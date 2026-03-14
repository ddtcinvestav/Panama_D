module cpu #(parameter WIDTH = 32)(

		input clk,
		input rst
    );
    
    	wire [6:0] opcode;
		wire alu_zero;
		wire reg_write, alu_src, mem_read, mem_write, mem_to_reg, branch;
		wire [1:0] alu_op;
		
		//Instancia DataPath
		datapath #(WIDTH) DATAPATH (
			.clk(clk),
			.rst(rst),
			.reg_write(reg_write),
			.alu_src(alu_src),
			.alu_op(alu_op),
			.mem_read(mem_read),
			.mem_write(mem_write),
			.mem_to_reg(mem_to_reg),
			.branch(branch),
			.opcode(opcode),  
			.alu_zero(alu_zero) 
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
			.alu_op(alu_op)
    	);
		
endmodule
