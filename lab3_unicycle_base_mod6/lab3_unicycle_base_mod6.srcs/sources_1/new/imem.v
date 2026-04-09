module imem #(parameter WIDTH = 32)

(
    input [WIDTH-1:0] addr,
    output reg [WIDTH-1:0] instr

);
    reg [WIDTH-1:0] mem [0:63];

    initial begin
        $readmemh("program.hex", mem);
    end

    always @(*) begin
        instr = mem[addr[WIDTH-1:2]];
    end

endmodule
