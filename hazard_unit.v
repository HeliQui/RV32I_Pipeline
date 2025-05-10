module hazard_unit (
    input regWrite_M,
    input regWrite_W,
	 input PCSrc_E,
    input [1:0] resultSrc_E,
    input [4:0] rd_M,
    input [4:0] rd_W,
    input [4:0] rs1_D,
    input [4:0] rs2_D,
    input [4:0] rs1_E,
    input [4:0] rs2_E,
    input [4:0] rd_E,
    output reg [1:0] forwardAE,
    output reg [1:0] forwardBE,
    output stall,
    output flush
);
    wire hazard;
// forward AE
    always @(*) begin
        if (regWrite_M && (rd_M == rs1_E)) begin
            forwardAE <= 2'b10;
        end
        else if (regWrite_W && (rd_W == rs1_E)) begin         
            forwardAE <= 2'b01;
        end
        else forwardAE <= 2'b00;
    end
// forward BE
    always @(*) begin
        if (regWrite_M && (rd_M == rs2_E)) begin
            forwardBE <= 2'b10;
        end
        else if (regWrite_W && (rd_W == rs2_E)) begin
            forwardBE <= 2'b01;
        end
        else forwardBE <= 2'b00;
    end
// Load hazard
    assign hazard = ((resultSrc_E == 2'b01) && ((rs1_D == rd_E) || (rs2_D == rd_E))) ? 1 : 0;
    assign stall = hazard;
    assign flush = PCSrc_E;
endmodule
