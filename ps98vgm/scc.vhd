library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity scc is
   Port(
      --osc
      CLK: in std_logic;      --14.31818M
      --psg/ssg, scc/052539
      ABD: inout std_logic_vector(7 downto 0);
      ABnRESET: out std_logic;   --open drain
      --psg/ssg
      APhiM: out std_logic;   --1.7897725M(AnPSEL=open|high)/3.579545M(AnPSEL=low)
      AnPSEL: in std_logic;
      ABDIR: out std_logic;
      ABC1: out std_logic;
      --scc/052539
      BCLOCK: out std_logic;  --3.579545M
      BA: out std_logic_vector(15 downto 0);
      BnRD: out std_logic;
      BnWR: out std_logic;
      BnSLTSL: out std_logic;
      BnRFSH: out std_logic;
      BFref: in std_logic;
      --da
      DACLK: out std_logic;   --16374, 3.579545M_180deg
--    DAnOE: out std_logic;   --16245
      DABIT: out std_logic;
      --bus
      A: in std_logic_vector(7 downto 0);
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
   --
   attribute SLEW: string;
   attribute SLEW of ABD: signal is "SLOW";
   attribute SLEW of ABnRESET: signal is "SLOW";
   attribute SLEW of APhiM: signal is "SLOW";
   attribute SLEW of ABDIR: signal is "SLOW";
   attribute SLEW of ABC1: signal is "SLOW";
   attribute SLEW of BCLOCK: signal is "SLOW";
   attribute SLEW of BA: signal is "SLOW";
   attribute SLEW of BnRD: signal is "SLOW";
   attribute SLEW of BnWR: signal is "SLOW";
   attribute SLEW of BnSLTSL: signal is "SLOW";
   attribute SLEW of BnRFSH: signal is "SLOW";
   attribute SLEW of DACLK: signal is "SLOW";   --16374
-- attribute SLEW of DAnOE: signal is "SLOW";   --16245
   attribute SLEW of DABIT: signal is "SLOW";
   attribute SLEW of D: signal is "SLOW";
   attribute SLEW of nIRQ: signal is "SLOW";
   --
   attribute PULLUP: string;
   attribute PULLUP of AnPSEL: signal is "TRUE";
   attribute PULLUP of BFref: signal is "TRUE";
   attribute PULLUP of nDSW: signal is "TRUE";
   --
   attribute LOC: string;
   attribute LOC of CLK: signal is "P88";
   attribute LOC of ABD: signal is "P28 P25 P22 P19 P12 P8 P7 P6";
   attribute LOC of ABnRESET: signal is "P21";
   attribute LOC of APhiM: signal is "P50";
   attribute LOC of AnPSEL: signal is "P71";
   attribute LOC of ABDIR: signal is "P37";
   attribute LOC of ABC1: signal is "P31";
   attribute LOC of BCLOCK: signal is "P27";
   attribute LOC of BA: signal is "P23 P41 P40 P36 P30 P29 P24 P35 P33 P32 P42 P44 P48 P47 P45 P46";
   attribute LOC of BnRD: signal is "P13";
   attribute LOC of BnWR: signal is "P20";
   attribute LOC of BnSLTSL: signal is "P9";
   attribute LOC of BnRFSH: signal is "P10";
   attribute LOC of BFref: signal is "P17";
   attribute LOC of DACLK: signal is "P2";   --16374
-- attribute LOC of DAnOE: signal is "P2";   --16245
   attribute LOC of DABIT: signal is "P100";
   attribute LOC of A: signal is "P56 P55 P58 P57 P65 P67 P77 P70";
   attribute LOC of D: signal is "P69 P76 P78 P80 P83 P92 P94 P97";
   attribute LOC of nRD: signal is "P81";
   attribute LOC of nWR: signal is "P79";
   attribute LOC of nCS: signal is "P98 P96 P93 P84";
   attribute LOC of nIC: signal is "P68";
   attribute LOC of nIRQ: signal is "P64";
   attribute LOC of nDSW: signal is "P54 P53 P52 P60";
end scc;

architecture rtl of scc is
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
   signal srdiv4: std_logic_vector(1 downto 0);
   signal clk14div4, clk14div4n: std_logic;
   signal clk14div8: std_logic;
   --psg/ssg, scc/052539
   --psg/ssg
   constant MODE_INACTIVE: std_logic_vector(1 downto 0) := "00";
   constant MODE_READ:     std_logic_vector(1 downto 0) := "01";
   constant MODE_WRITE:    std_logic_vector(1 downto 0) := "10";
   constant MODE_ADDRESS:  std_logic_vector(1 downto 0) := "11";
   --scc/052539
   --da
   --bus
   signal srcswr: std_logic_vector(1 downto 0);
   signal baddr: std_logic_vector(15 downto 0);
   signal gamode: std_logic_vector(1 downto 0);
   signal pcudir, pc7bit: std_logic;
   --dipsw
   signal selncs: std_logic;
begin

   --osc
   process(CLK)
   begin
      if CLK'event and CLK='1' then
         --3.579545M, 14.31818M/4
         srdiv4 <= srdiv4(0) & (not srdiv4(1));
         clk14div4 <= srdiv4(0);
         clk14div4n <= not srdiv4(0);
         --1.7897725M, 14.31818M/8
         if conv_integer(srdiv4)=0 then
            clk14div8 <= not clk14div8;
         end if;
      end if;
   end process;

   --psg/ssg, scc/052539
   ABD <= D when(selncs='0' and nRD='1' and nWR='0' and A(3 downto 2)="00") else
      D when(selncs='0' and nRD='1' and nWR='0' and A(3 downto 0)="1001") else
      "ZZZZZZZZ";
-- ABnRESET <= '0' when(nIC='0') else 'Z';
   process(nIC, CLK)
      variable v_st: sb_odoutst;
   begin
      if nIC='0' then
         v_st := (others => '1');
      elsif CLK'event and CLK='1' then
         v_st := v_st(0) & '0';
      end if;
      ABnRESET <= odout(v_st);
   end process;

   --psg/ssg
   APhiM <= clk14div4 when(AnPSEL='0') else clk14div8;
   process(nIC, selncs, A, nRD, nWR)
      variable v_mode: std_logic_vector(MODE_INACTIVE'range);
      variable v_st: std_logic_vector(2 downto 0);
   begin
      v_mode := MODE_INACTIVE;
      if nIC='1' and selncs='0' and A(3 downto 2)="00" then
         v_st := A(0) & nRD & nWR;
         case v_st is
            when "010" =>
               v_mode := MODE_ADDRESS;
            when "101" =>
               v_mode := MODE_READ;
            when "110" =>
               v_mode := MODE_WRITE;
            when others =>
               null;
         end case;
      end if;
      ABDIR <= v_mode(1);
      ABC1 <= v_mode(0);
   end process;

   --scc/052539
   BCLOCK <= clk14div4;
   BA <= baddr;
   BnRD <= '0' when(selncs='0' and nRD='0' and A(3 downto 0)="1001") else '1';
   BnWR <= '0' when(selncs='0' and nWR='0' and A(3 downto 0)="1001") else '1';
   BnSLTSL <= '0' when(selncs='0' and A(3 downto 0)="1001") else '1';
   BnRFSH <= '1';

   --da
   DACLK <= clk14div4n; --16374
-- DAnOE <= '0';        --16245
   DABIT <= pc7bit when(gamode="00" and pcudir='0') else '0';
-- process(nIC, BFref)
--    variable v_cnt: std_logic_vector(4 downto 0);
-- begin
--    if nIC='0' then
--       v_cnt := (others => '0');
--    elsif BFref'event and BFref='1' then
--       v_cnt := v_cnt + 1;
--    end if;
--    DABIT <= v_cnt(4);
-- end process;

   --bus
   D <= ABD when(selncs='0' and nRD='0' and nWR='1' and A(3 downto 2)="00" and A(0)='1') else
      ABD when(selncs='0' and nRD='0' and nWR='1' and A(3 downto 0)="1001") else
      "ZZZZZZZZ";
   nIRQ <= 'Z';
   process(nIC, CLK)
   begin
      if nIC='0' then
         srcswr <= (others => '0');
         baddr <= (others => '0');
         gamode <= (others => '0');
         pcudir <= '1';
         pc7bit <= '0';
      elsif CLK'event and CLK='1' then
         --
         srcswr <= srcswr(0) & ((not selncs) and (not nWR));
         if srcswr="01" then
            case A(3 downto 0) is
               when "0000" | "0010" =>
                  --psg/ssg, address
               when "0001" | "0011" =>
                  --psg/ssg, data
               when "0110" =>
                  --ppi, portc
                  pc7bit <= D(7);
               when "0111" =>
                  --ppi, mode
                  if D(7)='0' then
                     if D(3 downto 1)="111" then
                        pc7bit <= D(0);
                     end if;
                  else
                     gamode <= D(6 downto 5);
                     pcudir <= D(3);
                     pc7bit <= '0';
                  end if;
               when "1000" =>
                  --scc/052539, low address
                  baddr(7 downto 0) <= D;
               when "1001" =>
                  --scc/052539, data
               when "1010" =>
                  --scc/052539, high address
                  baddr(15 downto 8) <= D;
               when others =>
                  null;
            end case;
         end if;
      end if;
   end process;

   --dipsw
   process(nDSW, nCS, A)
   begin
      if (A(4) xor nDSW(3))='1' then
         selncs <= nCS(conv_integer("11" xor nDSW(1 downto 0)));
      else
         selncs <= '1';
      end if;
   end process;

end rtl;
