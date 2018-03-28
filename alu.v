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

module test;
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
endmodule
