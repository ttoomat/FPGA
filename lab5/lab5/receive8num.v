module receive8num (
    input iclk,
    input reset,
    input rx,
    output reg [3:0] real_num [7:0]  // 8 значений по 4 бита
);

reg [7:0] current_byte;
wire ready_1byte;
reg [1:0] number_index=0;  // 0..3 (4 байта => 8 numbers)

// Один UART-приёмник
receiver rUart_1byte (
    .iclk(iclk),
    .reset(reset),
    .rx(rx),
    .data(current_byte),
    .ready(ready_1byte)
);

/*
нужно отловить, когда поднимается флаг ready_1byte
но не if (ready_1byte)
т.е. prev_ready_1byte = 0, ready_1byte = 1;
*/
reg prev_ready_1byte = 0; 
reg [3:0]CONDITION;
//wire CONDITION = (prev_ready_1byte == 0) && (ready_1byte == 1);    
always @(posedge iclk) begin
    if (prev_ready_1byte == 0 && ready_1byte == 1) begin
        // Каждый байт даёт два полубайта:
        // младшие 4 бита => чётный индекс
        // старшие 4 бита => нечётный индекс
        real_num[number_index * 2 + 0] <= current_byte[3:0];
        real_num[number_index * 2 + 1] <= current_byte[7:4];
        CONDITION = real_num[0];
        if (number_index == 3) begin
            // Принято 4 байта = 8 чисел
            number_index <= 0;
        end else begin
            number_index <= number_index + 1;
        end
    end
    prev_ready_1byte <= ready_1byte;
end
endmodule