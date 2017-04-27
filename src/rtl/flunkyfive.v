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

true_dual_port_ram_single_clock #(
    .DATA_WIDTH(32),
    .ADDR_WIDTH(14)
) ram (
    .clk                (clk),
    .we_a               (pwrite & psel & penable),
    .addr_a             (paddr[15:2]),
    .data_a             (pwdata ^ 32'h5555_5555), // TBD - hack to make sure it REALLY works
    .q_a                (prdata),
    .we_b               ('b0),
    .addr_b             ('b0),
    .data_b             ('b0),
    .q_b                ()
);

endmodule

