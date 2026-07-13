//==============================================================
// Register Bank
//==============================================================
module register_bank #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 32
)(
    input  wire                  clk,
    input  wire                  rst_n,
    input  wire [ADDR_WIDTH-1:0] addr,
    input  wire [DATA_WIDTH-1:0] wdata,
    input  wire                  write_en,
    input  wire                  read_en,
    output reg  [DATA_WIDTH-1:0] rdata,

    // Config outputs
    output reg [DATA_WIDTH-1:0] threshold_cfg,
    output reg [DATA_WIDTH-1:0] window_cfg,
    output reg [DATA_WIDTH-1:0] sensor_enable,

    // Status inputs
    input  wire [DATA_WIDTH-1:0] status_flags
);

    reg [DATA_WIDTH-1:0] regfile [0:(1<<ADDR_WIDTH)-1];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            threshold_cfg <= 0;
            window_cfg    <= 8;
            sensor_enable <= 0;
        end else begin
            if (write_en) begin
                regfile[addr] <= wdata;
                case (addr)
                    8'h00: threshold_cfg <= wdata;
                    8'h04: window_cfg    <= wdata;
                    8'h08: sensor_enable <= wdata;
                endcase
            end
            if (read_en) begin
                case (addr)
                    8'h00: rdata <= threshold_cfg;
                    8'h04: rdata <= window_cfg;
                    8'h08: rdata <= sensor_enable;
                    8'h0C: rdata <= status_flags;
                    default: rdata <= 0;
                endcase
            end
        end
    end
endmodule
