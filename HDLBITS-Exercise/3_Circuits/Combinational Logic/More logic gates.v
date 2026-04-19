module top_module( 
    input a, b,
    output out_and,
    output out_or,
    output out_xor,
    output out_nand,
    output out_nor,
    output out_xnor,
    output out_anotb
);
        xor xor_gate(out_xor,a,b);
        nor nor_gate(out_nor,a,b);
        xnor xnor_gate(out_xnor,a,b);
    always@(*) begin
        out_and=a&b;
        out_or=a|b;
        out_nand=~(a & b);
        out_anotb= a &(~b);
    end
endmodule
