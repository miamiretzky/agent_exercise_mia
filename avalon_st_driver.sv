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

    /*-------------------------------------------------------------------------------
    -- Members.
    -------------------------------------------------------------------------------*/
	virtual avalon_st_if #(DATA_WIDTH_IN_BYTES) vif;

    /*-------------------------------------------------------------------------------
    -- Constructor.
    -------------------------------------------------------------------------------*/
    function new (/* Add arguments to the constructor here*/);
	   // Constructor's logic.
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
                    0 := LOW_RDY_PROBABILITY,
                    1 := HIGH_RDY_PROBABILITY
                };
            };
            vif.slave_cb.rdy <= rdy;
        end
endclass

`endif // __AVALON_ST_DRIVER