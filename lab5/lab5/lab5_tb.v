`timescale 1ns/100ps // 1 ns time unit, 100 ps resolution
/* Весь этот модуль - testbench, исключительно для симуляции.
 * Оттестируем receiver -> transmitter.
 */
module lab5_tb;
    reg clk=1;
	always #1 clk = !clk;
    // DUT inputs
	reg transmit_reset = 0, transmit_trig = 0;
    reg receive_reset = 0, uart_receive = 1; // idle line
    // DUT outputs
    wire uart_transmit;
    wire [3:0] real_num [7:0]; // this we will use in display module
    // 8 numbers: 1 2 3 4 5 6 7 8
    wire [7:0] data_to_receiver1 = 8'b0001_0010;
    wire [7:0] data_to_receiver2 = 8'b0011_0100;
    wire [7:0] data_to_receiver3 = 8'b0101_0110;
    wire [7:0] data_to_receiver4 = 8'b0111_1000;
	event gen_result;

    top t0(
        .iclk(clk),
        .receive_reset(receive_reset),
        .uart_receive(uart_receive),
        .transmit_reset(transmit_reset),
        .transmit_trig(transmit_trig),
        .uart_transmit(uart_transmit),
        .real_num(real_num)
    );
    // костыль, т.к. GTK-wave не отображает real_num почему-то
    wire [3:0] rn0 = real_num[0];
    wire [3:0] rn1 = real_num[1];
    wire [3:0] rn2 = real_num[2];
    wire [3:0] rn3 = real_num[3];
    wire [3:0] rn4 = real_num[4];
    wire [3:0] rn5 = real_num[5];
    wire [3:0] rn6 = real_num[6];
    wire [3:0] rn7 = real_num[7];

    initial begin
		$dumpfile("wave.vcd");		// create a VCD waveform dump called "wave.vcd"
		$dumpvars(0, lab5_tb);      // dump variable changes in the testbench

    receive_reset <= 1; #10
    receive_reset <= 0; #10 
    #10 // чёто ждём покайфу
    // передадим data_to_receiver
    uart_receive <= 1; #40
    // 1 такт нашего нынешнего устойства = 20
    // 8 bits = 2 decimal numbers
    // так что делаем 4 посылки по UART
    uart_receive <= 0; #20 // start
    uart_receive <= data_to_receiver1[0]; #20
    uart_receive <= data_to_receiver1[1]; #20
    uart_receive <= data_to_receiver1[2]; #20
    uart_receive <= data_to_receiver1[3]; #20
    uart_receive <= data_to_receiver1[4]; #20
    uart_receive <= data_to_receiver1[5]; #20
    uart_receive <= data_to_receiver1[6]; #20
    uart_receive <= data_to_receiver1[7]; #20
    uart_receive <= 1; #20 // stop bit
    uart_receive <= 1; #20 // idle
    uart_receive <= 0; #20 // start
    uart_receive <= data_to_receiver2[0]; #20
    uart_receive <= data_to_receiver2[1]; #20
    uart_receive <= data_to_receiver2[2]; #20
    uart_receive <= data_to_receiver2[3]; #20
    uart_receive <= data_to_receiver2[4]; #20
    uart_receive <= data_to_receiver2[5]; #20
    uart_receive <= data_to_receiver2[6]; #20
    uart_receive <= data_to_receiver2[7]; #20
    uart_receive <= 1; #20 // stop bit
    uart_receive <= 1; #20 // idle
    uart_receive <= 0; #20 // start
    uart_receive <= data_to_receiver3[0]; #20
    uart_receive <= data_to_receiver3[1]; #20
    uart_receive <= data_to_receiver3[2]; #20
    uart_receive <= data_to_receiver3[3]; #20
    uart_receive <= data_to_receiver3[4]; #20
    uart_receive <= data_to_receiver3[5]; #20
    uart_receive <= data_to_receiver3[6]; #20
    uart_receive <= data_to_receiver3[7]; #20
    uart_receive <= 1; #20 // stop bit
    uart_receive <= 1; #20 // idle
    uart_receive <= 0; #20 // start
    uart_receive <= data_to_receiver4[0]; #20
    uart_receive <= data_to_receiver4[1]; #20
    uart_receive <= data_to_receiver4[2]; #20
    uart_receive <= data_to_receiver4[3]; #20
    uart_receive <= data_to_receiver4[4]; #20
    uart_receive <= data_to_receiver4[5]; #20
    uart_receive <= data_to_receiver4[6]; #20
    uart_receive <= data_to_receiver4[7]; #20
    uart_receive <= 1; #20 // stop bit
    // дальше idle
    #10
    // начинаем отправлять то, что приняли
    // сейчас не реализовано отправление обратно
    transmit_reset <= 1; #10
    transmit_reset <= 0; #10 
    #10 // чёто ждём по кайфу
    transmit_trig <= 1; #10

    #1000
	
    #10 -> gen_result;

        $finish;
    end
// выводим то, что считали по UART
always @(posedge clk) begin
    if (real_num[0] !== 4'bx) begin
        $display("real_num = %h %h %h %h %h %h %h %h",
            real_num[7], real_num[6], real_num[5], real_num[4],
            real_num[3], real_num[2], real_num[1], real_num[0]);
    end
end
endmodule
