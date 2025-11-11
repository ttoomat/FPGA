// нужен счётчик раз в секунду - чтоб обновлять число на индикаторе
// и нужен более быстрый счётчик, чтоб по кругу включать все числа
module display_num(
    input clk_10Hz, clk_100kHz,
    // 16 bit data - DIG, SEG
    output reg SPI_DI,
    output SPI_CLK,
    output reg SPI_NSS
);
// попробуем вывести 1 на дисплей
assign SPI_CLK = clk_100kHz;
// dig = 0, cnt = 1
// digits_segments, должно вывести на 4х разрядах по одному сегменту:
wire[7:0] dig [7:0];
assign dig[0]=8'b0111_1111; // только самый первый разряд
assign dig[1]=8'b1011_1111;
assign dig[2]=8'b1101_1111;
assign dig[3]=8'b1110_1111;
assign dig[4]=8'b1111_0111;
assign dig[5]=8'b1111_1011;
assign dig[6]=8'b1111_1101;
assign dig[7]=8'b1111_1110;

wire[7:0] seg [9:0];
assign seg[0]=8'b111_11101;
assign seg[1]=8'b011_00001;
assign seg[2]=8'b110_11011;
assign seg[3]=8'b111_10011;
assign seg[4]=8'b011_00111;
assign seg[5]=8'b101_10111;
assign seg[6]=8'b101_11111;
assign seg[7]=8'b111_00001;
assign seg[8]=8'b111_11111;
assign seg[9]=8'b111_10111;

// посылаем туда 17 бит число, кодирующее digits & segments
reg[16:0] num [7:0];

reg[3:0] ind = 0; // типа какой разряд отображает
reg[4:0] i = 0; // index 0-15 - какой бит num передаём

reg[3:0] real_num[7:0];
initial begin
real_num[0]=1;
real_num[1]=2;
real_num[2]=3;
real_num[3]=4;
real_num[4]=5;
real_num[5]=6;
real_num[6]=7;
real_num[7]=8;
end
// изменить посл число один раз в секунду
always @(posedge clk_10Hz) begin
// сначала мусорный бит
num[0]={1'b0,dig[0],seg[real_num[0]]};
num[1]={1'b0,dig[1],seg[real_num[1]]};
num[2]={1'b0,dig[2],seg[real_num[2]]};
num[3]={1'b0,dig[3],seg[real_num[3]]};
num[4]={1'b0,dig[4],seg[real_num[4]]};
num[5]={1'b0,dig[5],seg[real_num[5]]};
num[6]={1'b0,dig[6],seg[real_num[6]]};
num[7]={1'b0,dig[7],seg[real_num[7]]};

if (real_num[7] < 9) begin
    real_num[7] = real_num[7] + 1;
end else begin
    real_num[7] = 0;
    if (real_num[6] < 9) begin
        real_num[6] = real_num[6] + 1;
    end else begin
        real_num[6] = 0;
        if (real_num[5] < 9) begin
            real_num[5] = real_num[5] + 1;
        end else begin
            real_num[5] = 0;
            if (real_num[4] < 9) begin
                real_num[4] = real_num[4] + 1;
            end else begin
                real_num[4] = 0;
                if (real_num[3] < 9) begin
                    real_num[3] = real_num[3] + 1;
                end else begin
                    real_num[3] = 0;
                    if (real_num[2] < 9) begin
                        real_num[2] = real_num[2] + 1;
                    end else begin
                        real_num[2] = 0;
                        if (real_num[1] < 9) begin
                            real_num[1] = real_num[1] + 1;
                        end else begin
                            real_num[1] = 0;
                            if (real_num[0] < 9) begin
                                real_num[0] = real_num[0] + 1;
                            end else begin
                                real_num[0] = 0;
                            end
                        end
                    end
                end
            end
        end
    end
end

end // end always
// перебираем все биты в num
always @(negedge SPI_CLK) begin
    SPI_NSS <= 0;
    SPI_DI <= num[ind][i];
    i <= i+1;
    if (i == 16) begin
        SPI_NSS <= 1;
        i <= 0;
        ind = ind + 1;
    end
end
endmodule

// нужен делитель частоты
module clk_prescaler1(
    input iclk, //100kHz
    output reg oclk1
);
reg[24:0] clk_cnt1 = 0;
// деление частоты iclk
always @(posedge iclk) begin
    // 10Hz
    if (clk_cnt1 < 10_000-1) begin
        clk_cnt1 <= clk_cnt1 + 1;
    end
    else begin
        clk_cnt1 <= 0;
        oclk1 <= !oclk1;
    end
end
endmodule

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

// увеличивать число каждую секунду
module part2 (
    input iclk,
    output SPI_DI,
    output SPI_CLK,
    output SPI_NSS
);
wire clk_10Hz;
wire clk_100kHz;
// поделить частоту, чтоб изменялось раз в секунду
clk_prescaler2 psc2 (
    .iclk(iclk),
    .oclk2(clk_100kHz)
);
clk_prescaler1 psc1 (
    .iclk(clk_100kHz),
    .oclk1(clk_10Hz)
);

// нарисовать число
display_num n(
    .clk_10Hz(clk_10Hz),
    .clk_100kHz(clk_100kHz),
    .SPI_DI(SPI_DI),
    .SPI_CLK(SPI_CLK),
    .SPI_NSS(SPI_NSS)
);
endmodule
