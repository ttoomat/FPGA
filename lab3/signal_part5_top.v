module signal_part5_top(
    input a, clk,
    output reg [2:0]ind
);

always @(posedge clk) begin
    if (ind === 3'bx) ind = 3'b100;
    if (a) begin
        ind <= 4;
    end else begin
        if (ind < 6) ind <= ind + 1;
        else ind <= 0;
    end
end
endmodule