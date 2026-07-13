//==============================================================
// Edge Analytics IP Core - Top Module
//==============================================================

`timescale 1ns/1ps

module edge_analytics_ip_core #(
    parameter NUM_SENSORS      = 4,
    parameter SENSOR_WIDTH     = 16,
    parameter TIMESTAMP_WIDTH  = 32,
    parameter FIFO_DEPTH       = 64,
    parameter OUTPUT_WIDTH     = 16,
    parameter ADDR_WIDTH       = 8,
    parameter CFG_DATA_WIDTH   = 32
)(
    input  wire                        clk,
    input  wire                        rst_n,
    input  wire [NUM_SENSORS*SENSOR_WIDTH-1:0] sensor_data_in,
    input  wire [NUM_SENSORS-1:0]              sensor_valid,
    input  wire                        cfg_clk,
    input  wire                        cfg_rst_n,
    input  wire [ADDR_WIDTH-1:0]       cfg_addr,
    input  wire [CFG_DATA_WIDTH-1:0]   cfg_wdata,
    input  wire                        cfg_write,
    input  wire                        cfg_read,
    output wire [CFG_DATA_WIDTH-1:0]   cfg_rdata,
    output wire [OUTPUT_WIDTH-1:0]     processed_data_out,
    output wire                        data_valid_out,
    output wire                        irq_alert,
    `ifdef USE_POWER_PINS
    inout VPWR,
    inout VGND,
    `endif
   
);

    //----------------------------------------------------------
    // Internal Wires
    //----------------------------------------------------------
    wire [SENSOR_WIDTH-1:0] sensor_data;
    wire sensor_data_valid;
    wire [SENSOR_WIDTH-1:0] fifo_out;
    wire fifo_empty, fifo_full;
    wire [TIMESTAMP_WIDTH-1:0] timestamp;

    // Separate outputs for each module
    wire [SENSOR_WIDTH-1:0] min_val_engine, max_val_engine;
    wire [SENSOR_WIDTH-1:0] min_val_detector, max_val_detector;
    wire threshold_cross_engine, threshold_cross_detector;
    wire [1:0] trend_engine, trend_detector;
    wire peak_detected;
    wire [31:0] sample_count;

    wire [CFG_DATA_WIDTH-1:0] threshold_cfg, window_cfg, sensor_enable;
    reg  [CFG_DATA_WIDTH-1:0] status_flags;

    //----------------------------------------------------------
    // Sensor Interface
    //----------------------------------------------------------
    sensor_interface #(
        .NUM_SENSORS(NUM_SENSORS),
        .SENSOR_WIDTH(SENSOR_WIDTH)
    ) u_sensor_interface (
        .clk(clk),
        .rst_n(rst_n),
        .sensor_data_in(sensor_data_in),
        .sensor_valid(sensor_valid),
        .sensor_data_out(sensor_data),
        .data_valid_out(sensor_data_valid)
    );

    //----------------------------------------------------------
    // Input Buffer (FIFO)
    //----------------------------------------------------------
    input_buffer #(
        .DATA_WIDTH(SENSOR_WIDTH),
        .DEPTH(FIFO_DEPTH)
    ) u_input_buffer (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(sensor_data_valid),
        .data_in(sensor_data),
        .rd_en(!fifo_empty),
        .data_out(fifo_out),
        .full(fifo_full),
        .empty(fifo_empty)
    );

    //----------------------------------------------------------
    // Analytics Engine
    //----------------------------------------------------------
    analytics_engine u_analytics_engine (
        .clk(clk),
        .rst_n(rst_n),
        .data_valid(sensor_data_valid),
        .data_in(fifo_out),
        .threshold(threshold_cfg[SENSOR_WIDTH-1:0]),
        .min_val(min_val_engine),
        .max_val(max_val_engine),
        .threshold_cross(threshold_cross_engine),
        .trend(trend_engine)
    );

    //----------------------------------------------------------
    // Min/Max Detector
    //----------------------------------------------------------
    minmax_detector #(.DATA_WIDTH(SENSOR_WIDTH)) u_minmax_detector (
        .clk(clk),
        .rst_n(rst_n),
        .data_valid(sensor_data_valid),
        .data_in(fifo_out),
        .min_val(min_val_detector),
        .max_val(max_val_detector)
    );

    //----------------------------------------------------------
    // Threshold Detector
    //----------------------------------------------------------
    threshold_detector #(.DATA_WIDTH(SENSOR_WIDTH)) u_threshold_detector (
        .clk(clk),
        .rst_n(rst_n),
        .data_valid(sensor_data_valid),
        .data_in(fifo_out),
        .threshold(threshold_cfg[SENSOR_WIDTH-1:0]),
        .threshold_cross(threshold_cross_detector)
    );

    //----------------------------------------------------------
    // Trend Detector
    //----------------------------------------------------------
    trend_detector #(.DATA_WIDTH(SENSOR_WIDTH)) u_trend_detector (
        .clk(clk),
        .rst_n(rst_n),
        .data_valid(sensor_data_valid),
        .data_in(fifo_out),
        .trend(trend_detector)
    );

    //----------------------------------------------------------
    // Output Formatter
    //----------------------------------------------------------
    output_formatter #(.DATA_WIDTH(SENSOR_WIDTH)) u_output_formatter (
        .clk(clk),
        .rst_n(rst_n),
        .data_valid(sensor_data_valid),
        .processed_data(fifo_out),
        .data_out(processed_data_out),
        .valid_out(data_valid_out)
    );

    //----------------------------------------------------------
    // Register Bank
    //----------------------------------------------------------
    register_bank #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(CFG_DATA_WIDTH)
    ) u_register_bank (
        .clk(cfg_clk),
        .rst_n(cfg_rst_n),
        .addr(cfg_addr),
        .wdata(cfg_wdata),
        .write_en(cfg_write),
        .read_en(cfg_read),
        .rdata(cfg_rdata),
        .threshold_cfg(threshold_cfg),
        .window_cfg(window_cfg),
        .sensor_enable(sensor_enable),
        .status_flags(status_flags)
    );

    //----------------------------------------------------------
    // Interrupt Logic
    //----------------------------------------------------------
    interrupt_logic u_interrupt_logic (
        .clk(clk),
        .rst_n(rst_n),
        .threshold_cross(threshold_cross_detector | threshold_cross_engine),
        .alert_event(data_valid_out),
        .irq(irq_alert)
    );

    //----------------------------------------------------------
    // Sample Counter
    //----------------------------------------------------------
    sample_counter #(.WIDTH(32)) u_sample_counter (
        .clk(clk),
        .rst_n(rst_n),
        .sample_valid(sensor_data_valid),
        .sample_count(sample_count)
    );

    //----------------------------------------------------------
    // Peak Detector
    //----------------------------------------------------------
    peak_detector #(.DATA_WIDTH(SENSOR_WIDTH)) u_peak_detector (
        .clk(clk),
        .rst_n(rst_n),
        .data_valid(sensor_data_valid),
        .data_in(fifo_out),
        .peak_detected(peak_detected)
    );

    //----------------------------------------------------------
    // Status Flags Update
    //----------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            status_flags <= {CFG_DATA_WIDTH{1'b0}};
        end else begin
            status_flags[30]   <= peak_detected;
            status_flags[29]   <= threshold_cross_detector | threshold_cross_engine;
            status_flags[31:0] <= sample_count;
        end
    end

    //----------------------------------------------------------
    // Final Output Assignments
    //----------------------------------------------------------
    // Choose which outputs to expose (detector vs engine)
    wire [SENSOR_WIDTH-1:0] min_val = min_val_detector;
    wire [SENSOR_WIDTH-1:0] max_val = max_val_detector;
    wire [1:0] trend       = trend_detector;

endmodule
