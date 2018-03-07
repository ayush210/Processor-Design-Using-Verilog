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

module test;
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

endmodule


