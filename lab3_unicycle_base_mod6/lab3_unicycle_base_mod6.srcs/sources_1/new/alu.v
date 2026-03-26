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
            4'b0000: resultado = A & B;  // AND
            4'b0001: resultado = A | B;  // OR
            4'b0010: resultado = A + B;  // ADD
            4'b0110: resultado = A - B;  // SUB
            default: resultado = 32'b0;
        endcase
    end

    assign Z = (resultado == 0);
endmodule
