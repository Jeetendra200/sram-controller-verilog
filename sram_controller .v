module sram_controller (
    input clk,
    input reset_n,
    input [11:0] addr,
    input [7:0] data_in,
    input [1:0] command,
    input [7:0] pec_data,
    input [1:0] pec_command,
    input [7:0] repeat_count,

    output reg [7:0] data_out,
    output reg busy,
    output reg internal_target_abort,
    output reg data_error,
    output reg command_error
);

integer i;

reg [7:0] mem [0:4095];
reg [7:0] calculated_pec;
reg [1:0] calculated_command;

always @(posedge clk) begin

    // Active-low reset
    if (!reset_n) begin
        busy                  <= 1'b0;
        data_error            <= 1'b0;
        command_error         <= 1'b0;
        internal_target_abort <= 1'b0;
        data_out              <= 8'd0;
    end
    else begin

        busy                  <= 1'b1;
        data_error            <= 1'b0;
        command_error         <= 1'b0;
        internal_target_abort <= 1'b0;

        // Check for X/Z inputs
        if ((^command === 1'bx) || (^data_in === 1'bx))
            internal_target_abort <= 1'b1;

        case (command)

            // WRITE
            2'b00: begin
                $display("Time=%0t Command=WRITE", $time);

                mem[addr] <= data_in;

                $display("Writing Data=%0h to Address=%0h",
                         data_in, addr);

                calculated_pec     = (~data_in) + 1;
                calculated_command = 2'b00;

                if (calculated_pec != pec_data)
                    data_error <= 1'b1;

                if (calculated_command != pec_command)
                    command_error <= 1'b1;
            end

            // READ
            2'b01: begin
                $display("Time=%0t Command=READ", $time);

                data_out <= mem[addr];

                $display("Reading Data=%0h from Address=%0h",
                         mem[addr], addr);

                calculated_pec     = (~mem[addr]) + 1;
                calculated_command = 2'b01;

                if (calculated_pec != pec_data)
                    data_error <= 1'b1;

                if (calculated_command != pec_command)
                    command_error <= 1'b1;
            end

            // CLEAR
            2'b10: begin
                $display("Time=%0t Command=CLEAR", $time);

                mem[addr]  <= 8'd0;
                data_out   <= 8'd0;

                $display("Cleared Address=%0h", addr);

                calculated_pec     = (~8'd0) + 1;
                calculated_command = 2'b10;

                if (calculated_pec != pec_data)
                    data_error <= 1'b1;

                if (calculated_command != pec_command)
                    command_error <= 1'b1;
            end

            // REPEAT COPY
            2'b11: begin
                $display("Time=%0t Command=REPEAT COPY", $time);
                $display("Writing %0d times starting from Address=%0h",
                         repeat_count, addr);

                for (i = 0; i < repeat_count; i = i + 1) begin
                    mem[addr + i] <= data_in;

                    $display(
                        "Time=%0t Repeat Copy: Data=%0h Address=%0h",
                        $time, data_in, addr + i
                    );
                end

                calculated_pec     = (~data_in) + 1;
                calculated_command = 2'b11;

                if (calculated_pec != pec_data)
                    data_error <= 1'b1;

                if (calculated_command != pec_command)
                    command_error <= 1'b1;
            end

            default: begin
                internal_target_abort <= 1'b1;
            end

        endcase
    end
end

endmodule