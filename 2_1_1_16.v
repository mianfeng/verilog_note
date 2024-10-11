module top_module( 
    input [3:0] in,
    output [2:0] out_both,
    output [3:1] out_any,
    output [3:0] out_different );
    integer i;
    always @(*) begin
        for(i = 0;i<4;i =i+1)begin
            case (i)
                0 : begin
                        out_both[0] = in[0]&in[1];
                        out_different[0] = in[0]^in[1];
                    end
                1 : begin 
                        out_both[1] = in[1]&in[2];
                        out_any[1] = in[1]|in[0];
                        out_different[1] = in[1]^in[2];
                    end
                2 : begin
                        out_both[2] = in[2]&in[3];
                        out_any[2] = in[2]|in[1];
                        out_different[2] = in[2]^in[3];
                    end
                3 : begin
                        out_any[3] = in[3]|in[2];
                        out_different[3] = in[3]^in[0];
                    end
                default: begin
                        out_any = 3'b0;
                        out_both = 3'b0;
                        out_different = 4'b0;
                    end 
            endcase
                
    end
    end

endmodule
