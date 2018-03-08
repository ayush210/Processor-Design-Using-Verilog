module pcincrement(pc,out);
input[31:0] pc;
wire[31:0] pc;
output[31:0] out;
reg[31:0] out;
always@(*)
		begin
		out=pc+4;
		end
endmodule

module mux2(in0,in1,select,out);
input[31:0] in0,in1;
input select;
output[31:0] out;
reg[31:0] out;
wire[31:0] in0,in1;
always @(*)
		begin
		case(select)
		0: out=in0;
		1: out=in1;
		endcase
		end
endmodule

module mux4(in0,in1,in2,in3,select,out);
input[31:0] in0,in1,in2,in3;
input[1:0] select;
output[31:0] out;
reg[31:0] out;
wire[31:0] in0,in1,in2,in3;
wire[1:0] select;
always @(*)
begin
		case(select)	
        0:out=in0;
		1:out=in1;
		2: out=in2;
		3: out=in3;
		endcase
end
endmodule

/*module test;
reg[31:0] in0,in1,in2,in3;
wire[31:0] out;
reg[1:0] select;
mux4 m(in0,in1,in2,in3,select,out);
initial begin
$monitor($time,"in0=%d in1=%d in2=%d in3=%d select=%d out=%d",in0,in1,in2,in3,select,out);
in0 = 0;in1=1;in2=2;in3 = 3;select = 0;
#5 select = 1;
#5 select = 2;
#5 select = 3;
#5 select = 0;
end
endmodule*/

module intermediatereg(in0,clk,out);

input[31:0] in0;
input clk;
wire[31:0] in0;
wire clk;
reg temp;
output[31:0] out;
reg[31:0] out;
always @(posedge clk)
		begin
		out<=in0;
		end

endmodule

/*module test;
reg[31:0] in0;
wire[31:0] out;
wire clk;
reg [31:0]out1;
always @(*)
		begin
#5 clk <= ~clk;
		end
intermediatereg r(in0,clk,out);
initial begin
$monitor($time,"%d %d ",out,out1);
clk = 0;in0 = 0;
end
always @(*)
		begin
		out1 = out + 20;
		end
endmodule*/


module instruction_memory(address,out);
input [31:0]address;
output[31:0] out;
wire[31:0] address;
reg [31:0]out;
reg[31:0] memory[31:0];
always @(*)
		begin
		out = memory[address];
		end
initial begin
memory[0] = 1;
memory[1] = 2;
memory[2] = 3;
end
endmodule

/*module test;
reg[31:0] address;
wire[31:0] out;
instruction_memory m(address,out);
initial begin
$monitor("%d %d",address,out);
#5 address = 0;
#5 address = 1;
#5 address = 2;
end
endmodule*/

module dff(in0,clk,out);
input[31:0] in0;
wire[31:0] in0;
output[31:0] out;
reg[31:0] out;
input clk;
always @(posedge clk)
		 begin
		 out = in0;
		 end
endmodule

module instruction_fetch(z4,selectmux0,selectmux1,selectmux2,clk,ir2output,pc2output);
output[31:0] pc2output;
output[31:0] ir2output;
input[31:0] branchaddress;
input[31:0] z4;
input[1:0] selectmux0,selectmux1;
input selectmux2,clk;
wire[31:0] branchaddress;
wire[31:0] z4;
wire[1:0] selectmux0,selectmux1;
wire selectmux2,clk;
wire[31:0] pcinput;
wire[31:0] pcoutput;
wire[31:0] pcincremented;
wire[31:0] pc2input;
wire[31:0] instructionout;
wire[31:0] ir2output;
wire[31:0] ir2input;
reg[31:0] nop;
mux4 pcmux(z4,pcincremented,pcoutput,branchaddress,selectmux0,pcinput);
dff pc(pcinput,clk,pcoutput);
pcincrement pcinc(pcoutput,pcincremented);
mux2 pc2mux(pcincremented,pc2output,selectmux2,pc2input);
dff pc2(pc2input,clk,pc2output);
instruction_memory ins(pcoutput,instructionout);
mux4 ir2mux(instructionout,nop,ir2output,ir2output,selectmux1,ir2input);
dff ir2(ir2input,clk,ir2output);
initial begin
//$monitor($time,"%d",pcoutput);
nop = 1;
end
endmodule 

module test;
reg [31:0]z4;
reg [1:0] selectmux0;
reg[1:0] selectmux1;
reg selectmux2;
reg clk;
wire [31:0] ir2output;
wire [31:0] pc2output;
always @(*)
		begin
#5	clk <= ~clk;
		end
instruction_fetch t(z4,selectmux0,selectmux1,selectmux2,clk,ir2output,pc2output);
initial begin
$monitor($time,"%d",ir2output);
clk <= 0;
#5 z4 <= 0;selectmux2 <= 0;selectmux0 <= 0;selectmux1 <= 0;
#10 z4 <=1; selectmux0 <= 2; 
#50 $finish;
end
endmodule
