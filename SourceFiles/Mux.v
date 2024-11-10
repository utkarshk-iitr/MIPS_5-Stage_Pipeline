module Mux(
    input selection_line, 
    input [31:0] input1, 
    input [31:0] input2, 
    output [31:0] out
);

    assign out = (selection_line) ? input2 : input1;
endmodule

module Mux_4_by_1 (
    input [31:0] input1, 
    input [31:0] input2, 
    input [31:0] input3,
    input [31:0] input4,
    input [1:0] selection_line, 
    output [31:0] out
);

   assign out = (selection_line == 2'b00) ? input1 : 
                (selection_line == 2'b01) ? input2 : 
                (selection_line == 2'b10) ? input3 : 
                (selection_line == 2'b11) ? input4 : 
                32'h00000000; // Default case, e.g., if selection_line == 2'b01
endmodule
