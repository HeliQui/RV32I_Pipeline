module rf_32_32 (
	input clk, reg_write, 
	input [31:0] data_write,
	input [4:0] wa, ra1, ra2,
	output reg [31:0] rd1, rd2
);

	reg [31:0] rf [31:0];
	always @(posedge clk) begin
		if (reg_write == 1) begin
			if (wa != 0)
				rf[wa] <= data_write;
		end 
		rf[0] <= 0;
		rd1 <= rf[ra1];
		rd2 <= rf[ra2];
	end
endmodule

