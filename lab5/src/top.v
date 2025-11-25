// делитель частоты
module prescaler(
    input iclk,
    output reg oclk
);
reg[24:0] cnt=0;
always @(posedge iclk) begin
    // 1Hz
    if (cnt < 27_000_000-1) begin
        cnt <= cnt + 1;
    end
    else begin
        cnt <= 0;
        oclk <= !oclk;
    end
end
endmodule

module top(
    input iclk,
    input transmit_reset,
    input transmit_trig,
    output transmit_tx
);
wire clk;
// после этого делителя в clk будет тактовый сигнал 10kHz
// этот тактовый сигнал дальше можно для UART типа
prescaler psc0 (
    .iclk(iclk),
    .oclk(clk)
);

wire [7:0] data1 = 8'b0101_0011;

// надо понять, к каким внешним элементам подключать линии.
// можно trig, reset подключить к кнопке

transmitter t1 (
    .clk(clk),
    .data(data1),
    .reset(transmit_reset),
    .trig(transmit_trig), // по импульсу trig будем посылать 1 байт
    .tx(transmit_tx) // данные последовательно
);

endmodule