module transmitter(
    input clk,
    input [7:0] data,
    input reset,
    input trig, // по импульсу trig будем посылать 1 байт
    output reg tx, // данные последовательно
    output reg tc // 1 байт отправлен = transmission complete
);
reg [3:0]data_ind; // номер бита данных от 0 до 7 + 1
parameter idle=0, start_bit=1, data_sending=2, stop_bit=3; 
reg[1:0] present_state, next_state;
initial begin
    present_state = idle;
    next_state = idle;
    tx = 1;
    data_ind = 0;
    tc = 0;
end
// формируем сигнал на падающем фронте
always @(negedge clk) begin
    // Reset logic
    if (reset) begin
        present_state = idle;
        next_state = idle;
        tc = 0;
    end
    else begin
    // переход из текущих состояний FSM
    case (present_state)
    idle: begin
        if (trig) begin
            next_state = start_bit;
        end else begin
            next_state = idle;
        end
    end
    start_bit: next_state = data_sending;
    data_sending: begin
        // если data_ind=7, то вся передача состоялась
        if (data_ind > 7) begin
            next_state = stop_bit;
        end else begin
            next_state = data_sending;
        end
    end
    stop_bit: next_state = idle;
    endcase
    present_state = next_state;

    // обработка текущих состояний FSM
    case (present_state)
    idle: begin
        tx <= 1;
        data_ind <= 0;
    end
    start_bit: begin
        tx <= 0;
        data_ind <= 0;
    end
    data_sending: begin
        // если data_ind=7, то вся передача состоялась
        if (data_ind <= 7) begin
            // аналог сдвигового регистра
            // послали один бит
            tx = data[data_ind];
            // увеличили счетчик, чтоб потом уже следующий бит посылать
            data_ind = data_ind + 1;
        end
    end
    stop_bit: begin
        tx <= 1;
        tc <= 1;
    end
    endcase
    
    end
end
endmodule
