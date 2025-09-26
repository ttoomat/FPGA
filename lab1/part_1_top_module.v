module Dtrig_1bit (input clk, input d, output q) ;
// one trigger
reg q_reg;
always @(posedge clk) begin
    q_reg <= d;
end
assign q = q_reg;

endmodule

module part_1_top_module (input clk, input d, output q );
// 3 triggers, выход одного становится входом следующего!
wire q_0, q_1;
Dtrig_1bit trig0 (
    .d(d),
    .q(q_0),
    .clk(clk)
);

Dtrig_1bit trig1 (
    .d(q_0),
    .q(q_1),
    .clk(clk)
);

Dtrig_1bit trig2 (
    .d(q_1),
    .q(q),
    .clk(clk)
);

endmodule