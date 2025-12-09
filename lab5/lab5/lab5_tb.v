`timescale 1ns/100ps // 1 ns time unit, 100 ps resolution
/*
Оттестируем transmitter.
*/
module lab5_tb;
    reg clk=1;
	always #1 clk = !clk;
    // DUT inputs
	//reg transmit_reset = 0, transmit_trig = 0;
    reg receive_reset = 0, uart_receive = 1; // idle line
    // DUT outputs
	//wire uart_transmit;
    
    wire [7:0] data_to_receiver = 8'b0000_1101;
	event gen_result;

    top t0(
        .iclk(clk),
        .receive_reset(receive_reset),
        .uart_receive(uart_receive)
        //.transmit_reset(transmit_reset),
        //.transmit_trig(transmit_trig),
        //.uart_transmit(uart_transmit)
    );

    initial begin
		$dumpfile("wave.vcd");		// create a VCD waveform dump called "wave.vcd"
		$dumpvars(0, lab5_tb);		// dump variable changes in the testbench

    /*
    transmit_reset <= 1; #10
    transmit_reset <= 0; #10 
    #10 // чёто ждём покайфу
    transmit_trig <= 1; #10
    */
    receive_reset <= 1; #10
    receive_reset <= 0; #10 
    #10 // чёто ждём покайфу
    // передадим data_to_receiver
    uart_receive <= 1; #42 // idle, взяла кривое время, чтоб посмотреть как будет себя вести
    // ведёт себя как надо, то есть синхронизируется!!!
    // блин надо ж по тактам ну ладно
    // как я поняла, 1 такт нашего устойства= 20
    uart_receive <= 0; #20 // start
    uart_receive <= data_to_receiver[0]; #20
    uart_receive <= data_to_receiver[1]; #20
    uart_receive <= data_to_receiver[2]; #20
    uart_receive <= data_to_receiver[3]; #20
    uart_receive <= data_to_receiver[4]; #20
    uart_receive <= data_to_receiver[5]; #20
    uart_receive <= data_to_receiver[6]; #20
    uart_receive <= data_to_receiver[7]; #20
    uart_receive <= 1; #20 // stop bit
    // дальше idle
    #10
    #100
	
    #10 -> gen_result;

        $finish;
    end

    //initial begin
    //    $monitor("t<=%-4d: a<=%b, b<=%b, q<=%b, q_comp<=%b, state<=%b, state_comp<=%b", $time, a, b, q, q_compare, state, state_compare);
    //end

endmodule