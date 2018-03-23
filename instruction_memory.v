module instruction_memory(clk,pc,instruction,instruction_reset,write_signal,instruction_write,write_address);
input instruction_reset,write_signal,clk;
input[31:0] pc,instruction_write,write_address;
output[31:0] instruction;
reg[31:0] instruction;
reg[8:0] i;
reg[31:0] memory[255:0];
always @(posedge clk)
		begin
		if(instruction_reset==1)
		begin
			for(i=0;i<256;i=i+1)
			memory[i] = 0;
		end
		else if(write_signal==1)
		begin
		memory[write_address] = instruction_write;
		end
		else
		begin
		instruction = memory[pc];
		end
		end
endmodule

/*module test;
reg[31:0] z4;
reg clk;
reg reset,select_pc2;
reg[1:0] select_pc,select_ir2;
wire[31:0] instruction,pc,branchaddress,ir2_input,ir2_output,pc2_input,pc2_output;
reg[31:0] instruction_write,write_address;
reg write_signal;
reg instruction_reset;
instruction_memory im(.clk(clk),.pc(pc),.instruction(instruction),.instruction_reset(instruction_reset),.write_signal(write_signal),.instruction_write(instruction_write),.write_address(write_address));
fetch_stage stage1(.z4(z4),.clk(clk),.reset(reset),.select_pc(select_pc),.select_ir2(select_ir2),.select_pc2(select_pc2),.instruction(instruction),.pc(pc),.branchaddress(branchaddress),.ir2_input(ir2_input),.pc2_input(pc2_input),.ir2_output(ir2_output),.pc2_output(pc2_output));
dff pc2d(.in(pc2_input),.clk(clk),.out(pc2_output),.reset(reset));
dff ir2d(.in(ir2_input),.clk(clk),.out(ir2_output),.reset(reset));
always @(*)
		begin
#5 clk<= ~clk;
		end
initial begin
$monitor($time,"%d %d",pc,instruction);
reset = 1;clk = 0;write_signal = 1;instruction_reset = 1;
#5
#10 instruction_write = 0;write_address = 0;instruction_reset = 0;instruction_reset = 0;
#10 instruction_write = 1;write_address = 1;
#10 instruction_write = 2;write_address = 2;
#10 instruction_write = 3;write_address = 3;
#10 write_signal = 0;
#10 reset = 0;select_pc = 1;select_ir2 = 0;select_pc2 = 0;
#50 $finish;
end


endmodule*/













