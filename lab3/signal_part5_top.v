module signal_part5_top(
    input a, clk,
    output [2:0]q
);

wire [2:0]ind;
wire [2:0] nums[7:0];

assign nums[0] = 3'b000;
assign nums[1] = 3'b001;
assign nums[2] = 3'b010;
assign nums[3] = 3'b011;
assign nums[4] = 3'b100;
assign nums[5] = 3'b101;
assign nums[6] = 3'b110;

//assign ind = 3'b100;

assign ind = a == 1 ? 4 : (ind < 6 ? ind + 1 : 0);
assign q = nums[ind];
endmodule