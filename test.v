module top_module ( 
    input [15:0] a, b,
    input cin,
    output cout,
    output [15:0] sum );
    wire [3:0] carry;
    genvar i;
    generate
        for (i = 0;i<4 ;i=i+1 ) begin :bcd_chain
            if(i == 0)
                bcd_fadd bcd_fa1(   .a(a[3:0]),
                                    .b(b[3:0]),
                                    .cin(cin),
                                    .cout(carry[0]),
                                    .sum(sum[3:0]));
            else
                bcd_fadd bcd_fa(   .a(a[i*3 +:3]),
                                    .b(b[i*3 +:3]),
                                    .cin(carry[i-1]),
                                    .cout(carry[i]),
                                    .sum(sum[i*3 +:3]));


            
        end
    endgenerate
    assign cout = carry[3];
    

endmodule
