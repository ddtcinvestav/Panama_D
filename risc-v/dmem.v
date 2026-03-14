module dmem #(parameter WIDTH = 32)
(
    input clk,
    input we,
    input re,
    input [WIDTH-1:0] addr,
    input [WIDTH-1:0] wd,
    output reg [WIDTH-1:0] rd   
        
);

    reg [WIDTH-1:0] memory [0:1023];
    
    
    
    // Escritura
    always @(posedge clk) begin
    
        if (we)
            memory[addr[WIDTH-1:2]] <= wd;
    end
    
    // Lectura
    always @(*) begin
    
        if(re)
            rd = memory[addr[WIDTH-1:2]];
        else
            rd = 32'b0;    
    
    end
    
endmodule
