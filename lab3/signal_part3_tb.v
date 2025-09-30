`timescale 1ns/100ps // 1 ns time unit, 100 ps resolution

module signal_part3_tb;
    reg isErr=0;
    reg[15:0] time_of_err = 16'bx;
    event gen_result;
    wire[3:0] mismatch;

    reg[3:0] A, B, C, D, E;
    reg[3:0] Q_compare;
    wire[3:0] Q;

    assign mismatch = Q ^ Q_compare;

    signal_part3_top top0 (
        .A(A), 
        .B(B), 
        .C(C),
        .D(D),
        .E(E),
        .Q(Q) 
    );

	initial begin
		$dumpfile("wave.vcd");		// create a VCD waveform dump called "wave.vcd"
		$dumpvars(0, signal_part3_tb);		// dump variable changes in the testbench

        #5
        #5 A = 4'ha; B = 4'hb; C = 0; D = 4'hd; E = 4'he; Q_compare = 4'hb;
        #5 C = 1; Q_compare = 4'he;
        #5 C = 2; Q_compare = 4'ha;
        #5 C = 3; Q_compare = 4'hd;
        #5 C = 4; Q_compare = 4'hf;
        #5 C = 5;
        #5 C = 6;
        #5 C = 7;
        #5 C = 8;
        #5 C = 9;
        #5 C = 4'ha;
        #5 C = 4'hb;
        #5 C = 4'hc;
        #5 C = 4'hd;
        #5 C = 4'he;
        #5 C = 4'hf;
        #5 C = 0; Q_compare = 4'hb;
        #5 C = 1; Q_compare = 4'he;
        #5 C = 2; Q_compare = 4'ha;

        #5 A = 4'h1; B = 4'h2; C = 0; D = 4'h3; E = 4'h4; Q_compare = 4'h2;
        #5 C = 1; Q_compare = 4'h4;
        #5 C = 2; Q_compare = 4'h1;
        #5 C = 3; Q_compare = 4'h3;
        #5 C = 4; Q_compare = 4'hf;
        #5 C = 5;
        #5 C = 6;
        #5 C = 7;
        #5 C = 8;
        #10 A = 4'h5; B = 4'h6; C = 0; D = 4'h7; E = 4'h8; Q_compare = 4'h6;
        #5 C = 1; Q_compare = 4'h8;
        #5 C = 2; Q_compare = 4'h5;
        #5 C = 3; Q_compare = 4'h7;
        #5 C = 4; Q_compare = 4'hf;
        #5 C = 5;
        #5 C = 6;
        #5 C = 7;
        #5 -> gen_result;

        $finish;
    end

    always @(posedge mismatch) begin
        if ((Q ^ Q_compare) != 4'h0) begin
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