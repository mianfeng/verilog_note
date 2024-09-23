// synthesis verilog_input_version verilog_2001
module top_module (
    input [3:0] in,
    output reg [1:0] pos  );
    integer i;
    reg [1:0] pos_temp;
    always @(*) begin
        pos_temp = 2'b00;
        for (i=3; i>=0; i=i-1) begin
            if (in[i] == 1) begin
                pos_temp = i;
            end
            else
                pos_temp = pos_temp;
        end
        pos = pos_temp;
    end

endmodule
