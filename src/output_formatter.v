//==============================================================
// Output Formatter
//==============================================================
module output_formatter #(
    parameter DATA_WIDTH = 16
)(
    input  wire clk,
    input  wire rst_n,
    input  wire data_valid,
    input  wire [DATA_WIDTH-1:0] processed_data,
    output reg  [DATA_WIDTH-1:0] data_out,
    output reg                   valid_out
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out  <= 0;
            valid_out <= 0;
        end else begin
            valid_out <= data_valid;
            if (data_valid) data_out <= processed_data;
        end
    end
endmodule
