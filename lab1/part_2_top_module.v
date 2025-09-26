module Dtrig_param(q, d, clk);
parameter SIZE = 8;
output reg [SIZE-1:0] q;
input [SIZE-1:0] d;
input clk;

always @(posedge clk) begin
    q <= d;
end
endmodule

module part_2_top_module (input [7:0]d, input [1:0]sel, input clk, output reg [7:0]q);
    // write code here
    // последовательные 8-бит триггеры
    reg [7:0]q0, q1, q2; // d -> q0->q1->q2
    Dtrig_param D1(
        .clk(clk),
        .d(d),
        .q(q0)
    );

    Dtrig_param D2(
        .clk(clk),
        .d(q0),
        .q(q1)
    );

    Dtrig_param D3(
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