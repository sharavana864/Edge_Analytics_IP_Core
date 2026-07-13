//==============================================================
// Timestamp Generator
//==============================================================
module timestamp_gen #(
    parameter WIDTH = 32
)(
    input  wire clk,
    input  wire rst_n,
    input  wire sample_valid,
    output reg  [WIDTH-1:0] timestamp
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            timestamp <= 0;
        end else if (sample_valid) begin
            timestamp <= timestamp + 1; // simple counter-based timestamp
        end
    end
endmodule
