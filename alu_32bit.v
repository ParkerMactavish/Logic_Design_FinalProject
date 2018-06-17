module alu_32bit(in0, in1, c_in, alu_op, out, nzcv_out);
	input [31:0] in0, in1;
	input [3:0]  alu_op;
	input c_in;
	
	reg [31:0] alu_add_reg0, alu_add_reg1;
	reg alu_cin_reg;
	
	output reg [31:0]  out;
	output [3:0] nzcv_out;//in the order of negarive, zero, carry_out, overflow
	
	assign nzcv_out[3]=out[31];
	assign nzcv_out[2]=~(|out);
	assign nzcv_out[1]=alu_add_reg0+alu_add_reg1+alu_cin_reg;
	assign nzcv_out[0]=(~out[31])&(alu_add_reg0[31])&(alu_add_reg1[31]) |(out[31])&(~alu_add_reg0[31])&(~alu_add_reg1[31]);
	
	always@(*)begin
		case(alu_op)
			4'd0:begin//in0 and in1
				alu_add_reg0=32'd0;
				alu_add_reg1=32'd0;
				alu_cin_reg=1'b0;
				out=in0&in1;
			end
			
			4'd1:begin//in0 xor in1
				alu_add_reg0=32'd0;
				alu_add_reg1=32'd0;
				alu_cin_reg=1'b0;
				out=in0^in1;
			end
			
			4'd2:begin//in0  -  in1
				alu_add_reg0=in0;
				alu_add_reg1=~in1;
				alu_cin_reg=1'b1;				
				out=alu_add_reg0+alu_add_reg1+alu_cin_reg;
			end
			
			4'd3:begin//in1  -  in0
				alu_add_reg0=in1;
				alu_add_reg1=~in0;
				alu_cin_reg=1'b1;				
				out=alu_add_reg0+alu_add_reg1+alu_cin_reg;
			end
			
			4'd4:begin//in0  +  in1
				alu_add_reg0=in0;
				alu_add_reg1=in1;
				alu_cin_reg=1'b0;				
				out=alu_add_reg0+alu_add_reg1+alu_cin_reg;
			end	
			
			4'd5:begin//in0  +  in1  +  c_in
				alu_add_reg0=in0;
				alu_add_reg1=in1;
				alu_cin_reg=c_in;				
				out=alu_add_reg0+alu_add_reg1+alu_cin_reg;
			end
			
			4'd6:begin//in0  -  in1  +  c_in  -  1
				alu_add_reg0=in0;
				alu_add_reg1=~in1;
				alu_cin_reg=c_in;				
				out=alu_add_reg0+alu_add_reg1+alu_cin_reg;
			end
			
			4'd7:begin//in1  -  in0  +  c_in  -  1
				alu_add_reg0=in0;
				alu_add_reg1=~in1;
				alu_cin_reg=c_in;				
				out=alu_add_reg0+alu_add_reg1+alu_cin_reg;
			end			
			
			4'd8:begin//AND but not present???
				alu_add_reg0=32'd0;
				alu_add_reg1=32'd0;
				alu_cin_reg=1'b0;				
				out=in0&in1;
			end
			
			4'd9:begin//XOR but not present???				
				alu_add_reg0=32'd0;
				alu_add_reg1=32'd0;
				alu_cin_reg=1'b0;				
				out=in0^in1;
			end
			
			4'd10:begin//SUB but not present???				
				alu_add_reg0=in0;
				alu_add_reg1=~in1;
				alu_cin_reg=1'b1;				
				out=alu_add_reg0+alu_add_reg1+alu_cin_reg;
			end
			
			4'd11:begin//ADD but not present???
				alu_add_reg0=in0;
				alu_add_reg1=in1;
				alu_cin_reg=1'b0;				
				out=alu_add_reg0+alu_add_reg1+alu_cin_reg;
			end
			
			4'd12:begin//in0 or  in1
				out=in0|in1;
				alu_add_reg0=32'd0;
				alu_add_reg1=32'd0;
				alu_cin_reg=1'b0;
			end			
			
			4'd13:begin//in1(ignore in0)
				out=in1;
				alu_add_reg0=32'd0;
				alu_add_reg1=32'd0;
				alu_cin_reg=1'b0;
			end
			
			4'd14:begin//in0 and not in1
				out=in0&(~in1);
				alu_add_reg0=32'd0;
				alu_add_reg1=32'd0;
				alu_cin_reg=1'b0;
			end			
			
			4'd15:begin//not in1
				out=~in1;
				alu_add_reg0=32'd0;
				alu_add_reg1=32'd0;
				alu_cin_reg=1'b0;
			end
			
			default:begin
				out=32'd0;
				alu_add_reg0=32'd0;
				alu_add_reg1=32'd0;
				alu_cin_reg=1'b0;
			end
		endcase
	end

endmodule