module signextender(in,out);
	input[15:0] in;
	output[31:0] out;
	reg[31:0] out;
	reg sign;
	integer i=31;
	always@(in)
	begin
	sign = in[15];
	for(i=31;i>=16;i=i-1)
		out[i] = sign;
	out[15:0] = in[15:0];
	end
endmodule

module signtb;
	reg [15:0] in;
  	wire [31:0] out;
  	signextender se(in, out);
  	initial begin
    		$monitor($time, " :Input = %b,\t Output = %b.", in, out);
    			#0  in = 16'hF000;
    			#100  in = 16'h011;
    			#100  in = 16'h8310;
    			#100  in = 16'h9999;
    			#200  $finish;
 		end
endmodule
