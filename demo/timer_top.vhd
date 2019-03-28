--------------------------------------------------------------------------------
-- Engineer:        Steve Vandenbussche
-- Module name:     timer_top.vhd
-- Description:     4-digit timer demo.
-- Create date:     Thu Mar 14 2019
--
-- Count up/down between 00:00 and 59:59 at two selectable speeds: 1Hz and 10Hz.
--
-- hardware platform tested:
--  - Lattice iCE40HX-8K breakout board
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

library WORK;
use WORK.config.all;

library SVDB;
use SVDB.sync.all;
use SVDB.utils.all;
use SVDB.timer.all;
use SVDB.display.all;
use SVDB.lattice.all;
use SVDB.cnt_gen.all;

entity timer_top is
    port (
        i_clk : in std_logic;                       -- clock 12MHz
        i_rst : in std_logic;                       -- reset active low
        i_sel : in std_logic;                       -- timebase select
        i_dir : in std_logic;                       -- up/down counting
        o_hsd : out std_logic_vector(3 downto 0);   -- display high side drive
        o_lsd : out std_logic_vector(6 downto 0)    -- display low side drive
    );
end timer_top;

architecture behavioral of timer_top is

    signal s_clk : std_logic;

    -- counter settings for fast timebase
    constant T : integer := (PLL_CLK / (1 sec / TIMEBASE)) - 1;
    constant R : integer := ceil_log2(T);

    -- display settings
    constant MULTIPLEX_TICKS : integer := PLL_CLK / (4 * REFRESH_RATE);
    constant GHOSTING_TICKS  : integer := PLL_CLK / (1 sec / DEAD_TIME);

    signal s_rst_tbf, s_tbf : std_logic;
    signal s_cnt_tbf : std_logic_vector(R-1 downto 0);

    signal s_rst_tbs, s_tbs : std_logic;
    signal s_cnt_tbs : std_logic_vector(3 downto 0);

    signal s_sel, s_tb : std_logic;
    signal s_bcd : std_logic_vector(15 downto 0);

begin

    ----------------------------------------------------------------
    -- 48MHz clock generator
    ----------------------------------------------------------------
    U0: pll_clk48
    port map(i_clk, '1', open, s_clk);

    ----------------------------------------------------------------
    -- fast timebase counter
    ----------------------------------------------------------------
    U1: cnt_sr generic map(N => R)
    port map(s_clk, s_rst_tbf, '1', s_cnt_tbf);

    s_rst_tbf <= i_rst or s_tbf;
    s_tbf <= equ(s_cnt_tbf, to_slv(T, R));

    ----------------------------------------------------------------
    -- slow timebase counter
    ----------------------------------------------------------------
    U2: cnt_sr generic map(N => 4)
    port map(s_clk, s_rst_tbs, s_tbf, s_cnt_tbs);

    s_rst_tbs <= i_rst or s_tbs;
    s_tbs <= equ(s_cnt_tbs, "1001") and s_tbf;

    ----------------------------------------------------------------
    -- 4-digit timer
    ----------------------------------------------------------------
    U3: timer_4d
    port map (
        i_clk => s_clk,
        i_rst => i_rst,
        i_ce  => s_tb,
        i_dir => i_dir,
        o_bcd => s_bcd,
        o_tc  => open,
        o_rc  => open
    );

    -- synchronize input: 'i_sel'
    U4: sync_sig
    port map(i_clk, i_sel, s_sel);

    -- select timebase
    s_tb <= (not s_sel and s_tbs) or (s_sel and s_tbf);

    ----------------------------------------------------------------
    -- display driver
    ----------------------------------------------------------------
    U5: seg4x7
    generic map (
        LOW_SIDE_LEVEL  => '1',
        HIGH_SIDE_LEVEL => '1',
        MULTIPLEX_TICKS => MULTIPLEX_TICKS,
        GHOSTING_TICKS  => GHOSTING_TICKS
    )
    port map (
        i_clk => s_clk,
        i_rst => '0',
        i_ce  => '1',
        i_blk => '0',
        i_bcd => s_bcd,
        o_hsd => o_hsd,
        o_lsd => o_lsd
    );

end;
