module PC (input [5:0] data_in,
				input load, inc, clr, clk, 
				output reg [5:0] data_out 
);

 always @(posedge clk)
	if (clr) data_out <= 6'b000000;
	else if (load) data_out <= data_in;
	else if (inc) data_out <= data_out + 1;

endmodule