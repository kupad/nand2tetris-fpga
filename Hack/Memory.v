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
    wire isRAM = ~address[13];
    wire loadSpecial = load && address[13];

    assign loadRAM = load == 1 && isRAM;
    assign load0000 = loadSpecial && address[3:0] == 4'b0000;
    assign load0001 = loadSpecial && address[3:0] == 4'b0001;
    assign load0010 = loadSpecial && address[3:0] == 4'b0010;
    assign load0011 = loadSpecial && address[3:0] == 4'b0011;
    assign load0100 = loadSpecial && address[3:0] == 4'b0100;
    assign load0101 = loadSpecial && address[3:0] == 4'b0101;
    assign load0110 = loadSpecial && address[3:0] == 4'b0110;
    assign load0111 = loadSpecial && address[3:0] == 4'b0111;
    assign load1000 = loadSpecial && address[3:0] == 4'b1000;
    assign load1001 = loadSpecial && address[3:0] == 4'b1001;
    assign load1010 = loadSpecial && address[3:0] == 4'b1010;
    assign load1011 = loadSpecial && address[3:0] == 4'b1011;
    assign load1100 = loadSpecial && address[3:0] == 4'b1100;
    assign load1101 = loadSpecial && address[3:0] == 4'b1101;
    assign load1110 = loadSpecial && address[3:0] == 4'b1110;
    assign load1111 = loadSpecial && address[3:0] == 4'b1111;

    assign out = isRAM ? inRAM :
        (address[3:0] == 4'b0000) ? in0000 :
        in0001;
    
    /*
    reg rout;
    always @(*) begin
        if(isRAM)
            rout = inRAM;
        else 
            case (address[3:0])
                4'b0000: rout = in0000;
                4'b0001: rout = in0001;
                4'b0010: rout = in0010;
                4'b0011: rout = in0011;
                4'b0100: rout = in0100;
                4'b0101: rout = in0101;
                4'b0110: rout = in0110;
                4'b0111: rout = in0111;
                4'b1000: rout = in1000;
                4'b1001: rout = in1001;
                4'b1010: rout = in1010;
                4'b1011: rout = in1011;
                4'b1100: rout = in1100;
                4'b1101: rout = in1101;
                4'b1110: rout = in1110;
                default: rout = in1111;
            endcase
    end
    assign out = rout;
    */
endmodule	
