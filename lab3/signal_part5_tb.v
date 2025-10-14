`timescale 1ns/100ps // 1 ns time unit, 100 ps resolution

module signal_part5_tb;
    reg clk=0;
	always #5 clk = !clk;

	reg a = 0;
	wire [2:0]q;

	reg[15:0] time_of_err = 16'bx;
	wire [2:0]mismatch;
	reg [2:0]q_compare = 3'bx;
	reg isErr = 0;
	event gen_result;

    signal_part5_top top0 (
        .clk(clk),
        .a(a),
        .ind(q)
    );

	initial begin
		$dumpfile("wave.vcd");		// create a VCD waveform dump called "wave.vcd"
		$dumpvars(0, signal_part5_tb);		// dump variable changes in the testbench

	a<=1; q_compare<=3'b100;
	#25 a<=0;
	#10 q_compare<=3'b101;
	#10 q_compare<=3'b110;
	#10 q_compare<=3'b000;
	#10 q_compare<=3'b001;
	#10 q_compare<=3'b010;
	#10 q_compare<=3'b011;
	#10 q_compare<=3'b100;
	#10 q_compare<=3'b101;
	#10 q_compare<=3'b110;
	#10 q_compare<=3'b000;
	#10 q_compare<=3'b001;
	#5 a<=1;
	#5 q_compare<=4;
	#20 a<=0;
	#10 q_compare<=5;
        #5 -> gen_result;

        $finish;
    end

    initial begin
        $monitor("t=%-4d: a=%b, q=%b, q_compare=%b", $time, a, q, q_compare);
    end

endmodule