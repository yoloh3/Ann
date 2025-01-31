`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: Kyushu Institute of Technology
// Engineer: DSP Lab
// 
// Create Date:    13:48:25 09/06/2017 
// Design Name: Neural Network (using backpropagation)
// Module Name:    z2 test bench
// Project Name: LSI Design Contest in Okinawa 2018
// Target Devices: 
// Tool versions: 
//
// Description: 
// 	Test bench for z2 module calculation of 2 input and 1 output
// 
// Test scenario:
// 	insert k1 and k2 following with bias and weight value.
// 	output value (z2) is stated at every end of the input
//	
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Name : date : what changed
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////


module z2_tb;

	//parameter
	parameter clk_period=1000;  
	// Inputs
	reg clk;
	reg reset;
	reg signed [15:0] k1;
	reg signed [15:0] k2;
	reg signed [15:0] w2_1;
	reg signed [15:0] w2_2;
	reg signed [15:0] b2;

	// Outputs
	wire [7:0] z2;

	// Instantiate the Unit Under Test (UUT)
	z2 uut (
		.clk(clk), 
		.reset(reset),
		.k1(k1), 
		.k2(k2), 
		.w2_1(w2_1), 
		.w2_2(w2_2), 
		.b2(b2), 
		.z2(z2)
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
		k1 = 0;
		k2 = 0;
		w2_1 = 0;
		w2_2 = 0;
		b2 = 0;
        
		// Add stimulus here
		#(clk_period)		    k1 	    = 16'b00_1000_0000_0000_00; 	//input k1 = (8)d
								k2  	= 16'b00_1000_0000_0000_00;		//input k2 = (8)d
								b2      = 16'b11_1111_0000_0000_00; 	//bias2 b2 = (-1)d
								w2_1 	= 16'b00_0000_0001_1001_10; 	//weight w2_1 = (0.0)d
								w2_2	= 16'b00_0000_0110_0110_01;		//weight w2_2 = (0.4)d
								//output z2 = 3.9375 0010_1111
		#(clk_period)         	b2      = 16'b11_1111_0000_0000_00; 	//bias2 = (-1)d
								w2_1 	= 16'b00_0000_0100_1100_11; 	//weight w2_1 = (0.3)d
								w2_2 	= 16'b00_0000_1000_0000_00; 	//weight w2_2 = (0.5)d
								//output z2 = 6.3750 0101_0110
		#(clk_period) 		    b2      = 16'b11_1111_0000_0000_00; 	//bias2 = (-1)d
								w2_1 	= 16'b00_0000_1001_1001_10; 	//weight w2_1 = (0.6)d
								w2_2 	= 16'b00_0000_0001_1001_10;		//weight w2_2 = (0.1)d
								//output z2 = 5.5625	0100_1001
		#(clk_period)		    k1 	    = 16'b00_1000_0000_0000_00; 	//input k1 = (8)d
								k2 	    = 16'b00_0101_0000_0000_00;		//input k2 = (5)d
								b2      = 16'b11_1111_0000_0000_00; 	//bias2 = (-1)d
								w2_1 	= 16'b00_0000_0001_1001_10; 	//weight w2_1 = (0.0)d
								w2_2	= 16'b00_0000_0110_0110_01;		//weight w2_2 = (0.4)d
								//output z2 = 2.7500 0001_1100
		#(clk_period)  	        b2      = 16'b11_1111_0000_0000_00; 	//bias2 = (-1)d
								w2_1 	= 16'b00_0000_0100_1100_11; 	//weight w2_1 = (0.3)d
								w2_2 	= 16'b00_0000_1000_0000_00; 	//weight w2_2 = (0.5)d
								//output z2 = 4.8750 0011_1110
		#(clk_period) 		    b2      = 16'b11_1111_0000_0000_00; 	//bias2 = (-1)d
								w2_1 	= 16'b00_0000_1001_1001_10; 	//weight w2_1 = (0.6)d
								w2_2 	= 16'b00_0000_0001_1001_10;		//weight w2_2 = (0.1)d
								//output z2 = 5.2500	0100_0100
		#(clk_period)		    k1 	    = 16'b00_0101_0000_0000_00; 	//input k1 = (5)d
								k2  	= 16'b00_1000_0000_0000_00;		//input k2 = (8)d
								b2      = 16'b11_1111_0000_0000_00; 	//bias2 = (-1)d
								w2_1 	= 16'b00_0000_0001_1001_10; 	//weight w2_1 = (0.0)d
								w2_2	= 16'b00_0000_0110_0110_01;		//weight w2_2 = (0.4)d
								//output z2 = 3.6875 0010_1011
		#(clk_period)         	b2      = 16'b11_1111_0000_0000_00; 	//bias2 = (-1)d
								w2_1 	= 16'b00_0000_0100_1100_11; 	//weight w2_1 = (0.3)d
								w2_2 	= 16'b00_0000_1000_0000_00; 	//weight w2_2 = (0.5)d
								//output z2 = 5.4375 0100_0111
		#(clk_period) 		    b2      = 16'b11_1111_0000_0000_00; 	//bias2 = (-1)d
								w2_1 	= 16'b00_0000_1001_1001_10; 	//weight w2_1 = (0.6)d
								w2_2 	= 16'b00_0000_0001_1001_10;		//weight w2_2 = (0.1)d
								//output z2 = 3.7500	0010_1100
		#(clk_period)		    k1 	    = 16'b00_0101_0000_0000_00; 	//input k1 = (5)d
								k2 	    = 16'b00_0101_0000_0000_00;		//input k2 = (5)d
								b2      = 16'b11_1111_0000_0000_00; 	//bias2 = (-1)d
								w2_1 	= 16'b00_0000_0001_1001_10; 	//weight w2_1 = (0.0)d
								w2_2	= 16'b00_0000_0110_0110_01;		//weight w2_2 = (0.4)d
								//output z2 = 2.4375 0001_0111
		#(clk_period)  	        b2      = 16'b11_1111_0000_0000_00; 	//bias2 = (-1)d
								w2_1 	= 16'b00_0000_0100_1100_11; 	//weight w2_1 = (0.3)d
								w2_2 	= 16'b00_0000_1000_0000_00; 	//weight w2_2 = (0.5)d
								//output z2 = 3.9375 0010_1111
		#(clk_period) 		    b2    = 16'b11_1111_0000_0000_00; 		//bias2 = (-1)d
								w2_1 	= 16'b00_0000_1001_1001_10; 	//weight w2_1 = (0.6)d
								w2_2 	= 16'b00_0000_0001_1001_10;		//weight w2_2 = (0.1)d
								//output z2 = 3.4375	0010_0111
		#(clk_period*5) $finish;  
	end
    
		//display 
		always@(z2)
			$display( $time, "  clk=%b k1 =%b k2=%b z2=%b", 
								    clk,   k1 ,   k2,  z2);
      
endmodule

