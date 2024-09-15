`timescale 1 ns / 100 ps

module tb ();

    localparam DURATION = 1000000;

    reg         clk = 0;
    reg         rst = 0;

    reg         data_ready = 1'b0;
    reg [7:0]   data = 8'd0;
    reg [7:0]   comparison_value = 8'd100;

    wire red_enable;
    wire green_enable;

    comparator #() uut (
        .clk(clk),
        .rst(rst),
        .data_ready(data_ready),
        .data(data),
        .in(comparison_value),
        .red_enable(red_enable),
        .green_enable(green_enable)
    );

    integer i;

    initial begin
        #100
        rst = 1'b1;
        #500
        rst = 1'b0;
        #100

        for (i = 8'd0; i < 256; i = i + 1) begin
            data = i;
            data_ready = 1'b1;
            #250
            data_ready = 1'b0;
            #250;
        end
    end

    always begin 
        #62.5

        clk = ~clk;
    end

    initial begin
		$dumpfile("comparator_tb.vcd"); //create sim output file
		$dumpvars(0, tb);
		$display("--------------------------------------------------");
		//Wait for sim to complete
		
		#(DURATION)
		
		$display("FINISHED");
		$finish;
	end

endmodule