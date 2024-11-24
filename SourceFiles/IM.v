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

    //Sample Instruction 6:
    // li r1 1
    // li r2 10
    // li r3 1
    // beq r2 r0 4
    // mul r1 r2
    // mflo r1
    // sub r2 r3 r2
    // j 3

    //Sample Instruction 7:
    // li r3 21
    // lsl r1 r3 3
    // asr r1 r4 4
    // lsr r1 r4 4

    //Sample Instruction 8
    // li r1 0
    // li r2 1
    // li r3 0
    // li r4 1
    // li r5 10
    // beq r5 r4 6
    // add r1 r2 r3
    // addi r2 r1 0
    // addi r3 r2 0
    // sub r5 r4 r5
    // j 5

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
