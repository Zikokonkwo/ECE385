module obstacle (
    input logic clk, reset,
    output logic [9:0] obstacle_x, obstacle_y
);
    // Initialize obstacle position
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            obstacle_x <= 10'd100; // Start position X
            obstacle_y <= 10'd0;   // Start at the top
        end else begin
            obstacle_y <= obstacle_y + 1; // Move down
            if (obstacle_y >= 10'd480) 
                obstacle_y <= 10'd0; // Reset to top after reaching bottom
        end
    end
endmodule

