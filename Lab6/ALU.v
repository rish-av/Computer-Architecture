module mux2to1(sel,out,in1,in2,in3);
	input in1,in2,in3;
	input[1:0] sel;
	output out;
	reg out;
	always@(in1 or in2 or in3 or sel)
	begin
		case(sel)
		2'b00:begin assign out = in1; end
		2'b01:begin assign out = in2; end
		2'b10:begin assign out = in3; end
		endcase
	end
endmodule

module mux8wide(sel,out,in1,in2,in3);
	input[7:0] in1,in2,in3;
	input[1:0] sel;
	output[7:0] out;
	genvar i;
	generate
	for(i=0;i<8;i=i+1)
	mux2to1 m1(sel,out[i],in1[i],in2[i],in3[i]);
	endgenerate
endmodule

module mux32wide(sel,out,in1,in2,in3);
	input[31:0] in1,in2,in3;
	output[31:0] out;
	input[1:0] sel;
	mux8wide m1(sel,out[31:24],in1[31:24],in2[31:24],in3[31:24]);
	mux8wide m2(sel,out[23:16],in1[23:16],in2[23:16],in3[23:16]);
	mux8wide m3(sel,out[15:8],in1[15:8],in2[15:8],in3[15:8]);
	mux8wide m4(sel,out[7:0],in1[7:0],in2[7:0],in3[7:0]);
endmodule

module bit32and(out,in1,in2);
	input[31:0] in1,in2;
	output[31:0] out;
	assign out = in1 & in2;
endmodule

module bit32or(out,in1,in2);
	input[31:0] in1,in2;
	output[31:0] out;
	assign out = in1 | in2;
endmodule

module fulladder(in1,in2,cin,cout,sum);
	input in1,in2,cin;
	output sum,cout;
	assign {cout,sum} = in1+in2+cin;
endmodule

module adder32bit(in1,in2,cin,out,cout);
	input[31:0] in1,in2;
	input cin;
	output[31:0] out;
	output cout;
	wire[31:0] carry;
	genvar i;
	fulladder f(in1[0],in2[0],cin,out[0],carry[0]); 
	generate
	for(i=1;i<32;i=i+1)
	fulladder f1(in1[i],in2[i],carry[i-1],out[i],carry[i]);
	endgenerate
endmodule

module negate(in1,out1);
	input[31:0] in1;
	output[31:0] out1;
	assign out1 = ~in1;
endmodule

module ALU(in1,in2,binv,cin,op,result,cout);
	input[31:0] in1,in2;
	input[1:0] op;
	input binv,cin;
	output[31:0] result;
	output cout;
	
	wire[31:0] out1;
	wire[31:0] out2;
	wire[31:0] out3;
	wire[31:0] neg;
	
	reg[31:0] in;
	always@(in1 or in2 or op)
	begin
	in = in2;
	if(binv) in = ~in2;
	end
	
	bit32or g1(out1,in1,in2);
	bit32and g2(out2,in1,in2);
	adder32bit g3(in1,in,cin,out3,cout);
	
	mux32wide m(op,result,out1,out2,out3);
endmodule

module controlALU(out,ALUOp0,ALUOp1,func);
 	input[5:0] func;
 	input ALUOp1,ALUOp0;
 	output[2:0] out;
 	assign  out[0] = ALUOp1 & (func[3]| func[0]);
	assign  out[1] = (~ALUOp1) | (~func[2]);
	assign  out[2] = ALUOp0 | (ALUOp1 & func[1]);
endmodule
