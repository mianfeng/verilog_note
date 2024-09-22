module top_module (
    input [7:0] a, b, c, d,
    output [7:0] min);//
    wire [7:0] temp;
    always @(*) begin
        temp = a < b ? a : b;
        temp = temp < c ? temp : c;
        min = temp < d ? temp : d;
    end
    // assign intermediate_result1 = compare? true: false;

endmodule
