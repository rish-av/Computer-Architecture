module PC(out,clk,reset);
	input clk,reset;
	output [31:0] out;
	reg[31:0] out;
	always@(posedge clk)
	begin
		if(~reset)
			out = out+1;
		else
			out=0;
	end
endmodule


/*module PCTb;
	reg  clk,reset;
	wire[31:0] w;
	PC test(w,clk,reset);
	initial
	begin
		$monitor($time,"count = %b",w);
		#0 clk = 1'b0;reset = 1'b1;
		#10 reset = 1'b0;
	end
	initial
	begin
	repeat(100)
		#5 clk = ~clk;
	end
endmodule*/
