`timescale 1ns/100ps // 1 ns time unit, 100 ps resolution

module signal_part4_tb;
    reg clk=0;
	always #30 clk = !clk;

	reg a = 0;
	wire p, q;

	reg[15:0] time_of_err = 16'bx;
	wire mismatch;
	reg q_compare = 1'bx;
    reg p_compare = 1'bx;
	reg isErr = 0;
	event gen_result;

	assign mismatch = (q != q_compare) || (p != p_compare);

    signal_part4_top top0 (
        .clk(clk),
        .a(a),
        .p(p),
        .q(q)
    );

	initial begin
		$dumpfile("wave.vcd");		// create a VCD waveform dump called "wave.vcd"
		$dumpvars(0, signal_part4_tb);		// dump variable changes in the testbench

        a=0; p_compare=0; q_compare=0;
        #15 a=1;
        #5 a=0;
        #5 a=1;
        #5 a=0;
        // clk=1
        #5 a=1; p_compare=1;
        #5 a=0; p_compare=0;
        #5 a=1; p_compare=1;
        #5 a=0; p_compare=0;
        #5 a=1; p_compare=1;
        //clk=0
        #5 a=0; q_compare=1;
        #5 a=1;
        #5 a=0;
        #5 a=1;
        #5 a=0;
        // clk=1
        #10 a=0; p_compare=0;
        #20 a=1; p_compare=1;
        #5 a=0; p_compare=0;
        #5 a=1; q_compare=0;
        #5 a=0;
        #5 a=1;
        #5 a=0;
        #5 a=1;
        #5 a=0;
        #5 -> gen_result;

        $finish;
    end

    always @(posedge mismatch) begin
        if (q != q_compare) begin
            isErr = 1;
            time_of_err = time_of_err === 16'bx ? $time : time_of_err;
        end
    end
    initial begin
        @(gen_result) begin
			if (isErr) begin
				$display("Result: FAIL, First error at t=%-4d", time_of_err);
            end else begin
				$display("Result: PASS");
            end
			$finish;
        end
    end
    initial begin
        $monitor("t=%-4d: a=%b, p=%b, p_compare=%b, q=%b, q_compare=%b", $time, a, p, p_compare, q, q_compare);
    end

endmodule