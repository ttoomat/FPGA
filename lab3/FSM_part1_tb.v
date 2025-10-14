`timescale 1ns/100ps // 1 ns time unit, 100 ps resolution

module FSM_part1_tb;

reg clk = 0;
reg reset = 0;
reg[12:0] counter;
always #5 clk = !clk;

event gen_result;

FSM_part1_top top0(
    .clk(clk),
    .reset(reset),
    .out(counter)
);

initial begin
    $dumpfile("wave.vcd");		// create a VCD waveform dump called "wave.vcd"
    $dumpvars(0, FSM_part1_tb);		// dump variable changes in the testbench
    #5 reset = 1;
    #5 reset = 0;
    #10100 reset = 1; 
    #10 reset = 0;
    #300 -> gen_result;
    $finish;
end

initial begin
    $monitor("t=%-4d: reset=%b, cnt=%b", $time, reset, counter);
end

endmodule