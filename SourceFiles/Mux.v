module Mux(selection_line, input1, input2, out);
    input selection_line;
    input [31:0] input1, input2;
    output [31:0] out;

    assign out = (selection_line) ? input2 : input1;
endmodule

module Mux_3_by_1 (input1, input2, input3, selection_line, out);
    input [31:0] input1, input2, input3;
    input [1:0] selection_line;
    output [31:0] out;

    assign out = (selection_line == 2'b00) ? input1 : (selection_line == 2'b01) ? input2 : (selection_line == 2'b10) ? input3 : 32'h00000000;
endmodule