module reg_file(clk, rst, pc_content, reg_write, link, read_addr_1, read_addr_2, read_addr_3, write_addr, write_data, pc_write, read_data_1, read_data_2, read_data_3);
	input clk, rst, reg_write, link;
	input[3:0] read_addr_1, read_addr_2, read_addr_3, write_addr;
	input[31:0] write_data, pc_content;
	
	output reg pc_write;
	output reg [31:0] read_data_1, read_data_2, read_data_3;
	
	reg[31:0] register[0:14];
	
	always@(posedge clk or posedge rst)begin
		if(rst)begin
			read_data_1<=32'd0;
			read_data_2<=32'd0;
			read_data_3<=32'd0;
		end
		else ;
		if(reg_write) register[write_addr]<=write_data;
		else;
		if(link) register[14]<=pc_content;
		else;
		if(read_addr_1<=4'd14) begin read_data_1=register[read_addr_1]; pc_write=1'b0;end
		else begin read_data_1=pc_content; pc_write=1'b1; end
		if(read_addr_2<=4'd14) begin read_data_2=register[read_addr_2]; pc_write=1'b0;end
		else begin read_data_2=pc_content; pc_write=1'b1; end
		if(read_addr_3<=4'd14) begin read_data_3=register[read_addr_3]; pc_write=1'b0;end
		else begin read_data_3=pc_content; pc_write=1'b1; end
	end
	
endmodule