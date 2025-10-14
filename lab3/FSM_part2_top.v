// что делает data?
module FSM_part2_top(
    input clk, shift_ena, count_ena,
    input data,
    output reg[3:0]q
);
reg[3:0] tmp;
always @(posedge clk) begin
    if (tmp === 4'bx) tmp = 0;
    if (data) begin
        if (shift_ena) tmp <= 4'b0001;
        else if (~(shift_ena) & (~count_ena)) begin
            // откуда эта 9-ка вообще?
            tmp = 4'b1001;
            q = 4'b1001;
        end
    end else begin
        if (shift_ena) begin
            // сдвигаем 1 -> 2 -> 4
            tmp <= tmp << 4'b0001;
        end
    end
    if (count_ena) begin
        // считаем вниз, то есть вычитаем
        if (tmp > 0) tmp <= tmp - 4'b0001;
    end
    q <= tmp;
end
endmodule