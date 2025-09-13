module full_add ( 
    input a, b, cin,
    output sum, cout );

    // write code here
//assign sum = (a ^ b) ^ (cin);
//assign cout = (a & b) | ((a^b) & cin);

reg sum_reg, cout_reg;

always @* begin
if (a^b) begin
    if (~cin) begin
        sum_reg = 1;
        cout_reg = 0;
    end else begin
        sum_reg = 0;
        cout_reg = 1;
    end
end else if (a & b) begin
    cout_reg = 1;
    sum_reg = cin;
end else begin
    sum_reg = cin;
    cout_reg = 0;
end
end
assign sum = sum_reg;
assign cout = cout_reg;


endmodule