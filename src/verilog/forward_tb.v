`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: Kyushu Institute of Technology
// Engineer: DSP Lab
//
// Create Date:   10:27:31 10/19/2017
// Design Name:   Neural Network (using backpropagation)
// Module Name:   forward test bench
// Project Name: LSI Design Contest in Okinawa 2018
// Target Devices: 
// Tool versions: 
//
// Description: 
// 	Test bench for forward module calculation of 21 input and 22 output
// 
// Test scenario:
//		insert clock, din(read enable for memory) and select_initial 
//		following with bias and weight value.
// 	output value which is a2 and a3 is stated at every end of the input
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Name : date : what changed
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module forward_tb;
	//parameter
	parameter clk_period = 1000;
	// Inputs
	reg clk;
	reg reset;
	reg din;
	reg select_initial;
	reg signed [31:0] cap_b2_1;
	reg signed [31:0] cap_b2_2;
	reg signed [31:0] cap_b2_3;
	reg signed [31:0] cap_w2_11;
	reg signed [31:0] cap_w2_12;
	reg signed [31:0] cap_w2_13;
	reg signed [31:0] cap_w2_21;
	reg signed [31:0] cap_w2_22;
	reg signed [31:0] cap_w2_23;
	reg signed [31:0] cap_b3_1;
	reg signed [31:0] cap_b3_2;
	reg signed [31:0] cap_w3_11;
	reg signed [31:0] cap_w3_12;
	reg signed [31:0] cap_w3_21;
	reg signed [31:0] cap_w3_22;
	reg signed [31:0] cap_w3_31;
	reg signed [31:0] cap_w3_32;

	// Outputs
	wire [31:0] b2_1;
	wire [31:0] b2_2;
	wire [31:0] b2_3;
	wire [31:0] b3_1;
	wire [31:0] b3_2;
	wire [31:0] w2_11;
	wire [31:0] w2_12;
	wire [31:0] w2_13;
	wire [31:0] w2_21;
	wire [31:0] w2_22;
	wire [31:0] w2_23;
	wire [31:0] w3_11;
	wire [31:0] w3_12;
	wire [31:0] w3_21;
	wire [31:0] w3_22;
	wire [31:0] w3_31;
	wire [31:0] w3_32;
	wire [31:0] a2_1;
	wire [31:0] a2_2;
	wire [31:0] a2_3;
	wire [31:0] a3_1;
	wire [31:0] a3_2;

	// Instantiate the Unit Under Test (UUT)
	forward uut (
		.clk(clk), 
		.reset(reset), 
		.din(din), 
		.select_initial(select_initial), 
		.cap_b2_1(cap_b2_1), 
		.cap_b2_2(cap_b2_2), 
		.cap_b2_3(cap_b2_3), 
		.cap_w2_11(cap_w2_11), 
		.cap_w2_12(cap_w2_12), 
		.cap_w2_13(cap_w2_13), 
		.cap_w2_21(cap_w2_21), 
		.cap_w2_22(cap_w2_22), 
		.cap_w2_23(cap_w2_23), 
		.cap_b3_1(cap_b3_1), 
		.cap_b3_2(cap_b3_2), 
		.cap_w3_11(cap_w3_11), 
		.cap_w3_12(cap_w3_12), 
		.cap_w3_21(cap_w3_21), 
		.cap_w3_22(cap_w3_22), 
		.cap_w3_31(cap_w3_31), 
		.cap_w3_32(cap_w3_32), 
		.b2_1(b2_1), 
		.b2_2(b2_2), 
		.b2_3(b2_3), 
		.b3_1(b3_1), 
		.b3_2(b3_2), 
		.w2_11(w2_11), 
		.w2_12(w2_12), 
		.w2_13(w2_13), 
		.w2_21(w2_21), 
		.w2_22(w2_22), 
		.w2_23(w2_23), 
		.w3_11(w3_11), 
		.w3_12(w3_12), 
		.w3_21(w3_21), 
		.w3_22(w3_22), 
		.w3_31(w3_31), 
		.w3_32(w3_32), 
		.a2_1(a2_1), 
		.a2_2(a2_2), 
		.a2_3(a2_3), 
		.a3_1(a3_1), 
		.a3_2(a3_2)
	);
	
	// generate clock
	always begin
		clk=0;
		#(clk_period/2) clk=1;
		#(clk_period/2);
	end
	
	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		din = 0;
		select_initial = 0;
		cap_b2_1 = 0;
		cap_b2_2 = 0;
		cap_b2_3 = 0;
		cap_w2_11 = 0;
		cap_w2_12 = 0;
		cap_w2_13 = 0;
		cap_w2_21 = 0;
		cap_w2_22 = 0;
		cap_w2_23 = 0;
		cap_b3_1 = 0;
		cap_b3_2 = 0;
		cap_w3_11 = 0;
		cap_w3_12 = 0;
		cap_w3_21 = 0;
		cap_w3_22 = 0;
		cap_w3_31 = 0;
		cap_w3_32 = 0;

		// Add stimulus here
		#(clk_period/2) reset=1; 
		#(clk_period/2) reset=0; din=1; select_initial = 1;
        
		#(clk_period)  	
								cap_b2_1 = 32'b1111_1111_0000_0000_0000_0000_0000_0000; 				//cap_delta_bias2 db2_1=(-1)d
								cap_b2_2 = 32'b1111_1111_0000_0000_0000_0000_0000_0000;				//cap_delta_bias2 db2_2=(-1)d
								cap_b2_3 = 32'b1111_1111_0000_0000_0000_0000_0000_0000;				//cap_delta_bias2 db2_3=(-1)d
								cap_w2_11 = 32'b0000_0000_0001_1001_1001_1001_1001_1001; 			//cap_delta_weight dw2_11=(0.1)d
								cap_w2_21 = 32'b0000_0000_0110_0110_0110_0110_0110_0110; 			//cap_delta_weight dw2_21=(0.4)d
								cap_w2_12 = 32'b0000_0000_0100_1100_1100_1100_1100_1100; 			//cap_delta_weight dw2_12=(0.3)d 
								cap_w2_22 = 32'b0000_0000_1000_0000_0000_0000_0000_0000; 			//cap_delta_weight dw2_22=(0.5)d
								cap_w2_13 = 32'b0000_0000_1001_1001_1001_1001_1001_1001; 			//cap_delta_weight dw2_13=(0.6)d 
								cap_w2_23 = 32'b0000_0000_0001_1001_1001_1001_1001_1001;				//cap_delta_weight dw2_23=(0.1)d
								//z2_1 = 3 			z2_2 = 5.4    		z2_3 = 4.6							//output for hidden layer
								//a2_1 = 0.9526 	a2_2 = 0.9955 		a2_3 = 0.9900
								cap_b3_1 = 32'b1111_1111_0000_0000_0000_0000_0000_0000; 				//cap_delta_bias3 db3_1=(-1)d
								cap_b3_2 = 32'b1111_1111_0000_0000_0000_0000_0000_0000;				//cap_delta_bias3 db3_2=(-1)d
								cap_w3_11 = 32'b0000_0000_1011_0011_0011_0011_0011_0011; 			//cap_delta_weight dw3_11=(0.7)d
								cap_w3_21 = 32'b0000_0000_0011_0011_0011_0011_0011_0011; 			//cap_delta_weight dw3_21=(0.2)d
								cap_w3_31 = 32'b0000_0001_0100_1100_1100_1100_1100_1100; 			//cap_delta_weight dw3_31 =(1.3)d
								cap_w3_12 = 32'b0000_0000_0011_0011_0011_0011_0011_0011; 			//cap_delta_weight dw3_12=(0.2)d
								cap_w3_22 = 32'b0000_0000_1000_0000_0000_0000_0000_0000; 			//cap_delta_weight dw3_22=(0.5)d
								cap_w3_32 = 32'b0000_0001_0001_1001_1001_1001_1001_1001;				//cap_delta_weight dw3_32 =(1.1)d
								//z3_1 = 1.1530 	z3_2 = 0.7773												//output for output layer
								//a3_1 = 0.7601 	a3_2 = 0.6851 
		#(clk_period)  	select_initial = 0; 
		#(clk_period*50) $finish;
	end
	
	//display
	always@(a2_1, a3_1)
			$display( $time, " a2_1=%b a2_2=%b a2_3=%b a3_1=%b a3_2=%b", 
									a2_1,   a2_2,    a2_3,   a3_1,   a3_2);
      
endmodule
