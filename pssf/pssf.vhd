library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--library UNISIM;
--use UNISIM.Vcomponents.all;

entity pssf is
   Port(
      --osc
      MCLK: in std_logic;     --28.63636M
      SCSPCLK: in std_logic;  --22.5792M, 512fs
      --scsp
      nSYSRES: out std_logic; --open drain
      nMCCS: out std_logic;
      nMCOE: out std_logic;
      MCDIR: out std_logic;
      MCD: inout std_logic_vector(7 downto 0);
      nMCRDY: in std_logic;
      nMCINT: in std_logic;
      DSCK: in std_logic;     --11.2896M, 256fs
      DBCK: in std_logic;     --64fs, rising edge
      DLRCK: in std_logic;    --fs=44.1k, high=left, left>right
      DSD: in std_logic;      --16/18bit, MSB first, right justified
      EBCK: out std_logic;    --64fs, rising edge
      ELRCK: out std_logic;   --fs=44.1k, high=left, left>right
      ESD: out std_logic;     --16bit, MSB first, right justified
      MIDIIN: out std_logic;
      MIDIOUT: in std_logic;
      --scpu
      SCPUCLK: out std_logic;
      nSNDRES: out std_logic; --open drain
      --da
      DAnRST: out std_logic;
      DAMUTE: out std_logic;
      DABCK: out std_logic;
      DALRCK: out std_logic;
      DADATA: out std_logic;
--    --da_1793
--    DAFMT: out std_logic_vector(2 downto 0);
--    DADEMP: out std_logic_vector(1 downto 0);
      --da_1791
      DAnMS: out std_logic;   --spi:chip select
      DAMC: out std_logic;    --spi:clock
      DAMDI: out std_logic;   --spi:data input
      DAMDO: in std_logic;    --spi:data output
      DAMSEL: out std_logic;  --low=spi
      --tos
      TX: out std_logic;
      --bus
      A7: in std_logic;
      A: in std_logic_vector(3 downto 0);
      D: inout std_logic_vector(7 downto 0);
      nRD: in std_logic;
      nWR: in std_logic;
      nCS: in std_logic_vector(3 downto 0);
      nIC: in std_logic;
      nIRQ: out std_logic;    --open drain
      --dipsw
      nDSW: in std_logic_vector(3 downto 0)
   );
   --
   attribute BUFG: string;
   attribute BUFG of MCLK: signal is "CLK";
   attribute BUFG of SCSPCLK: signal is "CLK";
   attribute BUFG of DSCK: signal is "CLK";
   --
   attribute SLEW: string;
   attribute SLEW of nSYSRES: signal is "SLOW";
   attribute SLEW of nMCCS: signal is "SLOW";
   attribute SLEW of nMCOE: signal is "SLOW";
   attribute SLEW of MCDIR: signal is "SLOW";
   attribute SLEW of MCD: signal is "SLOW";
   attribute SLEW of EBCK: signal is "SLOW";
   attribute SLEW of ELRCK: signal is "SLOW";
   attribute SLEW of ESD: signal is "SLOW";
   attribute SLEW of MIDIIN: signal is "SLOW";
   attribute SLEW of SCPUCLK: signal is "SLOW";
   attribute SLEW of nSNDRES: signal is "SLOW";
   attribute SLEW of DAnRST: signal is "SLOW";
   attribute SLEW of DAMUTE: signal is "SLOW";
   attribute SLEW of DABCK: signal is "SLOW";
   attribute SLEW of DALRCK: signal is "SLOW";
   attribute SLEW of DADATA: signal is "SLOW";
-- attribute SLEW of DAFMT: signal is "SLOW";   --da_1793
-- attribute SLEW of DADEMP: signal is "SLOW";  --da_1793
   attribute SLEW of DAnMS: signal is "SLOW";   --da_1791
   attribute SLEW of DAMC: signal is "SLOW";    --da_1791
   attribute SLEW of DAMDI: signal is "SLOW";   --da_1791
   attribute SLEW of DAMSEL: signal is "SLOW";  --da_1791
   attribute SLEW of TX: signal is "SLOW";
   attribute SLEW of D: signal is "SLOW";
   attribute SLEW of nIRQ: signal is "SLOW";
   --
   attribute IOSTANDARD: string;
   attribute IOSTANDARD of MCLK: signal is "LVTTL";
   attribute IOSTANDARD of SCSPCLK: signal is "LVTTL";
   attribute IOSTANDARD of nSYSRES: signal is "LVTTL";
   attribute IOSTANDARD of nMCCS: signal is "LVTTL";
   attribute IOSTANDARD of nMCOE: signal is "LVTTL";
   attribute IOSTANDARD of MCDIR: signal is "LVTTL";
   attribute IOSTANDARD of MCD: signal is "LVTTL";
   attribute IOSTANDARD of nMCRDY: signal is "LVTTL";
   attribute IOSTANDARD of nMCINT: signal is "LVTTL";
   attribute IOSTANDARD of DSCK: signal is "LVTTL";
   attribute IOSTANDARD of DBCK: signal is "LVTTL";
   attribute IOSTANDARD of DLRCK: signal is "LVTTL";
   attribute IOSTANDARD of DSD: signal is "LVTTL";
   attribute IOSTANDARD of EBCK: signal is "LVTTL";
   attribute IOSTANDARD of ELRCK: signal is "LVTTL";
   attribute IOSTANDARD of ESD: signal is "LVTTL";
   attribute IOSTANDARD of MIDIIN: signal is "LVTTL";
   attribute IOSTANDARD of MIDIOUT: signal is "LVTTL";
   attribute IOSTANDARD of SCPUCLK: signal is "LVTTL";
   attribute IOSTANDARD of nSNDRES: signal is "LVTTL";
   attribute IOSTANDARD of DAnRST: signal is "LVTTL";
   attribute IOSTANDARD of DAMUTE: signal is "LVTTL";
   attribute IOSTANDARD of DABCK: signal is "LVTTL";
   attribute IOSTANDARD of DALRCK: signal is "LVTTL";
   attribute IOSTANDARD of DADATA: signal is "LVTTL";
-- attribute IOSTANDARD of DAFMT: signal is "LVTTL";     --da_1793
-- attribute IOSTANDARD of DADEMP: signal is "LVTTL";    --da_1793
   attribute IOSTANDARD of DAnMS: signal is "LVTTL";     --da_1791
   attribute IOSTANDARD of DAMC: signal is "LVTTL";      --da_1791
   attribute IOSTANDARD of DAMDI: signal is "LVTTL";     --da_1791
   attribute IOSTANDARD of DAMDO: signal is "LVTTL";     --da_1791
   attribute IOSTANDARD of DAMSEL: signal is "LVTTL";    --da_1791
   attribute IOSTANDARD of TX: signal is "LVTTL";
   attribute IOSTANDARD of A7: signal is "LVTTL";
   attribute IOSTANDARD of A: signal is "LVTTL";
   attribute IOSTANDARD of D: signal is "LVTTL";
   attribute IOSTANDARD of nRD: signal is "LVTTL";
   attribute IOSTANDARD of nWR: signal is "LVTTL";
   attribute IOSTANDARD of nCS: signal is "LVTTL";
   attribute IOSTANDARD of nIC: signal is "LVTTL";
   attribute IOSTANDARD of nIRQ: signal is "LVTTL";
   attribute IOSTANDARD of nDSW: signal is "LVTTL";
   --
   attribute DRIVE: string;
   attribute DRIVE of nSYSRES: signal is "4";
   attribute DRIVE of nMCCS: signal is "4";
   attribute DRIVE of nMCOE: signal is "4";
   attribute DRIVE of MCDIR: signal is "4";
   attribute DRIVE of MCD: signal is "4";
   attribute DRIVE of EBCK: signal is "2";
   attribute DRIVE of ELRCK: signal is "2";
   attribute DRIVE of ESD: signal is "2";
   attribute DRIVE of MIDIIN: signal is "2";
   attribute DRIVE of SCPUCLK: signal is "4";
   attribute DRIVE of nSNDRES: signal is "4";
   attribute DRIVE of DAnRST: signal is "2";
   attribute DRIVE of DAMUTE: signal is "2";
   attribute DRIVE of DABCK: signal is "2";
   attribute DRIVE of DALRCK: signal is "2";
   attribute DRIVE of DADATA: signal is "2";
-- attribute DRIVE of DAFMT: signal is "2";     --da_1793
-- attribute DRIVE of DADEMP: signal is "2";    --da_1793
   attribute DRIVE of DAnMS: signal is "2";     --da_1791
   attribute DRIVE of DAMC: signal is "2";      --da_1791
   attribute DRIVE of DAMDI: signal is "2";     --da_1791
   attribute DRIVE of DAMSEL: signal is "2";    --da_1791
   attribute DRIVE of TX: signal is "4";
   attribute DRIVE of D: signal is "4";
   attribute DRIVE of nIRQ: signal is "4";
   --
   attribute PULLUP: string;
   attribute PULLUP of DAMDO: signal is "TRUE"; --da_1791
   attribute PULLUP of nDSW: signal is "TRUE";
   --
   attribute KEEPER: string;
   attribute KEEPER of MCD: signal is "TRUE";
   --
   attribute LOC: string;
   attribute LOC of MCLK: signal is "P18";
   attribute LOC of SCSPCLK: signal is "P15";
   attribute LOC of nSYSRES: signal is "P29";
   attribute LOC of nMCCS: signal is "P4";
   attribute LOC of nMCOE: signal is "P20";
   attribute LOC of MCDIR: signal is "P5";
   attribute LOC of MCD: signal is "P6 P7 P10 P23 P22 P21 P12 P11";
   attribute LOC of nMCRDY: signal is "P27";
   attribute LOC of nMCINT: signal is "P28";
   attribute LOC of DSCK: signal is "P88";
   attribute LOC of DBCK: signal is "P42";
   attribute LOC of DLRCK: signal is "P43";
   attribute LOC of DSD: signal is "P41";
   attribute LOC of EBCK: signal is "P138";
   attribute LOC of ELRCK: signal is "P140";
   attribute LOC of ESD: signal is "P139";
   attribute LOC of MIDIIN: signal is "P137";
   attribute LOC of MIDIOUT: signal is "P47";
   attribute LOC of SCPUCLK: signal is "P50";
   attribute LOC of nSNDRES: signal is "P48";
   attribute LOC of DAnRST: signal is "P59";
   attribute LOC of DAMUTE: signal is "P63";
   attribute LOC of DABCK: signal is "P65";
   attribute LOC of DALRCK: signal is "P66";
   attribute LOC of DADATA: signal is "P64";
-- attribute LOC of DAFMT: signal is "P75 P76 P77";   --da_1793
-- attribute LOC of DADEMP: signal is "P79 P78";      --da_1793
   attribute LOC of DAnMS: signal is "P75";           --da_1791
   attribute LOC of DAMC: signal is "P76";            --da_1791
   attribute LOC of DAMDI: signal is "P77";           --da_1791
   attribute LOC of DAMDO: signal is "P79";           --da_1791
   attribute LOC of DAMSEL: signal is "P78";          --da_1791
   attribute LOC of TX: signal is "P93";
   attribute LOC of A7: signal is "P102";
   attribute LOC of A: signal is "P113 P115 P118 P116";
   attribute LOC of D: signal is "P117 P120 P122 P124 P129 P131 P133 P136";
   attribute LOC of nRD: signal is "P123";
   attribute LOC of nWR: signal is "P121";
   attribute LOC of nCS: signal is "P134 P132 P130 P126";
   attribute LOC of nIC: signal is "P114";
   attribute LOC of nIRQ: signal is "P103";
   attribute LOC of nDSW: signal is "P95 P96 P100 P101";
end pssf;

architecture rtl of pssf is
   --osc
   signal clk22div2: std_logic;
   --scsp
   type scsp_state is (
      SS_IDLE,
      SS_READ_0, SS_READ_1, SS_READ_2, SS_READ_3, SS_READ_WAIT, SS_READ_4, SS_READ_5,
      SS_WRITE_0, SS_WRITE_1, SS_WRITE_2, SS_WRITE_3, SS_WRITE_4, SS_WRITE_5, SS_WRITE_WAIT
   );
   signal sstate: scsp_state;
   signal bcs: std_logic;
   signal boe: std_logic;
   signal bdir: std_logic;
   signal brdata: std_logic_vector(15 downto 0);
   signal bwdata: std_logic_vector(7 downto 0);
   signal wack: std_logic;
   signal rack: std_logic;
   --
   signal srbck: std_logic_vector(1 downto 0);
   signal srlrck: std_logic_vector(1 downto 0);
   signal srsd: std_logic;
   signal sradata: std_logic_vector(17 downto 0);
   signal srmute: std_logic;
   signal adata: std_logic_vector(17 downto 0);
   --
   signal extbck: std_logic;
   signal extlrck: std_logic;
   signal extsd: std_logic;
   --sin 1k, 0db, fs=44.1k 441samples
   type wave_rom is array(0 to 511) of std_logic_vector(15 downto 0);
   constant sintbl: wave_rom := (
      X"0000",X"122d",X"23fb",X"350f",X"450f",X"53aa",X"6092",X"6b85",X"744b",
      X"7ab5",X"7ea2",X"7fff",X"7ec3",X"7af6",X"74ab",X"6c03",X"612a",X"545a",
      X"45d4",X"35e3",X"24db",X"1314",X"00e9",X"eeba",X"dce5",X"cbc6",X"bbb6",
      X"ad08",X"a008",X"94fa",X"8c18",X"858f",X"8181",X"8003",X"811d",X"84ca",
      X"8af5",X"9380",X"9e3e",X"aaf7",X"b969",X"c94a",X"da46",X"ec06",X"fe2d",
      X"105e",X"223a",X"3365",X"4385",X"5246",X"5f5d",X"6a85",X"7384",X"7a2d",
      X"7e5b",X"7ffa",X"7f01",X"7b75",X"7568",X"6cfb",X"6258",X"55b7",X"4759",
      X"3789",X"2699",X"14e1",X"02bc",X"f089",X"dea7",X"cd71",X"bd42",X"ae6d",
      X"a13f",X"95fd",X"8ce1",X"861a",X"81cb",X"800b",X"80e3",X"844e",X"8a3c",
      X"928c",X"9d13",X"a99c",X"b7e6",X"c7a5",X"d889",X"ea39",X"fc5a",X"0e8f",
      X"2077",X"31b8",X"41f6",X"50de",X"5e23",X"697f",X"72b8",X"799e",X"7e0d",
      X"7fee",X"7f37",X"7bed",X"761f",X"6ded",X"6380",X"570f",X"48db",X"392c",
      X"2855",X"16ad",X"048f",X"f259",X"e06b",X"cf20",X"bed2",X"afd7",X"a27c",
      X"9705",X"8db0",X"86ab",X"821c",X"801a",X"80b0",X"83da",X"8988",X"919c",
      X"9bee",X"a846",X"b666",X"c603",X"d6ce",X"e86e",X"fa88",X"0cbf",X"1eb3",
      X"3008",X"4064",X"4f73",X"5ce4",X"6874",X"71e6",X"790a",X"7db9",X"7fdc",
      X"7f68",X"7c5e",X"76d0",X"6ed9",X"64a3",X"5863",X"4a59",X"3acc",X"2a0f",
      X"1878",X"0661",X"f42a",X"e230",X"d0d0",X"c066",X"b145",X"a3bd",X"9813",
      X"8e85",X"8743",X"8274",X"8030",X"8083",X"836b",X"88da",X"90b3",X"9acd",
      X"a6f5",X"b4ea",X"c465",X"d515",X"e6a3",X"f8b6",X"0aee",X"1ced",X"2e56",
      X"3ecf",X"4e02",X"5ba1",X"6764",X"710e",X"786f",X"7d5e",X"7fc3",X"7f91",
      X"7cc9",X"777a",X"6fc0",X"65c1",X"59b3",X"4bd3",X"3c6a",X"2bc7",X"1a41",
      X"0833",X"f5fb",X"e3f6",X"d283",X"c1fc",X"b2b7",X"a503",X"9926",X"8f60",
      X"87e1",X"82d2",X"804c",X"805d",X"8303",X"8833",X"8fcf",X"99b2",X"a5a8",
      X"b372",X"c2c9",X"d35e",X"e4da",X"f6e4",X"091c",X"1b26",X"2ca2",X"3d37",
      X"4c8e",X"5a58",X"664e",X"7031",X"77cd",X"7cfd",X"7fa3",X"7fb4",X"7d2e",
      X"781f",X"70a0",X"66da",X"5afd",X"4d49",X"3e04",X"2d7d",X"1c0a",X"0a05",
      X"f7cd",X"e5bf",X"d439",X"c396",X"b42d",X"a64d",X"9a3f",X"9040",X"8886",
      X"8337",X"806f",X"803d",X"82a2",X"8791",X"8ef2",X"989c",X"a45f",X"b1fe",
      X"c131",X"d1aa",X"e313",X"f512",X"074a",X"195d",X"2aeb",X"3b9b",X"4b16",
      X"590b",X"6533",X"6f4d",X"7726",X"7c95",X"7f7d",X"7fd0",X"7d8c",X"78bd",
      X"717b",X"67ed",X"5c43",X"4ebb",X"3f9a",X"2f30",X"1dd0",X"0bd6",X"f99f",
      X"e788",X"d5f1",X"c534",X"b5a7",X"a79d",X"9b5d",X"9127",X"8930",X"83a2",
      X"8098",X"8024",X"8247",X"86f6",X"8e1a",X"978c",X"a31c",X"b08d",X"bf9c",
      X"cff8",X"e14d",X"f341",X"0578",X"1792",X"2932",X"39fd",X"499a",X"57ba",
      X"6412",X"6e64",X"7678",X"7c26",X"7f50",X"7fe6",X"7de4",X"7955",X"7250",
      X"68fb",X"5d84",X"5029",X"412e",X"30e0",X"1f95",X"0da7",X"fb71",X"e953",
      X"d7ab",X"c6d4",X"b725",X"a8f1",X"9c80",X"9213",X"89e1",X"8413",X"80c9",
      X"8012",X"81f3",X"8662",X"8d48",X"9681",X"a1dd",X"af22",X"be0a",X"ce48",
      X"df89",X"f171",X"03a6",X"15c7",X"2777",X"385b",X"481a",X"5664",X"62ed",
      X"6d74",X"75c4",X"7bb2",X"7f1d",X"7ff5",X"7e35",X"79e6",X"731f",X"6a03",
      X"5ec1",X"5193",X"42be",X"328f",X"2159",X"0f77",X"fd44",X"eb1f",X"d967",
      X"c877",X"b8a7",X"aa49",X"9da8",X"9305",X"8a98",X"848b",X"80ff",X"8006",
      X"81a5",X"85d3",X"8c7c",X"957b",X"a0a3",X"adba",X"bc7b",X"cc9b",X"ddc6",
      X"efa2",X"01d3",X"13fa",X"25ba",X"36b6",X"4697",X"5509",X"61c2",X"6c80",
      X"750b",X"7b36",X"7ee3",X"7ffd",X"7e7f",X"7a71",X"73e8",X"6b06",X"5ff8",
      X"52f8",X"444a",X"343a",X"231b",X"1146",X"ff17",X"ecec",X"db25",X"ca1d",
      X"ba2c",X"aba6",X"9ed6",X"93fd",X"8b55",X"850a",X"813d",X"8001",X"815e",
      X"854b",X"8bb5",X"947b",X"9f6e",X"ac56",X"baf1",X"caf1",X"dc05",X"edd3",
      X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
      X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
      X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
      X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
      X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
      X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
      X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
      X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000"
   );
   --scpu
   --da
   signal dacbck: std_logic;
   signal daclrck: std_logic;
   signal dacdata: std_logic;
   --da_1793
   --da_1791
   type da_state is ( DS_INIT, DS_WAIT, DS_WRITE, DS_IDLE );
   signal dstate: da_state;
   --tos
   signal framecnt: std_logic_vector(7 downto 0);
   signal divcnt: std_logic_vector(1 downto 0);
   signal bitcnt: std_logic_vector(5 downto 0);
   signal parity: std_logic;
   signal sbit: std_logic;
   signal btxd: std_logic;
   signal txd: std_logic;
   --bus
   signal srcswr: std_logic_vector(1 downto 0);
   signal srcsrd: std_logic_vector(1 downto 0);
   signal sraddr: std_logic_vector(7 downto 0);
   signal srdata: std_logic_vector(15 downto 0);
   signal regindex: std_logic_vector(11 downto 0);
   signal enbextin: std_logic;
   signal enbspdif: std_logic;
   signal enbmute: std_logic;
   signal enb18bit: std_logic;
   signal enbscspreset: std_logic;
   signal enbscpureset: std_logic;
   signal accmode: std_logic_vector(1 downto 0);
   signal atemp: std_logic_vector(20 downto 0);
   signal wdtemp: std_logic_vector(7 downto 0);
   signal addr: std_logic_vector(19 downto 0);
   signal wdata: std_logic_vector(15 downto 0);
   signal wreq: std_logic;
   signal rreq: std_logic;
   signal busrdata: std_logic_vector(7 downto 0);
   --dipsw
   signal selncs: std_logic;
begin

   --osc
   process(SCSPCLK)
   begin
      if SCSPCLK'event and SCSPCLK='1' then
         --11.2896M, 22.5792M/2
         clk22div2 <= not clk22div2;
      end if;
   end process;

   --scsp
   nSYSRES <= '0' when(nIC='0' or enbscspreset='1') else 'Z';
   nMCCS <= '0' when(bcs='1') else '1';
   nMCOE <= '0' when(boe='1') else '1';
   MCDIR <= '1' when(bdir='1') else '0';
   MCD <= bwdata when(boe='1' and bdir='1') else "ZZZZZZZZ";
   process(nIC, MCLK)
   begin
      if nIC='0' then
         sstate <= SS_IDLE;
         bcs <= '0';
         boe <= '0';
         bdir <= '0';
         brdata <= (others => '0');
         bwdata <= (others => '0');
         wack <= '0';
         rack <= '0';
      elsif MCLK'event and MCLK='1' then
         --
         case sstate is
            when SS_IDLE =>
               bcs <= '0';
               boe <= '0';
               bdir <= '0';
               if nMCRDY='0' then
                  if rack/=rreq then
                     sstate <= SS_READ_0;
                  elsif wack/=wreq then
                     sstate <= SS_WRITE_0;
                  end if;
               end if;

            when SS_READ_0 =>
               bcs <= '1';
               boe <= '1';
               bdir <= '1';
               bwdata <= X"4" & addr(19 downto 16);
               sstate <= SS_READ_1;
            when SS_READ_1 =>
               bcs <= '1';
               boe <= '1';
               bdir <= '1';
               bwdata <= addr(15 downto 8);
               sstate <= SS_READ_2;
            when SS_READ_2 =>
               bcs <= '1';
               boe <= '1';
               bdir <= '1';
               bwdata <= "10" & accmode & X"0";
               sstate <= SS_READ_3;
            when SS_READ_3 =>
               bcs <= '1';
               boe <= '1';
               bdir <= '1';
               bwdata <= addr(7 downto 0);
               sstate <= SS_READ_WAIT;
            when SS_READ_WAIT =>
               if nMCRDY='0' then
                  bcs <= '1';
                  boe <= '1';
                  bdir <= '0';
                  sstate <= SS_READ_4;
               end if;
            when SS_READ_4 =>
               bcs <= '1';
               boe <= '1';
               bdir <= '0';
               brdata(15 downto 8) <= MCD;
               sstate <= SS_READ_5;
            when SS_READ_5 =>
               bcs <= '1';
               boe <= '1';
               bdir <= '0';
               brdata(7 downto 0) <= MCD;
               rack <= rreq;
               sstate <= SS_IDLE;

            when SS_WRITE_0 =>
               bcs <= '1';
               boe <= '1';
               bdir <= '1';
               bwdata <= X"0" & addr(19 downto 16);
               sstate <= SS_WRITE_1;
            when SS_WRITE_1 =>
               bcs <= '1';
               boe <= '1';
               bdir <= '1';
               bwdata <= addr(15 downto 8);
               sstate <= SS_WRITE_2;
            when SS_WRITE_2 =>
               bcs <= '1';
               boe <= '1';
               bdir <= '1';
               bwdata <= "10" & accmode & X"0";
               sstate <= SS_WRITE_3;
            when SS_WRITE_3 =>
               bcs <= '1';
               boe <= '1';
               bdir <= '1';
               bwdata <= addr(7 downto 0);
               sstate <= SS_WRITE_4;
            when SS_WRITE_4 =>
               bcs <= '1';
               boe <= '1';
               bdir <= '1';
               bwdata <= wdata(15 downto 8);
               sstate <= SS_WRITE_5;
            when SS_WRITE_5 =>
               bcs <= '1';
               boe <= '1';
               bdir <= '1';
               bwdata <= wdata(7 downto 0);
               wack <= wreq;
               sstate <= SS_WRITE_WAIT;
            when SS_WRITE_WAIT =>
               bcs <= '0';
               boe <= '0';
               bdir <= '0';
               if nMCRDY='0' then
                  sstate <= SS_IDLE;
               end if;

            when others =>
               sstate <= SS_IDLE;
         end case;
      end if;
   end process;

   --
   process(nIC, DSCK)
      variable v_mute: std_logic;
   begin
      if nIC='0' then
         srbck <= (others => '0');
         srlrck <= (others => '0');
         srsd <= '0';
         sradata <= (others => '0');
         srmute <= '0';
         v_mute := '0';
         adata <= (others => '0');
      elsif DSCK'event and DSCK='1' then
         --
         srbck <= srbck(0) & DBCK;
         srlrck <= srlrck(0) & DLRCK;  --high=left
         srsd <= DSD;
         if srbck="01" then
            if enb18bit='1' then
               sradata <= sradata(16 downto 0) & srsd;         --18bit
            else
               sradata <= sradata(16 downto 2) & srsd & "00";  --16bit
            end if;
         end if;
         --
         srmute <= enbmute;            --high=active
         if srlrck="10" then
            v_mute := srmute;
         end if;
         if srlrck="01" or srlrck="10" then
            if v_mute='0' then
               adata <= sradata;
            else
               adata <= (others => '0');
            end if;
         end if;
      end if;
   end process;

   --
   EBCK <= extbck;
   ELRCK <= extlrck;
   ESD <= extsd when(enbextin='1') else '0';
   process(nIC, DSCK)
      variable v_ecnt: std_logic_vector(1 downto 0);
      variable v_ebcklrckcnt: std_logic_vector(6 downto 0);
      variable v_n: integer;
      variable v_ephase: std_logic_vector(8 downto 0);
      variable v_eldata: std_logic_vector(15 downto 0);
      variable v_erdata: std_logic_vector(15 downto 0);
   begin
      if nIC='0' then
         v_ecnt := (others => '0');
         v_ebcklrckcnt := (others => '0');
         extbck <= '0';
         extlrck <= '0';
         extsd <= '0';
         v_eldata := (others => '0');
         v_erdata := (others => '0');
      elsif DSCK'event and DSCK='1' then
         --
         if conv_integer(v_ecnt)<(2-1) then
            v_ecnt := v_ecnt + 1;
         else
            v_ecnt := (others => '0');
            v_ebcklrckcnt := v_ebcklrckcnt + 1;
         end if;
         --
         if extlrck='0' and v_ebcklrckcnt(6)='1' then
            v_eldata := sintbl(conv_integer(v_ephase));
            v_erdata := sintbl(conv_integer(v_ephase));
            if conv_integer(v_ephase)<(441-1) then
               v_ephase := v_ephase + 1;
            else
               v_ephase := (others => '0');
            end if;
         end if;
         --
         extbck <= v_ebcklrckcnt(0);
         extlrck <= v_ebcklrckcnt(6);  --high=left
         v_n := 15 - conv_integer(v_ebcklrckcnt(4 downto 1));
         if v_ebcklrckcnt(5)='0' then
            extsd <= '1';
         elsif v_ebcklrckcnt(6)='1' then
            extsd <= v_eldata(v_n);
         else
            extsd <= v_erdata(v_n);
         end if;
      end if;
   end process;

   --
   MIDIIN <= '1';
-- MIDIOUT: in std_logic;

   --scpu
   nSNDRES <= '0' when(nIC='0' or enbscpureset='1') else 'Z';
   SCPUCLK <= clk22div2;

   --da
   DAnRST <= nIC;
   DAMUTE <= srmute;
   DABCK <= dacbck;
   DALRCK <= daclrck;
   DADATA <= dacdata;
   process(nIC, DSCK)
      variable v_ecnt: std_logic_vector(1 downto 0);
      variable v_ebcklrckcnt: std_logic_vector(6 downto 0);
      variable v_n: integer;
   begin
      if nIC='0' then
         v_ecnt := (others => '0');
         v_ebcklrckcnt := (others => '0');
         dacbck <= '0';
         daclrck <= '0';
         dacdata <= '0';
      elsif DSCK'event and DSCK='1' then
         --
         if srlrck="10" then
            v_ecnt := (others => '0');
            v_ebcklrckcnt := (others => '0');
         else
            if conv_integer(v_ecnt)<(2-1) then
               v_ecnt := v_ecnt + 1;
            else
               v_ecnt := (others => '0');
               v_ebcklrckcnt := v_ebcklrckcnt + 1;
            end if;
         end if;
         --
         dacbck <= v_ebcklrckcnt(0);
         daclrck <= not v_ebcklrckcnt(6); --high=left
         v_n := 31 - conv_integer(v_ebcklrckcnt(5 downto 1));
         if v_n<20 and v_n>=(20-adata'length) then
            dacdata <= adata(v_n - (20-adata'length));
         else
            dacdata <= '0';
         end if;
      end if;
   end process;

-- --da_1793
-- DAFMT <= "001";
-- DADEMP <= "00";

   --da_1791
   DAMSEL <= '0';
   process(nIC, DSCK)
      variable v_dsr: std_logic_vector(15 downto 0);
      variable v_wcnt: std_logic_vector(10 downto 0);
      variable v_dcnt: std_logic_vector(4 downto 0);
   begin
      if nIC='0' then
         dstate <= DS_INIT;
         DAnMS <= '1';
         DAMC <= '0';
         DAMDI <= '0';
         v_dsr(15 downto 8) := "00010010";   --r/w#, address
         v_dsr(7 downto 0) := "00010000";    --data(20bit)
      elsif DSCK'event and DSCK='1' then
         --
         case dstate is
            when DS_INIT =>
               --((1024+4)/11.2896)/(1/11.2896)=1028
               v_wcnt := conv_std_logic_vector(1028-1, v_wcnt'length);
               v_dcnt := (others => '1');
               dstate <= DS_WAIT;
            when DS_WAIT =>
               DAnMS <= '1';
               DAMC <= '0';
               DAMDI <= '0';
               if conv_integer(v_wcnt)=0 then
                  dstate <= DS_WRITE;
               end if;
               v_wcnt := v_wcnt - 1;
            when DS_WRITE =>
               --(100e-9)/(1/11.2896e6)=1.12896
               DAnMS <= '0';
               DAMC <= not v_dcnt(0);
               DAMDI <= v_dsr(conv_integer(v_dcnt(4 downto 1)));
               if conv_integer(v_dcnt)=0 then
                  dstate <= DS_IDLE;
               end if;
               v_dcnt := v_dcnt - 1;
            when DS_IDLE =>
               DAnMS <= '1';
               DAMC <= '0';
               DAMDI <= '0';
               dstate <= DS_IDLE;
            when others =>
               dstate <= DS_INIT;
         end case;
      end if;
   end process;

   --tos
   TX <= txd when(enbspdif='1') else '0';
   process(nIC, DSCK)
      variable v_preamble: std_logic_vector(3 downto 0);
      variable v_cstatus: std_logic;
   begin
      if nIC='0' then
         framecnt <= (others => '0');
         divcnt <= (others => '0');
         bitcnt <= (others => '0');
         parity <= '0';
         sbit <= '0';
         btxd <= '0';
         txd <= '0';
      elsif DSCK'event and DSCK='1' then

         --frame counter
         --  0~191
         if srlrck="10" then
            if framecnt="10111111" then
               framecnt <= (others => '0');
            else
               framecnt <= framecnt + 1;
            end if;
         end if;

         --preamble
         if srlrck="10" or srlrck="00" then
            --ch.a(left)
            if framecnt="00000000" then
               --frame0
               v_preamble := "1000";   --"Z"
            else
               v_preamble := "0010";   --"X"
            end if;
         else
            --ch.b(right)
            v_preamble := "0100";      --"Y"
         end if;

         --channel status
         case framecnt is
            --frame2
            --  1: copyright is not asserted for this data
            when X"02" =>
               v_cstatus := '1';
            --frame27~24
            --  sampling frequency
            --    0000: 44.1k
            --    0010: 48k
            --    0011: 32k
            when X"1b" =>
               v_cstatus := '0';
            when X"1a" =>
               v_cstatus := '0';
            when X"19" =>
               v_cstatus := '0';
            when X"18" =>
               v_cstatus := '0';
            --frame32
            --  maximum audio sample word length
            --    0: 20bit
            when X"20" =>
               v_cstatus := '0';
            --frame35~33
            --  audio sample word length
            --    001: 16bit
            --    010: 18bit
            when X"23" =>
               v_cstatus := '0';
            when X"22" =>
               if enb18bit='1' then
                  v_cstatus := '1'; --18bit
               else
                  v_cstatus := '0'; --16bit
               end if;
            when X"21" =>
               if enb18bit='1' then
                  v_cstatus := '0'; --18bit
               else
                  v_cstatus := '1'; --16bit
               end if;
            --others
            when others =>
               v_cstatus := '0';
         end case;

         --div counter
         --  0~1
         if srlrck="10" then
            divcnt <= (others => '0');
         else
            if divcnt="01" then
               divcnt <= (others => '0');
            else
               divcnt <= divcnt + 1;
            end if;
         end if;

         --bit counter
         --  0~63
         if srlrck="10" then
            bitcnt <= (others => '0');
         elsif divcnt="01" then
            bitcnt <= bitcnt + 1;
         end if;

         --status/parity, biphase-mark encode
         if divcnt="01" then
            --status
            case bitcnt(5 downto 1) is
               when "01010" =>
                  sbit <= adata(0);
               when "01011" =>
                  sbit <= adata(1);
               when "01100" =>
                  sbit <= adata(2);
               when "01101" =>
                  sbit <= adata(3);
               when "01110" =>
                  sbit <= adata(4);
               when "01111" =>
                  sbit <= adata(5);
               when "10000" =>
                  sbit <= adata(6);
               when "10001" =>
                  sbit <= adata(7);
               when "10010" =>
                  sbit <= adata(8);
               when "10011" =>
                  sbit <= adata(9);
               when "10100" =>
                  sbit <= adata(10);
               when "10101" =>
                  sbit <= adata(11);
               when "10110" =>
                  sbit <= adata(12);
               when "10111" =>
                  sbit <= adata(13);
               when "11000" =>
                  sbit <= adata(14);
               when "11001" =>
                  sbit <= adata(15);
               when "11010" =>
                  sbit <= adata(16);
               when "11011" =>
                  sbit <= adata(17);
               when "11110" =>
                  sbit <= v_cstatus;
               when "11111" =>
                  sbit <= parity;
               when others =>
                  sbit <= '0';
            end case;
            --parity
            case bitcnt(5 downto 3) is
               when "000" =>
                  parity <= '0';
               when others =>
                  if bitcnt(0)='1' then
                     parity <= parity xor sbit;
                  end if;
            end case;

            --biphase-mark encode
            case bitcnt is
               when "000000" =>
                  btxd <= txd;
                  txd <= txd xor '1';
               when "000001" =>
                  txd <= btxd xor '1';
               when "000010" =>
                  txd <= btxd xor '1';
               when "000011" =>
                  txd <= btxd xor '0';
               when "000100" =>
                  txd <= btxd xor v_preamble(3);
               when "000101" =>
                  txd <= btxd xor v_preamble(2);
               when "000110" =>
                  txd <= btxd xor v_preamble(1);
               when "000111" =>
                  txd <= btxd xor v_preamble(0);
               when others =>
                  if bitcnt(0)='1' then
                     txd <= txd xor sbit;
                  else
                     txd <= txd xor '1';
                  end if;
            end case;
         end if;

      end if;
   end process;

   --bus
   D <= busrdata when(selncs='0' and nRD='0' and nWR='1') else "ZZZZZZZZ";
   nIRQ <= 'Z';
   process(nIC, MCLK)
      variable v_busy: std_logic;
   begin
      if nIC='0' then
         srcswr <= (others => '0');
         srcsrd <= (others => '0');
         sraddr <= (others => '0');
         srdata <= (others => '0');
         regindex <= (others => '0');
         enbextin <= '0';
         enbspdif <= '0';
         enbmute <= '0';
         enb18bit <= '0';
         enbscspreset <= '0';
         enbscpureset <= '1';
         accmode <= (others => '0');
         atemp <= (others => '0');
         wdtemp <= (others => '0');
         addr <= (others => '0');
         wdata <= (others => '0');
         wreq <= '0';
         rreq <= '0';
         busrdata <= (others => '0');
      elsif MCLK'event and MCLK='1' then
         --
         srcswr <= ((not selncs) and (not nWR)) & srcswr(1);
         srcsrd <= ((not selncs) and (not nRD)) & srcsrd(1);
         sraddr <= A & sraddr(7 downto 4);
         srdata <= D & srdata(15 downto 8);
         if srcswr="01" then
            case sraddr(3 downto 0) is
               when X"0" | X"2" | X"8" | X"a" =>
                  --scsp, address
               when X"1" | X"3" | X"9" | X"b" =>
                  --scsp, data
               when X"4" | X"6" | X"c" | X"e" =>
                  --fpga, address
                  regindex <= "00" & sraddr(2 downto 1) & srdata(7 downto 0);
               when X"5" | X"7" | X"d" | X"f" =>
                  --fpga, data
                  case regindex is
                     when X"301" =>
                        --fpga, mode
                        --  b7: extin, enable/disable#
                        --  b4: spdif, enable/disable#
                        --  b3: mute, enable/disable#
                        --  b2: 18bit, enable/disable#
                        --  b1: scsp_reset, enable/disable#
                        --  b0: scpu_reset, enable/disable#
                        enbextin <= srdata(7);
                        enbspdif <= srdata(4);
                        enbmute <= srdata(3);
                        enb18bit <= srdata(2);
                        enbscspreset <= srdata(1);
                        enbscpureset <= srdata(0);
                     when X"302" =>
                        --scsp, low address
                        atemp(8 downto 1) <= srdata(7 downto 0);
                        atemp(0) <= '0';
                     when X"303" =>
                        --scsp, middle address
                        atemp(16 downto 9) <= srdata(7 downto 0);
                     when X"304" =>
                        --scsp, b5-4: access mode
                        --  0: word, b15-0
                        --  1: byte, b15-8
                        --  2: byte, b7-0
                        --  3: x
                        --scsp, b3-0: high address
                        accmode <= srdata(5 downto 4);
                        atemp(20 downto 17) <= srdata(3 downto 0);
                     when X"308" =>
                        --scsp, write data
                        atemp <= atemp + 1;
                        if atemp(0)='0' then
                           wdtemp <= srdata(7 downto 0);
                        else
                           addr <= atemp(20 downto 1);
                           wdata <= wdtemp & srdata(7 downto 0);
                           wreq <= not wreq;
                        end if;
                     when X"318" =>
                        --scsp, read data
                        atemp <= atemp + 2;
                        addr <= atemp(20 downto 1);
                        rreq <= not rreq;
                     when others =>
                        null;
                  end case;
               when others =>
                  null;
            end case;
         end if;
         --
         if srcsrd="10" then
            v_busy := not ((wreq xor wack) or (rreq xor rack));
            case sraddr(7 downto 4) is
               when X"0" | X"2" | X"8" | X"a" =>
                  --scsp, address
                  busrdata <= brdata(15 downto 8);
               when X"1" | X"3" | X"9" | X"b" =>
                  --scsp, data
                  busrdata <= brdata(7 downto 0);
               when X"4" | X"6" | X"c" | X"e" =>
                  --fpga, address
                  busrdata <= (not v_busy) & "000" & v_busy & v_busy & "00";
               when X"5" | X"7" | X"d" | X"f" =>
                  --fpga, data
                  busrdata <= X"ff";
               when others =>
                  null;
            end case;
         end if;
      end if;
   end process;

   --dipsw
   process(nDSW, nCS, A7)
   begin
      if (A7 xor nDSW(3))='1' then
         selncs <= nCS(conv_integer("11" xor nDSW(1 downto 0)));
      else
         selncs <= '1';
      end if;
   end process;

end rtl;
