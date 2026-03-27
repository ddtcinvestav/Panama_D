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

            //Añadidas nuevas
            // I-type OP-IMM (addi, ori, etc.)
            7'b0010011: imm = {{20{instr[31]}}, instr[31:20]};

            // J-type JAL
            7'b1101111: imm = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};

            // I-type JALR
            7'b1100111: imm = {{20{instr[31]}}, instr[31:20]};

            // U-type LUI y AUIPC
            7'b0110111: imm = {instr[31:12], 12'h000};  // LUI
            7'b0010111: imm = {instr[31:12], 12'h000};  // AUIPC


            default:    imm = 32'b0;
    endcase

    end


endmodule
