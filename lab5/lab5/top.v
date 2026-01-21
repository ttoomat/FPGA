/* Модуль получения тактов для сегментного индикатора.
 */
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

/* Делитель частоты для Baudrate UART.
 * В рамках симуляции 1875 изменено на 5.
 * 27_000_000 / 1875 = 14_400
 */
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

/* Наиболее высокоуровневый модуль.
 * Связывает в единую логику receive8num, display, кнопки и transmit.
 * логика будет такая: взять данные из консоли receiver'ом и передать в модуль, включающий числа.
 * и ещё трансмиттить то, что получили. Трансмиттить всегда / если изменилось по нажатию кнопки.
 * + сложение и вычитание на 1 по нажатию кнопки. Одна кнопка для прибавления 1, другая для вычитания 1.
 */
module top(
    // все эти порты должны иметь реальные подключения на плате
    input iclk, // 27 MHz
    input transmit_reset,
    input transmit_trig, // работает как enable
    input receive_reset, // не исп
    input uart_receive, // rx line
    output uart_transmit, // tx line
    output [3:0] real_num [7:0], // только для симуляции
    // buttons:
    input SW_pos, // сигнал с кнопки, прибавляющей числа
    input SW_neg,
    // display:
    output SPI_DI,
    output SPI_CLK,
    output SPI_NSS
);
// тактовый сигнал для transmitter
wire clk;
prescaler psc0 (
    .iclk(iclk),
    .oclk(clk)
);
// тактовый сигнал для прохода по всем разрядам для дисплея
wire clk_100kHz; 
clk_prescaler2 psc2 (
    .iclk(iclk),
    .oclk2(clk_100kHz)
);

// ниже -- массив, который использовали для тестировки transmitter -> receiver
//wire [7:0] data1; // = 8'b0000_1101;
// на железе -- проверить, верно ли к внешним выходам подключены линии.
// terminal connect -> посмотреть, приходит ли что-то от transmitter

// testbench -> receive8num
receive8num r8num (
    .iclk(iclk),
    .reset(receive_reset),
    .rx(uart_receive),
    .real_num(real_num)
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

/* пока передача не используется */
/*
transmitter t1 (
    .clk(clk),
    .data(data1),
    .reset(transmit_reset),
    .trig(transmit_trig), // по импульсу trig будем посылать 1 байт
    .tx(uart_transmit), // данные последовательно
    .tc(tc)
);
*/
endmodule
