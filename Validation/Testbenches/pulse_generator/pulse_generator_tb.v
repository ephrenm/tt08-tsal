`timescale 1 ns / 100 ps

module tb ();
    localparam DURATION = 1000000000;

    reg         clk = 0;
    reg         rst = 0;

    reg         red_ctrl = 0;
    reg         green_ctrl = 0;

    wire        green_led;
    wire        red_led;

    pulse_generator #() uut (
        .clk(clk),
        .rst(rst),
        .red_ctrl(red_ctrl),
        .green_ctrl(green_ctrl),
        .red_led(red_led),
        .green_led(green_led)
    );

    initial begin
        rst = 1'b1;
        #500
        rst = 1'b0;
        #10
        red_ctrl = 1'b1;
        green_ctrl = 1'b0;
        #800000000
        red_ctrl = 1'b0;
        green_ctrl = 1'b1;
    end

    always begin 
        #62.5

        clk = ~clk;
    end

    initial begin
		$dumpfile("pulse_generator_tb.vcd"); //create sim output file
		$dumpvars(0, tb);
		$display("--------------------------------------------------");
		//Wait for sim to complete
		
		#(DURATION)
		
		$display("FINISHED");
		$finish;
	end

endmodule

