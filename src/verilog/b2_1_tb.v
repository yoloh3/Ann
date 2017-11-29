`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: Kyushu Institute of Technology
// Engineer: DSP Lab
//
// Create Date:   14:16:09 10/11/2017
// Design Name:   Neural Network (using backpropagation)
// Module Name:   b2_1 test bench
// Project Name:  LSI Design Contest in Okinawa 2018
// Target Device:  
// Tool versions:  
// Description: 
// 	Test bench for b2_1 module calculation of 1 input and 1 output
//
//Test scenario:
//	
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module b2_1_tb;
	//parameter
	parameter clk_period = 1000;
	// Inputs
	reg clk;
	reg reset;
	reg [31:0] db2_1;
	reg select_initial;
	reg select_update;

	// Outputs
	wire [31:0] b2_1;

	// Instantiate the Unit Under Test (UUT)
	b2_1 uut (
		.clk(clk), 
		.reset(reset), 
		.db2_1(db2_1), 
		.select_initial(select_initial), 
		.select_update(select_update), 
		.b2_1(b2_1)
	);

	//クロックの発生 generate clock
	always begin
		clk=0;
		#(clk_period/2) clk=1;
		#(clk_period/2);
	end
	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		db2_1 = 0;
		select_initial = 0;
		select_update = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		#(clk_period) 	select_initial=1; select_update =0;
							db2_1 = 32'b1111_1111_0000_0000_0000_0000_0000_0000;
		#(clk_period) 	select_initial=1; select_update =0;
							db2_1 = 32'b1111_1111_0000_0000_0000_0000_1111_0000;
		#(clk_period) 	select_initial=0; select_update =0;
							db2_1 = 32'b1111_1111_0000_0000_0000_1111_0000_0000;
		#(clk_period) 	select_initial=0; select_update =1;
							db2_1 = 32'b1111_1111_0000_0000_1111_0000_0000_0000;
		#(clk_period) $finish;
	end
      	//表示
		always@(select_initial,   select_update,b2_1)
			$display( $time, "  clk=%b select_initial = %d select_update = %d b2_1 =%b ", 
								    clk,   select_initial,   select_update,  b2_1);
endmodule

