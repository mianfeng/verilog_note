module top_module (
    input clk,
    input j,
    input k,
    output Q); 
 
    always@ (posedge clk) begin
        case ({j,k}) 
        	2'b00:Q <= Q;
            2'b01: Q <= 1'b0;
            2'b10: Q <= 1'b1;
           2'b11: Q <= !Q;
            default:Q <= 1'b0;
        endcase
    end
        
endmodule
// J	K	Q
// 0	0	Qold
// 0	1	0
// 1	0	1
// 1	1	~Qold
