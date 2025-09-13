module Dtrig1bit (
    input clk,
    input d,
    output q
);
reg q_reg;
always @(posedge clk) begin
    q_reg <= d;
end
assign q = q_reg;
endmodule

// 8 bit trig consists of 8 x 1 bit trig
module Dtrig8bit (
    input clk,
    input [7:0]d,
    output [7:0]q
);

Dtrig1bit dtrig0(
    .clk(clk),
    .d(d[0]),
    .q(q[0])
);
Dtrig1bit dtrig1(
    .clk(clk),
    .d(d[1]),
    .q(q[1])
);
Dtrig1bit dtrig2(
    .clk(clk),
    .d(d[2]),
    .q(q[2])
);
Dtrig1bit dtrig3(
    .clk(clk),
    .d(d[3]),
    .q(q[3])
);
Dtrig1bit dtrig4(
    .clk(clk),
    .d(d[4]),
    .q(q[4])
);
Dtrig1bit dtrig5(
    .clk(clk),
    .d(d[5]),
    .q(q[5])
);
Dtrig1bit dtrig6(
    .clk(clk),
    .d(d[6]),
    .q(q[6])
);
Dtrig1bit dtrig7(
    .clk(clk),
    .d(d[7]),
    .q(q[7])
);
endmodule

module part_2_top_module (input [7:0]d, input [1:0]sel, input clk, output reg [7:0]q);
    // write code here
    // последовательные 8-бит триггеры
    reg [7:0]q0, q1, q2; // d -> q0->q1->q2
    Dtrig8bit D1(
        .clk(clk),
        .d(d),
        .q(q0)
    );

    Dtrig8bit D2(
        .clk(clk),
        .d(q0),
        .q(q1)
    );

    Dtrig8bit D3(
        .clk(clk),
        .d(q1),
        .q(q2)
    );

    // multiplexer chooses 1 of the signals
    reg [7:0]out_sel;
    always @* begin
        if ((~sel[1]) & (~sel[0])) begin
            out_sel = d;
        end else if ((~sel[1]) & sel[0]) begin
            out_sel = q0;
        end else if (sel[1] & (~sel[0])) begin
            out_sel = q1;
        end else if (sel[1] & sel[0]) begin
            out_sel = q2;
        end 
    end
    assign q = out_sel;
endmodule