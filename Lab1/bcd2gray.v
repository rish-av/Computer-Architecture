module bcd2gray_gate(b,f);
	input[3:0] b;
	output [3:0] f;
	xor(f[1],b[2],b[1]);
	xor(f[0],b[1],b[0]);
	or(f[2],b[2],b[3]);
	and(f[3],1,b[3]);
endmodule

module bcd2gray_dataflow(b,f);
	input [3:0] b;
	output [3:0] f;
	assign f[3] = b[3],f[2] = b[2] + b[3], f[1] = (~b[1])*b[2] + (~b[2])*b[1],f[0] = (~b[0])*b[1] + (~b[1])*b[0];
endmodule

module testbench;
	reg [3:0]b;
	wire [3:0]f;
	bcd2gray_gate check(b,f);
	//bcd2gray_dataflow check(b,f);
	initial
		begin
			$monitor($time," gate_level: b=%4b f=%4b",b,f);
			#0 b = 4'b0000;
			repeat(9)
				#1 b = b + 4'b0001;
		end
endmodule
