`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/18/2025 02:04:14 PM
// Design Name: 
// Module Name: basic_rv32m
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module basic_rv32m;

typedef struct {
  logic [11:0] csr_index;  
  logic [31:0] csr_result; 
} csr_t;

typedef struct {
  // INSN
  logic [31:0] pc;     
  logic [31:0] opcode;    
  string asm;        
  // X
  logic [4:0] xreg_index;
  logic [31:0] xreg_result;    
  // F
  logic [4:0] freg_index;
  logic [31:0] freg_result; 
  // V
  logic [4:0] vreg_index;
  logic [127:0] vreg_result;
  // CSR
  csr_t csr_list[8]; // Dynamic array
} instruction_t;
    

    // Associative array to store instructions by order
instruction_t instruction_array [0:68];
    
initial begin
  instruction_array[0]  = '{asm: "auipc   t0, 0x0"                 , pc: 'h00001000  , opcode: 'h00000297  , xreg_index: 'd5       , xreg_result: 'h00001000, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[1]  = '{asm: "addi    a1, t0, 32"              , pc: 'h00001004  , opcode: 'h02028593  , xreg_index: 'd11      , xreg_result: 'h00001020, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[2]  = '{asm: "csrr    a0, mhartid"             , pc: 'h00001008  , opcode: 'hf1402573  , xreg_index: 'd10      , xreg_result: 'h00000000, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[3]  = '{asm: "lw      t0, 24(t0)"              , pc: 'h0000100c  , opcode: 'h0182a283  , xreg_index: 'd5       , xreg_result: 'h80000000, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[4]  = '{asm: "jr      t0"                      , pc: 'h00001010  , opcode: 'h00028067  , xreg_index: 'dx       , xreg_result: 'hx       , freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[5]  = '{asm: "li      ra, 0"                   , pc: 'h80000000  , opcode: 'h00000093  , xreg_index: 'd1       , xreg_result: 'h00000000, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[6]  = '{asm: "lui     sp, 0x1234"              , pc: 'h80000004  , opcode: 'h01234137  , xreg_index: 'd2       , xreg_result: 'h01234000, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[7]  = '{asm: "addi    sp, sp, 1383"            , pc: 'h80000008  , opcode: 'h56710113  , xreg_index: 'd2       , xreg_result: 'h01234567, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[8]  = '{asm: "lui     gp, 0x5679"              , pc: 'h8000000c  , opcode: 'h056791b7  , xreg_index: 'd3       , xreg_result: 'h05679000, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[9]  = '{asm: "addi    gp, gp, -1621"           , pc: 'h80000010  , opcode: 'h9ab18193  , xreg_index: 'd3       , xreg_result: 'h056789ab, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[10] = '{asm: "mul     t1, sp, gp"              , pc: 'h80000014  , opcode: 'h02310333  , xreg_index: 'd6       , xreg_result: 'h92247acd, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[11] = '{asm: "add     ra, ra, t1"              , pc: 'h80000018  , opcode: 'h006080b3  , xreg_index: 'd1       , xreg_result: 'h92247acd, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[12] = '{asm: "mulh    t1, sp, gp"              , pc: 'h8000001c  , opcode: 'h02311333  , xreg_index: 'd6       , xreg_result: 'h00062628, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[13] = '{asm: "add     ra, ra, t1"              , pc: 'h80000020  , opcode: 'h006080b3  , xreg_index: 'd1       , xreg_result: 'h922aa0f5, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[14] = '{asm: "mulhsu  t1, sp, gp"              , pc: 'h80000024  , opcode: 'h02312333  , xreg_index: 'd6       , xreg_result: 'h00062628, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[15] = '{asm: "add     ra, ra, t1"              , pc: 'h80000028  , opcode: 'h006080b3  , xreg_index: 'd1       , xreg_result: 'h9230c71d, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[16] = '{asm: "mulhu   t1, sp, gp"              , pc: 'h8000002c  , opcode: 'h02313333  , xreg_index: 'd6       , xreg_result: 'h00062628, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[17] = '{asm: "add     ra, ra, t1"              , pc: 'h80000030  , opcode: 'h006080b3  , xreg_index: 'd1       , xreg_result: 'h9236ed45, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[18] = '{asm: "div     t1, gp, sp"              , pc: 'h80000034  , opcode: 'h0221c333  , xreg_index: 'd6       , xreg_result: 'h00000004, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[19] = '{asm: "add     ra, ra, t1"              , pc: 'h80000038  , opcode: 'h006080b3  , xreg_index: 'd1       , xreg_result: 'h9236ed49, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[20] = '{asm: "divu    t1, gp, sp"              , pc: 'h8000003c  , opcode: 'h0221d333  , xreg_index: 'd6       , xreg_result: 'h00000004, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[21] = '{asm: "add     ra, ra, t1"              , pc: 'h80000040  , opcode: 'h006080b3  , xreg_index: 'd1       , xreg_result: 'h9236ed4d, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[22] = '{asm: "rem     t1, gp, sp"              , pc: 'h80000044  , opcode: 'h0221e333  , xreg_index: 'd6       , xreg_result: 'h00da740f, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[23] = '{asm: "add     ra, ra, t1"              , pc: 'h80000048  , opcode: 'h006080b3  , xreg_index: 'd1       , xreg_result: 'h9311615c, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[24] = '{asm: "remu    t1, gp, sp"              , pc: 'h8000004c  , opcode: 'h0221f333  , xreg_index: 'd6       , xreg_result: 'h00da740f, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[25] = '{asm: "add     ra, ra, t1"              , pc: 'h80000050  , opcode: 'h006080b3  , xreg_index: 'd1       , xreg_result: 'h93ebd56b, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[26] = '{asm: "lui     sp, 0xfffe2"             , pc: 'h80000054  , opcode: 'hfffe2137  , xreg_index: 'd2       , xreg_result: 'hfffe2000, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[27] = '{asm: "addi    sp, sp, -576"            , pc: 'h80000058  , opcode: 'hdc010113  , xreg_index: 'd2       , xreg_result: 'hfffe1dc0, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[28] = '{asm: "lui     gp, 0x18"                , pc: 'h8000005c  , opcode: 'h000181b7  , xreg_index: 'd3       , xreg_result: 'h00018000, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[29] = '{asm: "addi    gp, gp, 461"             , pc: 'h80000060  , opcode: 'h1cd18193  , xreg_index: 'd3       , xreg_result: 'h000181cd, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[30] = '{asm: "mul     t1, sp, gp"              , pc: 'h80000064  , opcode: 'h02310333  , xreg_index: 'd6       , xreg_result: 'h293b92c0, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[31] = '{asm: "add     ra, ra, t1"              , pc: 'h80000068  , opcode: 'h006080b3  , xreg_index: 'd1       , xreg_result: 'hbd27682b, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[32] = '{asm: "mulh    t1, sp, gp"              , pc: 'h8000006c  , opcode: 'h02311333  , xreg_index: 'd6       , xreg_result: 'hfffffffd, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[33] = '{asm: "add     ra, ra, t1"              , pc: 'h80000070  , opcode: 'h006080b3  , xreg_index: 'd1       , xreg_result: 'hbd276828, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[34] = '{asm: "mulhsu  t1, sp, gp"              , pc: 'h80000074  , opcode: 'h02312333  , xreg_index: 'd6       , xreg_result: 'hfffffffd, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[35] = '{asm: "add     ra, ra, t1"              , pc: 'h80000078  , opcode: 'h006080b3  , xreg_index: 'd1       , xreg_result: 'hbd276825, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[36] = '{asm: "mulhu   t1, sp, gp"              , pc: 'h8000007c  , opcode: 'h02313333  , xreg_index: 'd6       , xreg_result: 'h000181ca, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[37] = '{asm: "add     ra, ra, t1"              , pc: 'h80000080  , opcode: 'h006080b3  , xreg_index: 'd1       , xreg_result: 'hbd28e9ef, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[38] = '{asm: "div     t1, sp, gp"              , pc: 'h80000084  , opcode: 'h02314333  , xreg_index: 'd6       , xreg_result: 'hffffffff, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[39] = '{asm: "add     ra, ra, t1"              , pc: 'h80000088  , opcode: 'h006080b3  , xreg_index: 'd1       , xreg_result: 'hbd28e9ee, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[40] = '{asm: "divu    t1, gp, sp"              , pc: 'h8000008c  , opcode: 'h0221d333  , xreg_index: 'd6       , xreg_result: 'h00000000, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[41] = '{asm: "add     ra, ra, t1"              , pc: 'h80000090  , opcode: 'h006080b3  , xreg_index: 'd1       , xreg_result: 'hbd28e9ee, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[42] = '{asm: "rem     t1, sp, gp"              , pc: 'h80000094  , opcode: 'h02316333  , xreg_index: 'd6       , xreg_result: 'hffff9f8d, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[43] = '{asm: "add     ra, ra, t1"              , pc: 'h80000098  , opcode: 'h006080b3  , xreg_index: 'd1       , xreg_result: 'hbd28897b, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[44] = '{asm: "remu    t1, gp, sp"              , pc: 'h8000009c  , opcode: 'h0221f333  , xreg_index: 'd6       , xreg_result: 'h000181cd, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[45] = '{asm: "add     ra, ra, t1"              , pc: 'h800000a0  , opcode: 'h006080b3  , xreg_index: 'd1       , xreg_result: 'hbd2a0b48, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[46] = '{asm: "li      sp, 37"                  , pc: 'h800000a4  , opcode: 'h02500113  , xreg_index: 'd2       , xreg_result: 'h00000025, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[47] = '{asm: "li      gp, 13"                  , pc: 'h800000a8  , opcode: 'h00d00193  , xreg_index: 'd3       , xreg_result: 'h0000000d, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[48] = '{asm: "mul     t1, sp, gp"              , pc: 'h800000ac  , opcode: 'h02310333  , xreg_index: 'd6       , xreg_result: 'h000001e1, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[49] = '{asm: "add     ra, ra, t1"              , pc: 'h800000b0  , opcode: 'h006080b3  , xreg_index: 'd1       , xreg_result: 'hbd2a0d29, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[50] = '{asm: "mulh    t1, sp, gp"              , pc: 'h800000b4  , opcode: 'h02311333  , xreg_index: 'd6       , xreg_result: 'h00000000, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[51] = '{asm: "add     ra, ra, t1"              , pc: 'h800000b8  , opcode: 'h006080b3  , xreg_index: 'd1       , xreg_result: 'hbd2a0d29, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[52] = '{asm: "mulhsu  t1, sp, gp"              , pc: 'h800000bc  , opcode: 'h02312333  , xreg_index: 'd6       , xreg_result: 'h00000000, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[53] = '{asm: "add     ra, ra, t1"              , pc: 'h800000c0  , opcode: 'h006080b3  , xreg_index: 'd1       , xreg_result: 'hbd2a0d29, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[54] = '{asm: "mulhu   t1, sp, gp"              , pc: 'h800000c4  , opcode: 'h02313333  , xreg_index: 'd6       , xreg_result: 'h00000000, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[55] = '{asm: "add     ra, ra, t1"              , pc: 'h800000c8  , opcode: 'h006080b3  , xreg_index: 'd1       , xreg_result: 'hbd2a0d29, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[56] = '{asm: "div     t1, sp, gp"              , pc: 'h800000cc  , opcode: 'h02314333  , xreg_index: 'd6       , xreg_result: 'h00000002, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[57] = '{asm: "add     ra, ra, t1"              , pc: 'h800000d0  , opcode: 'h006080b3  , xreg_index: 'd1       , xreg_result: 'hbd2a0d2b, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[58] = '{asm: "divu    t1, sp, gp"              , pc: 'h800000d4  , opcode: 'h02315333  , xreg_index: 'd6       , xreg_result: 'h00000002, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[59] = '{asm: "add     ra, ra, t1"              , pc: 'h800000d8  , opcode: 'h006080b3  , xreg_index: 'd1       , xreg_result: 'hbd2a0d2d, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[60] = '{asm: "rem     t1, sp, gp"              , pc: 'h800000dc  , opcode: 'h02316333  , xreg_index: 'd6       , xreg_result: 'h0000000b, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[61] = '{asm: "add     ra, ra, t1"              , pc: 'h800000e0  , opcode: 'h006080b3  , xreg_index: 'd1       , xreg_result: 'hbd2a0d38, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[62] = '{asm: "remu    t1, sp, gp"              , pc: 'h800000e4  , opcode: 'h02317333  , xreg_index: 'd6       , xreg_result: 'h0000000b, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[63] = '{asm: "add     ra, ra, t1"              , pc: 'h800000e8  , opcode: 'h006080b3  , xreg_index: 'd1       , xreg_result: 'hbd2a0d43, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[64] = '{asm: "li      t0, 1"                   , pc: 'h800000ec  , opcode: 'h00100293  , xreg_index: 'd5       , xreg_result: 'h00000001, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[65] = '{asm: "auipc   t1, 0x0"                 , pc: 'h800000f0  , opcode: 'h00000317  , xreg_index: 'd6       , xreg_result: 'h800000f0, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[66] = '{asm: "addi    t1, t1, 16"              , pc: 'h800000f4  , opcode: 'h01030313  , xreg_index: 'd6       , xreg_result: 'h80000100, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[67] = '{asm: "sw      t0, 0(t1)"               , pc: 'h800000f8  , opcode: 'h00532023  , xreg_index: 'dx       , xreg_result: 'hx       , freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[68] = '{asm: "j       pc + 0x0"                , pc: 'h800000fc  , opcode: 'h0000006f  , xreg_index: 'dx       , xreg_result: 'hx       , freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
end

endmodule
