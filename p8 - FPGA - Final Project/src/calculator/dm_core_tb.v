`timescale 1ns / 1ps

module dm_core_tb;

	// Inputs
	reg clka;
	reg ena;
	reg [3:0] wea;
	reg [10:0] addra;
	reg [31:0] dina;

	// Outputs
	wire [31:0] douta;

	// Instantiate the Unit Under Test (UUT)
	DM_Core uut (
		.clka(clka), 
		.ena(ena), 
		.wea(wea), 
		.addra(addra), 
		.dina(dina), 
		.douta(douta)
	);

	initial begin
		// Initialize Inputs
		clka = 0;
		ena = 0;
		wea = 0;
		addra = 0;
		dina = 0;

		// Wait 100 ns for global reset to finish
		#60;
		ena = 1;
		wea = 4'b1100;
		addra = 1002;
		dina = 32'h12345678;
		#80;
		wea = 4'b0000;
		addra = 1002;
        
		// Add stimulus here

	end
	always #20 clka = ~clka;
      
endmodule

