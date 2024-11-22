module decode_cycle(
    input clk,
    input rst,
    input [31:0] instrD,        // Instruction
    input [31:0] pcD,           // Program Counter
    input [31:0] pcplus4D,      // Program Counter + 4 for branch/jump
    input regwriteW,            // Write-back control signal        
    input [31:0] resultW,       // Write-back result data
    input [4:0] rdW,
    input flush,
    output reg regwriteE, isimmediateE, memwriteE, isloadE, memreadE, branchE, jumpE,  // Control signals for execution
    output reg [3:0] alusignalE,
    output reg [31:0] op1E, op2E, immxE, jumpoffset, // Register values, extended immediate, and jump offset
    output reg [4:0] rdE, rs1E, rs2E,                // Register addresses
    output reg [31:0] pcE, pcplus4E                  // Program Counter and PC+4         
);

    // Declare intermediate wires for control signals and data
    wire [1:0] aluopD;
    wire regdestD, regwriteD, isimmediateD, memreadD, memwriteD, isloadD, branchD, jumpD;
    wire [31:0] op1D, op2D, immxD, fullJumpOffset;
    wire [4:0] rs1D, rs2D, rdD;
    wire [3:0] alusignalD;

    wire [31:0] flushedOp1D, flushedOp2D, flushedImmxD, flushedJumpOffset, flushedPcD, flushedPcplus4D;
    wire [3:0] flushedAluSignalD;
    wire regwriteDCH, isimmediateDCH, memwriteDCH, isloadDCH, memreadDCH, branchDCH, jumpDCH;
    wire [4:0] flushedRdD, flushedRs1D, flushedRs2D;

    // Control Unit instantiation
    Control_Unit control_unit(
        .opcode(instrD[31:26]),   
        .IR(instrD),
        .AluOp(aluopD),
        .RegDest(regdestD),
        .RegWrite(regwriteD),
        .ALUSrc(isimmediateD),
        .MemRead(memreadD),
        .MemWrite(memwriteD),
        .MemToReg(isloadD),
        .Branch(branchD),
        .Jump(jumpD)
    );

    // Register File instantiation
    Reg_File register_file(
        .rst(rst),
        .isWB(regwriteW),
        .read_reg1(instrD[25:21]),   
        .read_reg2(instrD[20:16]),   
        .op1(op1D),
        .op2(op2D),
        .write_reg(rdW), 
        .write_data(resultW)
    );

    // Sign Extension module instantiation
    signExt sign_extender(
        .inData(instrD[15:0]),
        .outData(immxD)
    );

    // Shift and concatenate for jump address
    ShiftLeftForJump jump_shift(
        .inData(instrD[25:0]),
        .outData(fullJumpOffset[27:0])
    );
    assign fullJumpOffset[31:28] = pcplus4D[31:28];

    // ALU Control instantiation
    ALUcontrol alu_control(
        .funct(instrD[5:0]),
        .opcode(instrD[31:26]),
        .ALUop(aluopD),
        .ALUsignal(alusignalD)
    );

    // Flushing logic
    Flush flush_module(
        .flush(flush),
        .alusignalD(alusignalD),
        .op1D(op1D),
        .op2D(op2D),
        .immxD(immxD),
        .jumpoffset(fullJumpOffset),
        .regwriteD(regwriteD),
        .isimmediateD(isimmediateD),
        .memwriteD(memwriteD),
        .isloadD(isloadD),
        .memreadD(memreadD),
        .branchD(branchD),
        .jumpD(jumpD),
        .pcD(pcD),
        .pcplus4D(pcplus4D),
        .rdD(rdD),
        .rs1D(rs1D),
        .rs2D(rs2D),
        .alusignalDCH(flushedAluSignalD),
        .op1DCH(flushedOp1D),
        .op2DCH(flushedOp2D),
        .immxDCH(flushedImmxD),
        .jumpoffsetCH(flushedJumpOffset),
        .regwriteDCH(regwriteDCH),
        .isimmediateDCH(isimmediateDCH),
        .memwriteDCH(memwriteDCH),
        .isloadDCH(isloadDCH),
        .memreadDCH(memreadDCH),
        .branchDCH(branchDCH),
        .jumpDCH(jumpDCH),
        .pcDCH(flushedPcD),
        .pcplus4DCH(flushedPcplus4D),
        .rdDCH(flushedRdD),
        .rs1DCH(flushedRs1D),
        .rs2DCH(flushedRs2D)
    );

    assign rdD = (regdestD) ? instrD[15:11] : instrD[20:16]; 
    assign rs1D = instrD[25:21];
    assign rs2D = instrD[20:16];

    // Pipeline registers: Store control and data signals
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            alusignalE     <= 4'b0000;
            regwriteE      <= 1'b0;
            isimmediateE   <= 1'b0;
            memwriteE      <= 1'b0;
            isloadE        <= 1'b0;
            memreadE       <= 1'b0;
            branchE        <= 1'b0;
            jumpE          <= 1'b0;
            op1E           <= 32'b0;
            op2E           <= 32'b0;
            immxE          <= 32'b0;
            rdE            <= 5'b0;
            pcE            <= 32'b0;
            pcplus4E       <= 32'b0;
            rs1E           <= 5'b0;
            rs2E           <= 5'b0;
            jumpoffset     <= 32'b0;
        end else begin
            alusignalE     <= flushedAluSignalD;
            regwriteE      <= regwriteDCH;
            isimmediateE   <= isimmediateDCH;
            memwriteE      <= memwriteDCH;
            isloadE        <= isloadDCH;
            memreadE       <= memreadDCH;
            branchE        <= branchDCH;
            jumpE          <= jumpDCH;
            op1E           <= flushedOp1D;
            op2E           <= flushedOp2D;
            immxE          <= flushedImmxD;
            rdE            <= flushedRdD;
            pcE            <= flushedPcD;
            pcplus4E       <= flushedPcplus4D;
            rs1E           <= flushedRs1D;
            rs2E           <= flushedRs2D;
            jumpoffset     <= flushedJumpOffset;
        end
    end

endmodule
