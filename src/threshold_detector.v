//==============================================================
// Threshold Detector
//==============================================================
module threshold_detector #(
    parameter DATA_WIDTH = 16
)(
    input  wire clk,
    input  wire rst_n,
    input  wire data_valid,
    input  wire [DATA_WIDTH-1:0] data_in,
    input  wire [DATA_WIDTH-1:0] threshold,
    output reg                   threshold_cross
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) threshold_cross <= 0;
        else if (data_valid) threshold_cross <= (data_in > threshold);
    end
endmodule
