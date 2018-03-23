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

