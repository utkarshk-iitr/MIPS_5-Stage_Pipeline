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
    wire [31:0] result;
    reg [31:0] resultW_r;
    reg [4:0] rdW_r;
    reg regwriteW_r;

    // Mux instantiation to select between ALU result and memory data
    Mux writeback_mux (
        .selection_line(isloadW),
        .input1(aluresultW),
        .input2(readdataW),
        .out(result)
    );

    // Update resultW on the rising edge of clk or reset
    always @(posedge clk ) begin
        if (rst) begin
            resultW_r <= 32'h0;  // Reset resultW to 0
            regwriteW_r <= 1'b0;
            rdW_r <= 5'b00000;
        end else begin
            resultW_r <= result; // Assign the mux output to resultW
            regwriteW_r <= regwrite;
            rdW_r <= rd;
        end
    end

    assign resultW = resultW_r;
    assign regwriteW = regwriteW_r;
    assign rdW =rdW_r;
endmodule
