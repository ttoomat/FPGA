module signal_part2_top(
    input A, B, C, D,
    output Q
);
assign Q = (B | C);
endmodule