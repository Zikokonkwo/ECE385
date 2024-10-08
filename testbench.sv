module testbench(); //even though the testbench doesn't create any hardware, it still needs to be a module

timeunit 10ns;  // This is the amount of time represented by #1 
timeprecision 1ns;

// These signals are internal because the processor will be 
// instantiated as a submodule in testbench
logic 		Clk; 
logic		Reset_Load_Clr; 
logic 		run_i; // _i stands for input
logic [7:0]     sw_i;

logic        sign_LED;
logic [7:0]  hex_segA;
logic [3:0]  hex_gridA;	
logic [7:0]  Aval;
logic [7:0]  Bval;
//logic       LoadA; 
//logic [2:0] F;
//logic [1:0] R;

// To store expected results


// Instantiating the DUT (Device Under Test)
// Make sure the module and signal names match with those in your design
Lab4toplevel Lab4toplevel(.*);	

//assign xsw = Lab4toplevel.ripple_adder_9.fa.xsw;////////////////////////////////////////////////////////////////////////////////////////////
//assign cin = adder_toplevel.adder_sa.cin;///////////////////////////////////////////////////////////////////////////////
//assign out = adder_toplevel.out;

initial begin: CLOCK_INITIALIZATION
	Clk = 1'b1;
end 

// Toggle the clock
// #1 means wait for a delay of 1 timeunit, so simulation clock is 50 MHz technically 
// half of what it is on the FPGA board 

// Note: Since we do mostly behavioral simulations, timing is not accounted for in simulation, however
// this is important because we need to know what the time scale is for how long to run
// the simulation
always begin : CLOCK_GENERATION
	#1 Clk = ~Clk;
end

// Testing begins here
// The initial block is not synthesizable on an FPGA
// Everything happens sequentially inside an initial block
// as in a software program

// Note: Even though the testbench happens sequentially,
// it is recommended to use non-blocking assignments for most assignments because
// we do not want any dependencies to arise between different assignments in the 
// same simulation timestep. The exception is for reset, which we want to make sure
// happens first. 
initial begin: TEST_VECTORS
    run_i = 0;
    #10
    Reset_Load_Clr = 0;
    #20
    sw_i <= 8'hFF;
    #10
     Reset_Load_Clr = 1;
    #20
      Reset_Load_Clr = 0;
    #20
    sw_i <= 8'h01;
    #25
   run_i <= 1;
    #20
   run_i <= 0;
   #100
    
	
//	//change switches, reset_clr_ld, press run again
	run_i <= 1;
	#10
	run_i <= 0;
	
		$finish(); //this task will end the simulation if the Vivado settings are properly configured


end
endmodule
