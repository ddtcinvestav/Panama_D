package rv_enums;

typedef enum logic [6:0] {
    LOAD           = 7'h03, LOAD_FP        = 7'h07, CUSTOM_0       = 7'h0b, MISC_MEM       = 7'h0f,
    OP_IMM         = 7'h13, AUIPC          = 7'h17, OP_IMM_32      = 7'h1b, INST_48B_1     = 7'h1f,
    STORE          = 7'h23, STORE_FP       = 7'h27, CUSTOM_1       = 7'h2b, AMO            = 7'h2f,
    OP             = 7'h33, LUI            = 7'h37, OP_32          = 7'h3b, INST_64B_1     = 7'h3f,
    MADD           = 7'h43, MSUB           = 7'h47, NMSUB          = 7'h4b, NMADD          = 7'h4f,
    OP_FP          = 7'h53, RESERVED_1     = 7'h57, CUSTOM2RV128   = 7'h5b, INST_48B_2     = 7'h5f,
    BRANCH         = 7'h63, JALR           = 7'h67, RESERVED_2     = 7'h6b, JAL            = 7'h6f,
    SYSTEM         = 7'h73, RESERVED_3     = 7'h77, CUSTOM_3RV128  = 7'h7b, INST_80B_1     = 7'h7f
} isl_opcode_t;

endpackage