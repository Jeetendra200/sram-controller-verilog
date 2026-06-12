`timescale 1ns/1ps

module tb_sram_controller;

    reg clk;
    reg reset_n;
    reg [11:0] addr;
    reg [7:0] data_in;
    reg [1:0] command;
    reg [7:0] pec_data;
    reg [1:0] pec_command;
    reg [7:0] repeat_count;

    wire [7:0] data_out;
    wire busy;
    wire internal_target_abort;
    wire data_error;
    wire command_error;

    // DUT Instantiation
    sram_controller dut (
        .clk(clk),
        .reset_n(reset_n),
        .addr(addr),
        .data_in(data_in),
        .command(command),
        .pec_data(pec_data),
        .pec_command(pec_command),
        .repeat_count(repeat_count),
        .data_out(data_out),
        .busy(busy),
        .internal_target_abort(internal_target_abort),
        .data_error(data_error),
        .command_error(command_error)
    );

    // Clock Generation (10 ns period)
    always #5 clk = ~clk;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_sram_controller);

        $monitor("T=%0t CMD=%b ADDR=%h DIN=%h DOUT=%h BUSY=%b ABORT=%b DERR=%b CERR=%b",
                 $time, command, addr, data_in, data_out,
                 busy, internal_target_abort, data_error, command_error);

        // Initialize signals
        clk = 0;
        reset_n = 0;
        addr = 0;
        data_in = 0;
        command = 0;
        pec_data = 0;
        pec_command = 0;
        repeat_count = 0;

        //--------------------------------------------------
        // Reset
        //--------------------------------------------------
        #20;
        reset_n = 1;

        //--------------------------------------------------
        // WRITE Operation
        //--------------------------------------------------
        #10;
        command     = 2'b00;
        addr        = 12'h001;
        data_in     = 8'hAA;
        pec_data    = 8'h56;      // (~AA)+1
        pec_command = 2'b00;

        #20;

        //--------------------------------------------------
        // READ Operation
        //--------------------------------------------------
        command     = 2'b01;
        addr        = 12'h001;
        data_in     = 8'hAA;
        pec_data    = 8'h56;
        pec_command = 2'b01;

        #20;

        //--------------------------------------------------
        // CLEAR Operation
        //--------------------------------------------------
        command     = 2'b10;
        addr        = 12'h001;
        data_in     = 8'h00;
        pec_data    = 8'h00;
        pec_command = 2'b10;

        #20;

        //--------------------------------------------------
        // REPEAT COPY Operation
        //--------------------------------------------------
        command      = 2'b11;
        addr         = 12'h002;
        data_in      = 8'hAD;
        repeat_count = 8'd4;
        pec_data     = 8'h53;      // (~AD)+1
        pec_command  = 2'b11;

        #20;

        //--------------------------------------------------
        // Invalid Command Test (Z state)
        //--------------------------------------------------
        command      = 2'bzz;
        addr         = 12'h003;
        data_in      = 8'hAA;
        pec_data     = 8'h56;
        pec_command  = 2'b00;

        #20;

        //--------------------------------------------------
        // Invalid Data Test (X state)
        //--------------------------------------------------
        command      = 2'b01;
        addr         = 12'h003;
        data_in      = 8'hxx;
        pec_data     = 8'h00;
        pec_command  = 2'b01;

        #20;

        //--------------------------------------------------
        // CLEAR Another Address
        //--------------------------------------------------
        command      = 2'b10;
        addr         = 12'h003;
        data_in      = 8'h00;
        pec_data     = 8'h00;
        pec_command  = 2'b10;

        #20;

        //--------------------------------------------------
        // REPEAT COPY Again
        //--------------------------------------------------
        command      = 2'b11;
        addr         = 12'h004;
        data_in      = 8'hBD;
        repeat_count = 8'd6;
        pec_data     = 8'h43;      // (~BD)+1
        pec_command  = 2'b11;

        #40;

        //--------------------------------------------------
        // End Simulation
        //--------------------------------------------------
        $display("\nSimulation Completed Successfully\n");
        $finish;
    end

endmodule