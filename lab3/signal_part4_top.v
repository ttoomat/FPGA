module signal_part4_top(
    input a, clk,
    output reg p, q
);
always @(*) begin
    if (clk) p <= a;
end
always @(negedge clk) begin
    q <= p;
end
endmodule