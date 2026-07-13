set ::env(DESIGN_NAME) edge_analytics_ip_core
set ::env(VERILOG_FILES) [glob $::env(DESIGN_DIR)/src/*.v]

# Clock constraint
set ::env(CLOCK_PORT) "clk"
set ::env(CLOCK_PERIOD) 10.0

# Floorplan settings
set ::env(FP_CORE_UTIL) 60
set ::env(FP_ASPECT_RATIO) 1.0
set ::env(FP_IO_MODE) 1

# Power grid (use FP_PDN_CFG only!)
set ::env(VDD_NETS) "VPWR"
set ::env(GND_NETS) "VGND"
