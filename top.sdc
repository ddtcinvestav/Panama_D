# Synopsys Design Constraints
# DE2-115 - Reloj principal 50 MHz

create_clock -period 20.000 -name clk [get_ports clk]

derive_clock_uncertainty
