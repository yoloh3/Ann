`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:47:15 10/12/2017
// Design Name:   w2_11
// Module Name:   D:/HDL_LSI/hdl_20171012/w2_11_tb.v
// Project Name:  hdl_20171012
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: w2_11
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module w2_11_tb;
	//parameter
	parameter clk_period = 1000;
	
	// Inputs
	reg clk;
	reg reset;
	reg [31:0] dw2_11;
	reg select_initial;
	reg select_update;

	// Outputs
	wire [31:0] w2_11;

	// Instantiate the Unit Under Test (UUT)
	w2_11 uut (
		.clk(clk), 
		.reset(reset), 
		.dw2_11(dw2_11), 
		.select_initial(select_initial), 
		.select_update(select_update), 
		.w2_11(w2_11)
	);
	
	//generate clock
	always begin
		clk=0;
		#(clk_period/2) clk=1;
		#(clk_period/2);
	end
	
	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		dw2_11 = 0;
		select_initial = 0;
		select_update = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
			#(clk_period) 	
			select_initial =1; select_update = 0; 							//output = w2_11 = 32'b0000_0000_0001_1001_1001_1001_1001_1001;
			
			#(clk_period) 	
			select_initial =0; select_update =1;
			dw2_11 = 32'b0000_0000_1111_0000_0000_0000_0000_0000;		//output = w2_11 = 32'b0000_0001_0000_1001_1001_1001_1001_1001;
			
			#(clk_period)
			select_initial =0; select_update=0;
			
			#(clk_period)
			select_initial =0; select_update=1;
			dw2_11 = 32'b0000_0010_0000_0010_0010_0010_0010_0010;		//output = w2_11 = 
			#(clk_period) $finish;
	end
      	//•\Ž¦
		always@(select_initial, select_update, w2_11)
			$display( $time, "  clk=%b select_initial = %d select_update = %d w2_11 =%b ", 
								    clk,   select_initial,   select_update,  w2_11);

endmodule

