// -----------------------------------------------------------------------------
// File        : avalon_st_agent_tb.sv
// Author      : 
// Description : Top TB module for Agent Exercise.
// -----------------------------------------------------------------------------

`include "avalon_st_agent_pack.sv"
import avalon_st_agent_pack::*;
`include "avalon_st_if.sv"
`include "avalon_st_driver.sv"


module tb ();

    //////////////////////////////////////////////////////////////////////////////
    // Parameters.
    //////////////////////////////////////////////////////////////////////////////
    // Data width.
    localparam int unsigned DATA_WIDTH_IN_BYTES = 4;

    //////////////////////////////////////////////////////////////////////////////
    // Declarations.
    //////////////////////////////////////////////////////////////////////////////
    // Clock and reset.
    bit clk;
    bit rst_n;

    // Interface declaration.
    avalon_st_if#(.DATA_WIDTH_IN_BYTES(DATA_WIDTH_IN_BYTES)) vif (.clk(clk));
    avalon_st_driver slave_driver;
    avalon_st_driver master_driver;

    // Data to send 
    byte data[$];

    //////////////////////////////////////////////////////////////////////////////
    // General processes.
    //////////////////////////////////////////////////////////////////////////////
    // Generate clock.
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    // Initialize reset signal.
    initial begin
        rst_n = 0;
        #20;
        rst_n = 1;
    end

    // Timeout.
    initial begin
        #(10000) $finish;
    end

    // Waves dump.
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
    end

    //////////////////////////////////////////////////////////////////////////////
    // TestBench Logic
    //////////////////////////////////////////////////////////////////////////////
    // Test logic.
    initial begin

        // Construct the master and the slave
    	master_driver = new(vif);
        slave_driver  = new(vif, 1'b01;
    	
        // Give the master random data to send
        randomize_data(data);
        master_driver.drive_master(data);
    end

    task randomize_data(output byte data[$]);
        int unsigned data_length_in_bytes;
        byte random_byte;

        // Randomize the length of the data
        std::randomize(data_length_in_bytes) with{
            data_length_in_bytes inside {[0:1000]};
        };
        
        // Randomize each byte of the data
        for (int i = 0; i < data_length_in_bytes; i++ )  begin
            std::randomize(random_byte);
            data.push_front(random_byte);
        end
    endtask

endmodule