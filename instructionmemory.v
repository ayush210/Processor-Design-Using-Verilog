module instruction_memory(address,out);
input [31:0]address;
output[31:0] out;
wire[31:0] address;
reg [31:0]out;
reg[31:0] memory[31:0];
always @(*)
		begin
		out <= memory[address];
		end
initial begin
memory[0] = 0;
memory[1] = 1;
memory[2] = 2;
end
endmodule

module test;

reg[31:0] address;
wire[31:0] out;
instruction_memory m(address,out);
initial begin
$monitor("%d %d",address,out);
#5 address = 0;
#5 address = 1;
#5 address = 2;
end

endmodule
