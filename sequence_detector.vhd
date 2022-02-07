library ieee;
use ieee.std_logic_1164.all;

entity sequence_detector is
port(
	input : in std_logic;
	password : in std_logic_vector(3 downto 0);
	Reset, Clock : in std_logic;
	output : out std_logic);
end sequence_detector;

architecture behavior of sequence_detector is

type state is ( Zero, One, Two, Three, Four );
signal pr_state, nx_state : state;

begin 
	lower_case : process(Reset, Clock)
	begin 
		if Reset = '0' then
			pr_state <= Zero;
		elsif rising_edge(Clock) then
			pr_state <= nx_state;
		end if;

	end process lower_case;

	upper_case : process (input, pr_state)
		begin
			case pr_state is
				when Zero =>
					output <= '0';
					if input = password(0) then
						nx_state <= One;
					else
						nx_state <= Zero;
					end if;
				when One =>
					output <= '0';
					if input = password(1) then
						nx_state <= Two;
					else
						nx_state <= Zero;
					end if;
				when Two =>
					output <= '0';
					if input = password(2) then
						nx_state <= Three;
					else
						nx_state <= Zero;
					end if;
				when Three =>
					output <= '0';
					if input = password(3) then
						nx_state <= Four;
					else
						nx_state <= Zero;
					end if;
				when Four =>
					output <= '1';
					if input = password(0) then
						nx_state <= One;
					else
						nx_state <= Zero;
					end if;
			end case;
		end process upper_case;
end behavior;
