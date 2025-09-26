module full_add ( 
    input a, b, cin,
    output sum, cout );

reg sum_reg, cout_reg;

always @* begin
if (a^b) begin
    cout_reg = cin;
    sum_reg = ~cin;
end else begin
    sum_reg = cin;
    cout_reg = (a & b);
end
end
assign sum = sum_reg;
assign cout = cout_reg;

endmodule