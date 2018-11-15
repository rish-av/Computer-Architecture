module DECODER(d0,d1,d2,d3,d4,d5,d6,d7,x,y,z);	
	input x,y,z;
	output d0,d1,d2,d3,d4,d5,d6,d7;
	wire x0,y0,z0;
	not n1(x0,x);
	not n2(y0,y);
	not n3(z0,z);
	and a0(d0,x0,y0,z0);
	and a1(d1,x0,y0,z);
	and a2(d2,x0,y,z0);
	and a3(d3,x0,y,z);
	and a4(d4,x,y0,z0);
	and a5(d5,x,y0,z);
	and a6(d6,x,y,z0);
	and a7(d7,x,y,z);
endmodule

module FADDER(s,c,x,y,z);
	input x,y,z;
	wire d0,d1,d2,d3,d4,d5,d6,d7;
	output s,c;
	DECODER dec(d0,d1,d2,d3,d4,d5,d6,d7,x,y,z);
	assign s = d1 | d2 | d4 | d7,
		  c = d3 | d5 | d6 | d7;
endmodule

module eight_bitadder(a,b,z,o,c);
	input[7:0] a,b;
	input z;
	output[7:0] o;
	output c;
	wire[8:0] carry;
	wire[7:0] sum;
	assign carry[0] = z;
	FADDER f0(sum[0],carry[1],a[0],b[0],carry[0]);
	genvar i;
	generate
	for(i=1;i<8;i=i+1) begin
		FADDER f(sum[i],carry[i+1],a[i],b[i],carry[i]);
	end
	endgenerate
	assign o=sum;
	assign c=carry[8];
endmodule

module byte_adder(a,b,z,o,c);
	input[31:0] a,b;
	input z;
	output[31:0] o;
	output c;
	wire[4:0] carry;
	assign carry[0] = z;
	eight_bitadder a1(a[31:24],b[31:24],carry[0],o[31:24],carry[1]);
	eight_bitadder a2(a[23:16],b[23:16],carry[1],o[23:16],carry[2]);
	eight_bitadder a3(a[15:8],b[15:8],carry[2],o[15:8],carry[3]);
	eight_bitadder a4(a[7:0],b[7:0],carry[3],o[7:0],carry[4]);
	assign c = carry[4];
endmodule
		
module testbench;
	reg[31:0] a,b;
	wire[31:0] out;
	wire c;
	byte_adder b1(a,b,1'b0,out,c);
	initial
		begin
			$monitor($time," a=%32b b=%32b out=%32b c=%1b",a,b,out,c);
			#0 a=32'b00000000000000000000000000000000;b=32'b00010001000100010001000100010001;
			#100	 a=32'b11110000000000000000000000000000;b=32'b00100010001000100010001000100010;
			#200 $finish;
		end
endmodule
	
	
	
