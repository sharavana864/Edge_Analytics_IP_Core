//==============================================================
// Interrupt Logic
//==============================================================
module interrupt_logic (
    input  wire clk,
    input  wire rst_n,
    input  wire threshold_cross,
    input  wire alert_event,
    output reg  irq
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) irq <= 0;
        else irq <= threshold_cross | alert_event;
    end
endmodule
