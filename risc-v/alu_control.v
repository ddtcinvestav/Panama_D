module alu_control(
        
        input [1:0] alu_op,
        input [2:0] funct3,
        input funct7_30,
        output reg [3:0] alu_control
    );
    
    always @(*) begin
        case (alu_op)
            2'b00: alu_control = 4'b0010;  
            2'b01: alu_control = 4'b0110;  
            2'b10: begin                 // R-type: mira funct3/funct7
                case (funct3)
                    3'b000: 
                        if (funct7_30) 
                            alu_control = 4'b0110;  // SUB
                        else         
                            alu_control = 4'b0010;  // ADD
                            
                    3'b111: alu_control = 4'b0000; // AND
                    
                    3'b110: alu_control = 4'b0001; // OR
                    
                    default: alu_control = 4'b0;
                endcase
            end
            default: alu_control = 4'b0;
        endcase
    end
endmodule
