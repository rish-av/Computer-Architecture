module mux5bitwide(a,b,sel,out);
	output[4:0] out;
	reg[4:0] out;
	input[4:0] a,b;
	input sel;
	always@(a or b or sel)
	begin
	if(sel)
		out<=b;
	else
		out<=a;
	end
endmodule
