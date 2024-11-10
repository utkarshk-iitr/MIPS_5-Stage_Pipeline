module Instruct_M(pc, ir);

    input [31:0] pc;
    output reg [31:0] ir;
 
    reg[31:0] mem_array [127:0];
    reg[31:0] data;
    integer i,file;
    initial begin
    for (i = 0; i < 128; i = i + 1) begin
      mem_array[i] = 0;
    end
    //Sample Instruction 1:
    // add r1 r2 r5
    // addi r3 r1 6
    // sub r4 r2 r6
    // sw r4 4[r3]

    //Sample Instruction 2:
    // add r1 r2 r5
    // sub r4 r5 r6

    //Sample Instruction 3:
    // add r1 r2 r5
    // addi r3 r1 6
    // sub r4 r5 r6
    // sw r4 4[r3]

    //Sample Instruction 4:
    // lw r1 4[r3]
    // nop
    // add r1 r2 r3

    //Sample Instruction 5:
    // mul r1 r2
    // slt r1 r2 r6
    // or r1 r2 r5
    // xori r5 r3 2

    i = 0;
    file = $fopen("codes.txt", "r");

    while (!$feof(file)) begin
        if ($fscanf(file, "%h\n", data) == 1) begin
            mem_array[i] = data;
            i = i + 1;
        end
    end
    $fclose(file);
  end

    always @(pc)
    begin
        ir <= mem_array[pc[31:2]];
    end
endmodule
