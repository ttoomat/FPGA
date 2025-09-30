`timescale 1ns/100ps // 1 ns time unit, 100 ps resolution

module sync_top_tb;

	reg clk_a=0, clk_b=0;
	always #5 clk_a = !clk_a;
	always #3 clk_b = !clk_b;

	reg signal;
	wire signal_sync;

	sync_top top0
	(
		.clk_a(clk_a),
		.clk_b(clk_b),
		.signal(signal),
		.signal_sync(signal_sync)
	);

	initial begin
		$dumpfile("wave.vcd");		// create a VCD waveform dump called "wave.vcd"
		$dumpvars(0, sync_top_tb);		// dump variable changes in the testbench
		
		signal <= 0;
		#2
		signal <= 1;
		@(posedge clk_b);
		@(posedge clk_b);
		@(posedge clk_b);
		signal <= 0;
		@(posedge clk_b);
		@(posedge clk_b);
		#6
		signal <= 1;
		#6
		signal <= 0;
		#8
		signal <= 1;
		#4
		signal <= 0;
		#4
		signal <= 1;
		#3
		signal <= 0;
		@(posedge clk_b);
		@(posedge clk_b);
		@(posedge clk_b);

		$finish;
		
	end

	initial begin
		$monitor("t=%-4d: signal = %b, signal_sync = %b", $time, signal, signal_sync);
	end
endmodule