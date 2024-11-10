module memory_cycle (
    input clock,
    input rst,
    input memreadM,
    input memwriteM,
    input regwriteM,
    input isloadM,
    input [31:0] aluresultM,
    input [4:0] rdM,
    input [31:0] pcplus4M,
    input [31:0] writedataM,
    output regwrite,
    output isloadW,
    output [31:0] pcplus4W,
    output [31:0] aluresultW,
    output [31:0] readdataW,
    output [4:0] rd
);

    wire [31:0] readDataM;
    reg [31:0] pcplus4M_r, aluresultM_r, readdataM_r;
    reg [4:0] rdM_r;
    reg regwriteM_r, isloadM_r;

    // Instantiate data memory module
    DMemBank dmem (
        .memread(memreadM),
        .memwrite(memwriteM),
        .address(aluresultM),
        .writedata(writedataM),
        .readdata(readDataM)
    );

    // Update pipeline register values on clock edge or reset
    always @(posedge clock) begin
        if (rst) begin 
            pcplus4M_r <= 32'h00000000;
            aluresultM_r <= 32'h00000000;
            readdataM_r <= 32'h00000000;
            rdM_r <= 5'b00000;
            regwriteM_r <= 1'b0;
            isloadM_r <= 1'b0;
        end else begin
            regwriteM_r <= regwriteM;
            isloadM_r <= isloadM;
            rdM_r <= rdM;
            readdataM_r <= readDataM;
            pcplus4M_r <= pcplus4M;
            aluresultM_r <= aluresultM;  
        end
    end

    // Output assignments
    assign regwrite = regwriteM_r;
    assign isloadW = isloadM_r;
    assign pcplus4W = pcplus4M_r;
    assign aluresultW = aluresultM_r;
    assign readdataW = readdataM_r;
    assign rd = rdM_r;
endmodule
