////////////////////////////////////////////////////////////////////////////////
//
// File name    : avalon_st_driver.sv
// Project name : 
// Author       : 
// Date Created : 
//
////////////////////////////////////////////////////////////////////////////////
//
// Description:         
//
////////////////////////////////////////////////////////////////////////////////

`ifndef __AVALON_ST_DRIVER
`define __AVALON_ST_DRIVER

include avalon_st_if;
import agent_pack::*;

class avalon_st_driver #(int DATA_WIDTH_IN_BYTES = 4);

	virtual avalon_st_if #(DATA_WIDTH_IN_BYTES) vif;

    /*-------------------------------------------------------------------------------
    -- Constructor.
    -------------------------------------------------------------------------------*/
    function new (input virtual avalon_st_if #(DATA_WIDTH_IN_BYTES) vif, input bit is_slave = 1'b0);
	   this.vif = vif;

        // If the driver is slave start driving the rdy
       if(is_slave) begin
            drive_slave()
       end;
    endfunction

    /*-------------------------------------------------------------------------------
	-- Functions and Tasks.
    -------------------------------------------------------------------------------*/
	task drive_slave();
        bit rdy;

        // forever loop so the rdy value always changes
        forever begin
            @(vif.slave_cb);

            // randomize the rdy 
            std::randomize(rdy) with {
                rdy dist {
                    1'b0 := LOW_RDY_PROBABILITY,
                    1'b1 := HIGH_RDY_PROBABILITY
                };
            };
            vif.slave_cb.rdy <= rdy;
        end
    endtask

    task drive_master(input byte data[$]);
        logic [DATA_WIDTH_IN_BYTES * $bits(byte) - 1 : 0] curr_word;
        bit vld = 1'b0;
        int words_amount = (data.size() + DATA_WIDTH_IN_BYTES - 1) / DATA_WIDTH_IN_BYTES;
        int empty = DATA_WIDTH_IN_BYTES - (data.size() % DATA_WIDTH_IN_BYTES);
        int byte_index = 0;
        int word_num = 0;

        while (word_num < words_amount) begin

            // getting the current word
            curr_word = '0;
            for (int byte_in_word = 0; byte_in_word < DATA_WIDTH_IN_BYTES; byte_in_word++ )  begin
                byte_index = byte_in_word * DATA_WIDTH_IN_BYTES + word_num;
                if (byte_index < data.size()) begin
                    curr_word[byte_in_word*$bits(byte) +: $bits(byte)] = data[byte_index];
                end
            end

            // Changing the signals by the clock
            @(vif.master_cb);

            // Send HIGH sop with first word
            vif.master_cb.sop <= (word_num == 0);

            // Send empty and HIGH eop with last wor
            vif.master_cb.eop   <= (word_num == words_amount);
            vif.master_cb.empty <= (word_num == words_amount) ? empty : 0;

            // Send the current word
             vif.master_cb.data  <= curr_word;

            // Randomize the vld, when its HIGH it will stays HIGH until transaction
            if(!vld) begin
                std::randomize(vld) with {
                    1'b0 := LOW_VLD_PROBABILITY, 
                    1'b1 := HIGH_VLD_PROBABILITY
                }
            end
            vif.master_cb.valid <= vld;

            // Move to next word if there was a transaction
            if (vif.master_cb.rdy && master_cb.valid) begin
                word++;
                vld = 1'b0;
            end
        end
    endtask
endclass

`endif // __AVALON_ST_DRIVER