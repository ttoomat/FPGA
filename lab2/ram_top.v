module ram_top(
    clk, we, adr, din, dout
);
// N - размер адреса, M - размер ячейки
parameter N=4, M=32;
input clk;
input reg [N-1:0] adr;
// data input
input reg [M-1:0] din;
// write enable
input we;
output reg [M-1:0] dout;

// N бит занимает адрес => адреса от 0 до 2^N-1, на каждый есть ячейка-вектор M бит 
reg [M-1:0] registers [2**N-1:0];
// асинхронное чтение
assign dout = adr == 0 ? 0 : registers[adr];
always @(posedge clk) begin
    // если разрешена запись, write
    if (we) begin 
        registers[adr] <= din;
    end
end

endmodule
