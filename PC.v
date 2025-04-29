module PC (
	input clk, en, rst,
	input [31:0] addr_in,
	output reg [31:0] addr_out
);

	always @(posedge clk) begin
		if(~rst)
			addr_out <= 32'b0;
		if(!en)
			addr_out <= addr_in;
	end
endmodule 