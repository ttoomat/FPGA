module signal_part6_top(
    input a, b, clk,
    output q,
    output state
);
reg st;
assign state = (st === 1'bx) ? 0 : st;
assign q = a ^ b ^ state;
always @(posedge clk) begin
    if (a == b) begin
        st <= a;
    end
end

endmodule