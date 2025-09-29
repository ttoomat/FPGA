module sync_top(
    input reg clk,
    input reg signal,
    output reg signal_sync = 0
);
reg tmp;
always @(posedge clk) begin
    tmp <= signal;
    signal_sync <= tmp;
end
endmodule
