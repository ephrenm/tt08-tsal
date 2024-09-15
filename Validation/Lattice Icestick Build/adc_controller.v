/*
Author: Ephren Manning
Title: adc_controller.v
Purpose: Control logic for AD7476A 12-bit SAR ADC
Clock Frequency: 8 MHz
*/

module adc_controller #(
    parameter clk_speed = 8000000,
    parameter sclk_speed = 100000 //20kHz min, 20MHz max
) (
    input wire          rst,
    input wire          clk,

    input wire          data_in,

    output reg          cs,
    output reg          sclk,

    output reg [11:0]   adc_data,
    output reg          data_ready
);

    integer sclk_period = (clk_speed / sclk_speed) - 1;
    integer sclk_half_period = ((clk_speed / sclk_speed) / 2) - 1;

    reg[5:0]            bit_counter;
    reg[9:0]            clk_counter;

    reg                 data_in_reg;

    always @ (posedge clk) begin

        if (rst == 1'b1) begin
            cs <= 1'b1;
            sclk <= 1'b0;
            //adc_data <= 8'd0;
            data_ready <= 1'b0;
            bit_counter <= 6'b0;
            clk_counter <= 10'b0;
            data_in_reg <= 1'b0;
        end else begin
            data_in_reg <= data_in;

            if (clk_counter == 10'd0) begin
                if (cs == 1'b1 & bit_counter == 6'b0) begin //adc read has been finished and is idle
                    cs <= 1'b0; //set chip select low, starting conversion
                    bit_counter <= 6'd32;
                    clk_counter <= sclk_half_period; // wait 1/2 sclk period to read first bit
                    data_ready <= 1'b0;
                end else if (cs == 1'b0 & bit_counter == 6'b0) begin //adc read has finished
                    cs <= 1'b1; 
                    clk_counter <= sclk_period;
                    data_ready <= 1'b1;
                end else begin
                    sclk <= ~sclk;
                    clk_counter <= sclk_half_period;
                    bit_counter <= bit_counter - 1;
                end
            end else begin
                clk_counter <= clk_counter - 1;
            end
        end
    end

    always @ (posedge sclk) begin
        if (rst == 1'b1) begin
            adc_data <= 12'd0;
        end else begin
            adc_data <= {adc_data[10:0], data_in_reg};
        end
    end

endmodule