`timescale 1ns/100ps // 1 ns time unit, 100 ps resolution
/*
Оттестируем transmitter.
*/
module lab5_tb;
    reg clk=1;
	always #1 clk = !clk;
    // DUT inputs
	reg transmit_reset = 0, transmit_trig = 0;
    // DUT outputs
	wire uart_transmit;

	event gen_result;

    top t0(
        .iclk(clk),
        .transmit_reset(transmit_reset),
        .transmit_trig(transmit_trig),
        .uart_transmit(uart_transmit)
    );

    initial begin
		$dumpfile("wave.vcd");		// create a VCD waveform dump called "wave.vcd"
		$dumpvars(0, lab5_tb);		// dump variable changes in the testbench

    transmit_reset <= 1; #10
    transmit_reset <= 0; #10 
    #10 // чёто ждём покайфу
    transmit_trig <= 1; #10
    #1000
	
    #10 -> gen_result;

        $finish;
    end

    //initial begin
    //    $monitor("t<=%-4d: a<=%b, b<=%b, q<=%b, q_comp<=%b, state<=%b, state_comp<=%b", $time, a, b, q, q_compare, state, state_compare);
    //end

endmodule