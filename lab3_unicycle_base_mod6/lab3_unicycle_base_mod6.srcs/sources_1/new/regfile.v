module regfile #(parameter WIDTH = 32, parameter DEPTH = 32, parameter ADDR = 5)
(
    input clk,
    input rst,
    input we,             // Write Enable
    input [ADDR-1:0] rs1, // Indice registro 1
    input [ADDR-1:0] rs2, // Indice registro 2
    input [ADDR-1:0] rd,  // Indice registro destino
    input [WIDTH-1:0] wd, // Dato a escribir
    output  reg [WIDTH-1:0] rd1, //Salida registro 1
    output reg [WIDTH-1:0] rd2   //Salida registro 2

);

   reg [WIDTH-1:0] regs [0:DEPTH-1];

   integer i;

   always @(posedge clk) begin
        if(rst) begin
            for(i = 0; i < DEPTH; i = i + 1)
            regs[i] <= 32'b0;
        end else if (we && (rd != 0)) begin
            regs[rd] <= wd;
        end

   end


   always @(*) begin

        if(rs1 == 5'b0)
          rd1 = 32'b0;
        else if (we && (rd == rs1) && (rd != 0))
            rd1 = wd;
        else
            rd1 = regs[rs1];

   end

    always @(*) begin
        if (rs2 == 5'b0)
            rd2 = 32'b0;
        else if (we && (rd == rs2) && (rd !=0))
            rd2 = wd;
        else
            rd2 = regs[rs2];
   end



endmodule
