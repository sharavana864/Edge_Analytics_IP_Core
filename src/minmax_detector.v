//==============================================================
// Min/Max Detector
//==============================================================
module minmax_detector #(
    parameter DATA_WIDTH = 16
)(
    input  wire clk,
    input  wire rst_n,
    input  wire data_valid,
    input  wire [DATA_WIDTH-1:0] data_in,
    output reg  [DATA_WIDTH-1:0] min_val,
    output reg  [DATA_WIDTH-1:0] max_val
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            min_val <= {DATA_WIDTH{1'b1}};
            max_val <= 0;
        end else if (data_valid) begin
            if (data_in < min_val) min_val <= data_in;
            if (data_in > max_val) max_val <= data_in;
        end
    end
endmodule
