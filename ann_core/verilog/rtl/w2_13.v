`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Kyushu Institute of Technology
// Engineer: DSP Lab
// 
// Create Date:    10:43:18 10/11/2017 
// Design Name:    Neural Network (using backpropagation)
// Module Name:    w2_13
// Project Name:   LSI Design Contest in Okinawa 2018
// Target Devices: 
// Tool versions: 
//
// Description: 
//		Calculation of w2_13, when the select initial signal is active, 
// 	    the output will be the initial value of w2_13, and when the select update 
//		signal is active, the output will be the new value of w2_13
//	Input: 
//		clk	    : 1 bit
//		reset	: 1 bit : high active
//		dw2_13	: 16 bits 00_0000.0000_0000_00 signed	 : delta weight2_13
//		select_initial	: 1 bit	: high active
//		select_update	: 1 bit	: high active
//	Output:
//		w2_13	: 16 bits 00_0000.0000_0000_00 signed : weight2_13
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module w2_13(clk, reset, dw2_13, select_initial, select_update, w2_13);
	
	input clk, reset;
	input select_initial, select_update;
	input signed [15:0] dw2_13;
	output signed [15:0] w2_13;
	
	reg signed [15:0] zero = 16'b0;
	reg signed [15:0] w2_13;
	reg signed [15:0] init_w2_13 = 16'b00_0000_1001_1001_10;   //initial w2_13 = 0.6
	reg signed [15:0] net1, net2;
	
	always @(posedge clk)
		begin
			if(reset==1)
				begin
					net1=0;
					net2=0;
					w2_13=0;
				end
			else
				begin
					net1 = select_update? dw2_13 : zero;
					net2 = w2_13+ net1;
					w2_13 = select_initial? init_w2_13 : net2;
				end
		end
endmodule
