`timescale 1ns / 1ps
`default_nettype none
`define TEST c_mat_m

import rv_enums::*;

class RVID;
    // Data
    string asm;
    string rv_type;
    bit [4:0] rs1, rs2, rd;
    bit [2:0] funct3;
    bit [6:0] funct7;
    bit [5:0] funct6_v;
    bit [6:0] op;
    int imm;

    function new();
    endfunction

    function string get_type(input logic [6:0] op);
        string rv_type;
        case (op)
            LOAD, OP_IMM, JALR: rv_type = "I";
            STORE: rv_type = "S";
            BRANCH: rv_type = "B";
            AUIPC, LUI: rv_type = "U";
            JAL: rv_type = "J";
            OP: rv_type = "R";
            default: rv_type = "N/A";
        endcase
        return rv_type;
    endfunction

    function int get_imm(input logic [31:0] inst, input string rv_type);
        int imm; 
        case (rv_type)
            "I": imm = $signed({inst[31:20]});
            "S": imm = $signed({inst[31:25], inst[11:7]});
            "B": imm = $signed({inst[31], inst[7], inst[30:25], inst[11:8], 1'b0});
            "U": imm = $signed({inst[31:12]});
            "J": imm = $signed({inst[31], inst[19:12], inst[20], inst[30:21], 1'b0});
            default: imm = 0;
        endcase
        return imm;
    endfunction

    function void decode(input bit [31:0] inst);
        rs1 = inst[19:15];
        rs2 = inst[24:20];
        rd = inst[11:7];
        funct3 = inst[14:12];
        funct7 = inst[31:25];
        funct6_v = inst[31:26];
        op = inst[6:0];
        rv_type = get_type(op);
        imm = get_imm(inst, rv_type);
        asm = "Unknown Instruction!";
        case (op) 
            LOAD: begin
                case(funct3)
                    0: asm = $sformatf("lb x%0d, %0d(x%0d)", rd, imm, rs1);
                    1: asm = $sformatf("lh x%0d, %0d(x%0d)", rd, imm, rs1);
                    2: asm = $sformatf("lw x%0d, %0d(x%0d)", rd, imm, rs1);
                    4: asm = $sformatf("lbu x%0d, %0d(x%0d)", rd, imm, rs1);
                    5: asm = $sformatf("lhu x%0d, %0d(x%0d)", rd, imm, rs1);
                endcase
            end 
            OP_IMM: begin 
                case(funct3)
                    0: asm = $sformatf("addi x%0d, x%0d, %0d", rd, rs1, imm);
                    2: asm = $sformatf("slti x%0d, x%0d, %0d", rd, rs1, imm);
                    6: asm = $sformatf("ori x%0d, x%0d, %0d", rd, rs1, imm);
                    7: asm = $sformatf("andi x%0d, x%0d, %0d", rd, rs1, imm);
                endcase
            end
            AUIPC: begin // rv_type = "U"; 
                asm = $sformatf("auipc x%0d, %0d", rd, imm);
            end
            STORE: begin
                case(funct3)
                    0: asm = $sformatf("sb x%0d, %0d(x%0d)", rs2, imm, rs1);
                    1: asm = $sformatf("sh x%0d, %0d(x%0d)", rs2, imm, rs1);
                    2: asm = $sformatf("sw x%0d, %0d(x%0d)", rs2, imm, rs1);
                endcase
            end
            OP: begin
                  if (inst[25]) begin
                    case (funct3)
                      0: asm = $sformatf("mul x%0d, x%0d, x%0d", rd, rs1, rs2);
                      1: asm = $sformatf("mulh x%0d, x%0d, x%0d", rd, rs1, rs2);
                      2: asm = $sformatf("mulhsu x%0d, x%0d, x%0d", rd, rs1, rs2);
                      3: asm = $sformatf("mulhu x%0d, x%0d, x%0d", rd, rs1, rs2);
                      4: asm = $sformatf("div x%0d, x%0d, x%0d", rd, rs1, rs2);
                      5: asm = $sformatf("divu x%0d, x%0d, x%0d", rd, rs1, rs2);
                      6: asm = $sformatf("rem x%0d, x%0d, x%0d", rd, rs1, rs2);
                      7: asm = $sformatf("remu x%0d, x%0d, x%0d", rd, rs1, rs2);
                    endcase
                  end
                  else begin
                    case (funct3)
                      0: asm = (inst[30]) ? $sformatf("sub x%0d, x%0d, x%0d", rd, rs1, rs2) : $sformatf("add x%0d, x%0d, x%0d", rd, rs1, rs2);
                      1: asm = $sformatf("sll x%0d, x%0d, x%0d", rd, rs1, rs2);
                      2: asm = $sformatf("slt x%0d, x%0d, x%0d", rd, rs1, rs2);
                      3: asm = $sformatf("sltu x%0d, x%0d, x%0d", rd, rs1, rs2);
                      4: asm = $sformatf("xor x%0d, x%0d, x%0d", rd, rs1, rs2);
                      5: asm = (inst[30]) ? $sformatf("sra x%0d, x%0d, x%0d", rd, rs1, rs2) : $sformatf("srl x%0d, x%0d, x%0d", rd, rs1, rs2);
                      6: asm = $sformatf("or x%0d, x%0d, x%0d", rd, rs1, rs2);
                      7: asm = $sformatf("and x%0d, x%0d, x%0d", rd, rs1, rs2);
                    endcase         
                  end
            end
            LUI: begin // rv_type = "U"; 
                asm = $sformatf("lui x%0d, %0d", rd, imm);
            end
            BRANCH: begin
                case(funct3)
                    0: asm = $sformatf("beq x%0d, x%0d, %0d)", rs1, rs2, imm);
                    1: asm = $sformatf("bne x%0d, x%0d, %0d)", rs1, rs2, imm);
                    4: asm = $sformatf("blt x%0d, x%0d, %0d)", rs1, rs2, imm);
                    5: asm = $sformatf("bge x%0d, x%0d, %0d)", rs1, rs2, imm);
                    6: asm = $sformatf("bltu x%0d, x%0d, %0d)", rs1, rs2, imm);
                    7: asm = $sformatf("bgeu x%0d, x%0d, %0d)", rs1, rs2, imm);
                endcase
            end
            JAL: begin
                asm = $sformatf("jal x%0d, %0d", rd, imm);     
            end
            JALR: begin
                asm = $sformatf("jalr x%0d, x%0d, %0d", rd, rs1, imm);     
            end
        endcase
    endfunction
endclass

module tb;
    // Macros
	`define SVH_EXISTS
    `define STRINGIFY(x) `"x`"

	parameter string MEMORY_FILE = {`"`TEST`", ".mem"};
    `TEST ISS();
    
    // Parameters
    parameter ARCH = 32; 
    parameter RESET_ADDR = 'h80000000; 
    parameter GLOBAL_TIMEOUT = 1000000; 
    parameter MAX_NOTHING_RETIRED = 100; 
    parameter DRAIN_TIME = 10; 
    parameter CLK_PERIOD = 10; 
    parameter END_ON_N_MISMATCH = 1;

    // Data members
    longint cycle_counter;
    bit first_retire;
	longint first_retire_cycle;
	longint last_retire_cycle;
	real    ipc;

    bit comparation_on;
	bit current_is_mismatch;
    longint retired_instructions;
    longint compared_instructions;
    longint mismatched_instructions;
    longint mismatched_pc, matched_pc;
    longint mismatched_ldst, matched_ldst;
    longint mismatched_opcode, matched_opcode;
    longint mismatched_xgpr_index, matched_xgpr_index;
    longint mismatched_xgpr_data, matched_xgpr_data;
	bit timeout;
	bit nothing_retired;
	longint nothing_retired_counter;
	string test_status;

	longint instruction_array_comparation_index;
	longint instruction_array_comparation_index_start;
    // TB stimuli
    reg clk, arstn;
    wire valid;
    // RV Decoder
    RVID rvDecoder;
    initial rvDecoder = new();
    string rvDecodedInst;
    logic [0:(32*8)-1] rvLogicInst;
    string rvLocalStr;
    // Retire struct
    typedef struct {
        longint uid;
        bit retire_valid;
        bit retire_needs_wb;
        string retire_type;
        real fetch_time;
        longint fetch_cycle;
        logic [ARCH-1:0] retire_pc;
        logic [31:0] retire_inst;
        logic retire_xgpr_wb;
        logic [4:0] retire_xgpr_index;
        logic [ARCH-1:0] retire_xgpr_data;
    } retire_log_t;
    retire_log_t ret_entry;
    retire_log_t ret_array[longint];
    longint uid;
    longint retire_tail;
    longint fetch_head;
    bit wb_needed;

    // ROM signals
    logic [31:0] inst_memory_in;
    logic [ARCH-1:0] inst_mem_r_addr;
    // Instances
    SRAM #(.WIDTH(ARCH), .PRELOAD(1), .INIT_FILE(MEMORY_FILE), .READ_X_IF_UNINTIALIZED(0)) ROM (
        .clk(clk), .arstn(arstn),
        // W-PORT (UNUSED)
        // R-PORT
        .r_addr(inst_mem_r_addr), .r_en('1), .r_data(inst_memory_in[31:0])
    );
    
    // RAM signals
    logic [ARCH-1:0] data_address_out;
    // R-PORT
    logic data_memory_read;
    logic [63:0] data_memory_in;
    // W-PORT
    logic data_memory_write;
    logic [1:0] data_memory_write_strb;
    logic [63:0] data_memory_write_data;
    SRAM #(.WIDTH(ARCH), .PRELOAD(1), .INIT_FILE(MEMORY_FILE), .READ_X_IF_UNINTIALIZED(0)) RAM (
        .clk(clk), .arstn(arstn),
        // W-PORT
        .w_addr(data_address_out), .w_en(data_memory_write), .w_strb(data_memory_write_strb), .w_data(data_memory_write_data),
        // R-PORT
        .r_addr(data_address_out), .r_en(data_memory_read), .r_data(data_memory_in)
    );

    riscv_unicycle #(.ARCH(ARCH), .RESET_ADDR(RESET_ADDR)) DUT(
        .clk(clk),
        .arstn(arstn),
        .valid(valid),
        // ROM signals
        .inst_memory_in(inst_memory_in),
        .inst_mem_r_addr(inst_mem_r_addr),
        // RAM signals
        .data_address_out(data_address_out),
        // R-PORT
        .data_memory_read(data_memory_read),
        .data_memory_in(data_memory_in),
        // W-PORT
        .data_memory_write(data_memory_write),
        .data_memory_write_strb(data_memory_write_strb),
        .data_memory_write_data(data_memory_write_data)
    );

    // Functions/Tasks
    function bit wb_is_needed(input logic [31:0] inst);
        logic [6:0] opcode;
        bit wb;
        opcode = inst[6:0];
        case(opcode) 
            // For 32-bit
            OP:        wb = 1; // R-type
            OP_IMM:    wb = 1; // I-type
            LOAD:      wb = 1; // Loads
            LUI:       wb = 1; // LUI
            JAL:       wb = 1; // JAL
            JALR:      wb = 1; // JALR
            AUIPC:     wb = 1; // AUIPC
            // For 64-bit
            OP_32:     wb = 1; // 32-bit retrocompatible R-type
            OP_IMM_32: wb = 1; // 32-bit retrocompatible I-type
            default: wb = 0;
        endcase
        return wb;
    endfunction
    `ifdef SVH_EXISTS
	function void enable_comparation();
        comparation_on = 1;
		// Display the data
		for (int i = 0; i < $size(ISS.instruction_array); i++) begin
			if (ISS.instruction_array[i].pc === RESET_ADDR) begin
				instruction_array_comparation_index = i;
				break;
			end
		end
		instruction_array_comparation_index_start = instruction_array_comparation_index;
		$display("[INFO] STARTING COMPARATION AT pc=%0h (RESET_ADDR), INSTRUCTION_ARRAY_COMPARATION_INDEX=[SPK][#%0d]", ISS.instruction_array[instruction_array_comparation_index].pc, instruction_array_comparation_index);
	endfunction

	function automatic print_instruction_array_by_index(longint i);
		// Display the data
		$write("[SPK]");
		$write("[#%-6d]", i - instruction_array_comparation_index_start);
		$write("pc=0x%h, ", ISS.instruction_array[i].pc);
		$write("inst=0x%8h(%-24s), ", ISS.instruction_array[i].opcode, ISS.instruction_array[i].asm);
		$write("              ");
		$write("i_idx=%2s, ", (ISS.instruction_array[i].xreg_index === 'x) ? $sformatf("%s", "xx") : $sformatf("%d", ISS.instruction_array[i].xreg_index));
		$write("i_data=0x%h, ", ISS.instruction_array[i].xreg_result);
		$write("\n");
	endfunction
	task iss_comparation();
		void'(print_instruction_array_by_index(instruction_array_comparation_index));
		// PC COMPARATION
		if (ret_array[retire_tail].retire_pc !== ISS.instruction_array[instruction_array_comparation_index].pc) begin
			$error("[ERROR] MISMATCH WITH PC!");
			$display("    SPIKE: 0x%16h <!> DUT: 0x%16h",
					ISS.instruction_array[instruction_array_comparation_index].pc,
					ret_array[retire_tail].retire_pc);
			mismatched_pc++;
			current_is_mismatch = '1;
		end else begin
			matched_pc++;
		end
		// INST COMPARATION
		if (ret_array[retire_tail].retire_inst !== ISS.instruction_array[instruction_array_comparation_index].opcode) begin
			$error("[ERROR] MISMATCH WITH INST!");
			$display("    SPIKE: 0x%8h <!> DUT: 0x%8h",
					ISS.instruction_array[instruction_array_comparation_index].opcode,
					ret_array[retire_tail].retire_inst);
			mismatched_opcode++;
			current_is_mismatch = '1;
		end else begin
			matched_opcode++;
		end
		// GPR COMPARATION
		if (ret_array[retire_tail].retire_xgpr_wb || // If DUT said WB
            ISS.instruction_array[instruction_array_comparation_index].xreg_index !== 'x  // If SPIKE said WB
        ) begin
                if (ret_array[retire_tail].retire_xgpr_index !== ISS.instruction_array[instruction_array_comparation_index].xreg_index) begin
                    $display("[ERROR] MISMATCH WITH GPR INDEX [%0d] HAPPENED!", mismatched_xgpr_index);
					$display("    SPIKE: %0d <!> DUT: %0d",
							ISS.instruction_array[instruction_array_comparation_index].xreg_index,
							ret_array[retire_tail].retire_xgpr_index);
                    mismatched_xgpr_index++; 
                    current_is_mismatch = '1;
                end begin 
                    matched_xgpr_index++;
                end
                if (ret_array[retire_tail].retire_xgpr_data !== ISS.instruction_array[instruction_array_comparation_index].xreg_result) begin
                    $display("[ERROR] MISMATCH WITH GPR DATA [%0d] HAPPENED!", mismatched_xgpr_data);
					$display("    SPIKE: 0x%h <!> DUT: 0x%h",
							ISS.instruction_array[instruction_array_comparation_index].xreg_result,
							ret_array[retire_tail].retire_xgpr_data);
                    mismatched_xgpr_data++; 
                    current_is_mismatch = '1;
                end begin 
                    matched_xgpr_data++;
                end
		end
        if (current_is_mismatch) begin
            mismatched_instructions++;
        end

		compared_instructions++;
		instruction_array_comparation_index++;

	endtask
    `endif
    
	task eot();
        if (timeout) begin
            test_status = "TIMEOUT";
	    end else if ((|mismatched_instructions) || (|mismatched_opcode) || (|mismatched_pc) || (|mismatched_xgpr_data) || (|mismatched_xgpr_index) || timeout || nothing_retired) begin
            test_status = "FAILED";
        end else begin
            test_status = "PASSED";
        end
		void'(rvDecoder.decode(ret_array[retire_tail].retire_inst));
		rvDecodedInst = rvDecoder.asm;
		ipc = real'(retired_instructions / real'(last_retire_cycle - first_retire_cycle + 1));
		$display("=====================================================================================================================================================================================");
		$display("[TB] REACHED EOT CONDITION ... SIM SHOULD FINISH SHORTLY");
        $display("[TB] ========== CONFIG ========== ");
        $display("[TB] test_mem_path: %s", MEMORY_FILE);
        $display("[TB] RESET_ADDR: 0x%-h", RESET_ADDR);
        $display("[TB] GLOBAL_TIMEOUT: %-d", GLOBAL_TIMEOUT);
        $display("[TB] MAX_NOTHING_RETIRED: %-d", MAX_NOTHING_RETIRED);
        $display("[TB] END_ON_N_MISMATCH: %-d", END_ON_N_MISMATCH);
        $display("[TB] DRAIN_TIME: %-d", DRAIN_TIME);
        $display("[TB] ========== EOT ========== ");
        $display("[TB] cycles: %0d (%0d->%0d)", cycle_counter, first_retire_cycle, last_retire_cycle);
        $display("[TB] last pc: %0h", ret_array[retire_tail].retire_pc);
        $display("[TB] last inst: 0x%8h(%-24s)", ret_array[retire_tail].retire_inst, rvDecodedInst);
        $display("[TB] IPC: %0f", ipc);
        $display("[TB] CPI: %0f", 1/ipc);
        $display("[TB] compared instructions: %0d", compared_instructions);
        $display("[TB] mismatched instructions: %0d", mismatched_instructions);
        $display("[TB] pc (match/mismatch): (%0d,%0d)", matched_pc, mismatched_pc);
        $display("[TB] opcode (match/mismatch): (%0d,%0d)", matched_opcode, mismatched_opcode);
        $display("[TB] gpr_index (match/mismatch): (%0d,%0d)", matched_xgpr_index, mismatched_xgpr_index);
        $display("[TB] gpr_data (match/mismatch): (%0d,%0d)", matched_xgpr_data, mismatched_xgpr_data);
        $display("[TB] ");
        $display("[TB] test_status: %s", test_status);
        $display("[TB] ");
        if (test_status == "FAILED") begin
            `ifdef SVH_EXISTS
			$write("[TB] SPIKE NEXT INSTRUCTION, ");
			$write("\n");
			// Display the data
			$write("[SPK]");
			$write("[#%-6d]", instruction_array_comparation_index);
			$write("pc=0x%h, ", ISS.instruction_array[instruction_array_comparation_index].pc);
			$write("inst=0x%8h(%-24s), ", ISS.instruction_array[instruction_array_comparation_index].opcode, ISS.instruction_array[instruction_array_comparation_index].asm);
			$write("              ");
			$write("i_idx=%2s, ", (ISS.instruction_array[instruction_array_comparation_index].xreg_index === 'x) ? $sformatf("%s", "xx") : $sformatf("%d", ISS.instruction_array[instruction_array_comparation_index].xreg_index));
			$write("i_data=0x%h, ", ISS.instruction_array[instruction_array_comparation_index].xreg_result);
			$write("\n");
            `endif
        end
		$display("=====================================================================================================================================================================================");
		// DRAIN TIME
        //RAM.sram_dump();
		$display("Drain time of %d started", DRAIN_TIME);
            if (MEMORY_FILE == "c_hello_world.mem") begin		
                $write("Buffer content: ");
                for (int i = 0; i < 256; i++) begin
                    automatic logic [7:0] ch = RAM.sram_data['h80002000 + i];
                    if (ch === 8'h00 || ch === 'x) break; // Stop at null terminator
                    $write("%c", ch);       // Print as character
                end
                $write("\n"); // Newline after buffer content
			end else if (MEMORY_FILE == "c_mat_m.mem") begin
                automatic logic [7:0] pass = RAM.sram_data['h80002000];
                if (pass) begin
                    $display("MAT OK!");
                end else begin
                    $display("MAT NOT OK!");
                end
			end
        $finish;
		// END PRINT
    endtask
    // Processes

    // Tracer: Retired instructions
    always @(posedge clk or negedge arstn) begin
        if (!arstn) begin
        end else begin
            if(valid) begin
                if (!first_retire) begin
                    first_retire_cycle = cycle_counter;
                    first_retire = 1;
                end
                // Decode the instruction
                rvLogicInst = '0;
                void'(rvDecoder.decode(inst_memory_in));
                rvDecodedInst = rvDecoder.asm;
                rvLocalStr = rvDecodedInst;
                for (int j = 0; j < rvLocalStr.len(); j++) begin
                    rvLogicInst[8*(j+1)-1 -: 8] = rvLocalStr[j];
                end
                // Save the current retire into the retire array
                ret_entry.uid = uid;
                ret_entry.retire_pc = inst_mem_r_addr;
                ret_entry.retire_inst = inst_memory_in;
                ret_entry.fetch_time = $time;
                ret_entry.fetch_cycle = cycle_counter;
                wb_needed = wb_is_needed(inst_memory_in);
                ret_entry.retire_needs_wb = wb_needed;
                if(wb_needed && DUT.rd != 0) begin
                    if(DUT.RegWrite) begin
                        ret_entry.retire_valid = 1;
                        ret_entry.retire_xgpr_wb = DUT.RegWrite;
                        ret_entry.retire_xgpr_index = DUT.rd;
                        ret_entry.retire_xgpr_data = DUT.WBResult;
                    end 
                end else begin
                    ret_entry.retire_valid = 1;
                    ret_entry.retire_xgpr_wb = 0;
                    ret_entry.retire_xgpr_index = 0;  
                    ret_entry.retire_xgpr_data = 'x;
                end
                // Place the entry into the array and increment
                ret_array[fetch_head] = ret_entry;
                retired_instructions++;
                fetch_head++;
                uid++;
            end
        end
    end

    // Checker: Retired vs ISS
    initial begin
        forever begin
            @(posedge clk);
            // Increment nothing retired
			if (ret_array[retire_tail].retire_valid) begin
				nothing_retired_counter = 0;
			end else begin
				nothing_retired_counter++;
			end
            // If retires, print the retired instruction and compare
			if(ret_array[retire_tail].retire_valid) begin 
				void'(rvDecoder.decode(ret_array[retire_tail].retire_inst));
				rvDecodedInst = rvDecoder.asm;
				$display("=====================================================================================================================================================================================");
				//$write("[retire_tail=%0d]", retire_tail);
				$write("[time=%8t ps (fetch=%8t)]", $time, ret_array[retire_tail].fetch_time);
				$write("[cycle=%-8d] ", cycle_counter);
				$write("v=%b", ret_array[retire_tail].retire_valid);
				$write("\n");
				$write("[RET]");
				$write("[#%-6d]", ret_array[retire_tail].uid);
				$write("pc=0x%8h, ", ret_array[retire_tail].retire_pc);
				$write("inst=0x%8h(%-24s), ", ret_array[retire_tail].retire_inst, rvDecodedInst);
				$write("wb=%b, ", ret_array[retire_tail].retire_needs_wb);
				$write("i_wb=%b, ", ret_array[retire_tail].retire_xgpr_wb);
				$write("i_idx=%2s, ", (ret_array[retire_tail].retire_xgpr_index === 'x) ? $sformatf("%s", "xx") : $sformatf("%d", ret_array[retire_tail].retire_xgpr_index));
				$write("i_data=0x%h, ", ret_array[retire_tail].retire_xgpr_data);
				$write("\n");

				if (ret_array[retire_tail].retire_pc === RESET_ADDR) begin
                    $display("ENABLING COMPARATION");
                    `ifdef SVH_EXISTS
					    enable_comparation();
                    `endif
				end
                // END ON SELF JUMP OR ECALL
				if (ret_array[retire_tail].retire_inst inside {'h0000006f, 'h00000073}) begin
                    last_retire_cycle = cycle_counter;
					eot();
				end

                `ifdef SVH_EXISTS
                if (comparation_on) begin
				    iss_comparation();
                end
                `endif
                

				if (END_ON_N_MISMATCH == mismatched_instructions) begin
					eot();
				end

				retire_tail++;
			end
        end
    end

    // Cycle counter
	always @(posedge clk) begin
		cycle_counter++;
	end

    always #(CLK_PERIOD/2) clk = ~ clk;
    initial clk = 0;

    initial begin
        arstn = 1; #10; arstn = 0; #10; arstn = 1;
        ROM.sram_dump();
        ROM.sram_size();
        $display("[SVH][SIZE] %0d",  $size(ISS.instruction_array));
    end

    // Timeout watchdog
    initial begin
        #GLOBAL_TIMEOUT;
        $display("[ERROR][time=%8t ] REACHED TIMEOUT!", $time);
        timeout = '1;
        eot();
    end

    // No retires watchdog
	initial begin
		forever begin
			@(posedge clk);
			if (nothing_retired_counter == MAX_NOTHING_RETIRED) begin
				$display("[ERROR][time=%8t] NOTHING RETIRED IN %d CYCLES!", $time, nothing_retired_counter);
				nothing_retired = '1;
				eot();
			end
		end
    end
endmodule
