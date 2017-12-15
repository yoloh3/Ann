`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: Kyushu Institute of Technology
// Engineer: DSP Lab
// 
// Create Date:    13:48:25 09/06/2017 
// Design Name:    Neural Network (using backpropagation)
// Module Name:    z3 test bench
// Project Name:   LSI Design Contest in Okinawa 2018
// Target Devices: 
// Tool versions: 
//
// Description: 
// 	Test bench for z3 module calculation of 3 input and 1 output
// 
// Test scenario:
//		insert a2 following with bias and weight value.
// 	output value (z3) is stated at every end of the input
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Name : date : what changed
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module z3_tb;

	//parameter
	parameter clk_period=1000;		
	
	// Inputs
	reg clk;
	reg reset;
	reg signed [15:0] a2_1;
	reg signed [15:0] a2_2;
	reg signed [15:0] a2_3;
	reg signed [15:0] w3_1;
	reg signed [15:0] w3_2;
	reg signed [15:0] w3_3;
	reg signed [15:0] b3;

	// Outputs
	wire [7:0] z3;

	// Instantiate the Unit Under Test (UUT)
	z3 uut (
		.clk(clk), 
		.reset(reset),
		.a2_1(a2_1), 
		.a2_2(a2_2), 
		.a2_3(a2_3), 
		.w3_1(w3_1), 
		.w3_2(w3_2), 
		.w3_3(w3_3), 
		.b3(b3), 
		.z3(z3)
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
		a2_1 = 0;
		a2_2 = 0;
		a2_3 = 0;
		w3_1 = 0;
		w3_2 = 0;
		w3_3 = 0;
		b3 = 0;
        
		// Add stimulus here
		#(clk_period)	    a2_1 = 16'b00_0000_1111_0011_00; 			//input a2_1= (0.9497)d
							a2_2 = 16'b00_0000_1111_1110_11; 			//input a2_2 = (0.9954)d
							a2_3 = 16'b00_0000_1111_1101_01;			//input a2_3 = (0.9897)d
							b3   = 16'b11_1111_0000_0000_00;			//bias3 b3 = (-1)d
							w3_1 = 16'b00_0000_1011_0011_00; 			//weight w3_1=(0.7)d
							w3_2 = 16'b00_0000_0011_0011_00; 			//weight w3_2=(0.2)d
							w3_3 = 16'b00_0001_0100_1100_11; 			//weight w3_3 =(1.3)d
							//output z3 = 1.1250																
		#(clk_period)       b3   = 16'b11_1111_0000_0000_00;			//bias3 b3 = (-1)d
							w3_1 = 16'b00_0000_0011_0011_00; 			//weight w3_1=(0.2)d
							w3_2 = 16'b00_0000_1000_0000_00; 			//weight w3_2=(0.5)d
							w3_3 = 16'b00_0001_0001_1001_10; 			//weight w3_3 =(1.1)d
							//output	z3 = 0.7500
		#(clk_period)	    a2_1 = 16'b00_0000_1101_1010_00; 			//input a2_1= (0.8520)d
							a2_2 = 16'b00_0000_1111_1010_11; 			//input a2_2 = (0.9797)d
							a2_3 = 16'b00_0000_1111_1100_01;			//input a2_3 = (0.9859)d
							b3   = 16'b11_1111_0000_0000_00;			//bias3 b3 = (-1)d
							w3_1 = 16'b00_0000_1011_0011_00; 			//weight w3_1=(0.7)d
							w3_2 = 16'b00_0000_0011_0011_00; 			//weight w3_2=(0.2)d
							w3_3 = 16'b00_0001_0100_1100_11; 			//weight w3_3 =(1.3)d
							//output z3 = 1.0625															
		#(clk_period)       b3   = 16'b11_1111_0000_0000_00;			//bias3 b3 = (-1)d
							w3_1 = 16'b00_0000_0011_0011_00; 			//weight w3_1=(0.2)d
							w3_2 = 16'b00_0000_1000_0000_00; 			//weight w3_2=(0.5)d
							w3_3 = 16'b00_0001_0001_1001_10; 			//weight w3_3 =(1.1)d
							//output	z3 = 0.6875
		#(clk_period)	    a2_1 = 16'b00_0000_1110_1111_10; 			//input a2_1= (0.9363)d
							a2_2 = 16'b00_0000_1111_1101_00; 			//input a2_2 = (0.9883)d
							a2_3 = 16'b00_0000_1111_0000_10;			//input a2_3 = (0.9399)d
							b3   = 16'b11_1111_0000_0000_00;			//bias3 b3 = (-1)d
							w3_1 = 16'b00_0000_1011_0011_00; 			//weight w3_1=(0.7)d
							w3_2 = 16'b00_0000_0011_0011_00; 			//weight w3_2=(0.2)d
							w3_3 = 16'b00_0001_0100_1100_11; 			//weight w3_3 =(1.3)d
							//output z3 = 1.0625																
		#(clk_period)       b3   = 16'b11_1111_0000_0000_00;			//bias3 b3 = (-1)d
							w3_1 = 16'b00_0000_0011_0011_00; 			//weight w3_1=(0.2)d
							w3_2 = 16'b00_0000_1000_0000_00; 			//weight w3_2=(0.5)d
							w3_3 = 16'b00_0001_0001_1001_10; 			//weight w3_3 =(1.1)d
							//output	z3 = 0.6875
		#(clk_period)	    a2_1 = 16'b00_0000_1100_1110_11; 			//input a2_1= (0.8081)d
							a2_2 = 16'b00_0000_1111_0011_00; 			//input a2_2 = (0.9497)d
							a2_3 = 16'b00_0000_1110_1011_01;			//input a2_3 = (0.9196)d
							b3   = 16'b11_1111_0000_0000_00;			//bias3 b3 = (-1)d
							w3_1 = 16'b00_0000_1011_0011_00; 			//weight w3_1=(0.7)d
							w3_2 = 16'b00_0000_0011_0011_00; 			//weight w3_2=(0.2)d
							w3_3 = 16'b00_0001_0100_1100_11; 			//weight w3_3 =(1.3)d
							//output z3 = 0.9375																
		#(clk_period)       b3   = 16'b11_1111_0000_0000_00;			//bias3 b3 = (-1)d
							w3_1 = 16'b00_0000_0011_0011_00; 			//weight w3_1=(0.2)d
							w3_2 = 16'b00_0000_1000_0000_00; 			//weight w3_2=(0.5)d
							w3_3 = 16'b00_0001_0001_1001_10; 			//weight w3_3 =(1.1)d
							//output	z3 = 0.6250
		#(clk_period) $finish;
	end 

	//display
	always@(z3)
			$display( $time, " a2_1=%b a2_2=%b a2_3=%b b3=%b z3=%b", 
									a2_1,   a2_2,    a2_3,   b3,    z3);
      
endmodule

