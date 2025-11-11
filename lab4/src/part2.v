// нужен счётчик раз в секунду - чтоб обновлять число на индикаторе
// и нужен более быстрый счётчик, чтоб по кругу включать все числа
module display_num(
    input clk_1Hz, clk_10kHz,
    // 16 bit data - DIG, SEG
    output reg SPI_DI,
    output SPI_CLK,
    output reg SPI_NSS
);
// попробуем вывести 1 на дисплей
assign SPI_CLK = clk_10kHz;
// dig = 0, cnt = 1
// digits_segments, должно вывести на 4х разрядах по одному сегменту:
reg[16:0] num = 17'b00000_1111_0000_0111;
reg[4:0] i = 0; // index 0-15
// перебираем все биты в num
always @(negedge SPI_CLK) begin
    SPI_NSS <= 0;
    SPI_DI <= num[i];
    i <= i+1;
    if (i == 16) begin
        SPI_NSS <= 1;
        i <= 0;
    end
end
endmodule
/*
// нужен делитель частоты
module clk_prescaler1(
    input iclk,
    output reg oclk1
);
reg[24:0] clk_cnt1 = 0;
// деление частоты iclk
always @(posedge iclk) begin
    // 1Hz
    if (clk_cnt1 < 27_000_000-1) begin
        clk_cnt1 <= clk_cnt1 + 1;
    end
    else begin
        clk_cnt1 <= 0;
        oclk1 <= !oclk1;
    end
end
endmodule
*/
module clk_prescaler2(
    input iclk,
    output reg oclk2
);
reg[24:0] clk_cnt2 = 0;
// деление частоты iclk
always @(posedge iclk) begin
    // 10kHz
    if (clk_cnt2 < 27-1) begin
        clk_cnt2 <= clk_cnt2 + 1;
    end
    else begin
        clk_cnt2 <= 0;
        oclk2 <= !oclk2;
    end
end
endmodule

// увеличивать число каждую секунду
module part2 (
    input iclk,
    output SPI_DI,
    output SPI_CLK,
    output SPI_NSS
);
wire clk_1Hz = 0;
wire clk_10kHz;
// поделить частоту, чтоб изменялось раз в секунду
/*
clk_prescaler1 psc1 (
    .iclk(iclk),
    .oclk1(clk_1Hz)
);*/
clk_prescaler2 psc2 (
    .iclk(iclk),
    .oclk2(clk_10kHz)
);
// нарисовать число
display_num n(
    .clk_1Hz(clk_1Hz),
    .clk_10kHz(clk_10kHz),
    .SPI_DI(SPI_DI),
    .SPI_CLK(SPI_CLK),
    .SPI_NSS(SPI_NSS)
);
endmodule
