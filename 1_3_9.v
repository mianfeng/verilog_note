module top_module(
    input [31:0] a,
    input [31:0] b,
    input sub,
    output [31:0] sum
);
    wire [31:0] b_xor;
    wire coutL2H;
    assign b_xor = {32{sub}}^b;
    add16 adder_low(
        .a(a[15:0]),
        .b(b_xor[15:0]),
        .sum(sum[15:0]),
        .cin(sub),
        .cout(coutL2H)
    );
    add16 adder_high(
        .a(a[31:16]),
        .b(b_xor[31:16]),
        .sum(sum[31:16]),
        .cin(coutL2H),
        .cout()
    );
endmodule
