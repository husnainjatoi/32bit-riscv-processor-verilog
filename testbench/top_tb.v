`timescale 1ns / 1ps

module top_tb;

    reg clk;
    reg rst;

    wire [31:0] alu_result_out;
    wire        MemRW;
    wire        reg_write_en;
    wire [31:0] data_mem_out;

    wire [31:0] curr_pc;
    wire [31:0] instruction;
    wire [31:0] write_back_data;
    wire [4:0]  rs1;
    wire [4:0]  rs2;
    wire [4:0]  rd;
    wire [31:0] data1;
    wire [31:0] data2;

    assign curr_pc         = dut.pc;
    assign instruction     = dut.instruction;
    assign write_back_data = dut.write_data;
    assign rs1             = dut.rs1;
    assign rs2             = dut.rs2;
    assign rd              = dut.rd;
    assign data1           = dut.reg_data1;
    assign data2           = dut.reg_data2;

    top dut (
        .clk            (clk),
        .reset          (rst),
        .alu_result_out (alu_result_out),
        .MemRW          (MemRW),
        .reg_write_en   (reg_write_en),
        .data_mem_out   (data_mem_out)
    );

    always #5 clk = ~clk;

    initial begin
        $monitor("clk=%b | rst=%b | curr_pc=0x%08h | instruction=0x%08h | alu_result=0x%08h | write_back_data=0x%08h | rs1=%0d | rs2=%0d | rd=%0d | data1=0x%08h | data2=0x%08h",
            clk,
            rst,
            curr_pc,
            instruction,
            alu_result_out,
            write_back_data,
            rs1,
            rs2,
            rd,
            data1,
            data2
        );
    end

    initial begin
        clk = 0;
        rst = 1;
        #10;
        rst = 0;
    end

    initial begin
        #400;
        $writememh("reg_out.mem",  dut.rf.reg_file);
        $writememh("data_out.mem", dut.dmem.memory);
        $finish;
    end

endmodule
