// надо добавить счётчик. Нажали на кнопку 1 раз - загорается LED3. Нажали 2 раз - LED4. Ещё раз нажали - LED5.
module top(
    input clk, A,
    output reg LED2, LED3, LED4, LED5
);
reg[1:0] cnt = 0;
reg prev = 0;
always @(posedge clk) begin
    if (A & (~prev)) cnt <= cnt + 2'b01;
    prev <= A;
end

always @(*) begin
    LED2=1;
    LED3=1;
    LED4=1;
    LED5=1;
    case(cnt)
        0: LED2 = 0;
        1: LED3 = 0;
        2: LED4 = 0;
        3: LED5 = 0;
    endcase
end

endmodule
