module top_module( 
    input [399:0] a, b,
    input cin,
    output cout,
    output [399:0] sum );
    genvar i;
    wire [99:0] cout_temp;
    generate
        for(i=0;i<400;i=i+4) begin :bcd_loop // 生成100个full_adder模块
            if(i==0) begin
                bcd_fadd adder(.a(a[i+3:i]), .b(b[i+3:i]), .cin(cin), .sum(sum[i+3:i]), .cout(cout_temp[i/4]));
            end
            else begin
                bcd_fadd adder(.a(a[i+3:i]), .b(b[i+3:i]), .cin(cout_temp[i/4-1]), .sum(sum[i+3:i]), .cout(cout_temp[i/4]));
            end
        end
    endgenerate
    assign cout = cout_temp[99];

endmodule
