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



module alu_decode(ir3_output,alu_select);
input[31:0] ir3_output;
output[5:0] alu_select;
reg[5:0] alu_select;
always @(*)
		begin
		
		if(ir3_output[6:0]==7'b0110011)
		begin
		if(ir3_output[31:25]==7'b0100000&&ir3_output[14:12]==3'b000)
		alu_select = 6'b000000;//add
		if(ir3_output[31:25]==7'b0000000&&ir3_output[14:12]==3'b000)
		alu_select = 6'b000001;//sub
		if(ir3_output[31:25]==7'b0000000&&ir3_output[14:12]==3'b111)
		alu_select = 6'b000010;//and
		if(ir3_output[31:25]==7'b0000000&&ir3_output[14:12]==3'b110)
		alu_select = 6'b000011;//or
		if(ir3_output[31:25]==7'b0000000&&ir3_output[14:12]==3'b100)
		alu_select = 6'b000100;//xor
		if(ir3_output[31:25]==7'b0000000&&ir3_output[14:12]==3'b010)
		alu_select = 6'b000101;//slt
		if(ir3_output[31:25]==7'b0000000&&ir3_output[14:12]==3'b011)
		alu_select = 6'b000110;//sltu
		if(ir3_output[31:25]==7'b0100000&&ir3_output[14:12]==3'b101)
		alu_select = 6'b000111;//sra
		if(ir3_output[31:25]==7'b0000000&&ir3_output[14:12]==3'b101)
		alu_select = 6'b001000;//srl
		if(ir3_output[31:25]==7'b0000000&&ir3_output[14:12]==3'b001)
		alu_select = 6'b001001;//sll
		if(ir3_output[31:25]==7'b0000001&&ir3_output[14:12]==3'b000)
		alu_select = 6'b001010;//mul
		end
		
		if(ir3_output[6:0]==7'b0010011)
		begin
		if(ir3_output[14:12] == 3'b000)
		alu_select = 6'b001011;//addi
		if(ir3_output[14:12] == 3'b001)
		alu_select = 6'b001100;//subi
		if(ir3_output[14:12] == 3'b111)
		alu_select = 6'b001101;//andi
		if(ir3_output[14:12] == 3'b110)
		alu_select = 6'b001110;//ori
		if(ir3_output[14:12] == 3'b100)
		alu_select = 6'b001111;//xori
		if(ir3_output[14:12] == 3'b010)
		alu_select = 6'b010000;//slti
		if(ir3_output[14:12] == 3'b011)
		alu_select = 6'b010001;//sltiu
		if(ir3_output[14:12] == 3'b101&&ir3_output[31:25]==7'b0100000)
		alu_select = 6'b010010;//srai
		if(ir3_output[14:12] == 3'b101&&ir3_output[31:25]==7'b0000000)
		alu_select = 6'b010011;//srli
		if(ir3_output[14:12] == 3'b101&&ir3_output[31:25]==7'b0000001)
		alu_select = 6'b010100;//slli
		end
		
		if(ir3_output[6:0]==7'b0110111)
		alu_select = 6'b010101;//lui
	
		if(ir3_output[6:0]==7'b0010111)
		alu_select = 6'b010110;//auipc
		
		if(ir3_output[6:0]==7'b0000011&&ir3_output[14:12]==3'b010)
		alu_select = 6'b010111;//lw

		if(ir3_output[6:0]==7'b0100011&&ir3_output[14:12]==3'b010)
		alu_select = 6'b011000;//sw
			
		if(ir3_output[6:0]==7'b1101111)
		begin
		if(ir3_output[14:7]==8'b00000000&&ir3_output[31:20]==12'b000000000000)
			begin
				alu_select = 6'b011001;//jr
			end
		else 
			begin
				if(ir3_output[14:12]==3'b000)
					begin
						alu_select = 6'b011010;//jalr
					end
				else
					begin
						alu_select = 6'b011011;//jal
					end
			end
		end

		if(ir3_output[6:0]==7'b1100011)
		begin
		if(ir3_output[14:12]==3'b000)
		alu_select = 6'b011100;//beq
		if(ir3_output[14:12]==3'b001)
		alu_select = 6'b011101;//bne
		if(ir3_output[14:12]==3'b100)
		alu_select = 6'b011110;//blt
		if(ir3_output[14:12]==3'b101)
		alu_select = 6'b011111;//bge
		if(ir3_output[14:12]==3'b110)
		alu_select = 6'b100000;//bltu
		if(ir3_output[14:12]==3'b111)
		alu_select = 6'b100001;//bgeu
		end
		
		end
endmodule

/*module test;
reg[31:0] ir3_output;
wire[5:0] alu_select;
alu_decode dec(ir3_output,alu_select);
initial begin
$monitor("%d %d",ir3_output,alu_select);
#5	ir3_output[6:0]<=7'b0110011;ir3_output[31:25]<=7'b0100000;ir3_output[14:12]<=3'b000;
#5	ir3_output[31:25]=7'b0000000;ir3_output[14:12]=3'b000;
#5	ir3_output[31:25]=7'b0000000;ir3_output[14:12]=3'b111;
#5 	ir3_output[31:25]=7'b0000000;ir3_output[14:12]=3'b110;
#5	ir3_output[31:25]=7'b0000000;ir3_output[14:12]=3'b100;
#5	ir3_output[31:25]=7'b0000000;ir3_output[14:12]=3'b010;
#5 	ir3_output[31:25]=7'b0000000;ir3_output[14:12]=3'b011;
#5	ir3_output[31:25]=7'b0100000;ir3_output[14:12]=3'b101;
#5	ir3_output[31:25]=7'b0000000;ir3_output[14:12]=3'b101;
#5	ir3_output[31:25]=7'b0000000;ir3_output[14:12]=3'b001;
#5	ir3_output[31:25]=7'b0000001;ir3_output[14:12]=3'b000;
#5	ir3_output[6:0]=7'b0010011;	ir3_output[14:12] = 3'b000;
#5	ir3_output[14:12] = 3'b001;
#5	ir3_output[14:12] = 3'b111;
#5 	ir3_output[14:12] = 3'b110;
#5	ir3_output[14:12]= 3'b100;
#5	ir3_output[14:12]= 3'b010;
#5	ir3_output[14:12] = 3'b011;
#5	ir3_output[14:12] = 3'b101;ir3_output[31:25]=7'b0100000;
#5	ir3_output[14:12] = 3'b101;ir3_output[31:25]=7'b0000000;
#5	ir3_output[14:12] = 3'b101;ir3_output[31:25]=7'b0000001;
#5 	ir3_output[6:0]=7'b0110111;
#5	ir3_output[6:0]=7'b0010111;
#5 	ir3_output[6:0]=7'b0000011;ir3_output[14:12]=3'b010;
#5	ir3_output[6:0]=7'b0100011;ir3_output[14:12]=3'b010;
#5	ir3_output[6:0]=7'b1101111;ir3_output[14:12]=3'b000;
#5 	ir3_output[14:7]=8'b00000000;ir3_output[31:20]=12'b0;
#5  ir3_output[6:0]=7'b1100011;ir3_output[14:12]=3'b000;
#5 	ir3_output[14:12]=3'b001;
#5 	ir3_output[14:12]=3'b100;
#5 	ir3_output[14:12]=3'b101;
#5 	ir3_output[14:12]=3'b110;
#5 	ir3_output[14:12]=3'b111;	
end
endmodule*/

module alu(operand1,operand2,alu_select,z4_input);
input[31:0] operand1,operand2;
input[5:0] alu_select;
output[31:0] z4_input;
reg signed [31:0] z4_input;
always @(*)
		begin
		case(alu_select)
		0:	z4_input = operand1 + operand2;	//add
		1:	z4_input = operand1 - operand2;	//sub
		2:	z4_input = operand1 & operand2;	//and	
		3:	z4_input = operand1|operand2; //or
		4:	z4_input = operand1^operand2;	//xor
		5:	begin//slt
			if($signed(operand1)<$signed(operand2))
			z4_input = 1;
			else 
			z4_input = 0;
			end
		6:	begin
				if(operand1<operand2)
				z4_input =	1;
				else
				z4_input = 0;//sltu
		end
	7:	z4_input = operand1>>>operand2[4:0];//sra
		8:	z4_input = operand1>>operand2[4:0];	//srl
		9:	z4_input = operand1<<operand2[4:0];//sll
		10:	z4_input = operand1 * operand2 ;	//mul
		11:	z4_input = operand1 + operand2 ;	//addi
		12:	z4_input = operand1 - operand2 ;	//subi
		13:	z4_input = operand1 & operand2 ;	//andi
		14:	z4_input = operand1 | operand2 ;	//ori
		15:	z4_input = operand1 ^ operand2 ;	//xori
		16:	z4_input = 	operand1 << operand2 ;//	slti
		17:	begin
				if(operand1<operand2)
				z4_input =	1;
				else
				z4_input = 0;//sltu
		end
		18:	z4_input = 	operand1>>>operand2;//srai
		19:	z4_input = 	operand1>>operand2; //srli
		20:	z4_input = 	operand1<<operand2;//slli
		21:	z4_input = 	operand2;//lui
		22:	z4_input = 	operand1 + operand2;//auipc
		23:	z4_input = 	operand1 + operand2 ;//lw
		24:	z4_input = 	operand1 + operand2;//sw
		25:	z4_input = operand1 + operand2;	//jr
		26:	z4_input = 	operand1 + operand2;//jalr
		27:	z4_input = 	operand1 + operand2;//jal
		28:	z4_input = operand1 - operand2 ;//beq
		29:	z4_input = 	operand1 - operand2 ;//bne
		30:	z4_input = 	operand1 - operand2 ;//blt
		31:	z4_input = 	operand1 - operand2 ;//bge
		32:	z4_input = 	operand1 - operand2 ;//bltu
		33:	z4_input = 	operand1 - operand2 ;//bgeu
		default:z4_input<=operand1 + operand2;
		endcase
		end
endmodule

/*module test;
reg[31:0] operand1,operand2;
reg[5:0] alu_select;
wire[31:0]  out;
alu a(operand1,operand2,alu_select,out);
initial begin
operand1  = 1 ; operand2 = 2;
#5 alu_select = 0;
#5 alu_select = 1;
#5 alu_select = 2;
#5 alu_select = 3;
#5 alu_select = 4;
#5 alu_select = 5;
#5 alu_select = 6;
#5 alu_select = 7;
#5 alu_select = 8;
#5 alu_select = 9;
#5 alu_select = 10;
#5 alu_select = 11;
#5 alu_select = 12;
#5 alu_select = 13;
#5 alu_select = 14;
#5 alu_select = 15;
#5 alu_select = 16;
#5 alu_select = 17;
#5 alu_select = 18;
#5 alu_select = 19;
#5 alu_select = 20;
#5 alu_select = 21;
#5 alu_select = 22;
#5 alu_select = 23;
#5 alu_select = 24;
#5 alu_select = 25;
#5 alu_select = 26;
#5 alu_select = 27;
#5 alu_select = 28;
$display("%d %d",alu_select,$signed(out));
#5 alu_select = 29;
$display("%d %d",alu_select,$signed(out));
#5 alu_select = 30;
$display("%d %d",alu_select,$signed(out));
#5 alu_select = 31;
$display("%d %d",alu_select,$signed(out));
#5 alu_select = 32;
$display("%d %d",alu_select,$signed(out));
#5 alu_select = 33;
end
endmodule*/

module execute_stage(ir3_output,pc3_output,x3_output,y3_output,md3_output,pc4_output,z4_output,z5_output,select_ir4,select_pc4z4,select_operand1,select_operand2,select_md4,clk,reset,ir4_input,pc4_input,z4_input,md4_input);
input[1:0] select_operand1,select_operand2,select_md4;
input select_ir4,select_pc4z4;
input[31:0] ir3_output,pc3_output,x3_output,y3_output,md3_output,z4_output,z5_output,pc4_output;
input clk,reset;
output[31:0] ir4_input,pc4_input,z4_input,md4_input;
reg[31:0] nop;
wire[31:0] ir4_input,pc4_input,z4_input,md4_input;
wire[31:0] operand1,operand2,mux_operand_in;
wire[5:0] alu_select;
always @(posedge clk)
		begin
		if(reset==1)
		nop = 0;
		end
		assign pc4_input = pc3_output;
mux2 ir4mux(.in0(ir3_output),.in1(nop),.select(select_ir4),.out(ir4_input));
mux2 pc4z4mux(.in0(pc4_output),.in1(z4_output),.select(select_pc4z4),.out(mux_operand_in));
mux4 operand1mux(.in0(x3_output),.in1(z5_output),.in2(mux_operand_in),.in3(mux_operand_in),.select(select_operand1),.out(operand1));
mux4 operand2mux(.in0(y3_output),.in1(z5_output),.in2(mux_operand_in),.in3(mux_operand_in),.select(select_operand2),.out(operand2));
mux4 md4mux(.in0(md3_output),.in1(z5_output),.in2(mux_operand_in),.in3(mux_operand_in),.select(select_md4),.out(md4_input));
alu_decode decode(.ir3_output(ir3_output),.alu_select(alu_select));
alu al(.operand1(operand1),.operand2(operand2),.alu_select(alu_select),.z4_input(z4_input));
endmodule

module test;
reg[1:0] select_operand1,select_operand2,select_md4;
reg select_ir4,select_pc4z4;
reg[31:0] ir3_output,pc3_output,x3_output,y3_output,md3_output,z4_output,z5_output,pc4_output;
reg clk,reset;
wire[31:0] ir4_input,pc4_input,z4_input,md4_input;
execute_stage ex(.ir3_output(ir3_output),.pc3_output(pc3_output),.x3_output(x3_output),.y3_output(y3_output),.md3_output(md3_output),.pc4_output(pc4_output),.z4_output(z4_output),.z5_output(z5_output),.select_ir4(select_ir4),.select_pc4z4(select_pc4z4),.select_operand1(select_operand1),.select_operand2(select_operand2),.select_md4(select_md4),.clk(clk),.reset(reset),.ir4_input(ir4_input),.pc4_input(pc4_input),.z4_input(z4_input),.md4_input(md4_input));
initial begin
$monitor("%d %d %d %d",ir4_input,pc4_input,z4_input,md4_input);
ir3_output = 2;pc3_output = 1;x3_output = 5;y3_output= 6;md3_output = 7;
select_ir4 = 0;select_pc4z4 = 0;select_operand1 = 0;select_operand2 = 0;select_md4 = 0;
end
endmodule










