
module cpu #(parameter WIDTH = 32, parameter RESET_ADDR = 32'h00000000)(

		input clk,
		input arstn, //Cambio el RST a Activo bajo.
		
		//ROM externa
		output wire [WIDTH-1:0] inst_mem_r_addr,
		input wire[WIDTH-1:0] inst_memory_in,
		//RAM externa
		output wire data_memory_write,
		output wire data_memory_read,
		output wire [WIDTH-1:0] data_address_out,
		output wire [WIDTH-1:0] data_memory_write_data,
		input wire [WIDTH-1:0] data_memory_in, //Correcion de output a input
		output wire [1:0] data_memory_write_strb, // Tamaño de escritura: 00=byte, 01=halfword, 10=word
		//Valid
		output wire valid
    );
    
    	wire [6:0] opcode;
		wire alu_zero;
	
		wire RegWrite, alu_src, mem_read, mem_write, branch;// Cambio de reg_wirte a RegWrite para mantener consistencia con t
  		wire [1:0] mem_to_reg; //Tamaño de actualizado de 1 bits a 2 bits para soportar byte, halfword y word
		wire [1:0] alu_op;

		//Se añadio esto para el tb
		wire [4:0] rd;
		assign rd = inst_memory_in[11:7]; // Extrae el campo rd de la instrucción

		//Extrae el tamaño de la operación de memoria
		assign data_memory_write_strb = inst_memory_in[13:12];
		

		wire [WIDTH-1:0] WBResult; // Salida del mux final para escribir en el regfile, se añade para el testbench
		
		wire [WIDTH-1:0] pc_out_int;
		wire [WIDTH-1:0] alu_result_int;
		wire [WIDTH-1:0] rd2_int;
		
		//Para mantener mis nombres
		assign inst_mem_r_addr         = pc_out_int;
		assign data_address_out        = alu_result_int;
		assign data_memory_write_data  = rd2_int;
		assign data_memory_write       = mem_write;
		assign data_memory_read        = mem_read;
		
		//Instancia DataPath
		datapath #(.WIDTH(WIDTH), .RESET_ADDR(RESET_ADDR)) DATAPATH (
			.clk(clk),
			.arstn(arstn), //Cambio instancia del reset
			.reg_write(RegWrite), //Cambio de reg_write a RegWrite para mantener consistencia con tb
			.alu_src(alu_src),
			.alu_op(alu_op),
			.mem_read(mem_read),
			.mem_write(mem_write),
			.mem_to_reg(mem_to_reg),
			.branch(branch),
			.opcode(opcode),  
			.alu_zero(alu_zero),
			//Nuevas instancias
			.instr(inst_memory_in),
			.dmem_rd(data_memory_in),
			.pc_out(pc_out_int),
			.alu_result(alu_result_int),
			.rd2(rd2_int),
			.WBResult(WBResult) // Conectamos la salida del mux final a WBResult para el testbench
    	);
    	
    	//Instancia Control
    	control CONTROL (
			.opcode(opcode),
			.reg_write(RegWrite), //Cambio de reg_write a RegWrite para mantener consistencia con tb
			.alu_src(alu_src),
			.mem_to_reg(mem_to_reg),
			.mem_read(mem_read),
			.mem_write(mem_write),
			.branch(branch),
			.alu_op(alu_op),
			.valid(valid)
    	);
		
endmodule
