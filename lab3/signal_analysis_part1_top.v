module signal_analysis_part1_top(
    input A, B, C, D,
    output Q
);
assign Q = (A | B) & (C | D);
endmodule