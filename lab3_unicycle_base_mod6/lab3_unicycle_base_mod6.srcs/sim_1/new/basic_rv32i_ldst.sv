`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/18/2025 06:40:15 PM
// Design Name: 
// Module Name: basic_rv32i_ldst
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


module basic_rv32i_ldst;

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
instruction_t instruction_array [0:23];
    
initial begin
  instruction_array[0]  = '{asm: "auipc   t0, 0x0"                 , pc: 'h00001000  , opcode: 'h00000297  , xreg_index: 'd5       , xreg_result: 'h00001000, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[1]  = '{asm: "addi    a1, t0, 32"              , pc: 'h00001004  , opcode: 'h02028593  , xreg_index: 'd11      , xreg_result: 'h00001020, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[2]  = '{asm: "csrr    a0, mhartid"             , pc: 'h00001008  , opcode: 'hf1402573  , xreg_index: 'd10      , xreg_result: 'h00000000, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[3]  = '{asm: "lw      t0, 24(t0)"              , pc: 'h0000100c  , opcode: 'h0182a283  , xreg_index: 'd5       , xreg_result: 'h80000000, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[4]  = '{asm: "jr      t0"                      , pc: 'h00001010  , opcode: 'h00028067  , xreg_index: 'dx       , xreg_result: 'hx       , freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[5]  = '{asm: "auipc   t0, 0x0"                 , pc: 'h80000000  , opcode: 'h00000297  , xreg_index: 'd5       , xreg_result: 'h80000000, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[6]  = '{asm: "addi    t0, t0, 208"             , pc: 'h80000004  , opcode: 'h0d028293  , xreg_index: 'd5       , xreg_result: 'h800000d0, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[7]  = '{asm: "li      t1, 127"                 , pc: 'h80000008  , opcode: 'h07f00313  , xreg_index: 'd6       , xreg_result: 'h0000007f, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[8]  = '{asm: "sb      t1, 0(t0)"               , pc: 'h8000000c  , opcode: 'h00628023  , xreg_index: 'dx       , xreg_result: 'hx       , freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[9]  = '{asm: "lb      t2, 0(t0)"               , pc: 'h80000010  , opcode: 'h00028383  , xreg_index: 'd7       , xreg_result: 'h0000007f, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[10] = '{asm: "lbu     s0, 0(t0)"               , pc: 'h80000014  , opcode: 'h0002c403  , xreg_index: 'd8       , xreg_result: 'h0000007f, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[11] = '{asm: "lui     t1, 0x1"                 , pc: 'h80000018  , opcode: 'h00001337  , xreg_index: 'd6       , xreg_result: 'h00001000, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[12] = '{asm: "addi    t1, t1, 564"             , pc: 'h8000001c  , opcode: 'h23430313  , xreg_index: 'd6       , xreg_result: 'h00001234, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[13] = '{asm: "sh      t1, 2(t0)"               , pc: 'h80000020  , opcode: 'h00629123  , xreg_index: 'dx       , xreg_result: 'hx       , freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[14] = '{asm: "lh      t2, 2(t0)"               , pc: 'h80000024  , opcode: 'h00229383  , xreg_index: 'd7       , xreg_result: 'h00001234, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[15] = '{asm: "lui     t1, 0x89abd"             , pc: 'h80000028  , opcode: 'h89abd337  , xreg_index: 'd6       , xreg_result: 'h89abd000, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[16] = '{asm: "addi    t1, t1, -529"            , pc: 'h8000002c  , opcode: 'hdef30313  , xreg_index: 'd6       , xreg_result: 'h89abcdef, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[17] = '{asm: "sw      t1, 4(t0)"               , pc: 'h80000030  , opcode: 'h0062a223  , xreg_index: 'dx       , xreg_result: 'hx       , freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[18] = '{asm: "lw      t2, 4(t0)"               , pc: 'h80000034  , opcode: 'h0042a383  , xreg_index: 'd7       , xreg_result: 'h89abcdef, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[19] = '{asm: "li      t0, 1"                   , pc: 'h80000038  , opcode: 'h00100293  , xreg_index: 'd5       , xreg_result: 'h00000001, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[20] = '{asm: "auipc   t1, 0x0"                 , pc: 'h8000003c  , opcode: 'h00000317  , xreg_index: 'd6       , xreg_result: 'h8000003c, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[21] = '{asm: "addi    t1, t1, 68"              , pc: 'h80000040  , opcode: 'h04430313  , xreg_index: 'd6       , xreg_result: 'h80000080, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[22] = '{asm: "sw      t0, 0(t1)"               , pc: 'h80000044  , opcode: 'h00532023  , xreg_index: 'dx       , xreg_result: 'hx       , freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[23] = '{asm: "j       pc + 0x0"                , pc: 'h80000048  , opcode: 'h0000006f  , xreg_index: 'dx       , xreg_result: 'hx       , freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
end

endmodule
