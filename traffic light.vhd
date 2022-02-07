library ieee;
use ieee.std_logic_1164.all;
entity traffic_light is
port(
	input : in std_logic;
	password : in std_logic_vector(3 downto 0);
	Reset , Clock : in std_logic;
	green, red, yellow : out std_logic;
	digit1 : out std_logic_vector(3 downto 0);
	digit2 : out std_logic_vector(3 downto 0);
	output1 : out std_logic_vector(6 downto 0);
	output2 : out std_logic_vector(6 downto 0));
end traffic_light;

architecture behavior of traffic_light is

	type state is (s15,s14,s13,s12,s11,s10,s9,s8,s7,s6,s5,s4,s3,s2,s1,s0, go, stop, care);
	signal pr_state, nx_state : state;
	signal p_state , n_state : state;
	signal pass : std_logic;

component bcd_7seg_decoder is
port(
	I : in std_logic_vector(3 downto 0);
	O : out std_logic_vector(6 downto 0));
end component;

component sequence_detector is
port(
	input : in std_logic;
	Reset, Clock : in std_logic;
	output : out std_logic);
end component;

begin
	led1 : bcd_7seg_decoder port map(digit1 , output1);
	led2 : bcd_7seg_decoder port map(digit2 , output2);
	p1 : sequence_detector port map(input, Reset, Clock , pass);

	lower_case1 : process(reset, clock)
	begin
		if reset = '0' then
			p_state <= s15;
		elsif rising_edge(clock) then
			p_state <= n_state;
		end if;
	end process lower_case1;

	upper_case1 : process(p_state)
	begin
		case p_state is
			when s15 =>
				digit1 <= "0001";
				digit2 <= "0101";
				n_state <= s14;
			when s14 =>
				digit1 <= "0001";
				digit2 <= "0100";
				n_state <= s13;
			when s13 =>
				digit1 <= "0001";
				digit2 <= "0011";
				n_state <= s12;
			when s12 =>
				digit1 <= "0001";
				digit2 <= "0010";
				n_state <= s11;
			when s11 =>
				digit1 <= "0001";
				digit2 <= "0001";
				n_state <= s10;
			when s10 =>
				digit1 <= "0001";
				digit2 <= "0000";
				n_state <= s9;
			when s9 =>
				digit1 <= "0000";
				digit2 <= "1001";
				n_state <= s8;
			when s8 =>
				digit1 <= "0000";
				digit2 <= "1000";
				n_state <= s7;
			when s7 =>
				digit1 <= "0000";
				digit2 <= "0111";
				n_state <= s6;
			when s6 =>
				digit1 <= "0000";
				digit2 <= "0110";
				n_state <= s5;
			when s5 =>
				digit1 <= "0000";
				digit2 <= "0101";
				n_state <= s4;
			when s4 =>
				digit1 <= "0000";
				digit2 <= "0100";
				n_state <= s3;
			when s3 =>
				digit1 <= "0000";
				digit2 <= "0011";
				n_state <= s2;
			when s2 =>
				digit1 <= "0000";
				digit2 <= "0010";
				n_state <= s1;
			when s1 =>
				digit1 <= "0000";
				digit2 <= "0001";
				n_state <= s0;
			when s0 =>
				digit1 <= "0000";
				digit2 <= "0000";
				n_state <= s15;
			when others =>
				n_state <= s15;
		end case;
	end process upper_case1;


	lower_case2 : process(reset, clock)
	begin
		if reset = '0' then
			pr_state <= go;
		elsif rising_edge(clock) then
			pr_state <= nx_state;
		end if;
	end process lower_case2;

	upper_case2 : process (p_state, pr_state)
	begin
		case pr_state is
			when go =>
				green <= '1';
				yellow <= '0';
				red <= '0';
				if p_state = s3 then
					nx_state <= care;
				else nx_state <= go;
				end if;
			when care =>
				green <= '0';
				yellow <= '1';
				red <= '0';
				if p_state = s0 then
					nx_state <= stop;
				else nx_state <= care;
				end if;
			when stop =>
				green <= '0';
				yellow <= '0';
				red <= '1';
				if p_state = s1 then
					nx_state <= go;
				else nx_state <= stop;
				end if;
			when others => nx_state <= go;
		end case;
	end process upper_case2;
end behavior;
				




				
