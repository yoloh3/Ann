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
// 	Test bench for counter with input of clock and reset only
// 
// Test scenario:
//		for every 12 clock, the output will return to initial value
// 	output value is from 0 to 12
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Name : date : what changed
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module counter_tb;
	//parameter
	parameter clk_period=1000;
  
	//input
	reg clk;
	reg reset;
	
	//output
	wire [3:0] out;
  
	// Instantiate the Unit Under Test (UUT)
	counter uut (
		.clk(clk),
		.reset(reset),
		.out(out)
	);
  
	//generate clock
	always begin
		clk=0;
		#(clk_period/2) clk=1;
		#(clk_period/2);
	end
 
	initial begin
	// Initialize Inputs
	clk=0;
	reset=0;
	
	// Add stimulus here
    #(clk_period/2) reset=1;
    #(clk_period/2) reset=0;
    #(clk_period*16) $finish;
    
	end
	always @(out)
		begin
		$display( $time, " clk= %b resett=%d out=%b", 
											clk, reset, out);
	end
endmodule 