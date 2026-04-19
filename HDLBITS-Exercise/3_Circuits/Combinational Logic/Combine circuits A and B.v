module top_module (input x, input y, output z);
    wire wa1,wa2,wb1,wb2,or1,and1;
    A IA1(.z(wa1),.x(x),.y(y));
    B IB1(.z(wb1),.x(x),.y(y));
    A IA2(.z(wa2),.x(x),.y(y));
    B IB2(.z(wb2),.x(x),.y(y));
    assign or1=wa1|wb1,and1=wa2&wb2;
    assign z=or1^and1;
endmodule
module A (input x, input y, output z);
    assign z=(x^y)&x;
endmodule
module B (input x, input y, output z);
    assign z=x~^y;
endmodule
