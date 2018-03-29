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

module writeback_stage(ir4_output,pc4_output,z4_output,md4_output,z5_output,read_data,write_data,select_z5,select_writedata,ir5_input,z5_input);
input[31:0] ir4_output,pc4_output,z4_output,md4_output,z5_output,read_data;
output[31:0] write_data,ir5_input,z5_input;
input[1:0] select_z5;
input select_writedata;
mux2 writedatamux(.in0(z5_output),.in1(md4_output),.select(select_writedata),.out(write_data));
mux4 z5mux(.in0(read_data),.in1(z4_output),.in2(pc4_output),.in3(pc4_output),.select(select_z5),.out(z5_input));
assign ir5_input = ir4_output;
endmodule












