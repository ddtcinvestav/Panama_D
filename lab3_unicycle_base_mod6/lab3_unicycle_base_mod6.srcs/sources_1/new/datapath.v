
module datapath #(parameter WIDTH = 32, parameter RESET_ADDR = 32'h00000000)(

		input clk,
		input arstn, //Cambio el RST a Activo bajo
		// Señales de control que vienen del módulo control
		input reg_write,
		input alu_src,
		input [1:0] alu_op,
		input mem_read,
		input mem_write,
		input [1:0] mem_to_reg,
		input branch,
        input jump, // Nueva señal de control para saltos
		
		output [6:0] opcode,
    	output alu_zero,

        output [WIDTH-1:0] WBResult, // Salida del mux final para escribir en el regfile, se añade para el testbench
    	
    	//Estas señales pasan de ser wires internos a entradas y salidas del modulo
    	input [WIDTH-1:0] instr,
    	input [WIDTH-1:0] dmem_rd,
    	output [WIDTH-1:0] pc_out,
    	output [WIDTH-1:0] alu_result,
    	output [WIDTH-1:0] rd2

    );
    
    // Señales internas de PC
    //wire [WIDTH-1:0] pc_out;
    //wire [WIDTH-1:0] instr;
    wire [WIDTH-1:0] pc_plus4;
    // Señales internas para regfile
    wire [WIDTH-1:0] rd1;
    //wire [WIDTH-1:0] rd2;
    wire [WIDTH-1:0] wd;
    // Señales internas para ALU e inmediatos
    wire [WIDTH-1:0] imm;
    wire [WIDTH-1:0] alu_b;        // salida del mux (rd2 o imm)
    //wire [WIDTH-1:0] alu_result;
    wire [3:0] alu_ctrl;
    // Señales internas para dmem
    //wire [WIDTH-1:0] dmem_rd;
    // Señales internas para branch
    wire [WIDTH-1:0] pc_branch;
    wire [WIDTH-1:0] next_pc;

    //Se añaden nuevos para manejo de las nuevas instrucciones
    wire [WIDTH-1:0] mux_wb_1;
    wire [WIDTH-1:0] mux_wb_2;
    wire [WIDTH-1:0] mux_wb_3;
    wire auipc_sel = (opcode == 7'b0010111);
    
    
    wire jalr_sel = (opcode == 7'b1100111);          // 1 solo cuando es JALR
    wire pc_branch_sel = (branch & branch_taken) | (jump & ~jalr_sel); // branch o JAL (no JALR)
    wire [WIDTH-1:0] pc_stage1;
    
    reg [WIDTH-1:0] dmem_rd_ext;  // Añadido Dato de memoria con extension de signo/cero segun funct3 (lb, lh, lbu, lhu, lw 
    
    

    wire branch_taken; // Resultado de la condicion de branch

    //Se añaden nuevo para manejo de branch funct3
    reg branch_taken_reg;
    assign branch_taken = branch_taken_reg;
    
    assign opcode = instr[6:0];
    
    assign WBResult = wd; // Asignamos la salida del mux final a WBResult para el testbench.
    
    // Instancia de PC
    pc #(.WIDTH(WIDTH), .RESET_ADDR(RESET_ADDR)) PC(
	   .clk(clk),
	   .arstn(arstn),
	   .next_pc(next_pc),
	   .pc_out(pc_out)
        
	);
	
	/* Instancia de IMEM
	imem #(WIDTH) IMEM(
		.addr(pc_out),
		.instr(instr)

	);*/
	
	// Instancia Sumador PC+4
	add32 #(WIDTH) ADD32(
		.a(pc_out),
    	.b(32'd4),
    	.sum(pc_plus4)
	);
	
	// Instancia Regfile
	regfile #(WIDTH) REGFILE(
		.clk(clk),
		.arstn(arstn),
		.we(reg_write),          
        .rs1(instr[19:15]),      
        .rs2(instr[24:20]),      
        .rd(instr[11:7]),        
        .wd(wd),                
        .rd1(rd1),              
        .rd2(rd2)               
	
	);
	
	//Instancia imm
    imm_gen #(WIDTH) IMM_GEN (
        .instr(instr),
        .imm(imm)
    );

    // Instancia Mux para segundo operando del ALU
    mux2 #(WIDTH) MUX_ALU_SRC (
        .a(rd2),
        .b(imm),
        .sel(alu_src),   
        .y(alu_b)
    );

    // Instancia ALU
    alu #(WIDTH) ALU (
        .A(rd1),
        .B(alu_b),
        .seleccion(alu_ctrl),
        .resultado(alu_result),
        .Z(alu_zero)
    );

    // Instancia ALU_control
    alu_control ALU_CONTROL (
        .alu_op(alu_op),             
        .funct3(instr[14:12]),       
        .funct7_30(opcode == 'h33 ? instr[30]: 1'b0),
        .funct7_0(opcode == 7'h33 ? instr[25] : 1'b0), //Añadido conexion del nuevo puerto de alu_control       
        .alu_control(alu_ctrl)
    );
    
     /* Instancia DMEM
    dmem #(WIDTH) DMEM (
        .clk(clk),
        .we(mem_write),       
        .re(mem_read),        
        .addr(alu_result),    
        .wd(rd2),             
        .rd(dmem_rd)          
    );*/

    /*Instancia Mux final: selecciona entre ALU y memoria
    mux2 #(WIDTH) MUX_MEM_TO_REG (
        .a(alu_result),
        .b(dmem_rd),
        .sel(mem_to_reg),     
        .y(wd)                
    );*/



    // Mux nivel 1: ALU result vs dato de memoria
    mux2 #(WIDTH) MUX_WB1 (
        .a(alu_result),
        .b(dmem_rd_ext), //Añadido dato de memoria con extension segun funct3
        .sel(mem_to_reg[0]),
        .y(mux_wb_1)
    );

    // Mux nivel 2: resultado anterior vs PC+4
    mux2 #(WIDTH) MUX_WB2 (
        .a(mux_wb_1),
        .b(pc_plus4),
        .sel(mem_to_reg[1]),
        .y(mux_wb_2)
    );

    // Mux nivel 3: resultado anterior vs inmediato (LUI)
    mux2 #(WIDTH) MUX_WB3 (
        .a(mux_wb_2),
        .b(imm),
        .sel(mem_to_reg[1] & mem_to_reg[0]),
        .y(mux_wb_3)
    );

    mux2 #(WIDTH) MUX_WB4 (
        .a(mux_wb_3),
        .b(pc_branch),
        .sel(auipc_sel),
        .y(wd)
    );

    /*module top´
      input clk, arstn, valid´

      cpu )

      imem =

      dmem 
    endmodule*/




    
    // Instancia Sumador PC + inmediato (branch target)
    add32 #(WIDTH) ADD_BRANCH (
        .a(pc_out),
        .b(imm),
        .sum(pc_branch)
    );
    
    // Mux nivel 1: pc_plus4 vs pc_branch (para branches y JAL)
      mux2 #(WIDTH) MUX_PC1 (
          .a(pc_plus4),
          .b(pc_branch),
          .sel(pc_branch_sel),
          .y(pc_stage1)
      );

      // Mux nivel 2: resultado anterior vs alu_result (para JALR: salta a rd1+imm)
      mux2 #(WIDTH) MUX_PC2 (
          .a(pc_stage1),
          .b(alu_result),
          .sel(jalr_sel),
          .y(next_pc)
      );
    
    
    /* Intancia Mux para decidir el próximo PC
    mux2 #(WIDTH) MUX_PC_SRC (
        .a(pc_plus4),
        .b(pc_branch),
        .sel((branch & branch_taken) | jump),
        .y(next_pc)
    );*/
    
    
    

    // Añadido - Evaluacion de la condicion de branch segun funct3
     always @(*) begin
      case(instr[14:12])
          3'b000: branch_taken_reg = (rd1 == rd2);          // BEQ
          3'b001: branch_taken_reg = (rd1 != rd2);          // BNE
          3'b100: branch_taken_reg = ($signed(rd1) < $signed(rd2));   // BLT
          3'b101: branch_taken_reg = ($signed(rd1) >= $signed(rd2));  // BGE
          3'b110: branch_taken_reg = (rd1 < rd2);           // BLTU
          3'b111: branch_taken_reg = (rd1 >= rd2);          // BGEU
          default: branch_taken_reg = 1'b0;
      endcase
  	end
  	
		// Extraccion de byte/halfword/word de dmem segun funct3
	  always @(*) begin
		  case (instr[14:12])
			  3'b000: dmem_rd_ext = {{24{dmem_rd[7]}},  dmem_rd[7:0]};   // lb  - sign-extend byte
			  3'b001: dmem_rd_ext = {{16{dmem_rd[15]}}, dmem_rd[15:0]};  // lh  - sign-extend halfword
			  3'b010: dmem_rd_ext = dmem_rd;                              // lw  - palabra completa
			  3'b100: dmem_rd_ext = {24'h0, dmem_rd[7:0]};               // lbu - zero-extend byte
			  3'b101: dmem_rd_ext = {16'h0, dmem_rd[15:0]};              // lhu - zero-extend halfword
			  default: dmem_rd_ext = dmem_rd;
		  endcase
	  end
	
    
endmodule
