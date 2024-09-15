`timescale 1 ns / 100 ps

module tb ();
    localparam DURATION = 1000000000;

    reg         clk = 0;
    reg         rst = 1;

    reg         s_data = 0;

    wire        s_clk;
    wire        cs;

    wire        red_led;
    wire        green_led;

    top #() uut (
        .clk(clk),
        .rst_btn(rst),
        .s_data(s_data),
        .s_clk(s_clk),
        .cs(cs),
        .green_led(green_led),
        .red_led(red_led)
    );

    initial begin
        #100
        rst = 1'b0;
        #500
        rst = 1'b1;
        #100;
    end

    always begin 
        #41.7

        clk = ~clk;
    end

    initial begin
		$dumpfile("top_tb.vcd"); //create sim output file
		$dumpvars(0, tb);
		$display("--------------------------------------------------");
		//Wait for sim to complete
		
		#(DURATION)
		
		$display("FINISHED");
		$finish;
	end

endmodule