module ShiftLeftForJump(input [25:0] inData, output reg [27:0] outData);
    always @(inData) begin
        outData = {inData, 2'b00};
    end
endmodule