module alu_control(
          input [1:0] alu_op,
          input [2:0] funct3,
          input funct7_30,
          input funct7_0, //Añadido para instrucciones M
          output reg [3:0] alu_control
      );

      always @(*) begin
          case (alu_op)
              2'b00: alu_control = 4'b0010;
              2'b01: alu_control = 4'b0110;
              2'b10: begin
                  if (funct7_0) begin
                      case (funct3)
                          3'b000: alu_control = 4'b1010; // MUL
                          default: alu_control = 4'b0010;
                      endcase
                  end else begin
                      case (funct3)
                          3'b000:
                              if (funct7_30)
                                  alu_control = 4'b0110;  // SUB
                              else
                                  alu_control = 4'b0010;  // ADD
                          3'b111: alu_control = 4'b0000; // AND
                          3'b110: alu_control = 4'b0001; // OR
                          3'b100: alu_control = 4'b0011; // XOR
                          3'b001: alu_control = 4'b0100; // SLL
                          3'b101:
                              if (funct7_30)
                                  alu_control = 4'b0111; // SRA
                              else
                                  alu_control = 4'b0101; // SRL
                          3'b010: alu_control = 4'b1000; // SLT
                          3'b011: alu_control = 4'b1001; // SLTU
                          default: alu_control = 4'b0;
                      endcase
                  end
              end
              default: alu_control = 4'b0;
          endcase
      end
  endmodule