/* Модуль взаимодействия кнопок с числом.
 * Пока не тестирован и к тому же написан говнокодом.
 * Начиаем действовать только если все числа считаны из UART (ready_8num)
 */
module buttons (
    input i_iclk,
    input i_SW_pos, // сигнал прибвляющей кнопки
    input i_SW_neg,
    input [3:0] i_received_number [7:0], // полученное по UART число
    input i_ready_8num,
    output reg[3:0] o_changed_number [7:0] // число после работы кнопок
);
reg prev_ready_8num = 0;

/* Отслеживаем именно изменение фронта кнопки. И изменение фронта i_ready_8num.
 */
reg prev_SW_pos = 0;
reg prev_SW_neg = 0;
always @(posedge i_iclk) begin
    // скопируем массив при изменении ready_8num
    if (prev_ready_8num == 0 && i_ready_8num == 1) begin
        for (integer i = 0; i < 8; i = i + 1) begin
            o_changed_number[i] <= i_received_number[i];
        end
    end
    if (prev_SW_pos == 0 && i_SW_pos == 1) begin
        // позорное сложение с единицей
        // если минимальный разряд больше 9 -- предыдущему разряду даём 1, а у этого разряда остаётся 0.
        if (o_changed_number[7] < 9) begin
            o_changed_number[7] = o_changed_number[7] + 1;
        end else begin
            o_changed_number[7] = 0;
            if (o_changed_number[6] < 9) begin
                o_changed_number[6] = o_changed_number[6] + 1;
            end else begin
                o_changed_number[6] = 0;
                if (o_changed_number[5] < 9) begin
                    o_changed_number[5] = o_changed_number[5] + 1;
                end else begin
                    o_changed_number[5] = 0;
                    if (o_changed_number[4] < 9) begin
                        o_changed_number[4] = o_changed_number[4] + 1;
                    end else begin
                        o_changed_number[4] = 0;
                        if (o_changed_number[3] < 9) begin
                            o_changed_number[3] = o_changed_number[3] + 1;
                        end else begin
                            o_changed_number[3] = 0;
                            if (o_changed_number[2] < 9) begin
                                o_changed_number[2] = o_changed_number[2] + 1;
                            end else begin
                                o_changed_number[2] = 0;
                                if (o_changed_number[1] < 9) begin
                                    o_changed_number[1] = o_changed_number[1] + 1;
                                end else begin
                                    o_changed_number[1] = 0;
                                    if (o_changed_number[0] < 9) begin
                                        o_changed_number[0] = o_changed_number[0] + 1;
                                    end else begin
                                        o_changed_number[0] = 0;
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end 
    if (prev_SW_neg == 0 && i_SW_neg == 1) begin
        // позорное вычитание единицы из числа
        // если минимальный разряд меньше единицы, занимаем у предыдущего, а у этого разряда остаётся 9.
        if (o_changed_number[7] > 0) begin
            o_changed_number[7] <= o_changed_number[7] - 1;
        end else begin
            o_changed_number[7] = 9;
            if (o_changed_number[6] > 0) begin
                o_changed_number[6] <= o_changed_number[6] - 1;
            end else begin
                o_changed_number[6] = 9;
                if (o_changed_number[5] > 0) begin
                    o_changed_number[5] <= o_changed_number[5] - 1;
                end else begin
                    o_changed_number[5] = 9;
                    if (o_changed_number[4] > 0) begin
                        o_changed_number[4] <= o_changed_number[4] - 1;
                    end else begin
                        o_changed_number[4] = 9;
                        if (o_changed_number[3] > 0) begin
                            o_changed_number[3] <= o_changed_number[3] - 1;
                        end else begin
                            o_changed_number[3] = 9;
                            if (o_changed_number[2] > 0) begin
                                o_changed_number[2] <= o_changed_number[2] - 1;
                            end else begin
                                o_changed_number[2] = 9;
                                if (o_changed_number[1] > 0) begin
                                    o_changed_number[1] <= o_changed_number[1] - 1;
                                end else begin
                                    o_changed_number[1] = 9;
                                    if (o_changed_number[0] > 0) begin
                                        o_changed_number[0] <= o_changed_number[0] - 1;
                                    end else begin
                                        o_changed_number[0] <= 9;
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    prev_SW_pos <= i_SW_pos;
    prev_SW_neg <= i_SW_neg;
    prev_ready_8num <= i_ready_8num;
end
endmodule
