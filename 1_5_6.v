module top_module( 
    input [99:0] a, b,
    input cin,
    output [99:0] cout,
    output [99:0] sum );
    genvar i;
    generate
        for(i=0;i<100;i=i+1) begin :flipflop_loop // 生成100个full_adder模块
            if(i==0) begin
                full_adder adder(.a(a[i]), .b(b[i]), .cin(cin), .sum(sum[i]), .cout(cout[i]));
            end
            else begin
                full_adder adder(.a(a[i]), .b(b[i]), .cin(cout[i-1]), .sum(sum[i]), .cout(cout[i]));
            end
        end


    endgenerate

endmodule

module full_adder (
    input wire a,       // 加数1
    input wire b,       // 加数2
    input wire cin,     // 输入进位
    output wire sum,    // 输出和
    output wire cout    // 输出进位
);
    assign sum = a ^ b ^ cin;  // 和 = a ⊕ b ⊕ cin
    assign cout = (a & b) | (b & cin) | (a & cin);  // 进位 = (a AND b) OR (b AND cin) OR (a AND cin)
endmodule