/**
if (reset[t] == 1) out[t+1] = 0
	else if (load[t] == 1) out[t+1] = in
	else if (inc[t] == 1) out[t+1] = out[t] + 1 (integer add)
	else out[t+1] = out[t]
*/
//NOTE: The provided PC.out and PC.cmp do not match. I saved
//the PC.out as PC.out.orig. Comparing that to my own PC.out
//shows it's the same. So does comparing the testbunch results

`default_nettype none

module PC(
	input wire clk,
	input wire reset,
	input wire [15:0] in,
	input wire load,
	input wire inc,
	output wire [15:0] out
);	

    reg [15:0] pc = 16'hFFFF;
    always @(negedge clk) begin
        if (reset)
            pc <= 0;
        else if(load) 
            pc <= in;
        else if (inc)
            pc <= pc + 1;
        else
            pc <= pc;
    end
    assign out = pc;

endmodule
