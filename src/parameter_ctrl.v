//==============================================================
// Parameter Controller
//==============================================================
module parameter_ctrl #(
    parameter DATA_WIDTH = 32
)(
    input  wire clk,
    input  wire rst_n,
    input  wire [DATA_WIDTH-1:0] window_cfg,
    input  wire [DATA_WIDTH-1:0] threshold_cfg,
    output reg  [DATA_WIDTH-1:0] window_size,
    output reg  [DATA_WIDTH-1:0] threshold_val
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            window_size  <= 8;
            threshold_val <= 100;
        end else begin
            window_size  <= window_cfg;
            threshold_val <= threshold_cfg;
        end
    end
endmodule
