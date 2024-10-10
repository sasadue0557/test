library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity msxaudio is
   Port(
      --osc
      CLK: in std_logic;      --14.31818M
      --opll, msxaudio
      ABCLK: out std_logic;   --3.579545M
      ABnIC: out std_logic;   --open drain
      --opll
      AnCS: out std_logic;
      AnWE: out std_logic;
      --msxaudio
      BnCS: out std_logic;
      BnSEL: in std_logic;
      --msxaudio_adpcm
      BA8: in std_logic;
      BDM: inout std_logic_vector(7 downto 0);  --BDM(0):input only
      BDT0: out std_logic;
      BnRAS: in std_logic;
      BnCAS: in std_logic;
      BnWE: in std_logic;
      BMDEN: in std_logic;
      BnROMCS: in std_logic;
      --ram
      RA: out std_logic_vector(18 downto 0);
      RD: inout std_logic_vector(7 downto 0);
      RnRD: out std_logic;
      RnWR: out std_logic;
      RnCS: out std_logic;
      --bus
      A: in std_logic_vector(5 downto 0);
      D: inout std_logic_vector(7 downto 0);
      nRD: in std_logic;
      nWR: in std_logic;
      nCS: in std_logic_vector(3 downto 0);
      nIC: in std_logic;
      --dipsw
      nDSW: in std_logic_vector(3 downto 0)
   );
   --
   attribute BUFG: string;
   attribute BUFG of CLK: signal is "CLK";
   --
   attribute SLEW: string;
   attribute SLEW of ABCLK: signal is "SLOW";
   attribute SLEW of ABnIC: signal is "SLOW";
   attribute SLEW of AnCS: signal is "SLOW";
   attribute SLEW of AnWE: signal is "SLOW";
   attribute SLEW of BnCS: signal is "SLOW";
   attribute SLEW of BDM: signal is "SLOW";
   attribute SLEW of BDT0: signal is "SLOW";
   attribute SLEW of RA: signal is "SLOW";
   attribute SLEW of RD: signal is "SLOW";
   attribute SLEW of RnRD: signal is "SLOW";
   attribute SLEW of RnWR: signal is "SLOW";
   attribute SLEW of RnCS: signal is "SLOW";
   attribute SLEW of D: signal is "SLOW";
   --
   attribute PULLUP: string;
   attribute PULLUP of BnSEL: signal is "TRUE";
-- attribute PULLUP of BA8: signal is "TRUE";
   attribute PULLUP of BDM: signal is "TRUE";
-- attribute PULLUP of BnRAS: signal is "TRUE";
-- attribute PULLUP of BnCAS: signal is "TRUE";
-- attribute PULLUP of BnWE: signal is "TRUE";
-- attribute PULLUP of BMDEN: signal is "TRUE";
-- attribute PULLUP of BnROMCS: signal is "TRUE";
   attribute PULLUP of nDSW: signal is "TRUE";
   --
   attribute LOC: string;
   attribute LOC of CLK: signal is "P127";
   attribute LOC of ABCLK: signal is "P132";
   attribute LOC of ABnIC: signal is "P143";
   attribute LOC of AnCS: signal is "P119";
   attribute LOC of AnWE: signal is "P118";
   attribute LOC of BnCS: signal is "P25";
   attribute LOC of BnSEL: signal is "P72";
   attribute LOC of BA8: signal is "P35";
   attribute LOC of BDM: signal is "P2 P6 P7 P8 P11 P12 P14 P22";
   attribute LOC of BDT0: signal is "P30";
   attribute LOC of BnRAS: signal is "P23";
   attribute LOC of BnCAS: signal is "P26";
   attribute LOC of BnWE: signal is "P27";
   attribute LOC of BMDEN: signal is "P29";
   attribute LOC of BnROMCS: signal is "P31";
   attribute LOC of RA: signal is "P94 P93 P92 P91 P75 P77 P78 P80 P81 P108 P109 P110 P112 P113 P101 P100 P98 P97 P96";
   attribute LOC of RD: signal is "P86 P84 P83 P74 P116 P107 P106 P103";
   attribute LOC of RnRD: signal is "P87";
   attribute LOC of RnWR: signal is "P114";
   attribute LOC of RnCS: signal is "P102";
   attribute LOC of A: signal is "P42 P43 P44 P47 P53 P48";
   attribute LOC of D: signal is "P49 P54 P56 P61 P63 P66 P69 P71";
   attribute LOC of nRD: signal is "P60";
   attribute LOC of nWR: signal is "P55";
   attribute LOC of nCS: signal is "P70 P67 P65 P62";
   attribute LOC of nIC: signal is "P46";
   attribute LOC of nDSW: signal is "P40 P39 P38 P37";
end msxaudio;

architecture rtl of msxaudio is
   --
   subtype sb_odoutst is std_logic_vector(1 downto 0);
   function odout(st: sb_odoutst) return std_logic is
      variable v_temp: std_logic;
   begin
      case st is
         when "11" | "01" =>
            v_temp := '0';
         when "10" =>
            v_temp := '1';
         when others =>
            v_temp := 'Z';
      end case;
      return v_temp;
   end function;
   --osc
   signal clk14div4: std_logic_vector(1 downto 0);
   --opll, msxaudio
   --opll
   --msxaudio
   --msxaudio_adpcm
   signal srpa8: std_logic;
   signal srpdm: std_logic_vector(7 downto 0);
   signal srpras: std_logic_vector(1 downto 0);
   signal srpcas: std_logic_vector(1 downto 0);
   signal srpwe: std_logic_vector(1 downto 0);
   signal srpmden: std_logic_vector(1 downto 0);
   signal srpromcs: std_logic_vector(1 downto 0);
   signal paddr: std_logic_vector(RA'range);
   signal pwdata: std_logic_vector(RD'range);
   signal prnw: std_logic;
   signal prwreq: std_logic;
   --ram
   type ram_state is (
      RS_IDLE,
      RS_READ_0, RS_READ_0B, RS_READ_1, RS_READ_1B, RS_READ_2,
      RS_WRITE_0, RS_WRITE_0B, RS_WRITE_1, RS_WRITE_1B, RS_WRITE_2
   );
   signal rstate: ram_state;
   signal ramaddr: std_logic_vector(RA'range);
   signal ramwdata: std_logic_vector(RD'range);
   signal ramrd: std_logic;
   signal ramwr: std_logic;
   signal ramcs: std_logic;
   signal prdata: std_logic_vector(RD'range);
   signal prwack: std_logic;
   signal rdata: std_logic_vector(RD'range);
   signal rwack: std_logic;
   --bus
   signal srcswr: std_logic_vector(1 downto 0);
   signal srcsrd: std_logic_vector(1 downto 0);
   signal regindex: std_logic_vector(7 downto 0);
   signal atemp: std_logic_vector(7 downto 0);
   signal addr: std_logic_vector(RA'range);
   signal wdata: std_logic_vector(RD'range);
   signal rnw: std_logic;
   signal rwreq: std_logic;
   signal busrdata: std_logic_vector(7 downto 0);
   --dipsw
   signal selncs: std_logic;
begin

   --osc
   process(CLK)
   begin
      if CLK'event and CLK='1' then
         --3.579545M, 14.31818M/4
         clk14div4 <= clk14div4(0) & (not clk14div4(1));
      end if;
   end process;

   --opll, msxaudio
   ABCLK <= clk14div4(0);
-- ABnIC <= '0' when(nIC='0') else 'Z';
   process(nIC, CLK)
      variable v_st: sb_odoutst;
   begin
      if nIC='0' then
         v_st := (others => '1');
      elsif CLK'event and CLK='1' then
         v_st := v_st(0) & '0';
      end if;
      ABnIC <= odout(v_st);
   end process;

   --opll
   AnCS <= '0' when(selncs='0' and (nRD='0' or nWR='0') and A(2)='0') else '1';
   AnWE <= '0' when(selncs='0' and nWR='0' and A(2)='0') else '1';

   --msxaudio
   BnCS <= '0' when(selncs='0' and A(2 downto 1)="10") else '1';

   --msxaudio_adpcm
   BDM(7 downto 1) <= prdata(7 downto 1) when(BnRAS='0' and BnCAS='0' and (BMDEN='1' or BnROMCS='0') and BnWE='1') else
      "ZZZZZZZ";
   BDM(0) <= 'Z';
   BDT0 <= prdata(0);
   process(nIC, CLK)
   begin
      if nIC='0' then
         srpa8 <= '0';
         srpdm <= (others => '0');
         srpras <= (others => '0');
         srpcas <= (others => '0');
         srpwe <= (others => '0');
         srpmden <= (others => '0');
         srpromcs <= (others => '0');
         paddr <= (others => '0');
         pwdata <= (others => '0');
         prnw <= '0';
         prwreq <= '0';
      elsif CLK'event and CLK='1' then
         --
         srpa8 <= BA8;
         srpdm <= BDM;
         srpras <= srpras(0) & (not BnRAS);
         srpcas <= srpcas(0) & (not BnCAS);
         srpwe <= srpwe(0) & (not BnWE);
         srpmden <= srpmden(0) & BMDEN;
         srpromcs <= srpromcs(0) & (not BnROMCS);
         --
         if srpras="01" and srpcas(0)='0' then
            paddr(8 downto 0) <= srpa8 & srpdm;
         end if;
         if srpras(0)='1' and srpcas="01" then
            paddr(17 downto 9) <= srpa8 & srpdm;
         end if;
         --
         if srpras(0)='1' and srpcas(0)='1' then
            if srpmden="01" or srpwe="01" then
               --ram read/write
               paddr(18) <= '1';
               pwdata <= srpdm;
               prnw <= srpmden(0);
               prwreq <= not prwreq;
            elsif srpromcs="01" then
               --rom read
               paddr(18) <= '0';
               prnw <= '1';
               prwreq <= not prwreq;
            end if;
         end if;
      end if;
   end process;

   --ram
   RA <= ramaddr;
   RD <= ramwdata when(ramwr='1') else "ZZZZZZZZ";
   RnRD <= '0' when(ramrd='1') else '1';
   RnWR <= '0' when(ramwr='1') else '1';
   RnCS <= '0' when(ramcs='1') else '1';
   process(nIC, CLK)
   begin
      if nIC='0' then
         rstate <= RS_IDLE;
         ramaddr <= (others => '0');
         ramwdata <= (others => '0');
         ramrd <= '0';
         ramwr <= '0';
         ramcs <= '0';
         prdata <= X"80";
         prwack <= '0';
         rdata <= X"80";
         rwack <= '0';
      elsif CLK'event and CLK='1' then
         --
         case rstate is
            when RS_IDLE =>
               ramrd <= '0';
               ramwr <= '0';
               ramcs <= '0';
               if prwack/=prwreq then
                  if prnw='0' then
                     rstate <= RS_WRITE_0;
                  else
                     rstate <= RS_READ_0;
                  end if;
               elsif rwack/=rwreq then
                  if rnw='0' then
                     rstate <= RS_WRITE_0B;
                  else
                     rstate <= RS_READ_0B;
                  end if;
               end if;

            when RS_READ_0 =>
               ramaddr <= paddr;
               ramrd <= '1';
               ramcs <= '1';
               rstate <= RS_READ_1;
            when RS_READ_0B =>
               ramaddr <= addr;
               ramrd <= '1';
               ramcs <= '1';
               rstate <= RS_READ_1B;
            when RS_READ_1 =>
               prdata <= RD;
               prwack <= prwreq;
               rstate <= RS_READ_2;
            when RS_READ_1B =>
               rdata <= RD;
               rwack <= rwreq;
               rstate <= RS_READ_2;
            when RS_READ_2 =>
               ramrd <= '0';
               ramcs <= '0';
               rstate <= RS_IDLE;

            when RS_WRITE_0 =>
               ramaddr <= paddr;
               ramwdata <= pwdata;
               ramwr <= '1';
               ramcs <= '1';
               rstate <= RS_WRITE_1;
            when RS_WRITE_0B =>
               ramaddr <= addr;
               ramwdata <= wdata;
               ramwr <= '1';
               ramcs <= '1';
               rstate <= RS_WRITE_1B;
            when RS_WRITE_1 =>
               prwack <= prwreq;
               rstate <= RS_WRITE_2;
            when RS_WRITE_1B =>
               rwack <= rwreq;
               rstate <= RS_WRITE_2;
            when RS_WRITE_2 =>
               ramwr <= '0';
               ramcs <= '0';
               rstate <= RS_IDLE;

            when others =>
               rstate <= RS_IDLE;
         end case;
      end if;
   end process;

   --bus
   D <= busrdata when(selncs='0' and nRD='0' and nWR='1' and A(2 downto 1)="11") else "ZZZZZZZZ";
   process(nIC, CLK)
      variable v_busy: std_logic;
   begin
      if nIC='0' then
         srcswr <= (others => '0');
         srcsrd <= (others => '0');
         regindex <= (others => '0');
         atemp <= (others => '0');
         addr <= (others => '0');
         wdata <= (others => '0');
         rnw <= '0';
         rwreq <= '0';
         busrdata <= (others => '0');
      elsif CLK'event and CLK='1' then
         --
         srcswr <= srcswr(0) & ((not selncs) and (not nWR));
         srcsrd <= srcsrd(0) & ((not selncs) and (not nRD));
         if srcswr="01" then
            case A(2 downto 0) is
               when "000" | "010" =>
                  --opll, address
               when "001" | "011" =>
                  --opll, data
               when "100" =>
                  --msxaudio, address
               when "101" =>
                  --msxaudio, data
               when "110" =>
                  --cpld, address
                  regindex <= "000" & D(4 downto 0);
               when "111" =>
                  --cpld, data
                  case regindex is
                     when X"01" =>
                        --cpld, mode
                     when X"02" =>
                        --ram, low address
                        addr(15 downto 8) <= D;
                        atemp <= (others => '0');
                     when X"03" =>
                        --ram, high address
                        --  b2: rom/ram select
                        --    0: rom
                        --    1: ram
                        addr(18 downto 16) <= D(2 downto 0);
                     when X"08" =>
                        --ram, write data
                        addr(7 downto 0) <= atemp;
                        atemp <= atemp + 1;
                        wdata <= D;
                        rnw <= '0';
                        rwreq <= not rwreq;
                     when X"18" =>
                        --ram, read data
                        addr(7 downto 0) <= D;
                        atemp <= D;
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
         if srcsrd="01" then
            v_busy := not (rwreq xor rwack);
            case A(2 downto 0) is
               when "000" | "010" =>
                  --opll, address
               when "001" | "011" =>
                  --opll, data
               when "100" =>
                  --msxaudio, address
               when "101" =>
                  --msxaudio, data
               when "110" =>
                  --cpld, address
                  busrdata <= (not v_busy) & "000" & v_busy & v_busy & "00";
               when "111" =>
                  --cpld, data
                  busrdata <= rdata;
               when others =>
                  null;
            end case;
         end if;
      end if;
   end process;

   --dipsw
   process(nDSW, nCS, A)
   begin
      if (A(3) xor nDSW(3))='1' then
         selncs <= nCS(conv_integer("11" xor nDSW(1 downto 0)));
      else
         selncs <= '1';
      end if;
   end process;

end rtl;
