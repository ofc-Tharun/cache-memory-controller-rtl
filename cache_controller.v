// Cache Memory Controller - Direct Mapped Cache
// Verilog HDL - educational RTL implementation
module cache_controller #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 8,
    parameter INDEX_WIDTH = 2
)(
    input  wire                  clk,
    input  wire                  reset,
    input  wire                  read_en,
    input  wire                  write_en,
    input  wire [ADDR_WIDTH-1:0] address,
    input  wire [DATA_WIDTH-1:0] write_data,
    output reg  [DATA_WIDTH-1:0] read_data,
    output reg                   hit,
    output reg                   miss,
    output reg                   ready
);

    localparam NUM_LINES = (1 << INDEX_WIDTH);
    localparam TAG_WIDTH = ADDR_WIDTH - INDEX_WIDTH;

    reg [DATA_WIDTH-1:0] data_mem [0:NUM_LINES-1];
    reg [TAG_WIDTH-1:0]  tag_mem  [0:NUM_LINES-1];
    reg                  valid    [0:NUM_LINES-1];

    wire [INDEX_WIDTH-1:0] index;
    wire [TAG_WIDTH-1:0] tag;

    assign index = address[INDEX_WIDTH-1:0];
    assign tag   = address[ADDR_WIDTH-1:INDEX_WIDTH];

    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            read_data <= {DATA_WIDTH{1'b0}};
            hit       <= 1'b0;
            miss      <= 1'b0;
            ready     <= 1'b1;
            for (i = 0; i < NUM_LINES; i = i + 1) begin
                data_mem[i] <= {DATA_WIDTH{1'b0}};
                tag_mem[i]  <= {TAG_WIDTH{1'b0}};
                valid[i]    <= 1'b0;
            end
        end else begin
            hit   <= 1'b0;
            miss  <= 1'b0;
            ready <= 1'b1;

            if (read_en && write_en) begin
                // Simultaneous read and write is not supported.
                ready <= 1'b0;
            end else if (write_en) begin
                // Write-allocate: store data and tag in selected cache line.
                data_mem[index] <= write_data;
                tag_mem[index]  <= tag;
                valid[index]    <= 1'b1;
                hit             <= valid[index] && (tag_mem[index] == tag);
                miss            <= !(valid[index] && (tag_mem[index] == tag));
            end else if (read_en) begin
                if (valid[index] && (tag_mem[index] == tag)) begin
                    read_data <= data_mem[index];
                    hit       <= 1'b1;
                end else begin
                    // No backing main-memory model is included.
                    read_data <= {DATA_WIDTH{1'b0}};
                    miss      <= 1'b1;
                end
            end
        end
    end
endmodule
