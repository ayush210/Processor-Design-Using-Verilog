module adder(pc2,sext,branchaddress);
input[31:0] pc2,sext;
output[31:0] branchaddress;
reg[31:0] branchaddress;
always @(*)
		begin
			branchaddress <= pc2 + sext;
		end
endmodule

module test;
reg[31:0] pc2,sext;
wire[31:0] out;
adder a(pc2,sext,out);
initial begin
$monitor("%d %d %d",pc2,sext,out);
pc2 = 0; sext = 1;
#5 pc2 = 1; sext = 1;
#5 pc2 = 10;sext = 10;
end
endmodule
