module bit3_mux_2_1(input logic select
                     input logic [2:0] input1, input2,
                     output logic [2:0] mux_2_1_out);

  always_comb
    begin
      if(select == 1)
        mux_2_1_out = input2;
      else
        mux_2_1_out = input1;
    end
  end
  
endmodule
