module alu_decode(ir3_output,alu_select);
input[31:0] ir3_output;
output[5:0] alu_select;
reg[5:0] alu_select;
always @(*)
		begin
		
		if(ir3_output[6:0]==7'b0110011)
		begin
		if(ir3_output[31:25]==7'b0100000&&ir3_output[14:12]==3'b000)
		alu_select = 6'b000000;//add
		if(ir3_output[31:25]==7'b0000000&&ir3_output[14:12]==3'b000)
		alu_select = 6'b000001;//sub
		if(ir3_output[31:25]==7'b0000000&&ir3_output[14:12]==3'b111)
		alu_select = 6'b000010;//and
		if(ir3_output[31:25]==7'b0000000&&ir3_output[14:12]==3'b110)
		alu_select = 6'b000011;//or
		if(ir3_output[31:25]==7'b0000000&&ir3_output[14:12]==3'b100)
		alu_select = 6'b000100;//xor
		if(ir3_output[31:25]==7'b0000000&&ir3_output[14:12]==3'b010)
		alu_select = 6'b000101;//slt
		if(ir3_output[31:25]==7'b0000000&&ir3_output[14:12]==3'b011)
		alu_select = 6'b000110;//sltu
		if(ir3_output[31:25]==7'b0100000&&ir3_output[14:12]==3'b101)
		alu_select = 6'b000111;//sra
		if(ir3_output[31:25]==7'b0000000&&ir3_output[14:12]==3'b101)
		alu_select = 6'b001000;//srl
		if(ir3_output[31:25]==7'b0000000&&ir3_output[14:12]==3'b001)
		alu_select = 6'b001001;//sll
		if(ir3_output[31:25]==7'b0000001&&ir3_output[14:12]==3'b000)
		alu_select = 6'b001010;//mul
		end
		
		if(ir3_output[6:0]==7'b0010011)
		begin
		if(ir3_output[14:12] == 3'b000)
		alu_select = 6'b001011;//addi
		if(ir3_output[14:12] == 3'b001)
		alu_select = 6'b001100;//subi
		if(ir3_output[14:12] == 3'b111)
		alu_select = 6'b001101;//andi
		if(ir3_output[14:12] == 3'b110)
		alu_select = 6'b001110;//ori
		if(ir3_output[14:12] == 3'b100)
		alu_select = 6'b001111;//xori
		if(ir3_output[14:12] == 3'b010)
		alu_select = 6'b010000;//slti
		if(ir3_output[14:12] == 3'b011)
		alu_select = 6'b010001;//sltiu
		if(ir3_output[14:12] == 3'b101&&ir3_output[31:25]==7'b0100000)
		alu_select = 6'b010010;//srai
		if(ir3_output[14:12] == 3'b101&&ir3_output[31:25]==7'b0000000)
		alu_select = 6'b010011;//srli
		if(ir3_output[14:12] == 3'b101&&ir3_output[31:25]==7'b0000001)
		alu_select = 6'b010100;//slli
		end
		
		if(ir3_output[6:0]==7'b0110111)
		alu_select = 6'b010101;//lui
	
		if(ir3_output[6:0]==7'b0010111)
		alu_select = 6'b010110;//auipc
		
		if(ir3_output[6:0]==7'b0000011&&ir3_output[14:12]==3'b010)
		alu_select = 6'b010111;//lw

		if(ir3_output[6:0]==7'b0100011&&ir3_output[14:12]==3'b010)
		alu_select = 6'b011000;//sw
			
		if(ir3_output[6:0]==7'b1101111)
		begin
		if(ir3_output[14:7]==8'b00000000&&ir3_output[31:20]==12'b000000000000)
			begin
				alu_select = 6'b011001;//jr
			end
		else 
			begin
				if(ir3_output[14:12]==3'b000)
					begin
						alu_select = 6'b011010;//jalr
					end
				else
					begin
						alu_select = 6'b011011;//jal
					end
			end
		end

		if(ir3_output[6:0]==7'b1100011)
		begin
		if(ir3_output[14:12]==3'b000)
		alu_select = 6'b011100;//beq
		if(ir3_output[14:12]==3'b001)
		alu_select = 6'b011101;//bne
		if(ir3_output[14:12]==3'b100)
		alu_select = 6'b011110;//blt
		if(ir3_output[14:12]==3'b101)
		alu_select = 6'b011111;//bge
		if(ir3_output[14:12]==3'b110)
		alu_select = 6'b100000;//bltu
		if(ir3_output[14:12]==3'b111)
		alu_select = 6'b100001;//bgeu
		end
		
		end
endmodule

module test;
reg[31:0] ir3_output;
wire[5:0] alu_select;
alu_decode dec(ir3_output,alu_select);
initial begin
$monitor("%d %d",ir3_output,alu_select);
#5	ir3_output[6:0]<=7'b0110011;ir3_output[31:25]<=7'b0100000;ir3_output[14:12]<=3'b000;
#5	ir3_output[31:25]=7'b0000000;ir3_output[14:12]=3'b000;
#5	ir3_output[31:25]=7'b0000000;ir3_output[14:12]=3'b111;
#5 	ir3_output[31:25]=7'b0000000;ir3_output[14:12]=3'b110;
#5	ir3_output[31:25]=7'b0000000;ir3_output[14:12]=3'b100;
#5	ir3_output[31:25]=7'b0000000;ir3_output[14:12]=3'b010;
#5 	ir3_output[31:25]=7'b0000000;ir3_output[14:12]=3'b011;
#5	ir3_output[31:25]=7'b0100000;ir3_output[14:12]=3'b101;
#5	ir3_output[31:25]=7'b0000000;ir3_output[14:12]=3'b101;
#5	ir3_output[31:25]=7'b0000000;ir3_output[14:12]=3'b001;
#5	ir3_output[31:25]=7'b0000001;ir3_output[14:12]=3'b000;
#5	ir3_output[6:0]=7'b0010011;	ir3_output[14:12] = 3'b000;
#5	ir3_output[14:12] = 3'b001;
#5	ir3_output[14:12] = 3'b111;
#5 	ir3_output[14:12] = 3'b110;
#5	ir3_output[14:12]= 3'b100;
#5	ir3_output[14:12]= 3'b010;
#5	ir3_output[14:12] = 3'b011;
#5	ir3_output[14:12] = 3'b101;ir3_output[31:25]=7'b0100000;
#5	ir3_output[14:12] = 3'b101;ir3_output[31:25]=7'b0000000;
#5	ir3_output[14:12] = 3'b101;ir3_output[31:25]=7'b0000001;
#5 	ir3_output[6:0]=7'b0110111;
#5	ir3_output[6:0]=7'b0010111;
#5 	ir3_output[6:0]=7'b0000011;ir3_output[14:12]=3'b010;
#5	ir3_output[6:0]=7'b0100011;ir3_output[14:12]=3'b010;
#5	ir3_output[6:0]=7'b1101111;ir3_output[14:12]=3'b000;
#5 	ir3_output[14:7]=8'b00000000;ir3_output[31:20]=12'b0;
#5  ir3_output[6:0]=7'b1100011;ir3_output[14:12]=3'b000;
#5 	ir3_output[14:12]=3'b001;
#5 	ir3_output[14:12]=3'b100;
#5 	ir3_output[14:12]=3'b101;
#5 	ir3_output[14:12]=3'b110;
#5 	ir3_output[14:12]=3'b111;	
end
endmodule
