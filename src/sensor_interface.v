//==============================================================
// Sensor Interface
//==============================================================
module sensor_interface #(
    parameter NUM_SENSORS  = 4,
    parameter SENSOR_WIDTH = 16
)(
    input  wire                        clk,
    input  wire                        rst_n,
    input  wire [NUM_SENSORS*SENSOR_WIDTH-1:0] sensor_data_in,
    input  wire [NUM_SENSORS-1:0]      sensor_valid,
    output reg  [SENSOR_WIDTH-1:0]     sensor_data_out,
    output reg                         data_valid_out
);

    integer i;
    reg [SENSOR_WIDTH-1:0] sensor_array [0:NUM_SENSORS-1];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sensor_data_out <= 0;
            data_valid_out  <= 0;
        end else begin
            data_valid_out <= |sensor_valid; // any sensor active
            for (i=0; i<NUM_SENSORS; i=i+1) begin
                sensor_array[i] <= sensor_data_in[(i+1)*SENSOR_WIDTH-1 -: SENSOR_WIDTH];
            end
            // Simple priority: pick first valid sensor
            for (i=0; i<NUM_SENSORS; i=i+1) begin
                if (sensor_valid[i]) begin
                    sensor_data_out <= sensor_array[i];
                end
            end
        end
    end
endmodule
