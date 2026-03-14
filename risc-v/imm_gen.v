module imm_gen #(parameter WIDTH = 32)
(
    input [WIDTH-1:0] instr,
    output reg [WIDTH-1:0] imm
);

    wire [6:0] opcode = instr[6:0];
    
    always @(*) begin
        
        case(opcode)
            // Bits usados: [31:20]
            7'b0000011: imm = {{20{instr[31]}}, instr[31:20]};// I-type LOAD
            // Bits usados: [31:25] (parte alta) y [11:7] (parte baja)
            7'b0100011: imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};  // S-type STORE
            // Bits usados: [31] (signo), [7] (bit 11), [30:25] (bits 10:5), [11:8] (bits 4:1)
            7'b1100011: imm = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};  // B-type BRANCH
            default:    imm = 32'b0;
    endcase
    
    end
    
    
endmodule
