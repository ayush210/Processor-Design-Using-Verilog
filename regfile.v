module regfile(r1_add,r2_add,write_add,z5_output,write_enable,clk,reset,r1_value,r2_value);
		
reg[5:0] i;  //temp reg only for "for" loop
reg[31:0] registers[31:0]; //register file
input[4:0] r1_add,r2_add,write_add; //read1(r1) address  //read2(r2) add  //address of register write
input[31:0] z5_output;  //input from output of 4th stage after passing through dff
input write_enable,reset,clk;
output[31:0] r1_value,r2_value; //value read from registers
reg[31:0] r1_value,r2_value;

	always @(posedge clk)
		begin
			if(reset==1)
				begin
					for(i=0;i<32;i=i+1)
						begin
							registers[i] = 0;  //if reset ==1 initialize all registers to 0
						end
				end
			else
				begin
					if(write_enable==1)   //if write_enable == 1 write value at z5_output to register write address
						begin
							registers[write_add] <= z5_output;
						end
						//value read from r1_add and r2_add
					r1_value <= registers[r1_add];   
					r2_value <= registers[r2_add];
				end
		end
		
endmodule
