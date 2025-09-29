module alu_top (
    input reg [31:0] a_i,
    input reg [31:0] b_i,
    input reg [4:0] op_i,

    output reg [31:0] result_o=0,
    output reg flag_o=0
);

always @(*) begin
    case (op_i)
    //add
    5'b00_000: result_o = a_i + b_i;
    // sub
    5'b01_000: result_o = a_i - b_i;
    //sll
    5'b00_001: result_o = a_i << b_i;
    //slts:
    5'b00_010: result_o = $signed(a_i) > $signed(b_i);
    //sltu:
    5'b00_011: result_o = a_i > b_i;
    //xor:
    5'b00_100: result_o = a_i ^ b_i;
    //srl:
    5'b00_101: result_o = a_i >> b_i;
    //sra:
    5'b01_101: result_o = $signed(a_i) >>> b_i;
    //or:
    5'b00_110: result_o = a_i | b_i;
    //and:
    5'b00_111: result_o = a_i & b_i;
    //eq:
    5'b11_000: flag_o = a_i == b_i;
    //ne:
    5'b11_001: flag_o = a_i != b_i;
    //lts:
    5'b11_100: flag_o = $signed(a_i) < $signed(b_i);
    //ges:
    5'b11_101: flag_o = $signed(a_i) >= $signed(b_i);
    //ltu:
    5'b11_110: flag_o = $unsigned(a_i) < $unsigned(b_i);
    //geu:
    5'b11_111: flag_o = $unsigned(a_i) >= $unsigned(b_i);
    endcase
end

endmodule
