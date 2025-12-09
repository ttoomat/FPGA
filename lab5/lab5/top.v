// делитель частоты
// 27_000_000 / 1875 = 14_400
module prescaler(
    input iclk,
    output reg oclk
);
initial begin
    oclk = 0;
end
reg[24:0] cnt=0;
always @(posedge iclk) begin
    // Baudrate = 14_400
    // временно поменяли 1875 на 5
    if (cnt < 5-1) begin
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
    input transmit_trig, // when high impulse, the tansmission begins
    //input uart_receive, 
    output uart_transmit
);
wire clk;
// после этого делителя в clk будет тактовый сигнал 10kHz
// этот тактовый сигнал дальше можно для UART типа
prescaler psc0 (
    .iclk(iclk),
    .oclk(clk)
);

wire [7:0] data1 = 8'b0000_1101;
wire tc; // пока не исп, но выходит из transmitter
// проверить, верно ли к внешним выходам подключены линии.
// terminal connect -> посмотреть, приходит ли что-то

transmitter t1 (
    .clk(clk),
    .data(data1),
    .reset(transmit_reset),
    .trig(transmit_trig), // по импульсу trig будем посылать 1 байт
    .tx(uart_transmit), // данные последовательно
    .tc(tc)
);

// можно попробовать взять из ресивера и в трансмиттер передать

// логика будет такая: взять данные из консоли receiver'ом и передать в модуль, включающий числа.

endmodule