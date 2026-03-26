`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/18/2025 12:44:32 PM
// Design Name: 
// Module Name: basic_rv32m_corner
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


module basic_rv32m_corner;

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
instruction_t instruction_array [0:30];
    
initial begin
  instruction_array[0]  = '{asm: "auipc   t0, 0x0"                 , pc: 'h00001000  , opcode: 'h00000297  , xreg_index: 'd5       , xreg_result: 'h00001000, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[1]  = '{asm: "addi    a1, t0, 32"              , pc: 'h00001004  , opcode: 'h02028593  , xreg_index: 'd11      , xreg_result: 'h00001020, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[2]  = '{asm: "csrr    a0, mhartid"             , pc: 'h00001008  , opcode: 'hf1402573  , xreg_index: 'd10      , xreg_result: 'h00000000, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[3]  = '{asm: "lw      t0, 24(t0)"              , pc: 'h0000100c  , opcode: 'h0182a283  , xreg_index: 'd5       , xreg_result: 'h80000000, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[4]  = '{asm: "jr      t0"                      , pc: 'h00001010  , opcode: 'h00028067  , xreg_index: 'dx       , xreg_result: 'hx       , freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[5]  = '{asm: "li      t0, 0"                   , pc: 'h80000000  , opcode: 'h00000293  , xreg_index: 'd5       , xreg_result: 'h00000000, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[6]  = '{asm: "li      t1, -1"                  , pc: 'h80000004  , opcode: 'hfff00313  , xreg_index: 'd6       , xreg_result: 'hffffffff, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[7]  = '{asm: "lui     t2, 0x80000"             , pc: 'h80000008  , opcode: 'h800003b7  , xreg_index: 'd7       , xreg_result: 'h80000000, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[8]  = '{asm: "lui     t3, 0x3"                 , pc: 'h8000000c  , opcode: 'h00003e37  , xreg_index: 'd28      , xreg_result: 'h00003000, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[9]  = '{asm: "addi    t3, t3, 57"              , pc: 'h80000010  , opcode: 'h039e0e13  , xreg_index: 'd28      , xreg_result: 'h00003039, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[10] = '{asm: "lui     t4, 0x2"                 , pc: 'h80000014  , opcode: 'h00002eb7  , xreg_index: 'd29      , xreg_result: 'h00002000, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[11] = '{asm: "addi    t4, t4, -1403"           , pc: 'h80000018  , opcode: 'ha85e8e93  , xreg_index: 'd29      , xreg_result: 'h00001a85, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[12] = '{asm: "lui     t5, 0x80000"             , pc: 'h8000001c  , opcode: 'h80000f37  , xreg_index: 'd30      , xreg_result: 'h80000000, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[13] = '{asm: "addi    t5, t5, -1"              , pc: 'h80000020  , opcode: 'hffff0f13  , xreg_index: 'd30      , xreg_result: 'h7fffffff, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[14] = '{asm: "mul     t6, t3, t4"              , pc: 'h80000024  , opcode: 'h03de0fb3  , xreg_index: 'd31      , xreg_result: 'h04fed79d, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[15] = '{asm: "mulh    t6, t2, t4"              , pc: 'h80000028  , opcode: 'h03d39fb3  , xreg_index: 'd31      , xreg_result: 'hfffff2bd, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[16] = '{asm: "mulhsu  t6, t2, t4"              , pc: 'h8000002c  , opcode: 'h03d3afb3  , xreg_index: 'd31      , xreg_result: 'hfffff2bd, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[17] = '{asm: "mulhu   t6, t1, t4"              , pc: 'h80000030  , opcode: 'h03d33fb3  , xreg_index: 'd31      , xreg_result: 'h00001a84, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[18] = '{asm: "div     t6, t2, t1"              , pc: 'h80000034  , opcode: 'h0263cfb3  , xreg_index: 'd31      , xreg_result: 'h80000000, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[19] = '{asm: "divu    t6, t5, t4"              , pc: 'h80000038  , opcode: 'h03df5fb3  , xreg_index: 'd31      , xreg_result: 'h0004d39e, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[20] = '{asm: "rem     t6, t2, t1"              , pc: 'h8000003c  , opcode: 'h0263efb3  , xreg_index: 'd31      , xreg_result: 'h00000000, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[21] = '{asm: "remu    t6, t5, t4"              , pc: 'h80000040  , opcode: 'h03df7fb3  , xreg_index: 'd31      , xreg_result: 'h000002e9, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[22] = '{asm: "div     t6, t1, t0"              , pc: 'h80000044  , opcode: 'h02534fb3  , xreg_index: 'd31      , xreg_result: 'hffffffff, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[23] = '{asm: "divu    t6, t5, t0"              , pc: 'h80000048  , opcode: 'h025f5fb3  , xreg_index: 'd31      , xreg_result: 'hffffffff, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[24] = '{asm: "rem     t6, t1, t0"              , pc: 'h8000004c  , opcode: 'h02536fb3  , xreg_index: 'd31      , xreg_result: 'hffffffff, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[25] = '{asm: "remu    t6, t5, t0"              , pc: 'h80000050  , opcode: 'h025f7fb3  , xreg_index: 'd31      , xreg_result: 'h7fffffff, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[26] = '{asm: "li      t0, 1"                   , pc: 'h80000054  , opcode: 'h00100293  , xreg_index: 'd5       , xreg_result: 'h00000001, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[27] = '{asm: "auipc   t1, 0x0"                 , pc: 'h80000058  , opcode: 'h00000317  , xreg_index: 'd6       , xreg_result: 'h80000058, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[28] = '{asm: "addi    t1, t1, 40"              , pc: 'h8000005c  , opcode: 'h02830313  , xreg_index: 'd6       , xreg_result: 'h80000080, freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[29] = '{asm: "sw      t0, 0(t1)"               , pc: 'h80000060  , opcode: 'h00532023  , xreg_index: 'dx       , xreg_result: 'hx       , freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
  instruction_array[30] = '{asm: "j       pc + 0x0"                , pc: 'h80000064  , opcode: 'h0000006f  , xreg_index: 'dx       , xreg_result: 'hx       , freg_index: 'dx       , freg_result: 'hx       , vreg_index: 'dx       , vreg_result: 'hx       , csr_list: '{default: 0}};
end


endmodule
