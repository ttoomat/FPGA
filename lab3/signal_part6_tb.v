`timescale 1ns/100ps // 1 ns time unit, 100 ps resolution

module signal_part6_tb;
    reg clk=0;
	always #5 clk = !clk;

	reg a = 0, b = 0;
	wire q, state;

	reg q_compare, state_compare;
	event gen_result;

	assign mismatch = (q != q_compare);

    signal_part6_top top0 (
        .clk(clk),
        .a(a),
        .b(b),
        .q(q),
        .state(state)
    );
    initial begin
		$dumpfile("wave.vcd");		// create a VCD waveform dump called "wave.vcd"
		$dumpvars(0, signal_part6_tb);		// dump variable changes in the testbench

	a<=0; b<=0; q_compare<=0; state_compare<=0;
	#25 b<=1; q_compare<=1;
    #10 b<=0; a<=1;
    #10 b<=1; q_compare<=0;
	#10 a<=0; b<=0; q_compare<=1; state_compare <= 1;
    #10 a<=1; b<=1; q_compare<=0; state_compare <= 0;
    #10 q_compare<=1; state_compare <= 1;
    #20 b<=0; q_compare <= 0; 
    #10 b<=1; a<=0;
    #10 b<=0; q_compare<=1;
    #10 q_compare<=0; state_compare <= 0;
    #10 -> gen_result;

        $finish;
    end

    initial begin
        $monitor("t<=%-4d: a<=%b, b<=%b, q<=%b, q_comp<=%b, state<=%b, state_comp<=%b", $time, a, b, q, q_compare, state, state_compare);
    end

endmodule