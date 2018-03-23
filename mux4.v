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














