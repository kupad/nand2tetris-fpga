/**
 * The Hack CPU (Central Processing unit), consisting of an ALU,
 * two registers named A and D, and a program counter named PC.
 * The CPU is designed to fetch and execute instructions written in 
 * the Hack machine language. In particular, functions as follows:
 * Executes the inputted instruction according to the Hack machine 
 * language specification. The D and A in the language specification
 * refer to CPU-resident registers, while M refers to the external
 * memory location addressed by A, i.e. to Memory[A]. The inM input 
 * holds the value of this location. If the current instruction needs 
 * to write a value to M, the value is placed in outM, the address 
 * of the target location is placed in the addressM output, and the 
 * writeM control bit is asserted. (When writeM==0, any value may 
 * appear in outM). The outM and writeM outputs are combinational: 
 * they are affected instantaneously by the execution of the current 
 * instruction. The addressM and pc outputs are clocked: although they 
 * are affected by the execution of the current instruction, they commit 
 * to their new values only in the next time step. If reset==1 then the 
 * CPU jumps to address 0 (i.e. pc is set to 0 in next time step) rather 
 * than to the address resulting from executing the current instruction. 
 */
    
//instruction[16]:
//cccccccccccccccc
//
//A-instr
//0ccccccccccccccc 
//  instruction[15] == 0
//  c0...c14 is a memory location (or val)
//
//C-instruction:
//1xxaccccccdddjjj 
//  instruction[15] == 1
//
//acccc 'comp' instruction[6-12]
//  a: instruction[12]
//  c: instruction[6..11]
//ddd 'dest' instruction[3-5]
//  M: instruction[3]
//  D: instruction[4]
//  A: instruction[5]
//jjj 'jump' instruction[0-2]
//  table defined below


`default_nettype none
module CPU(
		input clk,
    	input [15:0] inM,         	// M value input  (M = contents of RAM[A])
    	input [15:0] instruction, 	// Instruction for execution
		input reset,           	// Signals whether to re-start the current
                         				// program (reset==1) or continue executing
                         				// the current program (reset==0).

    	output [15:0] outM,        // M value output
    	output writeM,          	// Write to M? 
    	output [15:0] addressM,    // Address in data memory (of M) to read
    	output [15:0] pc         	// address of next instruction
);
    wire loadA, loadD;
    wire [15:0] Aout, Dout, Ain;
    wire destA = instruction[5], 
         destD = instruction[4], 
         destM = instruction[3];
    wire [15:0] ALUy, ALUout;
    wire lt, eq, gt;
    wire jmp;
    
    /* A reg */
    assign loadA = ~instruction[15] | destA;
    //If A-instruction, instruction is input else, ALUout is input
    assign Ain = instruction[15] == 0 ? instruction : ALUout;
    Register RegA(.clk(clk), .in(Ain), .load(loadA), .out(Aout));
    
    /* D reg */
    assign loadD = instruction[15] & destD;
    Register RegD(.clk(clk), .in(ALUout), .load(loadD), .out(Dout));
        

    /* ALU */
    //Choose: is A or inM being fed to the ALU
    //0011111: x+1
    assign ALUy = instruction[12] ? inM : Aout;
    ALU Alu(
        .x(Dout), .y(ALUy), 
        .zx(instruction[11]), .nx(instruction[10]), .zy(instruction[9]), .ny(instruction[8]), .f(instruction[7]), .no(instruction[6]),
        .out(ALUout), .zr(eq), .ng(lt));
        
    /* MEM */
    assign addressM = Aout;
    assign outM = ALUout;
    assign writeM = instruction[15] & destM;

    /* PC */
    assign gt = ~eq & ~lt;

    //jmp if:
    //GT: instruction[0]
    //EQ: instruction[1]
    //LT: instruction[2]
    assign jmp = instruction[15] & (
        (instruction[0] & gt) | (instruction[1] & eq) | (instruction[2] & lt));

    PC Pc(.clk(clk), .in(Aout), .load(jmp), .inc(1'b1), .reset(reset), .out(pc));


endmodule

