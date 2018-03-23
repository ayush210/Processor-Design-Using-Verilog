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

/*module test;
reg[31:0] in;
reg clear;
wire[31:0] out;
incby1 i(in,out,clear);
initial begin
clear = 1;
#5 clear = 0;
end
endmodule*/

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

/*module test;
reg[31:0] in0;
wire[31:0] out;
wire[31:0] out1;
reg clk;
always @(*)
		begin
#5 clk <= ~clk;
		end
dff d(in0,clk,out);
dff d1(out,clk,out1);
initial begin
$monitor($time,"%d %d %d",in0,out,out1);
in0 = 0;clk= 0;
end
endmodule*/

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

module test;
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


endmodule













