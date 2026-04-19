module top_module (
    input in1,
    input in2,
    input in3,
    output out);
    wire out_xnor;
    xnor xnor_1(out_xnor,in1,in2);
    xor xor_1(out,out_xnor,in3);

endmodule
