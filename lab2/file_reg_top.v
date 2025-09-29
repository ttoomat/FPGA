module file_reg_top (       
    input reg clk=1,
    input reg we,
    input reg [4:0] waddr,
    input reg [31:0] wdata,
    input reg [4:0] raddr1,
    input reg [4:0] raddr2,

    output wire [31:0] rdata1,
    output wire [31:0] rdata2
);

reg [31:0] registers [2**5-1:0];

// read raddr1
assign rdata1 = raddr1 == 0 ? 0 : registers[raddr1];
// read raddr2
assign rdata2 = raddr2 == 0 ? 0 : registers[raddr2];
// write wdata
always @(posedge clk) begin
    // если разрешена запись, write
    if (we) begin 
        registers[waddr] <= wdata;
    end
end
endmodule
