module top (
    input wire      clk, 
    input wire      rst_btn,

    input wire      s_data,

    input wire [7:0] comparison_value,
    
    output wire     s_clk,
    output wire     cs,

    output wire     red_led,
    output wire     green_led
);

    wire rst;
    assign rst = ~rst_btn;
 
    reg [7:0]   in;

    always @ (posedge clk) begin
        in <= comparison_value;
    end

    adc_controller #(
        .clk_speed(8000000),
        .sclk_speed(100000)
    ) adc_inst (
        .rst(rst),
        .clk(clk),

        .data_in(s_data),

        .cs(cs),
        .sclk(s_clk),

        .adc_data(adc_data),
        .data_ready(data_ready)
    );

    wire [11:0] adc_data;
    wire        data_ready;

    comparator comparator_inst (
        .clk(clk),
        .rst(rst),
        .data_ready(data_ready),
        .data(adc_data[11:4]),
        .in(in),
        .red_enable(red_enable),
        .green_enable(green_enable)
    );

    wire        red_enable;
    wire        green_enable;

    pulse_generator pulse_generator_inst (
        .clk(clk),
        .rst(rst),
        .red_ctrl(red_enable),
        .green_ctrl(green_enable),
        .green_led(green_led),
        .red_led(red_led)
    );

endmodule

