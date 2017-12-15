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
	reg update_coeff;
	reg signed [15:0] input_k_1;
	reg signed [15:0] input_k_2;

	// Outputs
	wire signed [15:0] a3_1;
	wire signed [15:0] a3_2;
	wire finishing_update;
   
	// Instantiate the Unit Under Test (UUT)
	NN_CORE uut (
	.clk(clk),
	.res(res),
	.update_coeff(update_coeff),
	.input_k_1(input_k_1),
	.input_k_2(input_k_2),
	.finish_updating(finishing_update),
	.a3_1(a3_1),
	.a3_2(a3_2)
	);

	parameter clk_period = 100;
	
	always begin
	   clk = 0;
	   #(clk_period/2) clk=1;
	   #(clk_period/2);
	end
	
	initial begin
	   res = 0;
	   update_coeff = 0;
           input_k_1 = 16'h0;
           input_k_2 = 16'h0;	   
	   #(clk_period/2) res=1; 
	   #(clk_period/2) res=0;
	   #(clk_period/2)
	   update_coeff = 1;
	   #(clk_period)  	
	   #(clk_period)  	
	   #(clk_period)  	
	   #(clk_period)  	
	   // update_coeff = 0;

	#(clk_period*13*10000)
	
	// Add stimulus here
	// End
	#(clk_period*10) $finish;
	end
endmodule


