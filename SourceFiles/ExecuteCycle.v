// `include "Mux.v"
// `include "Adder.v"
// `include "Shift_Left.v"
// `include "Alu.v"

module Execute(
    input clk,
    input rst,
    input regwriteE, isimmediateE, memwriteE, isloadE, memreadE, branchE, jumpE,
    input [31:0] op1E, op2E, immxE, jumpoffset, 
    input [4:0] rdE, rs1E, rs2E,
    input [31:0] pcE, pcplus4E,
    input [3:0] alusignalE,
    input [1:0] forwardaE,forwardbE,
    input [31:0] resultW,
    input [31:0] aluresultW,
    input [31:0] readdataW,
    output isbranchtakenE, regwriteM, memwriteM, isloadM, memreadM,
    output [4:0] rdM,
    output [31:0] pcplus4M, aluresultM, branchtargetE,
    output [31:0] writedataM
);

    // Wires for data flow
    wire [31:0] shifted_branch, nextPCBranch;
    wire [31:0] Src_A,Src_B_interm, Src_B;
    wire [31:0] ResultE, Branch;
    wire [31:0] hi, lo; 
    reg RegWriteE_r, MemWriteE_r, isLoadE_r, MemReadE_r;
    reg [4:0] RD_E_r;
    reg [31:0] PCPlus4E_r, ResultE_r, branchTargetE_r, op2E_r;

    // Assignments for source operands

    // Shift and add for branch calculation
    ShiftLeft branch_shift(.inData(immxE), .outData(shifted_branch));
    Adder PC_branch(.input1(pcplus4E), .input2(shifted_branch), .out(nextPCBranch));

        Mux_4_by_1 muxa(
        .selection_line(forwardaE),
        .input1(op1E),
        .input2(aluresultW),
        .input3(aluresultM),
        .input4(readdataW),
        .out(Src_A)
    );

        Mux_4_by_1 muxb(
        .selection_line(forwardbE),
        .input1(op2E),
        .input2(aluresultW),
        .input3(aluresultM),
        .input4(readdataW),
        .out(Src_B_interm)
    );

    Mux branchPC(
        .input1(nextPCBranch),
        .input2(jumpoffset),
        .selection_line(jumpE),
        .out(Branch)
    );

    // ALU source selection using a Mux
    Mux alu_src_mux(
        .input1(Src_B_interm),
        .input2(immxE),
        .selection_line(isimmediateE),
        .out(Src_B)
    );


    // ALU instantiation
    ALU alu(
        .a(Src_A),
        .b(Src_B),
        .alusignal(alusignalE),
        .result(ResultE),
        .hi(hi),
        .lo(lo)
    );

    // Register logic for updating outputs
    always @(posedge clk ) begin
        if (rst) begin 
            RegWriteE_r <= 1'b0;
            MemWriteE_r <= 1'b0;
            isLoadE_r <= 1'b0;
            MemReadE_r <= 1'b0;
            RD_E_r <= 5'b00000;
            PCPlus4E_r <= 32'h00000000;
            ResultE_r <= 32'h00000000;
            branchTargetE_r <= 32'h00000000;
            op2E_r <= 32'h00000000;
        end else begin
            RegWriteE_r <= regwriteE;
            MemWriteE_r <= memwriteE;
            isLoadE_r <= isloadE;
            MemReadE_r <= memreadE;
            RD_E_r <= rdE;
            PCPlus4E_r <= pcplus4E;
            ResultE_r <= ResultE;
            branchTargetE_r <= Branch;
            op2E_r <= op2E;
        end
    end

    // Output Assignments
    assign isbranchtakenE = jumpE || (branchE && ResultE != 0);
    assign branchtargetE = Branch;
    assign regwriteM = RegWriteE_r;
    assign memwriteM = MemWriteE_r;
    assign isloadM = isLoadE_r;
    assign memreadM = MemReadE_r;
    assign rdM = RD_E_r;
    assign pcplus4M = PCPlus4E_r;
    assign aluresultM = ResultE_r;
    assign writedataM = op2E_r;
endmodule
