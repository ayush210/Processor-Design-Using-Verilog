module datamemory(clk,reset,address,write_data,read_data,write_signal);
reg[5:0] i;
input clk,reset,write_signal;
input[31:0] address,write_data;
output[31:0] read_data;
reg [31:0] memory[40:0];
reg[31:0] read_data;
always @(posedge clk)
		begin
		if(reset==1)
		begin
		for(i=0;i<41;i=i+1)
		memory[i] = 0;
		end
		else if(write_signal==1)
			memory[address] = write_data;
		else
		read_data = memory[address];
		end
endmodule


module test;
reg clk,reset;
reg[31:0] address,write_data;
wire[31:0] read_data;
reg write_signal;
datamemory d(clk,reset,address,write_data,read_data,write_signal);
always @(*)
		begin
#5 clk <= ~clk;
		end
initial begin
$monitor($time,"%d",read_data);
clk = 0;reset = 1;write_signal = 1;write_data = 10;
#5 address = 5;
#10 reset = 0;
#10 write_signal = 0;;
#20 $finish;
end
endmodule
