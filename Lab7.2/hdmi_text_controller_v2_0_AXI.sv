`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ECE-Illinois
// Engineer: Zuofu Cheng
// 
// Create Date: 06/08/2023 12:21:05 PM
// Design Name: 
// Module Name: hdmi_text_controller_v1_0_AXI
// Project Name: ECE 385 - hdmi_text_controller
// Target Devices: 
// Tool Versions: 
// Description: 
// This is a modified version of the Vivado template for an AXI4-Lite peripheral
// rewritten into SystemVerilog for use with ECE 385.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.02 - File modified to be more consistent with generated template
// Revision 11/18 - Made comments less confusing
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1 ns / 1 ps

module hdmi_text_controller_v1_0_AXI #
(

    // Parameters of Axi Slave Bus Interface S_AXI
    // Modify parameters as necessary for access of full VRAM range

    // Width of S_AXI data bus
    parameter integer C_S_AXI_DATA_WIDTH	= 32,
    // Width of S_AXI address bus
    parameter integer C_S_AXI_ADDR_WIDTH	= 16
)
(
    // Users to add ports here
    // output logic [C_S_AXI_DATA_WIDTH-1:0] slv_regs[600:0];/////////////////////////////////////////////////////////
    // User ports ends

    // Global Clock Signal
    input logic  S_AXI_ACLK,
    // Global Reset Signal. This Signal is Active LOW
    input logic  S_AXI_ARESETN,
    // Write address (issued by master, acceped by Slave)
    input logic [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
    // Write channel Protection type. This signal indicates the
        // privilege and security level of the transaction, and whether
        // the transaction is a data access or an instruction access.
    input logic [2 : 0] S_AXI_AWPROT,
    // Write address valid. This signal indicates that the master signaling
        // valid write address and control information.
    input logic  S_AXI_AWVALID,
    // Write address ready. This signal indicates that the slave is ready
        // to accept an address and associated control signals.
    output logic  S_AXI_AWREADY,
    // Write data (issued by master, acceped by Slave) 
    input logic [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
    // Write strobes. This signal indicates which byte lanes hold
        // valid data. There is one write strobe bit for each eight
        // bits of the write data bus.    
    input logic [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
    // Write valid. This signal indicates that valid write
        // data and strobes are available.
    input logic  S_AXI_WVALID,
    // Write ready. This signal indicates that the slave
        // can accept the write data.
    output logic  S_AXI_WREADY,
    // Write response. This signal indicates the status
        // of the write transaction.
    output logic [1 : 0] S_AXI_BRESP,
    // Write response valid. This signal indicates that the channel
        // is signaling a valid write response.
    output logic  S_AXI_BVALID,
    // Response ready. This signal indicates that the master
        // can accept a write response.
    input logic  S_AXI_BREADY,
    // Read address (issued by master, acceped by Slave)
    input logic [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
    // Protection type. This signal indicates the privilege
        // and security level of the transaction, and whether the
        // transaction is a data access or an instruction access.
    input logic [2 : 0] S_AXI_ARPROT,
    // Read address valid. This signal indicates that the channel
        // is signaling valid read address and control information.
    input logic  S_AXI_ARVALID,
    // Read address ready. This signal indicates that the slave is
        // ready to accept an address and associated control signals.
    output logic  S_AXI_ARREADY,
    // Read data (issued by slave)
    output logic [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
    // Read response. This signal indicates the status of the
        // read transfer.
    output logic [1 : 0] S_AXI_RRESP,
    // Read valid. This signal indicates that the channel is
        // signaling the required read data.
    output logic  S_AXI_RVALID,
    // Read ready. This signal indicates that the master can
        // accept the read data and response information.
    input logic  S_AXI_RREADY
);


///////////
 blk_mem_gen_0 bram_inst (
//Port A connections
        .addra(addra), // addresses the memory space for port A Read and write operations 
        .clka(clka), //same as clkb
        .dina(dina),//data input to be written into memory through port A
        .douta(douta),//data output from read operations through port A
        .ena(ena), //enables read, wrtie, and reset operations through port A
        .wea(wea),//enables write operations through port A 
 //Port B conenctions
        .addrb(addrb), //addresses the memory space for port B Read and write operations 
        .clkb(clkb), //same as clka
        .dinb(dinb), //data input to be written into memory through port B
        .doutb(doutb), ///data output from read operations through port B
        .enb(enb),//enables read, wrtie, and reset operations through port B
        .web(web)//enables write operations through port B
    );  

////////////
reg [31:0] Dina;
reg [31:0] Addra;
reg [31:0] Douta;

assign enb =  S_AXI_RREADY & ~S_AXI_ARVALID;

logic [31:0] value;
logic [31:0] Addrb;

//calculate address B --> need to use DrawY and DrawX
always_comb
begin
    value = DrawY[] *  + DrawX[];
    Addrb = {1'b0, value[31:1]};
end

logic [31:0] palette [8];
    
    
// AXI4LITE signals
logic  [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_awaddr;
logic  axi_awready;
logic  axi_wready;
logic  [1 : 0] 	axi_bresp;
logic  axi_bvalid;
logic  [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_araddr;
logic  axi_arready;
logic  [C_S_AXI_DATA_WIDTH-1 : 0] 	axi_rdata;
logic  [1 : 0] 	axi_rresp;
logic  	axi_rvalid;
// reg [31:0] palette [7:0]; // 8 registers, each 32 bits

// Example-specific design signals
// local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
// ADDR_LSB is used for addressing 32/64 bit registers/memories
// ADDR_LSB = 2 for 32 bits (n downto 2)
// ADDR_LSB = 3 for 64 bits (n downto 3)
localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
localparam integer OPT_MEM_ADDR_BITS = 13;
//----------------------------------------------
//-- Signals for user logic register space example
//------------------------------------------------
//-- Number of Slave Registers 4
//logic [C_S_AXI_DATA_WIDTH-1:0]	slv_reg0;
//logic [C_S_AXI_DATA_WIDTH-1:0]	slv_reg1;
//logic [C_S_AXI_DATA_WIDTH-1:0]	slv_reg2;
//logic [C_S_AXI_DATA_WIDTH-1:0]	slv_reg3;
//
//Note: the provided Verilog template had the registered declared as above, but in order to give 
//students a hint we have replaced the 4 individual registers with an unpacked array of packed logic. 
//Note that you as the student will still need to extend this to the full register set needed for the lab.
    // logic [C_S_AXI_DATA_WIDTH-1:0] slv_regs[601];////////////////////////////////////////////////////////////////////////
// logic	 slv_reg_rden;////////////////////////////////////////////////////////////////////////
// logic	 slv_reg_wren;////////////////////////////////////////////////////////////////////////
 logic [C_S_AXI_DATA_WIDTH-1:0]	 reg_data_out;////////////////////////////////////////////////////////////////////////
integer	 byte_index;
logic	 aw_en;
    //change something else from 4 --> 12

// I/O Connections assignments

assign S_AXI_AWREADY = axi_awready;
assign S_AXI_WREADY	= axi_wready;
assign S_AXI_BRESP	= axi_bresp;
assign S_AXI_BVALID	= axi_bvalid;
assign S_AXI_ARREADY = axi_arready;
assign S_AXI_RDATA	= axi_rdata;
assign S_AXI_RRESP	= axi_rresp;
assign S_AXI_RVALID	= axi_rvalid;
// Implement axi_awready generation
// axi_awready is asserted for one S_AXI_ACLK clock cycle when both
// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
// de-asserted when reset is low.
always_ff @( posedge S_AXI_ACLK )
begin
  if ( S_AXI_ARESETN == 1'b0 )
    begin
      axi_awready <= 1'b0;
      aw_en <= 1'b1;
    end 
  else
    begin    
      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
        begin
          // slave is ready to accept write address when 
          // there is a valid write address and write data
          // on the write address and data bus. This design 
          // expects no outstanding transactions. 
          axi_awready <= 1'b1;
          aw_en <= 1'b0;
        end
        else if (S_AXI_BREADY && axi_bvalid)
            begin
              aw_en <= 1'b1;
              axi_awready <= 1'b0;
            end
      else           
        begin
          axi_awready <= 1'b0;
        end
    end 
end       

// Implement axi_awaddr latching
// This process is used to latch the address when both 
// S_AXI_AWVALID and S_AXI_WVALID are valid. 

always_ff @( posedge S_AXI_ACLK )
begin
  if ( S_AXI_ARESETN == 1'b0 )
    begin
      axi_awaddr <= 0;
    end 
  else
    begin    
      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
        begin
          // Write Address latching 
          axi_awaddr <= S_AXI_AWADDR;
        end
    end 
end       

// Implement axi_wready generation
// axi_wready is asserted for one S_AXI_ACLK clock cycle when both
// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
// de-asserted when reset is low. 

always_ff @( posedge S_AXI_ACLK )
begin
  if ( S_AXI_ARESETN == 1'b0 )
    begin
      axi_wready <= 1'b0;
    end 
  else
    begin    
      if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID && aw_en )
        begin
          // slave is ready to accept write data when 
          // there is a valid write address and write data
          // on the write address and data bus. This design 
          // expects no outstanding transactions. 
          axi_wready <= 1'b1;
        end
      else
        begin
          axi_wready <= 1'b0;
        end
    end 
end       

// Implement memory mapped register select and write logic generation
// The write data is accepted and written to memory mapped registers when
// axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
// select byte enables of slave registers while writing.
// These registers are cleared when reset (active low) is applied.
// Slave register write enable is asserted when valid address and data are available
// and the slave is ready to accept the write address and write data.
// assign slv_reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;////////////////////////////////////////////////////////////////////////


	
//assign ena = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;//added from previous slv_reg_wren

    
always_ff @( posedge S_AXI_ACLK )
begin
  if ( S_AXI_ARESETN == 1'b0 )
    begin
        for (integer i = 0; i < 2**C_S_AXI_ADDR_WIDTH; i++)
        begin
            Dina[i] <= 0; //instead of slv_regs its dina
        end
    end
  else begin
      if (ena)//write enable
      begin
        for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
          if ( S_AXI_WSTRB[byte_index] == 1 ) begin
            // Respective byte enables are asserted as per write strobes, note the use of the index part select operator
            // '+:', you will need to understand how this operator works.
            Dina[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
            Addra <= axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB];
          end  
      end
  end
end    

// Implement write response logic generation
// The write response and response valid signals are asserted by the slave 
// when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
// This marks the acceptance of address and indicates the status of 
// write transaction.

// always_ff @( posedge S_AXI_ACLK )
// begin
//   if ( S_AXI_ARESETN == 1'b0 )
//     begin
//       axi_bvalid  <= 0;
//       axi_bresp   <= 2'b0;
//     end 
//   else
//     begin    
//       if (axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID)
//         begin
//           // indicates a valid write response is available
//           axi_bvalid <= 1'b1;
//           axi_bresp  <= 2'b0; // 'OKAY' response 
//         end                   // work error responses in future
//       else
//         begin
//           if (S_AXI_BREADY && axi_bvalid) 
//             //check if bready is asserted while bvalid is high) 
//             //(there is a possibility that bready is always asserted high)   
//             begin
//               axi_bvalid <= 1'b0; 
//             end  
//         end
//     end
// end 
    
typedef enum logic [1:0] {
  IDLE, wait_1, wait_2, wait_3
} state_t;

state_t state, next_state;

always_ff @(posedge S_AXI_ACLK) begin
  if (S_AXI_ARESETN == 1'b0) begin
    axi_bvalid <= 1'b0;
    axi_bresp  <= 2'b0;  // Default response is OKAY (2'b00)
    state      <= IDLE;
  end 
  else begin
    state <= next_state;  // Advance to the next state on each clock cycle

  // Manage axi_bvalid based on the current state
  if (state == wait_3) begin
      axi_bvalid <= 1'b1;   // Set axi_bvalid high after three cycles in wait_3
      axi_bresp  <= 2'b0;   // 'OKAY' response
    end 
  else if (S_AXI_BREADY && axi_bvalid) begin
      axi_bvalid <= 1'b0;   // Clear axi_bvalid when master acknowledges the response
    end
  end
end

always_comb begin
  // Default to remain in the same state
  next_state = state;

  case (state)
    IDLE: begin
      if (axi_awready && S_AXI_AWVALID && axi_wready && S_AXI_WVALID) begin
        next_state = wait_1;  // Start the delay process
      end
    end

    wait_1: next_state = wait_2;  // Progress to the next wait state
    wait_2: next_state = wait_3;
    wait_3: next_state = IDLE;    // After setting axi_bvalid, return to IDLE
  endcase
end
    
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//write to the palette
always_ff @(posedge S_AXI_ACLK) begin
	if (S_AXI_WREADY) //S_AXI_WSTRB && S_AXI_WREADY
	  begin
            if (S_AXI_AWADDR[31])
		palette[S_AXI_AWADDR[2:0]] <= S_AXI_WDATA;
	  end
	//S_AXI_WDATA <= 32'b0;
	if(S_AXI_ARREADY)
	  if(S_AXI_ARADDR[31])
	    begin
		S_AXI_RDATA <= palette[S_AXI_ARADDR[2:0]];
	    end else
	      begin
		S_AXI_RDATA <= Douta;
	      end
end
          


//// State machine to control the latency and response timing
//always_ff @(posedge S_AXI_ACLK) begin
//  if (S_AXI_ARESETN == 1'b0) begin
//    current_state <= IDLE;
//    next_state    <= IDLE;
//  end else begin
//    current_state <= next_state;
//  end
//end

//// Indicate when the write operation is complete (this depends on the VRAM/palette update)
//always_ff @(posedge S_AXI_ACLK) begin
//  if (S_AXI_ARESETN == 1'b0) begin
//    write_done <= 0;  // Reset the write completion flag
//  end else begin
//    // Write done condition - example for latency management
//    if (/* Write to VRAM/palette complete */) begin
//      write_done <= 1'b1;  // Set write_done flag when the operation is completed
//    end else begin
//      write_done <= 0;  // Reset if the operation is not yet completed
//    end
//  end
//end


// Implement axi_arready generation
// axi_arready is asserted for one S_AXI_ACLK clock cycle when
// S_AXI_ARVALID is asserted. axi_awready is 
// de-asserted when reset (active low) is asserted. 
// The read address is also latched when S_AXI_ARVALID is 
// asserted. axi_araddr is reset to zero on reset assertion.

always_ff @( posedge S_AXI_ACLK )
begin
  if ( S_AXI_ARESETN == 1'b0 )
    begin
      axi_arready <= 1'b0;
      axi_araddr  <= 32'b0;
    end 
  else
    begin    
      if (~axi_arready && S_AXI_ARVALID)
        begin
          // indicates that the slave has acceped the valid read address
          axi_arready <= 1'b1;
          // Read address latching
          axi_araddr  <= S_AXI_ARADDR;
        end
      else
        begin
          axi_arready <= 1'b0;
        end
    end 
end       

// Implement axi_arvalid generation
// axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
// S_AXI_ARVALID and axi_arready are asserted. The slave registers 
// data are available on the axi_rdata bus at this instance. The 
// assertion of axi_rvalid marks the validity of read data on the 
// bus and axi_rresp indicates the status of read transaction.axi_rvalid 
// is deasserted on reset (active low). axi_rresp and axi_rdata are 
// cleared to zero on reset (active low).  
always_ff @( posedge S_AXI_ACLK )
begin
  if ( S_AXI_ARESETN == 1'b0 )
    begin
      axi_rvalid <= 0;
      axi_rresp  <= 0;
    end 
  else
    begin    
      if (axi_arready && S_AXI_ARVALID && ~axi_rvalid)
        begin
          // Valid read data is available at the read data bus
          axi_rvalid <= 1'b1;
          axi_rresp  <= 2'b0; // 'OKAY' response
        end   
      else if (axi_rvalid && S_AXI_RREADY)
        begin
          // Read data is accepted by the master
          axi_rvalid <= 1'b0;
        end                
    end
end 
always_comb
begin
	if(ena == 1)
		addra <= axi_araddr;
	else
		addra <= axi_awaddr;
end

// Implement memory mapped register select and read logic generation
// Slave register read enable is asserted when valid address is available
// and the slave is ready to accept the read address.
assign ena = axi_arready & S_AXI_ARVALID & ~axi_rvalid;
always_comb
begin
      // Address decoding for reading registers
//     Douta = Dina[axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB]];
reg_data_out = Douta;
end

// Output register or memory read data
always_ff @( posedge S_AXI_ACLK )
begin
  if ( S_AXI_ARESETN == 1'b0 )
    begin
      axi_rdata  <= 0;
    end 
  else
    begin    
      // When there is a valid read address (S_AXI_ARVALID) with 
      // acceptance of read address by the slave (axi_arready), 
      // output the read dada 
        if (ena)
        begin
          axi_rdata <= douta;     // register read data
        end   
    end
end    

// Add user logic here

// User logic ends

endmodule
