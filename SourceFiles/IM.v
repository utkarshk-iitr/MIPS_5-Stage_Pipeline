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
    // mem_array[0]=32'h00222820;    // add r1 r2 r5
    // mem_array[1]=32'h20610006;    // addi r3 r1 6
    // mem_array[2]=32'h00823022;    // sub r4 r2 r6
    // mem_array[3] = 32'hAC640004;  // sw r4 4[r3]

    // mem_array[0]=32'h00222820;  // add r1 r2 r5
    // mem_array[1]=32'h00853022;  // sub r4 r5 r6

    // mem_array[0]=32'h00222820;    // add r1 r2 r5
    // mem_array[1]=32'h20610006;    // addi r3 r1 6
    // mem_array[2]=32'h00853022;    // sub r4 r5 r6
    // mem_array[3] = 32'hAC640004;  // sw r4 4[r3]

    // mem_array[0]=32'h8C610004;  // lw r1 4[r3]
    // mem_array[1]=32'h00000000;  // nop
    // mem_array[2]=32'h00221820;  // add r1 r2 r3

    // mem_array[0] = 32'h00220018;  // mul r1 r2
    
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
