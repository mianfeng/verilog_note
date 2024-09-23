module top_module ( input clk, input d, output q );
	wire dff_wire1,dff_wire2;
    my_dff dff1 (.clk(clk), .d(d), .q(dff_wire1));
    my_dff dff2 (.clk(clk), .d(dff_wire1), .q(dff_wire2));
    my_dff dff3 (.clk(clk), .d(dff_wire2), .q(q));

endmodule
