//////////////////////////////////////////////////////////////////////
// Just tests APB access to M10K RAM
//
`include "timescale.vh"
`include "ff_bfm_defines.vh"

// Test configuration
//
//`define DEBUG_TEST

module test_ram();
    reg [128*8-1:0] status;

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

    $display("Waiting for deassertion of resetn");

    while (testbench.resetn !== 1'b1) begin
        @(posedge testbench.clk);
    end

    $display("Testbench resetn deasserted");

    `FF_NOTE("Quick sanity test first");
    for (i = 0 ; i < 64 ; i = i + 4) begin
        `FF_APB_WRITE(i, i);
    end

    for (i = 0 ; i < 64 ; i = i + 4) begin
        exp32 = i ^ 32'h55555555;
        `FF_APB_READ(i, data32);
        $display("RAM 0x%08h = 0x%08h, expected = 0x%08h", i, data32, exp32);
        if (data32 !== exp32) begin
            `FF_ERROR("Data doesn't match expected");
        end
    end

    `FF_TERMINATE;
end

endmodule
