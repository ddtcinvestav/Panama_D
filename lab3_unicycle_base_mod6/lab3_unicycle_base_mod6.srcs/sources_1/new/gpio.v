module gpio #(parameter WIDTH = 32)(
    input  wire             clk,
    input  wire             arstn,

    // Wishbone slave interface
    input  wire             wb_cyc_i,
    input  wire             wb_stb_i,
    input  wire             wb_we_i,
    input  wire [WIDTH-1:0] wb_adr_i,
    input  wire [WIDTH-1:0] wb_dat_i,
    output reg  [WIDTH-1:0] wb_dat_o,
    output wire             wb_ack_o,

    // Salidas fisicas: LEDs
    output reg  [17:0]      gpio_ledr,
    output reg  [8:0]       gpio_ledg,

    // Entradas fisicas: interruptores y botones
    input  wire [17:0]      gpio_sw,
    input  wire [3:0]       gpio_key
);

    // ACK combinacional: el esclavo siempre responde en el mismo ciclo
    assign wb_ack_o = wb_cyc_i & wb_stb_i;

    // Direcciones de los registros (offset desde base 0xFF000000)
    localparam ADDR_LEDR = 32'hFF000000;
    localparam ADDR_LEDG = 32'hFF000004;
    localparam ADDR_SW   = 32'hFF000008;
    localparam ADDR_KEY  = 32'hFF00000C;

    // Escritura (registros de salida)
    always @(posedge clk or negedge arstn) begin
        if (!arstn) begin
            gpio_ledr <= 18'b0;
            gpio_ledg <= 9'b0;
        end else if (wb_cyc_i && wb_stb_i && wb_we_i) begin
            case (wb_adr_i)
                ADDR_LEDR: gpio_ledr <= wb_dat_i[17:0];
                ADDR_LEDG: gpio_ledg <= wb_dat_i[8:0];
                default: ;
            endcase
        end
    end

    // Lectura (combinacional)
    always @(*) begin
        case (wb_adr_i)
            ADDR_LEDR: wb_dat_o = {14'b0, gpio_ledr};
            ADDR_LEDG: wb_dat_o = {23'b0, gpio_ledg};
            ADDR_SW:   wb_dat_o = {14'b0, gpio_sw};
            ADDR_KEY:  wb_dat_o = {28'b0, gpio_key};
            default:   wb_dat_o = 32'b0;
        endcase
    end

endmodule
