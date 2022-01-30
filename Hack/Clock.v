/** 
 * input clk_in: clock input 100 MHz
 * output clk: clock output 33.333333 MHz
 *
 * Implementation with 2 bit DFF-counter:
 * counter | 0 1 2 0 1 2 0 1 2 0 1 2 0 1 2 ....
 * clk     | 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 ....
 */

`default_nettype none

module Clock(
	input wire in,			//external clock 100Mz
	output wire out			//Hack clock 33.333333 MHz
);

    /* after solving with DFFs below, I was 
    * able to find my way to this easier solution using a counter
    */
    reg [1:0] counter = 0;
    reg rout; //reg out
    always @(negedge in) begin
        counter <= counter + 1;
        if (counter == 2'b10) begin
            rout <= 1;
            counter <= 0;
        end
        else
            rout <= 0;
    end
    assign out = rout;


    /*
     * The following method uses the provided DFF.
     *
     * Dividing 100/3 (instead of 4 or 2) is tricky.
     *
     *
     * d0 and d1 are DFFs that hold a bit. 
     * d0 feeds d1, not(d1) feeds d0.
     * That leads to a: 00,10,11,01 pattern. (4 count)
     * 
     * To fix:
     * When BOTH would output 1s (11 representing the 3rd count),
     * instead of feeding 1 into d1 we feed 0. (0 already would be going to
     * d0.
     *
     * d0   d1
     * 0    0
     * 1    0
     * 1    1   <- emit 1, but reset by feeding 0 into d1 instead of 1 on the
     *              next iter. That will repeat this sequence
     * 0    0
     * 1    0
     * 1    1   <- again..
     *
     */
    /*
    wire d0in, d1in;
    wire d0out, d1out;

    assign d0in = ~d1out;
    assign d1in = d0out & d1out ? 0 : d0out;
    DFF d0(.clk(in), .in(d0in), .out(d0out));
    DFF d1(.clk(in), .in(d1in), .out(d1out));
    assign out = d1out;
    */

endmodule
