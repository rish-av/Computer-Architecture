module comparator_behave(a,b,out);
	input[3:0] a;
	input[3:0] b;
	output[2:0] out;
	reg[2:0] out;
	always@(a or b)
		begin
			if(a>b) begin out = 3'b100; end
			else if(a<b) begin out = 3'b010; end
			else if(a==b) begin out = 3'b001; end
		end
endmodule

module comparator_dataflow(a,b,out);
	input[3:0] a;
	input[3:0] b;
	output[2:0] out;
	assign out[0] = a>b,out[1]=b>a,out[2]=a==b;
endmodule

module testbench;
	reg[3:0] a;
	reg[3:0] b;
	wire[2:0] o;
	comparator_behave c(a,b,o);
	initial
		begin
			$monitor($time," a = %3b, b=%3b,o=%3b",a,b,o);
			#0 a=3'b010;b=3'b000;
				repeat(3)
					begin
						#1 a=a+3'b001;b=b+3'b010;
					end
		end
endmodule
