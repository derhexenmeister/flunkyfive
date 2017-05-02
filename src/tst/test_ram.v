//////////////////////////////////////////////////////////////////////
// Just tests APB access to M10K RAM
//
`include "timescale.vh"
`include "ff_bfm_defines.vh"

// Test configuration
//
//`define DEBUG_TEST

module test_ram();
    localparam ADDR_WIDTH = 14;

    reg [128*8-1:0] status;
    reg [31:0] ram[0:2**ADDR_WIDTH-1];

//////////////////////////////////////////////////////////////////////
// Helper tasks
//

//////////////////////////////////////////////////////////////////////
// Test starts here
//
reg [31:0]  global_seed;
reg [31:0]  data32;
reg [31:0]  exp32;
integer     i;

initial begin
    // For random number generation (want to be able to reproduce cases easily,
    // especially failing cases)
    //
    global_seed = 32'd1;

    status = "idle";

    // Read firmware into local RAM
    //
    $readmemh("../../../src/sw/riscv/firmware.hex", ram, 0, 2**ADDR_WIDTH-1);
    if (ram[0] === 32'hx) begin
        `FF_FATAL("Unable to open firmware file");
    end

    /////

    $display("Waiting for deassertion of resetn");

    while (testbench.resetn !== 1'b1) begin
        @(posedge testbench.clk);
    end

    $display("Testbench resetn deasserted");

    /////

    `FF_NOTE("Quick sanity test first");
    for (i = 0 ; i < 64 ; i = i + 4) begin
        `FF_APB_WRITE(i, i);
    end

    for (i = 0 ; i < 64 ; i = i + 4) begin
        exp32 = i;
        `FF_APB_READ(i, data32);
        if (data32 !== exp32) begin
            $display("RAM 0x%08h = 0x%08h, expected = 0x%08h", i, data32, exp32);
            `FF_ERROR("Data doesn't match expected");
        end
    end

    /////

    `FF_NOTE("Load RISC V code");

    for (i = 0 ; i < 2**ADDR_WIDTH ; i = i + 4) begin
        `FF_APB_WRITE(i, ram[i>>2]);
    end

    `FF_NOTE("Done loading RISC V code");

    `FF_APB_WRITE(24'h1_0000, 32'h1);

    #(`FF_MILLISECOND * 2);

    `FF_TERMINATE;
end

endmodule
