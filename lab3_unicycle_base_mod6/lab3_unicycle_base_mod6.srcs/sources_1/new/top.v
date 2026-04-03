module top #(parameter WIDTH = 32, parameter RESET_ADDR = 32'h00000000)(
      input clk,
      input arstn,
      output valid
  );

      // Wires para conectar cpu con imem
      wire [WIDTH-1:0] inst_addr;
      wire [WIDTH-1:0] inst_data;

      // Wires para conectar cpu con dmem
      wire             mem_write;
      wire             mem_read;
      wire [WIDTH-1:0] data_addr;
      wire [WIDTH-1:0] data_write;
      wire [WIDTH-1:0] data_read;
      wire [1:0]       write_strb;

      // Instancia CPU
      cpu #(.WIDTH(WIDTH), .RESET_ADDR(RESET_ADDR)) CPU (
          .clk                    (clk),
          .arstn                  (arstn),
          .inst_mem_r_addr        (inst_addr),
          .inst_memory_in         (inst_data),
          .data_memory_write      (mem_write),
          .data_memory_read       (mem_read),
          .data_address_out       (data_addr),
          .data_memory_write_data (data_write),
          .data_memory_in         (data_read),
          .data_memory_write_strb (write_strb),
          .valid                  (valid)
      );

      // Instancia IMEM
      imem #(.WIDTH(WIDTH)) IMEM (
          .addr  (inst_addr),
          .instr (inst_data)
      );

      // Instancia DMEM
      dmem #(.WIDTH(WIDTH)) DMEM (
          .clk  (clk),
          .we   (mem_write),
          .re   (mem_read),
          .addr (data_addr),
          .wd   (data_write),
          .rd   (data_read)
      );

  endmodule