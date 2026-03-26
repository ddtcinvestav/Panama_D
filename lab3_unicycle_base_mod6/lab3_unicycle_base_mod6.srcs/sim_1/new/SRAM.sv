module SRAM #(
  parameter WIDTH = 64, PRELOAD = 1, READ_X_IF_UNINTIALIZED = 1, WORD_ADDRESSABLE = 0,
  parameter string INIT_FILE = ""
) (
  input logic clk, arstn,
  // W-PORT
  input logic [WIDTH-1:0] w_addr,
  input logic w_en,
  input logic [1:0] w_strb,
  input logic [WIDTH-1:0] w_data,
  // R-PORT
  input logic [WIDTH-1:0] r_addr,
  input logic r_en,
  output logic [WIDTH-1:0] r_data
);
  // Data members
  typedef logic [7:0] resp_t;      // Character or byte
  typedef logic [WIDTH-1:0] key_t; // Key
  resp_t sram_data[key_t];         // Data array
  bit preload_not_previously_done;

  // Function to print current size
  function void sram_size();
    $display("[SRAM][SIZE] Current byte words: %0d", sram_data.size());
  endfunction 

  // Read from file fixed to little-endian and shifted 32 bit words in .hex file!
  function void load_sram_data_from_file(
    input string file_name,
    output resp_t sram_data[key_t]
  );
    integer file;
    string line;
    key_t current_addr;
    int r;
    string token;
    int byte_val;
    int i;
    int space_pos;

    int word_len;
    if (WORD_ADDRESSABLE) begin
      word_len = 8;
    end else begin
      word_len = 2;
    end

    file = $fopen(file_name, "r");
    if (file == 0) begin
      $display("Error: Could not open file %s", file_name);
      $finish;
    end else begin
      $display("File %s loaded correctly!", file_name);
    end

    current_addr = '0;
    while (!$feof(file)) begin
      line = "";
      void'($fgets(line, file));
      line = line.tolower();

      // Check for address line
      if (line.len() > 0 && line[0] == "@") begin
        r = $sscanf(line, "@%h", current_addr);
        if (WORD_ADDRESSABLE) begin
          current_addr = current_addr * 4;
        end else begin
          current_addr = current_addr;
        end
        if (r != 1) begin
          $display("Error parsing address line: %s", line);
          $finish;
        end
      end
      else begin
        // Parse each word manually
        while (line.len() >= word_len) begin
          token = line.substr(0, word_len-1); // get 8 characters
          //$display("TOKEN: %s", token);
          // Convert 8 hex chars (32 bits) to 4 bytes in little-endian
          for (i = (word_len/2)-1; i >= 0 ; i--) begin
            string byte_str;
            // i {x, y}
            // i = 0 {6,7}, i = 1 {4,5}, i = 2 {2,3}, i = 3 {0, 1};
            byte_str = {token.substr(i * 2, (i * 2) + 1)};
            //$display("ITER: %d, CURR_ADDR:%0h, BYTE_STR: %s", i, current_addr, byte_str);
            if ($sscanf(byte_str, "%2x", byte_val) == 1) begin
              sram_data[current_addr] = resp_t'(byte_val);
              current_addr++;
            end
          end

          // Remove this token and any leading space
          space_pos = -1;
          for (i = word_len; i < line.len(); i++) begin
            if (line[i] != " ") begin
              space_pos = i;
              break;
            end
          end
          if (space_pos != -1)
            line = line.substr(space_pos, line.len() - 1);
          else
            break;
        end
      end
    end
    $fclose(file);
  endfunction

  function void sram_dump();
    $display("[SRAM][FULL MEM DUMP]");
    foreach (sram_data[address]) begin
      $display("\t[0x%h]: %02x", address, sram_data[address]);
    end
  endfunction

  // Write process
  always_ff @(posedge clk or negedge arstn) begin
    if (!arstn) begin
      if (PRELOAD && !preload_not_previously_done) begin // Load preload.hex if enabled
        $display("[SRAM] P r e l o a d i n g . . .");
        load_sram_data_from_file(INIT_FILE, sram_data);
        $display("[SRAM] \tPreload done! Current bytes words: %0d", sram_data.size());
        preload_not_previously_done = '1;
      end
    end else begin
      if (w_en) begin
        case (w_strb)
          2'b00: sram_data[w_addr] = w_data[7:0];
          2'b01: begin
            sram_data[w_addr]      = w_data[7:0];
            sram_data[w_addr+1]    = w_data[15:8];
          end
          2'b10: begin
            sram_data[w_addr]      = w_data[7:0];
            sram_data[w_addr+1]    = w_data[15:8];
            sram_data[w_addr+2]    = w_data[23:16];
            sram_data[w_addr+3]    = w_data[31:24];
          end
        endcase
      end
    end
  end

  // Read process
  always_comb begin
    if (r_en) begin
      r_data = {
        (sram_data[r_addr+64'd3] === 'x) ? ((READ_X_IF_UNINTIALIZED) ? 'x : '0) : sram_data[r_addr+64'd3],
        (sram_data[r_addr+64'd2] === 'x) ? ((READ_X_IF_UNINTIALIZED) ? 'x : '0) : sram_data[r_addr+64'd2],
        (sram_data[r_addr+64'd1] === 'x) ? ((READ_X_IF_UNINTIALIZED) ? 'x : '0) : sram_data[r_addr+64'd1],
        (sram_data[r_addr]       === 'x) ? ((READ_X_IF_UNINTIALIZED) ? 'x : '0) : sram_data[r_addr]  
      };
    end else begin
      r_data = 'x;
    end
  end

endmodule