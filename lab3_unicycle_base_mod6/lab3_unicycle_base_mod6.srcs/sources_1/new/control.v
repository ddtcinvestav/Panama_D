module control (
    input [6:0] opcode,         // instr[6:0]
    output reg reg_write,       // Escribe register file
    output reg mem_read,        // Lee data memory
    output reg mem_write,       // Escribe data memory
    output reg branch,          // Branch enable
    output reg [1:0] mem_to_reg,// Expandimos a 2 bits para manejar las demas instrucciones 00=ALU, 01=MEM, 10=PC+4, 11=IMM
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
                mem_to_reg = 2'b00;
                alu_src    = 1'b0;      
                alu_op     = 2'b10;
                valid 	   = 1'b1;
            end
            
            7'b0000011: begin          //LOAD (lw, lb, lh
                reg_write  = 1'b1;
                mem_read   = 1'b1;
                mem_write  = 1'b0;
                branch     = 1'b0;
                mem_to_reg = 2'b01; 
                alu_src    = 1'b1;      
                alu_op     = 2'b00;
                valid 	   = 1'b1;
            end

            7'b0100011: begin       //STORE (sw, sb, sh)        
                reg_write  = 1'b0;
                mem_read   = 1'b0;
                mem_write  = 1'b1;
                branch     = 1'b0;
                mem_to_reg = 2'bXX;   
                alu_src    = 1'b1;      
                alu_op     = 2'b00;
                valid 	   = 1'b1;
            end

            7'b1100011: begin       //BRANCH (beq, bne, blt, bge) 
                reg_write  = 1'b0;
                mem_read   = 1'b0;
                mem_write  = 1'b0;
                branch     = 1'b1;
                mem_to_reg = 2'bXX;
                alu_src    = 1'b0;      
                alu_op     = 2'b01;
                valid 	   = 1'b1;
            end
            
            7'b0010011: begin        //Instruccion nueva añadida OP-IMM
            reg_write  = 1'b1;
            mem_read   = 1'b0;
            mem_write  = 1'b0;
            branch     = 1'b0;
            mem_to_reg = 2'b00;     
            alu_src    = 1'b1;      
            alu_op     = 2'b10;     
            valid      = 1'b1;
            end
            
            7'b0110111: begin       // Instruccion nueva añadida LUI
                reg_write  = 1'b1;
                mem_read   = 1'b0;
                mem_write  = 1'b0;
                branch     = 1'b0;
                mem_to_reg = 2'b11;    
                alu_src    = 1'b0;
                alu_op     = 2'b00;
                valid      = 1'b1;
            end
            
            7'b0010111: begin       // Instruccion nueva añadida AUIPC
                reg_write  = 1'b1;
                mem_read   = 1'b0;
                mem_write  = 1'b0;
                branch     = 1'b0;
                mem_to_reg = 2'b00;    
                alu_src    = 1'b1;      
                alu_op     = 2'b00;     
                valid      = 1'b1;
            end
              
            7'b1101111: begin       // Instruccion nueva añadida JAL
                reg_write  = 1'b1;
                mem_read   = 1'b0;
                mem_write  = 1'b0;
                branch     = 1'b0;
                mem_to_reg = 2'b10;     
                alu_src    = 1'b1;      
                alu_op     = 2'b00;     
                valid      = 1'b1;
            end
            
            7'b1100111: begin       // Instruccion nueva añadida JALR
                reg_write  = 1'b1;
                mem_read   = 1'b0;
                mem_write  = 1'b0;
                branch     = 1'b0;
                mem_to_reg = 2'b10;     
                alu_src    = 1'b1;      
                alu_op     = 2'b00;     
                valid      = 1'b1;
            end
            default: begin               
                reg_write  = 1'b0;
                mem_read   = 1'b0;
                mem_write  = 1'b0;
                branch     = 1'b0;
                mem_to_reg = 2'b00;
                alu_src    = 1'b0;
                alu_op     = 2'b00;
                valid 	   = 1'b0;
            end
        endcase
    end
endmodule