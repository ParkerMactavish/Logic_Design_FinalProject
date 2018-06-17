module ARM(rst, clk);
	input rst, clk;//reset and clock
	
	reg [31:0]	pc;//PC register namely R15
	
	reg [3:0]	nzcv_reg;//nzcv register
	
	wire 	reg_write,//controler to reg_file
			link,//controler to reg_file
			pc_write,//reg_file to pc branch mux
			update_nzcv,//controler to nzcv_mux
			mem_write,//controler to data_mem
			mem_to_reg,//controler to mem_to_reg_mux
			pc_src;//controler to pc branch mux
			
	wire [1:0]  alu_src;//controler out to mux_of_alu_32bit
	
	wire [3:0] 	alu_op,//controler out to alu_32bit
					alu_nzcv_out;//alu_32bit out to nzcv_mux
	
	reg  [3:0] 	next_nzcv;//nzcv_mux out to nzcv_reg
			
	wire [31:0]	pc_add_4, //pc_adder_by_4 out to pc_branch
					mem_read_data,//memory read data from data_mem to mem_to_reg_mux
					instruction,//instruction from ins_mem to everywhere
					reg_read_data_1,//reg_file to alu_32bit
					reg_read_data_2,//reg_file to shifter
					reg_read_data_3,//reg_file to data_mem
					sign_extend_im_out,//multi_4 out to multi_4_adder
					multi_4_adder_out,//multi_4_adder out to branch
					alu_32bit_out;//alu_32bit out to everywhere
					
	reg  [31:0] next_pc,//pc_branch to pc
					shift_out,//shifter out to mux_of_alu_32bit
					unsign_extend_im_out,//unsign_extend out to mux_of_alu_32bit
					rotate_im_out, //rotate out to mux_of_alu_32bit
					mux_of_alu_32bit_out,//mux_of_alu_32bit out to alu_32bit
					mem_to_reg_out;//mem_to_reg_mux to reg_file
					
					
	assign pc_add_4=pc+32'd4;//adder of pc
	
	assign multi_4_adder_out=sign_extend_im_out+pc_add_4;
	
	
	ins_mem _ins_mem(.pc(pc), .ins(instruction));
	
	data_mem _data_mem(.clk(clk), .rst(rst), .addr(alu_32bit_out), .write_data(reg_read_data_3), .mem_write(mem_write), .read_data(mem_read_data));
	
	reg_file _reg_file(.clk(clk), .rst(rst), .pc_content(pc_add_4), .reg_write(reg_write), .link(link), .read_addr_1(instruction[19:16]), .read_addr_2(instruction[3:0]), .read_addr_3(instruction[15:12]), .write_addr(instruction[15:12]), .write_data(mem_to_reg_out), .pc_write(pc_write), .read_data_1(reg_read_data_1), .read_data_2(reg_read_data_2), .read_data_3(reg_read_data_3));
	
	multi_4 _multi_4(.sign_immediate_in(instruction[23:0]), .sign_extend_immediate_out(sign_extend_im_out));
	
	//branch mux for next_pc
	always@(*)begin
		case({pc_write, pc_src})
			2'b00: next_pc=pc_add_4;
			2'b01: next_pc=multi_4_adder_out;
			default: next_pc=alu_32bit_out;
		endcase/*not done yet*/
	end
	
	//PC reg assign
	always@(posedge clk or posedge rst)begin
		if(rst) pc<=32'd0;
		else pc<=next_pc;
	end
	
	//shifter
	always@(*)begin
		case(instruction[6:5])//shift type is instruction[6:5], shift number is instruction[11:7]
			2'b00: shift_out=(reg_read_data_2<<instruction[11:7]);//logical left
			2'b01: shift_out=(reg_read_data_2>>instruction[11:7]);//lofical right
			2'b10: shift_out=($signed(reg_read_data_2)>>>instruction[11:7]);//arithmatical right
			2'b11: shift_out=(reg_read_data_2>>instruction[11:7])|(reg_read_data_2<<(6'd32-instruction[11:7]));//rotary right
			default: shift_out=(reg_read_data_2<<instruction[11:7]);
		endcase
	end
	
	//unsign_extend
	always@(*)begin
		unsign_extend_im_out={20'd0, instruction[11:0]};
	end
	
	//rotate
	always@(*)begin
		rotate_im_out=({24'd0, instruction[7:0]}>>(instruction[11:8]*2'd2))|({24'd0, instruction[7:0]}<<((6'd32-instruction[11:8])*2'd2));
	end
	
	//mux_of_alu_32bit
	always@(*)begin
		case(alu_src)
			2'b00:mux_of_alu_32bit_out=shift_out;
			2'b01:mux_of_alu_32bit_out=rotate_im_out;
			2'b10:mux_of_alu_32bit_out=shift_out;
			2'b11:mux_of_alu_32bit_out=unsign_extend_im_out;
		endcase
	end
	
	//alu_32bit
	alu_32bit _alu_32bit(.in0(reg_read_data_1), .in1(mux_of_alu_32bit_out), .c_in(nzcv_reg[1]), .alu_op(alu_op), .out(alu_32bit_out), .nzcv_out(alu_nzcv_out));
	
	//nzcv_mux
	always@(*)begin
		case(update_nzcv)
			1'b0:next_nzcv=nzcv_reg;
			1'b1:next_nzcv=alu_nzcv_out;
			default:next_nzcv=4'd0;
		endcase
	end
	
	//nzcv_reg
	always@(posedge clk or posedge rst)begin
		if(rst) nzcv_reg<=4'd0;
		else nzcv_reg<=next_nzcv;
	end
	
	//mem_to_reg_mux
	always@(*)begin
		if(~mem_to_reg)	mem_to_reg_out=alu_32bit_out;
		else mem_to_reg_out=mem_read_data;
	end
	
	controller _controller(.opfunc(instruction[31:20]), .nzcv(nzcv_reg), .reg_write(reg_write), .alu_src(alu_src), .alu_op(alu_op), .mem_to_reg(mem_to_reg), .mem_write(mem_write), .pc_src(pc_src), .update_nzcv(update_nzcv), .link(link));
							
endmodule
