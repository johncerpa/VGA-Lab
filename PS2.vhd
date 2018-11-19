library ieee ;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

-----------------------------------------------------

ENTITY PS2 IS
	PORT(
		ps2_data:   in std_logic; 
		ps2_clock: in  std_logic; 	
		reset : in std_logic;						
		key : out std_logic_vector(10 downto 0); 
		disp1: out std_logic_vector(6 downto 0);
		disp2: out std_logic_vector(6 downto 0);	
		addr: out std_logic_vector(6 downto 0)
	);
END PS2;

-----------------------------------------------------

ARCHITECTURE main OF PS2 IS

	SIGNAL i : INTEGER := 0;
	SIGNAL code : STD_LOGIC_VECTOR(10 DOWNTO 0);
	SIGNAL sw : INTEGER := 0;
	
	FUNCTION num2addr(num: STD_LOGIC_VECTOR(7 DOWNTO 0))
		RETURN STD_LOGIC_VECTOR is
		VARIABLE ascii : STD_LOGIC_VECTOR(7 DOWNTO 0);
		BEGIN
			CASE num IS
				WHEN X"1C"  => ascii := X"41";--A
				WHEN X"32"  => ascii := X"42";--B
				WHEN X"21"  => ascii := X"43";--C
				WHEN X"23"  => ascii := X"44";--D
				WHEN X"24"  => ascii := X"45";--E
				WHEN X"2B"  => ascii := X"46";--F
				WHEN X"34"  => ascii := X"47";--G
				WHEN X"33"  => ascii := X"48";--H
				WHEN X"43"  => ascii := X"49";--I
				WHEN X"3B"  => ascii := X"4A";--J
				WHEN X"42"  => ascii := X"4B";--K
				WHEN X"4B"  => ascii := X"4C";--L
				WHEN X"3A"  => ascii := X"4D";--M
				WHEN X"31"  => ascii := X"4E";--N
				WHEN X"44"  => ascii := X"4F";--O
				WHEN X"4D"  => ascii := X"50";--P
				WHEN X"15"  => ascii := X"51";--Q
				WHEN X"2D"  => ascii := X"52";--R
				WHEN X"1B"  => ascii := X"53";--S
				WHEN X"2C"  => ascii := X"54";--T
				WHEN X"3C"  => ascii := X"55";--U
				WHEN X"2A"  => ascii := X"56";--V
				WHEN X"1D"  => ascii := X"57";--W
				WHEN X"22"  => ascii := X"58";--Y
				WHEN X"35"  => ascii := X"59";--X
				WHEN X"1A"  => ascii := X"5A";--Z
				WHEN X"45"  => ascii := X"30";--0
				WHEN X"16"  => ascii := X"31";--1
				WHEN X"1E"  => ascii := X"32";--2
				WHEN X"26"  => ascii := X"33";--3
				WHEN X"25"  => ascii := X"34";--4
				WHEN X"2E"  => ascii := X"35";--5
				WHEN X"36"  => ascii := X"36";--6
				WHEN X"3D"  => ascii := X"37";--7
				WHEN X"3E"  => ascii := X"38";--8
				WHEN X"46"  => ascii := X"39";--9	
				WHEN X"29"  => ascii := X"00";--Space
				WHEN OTHERS => ascii := X"01";-- null
			END CASE;
		RETURN ascii(6 DOWNTO 0);
	END num2addr;
	
	
	 FUNCTION num2disp(cs : std_logic_vector(3 downto 0)) 
	 	RETURN std_logic_vector is
		VARIABLE disp : std_logic_vector(6 downto 0);
		BEGIN
			CASE cs IS
				WHEN X"0" => disp := "1000000"; 	--0	
				WHEN X"1" => disp := "1111001"; 	--1
				WHEN X"2" => disp := "0100100";	--2
				WHEN X"3" => disp := "0110000";	--3				
				WHEN X"4" => disp := "0011001";	--4			
				WHEN X"5" => disp := "0010010";	--5				
				WHEN X"6" => disp := "0000010";  --6				
				WHEN X"7" => disp := "1111000";	--7		
				WHEN X"8" => disp := "0000000";	--8			
				WHEN X"9" => disp := "0010000";	--9
				WHEN X"A" => disp := "0001000";	--A			
				WHEN X"B" => disp := "0000011";	--B
				WHEN X"C" => disp := "1000110";	--C
				WHEN X"D" => disp := "0100001";	--D
				WHEN X"E" => disp := "0000100";	--E
				WHEN X"F" => disp := "0001110";	--F
			END CASE;
			RETURN STD_LOGIC_VECTOR(disp);
		END num2disp;

BEGIN
    state_reg: PROCESS(ps2_clock, reset)
    BEGIN 
		IF (reset = '1') THEN
			i <= 0;
			disp1 <= num2disp(X"0");
			disp2 <= num2disp(X"0");
			sw <= 0;
			key <= (OTHERS => '0');
		ELSIF (ps2_clock'EVENT AND ps2_clock = '1') THEN
			code(i) <= ps2_data;
			i <= (i + 1) MOD 11;
			IF (i = 10) THEN
				key <= code;
				
				IF (code(8 DOWNTO 1) = X"F0") THEN
					sw <= 1;
				ELSIF (sw = 1 AND code(8 DOWNTO 1) /= X"F0") THEN
					addr <= num2addr(code(8 DOWNTO 1));
					disp1 <= num2disp(code(4 DOWNTO 1));
					disp2 <= num2disp(code(8 DOWNTO 5));
					sw <= 2;
				ELSE
					sw <= 0;
				END IF;
			END IF;
		END IF;
	END PROCESS;
	
END main;