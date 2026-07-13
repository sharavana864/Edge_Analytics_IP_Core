//==============================================================
// Debug Logic
//==============================================================
module debug_logic #(
    parameter DATA_WIDTH = 16
)(
    input  wire clk,
    input  wire rst_n,
    input  wire [DATA_WIDTH-1:0] data_in,
    input  wire data_valid,
    output reg  [DATA_WIDTH-1:0] debug_last_value,
    output reg                   debug_valid_flag
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            debug_last_value <= 0;
            debug_valid_flag <= 0;
        end else if (data_valid) begin
            debug_last_value <= data_in;
            debug_valid_flag <= 1;
        end else begin
            debug_valid_flag <= 0;
        end
    end
endmodule
