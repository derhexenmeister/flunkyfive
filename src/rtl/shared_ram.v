module shared_ram
    #(parameter ADDR_WIDTH=6)
(
    input clk,
    input [31:0] data_a, data_b,
    input [(ADDR_WIDTH-1):0] addr_a, addr_b,
    input [3:0] we_a, we_b,
    output [31:0] q_a, q_b
);
    generate
        genvar i;
        for (i=0; i < 4; i=i+1)
            begin: u
                true_dual_port_ram_single_clock #(
                    .DATA_WIDTH(8),
                    .ADDR_WIDTH(ADDR_WIDTH)
                ) ram (
                    .clk    (clk),
                    .data_a (data_a[(i*8)+:8]),
                    .data_b (data_b[(i*8)+:8]),
                    .addr_a (addr_a),
                    .addr_b (addr_b),
                    .we_a   (we_a[i]),
                    .we_b   (we_b[i]),
                    .q_a    (q_a[(i*8)+:8]),
                    .q_b    (q_b[(i*8)+:8])
                );
            end
    endgenerate

endmodule
