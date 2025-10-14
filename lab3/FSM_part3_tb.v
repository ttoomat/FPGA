`timescale 1ns/100ps // 1 ns time unit, 100 ps resolution

module FSM_part3_tb;

reg clk = 0;
reg reset = 0;
reg data;
reg start_shifting;
reg shift_compare;
always #5 clk = !clk;

event gen_result;

FSM_part3_top top0(
    .clk(clk),
    .reset(reset),
    .data(data),
    .start_shifting(start_shifting)
);

initial begin
    $dumpfile("wave.vcd");		// create a VCD waveform dump called "wave.vcd"
    $dumpvars(0, FSM_part3_tb);		// dump variable changes in the testbench
    clk=1; reset=1; data=0; shift_compare=0;
    #10 reset=0;
    #10 data=1;
    #10 data=0;
    #10 data=1;
    #50 data=0;
    #10 data=1;
    #10 shift_compare=1;
    #10 data=0;
    #20 reset=1; data=1;
    #10 shift_compare=0;
    #10 -> gen_result;
    $finish;
end

initial begin
    $monitor("t=%-4d: reset=%b, data=%b, shift=%b, shift_compare=%b", $time, reset, data, start_shifting, shift_compare);
end

endmodule