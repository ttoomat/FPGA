module add1bit (
    input cin,
    input a, b,
    output cout,
    output sum
);
assign sum = (a ^ b) ^ (cin);
assign cout = (a & b) | ((a^b) & cin);
endmodule

module add8bit (
    input [7:0] a, b,
    input cin,
    output [7:0] sum,
    output cout1
);

reg [7:0] cout;
add1bit a0 (
    .a(a[0]),
    .b(b[0]),
    .cin(cin),
    .cout(cout[0]),
    .sum(sum[0])
);
add1bit a1 (
    .a(a[1]),
    .b(b[1]),
    .cin(cout[0]),
    .cout(cout[1]),
    .sum(sum[1])
);
add1bit a2 (
    .a(a[2]),
    .b(b[2]),
    .cin(cout[1]),
    .cout(cout[2]),
    .sum(sum[2])
);
add1bit a3 (
    .a(a[3]),
    .b(b[3]),
    .cin(cout[2]),
    .cout(cout[3]),
    .sum(sum[3])
);
add1bit a4 (
    .a(a[4]),
    .b(b[4]),
    .cin(cout[3]),
    .cout(cout[4]),
    .sum(sum[4])
);
add1bit a5 (
    .a(a[5]),
    .b(b[5]),
    .cin(cout[4]),
    .cout(cout[5]),
    .sum(sum[5])
);
add1bit a6 (
    .a(a[6]),
    .b(b[6]),
    .cin(cout[5]),
    .cout(cout[6]),
    .sum(sum[6])
);
add1bit a7 (
    .a(a[7]),
    .b(b[7]),
    .cin(cout[6]),
    .cout(cout[7]),
    .sum(sum[7])
);
assign cout1 = cout[7];

endmodule

module add16bit (
    input [15:0] a, b,
    input cin,
    output [15:0] sum,
    output cout
);
add8bit add_low(
    .a(a[7:0]),
    .b(b[7:0]),
    .cin(cin),
    .cout1(cout),
    .sum(sum[7:0])
);
add8bit add_high(
    .a(a[15:8]),
    .b(b[15:8]),
    .cin(cout),
    .sum(sum[15:8])
);
endmodule

module part_4_top_module (input [31:0]a, input [31:0]b, output [31:0] sum);
    reg cout;
    add16bit add_low(
        .a(a[15:0]),
        .b(b[15:0]),
        .cin(1'b0),
        .cout(cout),
        .sum(sum[15:0])
    );
    reg [15:0]sum0, sum1;
    add16bit add_high0(
        .a(a[31:16]),
        .b(b[31:16]),
        .cin(1'b0),
        .sum(sum0[15:0])
    );
    add16bit add_high1(
        .a(a[31:16]),
        .b(b[31:16]),
        .cin(1'b1),
        .sum(sum1[15:0])
    );
    reg [15:0]sum_high;
    always @* begin
        if (cout) begin
            sum_high = sum1;
        end else begin
            sum_high = sum0;
        end
    end
    assign sum[31:16] = sum_high[15:0];
endmodule