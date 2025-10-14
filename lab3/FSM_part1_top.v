module FSM_part1_top(
    input wire clk,
    input wire reset,
    output reg[12:0] out
);
always @(posedge clk) begin
    if (reset) begin
        out = 12'd0;
    end else begin
        if (out < 12'd999) begin
            out = out + 12'd1;
        end else begin
            out = 12'd0;
        end
    end
end
endmodule