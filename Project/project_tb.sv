module tb_obstacle; 
    // Testbench signals
    logic Reset;
    logic frame_clk;
    logic [9:0] ObsX1, ObsY1, ObsX2, ObsY2;
    logic [9:0] obs1_size, obs2_size;

    // Clock generation
    always begin
        #5 frame_clk = ~frame_clk;  // 100 MHz clock (10 ns period)
    end

    // Instantiate the obstacles
    obstacle obs1 (
        .Reset(Reset),
        .frame_clk(frame_clk),
        .position_x(320),   // Initial position for obs1
        .position_y(240),   // Initial Y position
        .OBSX(ObsX1),
        .OBSY(ObsY1),
        .OBS_size(obs1_size)
    );
    
    obstacle obs2 (
        .Reset(Reset),
        .frame_clk(frame_clk),
        .position_x(400),   // Initial position for obs2
        .position_y(240),   // Initial Y position
        .OBSX(ObsX2),
        .OBSY(ObsY2),
        .OBS_size(obs2_size)
    );

    // Stimulus block
    initial begin
        // Initialize signals
        Reset = 1;
        frame_clk = 0;
        
        // Wait for a few cycles and then release reset
        #10 Reset = 0;
        
        // Run the simulation for 5000 time units (5000 * 10 ns = 50 us)
        #5000;

        // End simulation
        $finish;
    end

    // Monitor the signals (optional, for debugging)
    initial begin
        $monitor("At time %t, Obs1: (X = %d, Y = %d), Obs2: (X = %d, Y = %d)", 
                  $time, ObsX1, ObsY1, ObsX2, ObsY2);
    end

endmodule
