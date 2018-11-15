module halfadder(a,b,o,c);
	input a,b;
	output o,c;
	wire x,y,z,m;
	nand(x,a,b);
	nand(y,x,a);
	nand(z,x,b);
	nand(o,y,z);
	nand(m,a,b);
	nand(c,1,m);
endmodule
module full_adder(a,b,cin,o,cout);
	input a,b,cin;
	output o,cout;
	wire x,y,z,w,m,n,p;
	nand#(10) n1(x,a,b);
	nand#(10) n2(y,x,a);
	nand#(10) n3(z,x,b);
	nand#(10) n4(w,y,z);
	nand#(10) n5(m,w,cin);
	nand#(10) n6(n,w,m);
	nand#(10) n7(p,m,cin);
	nand#(10) n8(cout,x,m);
	nand#(10) n9(o,p,n);
endmodule
module carry_adder(a,b,o,c);
	input[3:0] a;
	input[3:0] b;
	output[3:0] o;
	output c;
	wire[4:0] ct;
	wire[3:0] st;
	wire[3:0] g;
	wire[3:0] p;
	wire[3:0] x;
	full_adder f0(a[0],b[0],ct[0],st[0],x[0]);
	full_adder f1(a[1],b[1],ct[1],st[1],x[1]);
	full_adder f2(a[2],b[2],ct[2],st[2],x[2]);
	full_adder f3(a[3],b[3],ct[3],st[3],x[3]);
	assign g[0] = a[0] & b[0];
	assign g[1] = a[1] & b[1];
	assign g[2] = a[2] & b[2];
	assign g[3] = a[3] & b[3];
	
	assign p[0] = a[0] | b[0];
	assign p[1] = a[1] | b[1];
	assign p[2] = a[2] | b[2];
	assign p[3] = a[3] | b[3];
	
	assign ct[0] = 1'b0;
	assign ct[1] = g[0] | (p[0] & ct[0]);
	assign ct[2] = g[1] | (p[1] & ct[1]);
	assign ct[3] = g[2] | (p[2] & ct[2]);
	assign ct[4] = g[3] | (p[3] & ct[3]);
	
	assign c = ct[4];
	assign o = st;
endmodule
module rca(a,b,o,c);
	input[3:0] a,b;
	output[3:0] o;
	output c;
	wire[3:0] ripple;
	wire[3:0] sum;
	full_adder f1(a[0],b[0],1'b0,sum[0],ripple[0]);
	full_adder f2(a[1],b[1],ripple[0],sum[1],ripple[1]);
	full_adder f3(a[2],b[2],ripple[1],sum[2],ripple[2]);
	full_adder f4(a[3],b[3],ripple[2],sum[3],ripple[3]);
	
	assign c = ripple[3];
	assign o = sum;
endmodule

module nbitRca (a,b,o,c,check);
	input[7:0] a;
	input[7:0] b;
	input check;
	output[7:0] o;
	wire[7:0] sum;
	wire[7:0] ripple;
	output c;
	full_adder f1(a[0],b[0],1'b0,sum[0],ripple[0]);
	genvar i;
	generate
		for(i=1;i<8;i=i+1) begin
			full_adder f(a[i],b[i],ripple[i-1],sum[i],ripple[i]);
		end
	endgenerate
	assign c = ripple[7];
	assign o = sum;
endmodule
/*module testbench_halfadder;
	reg a,b;
	wire o,c;
	halfadder ha(a,b,o,c);
	initial
		begin
			$monitor($time," a=%1b,b=%1b,o=%1b,c=%1b",a,b,o,c);
			#0	a=1'b0;b=1'b0;
			#30	a=1'b0;b=1'b1;
			#30	a=1'b1;b=1'b0;
			#30	a=1'b1;b=1'b1;
		end	
endmodule*/

/*module testbench_fulladder;
	reg a,b,cin;
	wire o,cout;
	full_adder fa(a,b,cin,o,cout);
	initial
		begin
			$monitor($time," a=%1b,b=%1b,cin=%1b,o=%1b,cout=%1b",a,b,cin,o,cout);
			#0 	a=1'b0;b=1'b0;cin=1'b0;
			#100	a=1'b0;b=1'b0;cin=1'b1;
			#100	a=1'b0;b=1'b1;cin=1'b0;
			#100	a=1'b0;b=1'b1;cin=1'b1;
			#100	a=1'b1;b=1'b0;cin=1'b0;
			#100	a=1'b1;b=1'b0;cin=1'b1;
			#100	a=1'b1;b=1'b1;cin=1'b0;
			#100	a=1'b1;b=1'b1;cin=1'b1;
			#100 $finish;
		end	
endmodule*/

module testbench_complex_adder;
	reg[7:0] a;
	reg[7:0] b;
	wire[7:0] out;
	wire c;
	//carry_adder c1(a,b,out,c);
	//rca r1(a,b,out,c);
	nbitRca r1(a,b,out,c,1'b0);
	initial
		begin
			$monitor($time," a=%8b,b=%8b,out=%8b,c=%1b",a,b,out,c);
			#0	a=8'b00000000;b=8'b10001110;
			#200 a=8'b10000000;b=8'b11100001;
			#400 $finish;
		end
endmodule	
