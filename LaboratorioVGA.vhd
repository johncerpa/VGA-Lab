library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY LaboratorioVGA IS

	PORT (
		CLOCK_50HZ: IN STD_LOGIC;
		VGA_CLOCK: OUT STD_LOGIC;
		VGA_HS, VGA_VS: OUT STD_LOGIC;
		VGA_R, VGA_G, VGA_B: OUT STD_LOGIC_VECTOR(7 downto 0);
		-----------------------------------------------
		ps2_data: IN STD_LOGIC;
		ps2_clock: IN STD_LOGIC;

		leds : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
		disp1: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		disp2: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);

		RST: IN STD_LOGIC
	);

END LaboratorioVGA;

ARCHITECTURE MAIN OF LaboratorioVGA IS

	SIGNAL ADDR: STD_LOGIC_VECTOR(6 DOWNTO 0);
	
	SIGNAL VGACLK, RESET: STD_LOGIC := '0';
	---------------------------------
	COMPONENT PLL IS
		PORT(
			CLK_IN_CLK: IN STD_LOGIC := 'X';
			RESET_RESET: IN STD_LOGIC := 'X';
			CLK_OUT_CLK: OUT STD_LOGIC
		);
	END COMPONENT PLL;
	
	----------------------------------
	
	COMPONENT SYNC IS
		PORT (
			CLK: IN STD_LOGIC;
			HSYNC, VSYNC: OUT STD_LOGIC;
			R, G, B: OUT STD_LOGIC_VECTOR(7 downto 0);
			DATA: IN STD_LOGIC_VECTOR(6 DOWNTO 0)
		);
	END COMPONENT SYNC;

	COMPONENT PS2 IS
		PORT(
			ps2_data:   in std_logic;
			ps2_clock: in  std_logic;
			reset: in std_logic;					
			key: OUT std_logic_vector(10 downto 0);
			disp1: OUT std_logic_vector(6 downto 0);
			disp2: OUT std_logic_vector(6 downto 0);
			addr: OUT std_logic_vector(6 downto 0)
		);
	END COMPONENT PS2;
	
BEGIN

	VGA_CLOCK <= VGACLK;
	C2: PLL PORT MAP(CLOCK_50HZ, RESET, VGACLK);
	C1: SYNC PORT MAP (VGACLK, VGA_HS, VGA_VS, VGA_R, VGA_G, VGA_B, ADDR);
	C3: PS2 PORT MAP(ps2_data, ps2_clock, RST, leds, disp1, disp2, ADDR);
	
END MAIN;