	component nios is
		port (
			address_sig_external_connection_export     : out std_logic_vector(7 downto 0);                     -- export
			clk_clk                                    : in  std_logic                     := 'X';             -- clk
			data_sig_external_connection_export        : out std_logic_vector(15 downto 0);                    -- export
			interlock_input_external_connection_export : out std_logic_vector(7 downto 0);                     -- export
			led_pio_external_connection_export         : out std_logic_vector(7 downto 0);                     -- export
			q_sig_external_connection_export           : in  std_logic_vector(15 downto 0) := (others => 'X'); -- export
			reset_reset_n                              : in  std_logic                     := 'X';             -- reset_n
			switches_external_connection_export        : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- export
			wren_external_connection_export            : out std_logic                                         -- export
		);
	end component nios;

	u0 : component nios
		port map (
			address_sig_external_connection_export     => CONNECTED_TO_address_sig_external_connection_export,     --     address_sig_external_connection.export
			clk_clk                                    => CONNECTED_TO_clk_clk,                                    --                                 clk.clk
			data_sig_external_connection_export        => CONNECTED_TO_data_sig_external_connection_export,        --        data_sig_external_connection.export
			interlock_input_external_connection_export => CONNECTED_TO_interlock_input_external_connection_export, -- interlock_input_external_connection.export
			led_pio_external_connection_export         => CONNECTED_TO_led_pio_external_connection_export,         --         led_pio_external_connection.export
			q_sig_external_connection_export           => CONNECTED_TO_q_sig_external_connection_export,           --           q_sig_external_connection.export
			reset_reset_n                              => CONNECTED_TO_reset_reset_n,                              --                               reset.reset_n
			switches_external_connection_export        => CONNECTED_TO_switches_external_connection_export,        --        switches_external_connection.export
			wren_external_connection_export            => CONNECTED_TO_wren_external_connection_export             --            wren_external_connection.export
		);

