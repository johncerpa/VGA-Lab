	component pll is
		port (
			clk_in_clk  : in  std_logic := 'X'; -- clk
			reset_reset : in  std_logic := 'X'; -- reset
			clk_out_clk : out std_logic         -- clk
		);
	end component pll;

	u0 : component pll
		port map (
			clk_in_clk  => CONNECTED_TO_clk_in_clk,  --  clk_in.clk
			reset_reset => CONNECTED_TO_reset_reset, --   reset.reset
			clk_out_clk => CONNECTED_TO_clk_out_clk  -- clk_out.clk
		);

