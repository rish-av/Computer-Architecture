module encoder(in,out);
	input[7:0] in;
	output[2:0] out;
	reg[2:0] out;
	always@(in)
	begin
		if(in[7]) out = 3'd0;
		else if(in[6]) out = 3'd1;
		else if(in[5]) out = 3'd2;
		else if(in[4]) out = 3'd3;
		else if(in[3]) out = 3'd4;
		else if(in[2]) out = 3'd5;
		else if(in[1]) out = 3'd6;
		else if(in[0]) out = 3'd7;
	end 
endmodule

module support_reg1(clk,ctrl,a,b,aout,bout,ctrlout);
	input[3:0] a,b;
	input clk;
	input[2:0] ctrl;
	output[3:0] aout,bout;
	output[2:0] ctrlout;
	reg[3:0] aout,bout;
	reg[2:0] ctrlout;
	always@(posedge clk)
	begin
		aout <= a;
		bout <= b;
		ctrlout <= ctrl;
	end	
endmodule

module support_reg2(clk,x,xout);
	input clk;
	input[3:0] x;
	output[3:0] xout;
	reg[3:0] xout;
	always@(posedge clk)
		xout = x;
endmodule


module ALU(a,b,ctrl,aluout);
	input[3:0] a,b;
	input[2:0] ctrl;
	output[3:0] aluout;
	reg[3:0] aluout;
	always@(a or b or ctrl)
	begin
		case(ctrl)
		3'b000 : aluout = a+b;
		3'b001 : aluout = a-b;
		3'b010 : aluout = a^b;
		3'b011 : aluout = a|b;
		3'b100 : aluout = a & b;
		3'b101 : aluout = ~(a|b);
		3'b110 : aluout = ~(a&b);
		3'b111 : aluout = ~(a^b);
		endcase
	end
endmodule

module paritygenerator(in,out);
	input[3:0] in;
	output out;
	assign out = ~(in[0]^in[1]^in[2]^in[3]);
endmodule


module datapath(clk,opcode,a,b,out);
	input clk;
	input [7:0] opcode;
	input [3:0] a,b;
	output out;
	wire[2:0] ctrl,ctrlout;
	wire[3:0] aout,bout;
	wire[3:0] aluout,aluout2;
	
	encoder e(opcode,ctrl);
	support_reg1 s1(clk,ctrl,a,b,aout,bout,ctrlout);
	ALU a1(aout,bout,ctrlout,aluout);
	support_reg2 s2(clk,aluout,aluout2);
	paritygenerator p1(aluout2,out);
endmodule

module test;
	reg clk;
	reg[7:0] opcode;
	reg[3:0] a,b;
	wire out;
	datapath d(clk,opcode,a,b,out);
	initial
	begin
		$monitor($time," :a=%b opcode=%b ctrl=%b aluout=%b b=%b out=%b",a,opcode,d.ctrl,d.aluout,b,out);
		#0 clk = 1'b1;
		#5 a = 4'b0101; b = 4'b0111;  opcode = 8'b10000000;
		#20 opcode = 8'b01000000;
    		#20 opcode = 8'b00100000;
	     #20 opcode = 8'b00010000;
	     #20 opcode = 8'b00001000;
	     #20 opcode = 8'b00000100;
	     #20 opcode = 8'b00000010;
	     #20 opcode = 8'b00000001;
	     #50 $finish;
	end
	always
		#2 clk = ~clk;
endmodule	








