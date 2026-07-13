//==============================================================
// Peak Detector
//==============================================================
module peak_detector #(
    parameter DATA_WIDTH = 16
)(
    input  wire clk,
    input  wire rst_n,
    input  wire data_valid,
    input  wire [DATA_WIDTH-1:0] data_in,
    output reg                   peak_detected
);

    reg [DATA_WIDTH-1:0] prev_val;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            prev_val <= 0;
            peak_detected <= 0;
        end else if (data_valid) begin
            peak_detected <= (data_in < prev_val); // falling after rise = peak
            prev_val <= data_in;
        end
    end
endmodule
