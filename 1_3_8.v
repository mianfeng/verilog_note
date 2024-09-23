module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);
    wire cout1;
    wire [15:0] sum0, sum1;
    add16 add_low16 (.a(a[15:0]), 
                .b(b[15:0]), 
                .sum(sum[15:0]),
                .cin(1'b0),
                .cout(cout1));
    add16 add_high16_0 (.a(a[31:16]),
                            .b(b[31:16]),
                            .sum(sum0),
                            .cin(1'b0),
                            .cout());
    add16 add_high16_1 (.a(a[31:16]),
                            .b(b[31:16]),
                            .sum(sum1),
                            .cin(1'b1),
                            .cout());
    always @(*) begin
        case (cout1)
            1'b0: sum[31:16] = sum0;

            1'b1: sum[31:16] = sum1;
            default: sum[31:16] = 16'b0;
        endcase

    end
endmodule
