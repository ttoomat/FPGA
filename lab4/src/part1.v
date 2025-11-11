// с помощью LUT3 реализуем комбинаторную логику
module part1(
    input A, B, C,
    output LED1, LED2, LED3, LED4, LED5, LED6, LED7, LED8
);

// 1: A ^ B | C
LUT3 #(.INIT(8'b0111_1101)) lut1 (.I0(A), .I1(B), .I2(C), .F(LED1)); // F - выход, INIT - таблица истинности
// 2: A ^ C
LUT3 #(.INIT(8'b0101_1010)) lut2 (.I0(A), .I1(B), .I2(C), .F(LED2));
// 3: B | (A ^ B | C)
LUT3 #(.INIT(8'b0111_1111)) lut3 (.I0(A), .I1(B), .I2(C), .F(LED3));
// 4: (A ^ B | C) & (A ^ C) & (B | (A ^ B | C))
LUT3 #(.INIT(8'b0101_1000)) lut4 (.I0(A), .I1(B), .I2(C), .F(LED4));
// 5: A | B | C - кстати, такое же, как 3 получилось
LUT3 #(.INIT(8'b0111_1111)) lut5 (.I0(A), .I1(B), .I2(C), .F(LED5));
// 6: ~(A ^ B | C)
LUT3 #(.INIT(8'b1000_0010)) lut6 (.I0(A), .I1(B), .I2(C), .F(LED6));
// 7: A & B & C
LUT3 #(.INIT(8'b0000_0001)) lut7 (.I0(A), .I1(B), .I2(C), .F(LED7));
// 8: C
LUT3 #(.INIT(8'b0101_0101)) lut8 (.I0(A), .I1(B), .I2(C), .F(LED8));

endmodule
