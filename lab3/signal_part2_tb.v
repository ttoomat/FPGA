`timescale 1ns/100ps // 1 ns time unit, 100 ps resolution

module signal_part2_tb;
    reg isErr=0;
    reg[15:0] time_of_err = 16'bx;
    event gen_result;
    wire mismatch;

    reg A, B, C, D;
    reg Q_compare;
    wire Q;

    assign mismatch = Q ^ Q_compare;

    signal_part2_top top0 (
        .A(A), 
        .B(B), 
        .C(C),
        .D(D),
        .Q(Q) 
    );

	initial begin
		$dumpfile("wave.vcd");		// create a VCD waveform dump called "wave.vcd"
		$dumpvars(0, signal_part2_tb);		// dump variable changes in the testbench

        #5
        A = 0;
        B = 0;
        C = 0;
        D = 0;
		Q_compare = 0;
        #5
        D = 1;
        #5
        C = 1;
        D = 0;
        Q_compare = 1;
        #5
        C = 1;
        D = 1;
        #5
        B = 1;
        C = 0;
        D = 0;
        #5
        D = 1;
        #5
        C = 1;
        D = 0;
        #5
        D = 1;

        #5
        A = 1;
        B = 0;
        C = 0;
        D = 0;
        Q_compare = 0;
        #5
        D = 1;
        #5
        C = 1;
        D = 0;
        Q_compare = 1;
        #5
        D = 1;
        #5
        B = 1;
        C = 0;
        D = 0;
        #5
        D = 1;
        #5
        C = 1;
        D = 0;
        #5
        D = 1;
        #5 -> gen_result;

        $finish;
    end

    always @(posedge mismatch) begin
        if (Q ^ Q_compare) begin
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
        $monitor("t=%-4d: A=%b, B=%b, C=%b, D=%b, Q=%b, Q_compare=%b", $time, A, B, C, D, Q, Q_compare);
    end

endmodule