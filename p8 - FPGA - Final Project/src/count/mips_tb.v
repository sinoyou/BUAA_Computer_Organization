`timescale 1ns / 1ps


module mips_tb;

	// Inputs
	reg clk_in;
	reg sys_rstn;
	reg rxd;
	reg [7:0] dip_switch0;
	reg [7:0] dip_switch1;
	reg [7:0] dip_switch2;
	reg [7:0] dip_switch3;
	reg [7:0] dip_switch4;
	reg [7:0] dip_switch5;
	reg [7:0] dip_switch6;
	reg [7:0] dip_switch7;
	reg [7:0] user_key;

	// Outputs
	wire txd;
	wire [31:0] led_light;
	wire [7:0] digital_tube0;
	wire [7:0] digital_tube1;
	wire [7:0] digital_tube2;
	wire [3:0] digital_tube_sel0;
	wire [3:0] digital_tube_sel1;
	wire digital_tube_sel2;

	// Instantiate the Unit Under Test (UUT)
	mips uut (
		.clk_in(clk_in), 
		.sys_rstn(sys_rstn), 
		.uart_rxd(rxd),
		.uart_txd(txd),
		.dip_switch0(dip_switch0), 
		.dip_switch1(dip_switch1), 
		.dip_switch2(dip_switch2), 
		.dip_switch3(dip_switch3), 
		.dip_switch4(dip_switch4), 
		.dip_switch5(dip_switch5), 
		.dip_switch6(dip_switch6), 
		.dip_switch7(dip_switch7), 
		.user_key(user_key), 
		.led_light(led_light), 
		.digital_tube0(digital_tube0), 
		.digital_tube1(digital_tube1), 
		.digital_tube2(digital_tube2), 
		.digital_tube_sel0(digital_tube_sel0), 
		.digital_tube_sel1(digital_tube_sel1), 
		.digital_tube_sel2(digital_tube_sel2)
	);

	initial begin
		// Initialize Inputs
		clk_in = 0;
		sys_rstn = ~1;
		rxd = 0;
		dip_switch0 = ~(0);
		dip_switch1 = ~0;
		dip_switch2 = ~0;
		dip_switch3 = ~0;
		dip_switch4 = ~(1);
		dip_switch5 = ~0;
		dip_switch6 = ~0;
		dip_switch7 = ~0;
		user_key = ~8'b00000010;

		// Wait 100 ns for global reset to finish
		#300;
      sys_rstn = ~0;  
		// Add stimulus here

	end
	always #1 clk_in = ~clk_in;
      
endmodule

