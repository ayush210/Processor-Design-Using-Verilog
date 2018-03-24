module sext(ir2,sext_select,sextended_value);
input[31:0] ir2;
input[2:0] sext_select;
output[31:0] sextended_value;
reg[31:0] sextended_value;
always @(*)
		begin
		case(sext_select)
		0: sextended_value<= {{21{ir2[31]}},ir2[30:25],ir2[24:21],ir2[20]}; //I-imm 
		1: sextended_value<= {{20{ir2[31]}},ir2[7],ir2[30:25],ir2[11:8],1'b0};//B-imm
		2: sextended_value<= {ir2[31],ir2[30:20],ir2[19:12],{12{1'b0}}};//U-imm
		3: sextended_value<= {{21{ir2[31]}},ir2[30:25],ir2[11:8],ir2[7]};//S-imm
		4: sextended_value<= {{12{ir2[31]}},ir2[19:12],ir2[20],ir2[30:25],ir2[24:21],1'b0};//J -imm
		endcase
		end
endmodule

module test;
reg[31:0] ir2;
wire[31:0] out;
reg[2:0] sext_select;
sext s(ir2,sext_select,out);
initial begin
$monitor("%d %b %d",ir2,out,sext_select);
ir2 = 1;
ir2[31] = 1'b1;
sext_select = 0;
#5 sext_select = 1;
#5 sext_select = 2;
#5 sext_select = 3;
#5 sext_select = 4;
end
endmodule
