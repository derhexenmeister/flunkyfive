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
    //reg [31:0]        mem_rdata;
    wire [31:0]          mem_rdata;

    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            mem_ready <= 1'b0;
        end
        else begin
            mem_ready <= mem_valid;
        end
    end

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
        // ARM HPS
        .we_a       ({4{pwrite & psel & penable}}),
        .addr_a     (paddr[15:2]),
        .data_a     (pwdata),
        .q_a        (prdata),
        // RISC V
        .we_b       (mem_wstrb),
        .addr_b     (mem_addr[15:2]),
        .data_b     (mem_wdata),
        .q_b        (mem_rdata)
);

endmodule

