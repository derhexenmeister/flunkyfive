module shared_ram
    #(parameter ADDR_WIDTH=6)
(
    input                       clk,
    input                       resetn,
    // ARM HPS port
    input [31:0]                data_a,
    input [(ADDR_WIDTH-1):0]    addr_a,
    input [3:0]                 we_a,
    output [31:0]               q_a, 
    // RISC V port
    input                       mem_valid_b,
    output reg                  mem_ready_b,
    input [31:0]                data_b,
    input [(ADDR_WIDTH-1):0]    addr_b,
    input [3:0]                 we_b,
    output [31:0]               q_b
);
    // Handle RISC V bus structure
    //
    wire [31:0] q_b_internal;

    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
                mem_ready_b <= 1'b0;
        end
        else begin
                mem_ready_b <= mem_valid_b;
        end
    end

    assign q_b = mem_valid_b ? q_b_internal : 32'h0;

    generate
        genvar i;
        for (i=0; i < 4; i=i+1) begin: u
            true_dual_port_ram_single_clock #(
                .DATA_WIDTH(8),
                .ADDR_WIDTH(ADDR_WIDTH)
            ) ram (
                .clk    (clk),
                // ARM HPS port
                .data_a (data_a[(i*8)+:8]),
                .addr_a (addr_a),
                .we_a   (we_a[i]),
                .q_a    (q_a[(i*8)+:8]),
                // RISC V port
                .data_b (data_b[(i*8)+:8]),
                .addr_b (addr_b),
                .we_b   (we_b[i] & mem_valid_b),
                .q_b    (q_b_internal[(i*8)+:8])
            );
        end
    endgenerate

endmodule
