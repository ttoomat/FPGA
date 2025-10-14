module FSM_part3_top(
    input clk, reset,
    input data,
    output reg start_shifting
);
reg[3:0] prev = 4'b0000;
always @(posedge clk) begin
    if (start_shifting === 1'bx) start_shifting=0;
    if (!reset) begin
        prev[0] <= data;
        prev[1] <= prev[0];
        prev[2] <= prev[1];
        prev[3] <= prev[2];
        if (prev == 4'b1101) start_shifting <= 1;
    end else begin
        start_shifting <= 0;
        prev <= 4'b0000;
    end
end
endmodule