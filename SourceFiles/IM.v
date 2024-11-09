module Instruct_M(memread, pc, ir);

    input memread;
    input [31:0] pc;
    output reg [31:0] ir;
 
    reg[31:0] mem_array [127:0];
    integer i;
    initial begin
    for (i = 0; i < 128; i = i + 1) begin
      mem_array[i] = 0;
    end
    mem_array[0]=32'h00222820;    // add r1, r2, r5
    mem_array[1]=32'h20610006;    // addi r3, r1, 6
    mem_array[2]=32'h00823022;    // sub r4, r5, r6
    mem_array[3] = 32'hAC640004;  // st r4, 4[r3]

  end
    always @(memread, pc)
    begin
        if(memread)
        begin
            ir <= mem_array[pc[31:2]];
        end
    end
endmodule