library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ga20 is
   Port(
      --osc
      CLK: in std_logic;      --14.31818M
      --opm, ga20
      BABCLK: out std_logic;  --3.579545M
      BnABIC: out std_logic;  --open drain
      --opm
      BnACS: out std_logic;
      --ga20
      BnBCS: out std_logic;
      --ga20_mem
      BMA: in std_logic_vector(19 downto 0);
      BMD: inout std_logic_vector(7 downto 0);
      --ram
      RA: out std_logic_vector(19 downto 0);
      RD: inout std_logic_vector(7 downto 0);
      RnRD: out std_logic;
      RnWR: out std_logic;
      RnCS: out std_logic;
      --bus
      A7: in std_logic;
      A: in std_logic_vector(6 downto 0);
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
   attribute SLEW of BABCLK: signal is "SLOW";
   attribute SLEW of BnABIC: signal is "SLOW";
   attribute SLEW of BnACS: signal is "SLOW";
   attribute SLEW of BnBCS: signal is "SLOW";
   attribute SLEW of BMD: signal is "SLOW";
   attribute SLEW of RA: signal is "SLOW";
   attribute SLEW of RD: signal is "SLOW";
   attribute SLEW of RnRD: signal is "SLOW";
   attribute SLEW of RnWR: signal is "SLOW";
   attribute SLEW of RnCS: signal is "SLOW";
   attribute SLEW of D: signal is "SLOW";
   --
   attribute PULLUP: string;
   attribute PULLUP of nDSW: signal is "TRUE";
   --
   attribute LOC: string;
   attribute LOC of CLK: signal is "P127";
   attribute LOC of BABCLK: signal is "P101";
   attribute LOC of BnABIC: signal is "P91";
   attribute LOC of BnACS: signal is "P92";
   attribute LOC of BnBCS: signal is "P139";
   attribute LOC of BMA: signal is "P109 P110 P111 P112 P113 P114 P116 P117 P118 P119 P120 P121 P122 P131 P132 P133 P134 P136 P137 P138";
   attribute LOC of BMD: signal is "P2 P6 P7 P143 P1 P142 P141 P140";
   attribute LOC of RA: signal is "P42 P41 P40 P39 P38 P15 P14 P12 P11 P10 P9 P26 P28 P29 P30 P31 P32 P34 P48 P47";
   attribute LOC of RD: signal is "P23 P22 P18 P16 P45 P37 P36 P35";
   attribute LOC of RnRD: signal is "P27";
   attribute LOC of RnWR: signal is "P43";
   attribute LOC of RnCS: signal is "P46";
   attribute LOC of A7: signal is "P60";
   attribute LOC of A: signal is "P61 P62 P68 P69 P72 P71 P74";
   attribute LOC of D: signal is "P75 P78 P80 P82 P83 P84 P86 P87";
   attribute LOC of nRD: signal is "P81";
   attribute LOC of nWR: signal is "P79";
   attribute LOC of nCS: signal is "P67 P66 P65 P63";
   attribute LOC of nIC: signal is "P70";
   attribute LOC of nDSW: signal is "P53 P54 P55 P56";
end ga20;

architecture rtl of ga20 is
   --
   subtype sb_odoutst is std_logic_vector(1 downto 0);
   function odout(st: sb_odoutst) return std_logic is
      variable temp: std_logic;
   begin
      case st is
         when "11" | "01" =>
            temp := '0';
         when "10" =>
            temp := '1';
         when others =>
            temp := 'Z';
      end case;
      return temp;
   end function;
   --osc
   signal clk14div4: std_logic_vector(1 downto 0);
   --opm, ga20
   --opm
   --ga20
   --ga20_mem
   signal brreq: std_logic;
   --ram
   type ram_state is (
      RS_IDLE,
      RS_READ_0B, RS_READ_1, RS_READ_1B, RS_READ_2,
      RS_WRITE_0B, RS_WRITE_1B, RS_WRITE_2B
   );
   signal rstate: ram_state;
   signal addrval: std_logic;
   signal ramaddr: std_logic_vector(RA'range);
   signal ramrdata: std_logic_vector(7 downto 0);
   signal ramwdata: std_logic_vector(7 downto 0);
   signal ramrd: std_logic;
   signal ramwr: std_logic;
   signal ramcs: std_logic;
   signal brack: std_logic;
   signal wack: std_logic;
   signal rack: std_logic;
   --bus
   signal srcswr: std_logic_vector(1 downto 0);
   signal srcsrd: std_logic_vector(1 downto 0);
   signal regindex: std_logic_vector(7 downto 0);
   signal enbdatasel: std_logic;
   signal enbconnect: std_logic;
   signal waddr: std_logic_vector(RA'range);
   signal watemp: std_logic_vector(7 downto 0);
   signal wdata: std_logic_vector(7 downto 0);
   signal wreq: std_logic;
   signal dacdata: std_logic_vector(7 downto 0);
   signal rreq: std_logic;
   signal rdata: std_logic_vector(7 downto 0);
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

   --opm, ga20
   BABCLK <= clk14div4(0);
-- BnABIC <= '0' when(nIC='0') else 'Z';
   process(CLK, nIC)
      variable st: sb_odoutst;
   begin
      if nIC='0' then
         st := (others => '1');
      elsif CLK'event and CLK='1' then
         st := st(0) & '0';
      end if;
      BnABIC <= odout(st);
   end process;

   --opm
   BnACS <= '0' when(selncs='0' and A(6)='0' and A(1)='0') else '1';

   --ga20
   BnBCS <= '0' when(selncs='0' and A(6 downto 5)="10") else '1';

   --ga20_mem
   BMD <= ramrdata when(enbconnect='1' and enbdatasel='0') else
      dacdata when(enbconnect='1' and enbdatasel='1') else
      "ZZZZZZZZ";
   process(nIC, CLK)
      variable tempaddr: std_logic_vector(BMA'range);
   begin
      if nIC='0' then
         tempaddr := (others => '0');
         --
         brreq <= '0';
      elsif CLK'event and CLK='1' then
         --
         if enbconnect='1' and enbdatasel='0' then
            tempaddr := BMA;
            if brreq=brack and (addrval='0' or tempaddr/=ramaddr) then
               --read
               brreq <= not brreq;
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
         addrval <= '0';
         ramaddr <= (others => '0');
         ramrdata <= X"80";
         ramwdata <= (others => '0');
         ramrd <= '0';
         ramwr <= '0';
         ramcs <= '0';
         brack <= '0';
         wack <= '0';
         rack <= '0';
      elsif CLK'event and CLK='1' then
         --
         case rstate is
            when RS_IDLE =>
               ramrd <= '0';
               ramwr <= '0';
               ramcs <= '0';
               if brack/=brreq then
                  ramaddr <= BMA;
                  ramrd <= '1';
                  ramcs <= '1';
                  rstate <= RS_READ_1;
               elsif wack/=wreq then
                  rstate <= RS_WRITE_0B;
               elsif rack/=rreq then
                  rstate <= RS_READ_0B;
               end if;

            when RS_READ_0B =>
               ramaddr <= waddr;
               ramrd <= '1';
               ramcs <= '1';
               rstate <= RS_READ_1B;
            when RS_READ_1 =>
               addrval <= '1';
               ramrdata <= RD;
               brack <= brreq;
               rstate <= RS_READ_2;
            when RS_READ_1B =>
               addrval <= '1';
               ramrdata <= RD;
               rack <= rreq;
               rstate <= RS_READ_2;
            when RS_READ_2 =>
               ramrd <= '0';
               ramcs <= '0';
               rstate <= RS_IDLE;

            when RS_WRITE_0B =>
               ramaddr <= waddr;
               ramwdata <= wdata;
               ramwr <= '1';
               ramcs <= '1';
               rstate <= RS_WRITE_1B;
            when RS_WRITE_1B =>
               addrval <= '0';
               ramrdata <= X"80";
               wack <= wreq;
               rstate <= RS_WRITE_2B;
            when RS_WRITE_2B =>
               ramwr <= '0';
               ramcs <= '0';
               rstate <= RS_IDLE;

            when others =>
               rstate <= RS_IDLE;
         end case;
      end if;
   end process;

   --bus
   D <= rdata when(selncs='0' and nRD='0' and A(6 downto 5)="11") else "ZZZZZZZZ";
   process(nIC, CLK)
      variable busy: std_logic;
   begin
      if nIC='0' then
         srcswr <= (others => '0');
         srcsrd <= (others => '0');
         regindex <= (others => '0');
         enbdatasel <= '1';
         enbconnect <= '1';
         waddr <= (others => '0');
         watemp <= (others => '0');
         wdata <= (others => '0');
         wreq <= '0';
         dacdata <= X"80";
         rreq <= '0';
         rdata <= (others => '0');
      elsif CLK'event and CLK='1' then
         --
         srcswr <= srcswr(0) & ((not selncs) and (not nWR));
         srcsrd <= srcsrd(0) & ((not selncs) and (not nRD));
         if srcswr="01" then
            case "0" & A(6 downto 5) & "000" & A(1 downto 0) is
               when X"00" | X"20" =>
                  --opm, address
               when X"01" | X"21" =>
                  --opm, data
               when X"40" | X"41" | X"42" | X"43" =>
                  --ga20
               when X"60" | X"62" =>
                  --cpld, address
                  regindex <= "000" & D(4 downto 0);
               when X"61" | X"63" =>
                  --cpld, data
                  case regindex is
                     when X"01" =>
                        --cpld, mode
                        --  b1: data select, dac/ram#
                        --  b0: dac/ram connect, enable/disable#
                        enbdatasel <= D(1);
                        enbconnect <= D(0);
                     when X"02" =>
                        --ram, low address
                        waddr(15 downto 8) <= D;
                        watemp <= (others => '0');
                     when X"03" =>
                        --ram, high address
                        waddr(19 downto 16) <= D(3 downto 0);
                     when X"08" =>
                        --ram, write data
                        waddr(7 downto 0) <= watemp;
                        watemp <= watemp + 1;
                        wdata <= D;
                        wreq <= not wreq;
                     when X"0e" =>
                        --dac, data
                        dacdata <= D;
                     when X"18" =>
                        --ram, read data
                        waddr(7 downto 0) <= D;
                        watemp <= D;
                        rreq <= not rreq;
                     when others =>
                        null;
                  end case;
               when others =>
                  null;
            end case;
         end if;
         --
         if srcsrd="01" then
            busy := not ((wreq xor wack) or (rreq xor rack));
            case "0" & A(6 downto 5) & "000" & A(1 downto 0) is
               when X"00" | X"20" =>
                  --opm, address
               when X"01" | X"21" =>
                  --opm, data
               when X"40" | X"41" | X"42" | X"43" =>
                  --ga20
               when X"60" | X"62" =>
                  --cpld, address
                  rdata <= (not busy) & "000" & busy & busy & "00";
               when X"61" | X"63" =>
                  --cpld, data
                  rdata <= ramrdata;
               when others =>
                  null;
            end case;
         end if;
      end if;
   end process;

   --dipsw
   process(nDSW, nCS, A7)
      variable n: integer;
   begin
      --cs select
      if (A7 xor nDSW(3))='1' then
         n := conv_integer("11" xor nDSW(1 downto 0));
         selncs <= nCS(n);
      else
         selncs <= '1';
      end if;
   end process;

end rtl;
