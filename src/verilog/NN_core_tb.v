`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:21:46 10/16/2017
// Design Name:   NN_CORE
// Module Name:   C:/Users/igarashi/Desktop/20171016_1135_backward/NN_CORE/NN_CORE_tb.v
// Project Name:  NN_CORE
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: NN_CORE
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module NN_CORE_tb;

	// Inputs
	reg clk;
	reg res;
	reg din;
	reg select_initial;
	
	// Outputs
	wire [31:0] renewal_w3_11;
	wire [31:0] renewal_w3_12;
	wire [31:0] renewal_w3_21;
	wire [31:0] renewal_w3_22;
	wire [31:0] renewal_w3_31;
	wire [31:0] renewal_w3_32;
	wire [31:0] renewal_w2_11;
	wire [31:0] renewal_w2_12;
	wire [31:0] renewal_w2_13;
	wire [31:0] renewal_w2_21;
	wire [31:0] renewal_w2_22;
	wire [31:0] renewal_w2_23;
	wire [31:0] renewal_b3_1;
	wire [31:0] renewal_b3_2;
	wire [31:0] renewal_b3_3;
	wire [31:0] renewal_b2_1;
	wire [31:0] renewal_b2_2;
	wire [31:0] renewal_b2_3;

	// Instantiate the Unit Under Test (UUT)
	NN_CORE uut (
		.clk(clk), 
		.res(res), 
		.din(din), 
		.select_initial(select_initial), 
		.renewal_w3_11(renewal_w3_11), 
		.renewal_w3_12(renewal_w3_12), 
		.renewal_w3_21(renewal_w3_21), 
		.renewal_w3_22(renewal_w3_22), 
		.renewal_w3_31(renewal_w3_31), 
		.renewal_w3_32(renewal_w3_32), 
		.renewal_w2_11(renewal_w2_11), 
		.renewal_w2_12(renewal_w2_12), 
		.renewal_w2_13(renewal_w2_13), 
		.renewal_w2_21(renewal_w2_21), 
		.renewal_w2_22(renewal_w2_22), 
		.renewal_w2_23(renewal_w2_23), 
		.renewal_b3_1(renewal_b3_1), 
		.renewal_b3_2(renewal_b3_2), 
		.renewal_b3_3(renewal_b3_3), 
		.renewal_b2_1(renewal_b2_1), 
		.renewal_b2_2(renewal_b2_2), 
		.renewal_b2_3(renewal_b2_3)
	);

	parameter STEP = 100;
	
	always begin
		clk = 1; #(STEP/2);
		clk = 0; #(STEP/2);
	end
	
	initial begin
	res = 0;
	din = 0;
	select_initial = 0;
	
	#STEP
	res = 1;
	
	#STEP
	res = 0;
	din = 1;
	select_initial = 1;
//	t_1 = 32'b0000_0001_0000_0000_0000_0000_0000_0000;
//	t_2 = 0;
//	k_1 = 32'b0000_1000_0000_0000_0000_0000_0000_0000; 
//	k_2 = 32'b0000_1000_0000_0000_0000_0000_0000_0000;
	
	#STEP
	select_initial = 0;

	#(STEP*13*10000)
	
	// Add stimulus here
	// End
	#(STEP*10) $finish;
	end
	endmodule


