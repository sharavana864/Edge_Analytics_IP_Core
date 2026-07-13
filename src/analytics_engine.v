//==============================================================
// Analytics Engine
//==============================================================
module analytics_engine #(
    parameter DATA_WIDTH = 16
)(
    input  wire clk,
    input  wire rst_n,
    input  wire data_valid,
    input  wire [DATA_WIDTH-1:0] data_in,
    input  wire [DATA_WIDTH-1:0] threshold,
    output reg  [DATA_WIDTH-1:0] min_val,
    output reg  [DATA_WIDTH-1:0] max_val,
    output reg                    threshold_cross,
    output reg [1:0]              trend // 00=stable, 01=rising, 10=falling
);

    reg [DATA_WIDTH-1:0] prev_val;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            min_val <= {DATA_WIDTH{1'b1}};
            max_val <= 0;
            threshold_cross <= 0;
            trend <= 2'b00;
            prev_val <= 0;
        end else if (data_valid) begin
            if (data_in < min_val) min_val <= data_in;
            if (data_in > max_val) max_val <= data_in;
            threshold_cross <= (data_in > threshold);
            if (data_in > prev_val) trend <= 2'b01;
            else if (data_in < prev_val) trend <= 2'b10;
            else trend <= 2'b00;
            prev_val <= data_in;
        end
    end
endmodule
