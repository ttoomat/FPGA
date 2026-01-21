/* Делитель частоты для receiver.
 * Для тестировки 1875 заменено на 5.
 * 27_000_000 / 1875 = 14_400
 */
module prescaler_rx(
    input iclk,
    input enable,
    output reg oclk
);
initial begin
    oclk = 0;
end
reg[24:0] cnt=0;
always @(posedge iclk) begin
    if (enable) begin
        // Baudrate = 14_400
        // временно поменяли 1875 на 5
        if (cnt < 5-1) begin
            cnt <= cnt + 1;
        end
        else begin
            cnt <= 0;
            oclk <= !oclk;
        end
    end // if enable
    else begin
        oclk = 0;
    end
end
endmodule
/*
В receiver ждём, пока не придёт падающий фронт линии, idle -> start bit и тогда запускать
тактовую частоту. Так как знаем baudrate, то переходы по состояниям делаем по тактам. 
start_bit - отлавливаем его. Линия падает на 0.
data_sending - через 1 такт после start_bit.
stop_bit - через 1 такт после последнего из 0-7 битов data_sending. Надо бы проверить, точно ли его послали, но пока не делаем. Это 1.
idle - можно проверять на idle после stop_bit.

Некая особенность: при подряд идущих посылках всегда необходим idle state
  хотя бы 1 бит между stop bit и start bit новой посылки.
  также неизвестно, реально ли синхронизируются часы по падающей линии после idle.
*/
module receiver (
    input iclk,  // 27 MHz. Делитель вызывается внутри receiver.
    input reset,
    input rx,    // последовательные данные
    output reg [7:0]data, // выход -- шина данных (параллельно)
    output reg ready // RXNE, после каждого прочитанного байта поднимается в 1.
    // можно добавить отлов ошибки
);
reg [3:0]data_ind; // номер бита данных от 0 до 7 + 1
parameter idle=0, start_bit=1, data_sending=2, stop_bit=3; 
reg[1:0] present_state, next_state;
// 27 MHz - iclk frequency
// 14_400 - Baudrate
reg clk_rx;
reg clk_enable=0;
initial begin
    data_ind = 0;
    present_state = idle;
    next_state = idle;
    ready = 0;
end
prescaler_rx p_rx (
    .iclk(iclk),
    .enable(clk_enable),
    .oclk(clk_rx)
);
// отлавливаем падение фронта после idle
always @(negedge rx) begin
    // при падении rx переход на start_bit ТОЛЬКО если прошлое состояние - idle
    case (present_state)
    idle: begin
        next_state = start_bit;
        // и надо здесь запустить часы, они будут согласованы как надо
        clk_enable = 1;
        //ready=0;
    end
    endcase
end

// receiver читает данные с линии по posedge clk
always @(posedge clk_rx) begin
    // остальные переходы кроме idle -> start_bit происхоят по тактам
    case (present_state)
    start_bit: begin
        next_state = data_sending;
    end
    data_sending: begin
        // если data_ind=7, то вся передача состоялась
        if (data_ind > 7) begin
            next_state = stop_bit;
        end else begin
            next_state = data_sending;
        end
    end
    stop_bit: begin
    // todo: check stop_bit and handle if data[stop_bit] != 1
        next_state = idle;
    end
    endcase // переходы между состояниями
    present_state = next_state;

    // обработка состояния
    case (present_state)
        idle: begin
            clk_enable = 0; // снова ждём negedge, чтоб запустить часы
        end
        start_bit: begin
            data_ind <= 0;
            ready = 0;
        end
        data_sending: begin
            if (data_ind <= 7) begin
                data[data_ind] <= rx;
                data_ind <= data_ind + 1;
            end
        end
        stop_bit: begin
            ready = 1;
        end
    endcase // обработка состояния
end // always posedge clk_rx
endmodule
