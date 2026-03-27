module alu #(parameter WIDTH = 32) 
(
    input  [WIDTH-1:0] A,
    input  [WIDTH-1:0] B,
    input  [3:0]  seleccion,            
    output reg  [WIDTH-1:0] resultado,
    output Z                     
);
    always @(*) begin
        case(seleccion)
            4'b0000: resultado = A & B;                             // AND
            4'b0001: resultado = A | B;                             // OR  
            4'b0010: resultado = A + B;                             // ADD
            4'b0110: resultado = A - B;                             // SUB
            //Operaciones nuevas añadidas
            4'b0011: resultado = A ^ B;                             // XOR
            4'b0100: resultado = A << B[4:0];                       // SLL
            4'b0101: resultado = A >> B[4:0];                       // SRL
            4'b0111: resultado = $signed(A) >>> B[4:0];             // SRA
            4'b1000: resultado = ($signed(A) < $signed(B)) ? 1 : 0; // SLT
            4'b1001: resultado = (A < B) ? 1 : 0;                   // SLTU
            default: resultado = 32'b0;
        endcase
    end
    
    assign Z = (resultado == 0);       
endmodule
