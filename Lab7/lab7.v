module multicycleControl(op,state,nextstate,pcwrite,pcwritecon,iord,memread,memwrite,irwrite,mem2reg,pcsource,aluop,alusrc,regwrite,regdst);
	input[5:0] op;
	input[3:0] state;
	output[3:0] nextstate;
	output[1:0] aluop;
	output[1:0] alusrc;
	output pcwrite,pcwritecon,iord,memread,memwrite,irwrite,mem2reg,pcsource,regwrite,regdst;
	pcwrite = ((~state[0])&(~state[1])&(~state[2])&(~state[3])) | ((state[0])&(~state[2])&(~state[1]));
endmodule
//PLA is given rest signals can be written in similar fashion
