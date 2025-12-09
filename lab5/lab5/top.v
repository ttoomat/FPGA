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
    input transmit_trig, // работает как enable, если честно
    input receive_reset,
    input uart_receive,
    output uart_transmit
);
wire clk;
// после этого делителя в clk будет тактовый сигнал 10kHz
// этот тактовый сигнал дальше можно для UART типа
prescaler psc0 (
    .iclk(iclk),
    .oclk(clk)
);

wire [7:0] data1;// = 8'b0000_1101;
wire tc; // пока не исп, но выходит из transmitter
// проверить, верно ли к внешним выходам подключены линии.
// terminal connect -> посмотреть, приходит ли что-то

// можно попробовать взять из ресивера и в трансмиттер передать
receiver r1 (
    .iclk(iclk), // её будем делить уже как захочем
    .reset(receive_reset),
    .rx(uart_receive), // 1 bit data
    .data(data1) // выход - массив
);

transmitter t1 (
    .clk(clk),
    .data(data1),
    .reset(transmit_reset),
    .trig(transmit_trig), // по импульсу trig будем посылать 1 байт
    .tx(uart_transmit), // данные последовательно
    .tc(tc)
);


// логика будет такая: взять данные из консоли receiver'ом и передать в модуль, включающий числа.
// и ещё трансмиттить то, что получили. Или то, что изменилось по нажатию кнопки.
// + реализовать сложение и вычитание на 1 по нажатию кнопки. Одна кнопка для прибавления 1, другая для вычитания 1.
endmodule