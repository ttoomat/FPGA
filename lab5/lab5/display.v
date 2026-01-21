// модуль отображения числа на дисплее
// на вход подаётся число, которое хотим отрисовать
module display(
    // есть реальное число. То есть массив из 8 чисел, каждое -- десятичное, т.е. 4 бита.
    input [3:0] real_num [7:0],
    // частота для подачи на SPI дисплей
    input clk_100kHz,
    // 16 bit data - DIG, SEG
    output reg SPI_DI,
    output SPI_CLK,
    output reg SPI_NSS
);
assign SPI_CLK = clk_100kHz;

// dig[i] - активный только i-й разряд
wire[7:0] dig [7:0];
assign dig[0]=8'b0111_1111; // только самый первый разряд
assign dig[1]=8'b1011_1111;
assign dig[2]=8'b1101_1111;
assign dig[3]=8'b1110_1111;
assign dig[4]=8'b1111_0111;
assign dig[5]=8'b1111_1011;
assign dig[6]=8'b1111_1101;
assign dig[7]=8'b1111_1110;

// seg[i] - массив горящих сегментов для определеной цифры
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

// каждый разряд - 17 бит число (1+8+8), кодирующее digits & segments
// и всего 8 таких разрядов
wire[16:0] num [7:0];
assign num[0]={1'b0,dig[0],seg[real_num[0]]};
assign num[1]={1'b0,dig[1],seg[real_num[1]]};
assign num[2]={1'b0,dig[2],seg[real_num[2]]};
assign num[3]={1'b0,dig[3],seg[real_num[3]]};
assign num[4]={1'b0,dig[4],seg[real_num[4]]};
assign num[5]={1'b0,dig[5],seg[real_num[5]]};
assign num[6]={1'b0,dig[6],seg[real_num[6]]};
assign num[7]={1'b0,dig[7],seg[real_num[7]]};

reg[3:0] ind = 0; // какой разряд отображает
reg[4:0] i = 0;   // index 0-15 - какой бит num передаём

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
