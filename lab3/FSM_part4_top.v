module FSM_part4_top(
    input clk, reset, data, ack, // ресет от пользователя
    output reg counting, done,
    output wire[3:0] count
);
reg start_shifting;
reg[3:0] delay;
reg[12:0] cnt;
// ловим последовательность 1101
FSM_part3_top module1(
    .clk(clk),
    .reset(reset),
    .data(data),
    .start_shifting(start_shifting)
);
reg [2:0]n_4bit = 4;
integer i=0;
// когда start shifting -- считываем 4 бита с линии данных
// надо как-то start shifting сбрасывать после считывания 4 бита
always @(posedge clk, start_shifting) begin
    if (done === 1'bx) done = 0;
    if (counting === 1'bx) counting = 0;
    if (start_shifting) begin
        if (n_4bit > 0) begin
            // как остановить запись в delay?
            delay[0] <= data;
            delay[1] <= delay[0];
            delay[2] <= delay[1];
            delay[3] <= delay[2];
            n_4bit -= 1;
            // начали счёт
        end
    end
    if (n_4bit == 0) counting = 1;
    if (counting) begin
        // delay+1 раз считаем до 1000
        for (i=0; i < delay + 1; i++) begin
            if (cnt < 12'd999) begin
                cnt = cnt + 12'd1;
            end else begin
                cnt = 12'd0;
            end
        end
    end
    /*
    if (i == delay+1) begin
        done = 1;
        counting=0;
    end
    */
end
// далее -- режим счёта 

endmodule