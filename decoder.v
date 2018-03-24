module decoder(in,sext_select);
input[6:0] in;
output[2:0] sext_select;
reg[2:0] sext_select;
always @(*)
		begin
		case(in)
		27:sext_select<=0;
		107:sext_select<=1;
		31 :sext_select<=2;
		23 : sext_select<=2;
		43:sext_select<=3;
		55:sext_select<=4;
		endcase
		end
endmodule

module test;
reg[6:0] in;
wire[2:0] sext_select;
decoder d(in,sext_select);
initial begin
$monitor("%d %d",in,sext_select);
in = 0010011;
#5 in = 1100011;
#5 in = 0110111;
#5 in = 0010111;
#5 in = 1101111;
#5 in = 0100011;
end
endmodule
