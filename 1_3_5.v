module top_module ( 
    input clk, 
    input [7:0] d, 
    input [1:0] sel, 
    output [7:0] q 
);  
    wire [7:0] dff1, dff2,dff3;
    my_dff8 my_dff1 (.clk(clk), .d(d), .q(dff1));
    my_dff8 my_dff2 (.clk(clk), .d(dff1), .q(dff2));
    my_dff8 my_dff3 (.clk(clk), .d(dff2), .q(dff3));
    always @(*) begin
        case (sel)
            2'b00: q = d;
            2'b01: q = dff1;
            2'b10: q = dff2;
            2'b11: q = dff3;
            default: q = 8'b0; 
        endcase
    end
endmodule
