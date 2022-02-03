`default_nettype none
module Hack1( 
    input clk_in,				// external clock 100 MHz	
    input [1:0] but,			// buttons	(0 if pressed, 1 if released)
	output [1:0] led			// leds 	(0 off, 1 on)
);
    wire loadRUN = 1'b0; //where is this supposed to come from?
    wire reset;

    wire clk;
    
    //cpu outs
    wire cpuWriteM; //write to Mem?
    wire [15:0] 
        cpuAddressM, //Mem location
        cpuOutM,     //Mem output val
        cpuPC;       //program counter
    
    //mem 
    wire 
        memLoadRAM,     //loading RAM?
        memLoad0000;    //loading led?
    wire [15:0] memDataOut; //value at Mem location
    
    //ram
    wire [15:0] ramOut; //value at RAM address 
    
    //rom outs
    wire [15:0] romInstr; //instruction from ROM
    
    //special registers
    wire [15:0] ledRegOut;
    wire [15:0] butRegOut;
    //wire [15:0] notButRegOut;


    assign reset = loadRUN;
    
    Clock clock(.in(clk_in), .out(clk));
    
    ROM rom(.pc(cpuPC), .instruction(romInstr));
  
    CPU cpu(.clk(clk), .inM(memDataOut), .instruction(romInstr), .reset(reset), 
        .outM(cpuOutM), .writeM(cpuWriteM), .addressM(cpuAddressM), .pc(cpuPC));

    // Memory, RAM Buttons 
    Memory mem(
        //CPU connections
        .address(cpuAddressM), .load(cpuWriteM), .out(memDataOut), 

        //RAM connections
        .inRAM(ramOut), 
        .loadRAM(memLoadRAM),

        //led connection
        .load0000(memLoad0000),
        .in0000(ledRegOut),

        //button connection
        .in0001(butRegOut),

        //not used
        .in0010(16'h0000), .in0011(16'h0000), .in0100(16'h0000), .in0101(16'h0000), .in0110(16'h0000), .in0111(16'h0000), .in1000(16'h0000), 
        .in1001(16'h0000), .in1010(16'h0000), .in1011(16'h0000), .in1100(16'h0000), .in1101(16'h0000), .in1110(16'h0000), .in1111(16'h0000)
    );

    RAM ram(.clk(clk), .address(cpuAddressM), .load(memLoadRAM), .in(cpuOutM), .out(ramOut));

    //led
    Register ledReg(.clk(clk), .load(memLoad0000), .in(cpuOutM), .out(ledRegOut));
    assign led[0] = ledRegOut[0];
    assign led[1] = ledRegOut[1];

    //but
    Register butReg(.clk(clk), .load(1'b1), .in(but), .out(butRegOut));


endmodule
