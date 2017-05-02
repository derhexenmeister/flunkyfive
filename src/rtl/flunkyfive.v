`include "timescale.vh"

module flunkyfive #(parameter GPIO_WIDTH=4) (
    input                   clk,
    input                   resetn,

    // APB Interface
    //
    input wire [19:0]       paddr,
    input wire              pwrite,
    input wire              psel,
    input wire              penable,
    output wire [31:0]      prdata,
    input wire [31:0]       pwdata,

    // GPIOs
    //
    inout [GPIO_WIDTH-1:0]  GPIO
);

    ////////////////////
    // Control register
    //
    reg                     flunky_control_resetn;

    ////////////////////
    // GPIOs
    //
    wire [GPIO_WIDTH-1:0]   gpi;
    wire [GPIO_WIDTH-1:0]   gpo;
    wire [GPIO_WIDTH-1:0]   gpen;

    ////////////////////
    // Decode APB bus addresses
    //
    wire [31:0]             prdata_ram;
    wire [31:0]             prdata_csrs = {31'h0, flunky_control_resetn};
    wire                    psel_ram;
    wire                    psel_csrs;

    assign psel_ram = (paddr[19:16] == 4'h0) & psel;
    assign psel_csrs = (paddr[19:16] == 4'h1) & psel;
    assign prdata = (psel_csrs) ? prdata_csrs : prdata_ram;

    ////////////////////
    // One "flunky" RISC V core
    //
    flunky flunky (
        .clk            (clk),
        .resetn         (flunky_control_resetn),

        // APB Interface
        //
        .paddr          (paddr[15:0]),
        .pwrite         (pwrite),
        .psel           (psel),
        .penable        (penable),
        .prdata         (prdata_ram),
        .pwdata         (pwdata),

        // GPIO Pin Control/Status
        //
        .gpi            (gpi),
        .gpo            (gpo),
        .gpen           (gpen)
);

    ////////////////////
    // GPIO Pins
    //
    assign gpi = GPIO;

    generate
        genvar i;
        for (i=0; i < GPIO_WIDTH; i=i+1) begin: u
            assign GPIO[i] = gpen[i] ? gpo[i] : 1'bz;
        end
    endgenerate

    ////////////////////
    // Control register
    //
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            flunky_control_resetn <= 1'b0;
        end
        else if (psel_csrs && penable) begin
            flunky_control_resetn <= pwdata[0];
        end
    end

endmodule

