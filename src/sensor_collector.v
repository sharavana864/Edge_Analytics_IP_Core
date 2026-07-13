//==============================================================
// Sensor Collector
//==============================================================
module sensor_collector #(
    parameter NUM_SENSORS  = 4,
    parameter SENSOR_WIDTH = 16
)(
    input  wire [NUM_SENSORS*SENSOR_WIDTH-1:0] sensor_data_in,
    input  wire [NUM_SENSORS-1:0]              sensor_valid,
    output wire [SENSOR_WIDTH-1:0]             selected_data,
    output wire                                data_valid
);

    assign data_valid = |sensor_valid;
    assign selected_data = sensor_data_in[SENSOR_WIDTH-1:0]; // simple: pick sensor0
endmodule
