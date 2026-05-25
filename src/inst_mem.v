module inst_mem (
    input  [31:0] addr,
    output [31:0] inst
);

    // instruction memory of 2 kb
    reg [31:0] memory [0:255];

    // word aligned access (ignore lower 2 bits)
    assign inst = memory[addr[31:2]];

    initial begin
        $readmemh("instructions.mem", memory);
    end

endmodule