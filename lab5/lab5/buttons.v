/* Модуль взаимодействия кнопок с числом.
 * Пока не тестирован и к тому же написан говнокодом.
 */
module buttons (
    input i_iclk,
    input i_SW_pos, // сигнал прибавляющей кнопки
    input i_SW_neg,
    input [3:0] i_received_number [7:0], // полученное по UART число
    output [3:0] o_changed_number [7:0] // число после работы кнопок
);
/* Нужно опять отслеживать именно изменение фронта кнопки.
 * также нужно реализовать сложение и вычитание массива с 1...
 */
reg prev_SW_pos = 0;
reg prev_SW_neg = 0;
always @(posedge i_iclk) begin
    if (prev_SW_pos == 0 && i_SW_pos == 1) begin
        // позорное сложение с единицей
        o_changed_number = i_received_number + 1;
        // если минимальный разряд больше 9 -- предыдущему разряду даём 1, а у этого разряда остаётся 0.
        if (i_received_number[7] < 9) begin
            o_changed_number[7] = i_received_number[7] + 1;
        end else begin
            o_changed_number[7] = 0;
            if (i_received_number[6] < 9) begin
                o_changed_number[6] = i_received_number[6] + 1;
            end else begin
                o_changed_number[6] = 0;
                if (i_received_number[5] < 9) begin
                    o_changed_number[5] = i_received_number[5] + 1;
                end else begin
                    o_changed_number[5] = 0;
                    if (i_received_number[4] < 9) begin
                        o_changed_number[4] = i_received_number[4] + 1;
                    end else begin
                        o_changed_number[4] = 0;
                        if (i_received_number[3] < 9) begin
                            o_changed_number[3] = i_received_number[3] + 1;
                        end else begin
                            o_changed_number[3] = 0;
                            if (i_received_number[2] < 9) begin
                                o_changed_number[2] = i_received_number[2] + 1;
                            end else begin
                                o_changed_number[2] = 0;
                                if (i_received_number[1] < 9) begin
                                    o_changed_number[1] = i_received_number[1] + 1;
                                end else begin
                                    o_changed_number[1] = 0;
                                    if (i_received_number[0] < 9) begin
                                        o_changed_number[0] = i_received_number[0] + 1;
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
        if (i_received_number[7] > 0) begin
            o_changed_number[7] = i_received_number[7] - 1;
        end else begin
            o_changed_number[7] = 9;
            if (i_received_number[6] > 0) begin
                o_changed_number[6] = i_received_number[6] - 1;
            end else begin
                o_changed_number[6] = 9;
                if (i_received_number[5] > 0) begin
                    o_changed_number[5] = i_received_number[5] - 1;
                end else begin
                    o_changed_number[5] = 9;
                    if (i_received_number[4] > 0) begin
                        o_changed_number[4] = i_received_number[4] - 1;
                    end else begin
                        o_changed_number[4] = 9;
                        if (i_received_number[3] > 0) begin
                            o_changed_number[3] = i_received_number[3] - 1;
                        end else begin
                            o_changed_number[3] = 9;
                            if (i_received_number[2] > 0) begin
                                o_changed_number[2] = i_received_number[2] - 1;
                            end else begin
                                o_changed_number[2] = 9;
                                if (i_received_number[1] > 0) begin
                                    o_changed_number[1] = i_received_number[1] - 1;
                                end else begin
                                    o_changed_number[1] = 9;
                                    if (i_received_number[0] > 0) begin
                                        o_changed_number[0] = i_received_number[0] - 1;
                                    end else begin
                                        o_changed_number[0] = 9;
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
endmodule
