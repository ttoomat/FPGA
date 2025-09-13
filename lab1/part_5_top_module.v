module add1bit (
    input cin, sub,
    input a, b,
    output cout,
    output sum
);
reg sum_reg, cout_reg;

always @* begin
    if (~sub) begin
        sum_reg = (a ^ b) ^ (cin);
        cout_reg = (a & b) | ((a ^ b) & cin);
    end else begin
        // если вычитание - просто таблицы истинности составила
        if (~cin) begin
            sum_reg = a ^ b;
            cout_reg = b & (~a);
        end else begin
            sum_reg = ~(a ^ b);
            cout_reg = ~(a & (~b));
        end
    end
end

assign sum = sum_reg;
assign cout = cout_reg;

endmodule

module add4bit (
    input [3:0] a, b,
    input cin, sub,
    output [3:0] sum,
    output cout
);
reg [3:0] cout1;
add1bit a0 (
    .a(a[0]),
    .b(b[0]),
    .sub(sub),
    .cin(cin),
    .cout(cout1[0]),
    .sum(sum[0])
);
add1bit a1 (
    .a(a[1]),
    .b(b[1]),
    .sub(sub),
    .cin(cout1[0]),
    .cout(cout1[1]),
    .sum(sum[1])
);
add1bit a2 (
    .a(a[2]),
    .b(b[2]),
    .sub(sub),
    .cin(cout1[1]),
    .cout(cout1[2]),
    .sum(sum[2])
);
add1bit a3 (
    .a(a[3]),
    .b(b[3]),
    .sub(sub),
    .cin(cout1[2]),
    .cout(cout1[3]),
    .sum(sum[3])
);
assign cout = cout1[3];
endmodule

module add8bit (
    input [7:0] a, b,
    input cin, sub,
    output [7:0] sum,
    output cout
);
reg cout1;
    add4bit add_high(
        .a(a[3:0]),
        .b(b[3:0]),
        .sub(sub),
        .cin(cin),
        .cout(cout1),
        .sum(sum[3:0])
    );
    add4bit add_low(
        .a(a[7:4]),
        .b(b[7:4]),
        .sub(sub),
        .cin(cout1),
        .cout(cout),
        .sum(sum[7:4])
    );
endmodule

module add16bit (
    input [15:0] a, b,
    input cin, sub,
    output [15:0] sum,
    output cout
);
reg cout1;
add8bit add_high(
    .a(a[7:0]),
    .b(b[7:0]),
    .sub(sub),
    .cin(cin),
    .cout(cout1),
    .sum(sum[7:0])
);
add8bit add_low(
    .a(a[15:8]),
    .b(b[15:8]),
    .sub(sub),
    .cin(cout1),
    .cout(cout),
    .sum(sum[15:8])
);
endmodule

module part_5_top_module (input [31:0]a, input [31:0]b, input sub, output [31:0] sum);
    // если sub = 0 - сложение
    reg cout;
    add16bit add_high(
        .a(a[15:0]),
        .b(b[15:0]),
        .sub(sub),
        .cin(1'b0),
        .cout(cout),
        .sum(sum[15:0])
    );
    add16bit add_low(
        .a(a[31:16]),
        .b(b[31:16]),
        .sub(sub),
        .cin(cout),
        .sum(sum[31:16])
    );
    
endmodule
