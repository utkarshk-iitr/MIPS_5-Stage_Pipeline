`timescale 1ns/1ps
`include "Top.v"
module TopPipeline_tb;
    reg clk;
    reg rst;

    // Instantiate top pipeline module
    TopPipeline top_inst (
        .clk(clk),
        .rst(rst)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns clock period
    end

    // Reset signal generation
    initial begin
        rst = 1;
        #7 rst = 0; // Release reset after 15 ns
    end

    // VCD dump for waveform viewing
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, TopPipeline_tb);
        
        // Run simulation for a certain period
        #2000;
        $finish;
    end
endmodule
