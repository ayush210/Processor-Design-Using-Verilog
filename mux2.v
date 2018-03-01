module mux2(in0,in1,out,select);
input[31:0] in0,in1;
input select;
output[31:0] out;
reg[31:0] out;
wire[31:0] in0,in1;
always @(*)
		begin
		case(select)
		0: out<=in0;
		1: out<=in1;
		endcase
		end
endmodule

module test;
reg[31:0] in0,in1;
wire[31:0] out;
reg select;
mux2 m(in0,in1,out,select);
initial begin
$monitor($time,"in0=%d in1=%d out=%d select=%d",in0,in1,out,select);
select = 0; in0=0;in1=1;
#5 select = 1;
end
endmodule
