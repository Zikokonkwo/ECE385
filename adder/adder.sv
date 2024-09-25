
module fa (input logic a, sw, fn, xsw, c, //sw = switch data and xsw = sw data XORed with fn select
           output logic s, c_out
           );
           
    always_comb begin 
	xsw = sw^fn;
        s = a^xsw^c;
        c_out = (a&xsw)|(xsw&c)|(a&c);
        
    end
    
endmodule
//////////////////////////////////////////////////////
module ripple_adder_3 (input logic [2:0] a, xsw,
                       input logic  c_in, fn,
                       output logic [2:0] s,
                       output logic c_out);
                       
    logic c1, c2;

    fa fa0 (.a(a[0]), .xsw(xsw[0]), .c(fn), .s(s[0]), .c_out(c1));
    fa fa1 (.a(a[1]), .xsw(xsw[1]), .c(c1), .s(s[1]), .c_out(c2));
    fa fa2 (.a(a[2]), .xsw(xsw[2]), .c(c2), .s(s[2]), .c_out(c_out));
    
endmodule
///////////////////////////////////////////////////////
module ripple_adder (
	input  logic  [8:0] a, xsw,
	input  logic  fn,
	
	output logic  [8:0] s,
	output logic  cout
);
             
        logic c3, c6; 
        ripple_adder_3 ra3_0 (.a(a[2:0]),   .xsw(xsw[2:0]),   .c_in(fn),  .s(s[2:0]),   .c_out(c3) );
        ripple_adder_3 ra3_1 (.a(a[5:3]),   .xsw(xsw[5:3]),   .c_in(c3),  .s(s[5:3]),   .c_out(c6) );
        ripple_adder_3 ra3_2 (.a(a[8:6]),   .xsw(xsw[8:6]),   .c_in(c6),  .s(s[8:6]),   .c_out(cout) );
       
endmodule