module Control_Unit (
	input [6:0] funct7, opcode,
	input [2:0] funct3,
	output reg MemReadD, MemWriteD, ALUSrcD, JumpD, RegWriteD, BranchD, Muxjalr,
	output reg [3:0] ALUOpD,
	output reg [2:0] ImmControlD, WriteBackD
);
	localparam R = 7'b0110011;
   localparam I0 = 7'b0010011;
	localparam I1 = 7'b0000011;
	localparam I2 = 7'b1100111;
   localparam S = 7'b0100011;
   localparam B = 7'b1100011;
	localparam U0 = 7'b0110111;
	localparam U1 = 7'b0010111;
   localparam J = 7'b1101111;


	always @(*) begin
		case(opcode)
			R: begin
				Muxjalr <= 0; MemReadD <= 0; MemWriteD <= 0; ALUSrcD <= 0; JumpD <= 0; RegWriteD <= 1; BranchD <= 0;
				ImmControlD <= 1'bx;
				WriteBackD <= 3'b000;
				if (funct3 == 3'b000) begin
					if (funct7 == 7'b0000000) ALUOpD <= 4'b0000;
					else if (funct7 == 7'b0100000) ALUOpD <= 4'b1000; end
				else if (funct3 == 3'b101 && funct7 ==7'b0100000) ALUOpD <= 4'b1001;
				else if (funct7 == 7'b0000000) begin
					case (funct3)
						3'b100: ALUOpD <= 4'b0100;
						3'b110: ALUOpD <= 4'b0110;
						3'b111: ALUOpD <= 4'b0111;
						3'b001: ALUOpD <= 4'b0001;
						3'b101: ALUOpD <= 4'b0101;
						3'b010: ALUOpD <= 4'b0010;
						3'b011: ALUOpD <= 4'b0011;
					endcase
				end
			end
			I0: begin
				Muxjalr <= 0; MemReadD <= 0; MemWriteD <= 0; ALUSrcD <= 1; JumpD <= 0; RegWriteD <= 1; BranchD <= 0;
				case (funct3)
					3'b000: begin
						ALUOpD <= 4'b0000;
						ImmControlD <= 3'b000; end
					3'b100: begin
						ALUOpD <= 4'b0100;
						ImmControlD <= 3'b000; end
					3'b110: begin
						ALUOpD <= 4'b0110;
						ImmControlD <= 3'b000; end
					3'b111: begin
						ALUOpD <= 4'b0111;
						ImmControlD <= 3'b000; end
					3'b001: begin
						if (funct7 == 7'b0000000) begin
							ALUOpD <= 4'b0001;
							ImmControlD <= 3'b010; end
						end
					3'b101: begin
						if (funct7 == 7'b0000000) begin
							ALUOpD <= 4'b0101;
							ImmControlD <= 3'b010; end
						end
					3'b101: begin
						if (funct7 == 7'b0100000) begin
							ALUOpD <= 4'b1001;
							ImmControlD <= 3'b010; end
						end
					3'b010: begin
						ALUOpD <= 4'b0010;
						ImmControlD <= 3'b000; end
					3'b011: begin
						ALUOpD <= 4'b0011;
						ImmControlD <= 3'b001; end
				endcase
				WriteBackD <= 3'b000;
			end
			I1: begin
				MemReadD <=1; MemWriteD <= 0; ALUSrcD <= 1; JumpD <= 0; RegWriteD <= 1;
				ALUOpD <= 4'b0000;
				BranchD <= 0;
				WriteBackD <= 3'b001;
				ImmControlD <= 3'b000;
			end
			I2: begin
				if (funct3 == 3'b000) begin
					Muxjalr <= 1; MemReadD <= 0; MemWriteD <= 0; ALUSrcD <= 1'bx; JumpD <= 0; RegWriteD <= 1; BranchD <= 0;
					ALUOpD <= 4'bxxxx;
					ImmControlD <= 3'b000;
					WriteBackD <= 3'b010;
				end
			end
	
			S: begin
				MemReadD <= 0; MemWriteD <= 1; ALUSrcD <= 1; JumpD <= 0; RegWriteD <= 0; BranchD <= 0; Muxjalr <= 0;
				ALUOpD <= 4'b0000;
				ImmControlD <= 3'b011;
				WriteBackD <= 3'bxxx;
			end
			
			B: begin
				MemReadD <= 0; MemWriteD <= 0; ALUSrcD <= 0; JumpD <= 0; RegWriteD <= 0; BranchD <= 1; Muxjalr <= 0;
				ImmControlD <= 3'b100;
				WriteBackD <= 3'bxxx;
				ALUOpD <= 4'bxxxx;
			end
			
			U1: begin
				MemReadD <= 0; MemWriteD <= 0; ALUSrcD <= 1'bx; JumpD <= 0; RegWriteD <= 1; BranchD <= 0; Muxjalr <= 0;
				ImmControlD <= 3'b101;
				WriteBackD <= 3'b100;
				ALUOpD <= 4'bxxxx;
			end
			
			
			U0: begin
				MemReadD <= 0; MemWriteD <= 0; ALUSrcD <= 1'bx; JumpD <= 0; RegWriteD <= 1; BranchD <= 0; Muxjalr <= 0;
				ImmControlD <= 3'b101;
				WriteBackD <= 3'b011;
				ALUOpD <= 4'bxxxx;
			end
			
			J: begin
				MemReadD <= 0; MemWriteD <= 0; ALUSrcD <= 0; JumpD <= 1; RegWriteD <= 0; BranchD <= 0; Muxjalr <= 0;
				ImmControlD <= 3'b110;
				WriteBackD <= 3'b010;
				ALUOpD <= 4'bxxxx;
			end
			default: begin
				MemReadD <= 0; MemWriteD <= 0; ALUSrcD <= 0; JumpD <= 0; RegWriteD <= 0; BranchD <= 0; Muxjalr <= 0;
				ImmControlD <= 3'b000;
				WriteBackD <= 3'b000;
				ALUOpD <= 4'b0000;
			end
		endcase
	end
endmodule 