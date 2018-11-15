module dff(clk,in,q,reset);
	input clk,in,reset;
	output q;
	reg q;
	always@(posedge clk)
	begin
	if(!reset) q<=1'b0;
	else q<=in;
	end
endmodule

module shiftreg(EN, in, CLK, Q);
	input EN;
	input in;
	input CLK;
	output [3:0] Q;
	reg [3:0] Q;
	initial
		Q=4'd10;
	always @(posedge CLK)
	begin
	if (EN)
		Q={in,Q[3:1]};
	end
endmodule

module shiftregtest;
	reg EN,in , CLK;
	wire [3:0] Q;
	shiftreg shreg(EN,in,CLK,Q);
	initial
	begin
		CLK=0;
	end
	always
		#2 CLK=~CLK;
	initial
		begin
			$monitor($time," EN=%b in= %b Q=%b\n",EN,in,Q);
			in=0;EN=0;
			#4 in=1;EN=1;
			#4 in=1;EN=0;
			#4 in=0;EN=1;
			#5 $finish;
		end
endmodule
