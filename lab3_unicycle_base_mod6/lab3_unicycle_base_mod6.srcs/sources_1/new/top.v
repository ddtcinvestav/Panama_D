module top #(parameter WIDTH = 32, parameter RESET_ADDR = 32'h00000000)(
    input  wire        clk,
    input  wire        arstn,
    output wire        valid,

    // GPIO: LEDs (salidas)
    output wire [17:0] ledr,
    output wire [8:0]  ledg,

    // GPIO: interruptores y botones (entradas)
    input  wire [17:0] sw,
    input  wire [3:0]  key
);

    // Wires para conectar cpu con imem
    wire [WIDTH-1:0] inst_addr;
    wire [WIDTH-1:0] inst_data;

    // Wires para conectar cpu con dmem/gpio
    wire             mem_write;
    wire             mem_read;
    wire [WIDTH-1:0] data_addr;
    wire [WIDTH-1:0] data_write;
    wire [WIDTH-1:0] data_read;
    wire [1:0]       write_strb;

    // Decodificador de direcciones
    wire gpio_sel = (data_addr[31:24] == 8'hFF);
    wire dmem_sel = ~gpio_sel;

    // Datos de lectura de cada esclavo
    wire [WIDTH-1:0] dmem_rd;
    wire [WIDTH-1:0] gpio_rd;

    // Mux de lectura: selecciona la fuente segun la direccion
    assign data_read = gpio_sel ? gpio_rd : dmem_rd;

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
        .we   (mem_write & dmem_sel),
        .re   (mem_read  & dmem_sel),
        .addr (data_addr),
        .wd   (data_write),
        .rd   (dmem_rd)
    );

    // Instancia GPIO
    gpio #(.WIDTH(WIDTH)) GPIO (
        .clk      (clk),
        .arstn    (arstn),
        // Wishbone
        .wb_cyc_i (mem_write | mem_read),
        .wb_stb_i (gpio_sel),
        .wb_we_i  (mem_write),
        .wb_adr_i (data_addr),
        .wb_dat_i (data_write),
        .wb_dat_o (gpio_rd),
        .wb_ack_o (),
        // Pines fisicos
        .gpio_ledr (ledr),
        .gpio_ledg (ledg),
        .gpio_sw   (sw),
        .gpio_key  (key)
    );

endmodule
