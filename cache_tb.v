`timescale 1ns/1ps

module cache_tb;
    reg clk = 0;
    reg reset = 1;
    reg read_en = 0;
    reg write_en = 0;
    reg [7:0] address = 0;
    reg [7:0] write_data = 0;

    wire [7:0] read_data;
    wire hit, miss, ready;

    cache_controller dut (
        .clk(clk),
        .reset(reset),
        .read_en(read_en),
        .write_en(write_en),
        .address(address),
        .write_data(write_data),
        .read_data(read_data),
        .hit(hit),
        .miss(miss),
        .ready(ready)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("cache_tb.vcd");
        $dumpvars(0, cache_tb);

        #12 reset = 0;

        // Write data to address 0x12.
        @(negedge clk);
        address = 8'h12;
        write_data = 8'hA5;
        write_en = 1;

        @(negedge clk);
        write_en = 0;

        // Read same address: expected hit and data A5.
        read_en = 1;
        @(negedge clk);
        $display("Read same address: data=%h hit=%b miss=%b",
                 read_data, hit, miss);
        read_en = 0;

        // Read a different tag with same index: expected miss.
        address = 8'h22;
        read_en = 1;
        @(negedge clk);
        $display("Read different tag: data=%h hit=%b miss=%b",
                 read_data, hit, miss);
        read_en = 0;

        #10;
        $finish;
    end
endmodule
