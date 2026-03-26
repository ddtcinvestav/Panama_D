module control (
    input [6:0] opcode,         // instr[6:0]
    output reg reg_write,       // Escribe register file
    output reg mem_read,        // Lee data memory
    output reg mem_write,       // Escribe data memory
    output reg branch,          // Branch enable
    output reg mem_to_reg,      // ALU(0) o MEM(1) -> regfile
    output reg alu_src,         // Reg(0) o Imm(1) -> ALU
    output reg [1:0]  alu_op,    // ALU control mode
    output reg valid			//Señal de Valid añadida
);
    always @(*) begin
        case (opcode)
            7'b0110011: begin           // R-type (add,sub,and,or)
                reg_write  = 1'b1;
                mem_read   = 1'b0;
                mem_write  = 1'b0;
                branch     = 1'b0;
                mem_to_reg = 1'b0;      
                alu_src    = 1'b0;      
                alu_op     = 2'b10;
                valid 	   = 1'b1;
            end
            7'b0000011: begin           
                reg_write  = 1'b1;
                mem_read   = 1'b1;
                mem_write  = 1'b0;
                branch     = 1'b0;
                mem_to_reg = 1'b1;      
                alu_src    = 1'b1;      
                alu_op     = 2'b00;
                valid 	   = 1'b1;
            end
            7'b0100011: begin           
                reg_write  = 1'b0;
                mem_read   = 1'b0;
                mem_write  = 1'b1;
                branch     = 1'b0;
                mem_to_reg = 1'bX;      
                alu_src    = 1'b1;      
                alu_op     = 2'b00;
                valid 	   = 1'b1;
            end
            7'b1100011: begin          
                reg_write  = 1'b0;
                mem_read   = 1'b0;
                mem_write  = 1'b0;
                branch     = 1'b1;
                mem_to_reg = 1'bX;      
                alu_src    = 1'b0;      
                alu_op     = 2'b01;
                valid 	   = 1'b1;
            end
            default: begin               
                reg_write  = 1'b0;
                mem_read   = 1'b0;
                mem_write  = 1'b0;
                branch     = 1'b0;
                mem_to_reg = 1'b0;
                alu_src    = 1'b0;
                alu_op     = 2'b00;
                valid 	   = 1'b0;
            end
        endcase
    end
endmodule