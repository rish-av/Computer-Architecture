module dff(clk,in,q,reset);
	input in,clk,reset;
	output q;
	reg q;
	always@(negedge clk)
	begin
	if(~reset) q =1'b0;
	else q =in;
	end
endmodule

module reg_32bit(q,d,clk,reset);
	input[31:0] d;
	output[31:0] q;
	input clk,reset;
	genvar i;
	generate
	for(i=0;i<32;i=i+1)
	dff d(clk,d[i],q[i],reset);
	endgenerate
endmodule

module mux4_1(out,q1,q2,q3,q4,reg_no);
	output[31:0] out;
	reg[31:0] out;
	input[31:0] q1,q2,q3,q4;
	input[1:0] reg_no;
	always@(q1 or q2 or q3 or q4 or reg_no)
	begin
	case(reg_no)
	2'b00: assign out = q1;
	2'b01: assign out = q2;
	2'b10: assign out = q3;
	2'b11: assign out = q4;
	endcase
	end
endmodule

module decoder2_4(register,reg_no);
	input[1:0] reg_no;
	output[3:0] register;
	reg[3:0] register;
	always@(reg_no)
	begin
	case(reg_no)
	2'b00: assign register = 4'b0001;
	2'b01: assign register = 4'b0010;
	2'b10: assign register = 4'b0100;
	2'b11: assign register = 4'b1000;
	endcase
	end
endmodule

module RegFile(clk,reset,ReadReg1,ReadReg2,WriteData,WriteReg,RegWrite,ReadData1,ReadData2);
	input clk, reset, RegWrite;
	input [1:0] ReadReg1, ReadReg2, WriteRegNo;
	input [31:0]  WriteData;
	output[31:0]  ReadData1, ReadData2;
	wire[31:0] w1,w2,w3,w4;
	wire c1,c2,c3,c4;
	wire[3:0] out;
	decoder2_4(WriteRegNo,out);
	assign c1 = clk&regwrite&out[0];
	assign c2 = clk&regwrite&out[1];
	assign c3 = clk&regwrite&out[2];
	assign c4 = clk&regwrite&out[3];
	reg_32bit r1(w1,WriteData,c1,reset);
	reg_32bit r2(w2,WriteData,c2,reset);
	reg_32bit r3(w3,WriteData,c3,reset);
	reg_32bit r4(w4,WriteData,c4,reset);
	mux4_1 m1(ReadData1,w1,w2,w3,w4,ReadReg1);
	mux4_1 m2(ReadData2,w1,w2,w3,w4,ReadReg2);
endmodule
module testbencRF;
endmodule
/*module tb32reg;
	reg [31:0] d;
	reg clk,reset;
	wire [31:0] q;
	reg_32bit R(q,d,clk,reset);	
	initial
	begin
		$monitor($time,"d=%b,q=%b",d,q);
		#0 clk= 1'b1;reset=1'b0;//reset the register
		#20 reset=1'b1;
		#20 d=32'hAFAFAFAF;
		#200 $finish;
	end
	always @(clk)
	#5 clk<=~clk;
endmodule*/
