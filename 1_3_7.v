module top_module (
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);//
    wire [15:0] c;
    addhalf16 add32_1 (.a(a[15:0]), 
                .b(b[15:0]), 
                .sum(sum[15:0]),
                .cin(1'b0),
                .cout(c[15]));
    addhalf16 add32_2 (.a(a[31:16]),
                .b(b[31:16]),
                .sum(sum[31:16]),
                .cin(c[15]),
                .cout());
endmodule
 
module addhalf16 ( input [15:0] a, input [15:0] b, input cin, output [15:0] sum, output cout );
    wire [15:0] c;
    add1 add1_1 (.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(c[0]));
    add1 add2 (.a(a[1]), .b(b[1]), .cin(c[0]), .sum(sum[1]), .cout(c[1]));
    add1 add3 (.a(a[2]), .b(b[2]), .cin(c[1]), .sum(sum[2]), .cout(c[2]));
    add1 add4 (.a(a[3]), .b(b[3]), .cin(c[2]), .sum(sum[3]), .cout(c[3]));
    add1 add5 (.a(a[4]), .b(b[4]), .cin(c[3]), .sum(sum[4]), .cout(c[4]));
    add1 add6 (.a(a[5]), .b(b[5]), .cin(c[4]), .sum(sum[5]), .cout(c[5]));
    add1 add7 (.a(a[6]), .b(b[6]), .cin(c[5]), .sum(sum[6]), .cout(c[6]));
    add1 add8 (.a(a[7]), .b(b[7]), .cin(c[6]), .sum(sum[7]), .cout(c[7]));
    add1 add9 (.a(a[8]), .b(b[8]), .cin(c[7]), .sum(sum[8]), .cout(c[8]));
    add1 add10 (.a(a[9]), .b(b[9]), .cin(c[8]), .sum(sum[9]), .cout(c[9]));
    add1 add11 (.a(a[10]), .b(b[10]), .cin(c[9]), .sum(sum[10]), .cout(c[10]));
    add1 add12 (.a(a[11]), .b(b[11]), .cin(c[10]), .sum(sum[11]), .cout(c[11]));
    add1 add13 (.a(a[12]), .b(b[12]), .cin(c[11]), .sum(sum[12]), .cout(c[12]));
    add1 add14 (.a(a[13]), .b(b[13]), .cin(c[12]), .sum(sum[13]), .cout(c[13]));
    add1 add15 (.a(a[14]), .b(b[14]), .cin(c[13]), .sum(sum[14]), .cout(c[14]));
    add1 add16_1 (.a(a[15]), .b(b[15]), .cin(c[14]), .sum(sum[15]), .cout(c[15]));
endmodule

module add1 ( input a, input b, input cin,   output sum, output cout );
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
    // Full adder module here

endmodule
