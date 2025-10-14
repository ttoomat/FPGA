`timescale 1ns/100ps // 1 ns time unit, 100 ps resolution

module FSM_part4_tb;

reg clk = 0, reset = 1, ack = 0;
reg data=0, data_compare=0;
reg counting, done, counting_compare=0, done_compare=0;
reg [3:0]count;
reg [3:0]count_compare;

always #5 clk = !clk;

event gen_result;

FSM_part4_top top0(
    .clk(clk),
    .reset(reset),
    .data(data),
    .ack(ack),
    // output
    .counting(counting),
    .count(count),
    .done(done)
);

initial begin
    $dumpfile("wave.vcd");		// create a VCD waveform dump called "wave.vcd"
    $dumpvars(0, FSM_part4_tb);		// dump variable changes in the testbench
    clk=1; reset=1; data=0; counting_compare=0; done_compare=0;
    #10 reset=0; data=1;
    #10 data=0;
    #20 data=1;
    #20 data=0;
    #10 data=1;
    #10 data=0;
    #30 data=1;
    #50000
    #10 -> gen_result;
    $finish;
end

/*
initial begin
    $monitor("t=%-4d: reset=%b, data=%b, ack=%b, counting=%b, done=%b", $time, reset, data, ack, counting, done);
end
*/
endmodule