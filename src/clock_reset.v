//==============================================================
// Clock & Reset Module
//==============================================================
`timescale 1ns/1ps

module clock_reset (
    input  wire clk_in,
    input  wire rst_n_in,
    input  wire clk_enable,
    output wire clk_out,
    output reg  rst_n_sync
);

    // Clock gating
    assign clk_out = clk_enable ? clk_in : 1'b0;

    // Reset synchronization
    reg rst_ff1, rst_ff2;
    always @(posedge clk_in or negedge rst_n_in) begin
        if (!rst_n_in) begin
            rst_ff1 <= 0; rst_ff2 <= 0; rst_n_sync <= 0;
        end else begin
            rst_ff1 <= 1;
            rst_ff2 <= rst_ff1;
            rst_n_sync <= rst_ff2;
        end
    end
endmodule
