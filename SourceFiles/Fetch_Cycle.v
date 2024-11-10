// `include "Mux.v"
// `include "PC.v"
// `include "IM.v"
// `include "Adder.v"

module Fetch(
    input clk,
    input rst,
    input isbranchtakenE,
    input [31:0] branchtargetE,
    output [31:0] pcplus4D,
    output [31:0] instrD,
    output [31:0] pcD
);

    // Internal wires
    wire [31:0] pcf, instrf, pc_plus4f, pc_next;
    
    // Pipeline registers for Fetch stage
    reg [31:0] PC_Plus4F_r, InstrF_r, PCF_r;

    // PC Next Mux: Selects between PC+4 and Branch Target
    Mux PC_mux (
        .selection_line(isbranchtakenE),
        .input1(pc_plus4f),
        .input2(branchtargetE),
        .out(pc_next)
    );

    // PC Register Module
    PC PCmodule (
        .clk(clk),
        .rst(rst),
        .input1(pc_next),
        .out(pcf)
    );

    // Instruction Memory (IM)
    Instruct_M IM (
        .pc(pcf),
        .ir(instrf)
    );

    // PC + 4 Adder
    Adder PC_adder (
        .input1(pcf),
        .input2(32'h00000004),
        .out(pc_plus4f)
    );

    // Pipeline Register Update
    always @(posedge clk ) begin
        if (rst) begin
            PC_Plus4F_r <= 32'h00000000;
            InstrF_r <= 32'h00000000;
            PCF_r <= 32'h00000000;
        end else begin
            PC_Plus4F_r <= pc_plus4f;
            InstrF_r <= instrf;
            PCF_r <= pcf;
        end
    end

    // Output Assignments
    assign instrD = InstrF_r;
    assign pcplus4D = PC_Plus4F_r;
    assign pcD = PCF_r;

endmodule
