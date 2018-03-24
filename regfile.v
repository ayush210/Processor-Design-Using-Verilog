module regfile(r1_add,r2_add,write_add,z5_output,write_enable,clk,reset,r1_value,r2_value);
reg[5:0] i;
reg[31:0] registers[31:0];
input[31:0] r1_add,r2_add,write_add,z5_output;
input write_enable,reset,clk;
output[31:0] r1_value,r2_value;
reg[31:0] r1_value,r2_value;
always @(posedge clk)
	begin
		if(reset==1)
			begin
				for(i=0;i<32;i=i+1)
					begin
						registers[i] = 0;
					end
			end
		else
			begin
				if(write_enable==1)
					begin
						registers[write_add] <= z5_output;
					end
						r1_value <= registers[r1_add];
						r2_value <= registers[r2_add];
			end
	end
endmodule
