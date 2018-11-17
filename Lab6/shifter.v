module shifter32(in,out);
	input[31:0] in;
	output[31:0] out;
	assign out = {in[31:2],1'b0,1'b0};
endmodule

module left_shift(in,out);
	output[27:0] out;
	input[25:0] in;
	assign out[27:2] = in[25:0];
	assign out[0] = 1'b0;
	assign out[1] = 1'b0;
endmodule

/*module left_tb;
	reg[25:0] in;
	wire[27:0] out;
	left_shift l(in,out);
	initial
	begin
		$monitor($time,"in=%b out=%b",in,out);
		#0 in=26'b00000000000011110000111100;
		#1 in=26'b10000000000011110000111111;
		#2 $finish;
	end
endmodule*/
