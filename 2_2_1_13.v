module top_module (
    input clk,
    input x,
    output z
); 	

	wire temp_dff1;
	wire dff1_in;
	assign dff1_in = x^temp_dff1;
	DFF_self dff1(.clk(clk), .D(dff1_in), .Q(temp_dff1), .Q_ba());
	wire temp_dff2;
	wire temp_dff2_bar;
	wire dff2_in;
	assign dff2_in = ~temp_dff2&x;
	DFF_self dff2(.clk(clk), .D(dff2_in), .Q(temp_dff2), .Q_ba(temp_dff2_bar));
	wire temp_dff3;
	wire temp_dff3_bar;
	wire dff3_in;
	assign dff3_in = ~temp_dff3|x;
	DFF_self dff3(.clk(clk), .D(dff3_in), .Q(temp_dff3), .Q_ba(temp_dff3_bar));
	assign z =~(temp_dff3|temp_dff2|temp_dff1) ;



endmodule


module DFF_self (
	input clk,
	input D,
	output reg Q,
	output reg Q_ba
);

	always@ (posedge clk)begin
		Q <= D;
		Q_ba <= ~D;
	end
endmodule
