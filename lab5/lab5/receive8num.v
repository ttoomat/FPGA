/* Модуль считывания 4-х посылок UART.
 */
module receive8num (
    input iclk,
    input reset,
    input rx,
    output reg [3:0] real_num [7:0]  // 8 значений по 4 бита, т.е. 8 десятичных цифр
);
reg [7:0] current_byte; // байт данных из 1 посылки UART
wire ready_1byte; // выход из receiver: 1 если прочитал новый байт
reg [1:0] number_index=0;  // 0..3, номер посылки

// UART-приёмник принимает все посылки, надо успевать записывать в буффер
receiver rUart_1byte (
    .iclk(iclk),
    .reset(reset),
    .rx(rx),
    .data(current_byte),
    .ready(ready_1byte)
);

/*
нужно отловить, когда поднимается флаг ready_1byte, как будто posedge ready_1byte
т.е. prev_ready_1byte = 0, ready_1byte = 1
*/
reg prev_ready_1byte = 0; // состояние ready_1byte 1 такт назад
always @(posedge iclk) begin
    if (prev_ready_1byte == 0 && ready_1byte == 1) begin
        // младшие 4 бита => чётный индекс
        // старшие 4 бита => нечётный индекс
        real_num[number_index * 2 + 0] <= current_byte[3:0];
        real_num[number_index * 2 + 1] <= current_byte[7:4];
        if (number_index == 3) begin
            // принято все 4 посылки
            number_index <= 0;
        end else begin
            number_index <= number_index + 1;
        end
    end
    prev_ready_1byte <= ready_1byte;
end
endmodule
