////////////////////////////////////////////////////////////////////////////////
//
// File name    : agent_pack.sv
// Project name : 
// Author       : 
// Date Created : 
//
////////////////////////////////////////////////////////////////////////////////
//
// Description:  pack for the agent   
//
////////////////////////////////////////////////////////////////////////////////


package agent_pack;

    // parameters for driver slave
    localparam int unsigned LOW_RDY_PROBABILITY = 20;
    localparam int unsigned HIGH_RDY_PROBABILITY = 80;

    // parameters for driver master
    localparam int unsigned LOW_VLD_PROBABILITY = 50;
    localparam int unsigned HIGH_VLD_PROBABILITY = 50;


endpackage : agent_pack
