module clk_prescaler2(
    input iclk,
    output reg oclk2
);
reg[24:0] clk_cnt2 = 0;
// деление частоты iclk
always @(posedge iclk) begin
    // 100kHz
    if (clk_cnt2 < 270-1) begin
        clk_cnt2 <= clk_cnt2 + 1;
    end
    else begin
        clk_cnt2 <= 0;
        oclk2 <= !oclk2;
    end
end
endmodule

// делитель частоты для Baudrate UART
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

// делитель частоты для дисплея

module top(
    input iclk,
    input transmit_reset,
    input transmit_trig, // работает как enable, если честно
    input receive_reset,
    input uart_receive,
    output uart_transmit,
    output [3:0] real_num [7:0],
    output SPI_DI,
    output SPI_CLK,
    output SPI_NSS
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
//reg [31:0] received_number; // we receive 8 decimal numbers. 4 packages of 2 bytes. 32

// можно попробовать взять из ресивера и в трансмиттер передать
receive8num r8num (
    .iclk(iclk),
    .reset(receive_reset),
    .rx(uart_receive),
    .real_num(real_num)
);

wire clk_100kHz; // смена разряда дисплея
clk_prescaler2 psc2 (
    .iclk(iclk),
    .oclk2(clk_100kHz)
);

display display_received(
    // есть реальное число. То есть массив из 8 чисел, каждое -- десятичное, т.е. 4 бита.
    .real_num(real_num),
    // частота для подачи на SPI дисплей
    .clk_100kHz(clk_100kHz),
    .SPI_DI(SPI_DI),
    .SPI_CLK(SPI_CLK),
    .SPI_NSS(SPI_NSS)
);

/*
receiver r1 (
    .iclk(iclk), // её будем делить уже как захочем
    .reset(receive_reset),
    .rx(uart_receive), // 1 bit data
    .data(data1) // выход - массив
);
*/

/*
сейчас receiver получает 8 бит число.
А нам надо 8 10-чных чисел.
1 десятичное число = 4 бит
Т.е. будет 2 десятичных числа за посылку.
Т.е. 4 посылки?
Можно пока хотя бы просто 8 битное число принимать и его отображать.

Думаю можно просто 8-битное число на вход где надо 30-битное и остальные числа будут забиты нулями.
*/

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