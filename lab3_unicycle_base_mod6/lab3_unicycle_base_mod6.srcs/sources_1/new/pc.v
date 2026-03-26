module pc #(parameter WIDTH = 32)
(
   input clk,
   input rst,
   input [WIDTH-1:0] next_pc,
   output reg [WIDTH-1:0] pc_out

);

   always @(posedge clk or posedge rst) begin
       if (rst)
           pc_out <= 32'b0;
       else
           pc_out <= next_pc;
   end

endmodule
