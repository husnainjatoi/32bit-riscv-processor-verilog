module imm_gen (
    input  [31:0] instruction,
    output reg [31:0] imm_out
);

    wire [6:0] opcode;
    assign opcode = instruction[6:0];

    always @(*) begin
        case (opcode)
            7'b1101111: begin // j type
                imm_out = {{12{instruction[31]}},       // sign extension
                           instruction[19:12],          // imm[19:12]
                           instruction[20],             // imm[11]
                           instruction[30:21],          // imm[10:1]
                           1'b0};                       // imm[0] = 0
            end

            7'b1100011: begin // b type
                imm_out = {{19{instruction[31]}},       // sign extension
                           instruction[31],             // imm[12]
                           instruction[7],              // imm[11]
                           instruction[30:25],          // imm[10:5]
                           instruction[11:8],           // imm[4:1]
                           1'b0};                       // imm[0] = 0
            end
            
            7'b0100011: begin // s type
                imm_out = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            end
            
            7'b0110111, // u type
            7'b0010111: begin // auipc
                imm_out = {instruction[31:12], 12'b0};
            end

            7'b1100111, // jalr (I type)
            7'b0000011, // load (I type)
            7'b0010011: begin // I type (addi, andi, etc.)
                imm_out = {{20{instruction[31]}}, instruction[31:20]};
            end

            default: imm_out = 32'd0;
        endcase
    end

endmodule