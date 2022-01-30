/**
* Memory mapped IO
*
* Big Multiplexer/Demultiplexer to address Memory.
*
* if (load==1) and (address[13]==0) loadRAM=1
* if (load==1) and (address[13]==1 and address[3:0]==0000) load0000=1
* if (load==1) and (address[13]==1 and address[3:0]==0001) load0001=1
* if (load==1) and (address[13]==1 and address[3:0]==0010) load0010=1
* ...
* if (address[13]==0) data = dataRAM
* if (address[13]==1 and address[3:0]=0000) data = data0000
* if (address[13]==1 and address[3:0]=0001) data = data0001
* if (address[13]==1 and address[3:0]=0010) data = data0010
*/

`default_nettype none
module Memory(
	input wire [15:0] address,
	input wire load,
	output wire [15:0] out,
	output wire loadRAM,
	output wire load0000,
	output wire load0001,
	output wire load0010,
	output wire load0011,
	output wire load0100,
	output wire load0101,
	output wire load0110,
	output wire load0111,
	output wire load1000,
	output wire load1001,
	output wire load1010,
	output wire load1011,
	output wire load1100,
	output wire load1101,
	output wire load1110,
	output wire load1111,
	input wire [15:0] inRAM,
	input wire [15:0] in0000,
	input wire [15:0] in0001,
	input wire [15:0] in0010,
	input wire [15:0] in0011,
	input wire [15:0] in0100,
	input wire [15:0] in0101,
	input wire [15:0] in0110,
	input wire [15:0] in0111,
	input wire [15:0] in1000,
	input wire [15:0] in1001,
	input wire [15:0] in1010,
	input wire [15:0] in1011,
	input wire [15:0] in1100,
	input wire [15:0] in1101,
	input wire [15:0] in1110,
	input wire [15:0] in1111
);

//your implementation comes here:
//if > 8192 (2^13) 0010000000000000 use special I/O 
//else go to RAM

    assign loadRAM = load==1 && ~address[13];

    assign load0000 = load && address[13] && address[3:0] == 4'b0000;
    assign load0001 = load && address[13] && address[3:0] == 4'b0001;
    assign load0010 = load && address[13] && address[3:0] == 4'b0010;
    assign load0011 = load && address[13] && address[3:0] == 4'b0011;
    assign load0100 = load && address[13] && address[3:0] == 4'b0100;
    assign load0101 = load && address[13] && address[3:0] == 4'b0101;
    assign load0110 = load && address[13] && address[3:0] == 4'b0110;
    assign load0111 = load && address[13] && address[3:0] == 4'b0111;
    assign load1000 = load && address[13] && address[3:0] == 4'b1000;
    assign load1001 = load && address[13] && address[3:0] == 4'b1001;
    assign load1010 = load && address[13] && address[3:0] == 4'b1010;
    assign load1011 = load && address[13] && address[3:0] == 4'b1011;
    assign load1100 = load && address[13] && address[3:0] == 4'b1100;
    assign load1101 = load && address[13] && address[3:0] == 4'b1101;
    assign load1110 = load && address[13] && address[3:0] == 4'b1110;
    assign load1111 = load && address[13] && address[3:0] == 4'b1111;

    assign out = ~address[13] ? inRAM :
                 address[3:0] == 'b0000 ? in0000 :
                 address[3:0] == 'b0001 ? in0001 :
                 address[3:0] == 'b0010 ? in0010 :
                 address[3:0] == 'b0011 ? in0011 :
                 address[3:0] == 'b0100 ? in0100 :
                 address[3:0] == 'b0101 ? in0101 :
                 address[3:0] == 'b0110 ? in0110 :
                 address[3:0] == 'b0111 ? in0111 :
                 address[3:0] == 'b1000 ? in1000 :
                 address[3:0] == 'b1001 ? in1001 :
                 address[3:0] == 'b1010 ? in1010 :
                 address[3:0] == 'b1011 ? in1011 :
                 address[3:0] == 'b1100 ? in1100 :
                 address[3:0] == 'b1101 ? in1101 :
                 address[3:0] == 'b1110 ? in1110 :
                 in1111;
    

endmodule	
