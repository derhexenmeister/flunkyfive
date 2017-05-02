`include "timescale.vh"

module flunkyfive #(parameter GPIO_WIDTH=4) (
    input                   clk,
    input                   resetn,

    // APB Interface
    //
    input wire [15:0]       paddr,
    input wire              pwrite,
    input wire              psel,
    input wire              penable,
    output wire [31:0]      prdata,
    input wire [31:0]       pwdata,

    // GPIOs
    //
    inout [GPIO_WIDTH-1:0]  GPIO
);
    wire [GPIO_WIDTH-1:0]   gpi;
    wire [GPIO_WIDTH-1:0]   gpo;
    wire [GPIO_WIDTH-1:0]   gpen;

    flunky flunky (
        .clk            (clk),
        .resetn         (resetn),

        // APB Interface
        //
        .paddr          (paddr[15:0]),
        .pwrite         (pwrite),
        .psel           (psel),
        .penable        (penable),
        .prdata         (prdata),
        .pwdata         (pwdata),

        // GPIO Pin Control/Status
        //
        .gpi            (gpi),
        .gpo            (gpo),
        .gpen           (gpen)
);

    // GPIO Pins
    //
    generate
        genvar i;
        for (i=0; i < GPIO_WIDTH; i=i+1) begin: u
            assign GPIO[i] = gpen[i] ? gpo[i] : 1'bz;
        end
    endgenerate

endmodule

