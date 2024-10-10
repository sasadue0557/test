
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity opnb is
   Port(
      --osc
      CLK: in std_logic;      --32M
      --opnb
      BPhiM: out std_logic;   --8M
      BA: out std_logic_vector(1 downto 0);
      BnRD: out std_logic;
      BnWR: out std_logic;
      BnCS: out std_logic;
      BnIC: out std_logic;
      --opnb_adpcm-a
      BRA23: in std_logic;
      BRA22: in std_logic;
      BRA21: in std_logic;
      BRA20: in std_logic;
      BRAD: inout std_logic_vector(7 downto 0);
      BRA9: in std_logic;
      BRA8: in std_logic;
      BRMPX: in std_logic;
      BnROE: in std_logic;
      --opnb_adpcm-b
      BPAD: inout std_logic_vector(7 downto 0);
      BPA11: in std_logic;
      BPA10: in std_logic;
      BPA9: in std_logic;
      BPA8: in std_logic;
      BPMPX: in std_logic;
      BnPOE: in std_logic;
      --ram
      MDQ: inout std_logic_vector(7 downto 0);
      MnWE: out std_logic;
      MnCAS: out std_logic;
      MnRAS: out std_logic;
      MnCS: out std_logic;
      MBA: out std_logic_vector(1 downto 0);
      MA: out std_logic_vector(12 downto 0);
      MCKE: out std_logic;
      MDQM: out std_logic;
      --vol
      VnCS: out std_logic;
      VSCLK: out std_logic;
      VSDI: out std_logic;
      --bus
      A: in std_logic_vector(2 downto 0);
      nRD: in std_logic;
      nWR: in std_logic;
      nCS: in std_logic_vector(3 downto 0);
      D: inout std_logic_vector(7 downto 0);
      nIC: in std_logic;
      --dipsw
      nDSW: in std_logic_vector(3 downto 0);
      --jtag
      JTAG: in std_logic_vector(3 downto 0)
   );
   --
   attribute BUFG: string;
   attribute BUFG of CLK: signal is "CLK";
   --
   attribute SLEW: string;
   attribute SLEW of BPhiM: signal is "SLOW";
   attribute SLEW of BA: signal is "SLOW";
   attribute SLEW of BnRD: signal is "SLOW";
   attribute SLEW of BnWR: signal is "SLOW";
   attribute SLEW of BnCS: signal is "SLOW";
   attribute SLEW of BnIC: signal is "SLOW";
   attribute SLEW of BRAD: signal is "SLOW";
   attribute SLEW of BPAD: signal is "SLOW";
   attribute SLEW of MDQ: signal is "SLOW";
   attribute SLEW of MnWE: signal is "SLOW";
   attribute SLEW of MnCAS: signal is "SLOW";
   attribute SLEW of MnRAS: signal is "SLOW";
   attribute SLEW of MnCS: signal is "SLOW";
   attribute SLEW of MBA: signal is "SLOW";
   attribute SLEW of MA: signal is "SLOW";
   attribute SLEW of MCKE: signal is "SLOW";
   attribute SLEW of MDQM: signal is "SLOW";
   attribute SLEW of VnCS: signal is "SLOW";
   attribute SLEW of VSCLK: signal is "SLOW";
   attribute SLEW of VSDI: signal is "SLOW";
   attribute SLEW of D: signal is "SLOW";
   --
   attribute PULLUP: boolean;
   attribute PULLUP of nDSW: signal is TRUE;
   --
   attribute LOC: string;
   attribute LOC of CLK: signal is "P126";
   attribute LOC of BPhiM: signal is "P1";
   attribute LOC of BA: signal is "P5,P6";
   attribute LOC of BnRD: signal is "P7";
   attribute LOC of BnWR: signal is "P8";
   attribute LOC of BnCS: signal is "P9";
   attribute LOC of BnIC: signal is "P48";
   attribute LOC of BRA23: signal is "P43";
   attribute LOC of BRA22: signal is "P44";
   attribute LOC of BRA21: signal is "P45";
   attribute LOC of BRA20: signal is "P46";
   attribute LOC of BRAD: signal is "P12,P15,P18,P21,P25,P27,P29,P31";
   attribute LOC of BRA9: signal is "P39";
   attribute LOC of BRA8: signal is "P41";
   attribute LOC of BRMPX: signal is "P34";
   attribute LOC of BnROE: signal is "P36";
   attribute LOC of BPAD: signal is "P10,P11,P14,P16,P19,P23,P26,P28";
   attribute LOC of BPA11: signal is "P35";
   attribute LOC of BPA10: signal is "P38";
   attribute LOC of BPA9: signal is "P40";
   attribute LOC of BPA8: signal is "P42";
   attribute LOC of BPMPX: signal is "P30";
   attribute LOC of BnPOE: signal is "P32";
   attribute LOC of MDQ: signal is "P103,P102,P101,P100,P90,P91,P92,P93";
   attribute LOC of MnWE: signal is "P88";
   attribute LOC of MnCAS: signal is "P87";
   attribute LOC of MnRAS: signal is "P84";
   attribute LOC of MnCS: signal is "P83";
   attribute LOC of MBA: signal is "P81,P82";
   attribute LOC of MA: signal is "P71,P70,P80,P69,P67,P66,P65,P63,P62,P74,P75,P78,P79";
   attribute LOC of MCKE: signal is "P72";
   attribute LOC of MDQM: signal is "P97";
   attribute LOC of VnCS: signal is "P54";
   attribute LOC of VSCLK: signal is "P49";
   attribute LOC of VSDI: signal is "P53";
   attribute LOC of A: signal is "P116,P119,P117";
   attribute LOC of nRD: signal is "P133";
   attribute LOC of nWR: signal is "P122";
   attribute LOC of nCS: signal is "P142,P140,P138,P136";
   attribute LOC of D: signal is "P118,P120,P132,P134,P137,P139,P141,P143";
   attribute LOC of nIC: signal is "P128";
   attribute LOC of nDSW: signal is "P113,P112,P111,P110";
   attribute LOC of JTAG: signal is "P86,P131,P121,P22"; --xcr3256
-- attribute LOC of JTAG: signal is "P89,P4,P104,P20";      --xcr3384
end opnb;

architecture rtl of opnb is
   --osc
   signal clk32div4: std_logic_vector(1 downto 0);
   --opnb
   --opnb_adpcm-a
   signal srrmpx: std_logic_vector(1 downto 0);
   signal ra: std_logic_vector(23 downto 0);
   signal rreq: std_logic;
   --opnb_adpcm-b
   signal srpmpx: std_logic_vector(1 downto 0);
   signal pa: std_logic_vector(23 downto 0);
   signal preq: std_logic;
   --ram_setting
   constant tRFCmin: integer := 3;
   constant tRFC: integer := 250;
   --ram
   signal refcnt: std_logic_vector(7 downto 0);
   signal refreq: std_logic;
   type mem_state is (
      --initialize
      MS_INIT_0, MS_INIT_1, MS_INIT_2,
      MS_INIT_REFRESH_0, MS_INIT_REFRESH_1,
      MS_INIT_MODE_0, MS_INIT_MODE_1, MS_INIT_MODE_2,
      --idle
      MS_IDLE,
      --refresh
      MS_REFRESH_0, MS_REFRESH_1,
      --read
      MS_READ_0, MS_READ_1, MS_READ_2, MS_READ_3, MS_READ_4,
      --write
      MS_WRITE_0, MS_WRITE_1, MS_WRITE_2,
      --precharge
      MS_PRECHARGE
   );
   signal mstate: mem_state;
   signal rfccnt: std_logic_vector(2 downto 0);
   signal rfcwcnt: std_logic_vector(1 downto 0);
   signal mmdq: std_logic_vector(7 downto 0);
   signal mmcmd: std_logic_vector(3 downto 0);
   signal mmba: std_logic_vector(1 downto 0);
   signal mma: std_logic_vector(12 downto 0);
   signal mmcke: std_logic;
   signal mmdqm: std_logic;
   signal moe: std_logic;
   signal madr: std_logic_vector(24 downto 0);
   signal rad: std_logic_vector(7 downto 0);
   signal rack: std_logic;
   signal pad: std_logic_vector(7 downto 0);
   signal pack: std_logic;
   signal refack: std_logic;
   signal wack: std_logic;
   --ram_command
-- constant CMD_NOP       : std_logic_vector(3 downto 0) := "1000";
   constant CMD_NOP       : std_logic_vector(3 downto 0) := "0111";
   constant CMD_ACTIVE    : std_logic_vector(3 downto 0) := "0011";
   constant CMD_READ      : std_logic_vector(3 downto 0) := "0101";
   constant CMD_WRITE     : std_logic_vector(3 downto 0) := "0100";
   constant CMD_PRECHARGE : std_logic_vector(3 downto 0) := "0010";
   constant CMD_REFRESH   : std_logic_vector(3 downto 0) := "0001";
   constant CMD_MODE      : std_logic_vector(3 downto 0) := "0000";
   --vol
   type vol_state is ( VS_WAIT, VS_IDLE, VS_WRITE_0, VS_WRITE_1 );
   signal vstate: vol_state;
   signal vcnt: std_logic_vector(4 downto 0);
   signal vack: std_logic;
   --bus
   signal sric: std_logic_vector(1 downto 0);
   signal srwrcs: std_logic_vector(1 downto 0);
   signal srrdcs: std_logic_vector(1 downto 0);
   signal regnum: std_logic_vector(3 downto 0);
   signal wadr: std_logic_vector(24 downto 0);
   signal wa: std_logic_vector(7 downto 0);
   signal wdat: std_logic_vector(7 downto 0);
   signal wreq: std_logic;
   signal vdat: std_logic_vector(7 downto 0);
   signal vreq: std_logic;
   signal rdat: std_logic_vector(7 downto 0);
   --dipsw
   signal selncs: std_logic;
begin

   --osc
   process(CLK)
   begin
      if CLK'event and CLK='1' then
         --8M, 32M/4
         clk32div4 <= clk32div4(0) & (not clk32div4(1));
      end if;
   end process;

   --opnb
   BPhiM <= clk32div4(1);
   BA <= A(1 downto 0);
   BnRD <= nRD;
   BnWR <= nWR;
   BnCS <= '0' when(A(2)='0' and selncs='0') else '1';
   BnIC <= '0' when(sric(0)='0') else '1' when(sric(1)='0') else 'Z';

   --opnb_adpcm-a
   BRAD <= rad when(BnROE='0') else "ZZZZZZZZ";
   process(nIC, CLK)
   begin
      if nIC='0' then
         srrmpx <= (others => '0');
         ra <= (others => '0');
         rreq <= '0';
      elsif CLK'event and CLK='1' then
         --
         srrmpx <= srrmpx(0) & BRMPX;
         case srrmpx is
            when "01" =>
               ra(9 downto 0) <= BRA9 & BRA8 & BRAD;
            when "10" =>
               ra(23 downto 20) <= BRA23 & BRA22 & BRA21 & BRA20;
               ra(19 downto 10) <= BRA9 & BRA8 & BRAD;
               rreq <= not rreq;
            when others =>
               null;
         end case;
      end if;
   end process;

   --opnb_adpcm-b
   BPAD <= pad when(BnPOE='0') else "ZZZZZZZZ";
   process(nIC, CLK)
   begin
      if nIC='0' then
         srpmpx <= (others => '0');
         pa <= (others => '0');
         preq <= '0';
      elsif CLK'event and CLK='1' then
         --
         srpmpx <= srpmpx(0) & BPMPX;
         case srpmpx is
            when "01" =>
               pa(11 downto 0) <= BPA11 & BPA10 & BPA9 & BPA8 & BPAD;
            when "10" =>
               pa(23 downto 12) <= BPA11 & BPA10 & BPA9 & BPA8 & BPAD;
               preq <= not preq;
            when others =>
               null;
         end case;
      end if;
   end process;

   --ram
   MDQ <= mmdq when(moe='1') else "ZZZZZZZZ";
   MnWE <= mmcmd(0);
   MnCAS <= mmcmd(1);
   MnRAS <= mmcmd(2);
   MnCS <= mmcmd(3);
   MBA <= mmba;
   MA <= mma;
   MCKE <= mmcke;
   MDQM <= mmdqm;
   process(nIC, CLK)
   begin
      if nIC='0' then
         refcnt <= (others => '0');
         refreq <= '0';
         mstate <= MS_INIT_0;
         rfccnt <= conv_std_logic_vector(8-1, rfccnt'length);
         rfcwcnt <= (others => '0');
         mmdq <= (others => '0');
         mmcmd <= CMD_NOP;
         mmba <= (others => '0');
         mma <= (others => '0');
--       mmcke <= '0';
         mmcke <= '1';
         mmdqm <= '1';
         moe <= '0';
         madr <= (others => '0');
         rad <= (others => '0');
         rack <= '0';
         pad <= (others => '0');
         pack <= '0';
         refack <= '0';
         wack <= '0';
      elsif CLK'event and CLK='1' then

         --
         if refcnt=conv_std_logic_vector(0, refcnt'length) then
            refcnt <= conv_std_logic_vector(tRFC-1, refcnt'length);
            refreq <= not refreq;
         else
            refcnt <= refcnt - 1;
         end if;

         --
         case mstate is
            --initialize
            when MS_INIT_0 =>
               mmcmd <= CMD_NOP;
               mmcke <= '1';
               mstate <= MS_INIT_1;

            when MS_INIT_1 =>
               mmcmd <= CMD_NOP;
               mstate <= MS_INIT_2;
            when MS_INIT_2 =>
               mmcmd <= CMD_PRECHARGE;
               mma(10) <= '1';   --All banks
               mstate <= MS_INIT_REFRESH_0;

            when MS_INIT_REFRESH_0 =>
               mmcmd <= CMD_REFRESH;
               rfcwcnt <= conv_std_logic_vector(tRFCmin-2, rfcwcnt'length);
               mstate <= MS_INIT_REFRESH_1;
            when MS_INIT_REFRESH_1 =>
               mmcmd <= CMD_NOP;
               if rfcwcnt/=conv_std_logic_vector(0, rfcwcnt'length) then
                  rfcwcnt <= rfcwcnt - 1;
               elsif rfccnt/=conv_std_logic_vector(0, rfccnt'length) then
                  rfccnt <= rfccnt - 1;
                  mstate <= MS_INIT_REFRESH_0;
               else
                  mstate <= MS_INIT_MODE_0;
               end if;

            when MS_INIT_MODE_0 =>
               mmcmd <= CMD_MODE;
               mmba <= "00";
               mma(12 downto 10) <= "000";   --Reserved
               mma(9) <= '1';                --Write Burst Mode
               mma(8 downto 7) <= "00";      --Operating Mode
               mma(6 downto 4) <= "010";     --CAS Latency
               mma(3) <= '0';                --Burst Type
               mma(2 downto 0) <= "000";     --Burst Length
               mstate <= MS_INIT_MODE_1;
            when MS_INIT_MODE_1 =>
               mmcmd <= CMD_NOP;
--             mstate <= MS_INIT_MODE_2;
--          when MS_INIT_MODE_2 =>
--             mmcmd <= CMD_NOP;
               mstate <= MS_IDLE;

            --idle
            when MS_IDLE =>
               mmcmd <= CMD_NOP;
               if pack/=preq then
                  madr <= "0" & pa;
                  mstate <= MS_READ_0;
               elsif rack/=rreq then
                  madr <= "1" & ra;
                  mstate <= MS_READ_0;
               elsif refack/=refreq then
                  madr <= wadr;
                  mmdq <= wdat;
                  mstate <= MS_REFRESH_0;
               elsif wack/=wreq then
                  madr <= wadr;
                  mmdq <= wdat;
                  mstate <= MS_WRITE_0;
               end if;

            --refresh
            when MS_REFRESH_0 =>
               mmcmd <= CMD_REFRESH;
               rfcwcnt <= conv_std_logic_vector(tRFCmin-2, rfcwcnt'length);
               refack <= refreq;
               mstate <= MS_REFRESH_1;
            when MS_REFRESH_1 =>
               mmcmd <= CMD_NOP;
               if rfcwcnt/=conv_std_logic_vector(0, rfcwcnt'length) then
                  rfcwcnt <= rfcwcnt - 1;
               else
                  mstate <= MS_IDLE;
               end if;

            --read
            when MS_READ_0 =>
               mmcmd <= CMD_ACTIVE;
               mmba <= madr(24 downto 23);
               mma <= madr(22 downto 10);
               if madr(24)='0' then
                  pack <= preq;
               else
                  rack <= rreq;
               end if;
               mstate <= MS_READ_1;
            when MS_READ_1 =>
               mmcmd <= CMD_READ;
               mma(10) <= '0';   --Disable auto precharge
               mma(9 downto 0) <= madr(9 downto 0);
               mmdqm <= '0';
               mstate <= MS_READ_2;
            when MS_READ_2 =>
               mmcmd <= CMD_NOP;
               mmdqm <= '1';
               mstate <= MS_READ_3;
            when MS_READ_3 =>
               mmcmd <= CMD_NOP;
               mstate <= MS_READ_4;
            when MS_READ_4 =>
               mmcmd <= CMD_NOP;
               if madr(24)='0' then
                  pad <= MDQ;
               else
                  rad <= MDQ;
               end if;
               mstate <= MS_PRECHARGE;

            --write
            when MS_WRITE_0 =>
               mmcmd <= CMD_ACTIVE;
               mmba <= madr(24 downto 23);
               mma <= madr(22 downto 10);
               wack <= wreq;
               mstate <= MS_WRITE_1;
            when MS_WRITE_1 =>
               mmcmd <= CMD_WRITE;
               mma(10) <= '0';   --Disable auto precharge
               mma(9 downto 0) <= madr(9 downto 0);
               mmdqm <= '0';
               moe <= '1';
               mstate <= MS_WRITE_2;
            when MS_WRITE_2 =>
               mmcmd <= CMD_NOP;
               mmdqm <= '1';
               moe <= '0';
               mstate <= MS_PRECHARGE;

            --precharge
            when MS_PRECHARGE =>
               mmcmd <= CMD_PRECHARGE;
               mma(10) <= '1';   --All banks
               mstate <= MS_IDLE;

            when others =>
               mstate <= MS_INIT_0;
         end case;

      end if;
   end process;

   --vol
   process(nIC, CLK)
   begin
      if nIC='0' then
         vstate <= VS_WAIT;
         vcnt <= (others => '1');
         vack <= '0';
         VnCS <= '1';
         VSCLK <= '0';
         VSDI <= '0';
      elsif CLK'event and CLK='1' then
         --
         if clk32div4="00" then
            case vstate is
               when VS_WAIT =>
                  VnCS <= '1';
                  VSCLK <= '0';
                  VSDI <= '0';
                  vstate <= VS_IDLE;
               when VS_IDLE =>
                  VnCS <= '1';
                  VSCLK <= '0';
                  VSDI <= '0';
                  vcnt <= (others => '1');
                  if vack/=vreq then
                     vstate <= VS_WRITE_0;
                  end if;
               when VS_WRITE_0 =>
                  VnCS <= '0';
                  VSCLK <= not vcnt(0);
                  VSDI <= vdat(conv_integer(vcnt(3 downto 1)));
                  vcnt <= vcnt - 1;
                  if vcnt="00000" then
                     vstate <= VS_WRITE_1;
                  end if;
               when VS_WRITE_1 =>
                  VnCS <= '0';
                  VSCLK <= '0';
                  VSDI <= '0';
                  vack <= vreq;
                  vstate <= VS_IDLE;
               when others =>
                  vstate <= VS_IDLE;
            end case;
         end if;
      end if;
   end process;

   --bus
   D <= rdat when(A(2)='1' and selncs='0' and nRD='0') else "ZZZZZZZZ";
   process(nIC, CLK)
      variable busy: std_logic;
   begin
      if nIC='0' then
         sric <= (others => '0');
         srwrcs <= (others => '0');
         srrdcs <= (others => '0');
         regnum <= (others => '0');
         wadr <= (others => '0');
         wa <= (others => '0');
         wdat <= (others => '0');
         wreq <= '0';
         vdat <= (others => '0');
         vreq <= '0';
         rdat <= (others => '0');
      elsif CLK'event and CLK='1' then

         --reset
         sric <= sric(0) & '1';

         --register
         srwrcs <= srwrcs(0) & (A(2) and (not selncs) and (not nWR));
         if srwrcs="01" then
            --write
            case A(1 downto 0) is
               when "00" | "10" =>
                  regnum <= D(3 downto 0);
               when "01" | "11" =>
                  case regnum is
                     when X"1" =>
                        --ram, adpcm-a/b select
                        --  0: adpcm-b
                        --  1: adpcm-a
                        wadr(24) <= D(0);
                     when X"2" =>
                        --ram, low address
                        wadr(15 downto 8) <= D;
                        wa <= (others => '0');
                     when X"3" =>
                        --ram, high address
                        wadr(23 downto 16) <= D;
                     when X"8" =>
                        --ram, data
                        wadr(7 downto 0) <= wa;
                        wa <= wa + 1;
                        wdat <= D;
                        wreq <= not wreq;
                     when X"b" =>
                        --opnb, fm volume
                        --  $00: mute
                        --  $01~$ff: min~max
                        vdat <= D;
                        vreq <= not vreq;
                     when others =>
                        null;
                  end case;
               when others =>
                  null;
            end case;
         end if;

         --register
         srrdcs <= srrdcs(0) & (A(2) and (not selncs) and (not nRD));
         if srrdcs="01" then
            --read
--          busy := not (wreq xor wack);
            busy := not ((wreq xor wack) or (vreq xor vack));
            case A(1 downto 0) is
               when "00" | "10" =>
                  rdat <= (not busy) & "000" & busy & busy & "00";
               when "01" | "11" =>
                  rdat <= (not busy) & "000" & busy & busy & "00";
               when others =>
                  null;
            end case;
         end if;

      end if;
   end process;

   --dipsw
   process(nDSW, nCS)
      variable n: integer;
   begin
      --cs select
      n := conv_integer("11" xor nDSW(1 downto 0));
      selncs <= nCS(n);
   end process;

end rtl;



--
--  Synthesis
--   FSM Encoding Algorithm: Compact
--   Others: Default
--
--  Fitting
--   Preserve Unused Inputs: Enable
--   Others: Default
--
