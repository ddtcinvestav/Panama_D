module pc #(parameter WIDTH = 32, parameter RESET_ADDR = 32'h00000000)
(
   input clk,
   input rst,
   input [WIDTH-1:0] next_pc,
   output reg [WIDTH-1:0] pc_out
        
);

   always @(posedge clk or posedge rst) begin
       if (rst)
           pc_out <= RESET_ADDR;
       else
           pc_out <= next_pc;
   end
   
endmodule
