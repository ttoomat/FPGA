// делитель частоты
// 27_000_000 / 1875 = 14_400
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
        // если не enable - время на нуле
        // или оно должно просто остановиться?
        // хотя мы ж хотим начинать с нулевого значения всегда
        oclk = 0;
    end
end
endmodule
/*
В receiver по идее надо ждать, пока не придёт падающий фронт линии
и тогда запускать тактовую частоту. Так как мы знаем baudrate, то переходы по состояниям 
можно делать и по тактам. 
stop_bit - отлавливаем его. Это логич 0.
data_sending - через 1 такт после start_bit
stop_bit - через 1 такт после 0-7 битов data_sending. Надо бы проверить, точно ли его послали. Это логич 1.
idle - можно проверять на idle после stop_bit.  
*/
module receiver (
    input iclk,  // её будем делить уже как захочем
    input reset,
    input rx,    // 1 bit data
    output reg [7:0]data
    // можно добавить отлов ошибки и rx not empty flag
);
reg [3:0]data_ind; // номер бита данных от 0 до 7 + 1
parameter idle=0, start_bit=1, data_sending=2, stop_bit=3; 
reg[1:0] present_state, next_state;
// 27 MHz - iclk frequency
// 14_400 - Baudrate
reg clk_rx;
//reg [24:0] cnt_clk=0; // внутри always не можем вызвать модуль прескейлера, так что напишем его внутри
reg clk_enable=0;
initial begin
    data_ind = 0;
    present_state = idle;
    next_state = idle;
    // но есть шанс подключиться уже во время передачи...
    //rxne = 0;
end
prescaler_rx p_rx (
    .iclk(iclk),
    .enable(clk_enable),
    .oclk(clk_rx)
);
// отлавливаем падение фронта после idle
// но ведь оно будет срабатывать каждый раз, когда падает rx...
always @(negedge rx) begin
    // при падении rx переход на start_bit ТОЛЬКО если прошлое состояние - idle
    case (present_state)
    idle: begin
        next_state = start_bit;
        // и надо здесь запустить часы
        // непонятно, точно ли тактовые частоты будут согласованы
        clk_enable = 1;
    end
    endcase
end

// читаем по возр фронту clk
always @(posedge clk_rx) begin
    // остальные переходы кроме idle-> start_bit происхоят по тактам
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
            clk_enable = 0; // снова ждём пад фр
        end
        start_bit: begin
            data_ind <= 0;
        end
        data_sending: begin
            if (data_ind <= 7) begin
                data[data_ind] <= rx;
                data_ind <= data_ind + 1;
            end
        end
    endcase // обработка состояния
    
end // always posedge clk_rx

/*
always @(posedge clk) begin
if (reset) begin
    present_state = idle;
end else begin
    // обработка текущего состояния
    // вроде ничего не надо обрабатывать, кроме data_sending
    case (present_state)
    idle: begin
    end
    start_bit: begin
        //next_state <= data_sending;
    end
    data_sending: begin
        // если data_ind=7, то вся передача состоялась
        if (data_ind < 7) begin
            // аналог сдвигового регистра
            // послали один бит
            data[data_ind] <= rx;
            // увеличили счетчик, чтоб потом уже следующий бит посылать
            data_ind <= data_ind + 1;
        end
    end
    stop_bit: begin
        rxne = 1;
    end
    endcase

    // переход к новому состоянию
    // вроде ничего не надо обрабатывать, кроме data_sending
    // на stop_bit переходим по тактам
    case (present_state)
    idle: begin
    end
    // start_bit приходит по линии
    start_bit: begin
        next_state <= data_sending;
    end
    data_sending: begin
        // если data_ind=7, то вся передача состоялась
        if (data_ind >= 7) begin
            next_state <= stop_bit;
        end else begin
            next_state <= data_sending;
        end
    end
    stop_bit: begin
        rxne = 1;
    end
    endcase
end // if-else
end // always
*/
endmodule