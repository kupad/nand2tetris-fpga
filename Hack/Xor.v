/**
 * Exclusive-or gate:
 * out = not (a == b)
 */
//`default_nettype none

module Xor(
	input wire a,
	input wire b,
	output wire out
);

    wire nota;
    wire notb;

    not NOT1(nota, a);
    not NOT2(notb, b);

    wire x;
    wire y;
    
    and AND1(x, a, notb);
    and AND2(y, nota, b);

    or OR(out, x, y);

endmodule

