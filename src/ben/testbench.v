`include "timescale.vh"

module testbench();
    reg         clk;
    reg         resetn;

    wire [19:0] paddr;
    wire        psel;
    wire [31:0] prdata;
    wire        pwrite;
    wire [31:0] pwdata;
    wire        penable;

//////////////////////////////////////////////////////////////////////
// Clock Generation
//
initial begin
    clk = 1'b0;
    forever #50 clk = ~clk;
end

//////////////////////////////////////////////////////////////////////
// Reset Generation
//
initial begin
    resetn = 1'b0;
    @(posedge clk);
    @(posedge clk);
    `D;
    resetn = 1'b1;
end

//////////////////////////////////////////////////////////////////////
// Instantiate helper functions/tasks so we have a defined path to
// them
//
ff_log ff_log();
ff_utilities ff_utilities();

`ifdef DPI_SUPPORTED
`endif // DPI_SUPPORTED

//////////////////////////////////////////////////////////////////////
// Waveform dump
//
initial  begin
    $dumpfile ("flunkyfive.vcd");
    $dumpvars;
end

//////////////////////////////////////////////////////////////////////
// Instantiate APB master to control DUT
//
ff_apb_master_bfm ff_apb_master_bfm(
    .presetn    (resetn),
    .pclk       (clk),
    .paddr      (paddr),
    .pwrite     (pwrite),
    .psel       (psel),
    .penable    (penable),
    .prdata     (prdata),
    .pwdata     (pwdata)
);

//////////////////////////////////////////////////////////////////////
// Instantiate DUT
//
tri1 [3:0]          GPIO;

flunkyfive #(
    .GPIO_WIDTH(4)
) flunkyfive (
    .clk            (clk),
    .resetn         (resetn),

    // APB Interface
    //
    .paddr          (paddr),
    .pwrite         (pwrite),
    .psel           (psel),
    .penable        (penable),
    .prdata         (prdata),
    .pwdata         (pwdata),

    .GPIO           (GPIO)
);

endmodule
