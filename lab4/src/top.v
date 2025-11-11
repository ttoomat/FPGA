// lab4
module top(
    //input A, B, C,
    //output LED1, LED2, LED3, LED4, LED5, LED6, LED7, LED8
    input iclk,
    output SPI_DI, SPI_CLK, SPI_NSS
);

/*
// 8 LUT3 - ariphmetic operations
part1 p1(
    A, B, C,
    LED1, LED2, LED3, LED4, LED5, LED6, LED7, LED8
);
*/
part2 p2 (
    .iclk(iclk),
    .SPI_DI(SPI_DI),
    .SPI_CLK(SPI_CLK),
    .SPI_NSS(SPI_NSS)
);
endmodule
