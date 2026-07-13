//==============================================================
// Sample Counter
//==============================================================
module sample_counter #(
    parameter WIDTH = 32
)(
    input  wire clk,
    input  wire rst_n,
    input  wire sample_valid,
    output reg  [WIDTH-1:0] sample_count
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) sample_count <= 0;
        else if (sample_valid) sample_count <= sample_count + 1;
    end
endmodule
