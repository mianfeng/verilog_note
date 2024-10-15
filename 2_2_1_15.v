module top_module (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);
	wire [7:0]temp_in;
	integer i;
	always @(posedge clk) begin
		for (i=0; i<8; i=i+1) begin
			if(in[i]&~temp_in[i]) begin
				pedge[i] <= 1'b1;
			end
			else begin
				pedge[i] <= 1'b0;
			end
		end
		temp_in <= in;
		

	end

endmodule
