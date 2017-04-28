module gpio
    #(parameter DATA_WIDTH=4)
(
    input                       clk,
    input                       resetn,
    input                       mem_valid,
    output reg                  mem_ready,
    input [31:0]                data,
    input [31:0]                addr,
    input                       we,
    output [31:0]               q,
    inout [DATA_WIDTH-1:0]      gpio
);
    reg [DATA_WIDTH-1:0]        gpen;
    reg [DATA_WIDTH-1:0]        gpo;
    reg [31:0]                  internal_q;

    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
                mem_ready <= 1'b0;
                gpen      <= 'h0;
                gpo       <= 'h0;
        end
        else begin
                mem_ready <= mem_valid;
                if (we & (addr[3:2] == 2'b00)) begin
                    gpen[DATA_WIDTH-1:0] = data[DATA_WIDTH-1:0];
                end
                if (we & (addr[3:2] == 2'b01)) begin
                    gpo[DATA_WIDTH-1:0] = data[DATA_WIDTH-1:0];
                end
        end
    end

    always @* begin
        case (addr[3:2])
            2'b00: internal_q = gpen;
            2'b01: internal_q = gpo;
            2'b10: internal_q = gpio;
            default: internal_q = gpio;
        endcase
    end

    assign q = mem_valid ? internal_q : 32'h0;
endmodule
