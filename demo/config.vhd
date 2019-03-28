--------------------------------------------------------------------------------
-- Engineer:        Steve Vandenbussche
-- Module name:     config.vhd
-- Create date:     Thu Mar 14 2019
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

library SVDB;
use SVDB.lattice.all;

package config is

    -- board clock
    constant BRD_CLK : positive := HX8K_DEV_CLK;

    -- pll clock in Hz
    constant PLL_CLK : positive := 48000000;

    -- fase timebase in ms
    constant TIMEBASE : time := 100 ms;

    -- display refresh rate in Hz
    constant REFRESH_RATE : positive := 100;

    -- display dead time in us
    constant DEAD_TIME : time := 100 us;

end package;
