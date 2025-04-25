module ALU (
	input [7:0] a, b, 
	input pass, add, 
	output reg[7:0] alu_out 
);
	
	
 always @(a or b or pass or add)
	if (pass) alu_out = a;
	else if (add) alu_out = a + b;
	else alu_out = 0;
 
endmodule