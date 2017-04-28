// The $readmemb and $readmemh system tasks load the contents of a 2-D
// array variable from a text file.  Quartus Prime supports these system tasks in
// initial blocks.  They may be used to initialized the contents of inferred
// RAMs or ROMs.  They may also be used to specify the power-up value for
// a 2-D array of registers. 
// 
// Usage:
//
// ("file_name", memory_name [, start_addr [, end_addr]]);
// ("file_name", memory_name [, start_addr [, end_addr]]);
//
// File Format:
// 
// The text file can contain Verilog whitespace characters, comments,
// and binary ($readmemb) or hexadecimal ($readmemh) data values.  Both
// types of data values can contain x or X, z or Z, and the underscore
// character.
// 
// The data values are assigned to memory words from left to right,
// beginning at start_addr or the left array bound (the default).  The
// next address to load may be specified in the file itself using @hhhhhh, 
// where h is a hexadecimal character.  Spaces between the @ and the address 
// character are not allowed.  It shall be an error if there are too many 
// words in the file or if an address is outside the bounds of the array.
//
// Example:
//
// reg [7:0] ram[0:2];
// 
// initial
// begin
//     $readmemb("init.txt", rom);
// end
//
// <init.txt>
//
// 11110000      // Loads at address 0 by default
// 10101111   
// @2 00001111
   
// Quartus Prime Verilog Template
// True Dual Port RAM with single clock

module true_dual_port_ram_single_clock
    #(parameter DATA_WIDTH=8, parameter ADDR_WIDTH=6)
(
    input [(DATA_WIDTH-1):0] data_a, data_b,
    input [(ADDR_WIDTH-1):0] addr_a, addr_b,
    input we_a, we_b, clk,
    output reg [(DATA_WIDTH-1):0] q_a, q_b
);
    // Declare the RAM variable
    reg [DATA_WIDTH-1:0] ram[0:2**ADDR_WIDTH-1];

    // Port A 
    always @ (posedge clk) begin
        if (we_a) begin
            ram[addr_a] <= data_a;
            q_a <= data_a;
        end
        else begin
            q_a <= ram[addr_a];
        end 
    end 

    // Port B 
    always @ (posedge clk) begin
        if (we_b) begin
            ram[addr_b] <= data_b;
            q_b <= data_b;
        end
        else begin
            q_b <= ram[addr_b];
        end 
    end
endmodule
