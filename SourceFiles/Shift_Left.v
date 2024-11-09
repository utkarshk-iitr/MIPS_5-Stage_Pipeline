module ShiftLeft(input [31:0] inData, output reg [31:0] outData);
    always @(*) begin
        outData = inData << 2;
    end
endmodule