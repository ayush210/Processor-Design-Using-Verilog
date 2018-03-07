module pcincrement(pc,out);
input[31:0] pc;
wire[31:0] pc;
output[31:0] out;
reg[31:0] out;
always@(*)
		begin
		out<= pc+4;
		end
endmodule



