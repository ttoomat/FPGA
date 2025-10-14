`timescale 1ns/100ps // 1 ns time unit, 100 ps resolution

module FSM_part2_tb;

reg clk = 0;
reg shift_ena = 0, count_ena = 0;
reg data;
reg[3:0]q;
reg[3:0]q_compare;
always #5 clk = !clk;

event gen_result;

FSM_part2_top top0(
    .clk(clk),
    .shift_ena(shift_ena),
    .count_ena(count_ena),
    .data(data),
    .q(q)
);

initial begin
    $dumpfile("wave.vcd");		// create a VCD waveform dump called "wave.vcd"
    $dumpvars(0, FSM_part2_tb);		// dump variable changes in the testbench
    clk=1; q_compare=0; data=0;
    #20 shift_ena=1; data=1;
    #10 data=0; q_compare=1;
    #10 q_compare=2;
    #10 q_compare=4; data=1;
    #10 shift_ena=0; q_compare=9;
    #30 count_ena=1;
    #10 q_compare=8;
    #10 q_compare=7;
    #10 q_compare=6;
    #10 q_compare=5;
    #10 count_ena=0; q_compare=4;
    #10 -> gen_result;
    $finish;
end

initial begin
    $monitor("t=%-4d: shift_ena=%b, count_ena=%b, data=%b, q=%b", $time, shift_ena, count_ena, data, q);
end

endmodule