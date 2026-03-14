module imem #(parameter WIDTH = 32)

(
    input [WIDTH-1:0] addr,
    output reg [WIDTH-1:0] instr

);
    always @(*) begin
        case (addr[WIDTH-1:2])
            // Formato R: {funct7, rs2, rs1, funct3, rd, opcode}
            0: instr = {7'b0000000, 5'd2, 5'd0, 3'b000, 5'd1, 7'b0110011};
            1: instr = {7'b0000000, 5'd2, 5'd0, 3'b000, 5'd3, 7'b0110011};
            2: instr = {12'd0, 5'd0, 3'b011, 5'd2, 7'b0000011}; 
            3: instr = {7'd0, 5'd3, 5'd0, 3'b011, 5'd0, 7'b0100011};
            default: instr = 32'b0;
        endcase
    end

    
endmodule
