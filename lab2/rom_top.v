module rom_top(
    input reg[1:0] adr,
	output reg[3:0] dout
);
always @(*) begin
case (adr)
0: dout = 4'b1001;
1: dout = 4'b0011;
2: dout = 4'b1110;
3: dout = 4'b1010;
endcase
end
endmodule
