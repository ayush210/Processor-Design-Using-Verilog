
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

module adder(pc2,sext,branchaddress);
input[31:0] pc2,sext;
output[31:0] branchaddress;
reg[31:0] branchaddress;
always @(*)
		begin
			branchaddress <= pc2 + sext;
		end
endmodule

module regfile(r1_add,r2_add,write_add,z5_output,write_enable,clk,reset,r1_value,r2_value);
reg[5:0] i;
reg[31:0] registers[31:0];
input[31:0] r1_add,r2_add,write_add,z5_output;
input write_enable,reset,clk;
output[31:0] r1_value,r2_value;
reg[31:0] r1_value,r2_value;
always @(posedge clk)
	begin
		if(reset==1)
			begin
				for(i=0;i<32;i=i+1)
					begin
						registers[i] = 0;
					end
			end
		else
			begin
				if(write_enable==1)
					begin
						registers[write_add] <= z5_output;
					end
						r1_value <= registers[r1_add];
						r2_value <= registers[r2_add];
			end
	end
endmodule

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


module decoder(in,sext_select);
input[6:0] in;
output[2:0] sext_select;
reg[2:0] sext_select;
always @(*)
		begin
		case(in)
		27:sext_select<=0;
		107:sext_select<=1;
		31 :sext_select<=2;
		23 : sext_select<=2;
		43:sext_select<=3;
		55:sext_select<=4;
		endcase
		end
endmodule

module dff(in,clk,out,reset);
input reset;
input[31:0] in;
input clk;
output[31:0] out;
reg[31:0] out;
always @(posedge clk)
		begin
		if(reset==1)
		begin
		out<=0;
		end
		else
		begin
		out<=in;
		end
		end
endmodule


module incby1(in,out,clear);
input clear;
input[31:0] in;
output[31:0] out;
reg[31:0] out;
always @(in or clear)
		begin
		if(clear==1)
		begin
		out<=0;
		end
		else
		begin
		out<= in + 1;
		end
		end
endmodule

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

module fetch_stage(z4,clk,reset,select_pc,select_ir2,select_pc2,instruction,pc,branchaddress,ir2_input,pc2_input,ir2_output,pc2_output);
input clk,reset;
input[31:0] z4;
input[1:0] select_pc,select_ir2;
input select_pc2;
input[31:0] instruction,branchaddress,ir2_output,pc2_output;
output[31:0] pc;
output[31:0] ir2_input,pc2_input;
wire[31:0] pcout,incrementedpc;
reg[31:0] nop;
always @(reset)
		begin
		    if(reset==1)
		        begin
				        nop <= 0;
						        end
								end
								mux4 pcmux(.in0(z4),.in1(incrementedpc),.in2(pcout),.in3(branchaddress),.select(select_pc),.out(pc));
								dff pcd(.in(pc),.clk(clk),.out(pcout),.reset(reset));
								incby1 inc(.in(pcout),.out(incrementedpc),.clear(reset));
								mux2 pc2mux(.in0(incrementedpc),.in1(pc2_output),.select(select_pc2),.out(pc2_input));
							mux4 ir2mux(.in0(instruction),.in1(nop),.in2(ir2_output),.in3(ir2_output),.select(select_ir2),.out(ir2_input));
		endmodule

module instruction_memory(clk,pc,instruction,instruction_reset,write_signal,instruction_write,write_address);
input instruction_reset,write_signal,clk;
input[31:0] pc,instruction_write,write_address;
output[31:0] instruction;
reg[31:0] instruction;
reg[8:0] i;
reg[31:0] memory[255:0];
always @(posedge clk)
		begin
		if(instruction_reset==1)
		begin
			for(i=0;i<256;i=i+1)
			memory[i] = 0;
		end
		else if(write_signal==1)
		begin
		memory[write_address] = instruction_write;
		end
		else
		begin
		instruction = memory[pc];
		end
		end
endmodule

/*module test;
reg[31:0] z4;
reg clk;
reg reset,select_pc2;
reg[1:0] select_pc,select_ir2;
wire[31:0] instruction,pc,branchaddress,ir2_input,ir2_output,pc2_input,pc2_output;
reg[31:0] instruction_write,write_address;
reg write_signal;
reg instruction_reset;
instruction_memory im(.clk(clk),.pc(pc),.instruction(instruction),.instruction_reset(instruction_reset),.write_signal(write_signal),.instruction_write(instruction_write),.write_address(write_address));
fetch_stage stage1(.z4(z4),.clk(clk),.reset(reset),.select_pc(select_pc),.select_ir2(select_ir2),.select_pc2(select_pc2),.instruction(instruction),.pc(pc),.branchaddress(branchaddress),.ir2_input(ir2_input),.pc2_input(pc2_input),.ir2_output(ir2_output),.pc2_output(pc2_output));
dff pc2d(.in(pc2_input),.clk(clk),.out(pc2_output),.reset(reset));
dff ir2d(.in(ir2_input),.clk(clk),.out(ir2_output),.reset(reset));
always @(*)
		begin
#5 clk<= ~clk;
		end
initial begin

$monitor($time,"%d %d",pc,instruction);
reset = 1;clk = 0;write_signal = 1;instruction_reset = 1;
#5
#10 instruction_write = 0;write_address = 0;instruction_reset = 0;instruction_reset = 0;
#10 instruction_write = 1;write_address = 1;
#10 instruction_write = 2;write_address = 2;
#10 instruction_write = 3;write_address = 3;
#10 write_signal = 0;
#10 reset = 0;select_pc = 1;select_ir2 = 0;select_pc2 = 0;
#50 $finish;
end
endmodule*/

module combined;
reg clk,reset,instruction_reset,write_signal;
reg[31:0] instruction_write;
reg[31:0] write_address;
wire[31:0] z4_input,instruction,pc,branchaddress,z4_output;
wire[1:0] select_pc,select_ir2;
wire select_pc2;
wire[31:0] ir2_input,pc2_input,ir2_output,pc2_output;
wire[31:0] r1_value,r2_value;
wire[31:0] z5_output;
wire[31:0] ir3_output,pc3_output,x3_output,y3_output,md3_output,ir3_input,pc3_input,x3_input,y3_input,md3_input,branchaddress_input;
wire[1:0] select_ir3,select_x3,select_y3,select_md3;
wire select_pc3;
fetch_stage fetch(.z4(z4_output),.clk(clk),.reset(reset),.select_pc(select_pc),.select_ir2(select_ir2),.select_pc2(select_pc2),.instruction(instruction),.pc(pc),.branchaddress(branchaddress),.ir2_input(ir2_input),.pc2_input(pc2_input),.ir2_output(ir2_output),.pc2_output(pc2_output));
instruction_memory ins(.clk(clk),.pc(pc),.instruction(instruction),.instruction_reset(instruction_reset),.write_signal(write_signal),.instruction_write(instruction_write),.write_address(write_address));
dff ir2(.in(ir2_input),.clk(clk),.out(ir2_output),.reset(reset));
dff pc2(.in(pc2_input),.clk(clk),.out(pc2_output),.reset(reset));
decode_stage decode(.ir2_output(ir2_output),.pc2_output(pc2_output),.clk(clk),.r1_value(r1_value),.r2_value(r2_value),.z5_output(z5_output),.reset(reset),.ir3_output(ir3_output),.pc3_output(pc3_output),.x3_output(x3_output),.y3_output(y3_output),.md3_output(md3_output),.ir3_input(ir3_input),.pc3_input(pc3_input),.x3_input(x3_input),.y3_input(y3_input),.md3_input(md3_input),.branchaddress_input(branchaddress_input),.select_ir3(select_ir3),.select_pc3(select_pc3),.select_x3(select_x3),.select_y3(select_y3),.select_md3(select_md3));
dff ir3(.in(ir3_input),.clk(clk),.out(ir3_output),.reset(reset));
dff pc3(.in(pc3_input),.clk(clk),.out(pc3_output),.reset(reset));
dff x3(.in(x3_input),.clk(clk),.out(x3_output),.reset(reset));
dff y3(.in(y3_input),.clk(clk),.out(y3_output),.reset(reset));
dff branchadd(.in(branchaddress_input),.clk(clk),.out(branchaddress),.reset(reset));
dff md3(.in(md3_input),.clk(clk),.out(md3_output),.reset(reset));



always @(*)
		        begin
#5 clk <= ~clk;
				        end
						      assign select_pc = 1;
						      assign select_ir2 = 0;
						      assign select_pc2 = 0;
						     assign select_ir3 = 0;
						     assign select_pc3 = 0;
						    assign select_x3 = 0;
						     assign select_y3 = 0;
						     assign select_md3 = 0;
							 assign r1_value = 5;
							 assign r2_value = 6;
initial begin
$monitor($time,"%d %d %d %d %d",ir3_output,pc3_output,x3_output,y3_output,md3_output);
clk = 0; reset = 1;
reset = 1;clk = 0;write_signal = 1;instruction_reset = 1;
#5
#10 instruction_write = 0;write_address = 0;instruction_reset = 0;
#10 instruction_write = 1;write_address = 1;
#10 instruction_write = 2;write_address = 2;
#10 instruction_write = 3;write_address = 3;
#10 write_signal = 0;
#10 reset = 0;
#50 $finish;
						end

endmodule
















