
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














