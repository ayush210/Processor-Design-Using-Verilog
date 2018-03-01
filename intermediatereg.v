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
reg clk;
wire[31:0] out;
intermediatereg r1(in0,clk,out);
always @(*)
		begin
  #5		clk<=~clk;
		end
initial begin
$monitor("%d %d",in0,out);
in0 = 20;clk = 0;
end

endmodule


