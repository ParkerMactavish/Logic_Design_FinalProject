module ins_mem(pc, ins);
	
	input [31:0] pc;
	output [31:0] ins;
	
	parameter INS_MEM_SIZE=32;
	
	reg [31:0] mem[0:INS_MEM_SIZE-1];
	
	assign ins=mem[pc[31:2]];
	
endmodule