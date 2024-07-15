module pulse_generator (
    input wire  clk,
    input wire  rst,

    input wire  red_ctrl,
    input wire  green_ctrl,

    output reg  red_led,
    output reg  green_led
);

    reg [23:0] red_ctrl_counter;

    //Red LED
    always @ (posedge clk) begin
        if(rst == 1'b1) begin
            red_led <= 1'b0;
            //green_led <= 1'b0;
            red_ctrl_counter <= 24'd0;
        end else if (red_ctrl == 1'b1) begin
            if (red_ctrl_counter == 24'd1000000 - 1) begin
                red_led <= ~red_led;
                red_ctrl_counter <= 24'd0;
            end else begin
                red_ctrl_counter <= red_ctrl_counter + 1;
            end
        end else begin
            red_led <= 1'b0;
        end
    end

    //Green LED
    always @ (posedge clk) begin
        if(rst == 1'b1) begin
            green_led <= 1'b0;
        end else begin
            green_led <= green_ctrl;
        end
    end
        
endmodule