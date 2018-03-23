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
end*/











