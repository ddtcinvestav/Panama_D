module datapath #(parameter WIDTH = 32)(

		input clk,
		input rst,
		// Señales de control que vienen del módulo control
		input reg_write,
		input alu_src,
		input [1:0] alu_op,
		input mem_read,
		input mem_write,
		input mem_to_reg,
		input branch,
		output [6:0] opcode,
    	output alu_zero

    );

    // Señales internas de PC
    wire [WIDTH-1:0] pc_out;
    wire [WIDTH-1:0] instr;
    wire [WIDTH-1:0] pc_plus4;
    // Señales internas para regfile
    wire [WIDTH-1:0] rd1, rd2;
    wire [WIDTH-1:0] wd;
    // Señales internas para ALU e inmediatos
    wire [WIDTH-1:0] imm;
    wire [WIDTH-1:0] alu_b;        // salida del mux (rd2 o imm)
    wire [WIDTH-1:0] alu_result;
    wire [3:0] alu_ctrl;
    // Señales internas para dmem
    wire [WIDTH-1:0] dmem_rd;
    // Señales internas para branch
    wire [WIDTH-1:0] pc_branch;
    wire [WIDTH-1:0] next_pc;

    assign opcode = instr[6:0];


    // Instancia de PC
    pc #(WIDTH) PC(
	   .clk(clk),
	   .rst(rst),
	   .next_pc(next_pc),
	   .pc_out(pc_out)

	);

	// Instancia de IMEM
	imem #(WIDTH) IMEM(
		.addr(pc_out),
		.instr(instr)

	);

	// Instancia Sumador PC+4
	add32 #(WIDTH) ADD32(
		.a(pc_out),
    	.b(32'd4),
    	.sum(pc_plus4)
	);

	// Instancia Regfile
	regfile #(WIDTH) REGFILE(
		.clk(clk),
		.rst(rst),
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
        .funct7_30(instr[30]),
        .alu_control(alu_ctrl)
    );

     // Instancia DMEM
    dmem #(WIDTH) DMEM (
        .clk(clk),
        .we(mem_write),
        .re(mem_read),
        .addr(alu_result),
        .wd(rd2),
        .rd(dmem_rd)
    );

    // Instancia Mux final: selecciona entre ALU y memoria
    mux2 #(WIDTH) MUX_MEM_TO_REG (
        .a(alu_result),
        .b(dmem_rd),
        .sel(mem_to_reg),
        .y(wd)
    );

    // Instancia Sumador PC + inmediato (branch target)
    add32 #(WIDTH) ADD_BRANCH (
        .a(pc_out),
        .b(imm),
        .sum(pc_branch)
    );

    // Intancia Mux para decidir el próximo PC
    mux2 #(WIDTH) MUX_PC_SRC (
        .a(pc_plus4),
        .b(pc_branch),
        .sel(branch & alu_zero),
        .y(next_pc)
    );


endmodule
