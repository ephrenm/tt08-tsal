`timescale 1 ns / 100 ps

module tb ();
    localparam DURATION = 1000000; //750 ms at 100kHz sclk for full data range

    reg         clk = 0;
    reg         rst = 0;

    reg         data_in = 0;

    wire        cs;
    wire        sclk;

    wire [11:0] adc_data;
    wire        data_ready;

    reg [15:0]  test_reg = 16'b0000111111111111;
    reg [3:0]   bit_counter = 4'd0;

    adc_controller #(
        .clk_speed(8000000),
        .sclk_speed(100000)
    ) uut (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .cs(cs),
        .sclk(sclk),
        .adc_data(adc_data),
        .data_ready(data_ready)
    );

    initial begin
        #10
        rst = 1'b1;
        #500
        rst = 1'b0;
        data_in = 1'b1;
    end

    always @ (negedge cs) begin
        data_in <= test_reg[15];
        bit_counter <= 4'd14;
    end

    always @ (posedge data_ready) begin
        if (adc_data != test_reg[11:0]) begin
            $display("ERROR at %h", test_reg);
        end else begin
            test_reg <= test_reg + 1;
        end
    end

    always @ (negedge sclk) begin
        if (bit_counter >= 4'd0) begin
            data_in = test_reg[bit_counter];
            bit_counter = bit_counter - 1;
        end
    end

    always begin 
        #62.5

        clk = ~clk;
    end

    initial begin
		$dumpfile("adc_controller_tb.vcd"); //create sim output file
		$dumpvars(0, tb);
		$display("--------------------------------------------------");
		//Wait for sim to complete
		
		#(DURATION)
		
		$display("FINISHED");
		$finish;
	end

endmodule