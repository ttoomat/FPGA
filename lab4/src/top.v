// надо добавить счётчик до 27млн, чтоб поделить частоту входного
// 2^25 = 33_554_432
module top(
    input iclk,
    output reg LED2, LED3, LED4, LED5
);
reg[24:0] clk_cnt = 0;
reg[1:0] state = 0; // 4 состояния светодиодов

// деление частоты iclk
always @(posedge iclk) begin
    if (clk_cnt < 27_000_000-1) begin
        clk_cnt <= clk_cnt + 1;
    end
    else begin
        clk_cnt <= 0;
        state = state + 1;
    end
end

always @(*) begin
    LED2 <= 1;
    LED3 <= 1;
    LED4 <= 1;
    LED5 <= 1;
    case(state)
        0: LED2 <= 0;
        1: LED3 <= 0;
        2: LED4 <= 0;
        3: LED5 <= 0;
    endcase
end

endmodule
