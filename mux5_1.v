module mux5_1 (
	input [2:0] select,
	input [31:0] in0, in1, in2, in3, in4,
	output reg [31:0] out);

	always @(*) begin
	case (select)
		3'b000: out <= in0;
		3'b001: out <= in1;
		3'b010: out <= in2;
		3'b011: out <= in3;
		3'b100: out <= in4;
		default: out <= 32'd0;
	endcase
end
endmodule 