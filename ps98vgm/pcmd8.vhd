library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity pcmd8 is
   Port(
      --osc
      CLK: in std_logic;      --33.8688M
      XI: in std_logic;       --16.9344M, 384fs
      --pcmd8
      BnCS: out std_logic;
      BnDSPCS: in std_logic;
      BnDSPSCK: in std_logic;
      BDSPCDI_nIRQ: in std_logic;
      BBCO: in std_logic;     --64fs, rising edge
      BLRO: in std_logic;     --fs=44.1k, high=left, left>right
      BDO: in std_logic;      --16bit, MSB first, right justified
      BEO: in std_logic;      --16bit, MSB first, right justified
      --pcmd8_mem
      BMA: in std_logic_vector(23 downto 0);
      BMD: inout std_logic_vector(7 downto 0);
      BnMOE: in std_logic;
      BnMWR: in std_logic;
      BnMCE: in std_logic;
      --ram
      RDQ: inout std_logic_vector(7 downto 0);
      RnWE: out std_logic;
      RnCAS: out std_logic;
      RnRAS: out std_logic;
      RnCS: out std_logic;
      RBA: out std_logic_vector(1 downto 0);
      RA: out std_logic_vector(12 downto 0);
      RCKE: out std_logic;
      RCLK: out std_logic;    --67.7376M
      RDQM: out std_logic;
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
      A: in std_logic_vector(5 downto 0);
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
   attribute BUFG of CLK: signal is "CLK";
   attribute BUFG of XI: signal is "CLK";
   --
   attribute SLEW: string;
   attribute SLEW of BnCS: signal is "SLOW";
   attribute SLEW of BMD: signal is "FAST";
   attribute SLEW of RDQ: signal is "FAST";
   attribute SLEW of RnWE: signal is "FAST";
   attribute SLEW of RnCAS: signal is "FAST";
   attribute SLEW of RnRAS: signal is "FAST";
   attribute SLEW of RnCS: signal is "FAST";
   attribute SLEW of RBA: signal is "FAST";
   attribute SLEW of RA: signal is "FAST";
   attribute SLEW of RCKE: signal is "FAST";
   attribute SLEW of RCLK: signal is "FAST";
   attribute SLEW of RDQM: signal is "FAST";
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
   attribute IOSTANDARD of CLK: signal is "LVTTL";
   attribute IOSTANDARD of XI: signal is "LVTTL";
   attribute IOSTANDARD of BnCS: signal is "LVTTL";
   attribute IOSTANDARD of BnDSPCS: signal is "LVTTL";
   attribute IOSTANDARD of BnDSPSCK: signal is "LVTTL";
   attribute IOSTANDARD of BDSPCDI_nIRQ: signal is "LVTTL";
   attribute IOSTANDARD of BBCO: signal is "LVTTL";
   attribute IOSTANDARD of BLRO: signal is "LVTTL";
   attribute IOSTANDARD of BDO: signal is "LVTTL";
   attribute IOSTANDARD of BEO: signal is "LVTTL";
   attribute IOSTANDARD of BMA: signal is "LVTTL";
   attribute IOSTANDARD of BMD: signal is "LVTTL";
   attribute IOSTANDARD of BnMOE: signal is "LVTTL";
   attribute IOSTANDARD of BnMWR: signal is "LVTTL";
   attribute IOSTANDARD of BnMCE: signal is "LVTTL";
   attribute IOSTANDARD of RDQ: signal is "LVTTL";
   attribute IOSTANDARD of RnWE: signal is "LVTTL";
   attribute IOSTANDARD of RnCAS: signal is "LVTTL";
   attribute IOSTANDARD of RnRAS: signal is "LVTTL";
   attribute IOSTANDARD of RnCS: signal is "LVTTL";
   attribute IOSTANDARD of RBA: signal is "LVTTL";
   attribute IOSTANDARD of RA: signal is "LVTTL";
   attribute IOSTANDARD of RCKE: signal is "LVTTL";
   attribute IOSTANDARD of RCLK: signal is "LVTTL";
   attribute IOSTANDARD of RDQM: signal is "LVTTL";
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
   attribute DRIVE of BnCS: signal is "4";
   attribute DRIVE of BMD: signal is "4";
   attribute DRIVE of RDQ: signal is "4";
   attribute DRIVE of RnWE: signal is "4";
   attribute DRIVE of RnCAS: signal is "4";
   attribute DRIVE of RnRAS: signal is "4";
   attribute DRIVE of RnCS: signal is "4";
   attribute DRIVE of RBA: signal is "4";
   attribute DRIVE of RA: signal is "4";
   attribute DRIVE of RCKE: signal is "4";
   attribute DRIVE of RCLK: signal is "4";
   attribute DRIVE of RDQM: signal is "4";
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
   attribute PULLUP of BDSPCDI_nIRQ: signal is "TRUE";
   attribute PULLUP of DAMDO: signal is "TRUE"; --da_1791
   attribute PULLUP of nDSW: signal is "TRUE";
   --
   attribute KEEPER: string;
   attribute KEEPER of RDQ: signal is "TRUE";
   --
   attribute LOC: string;
   attribute LOC of CLK: signal is "P80";
   attribute LOC of XI: signal is "P185";
   attribute LOC of BnCS: signal is "P194";
   attribute LOC of BnDSPCS: signal is "P200";
   attribute LOC of BnDSPSCK: signal is "P199";
   attribute LOC of BDSPCDI_nIRQ: signal is "P195";
   attribute LOC of BBCO: signal is "P27";
   attribute LOC of BLRO: signal is "P24";
   attribute LOC of BDO: signal is "P29";
   attribute LOC of BEO: signal is "P23";
   attribute LOC of BMA: signal is "P204 P205 P4 P5 P6 P7 P8 P9 P10 P14 P15 P16 P17 P18 P20 P21 P22 P33 P34 P35 P36 P37 P41 P42";
   attribute LOC of BMD: signal is "P43 P44 P45 P46 P47 P48 P31 P30";
   attribute LOC of BnMOE: signal is "P203";
   attribute LOC of BnMWR: signal is "P202";
   attribute LOC of BnMCE: signal is "P201";
   attribute LOC of RDQ: signal is "P102 P101 P94 P90 P109 P110 P111 P112";
   attribute LOC of RnWE: signal is "P100";
   attribute LOC of RnCAS: signal is "P99";
   attribute LOC of RnRAS: signal is "P98";
   attribute LOC of RnCS: signal is "P97";
   attribute LOC of RBA: signal is "P95 P96";
   attribute LOC of RA: signal is "P74 P73 P89 P71 P70 P69 P68 P67 P63 P84 P86 P87 P88";
   attribute LOC of RCKE: signal is "P75";
   attribute LOC of RCLK: signal is "P82";
   attribute LOC of RDQM: signal is "P83";
   attribute LOC of DAnRST: signal is "P61";
   attribute LOC of DAMUTE: signal is "P60";
   attribute LOC of DABCK: signal is "P58";
   attribute LOC of DALRCK: signal is "P59";
   attribute LOC of DADATA: signal is "P57";
-- attribute LOC of DAFMT: signal is "P120 P121 P122";   --da_1793
-- attribute LOC of DADEMP: signal is "P123 P127";       --da_1793
   attribute LOC of DAnMS: signal is "P120";             --da_1791
   attribute LOC of DAMC: signal is "P121";              --da_1791
   attribute LOC of DAMDI: signal is "P122";             --da_1791
   attribute LOC of DAMDO: signal is "P123";             --da_1791
   attribute LOC of DAMSEL: signal is "P127";            --da_1791
   attribute LOC of TX: signal is "P134";
   attribute LOC of A: signal is "P150 P149 P163 P165 P168 P166";
   attribute LOC of D: signal is "P167 P172 P174 P176 P179 P187 P189 P192";
   attribute LOC of nRD: signal is "P175";
   attribute LOC of nWR: signal is "P173";
   attribute LOC of nCS: signal is "P191 P188 P180 P178";
   attribute LOC of nIC: signal is "P164";
   attribute LOC of nIRQ: signal is "P151";
   attribute LOC of nDSW: signal is "P140 P141 P147 P148";
end pcmd8;

architecture rtl of pcmd8 is
   --osc
   signal CLK0: std_logic;
   signal CLK2X: std_logic;
   signal LOCKED: std_logic;
   signal CLKFB: std_logic;
   signal RAMCLK: std_logic;
   --pcmd8
   signal srbbco: std_logic_vector(1 downto 0);
   signal srblro: std_logic_vector(1 downto 0);
   signal srbdo: std_logic;
   signal sradata: std_logic_vector(17 downto 0);
   signal srmute: std_logic;
   signal adata: std_logic_vector(17 downto 0);
   --pcmd8_mem
   signal srmcemoe: std_logic_vector(1 downto 0);
   signal srma: std_logic_vector(BMA'range);
   signal srbbco2: std_logic_vector(1 downto 0);
   signal srblro2: std_logic;
   signal srblro3: std_logic_vector(1 downto 0);
   signal bcocnt: integer range 0 to 31;
   signal enbmaskset: std_logic;
   signal accmask: std_logic_vector(0 to 31);
   --ram
   constant CMD_INHIBIT:   std_logic_vector(3 downto 0) := "1000";
   constant CMD_NOP:       std_logic_vector(3 downto 0) := "0111";
   constant CMD_ACTIVE:    std_logic_vector(3 downto 0) := "0011";
   constant CMD_READ:      std_logic_vector(3 downto 0) := "0101";
   constant CMD_WRITE:     std_logic_vector(3 downto 0) := "0100";
   constant CMD_PRECHARGE: std_logic_vector(3 downto 0) := "0010";
   constant CMD_REFRESH:   std_logic_vector(3 downto 0) := "0001";
   constant CMD_MODE:      std_logic_vector(3 downto 0) := "0000";
   --
   constant cTmin:   integer := 6774;
   constant cRFCmin: integer := 5;
   constant cREF:    integer := 529;
   --
   type ram_state is (
      --initialize
      RS_INIT_0, RS_INIT_1, RS_INIT_2, RS_INIT_3, RS_INIT_4,
      RS_INIT_REFRESH_0, RS_INIT_REFRESH_1, RS_INIT_REFRESH_2,
      RS_INIT_MODE_0, RS_INIT_MODE_1, RS_INIT_MODE_2,
      --idle
      RS_IDLE,
      --refresh
      RS_REFRESH_0, RS_REFRESH_1,
      --active
      RS_ACTIVE_0, RS_ACTIVE_1,
      --read
      RS_READ_0, RS_READ_1, RS_READ_2, RS_READ_3, RS_READ_4,
      --write
      RS_WRITE_0, RS_WRITE_1, RS_WRITE_2, RS_WRITE_3
   );
   signal rstate: ram_state;
   signal waitcnt: integer range 0 to 8191;
   signal refcnt: integer;
   signal refreq: std_logic;
   signal rfccnt: integer;
   signal rrcmd: std_logic_vector(3 downto 0);
   signal rrba: std_logic_vector(RBA'range);
   signal rra: std_logic_vector(RA'range);
   signal rrcke: std_logic;
   signal rrdqm: std_logic;
   signal roe: std_logic;
   signal accselect: std_logic;
   signal ramaddr: std_logic_vector(24 downto 0);
   signal ramrnw: std_logic;
   signal ramwdata: std_logic_vector(RDQ'range);
   signal brdata: std_logic_vector(RDQ'range);
   signal refack: std_logic;
   signal rdata: std_logic_vector(RDQ'range);
   signal rwack: std_logic;
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
   signal sraddr: std_logic_vector(3 downto 0);
   signal srdata: std_logic_vector(15 downto 0);
   signal regindex: std_logic_vector(11 downto 0);
   signal ienb: std_logic;
   signal seloutput: std_logic;
   signal enbspdif: std_logic;
   signal enbmute: std_logic;
   signal atemp: std_logic_vector(BMA'range);
   signal addr: std_logic_vector(BMA'range);
   signal wdata: std_logic_vector(7 downto 0);
   signal rnw: std_logic;
   signal rwreq: std_logic;
   signal busrdata: std_logic_vector(7 downto 0);
   --dipsw
   signal selncs: std_logic;
begin

   --osc
   CLKDLL_inst : CLKDLL
   generic map (
      CLKDV_DIVIDE => 2.0, --  Divide by: 1.5,2.0,2.5,3.0,4.0,5.0,8.0 or 16.0
      DUTY_CYCLE_CORRECTION => TRUE, --  Duty cycle correction, TRUE or FALSE
      FACTORY_JF => X"C080",  --  FACTORY JF Values
      STARTUP_WAIT => FALSE)  --  Delay config DONE until DLL LOCK, TRUE/FALSE
   port map (
      CLK0 => CLK0,     -- 0 degree DLL CLK ouptput
      CLK2X => CLK2X,   -- 2X DLL CLK output
      LOCKED => LOCKED, -- DLL LOCK status output
      CLKFB => CLKFB,   -- DLL clock feedback
      CLKIN => CLK,     -- Clock input (from IBUFG, BUFG or DLL)
      RST => (not nIC)  -- DLL asynchronous reset input
   );
   BUFG_inst : BUFG
   port map (
      O => CLKFB,       -- Clock buffer output
      I => CLK0         -- Clock buffer input
   );
   BUFG_inst2 : BUFG
   port map (
      O => RAMCLK,      -- Clock buffer output
      I => CLK2X        -- Clock buffer input
   );

   --pcmd8
   BnCS <= '0' when(selncs='0' and A(1)='0') else '1';

   --
   process(nIC, XI)
      variable v_mute: std_logic;
   begin
      if nIC='0' then
         srbbco <= (others => '0');
         srblro <= (others => '0');
         srbdo <= '0';
         sradata <= (others => '0');
         srmute <= '0';
         v_mute := '0';
         adata <= (others => '0');
      elsif XI'event and XI='1' then
         --
         srbbco <= srbbco(0) & BBCO;
         srblro <= srblro(0) & BLRO;   --high=left
         case seloutput is
            when '0' =>
               srbdo <= BDO;
            when others =>
               srbdo <= BEO;
         end case;
         if srbbco="01" then
--          sradata <= sradata(16 downto 0) & srbdo;        --18bit
            sradata <= sradata(16 downto 2) & srbdo & "00"; --16bit
         end if;
         --
         srmute <= enbmute;            --high=active
         if srblro="10" then
            v_mute := srmute;
         end if;
         if srblro="01" or srblro="10" then
            if v_mute='0' then
               adata <= sradata;
            else
               adata <= (others => '0');
            end if;
         end if;
      end if;
   end process;

   --pcmd8_mem
   BMD <= brdata when(BnMCE='0' and BnMOE='0') else "ZZZZZZZZ";

   --ram
   RDQ <= ramwdata when(roe='1') else "ZZZZZZZZ";
   RnWE <= rrcmd(0);
   RnCAS <= rrcmd(1);
   RnRAS <= rrcmd(2);
   RnCS <= rrcmd(3);
   RBA <= rrba;
   RA <= rra;
   RCKE <= rrcke;
   RCLK <= RAMCLK;
   RDQM <= rrdqm;
   process(LOCKED, nIC, RAMCLK)
      variable v_mask: std_logic;
   begin
      if LOCKED='0' or nIC='0' then
         rstate <= RS_INIT_0;
         waitcnt <= 0;
         refcnt <= 0;
         refreq <= '0';
         rfccnt <= 0;
         rrcmd <= CMD_INHIBIT;
         rrba <= (others => '0');
         rra <= (others => '0');
         rrcke <= '0';
         rrdqm <= '1';
         roe <= '0';
         accselect <= '0';
         ramaddr <= (others => '0');
         ramrnw <= '0';
         ramwdata <= (others => '0');
         brdata <= X"00";
         refack <= '0';
         rdata <= X"00";
         rwack <= '0';
         --
         srmcemoe <= (others => '0');
         srma <= (others => '0');
         srbbco2 <= (others => '0');
         srblro2 <= '0';
         srblro3 <= (others => '0');
         bcocnt <= 0;
         enbmaskset <= '0';
--       accmask <= (others => '0');
         accmask <= "1111110000011111" & "1111110000011111";
--       accmask <= "1111000000000001" & "1111000000000001";   --org
      elsif RAMCLK'event and RAMCLK='1' then

         --
         if refcnt=0 then
            refcnt <= cREF-1;
            refreq <= not refreq;
         else
            refcnt <= refcnt - 1;
         end if;

--          if BnMWR='0' then
--             ramrnw <= '0';
--             ramwdata <= BMD;
--          end if;
         --
         srmcemoe <= srmcemoe(0) & ((not BnMCE) and (not BnMOE));
         srma <= BMA;
         srbbco2 <= srbbco2(0) & BBCO;
         srblro2 <= BLRO;
         case srbbco2 is
            when "01" =>
               srblro3 <= srblro3(0) & srblro2;
               if srblro3="01" or srblro3="10" then
                  bcocnt <= 0;
                  enbmaskset <= '1';
               elsif bcocnt>=31 then
                  bcocnt <= 0;
               else
                  bcocnt <= bcocnt + 1;
               end if;
            when "10" =>
               if bcocnt>=31 then
                  bcocnt <= 0;
               else
                  bcocnt <= bcocnt + 1;
               end if;
            when others =>
               null;
         end case;
         v_mask := accmask(bcocnt) or srmcemoe(0);
         if enbmaskset='1' then
--          accmask(bcocnt) <= v_mask;
         end if;

         --
         case rstate is
            --initialize
            when RS_INIT_0 =>
               rrcmd <= CMD_INHIBIT;
               rrcke <= '0';
               waitcnt <= cTmin;
               rstate <= RS_INIT_1;
            when RS_INIT_1 =>
               rrcmd <= CMD_INHIBIT;
               if waitcnt>2 then
                  waitcnt <= waitcnt - 1;
               else
                  rstate <= RS_INIT_2;
               end if;
            when RS_INIT_2 =>
               rrcmd <= CMD_NOP;
               rrcke <= '1';
               rstate <= RS_INIT_3;

            when RS_INIT_3 =>
               rrcmd <= CMD_PRECHARGE;
               rra(10) <= '1';   --All banks
               rstate <= RS_INIT_4;
            when RS_INIT_4 =>
               rrcmd <= CMD_NOP;
               rstate <= RS_INIT_REFRESH_0;

            when RS_INIT_REFRESH_0 =>
               rrcmd <= CMD_NOP;
               rfccnt <= 8;
               rstate <= RS_INIT_REFRESH_1;
            when RS_INIT_REFRESH_1 =>
               rrcmd <= CMD_REFRESH;
               waitcnt <= cRFCmin;
               rstate <= RS_INIT_REFRESH_2;
            when RS_INIT_REFRESH_2 =>
               rrcmd <= CMD_NOP;
               if waitcnt>2 then
                  waitcnt <= waitcnt - 1;
               elsif rfccnt>1 then
                  rfccnt <= rfccnt - 1;
                  rstate <= RS_INIT_REFRESH_1;
               else
                  rstate <= RS_INIT_MODE_0;
               end if;

            when RS_INIT_MODE_0 =>
               rrcmd <= CMD_MODE;
               rrba <= "00";
               rra(12 downto 10) <= "000";   --Reserved
               rra(9) <= '1';                --Write Burst Mode
               rra(8 downto 7) <= "00";      --Operating Mode
               rra(6 downto 4) <= "010";     --CAS Latency
               rra(3) <= '0';                --Burst Type
               rra(2 downto 0) <= "000";     --Burst Length
               rstate <= RS_INIT_MODE_1;
            when RS_INIT_MODE_1 =>
               rrcmd <= CMD_NOP;
--             rstate <= RS_INIT_MODE_2;
--          when RS_INIT_MODE_2 =>
--             rrcmd <= CMD_NOP;
               rstate <= RS_IDLE;

            --idle
            when RS_IDLE =>
               rrcmd <= CMD_NOP;
               if srmcemoe="01" then
                  accselect <= '0';
                  ramaddr <= "0" & srma;
                  ramrnw <= '1';
--                brdata <= srma(7 downto 0);
                  rstate <= RS_ACTIVE_0;
               elsif v_mask='0' then
                  if refack/=refreq then
                     rstate <= RS_REFRESH_0;
                  elsif rwack/=rwreq then
                     rwack <= rwreq;
                     accselect <= '1';
                     ramaddr <= "0" & addr;
                     ramrnw <= rnw;
                     ramwdata <= wdata;
                     rstate <= RS_ACTIVE_0;
                  end if;
               end if;

            --refresh
            when RS_REFRESH_0 =>
               rrcmd <= CMD_REFRESH;
               waitcnt <= cRFCmin;
               refack <= refreq;
               rstate <= RS_REFRESH_1;
            when RS_REFRESH_1 =>
               rrcmd <= CMD_NOP;
--             if waitcnt>2 then
               if waitcnt>(2+1) then
                  waitcnt <= waitcnt - 1;
               else
                  rstate <= RS_IDLE;
               end if;

            --active
            when RS_ACTIVE_0 =>
               rrcmd <= CMD_ACTIVE;
               rrba <= ramaddr(24 downto 23);
               rra <= ramaddr(22 downto 10);
               rstate <= RS_ACTIVE_1;
            when RS_ACTIVE_1 =>
               rrcmd <= CMD_NOP;
               if ramrnw='1' then
                  rstate <= RS_READ_0;
               else
                  rstate <= RS_WRITE_0;
               end if;

            --read
            when RS_READ_0 =>
               rrcmd <= CMD_READ;
               rra(10) <= '1';   --Enable auto precharge
               rra(9 downto 0) <= ramaddr(9 downto 0);
               rrdqm <= '0';
               rstate <= RS_READ_1;
            when RS_READ_1 =>
               rrcmd <= CMD_NOP;
               rrdqm <= '1';
               rstate <= RS_READ_2;
            when RS_READ_2 =>
               rrcmd <= CMD_NOP;
               rstate <= RS_READ_3;
            when RS_READ_3 =>
               rrcmd <= CMD_NOP;
               if accselect='0' then
                  brdata <= RDQ;
               else
                  rdata <= RDQ;
               end if;
--             rstate <= RS_READ_4;
--          when RS_READ_4 =>
--             rrcmd <= CMD_NOP;
               rstate <= RS_IDLE;

            --write
            when RS_WRITE_0 =>
               rrcmd <= CMD_WRITE;
               rra(10) <= '1';   --Enable auto precharge
               rra(9 downto 0) <= ramaddr(9 downto 0);
               rrdqm <= '0';
               roe <= '1';
               rstate <= RS_WRITE_1;
            when RS_WRITE_1 =>
               rrcmd <= CMD_NOP;
               rrdqm <= '1';
               roe <= '0';
               rstate <= RS_WRITE_2;
            when RS_WRITE_2 =>
               rrcmd <= CMD_NOP;
--             rstate <= RS_WRITE_3;
--          when RS_WRITE_3 =>
--             rrcmd <= CMD_NOP;
               rstate <= RS_IDLE;

            when others =>
               rstate <= RS_INIT_0;
         end case;

      end if;
   end process;

   --da
   DAnRST <= nIC;
   DAMUTE <= srmute;
   DABCK <= dacbck;
   DALRCK <= daclrck;
   DADATA <= dacdata;
   process(nIC, XI)
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
      elsif XI'event and XI='1' then
         --
         if srblro="10" then
            v_ecnt := (others => '0');
            v_ebcklrckcnt := (others => '0');
         else
            if conv_integer(v_ecnt)<(3-1) then
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
   process(nIC, XI)
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
      elsif XI'event and XI='1' then
         --
         case dstate is
            when DS_INIT =>
               --((1024+4)/16.9344)/(1/16.9344)=1028
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
               --(100e-9)/(1/16.9344e6)=1.69344
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
-- TX <= accmask(bcocnt);
   process(nIC, XI)
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
      elsif XI'event and XI='1' then

         --frame counter
         --  0~191
         if srblro="10" then
            if framecnt="10111111" then
               framecnt <= (others => '0');
            else
               framecnt <= framecnt + 1;
            end if;
         end if;

         --preamble
         if srblro="10" or srblro="00" then
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
               v_cstatus := '0';
            when X"21" =>
               v_cstatus := '1';
            --others
            when others =>
               v_cstatus := '0';
         end case;

         --div counter
         --  0~2
         if srblro="10" then
            divcnt <= (others => '0');
         else
            if divcnt="10" then
               divcnt <= (others => '0');
            else
               divcnt <= divcnt + 1;
            end if;
         end if;

         --bit counter
         --  0~63
         if srblro="10" then
            bitcnt <= (others => '0');
         elsif divcnt="10" then
            bitcnt <= bitcnt + 1;
         end if;

         --status/parity, biphase-mark encode
         if divcnt="10" then
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
   D <= busrdata when(selncs='0' and nRD='0' and nWR='1' and A(1)='1') else "ZZZZZZZZ";
   nIRQ <= '0' when(ienb='1' and BDSPCDI_nIRQ='0') else 'Z';
   process(LOCKED, nIC, RAMCLK)
      variable v_busy: std_logic;
   begin
      if LOCKED='0' or nIC='0' then
         srcswr <= (others => '0');
         srcsrd <= (others => '0');
         sraddr <= (others => '0');
         srdata <= (others => '0');
         regindex <= (others => '0');
         ienb <= '0';
         seloutput <= '0';
         enbspdif <= '0';
         enbmute <= '0';
         atemp <= (others => '0');
         addr <= (others => '0');
         wdata <= (others => '0');
         rnw <= '0';
         rwreq <= '0';
         busrdata <= (others => '0');
      elsif RAMCLK'event and RAMCLK='1' then
         --
         srcswr <= ((not selncs) and (not nWR)) & srcswr(1);
         srcsrd <= ((not selncs) and (not nRD)) & srcsrd(1);
         sraddr <= A(1 downto 0) & sraddr(3 downto 2);
         srdata <= D & srdata(15 downto 8);
         if srcswr="01" then
            case sraddr(1 downto 0) is
               when "00" | "10" =>
                  --pcmd8/fpga, address
                  regindex <= "000" & sraddr(1) & srdata(7 downto 0);
               when "01" | "11" =>
                  --pcmd8/fpga, data
                  case regindex is
                     when X"0ff" =>
                        --pcmd8
                        ienb <= srdata(4);
                     when X"101" =>
                        --fpga, mode
                        --  b5: do/eo select
                        --    0: do
                        --    1: eo
                        --  b4: spdif, enable/disable#
                        --  b3: mute, enable/disable#
                        seloutput <= srdata(5);
                        enbspdif <= srdata(4);
                        enbmute <= srdata(3);
                     when X"102" =>
                        --ram, low address
                        atemp(15 downto 8) <= srdata(7 downto 0);
                        atemp(7 downto 0) <= (others => '0');
                     when X"103" =>
                        --ram, high address
                        atemp(23 downto 16) <= srdata(7 downto 0);
                     when X"108" =>
                        --ram, write data
                        addr <= atemp;
                        atemp <= atemp + 1;
                        wdata <= srdata(7 downto 0);
                        rnw <= '0';
                        rwreq <= not rwreq;
                     when X"118" =>
                        --ram, read data
                        addr <= atemp(23 downto 8) & srdata(7 downto 0);
                        atemp(7 downto 0) <= srdata(7 downto 0);
                        rnw <= '1';
                        rwreq <= not rwreq;
                     when others =>
                        null;
                  end case;
               when others =>
                  null;
            end case;
         end if;
         --
         if srcsrd="10" then
            v_busy := not (rwreq xor rwack);
            case sraddr(3 downto 2) is
               when "00" =>
                  --pcmd8, address
               when "01" =>
                  --pcmd8, data
               when "10" =>
                  --fpga, address
                  busrdata <= (not v_busy) & "000" & v_busy & v_busy & "00";
               when "11" =>
                  --fpga, data
                  case regindex is
                     when X"118" =>
                        --ram, read data
                        busrdata <= rdata;
                     when others =>
                        busrdata <= X"ff";
                  end case;
               when others =>
                  null;
            end case;
         end if;
      end if;
   end process;

   --dipsw
   process(nDSW, nCS, A)
   begin
      if (A(2) xor nDSW(3))='1' then
         selncs <= nCS(conv_integer("11" xor nDSW(1 downto 0)));
      else
         selncs <= '1';
      end if;
   end process;

end rtl;
