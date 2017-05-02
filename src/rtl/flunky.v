// A single RISC V "flunky" (like a minion)
//
`include "timescale.vh"

module flunky #(parameter GPIO_WIDTH=4) (
    input                           clk,
    input                           resetn,

    // APB Interface
    //
    input wire [15:0]               paddr,
    input wire                      pwrite,
    input wire                      psel,
    input wire                      penable,
    output wire [31:0]              prdata,
    input wire [31:0]               pwdata,

    // GPIO Interface
    //
    input wire [GPIO_WIDTH-1:0]     gpi,
    output wire [GPIO_WIDTH-1:0]    gpo,
    output wire [GPIO_WIDTH-1:0]    gpen
);

    // -------------------------------
    // PicoRV32 Core
    wire [31:0]         mem_addr;
    wire [31:0]         mem_wdata;
    wire [3:0]          mem_wstrb;

    wire                mem_ready;
    wire [31:0]         mem_rdata;

    // -------------------------------
    // Bus structure
    wire                mem_valid_sram = (mem_addr[19:16] != 4'h1) & mem_valid; // anything but gpio (prevent hangup)
    wire                mem_valid_gpio = (mem_addr[19:16] == 4'h1) & mem_valid;

    wire                mem_ready_sram;
    wire                mem_ready_gpio;

    assign              mem_ready = mem_ready_sram | mem_ready_gpio;

    wire [31:0]         mem_rdata_sram;
    wire [31:0]         mem_rdata_gpio = 32'h0; // TBD

    assign              mem_rdata = mem_rdata_sram | mem_rdata_gpio;

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

    // 64 kbytes of dual-port RAM
    //
    shared_ram #(
        .ADDR_WIDTH(14)
    ) ram (
        .clk            (clk),
        .resetn         (resetn),
        // ARM HPS
        .we_a           ({4{pwrite & psel & penable}}),
        .addr_a         (paddr[15:2]),
        .data_a         (pwdata),
        .q_a            (prdata),
        // RISC V
        .mem_valid_b    (mem_valid_sram),
        .mem_ready_b    (mem_ready_sram),
        .we_b           (mem_wstrb),
        .addr_b         (mem_addr[15:2]),
        .data_b         (mem_wdata),
        .q_b            (mem_rdata_sram)
    );

    gpio #(
        .GPIO_WIDTH(GPIO_WIDTH)
    ) gpio (
        .clk            (clk),
        .resetn         (resetn),

        // Memory Bus
        //
        .mem_valid      (mem_valid_gpio),
        .mem_ready      (mem_ready_gpio),
        .data           (mem_wdata),
        .addr           (mem_addr),
        .we             (|mem_wstrb),
        .q              (mem_rdata_gpio),

        // GPIO Pin Control/Status
        //
        .gpi            (gpi),
        .gpo            (gpo),
        .gpen           (gpen)
    );

endmodule

