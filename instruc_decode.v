module mux2(in0,in1,select,out);
input[31:0] in0,in1;
input select;
output[31:0] out;
reg[31:0] out;
always @(*)
		begin
		case(select)
		0:out<=in0;
		1:out<=in1;
		endcase
		end
endmodule

/*module test;
reg[31:0] in0,in1;
reg select;
wire[31:0] out;
mux2 m(in0,in1,select,out);
initial begin
$monitor("%d %d %d %d",in0,in1,select,out);
in0 = 0;in1 = 1;select = 0;
#5 select = 1;
end
endmodule*/

module mux4(in0,in1,in2,in3,select,out);
input[31:0] in0,in1,in2,in3;
input[1:0] select;
output[31:0] out;
reg[31:0] out;
always@(*)
		begin
		case(select)
0:out<=in0;
1:out<=in1;
2:out<=in2;
3:out<=in3;
endcase
		end
endmodule

/*module test;
reg[31:0] in0,in1,in2,in3;
reg[1:0] select;
wire[31:0] out;
mux4 m(in0,in1,in2,in3,select,out);
initial begin
$monitor("%d %d %d %d %d %d",in0,in1,in2,in3,select,out);
in0 = 0;in1=1;in2= 2;in3=3;select = 0;
#5 select = 1;
#5 select = 2;
#5 select = 3;
end
endmodule*/

module decoder(in,sext_select);
input[6:0] in;
output[2:0] sext_select;
reg[2:0] sext_select;
always @(*)
		begin
		case(in)
		19:sext_select<=0;//i-imm
		3:	sext_select <= 0;//i-imm
		103:sext_select<=0;
		23:sext_select<=2;
		//107:sext_select<=1;
		55:sext_select<=2;//u imm
		35:sext_select<=3;//s-imm
		111:sext_select <= 4;//j-imm
		99:sext_select<=1;//b-imm
		default:sext_select<=0;
		endcase
		end
endmodule

/*module test;
reg[6:0] in;
wire[2:0] sext_select;
decoder d(in,sext_select);
initial begin
$monitor("%d %d",in,sext_select);
in = 0010011;
#5 in = 1100011;
#5 in = 0110111;
#5 in = 0010111;
#5 in = 1101111;
#5 in = 0100011;
end
endmodule*/

module sext(ir2,sext_select,sextended_value);
input[31:0] ir2;
input[2:0] sext_select;
output[31:0] sextended_value;
reg[31:0] sextended_value;
always @(*)
		begin
		case(sext_select)
		0: sextended_value<= {{21{ir2[31]}},ir2[30:25],ir2[24:21],ir2[20]}; //I-imm 
		1: sextended_value<= {{20{ir2[31]}},ir2[7],ir2[30:25],ir2[11:8],1'b0};//B-imm
		2: sextended_value<= {ir2[31],ir2[30:20],ir2[19:12],{12{1'b0}}};//U-imm
		3: sextended_value<= {{21{ir2[31]}},ir2[30:25],ir2[11:8],ir2[7]};//S-imm
		4: sextended_value<= {{12{ir2[31]}},ir2[19:12],ir2[20],ir2[30:25],ir2[24:21],1'b0};//J -imm
		endcase
		end
endmodule

/*module test;
reg[31:0] ir2;
wire[31:0] out;
reg[2:0] sext_select;
sext s(ir2,sext_select,out);
initial begin
$monitor("%d %b %d",ir2,out,sext_select);
ir2 = 1;
ir2[31] = 1'b1;
sext_select = 0;
#5 sext_select = 1;
#5 sext_select = 2;
#5 sext_select = 3;
#5 sext_select = 4;
end
endmodule*/

module adder(pc2,sext,branchaddress);
input[31:0] pc2,sext;
output[31:0] branchaddress;
reg[31:0] branchaddress;
always @(*)
		begin
			branchaddress <= pc2 + sext;
		end
endmodule

/*module test;
reg[31:0] pc2,sext;
wire[31:0] out;
adder a(pc2,sext,out);
initial begin
$monitor("%d %d %d",pc2,sext,out);
pc2 = 0; sext = 1;
#5 pc2 = 1; sext = 1;
#5 pc2 = 10;sext = 10;
end
endmodule*/

module decode_stage(ir2_output,pc2_output,clk,r1_value,r2_value,z5_output,reset,ir3_output,pc3_output,x3_output,y3_output,md3_output,ir3_input,pc3_input,x3_input,y3_input,md3_input,branchaddress_input,select_ir3,select_pc3,select_x3,select_y3,select_md3);
input[31:0] ir3_output,pc3_output,x3_output,y3_output,md3_output;
input[31:0] ir2_output,pc2_output,r1_value,r2_value,z5_output;
input reset,clk;
input[1:0] select_ir3,select_x3,select_y3,select_md3;
input select_pc3;
output[31:0] ir3_input,pc3_input,x3_input,y3_input,md3_input,branchaddress_input;
wire[31:0] ir2_output,pc2_output,r1_value,r2_value,z5_output,sextended_value;
wire reset,clk;
wire[1:0] select_ir3,select_x3,select_y3,select_md3;
wire select_pc3;
reg[31:0] nop;
wire[2:0] sext_select;
always @(reset)
		begin
		if(reset==1)
			begin
			nop <= 0;
			end
		end
mux4 ir3mux(.in0(ir2_output),.in1(nop),.in2(ir3_output),.in3(ir3_output),.select(select_ir3),.out(ir3_input));
mux2 pc3mux(.in0(pc2_output),.in1(pc3_output),.select(select_pc3),.out(pc3_input));
mux4 x3mux(.in0(r1_value),.in1(pc2_output),.in2(x3_output),.in3(z5_output),.select(select_x3),.out(x3_input));
mux4 y3mux(.in0(r2_value),.in1(sextended_value),.in2(y3_output),.in3(z5_output),.select(select_y3),.out(y3_input));
mux4 md3mux(.in0(r2_value),.in1(z5_output),.in2(md3_output),.in3(md3_output),.select(select_md3),.out(md3_input));
decoder de(ir2_output[6:0],sext_select);
sext ext(ir2_output,sext_select,sextended_value);
adder branchadd(pc2_output,sextended_value,branchaddress_input);
endmodule

module test;
reg[31:0] ir2_output,pc2_output,r1_value,r2_value,z5_output,ir3_output,pc3_output,x3_output,y3_output,md3_output;
reg clk,reset;
wire[31:0] ir3_input,pc3_input,x3_input,y3_input,md3_input,branchaddress_input;
reg[1:0] select_ir3,select_x3,select_y3,select_md3;
reg select_pc3;
decode_stage dec(.ir2_output(ir2_output),.pc2_output(pc2_output),.clk(clk),.r1_value(r1_value),.r2_value(r2_value),.z5_output(z5_output),.reset(reset),.ir3_output(ir3_output),.pc3_output(pc3_output),.x3_output(x3_output),.y3_output(y3_output),.md3_output(md3_output),.ir3_input(ir3_input),.pc3_input(pc3_input),.x3_input(x3_input),.y3_input(y3_input),.md3_input(md3_input),.branchaddress_input(branchaddress_input),.select_ir3(select_ir3),.select_pc3(select_pc3),.select_x3(select_x3),.select_y3(select_y3),.select_md3(select_md3));
always @(*)
		begin
			#5 clk <= ~clk;
		end
initial begin
$monitor("ir3=%d pc3=%d x3=%d y3=%d branch=%d md3=%d ",ir3_input,pc3_input,x3_input,y3_input,branchaddress_input,md3_input);
//$monitor("%d",y3_input);
reset = 1;clk = 0;
ir2_output[31:7] = 25'b1;
ir2_output[6:0] = 7'b0010011;
pc2_output = 2;r1_value = 10;r2_value = 20;z5_output = 0;ir3_output = 5;pc3_output = 6;x3_output = 7;y3_output = 8;md3_output = 9;
select_ir3 = 0;select_pc3 = 0;select_x3 = 0;select_y3 = 0;select_md3 = 0;
#15 reset = 0;
end
endmodule
