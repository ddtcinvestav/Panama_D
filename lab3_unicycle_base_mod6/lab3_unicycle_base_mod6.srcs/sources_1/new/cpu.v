
module cpu #(parameter WIDTH = 32, parameter RESET_ADDR = 32'h00000000)(

		input clk,
		input arstn, //Cambio el RST a Activo bajo
		
		//ROM externa
		output wire [WIDTH-1:0] inst_mem_r_addr,
		input wire[WIDTH-1:0] inst_memory_in,
		//RAM externa
		output wire data_memory_write,
		output wire data_memory_read,
		output wire [WIDTH-1:0] data_address_out,
		output wire [WIDTH-1:0] data_memory_write_data,
		output wire [WIDTH-1:0] data_memory_in,
		//Valid
		output wire valid
    );
    
    	wire [6:0] opcode;
		wire alu_zero;
		wire reg_write, alu_src, mem_read, mem_write, mem_to_reg, branch;
		wire [1:0] alu_op;
		
		
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
			.reg_write(reg_write),
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
			.rd2(rd2_int) 
    	);
    	
    	//Instancia Control
    	control CONTROL (
			.opcode(opcode),
			.reg_write(reg_write),
			.alu_src(alu_src),
			.mem_to_reg(mem_to_reg),
			.mem_read(mem_read),
			.mem_write(mem_write),
			.branch(branch),
			.alu_op(alu_op),
			.valid(valid)
    	);
		
endmodule
