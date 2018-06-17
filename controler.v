module controller(opfunc, nzcv, reg_write, alu_src, alu_op, mem_to_reg, mem_write, pc_src, update_nzcv, link);
	input  [11:0] opfunc;
	input  [3:0]  nzcv;
	
	output reg [1:0]  alu_src;
	output reg [3:0]  alu_op;
	output reg reg_write, mem_to_reg, mem_write, pc_src, update_nzcv, link;

	reg condition;
	
	always@(*)begin
		case(opfunc[11:8])
			4'd0:condition=nzcv[2];
			4'd1:condition=~nzcv[2];
			4'd2:condition=nzcv[1];
			4'd3:condition=~nzcv[1];
			4'd4:condition=nzcv[3];
			4'd5:condition=~nzcv[3];
			4'd6:condition=nzcv[0];
			4'd7:condition=~nzcv[0];
			
			4'd8:condition=(~nzcv[2])&nzcv[1];
			4'd9:condition=nzcv[2]|(~nzcv[1]);
			4'd10:condition=nzcv[3]^nzcv[0];
			4'd11:condition=~(nzcv[3]^nzcv[0]);
			4'd12:condition=~((nzcv[3]^nzcv[0])+nzcv[2]);
			4'd13:condition=(nzcv[3]^nzcv[0])&nzcv[2];
			4'd14:condition=1'b1;
			4'd15:condition=1'b1;
		endcase
	end
	always@(*)begin
		if(~condition)begin
			alu_src=2'b00;
			alu_op=4'b0000;
			reg_write=1'b0;
			mem_to_reg=1'b0;
			mem_write=1'b0;
			pc_src=1'b0;
			update_nzcv=1'b0;
			link=1'b0;
		end
		else begin
			case(opfunc[7:0])
				8'b101x_xxxx:begin
					alu_op=4'b0000;
					alu_src=2'b00;
					reg_write=1'b0;
					mem_to_reg=1'b0;
					mem_write=1'b0;
					pc_src=1'b1;
					update_nzcv=1'b0;
					link=opfunc[4];
				end
				
				8'b0000_xxxx:begin
					alu_op=opfunc[4:1];
					alu_src=2'b00;
					reg_write=1'b1;
					mem_to_reg=1'b0;
					mem_write=1'b0;
					pc_src=1'b0;
					update_nzcv=opfunc[0];
					link=1'b0;
				end
				
				8'b0001_0xxx:begin
					alu_op=opfunc[4:1];
					alu_src=2'b00;
					reg_write=1'b0;
					mem_to_reg=1'b0;
					mem_write=1'b0;
					pc_src=1'b0;
					update_nzcv=opfunc[0];
					link=1'b0;
				end
				
				8'b0001_1xxx:begin
					alu_op=opfunc[4:1];
					alu_src=2'b00;
					reg_write=1'b1;
					mem_to_reg=1'b0;
					mem_write=1'b0;
					pc_src=1'b0;
					update_nzcv=opfunc[0];
					link=1'b0;
				end
				
				8'b0010_xxxx:begin
					alu_op=opfunc[4:1];
					alu_src=2'b00;
					reg_write=1'b1;
					mem_to_reg=1'b0;
					mem_write=1'b0;
					pc_src=1'b0;
					update_nzcv=opfunc[0];
					link=1'b0;
				end
				
				8'b0011_0xxx:begin
					alu_op=opfunc[4:1];
					alu_src=2'b00;
					reg_write=1'b1;
					mem_to_reg=1'b0;
					mem_write=1'b0;
					pc_src=1'b0;
					update_nzcv=opfunc[0];
					link=1'b0;
				end
				
				8'b0011_1xxx:begin
					alu_op=opfunc[4:1];
					alu_src=2'b00;
					reg_write=1'b1;
					mem_to_reg=1'b0;
					mem_write=1'b0;
					pc_src=1'b0;
					update_nzcv=opfunc[0];
					link=1'b0;
				end
				
				8'b010x_0xxx:begin
					alu_op=4'b0010;
					alu_src=2'b11;
					reg_write=opfunc[0];
					mem_to_reg=1'b1;
					mem_write=~opfunc[0];
					pc_src=1'b0;
					update_nzcv=1'b0;
					link=1'b0;
				end
				
				8'b010x_1xxx:begin
					alu_op=4'b0100;
					alu_src=2'b11;
					reg_write=opfunc[0];
					mem_to_reg=1'b1;
					mem_write=~opfunc[0];
					pc_src=1'b0;
					update_nzcv=1'b0;
					link=1'b0;
				end
				
				8'b011x_0xxx:begin
					alu_op=4'b0010;
					alu_src=2'b10;
					reg_write=opfunc[0];
					mem_to_reg=1'b1;
					mem_write=~opfunc[0];
					pc_src=1'b0;
					update_nzcv=1'b0;
					link=1'b0;
				end
				
				8'b011x_1xxx:begin
					alu_op=4'b0100;
					alu_src=2'b10;
					reg_write=opfunc[0];
					mem_to_reg=1'b1;
					mem_write=~opfunc[0];
					pc_src=1'b0;
					update_nzcv=1'b0;
					link=1'b0;
				end
				
				default:	begin
					alu_op=4'b0000;
					alu_src=2'b00;
					reg_write=1'b0;
					mem_to_reg=1'b0;
					mem_write=1'b0;
					pc_src=1'b0;
					update_nzcv=1'b0;
					link=1'b0;
				end
				
				/*8'b0000_000x:begin
					alu_op=opfunc[4:1];
					alu_src=2'b00;
					reg_write=1'b1;
					mem_to_reg=1'b0;
					mem_write=1'b0;
					pc_src=1'b0;
					update_nzcv=opfunc[0];
					link=1'b0;
				end
				
				8'b0000_001x:begin
					alu_op=opfunc[4:1];
					alu_src=2'b00;
					reg_write=1'b1;
					mem_to_reg=1'b0;
					mem_write=1'b0;
					pc_src=1'b0;
					update_nzcv=opfunc[0];
					link=1'b0;
				end
				
				8'b0000_010x:begin
					alu_op=opfunc[4:1];
					alu_src=2'b00;
					reg_write=1'b1;	
					mem_to_reg=1'b0;
					mem_write=1'b0;
					pc_src=1'b0;
					update_nzcv=opfunc[0];
					link=1'b0;
				end
				
				8'b0000_011x:begin
					alu_op=opfunc[4:1];
					alu_src=2'b00;
					reg_write=1'b1;
					mem_to_reg=1'b0;
					mem_write=1'b0;	
					pc_src=1'b0;
					update_nzcv=opfunc[0];	
					link=1'b0;
				end
				
				8'b0000_100x:begin
					alu_op=opfunc[4:1];
					alu_src=2'b00;
					reg_write=1'b1;
					mem_to_reg=1'b0;
					mem_write=1'b0;
					pc_src=1'b0;
					update_nzcv=opfunc[0];
					link=1'b0;
				end
				
				8'b0000_101x:
					alu_op=opfunc[4:1];
					alu_src=2'b00;
					reg_write=1'b1;
					1'b0	1'b0	1'b0	opfunc[0]	1'b0
				8'b0000_110x	opfunc[4:1]	2'b00	1'b1	1'b0	1'b0	1'b0	opfunc[0]	1'b0
				8'b0000_111x	opfunc[4:1]	2'b00	1'b1	1'b0	1'b0	1'b0	opfunc[0]	1'b0
				8'b0001_000x	opfunc[4:1]	2'b00	1'b0	1'b0	1'b0	1'b0	opfunc[0]	1'b0
				8'b0001_001x	opfunc[4:1]	2'b00	1'b0	1'b0	1'b0	1'b0	opfunc[0]	1'b0
				8'b0001_010x	opfunc[4:1]	2'b00	1'b0	1'b0	1'b0	1'b0	opfunc[0]	1'b0
				8'b0001_011x	opfunc[4:1]	2'b00	1'b0	1'b0	1'b0	1'b0	opfunc[0]	1'b0
				8'b0001_100x	opfunc[4:1]	2'b00	1'b1	1'b0	1'b0	1'b0	opfunc[0]	1'b0
				8'b0001_101x	opfunc[4:1]	2'b00	1'b1	1'b0	1'b0	1'b0	opfunc[0]	1'b0
				8'b0001_110x	opfunc[4:1]	2'b00	1'b1	1'b0	1'b0	1'b0	opfunc[0]	1'b0
				8'b0001_111x	opfunc[4:1]	2'b00	1'b1	1'b0	1'b0	1'b0	opfunc[0]	1'b0
				8'b0010_000x	opfunc[4:1]	2'b00	1'b1	1'b0	1'b0	1'b0	opfunc[0]	1'b0
				8'b0010_001x	opfunc[4:1]	2'b00	1'b1	1'b0	1'b0	1'b0	opfunc[0]	1'b0
				8'b0010_010x	opfunc[4:1]	2'b00	1'b1	1'b0	1'b0	1'b0	opfunc[0]	1'b0
				8'b0010_011x	opfunc[4:1]	2'b00	1'b1	1'b0	1'b0	1'b0	opfunc[0]	1'b0
				8'b0010_100x	opfunc[4:1]	2'b00	1'b1	1'b0	1'b0	1'b0	opfunc[0]	1'b0
				8'b0010_101x	opfunc[4:1]	2'b00	1'b1	1'b0	1'b0	1'b0	opfunc[0]	1'b0
				8'b0010_110x	opfunc[4:1]	2'b00	1'b1	1'b0	1'b0	1'b0	opfunc[0]	1'b0
				8'b0010_111x	opfunc[4:1]	2'b00	1'b1	1'b0	1'b0	1'b0	opfunc[0]	1'b0
				8'b0011_000x	opfunc[4:1]	2'b00	1'b0	1'b0	1'b0	1'b0	opfunc[0]	1'b0
				8'b0011_001x	opfunc[4:1]	2'b00	1'b0	1'b0	1'b0	1'b0	opfunc[0]	1'b0
				8'b0011_010x	opfunc[4:1]	2'b00	1'b0	1'b0	1'b0	1'b0	opfunc[0]	1'b0
				8'b0011_011x	opfunc[4:1]	2'b00	1'b0	1'b0	1'b0	1'b0	opfunc[0]	1'b0
				8'b0011_100x	opfunc[4:1]	2'b00	1'b1	1'b0	1'b0	1'b0	opfunc[0]	1'b0
				8'b0011_101x	opfunc[4:1]	2'b00	1'b1	1'b0	1'b0	1'b0	opfunc[0]	1'b0
				8'b0011_110x	opfunc[4:1]	2'b00	1'b1	1'b0	1'b0	1'b0	opfunc[0]	1'b0
				8'b0011_111x	opfunc[4:1]	2'b00	1'b1	1'b0	1'b0	1'b0	opfunc[0]	1'b0*/
			endcase
		end
	end
endmodule