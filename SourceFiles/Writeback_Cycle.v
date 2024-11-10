// `include "Mux.v"

module writeback_cycle(
    input clk,
    input rst,
    input isloadW,
    input [4:0] rd,            // Control signal to select data source for writeback
    input regwrite,
    input [31:0] pcplus4W,
    input [31:0] aluresultW,   // Result from ALU operation
    input [31:0] readdataW,    // Data read from memory 
    output [31:0] resultW, // Declare as reg for use in always block
    output regwriteW,
    output [4:0] rdW
);
    // Mux instantiation to select between ALU result and memory data
    Mux writeback_mux (
        .selection_line(isloadW),
        .input1(aluresultW),
        .input2(readdataW),
        .out(resultW)
    );

    assign regwriteW = regwrite;
    assign rdW =rd;
endmodule
