module top_module( 
    input [2:0] in,
    output [1:0] out );
    integer i;
    always @(*) begin
        out = 2'b0;
        for (i = 0; i < 3; i = i + 1) begin
            if (in[i] == 1) begin
                out = out + 1;
            end
            else begin
                out = out;
            end
        end
    end

endmodule
