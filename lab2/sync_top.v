module dtrig (
    input clk,
    input d,
    output reg q
);
always @(posedge clk) begin
    q <= d;
end
endmodule

module sync_top(
    input reg clk_a, clk_b,
    input reg signal,
    output reg signal_sync
);
reg q1, q2;
dtrig trig1(.clk(clk_a), .d(signal), .q(q1));
dtrig trig2(.clk(clk_b), .d(q1), .q(q2));
dtrig trig3(.clk(clk_b), .d(q2), .q(signal_sync));

endmodule
