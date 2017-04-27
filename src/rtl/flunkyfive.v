`include "timescale.vh"

module flunkyfive (
    input               clk,
    input               resetn,

    // APB Interface
    //
    input wire [15:0]   paddr,
    input wire          pwrite,
    input wire          psel,
    input wire          penable,
    output wire [31:0]  prdata,
    input wire [31:0]   pwdata
);

    // -------------------------------
    // PicoRV32 Core
    wire [31:0]         mem_addr;
    wire [31:0]         mem_wdata;
    wire [3:0]          mem_wstrb;

    reg                 mem_ready;
    reg [31:0]          mem_rdata;

    picorv32 #(
        .ENABLE_REGS_DUALPORT(1),
        .COMPRESSED_ISA(1),
        .ENABLE_COUNTERS(0),
        .LATCHED_MEM_RDATA(1),
        .TWO_STAGE_SHIFT(0),
        .TWO_CYCLE_ALU(1),
        .CATCH_MISALIGN(0),
        .CATCH_ILLINSN(0)
    ) cpu (
        .clk        (clk      ),
        .resetn     (resetn   ),
        .mem_valid  (mem_valid),
        .mem_ready  (mem_ready),
        .mem_addr   (mem_addr ),
        .mem_wdata  (mem_wdata),
        .mem_wstrb  (mem_wstrb),
        .mem_rdata  (mem_rdata)
    );

    shared_ram #(
        .ADDR_WIDTH(14)
    ) ram (
        .clk        (clk),
        .we_a       ({4{pwrite & psel & penable}}),
        .addr_a     (paddr[15:2]),
        .data_a     (pwdata ^ 32'h5555_5555), // TBD - hack to make sure it REALLY works
        .q_a        (prdata),
        .we_b       (4'b0),
        .addr_b     (14'b0),
        .data_b     (32'b0),
        .q_b        ()
);

endmodule

