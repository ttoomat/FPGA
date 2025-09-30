module signal_part3_top(
    input [3:0] A, B, C, D, E,
    output reg [3:0]Q
);
always @(*) begin
    case(C)
    4'h0: Q = B;
    4'h1: Q = E;
    4'h2: Q = A;
    4'h3: Q = D;
    default: Q = 4'hf;
    endcase
end
endmodule