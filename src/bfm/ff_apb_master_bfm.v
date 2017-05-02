`include "timescale.vh"

module ff_apb_master_bfm(
    input wire        presetn,
    input wire        pclk,
    output reg [19:0] paddr,
    output reg        pwrite,
    output reg        psel,
    output reg        penable,
    input wire [31:0] prdata,
    output reg [31:0] pwdata
);

localparam APB_BAD_ADDR = 24'hbad;
localparam APB_BAD_DATA = 32'hbad;

// This status is for viewing in waveforms
//
reg [128*8-1:0] status;

initial begin
    status = "apb_idle";

    pwrite  = 1'b0;
    psel    = 1'b0;
    penable = 1'b0;
    paddr   = APB_BAD_ADDR;
    pwdata  = APB_BAD_DATA;
end

task apb_read;
    input  [31:0]   address;
    output [31:0]   data;
begin
    @(posedge pclk);
    `D;
    status = "apb_read";
    pwrite  = 1'b0;
    psel    = 1'b1;
    penable = 1'b0;
    paddr   = address[19:0];
    @(posedge pclk);
    `D;
    penable = 1'b1;
    @(posedge pclk);
    data    = prdata;
    `D;
    status  = "apb_idle";
    pwrite  = 1'b0;
    psel    = 1'b0;
    penable = 1'b0;
    paddr   = APB_BAD_ADDR;
end
endtask

task apb_write;
    input [31:0]    address;
    input [31:0]    data;
begin
    @(posedge pclk);
    `D;
    status = "apb_write";
    pwrite  = 1'b1;
    psel    = 1'b1;
    penable = 1'b0;
    paddr   = address[19:0];
    pwdata  = data;
    @(posedge pclk);
    `D;
    penable = 1'b1;
    @(posedge pclk);
    `D;
    status = "apb_idle";
    pwrite  = 1'b0;
    psel    = 1'b0;
    penable = 1'b0;
    paddr   = APB_BAD_ADDR;
    pwdata  = APB_BAD_DATA;
end
endtask

endmodule
