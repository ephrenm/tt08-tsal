module comparator (
  input wire		clk,
  input wire		rst,
  
  input wire		data_ready,
  input wire [7:0]  data,
  
  input wire [7:0]	in,
  
  output reg		red_enable,
  output reg		green_enable
);
  
  reg [7:0]			comp_reg;
  reg [7:0]			input_reg;
  
  always @ (posedge clk) begin
    if (rst == 1'b1) begin
      red_enable <= 1'b0;
      green_enable <= 1'b0;
      comp_reg <= 8'd0;
      input_reg <= 8'd0;
    end else if (data_ready == 1'b1) begin
      comp_reg <= data;
      input_reg <= in;
    end
    
    if (comp_reg >= input_reg) begin
      red_enable <= 1'b1;
      green_enable <= 1'b0;
    end else begin
      green_enable <= 1'b1;
      red_enable <= 1'b0;
    end
  end
  
  
endmodule
