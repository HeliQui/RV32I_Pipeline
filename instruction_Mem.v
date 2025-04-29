module instruction_Mem (
    input [31:0] addr,
	 output reg [31:0] inst
);
   reg [31:0] i_mem [1023:0]; 
	
	
	reg [31:0] address ;
	
	initial begin
		$readmemb ("hex_file.hex", i_mem);
   end
	 
	always @(*) begin
		address = {2'b00, addr[31:2]};
		inst = i_mem[address];
	end
	 
endmodule
