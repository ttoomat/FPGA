module transmitter(
    input clk,
    input [7:0] data,
    input reset,
    //input tcr, // transmission complete reset
    input trig, // по импульсу trig будем посылать 1 байт
    output reg tx // данные последовательно
    //output reg tc // 1 байт отправлен = transmission complete
);
reg [2:0]data_ind; // номер бита данных от 0 до 7
parameter idle=0, start_bit=1, data_sending=2, stop_bit=3; 
reg[1:0] present_state, next_state;
reg tc;
initial begin
    present_state = idle;
    next_state = idle;
    tx = 1;
    data_ind = 0;
    tc = 0;
end

always @(negedge clk) begin
    // Reset logic
    if (reset) begin
        present_state <= idle;
        next_state <= idle;
        tc <= 0;
    end
    else begin
    // обработка состояний FSM
    //if (tc == 0) begin
    case (present_state)
    idle: begin
        tx <= 1;
        data_ind <= 0;
        if (trig) begin
            next_state <= start_bit;
        end else begin
            next_state <= idle;
        end
    end
    start_bit: begin
        tx <= 0;
        data_ind <= 0;
        next_state <= data_sending;
    end
    data_sending: begin
        // если data_ind=7, то вся передача состоялась
        if (data_ind >= 7) begin
            next_state <= stop_bit;
            //data_ind <= 0;
        end else begin
            // аналог сдвигового регистра
            // послали один бит
            tx <= data[data_ind];
            // увеличили счетчик, чтоб потом уже следующий бит посылать
            data_ind <= data_ind + 1;
            next_state <= data_sending;
        end
    end
    stop_bit: begin
        tx <= 1;
        next_state <= idle;
        tc <= 1;
    end
    endcase
    present_state <= next_state;
    end
//end
end
endmodule
