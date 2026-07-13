module moving_avg_filter #(
    parameter DATA_WIDTH  = 16,
    parameter WINDOW_SIZE = 8
)(
    input  wire clk,
    input  wire rst_n,
    input  wire data_valid,
    input  wire [DATA_WIDTH-1:0] data_in,
    output reg  [DATA_WIDTH-1:0] avg_out
);

    localparam IDX_WIDTH = $clog2(WINDOW_SIZE);
    localparam SUM_WIDTH = DATA_WIDTH + IDX_WIDTH + 1;

    // Explicit unsigned, correctly-sized copy of WINDOW_SIZE.
    // Bare `parameter` is a signed 32-bit integer in SV, so dividing the
    // unsigned SUM_WIDTH-bit `sum` by raw WINDOW_SIZE trips arith-op-mismatch.
    localparam [SUM_WIDTH-1:0] WINDOW_SIZE_U    = WINDOW_SIZE;
    // Same reasoning for the idx wrap comparison below (idx is unsigned
    // IDX_WIDTH bits; WINDOW_SIZE-1 is signed 32-bit).
    localparam [IDX_WIDTH-1:0] WINDOW_SIZE_M1_U = WINDOW_SIZE - 1;

    // All declared as unsigned reg
    reg [DATA_WIDTH-1:0] window [0:WINDOW_SIZE-1];
reg [IDX_WIDTH-1:0]  idx;
reg [SUM_WIDTH-1:0]  sum;
reg [SUM_WIDTH-1:0]  avg_temp;
    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            idx      <= 0;
            sum      <= 0;
            avg_temp <= 0;
            avg_out  <= 0;
            for (i = 0; i < WINDOW_SIZE; i = i + 1)
                window[i] <= 0;
        end else if (data_valid) begin
            // Equal-width arithmetic
            sum <= sum
                 - {{(SUM_WIDTH-DATA_WIDTH){1'b0}}, window[idx]}
                 + {{(SUM_WIDTH-DATA_WIDTH){1'b0}}, data_in};

            window[idx] <= data_in;

            // Wrap index safely
            if (idx == WINDOW_SIZE_M1_U)
                idx <= 0;
            else
                idx <= idx + 1'b1;

            // Division result stored in equal-width reg
            avg_temp <= sum / WINDOW_SIZE_U;

            // Truncate cleanly to DATA_WIDTH
            avg_out <= avg_temp[DATA_WIDTH-1:0];
        end
    end

endmodule

