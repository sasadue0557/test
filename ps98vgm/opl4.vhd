library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity opl4 is
   Port(
      --osc
      XI: in std_logic;       --33.8688M, 768fs
      --opl4
      BnCS: out std_logic;
      BCLKO: in std_logic;    --16.9344M, 384fs
      BBCO: in std_logic;     --48fs, rising edge
      BLRO: in std_logic;     --fs=44.1k, high=left, left>right
      BDO: in std_logic_vector(2 downto 0);  --16bit, MSB first, right justified
      --opl4_mem
      BMA: in std_logic_vector(20 downto 0);
      BMD: inout std_logic_vector(7 downto 0);
      BnMRD: in std_logic;
      BnMWR: in std_logic;
      BnMCS: in std_logic_vector(1 downto 0);
      --ram
      RA: out std_logic_vector(21 downto 0);
      RD: inout std_logic_vector(7 downto 0);
      RnRD: out std_logic;
      RnWR: out std_logic;
      RnCS: out std_logic_vector(1 downto 0);
      --da_1793
      DAnRST: out std_logic;
      DAMUTE: out std_logic;
      DABCK: out std_logic;
      DALRCK: out std_logic;
      DADATA: out std_logic;
      DAFMT: out std_logic_vector(2 downto 0);
      DADEMP: out std_logic_vector(1 downto 0);
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
      --dipsw
      nDSW: in std_logic_vector(3 downto 0)
   );
   --
   attribute BUFG: string;
   attribute BUFG of XI: signal is "CLK";
   attribute BUFG of BCLKO: signal is "CLK";
   --
   attribute SLEW: string;
   attribute SLEW of BnCS: signal is "SLOW";
   attribute SLEW of BMD: signal is "SLOW";
   attribute SLEW of RA: signal is "SLOW";
   attribute SLEW of RD: signal is "SLOW";
   attribute SLEW of RnRD: signal is "SLOW";
   attribute SLEW of RnWR: signal is "SLOW";
   attribute SLEW of RnCS: signal is "SLOW";
   attribute SLEW of DAnRST: signal is "SLOW";
   attribute SLEW of DAMUTE: signal is "SLOW";
   attribute SLEW of DABCK: signal is "SLOW";
   attribute SLEW of DALRCK: signal is "SLOW";
   attribute SLEW of DADATA: signal is "SLOW";
   attribute SLEW of DAFMT: signal is "SLOW";
   attribute SLEW of DADEMP: signal is "SLOW";
   attribute SLEW of TX: signal is "SLOW";
   attribute SLEW of D: signal is "SLOW";
   --
   attribute PULLUP: string;
   attribute PULLUP of nDSW: signal is "TRUE";
   --
   attribute LOC: string;
   attribute LOC of XI: signal is "P128";
   attribute LOC of BnCS: signal is "P103";
   attribute LOC of BCLKO: signal is "P126";
   attribute LOC of BBCO: signal is "P14";
   attribute LOC of BLRO: signal is "P12";
   attribute LOC of BDO: signal is "P9 P10 P11";
   attribute LOC of BMA: signal is "P106 P107 P108 P109 P137 P134 P132 P122 P120 P118 P116 P112 P110 P111 P113 P117 P119 P121 P131 P133 P136";
   attribute LOC of BMD: signal is "P141 P143 P2 P6 P5 P1 P142 P140";
   attribute LOC of BnMRD: signal is "P138";
   attribute LOC of BnMWR: signal is "P114";
   attribute LOC of BnMCS: signal is "P7 P8";
   attribute LOC of RA: signal is "P39 P56 P38 P41 P42 P55 P29 P30 P31 P32 P34 P35 P36 P37 P44 P45 P46 P47 P48 P49 P53 P72";
   attribute LOC of RD: signal is "P60 P61 P62 P63 P65 P66 P67 P68";
   attribute LOC of RnRD: signal is "P70";
   attribute LOC of RnWR: signal is "P40";
   attribute LOC of RnCS: signal is "P54 P71";
   attribute LOC of DAnRST: signal is "P21";
   attribute LOC of DAMUTE: signal is "P15";
   attribute LOC of DABCK: signal is "P18";
   attribute LOC of DALRCK: signal is "P19";
   attribute LOC of DADATA: signal is "P16";
   attribute LOC of DAFMT: signal is "P22 P23 P25";
   attribute LOC of DADEMP: signal is "P26 P27";
   attribute LOC of TX: signal is "P28";
   attribute LOC of A7: signal is "P79";
   attribute LOC of A: signal is "P80 P82 P86 P83";
   attribute LOC of D: signal is "P84 P87 P90 P92 P94 P97 P100 P102";
   attribute LOC of nRD: signal is "P91";
   attribute LOC of nWR: signal is "P88";
   attribute LOC of nCS: signal is "P101 P98 P96 P93";
   attribute LOC of nIC: signal is "P81";
   attribute LOC of nDSW: signal is "P78 P77 P75 P74";
end opl4;

architecture rtl of opl4 is
   --osc
   --opl4
   signal srbclk: std_logic_vector(1 downto 0);
   signal srlrck: std_logic_vector(1 downto 0);
   signal srbdata: std_logic;
   signal sradata: std_logic_vector(17 downto 0);
   signal srbmute: std_logic;
   signal adata: std_logic_vector(17 downto 0);
   --opl4_mem
   signal srmwr: std_logic;
   signal brd: std_logic;
   signal brwreq: std_logic;
   --ram
   type ram_state is (
      RS_IDLE,
      RS_READ_0, RS_READ_1, RS_READ_2,
      RS_WRITE_0, RS_WRITE_0B, RS_WRITE_1, RS_WRITE_1B, RS_WRITE_2
   );
   signal rstate: ram_state;
   signal addrval: std_logic;
   signal ramaddr: std_logic_vector(21 downto 0);
   signal ramrdata: std_logic_vector(7 downto 0);
   signal ramwdata: std_logic_vector(7 downto 0);
   signal ramrd: std_logic;
   signal ramwr: std_logic;
   signal ramcs: std_logic_vector(1 downto 0);
   signal brwack: std_logic;
   signal wack: std_logic;
   --da_1793
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
   signal regindex: std_logic_vector(3 downto 0);
   signal seloutput: std_logic_vector(1 downto 0);
   signal enbspdif: std_logic;
   signal enbmute: std_logic;
   signal waddr: std_logic_vector(21 downto 0);
   signal watemp: std_logic_vector(7 downto 0);
   signal wdata: std_logic_vector(7 downto 0);
   signal wreq: std_logic;
   signal rdata: std_logic_vector(7 downto 0);
   --dipsw
   signal selncs: std_logic;
begin

   --osc

   --opl4
   BnCS <= '0' when(selncs='0' and A(3)='0') else '1';
   process(nIC, BCLKO)
      variable mute: std_logic;
   begin
      if nIC='0' then
         srbclk <= (others => '0');
         srlrck <= (others => '0');
         srbdata <= '0';
         sradata <= (others => '0');
         srbmute <= '0';
         mute := '0';
         adata <= (others => '0');
      elsif BCLKO'event and BCLKO='1' then
         --
         srbclk <= srbclk(0) & BBCO;
         srlrck <= srlrck(0) & BLRO;   --high=left
         srbdata <= BDO(conv_integer(seloutput));
         if srbclk="01" then
            sradata <= sradata(16 downto 2) & srbdata & "00";  --16bit
--          sradata <= sradata(16 downto 0) & srbdata;   --18bit
         end if;
         --
         srbmute <= enbmute;           --high=active
         if srlrck="01" then
            mute := srbmute;
         end if;
         if srlrck="01" or srlrck="10" then
            if mute='0' then
               adata <= sradata;
            else
               adata <= (others => '0');
            end if;
         end if;
      end if;
   end process;

   --opl4_mem
-- BMD <= RD when(BnMCS/="11" and BnMRD='0') else "ZZZZZZZZ";
   BMD <= ramrdata when(BnMCS/="11" and BnMRD='0') else "ZZZZZZZZ";
   process(nIC, XI)
      variable tempaddr: std_logic_vector(ramaddr'range);
   begin
      if nIC='0' then
         tempaddr := (others => '0');
         --
         srmwr <= '1';
         brd <= '0';
         brwreq <= '0';
      elsif XI'event and XI='1' then
         --
         srmwr <= BnMWR;
         tempaddr := BnMCS(0) & BMA;
         if BnMCS/="11" and brwreq=brwack then
            if BnMRD='0' and (addrval='0' or tempaddr/=ramaddr) then
               --read
               brd <= '1';
               brwreq <= not brwreq;
            elsif srmwr='1' and BnMWR='0' then
               --write
               brd <= '0';
               brwreq <= not brwreq;
            end if;
         end if;
      end if;
   end process;

   --ram
-- RA <= "0" & BMA;
-- RD <= BMD when(BnMCS/="11" and BnMWR='0') else "ZZZZZZZZ";
-- RnRD <= BnMRD;
-- RnWR <= BnMWR;
-- RnCS <= BnMCS;
   RA <= ramaddr;
   RD <= ramwdata when(ramwr='1') else "ZZZZZZZZ";
   RnRD <= '0' when(ramrd='1') else '1';
   RnWR <= '0' when(ramwr='1') else '1';
   RnCS(0) <= '0' when(ramcs(0)='1') else '1';
   RnCS(1) <= '0' when(ramcs(1)='1') else '1';
   process(nIC, XI)
   begin
      if nIC='0' then
         rstate <= RS_IDLE;
         addrval <= '0';
         ramaddr <= (others => '0');
         ramrdata <= (others => '0');  --X"ff";
         ramwdata <= (others => '0');
         ramrd <= '0';
         ramwr <= '0';
         ramcs <= (others => '0');
         brwack <= '0';
         wack <= '0';
      elsif XI'event and XI='1' then
         --
         case rstate is
            when RS_IDLE =>
               ramrd <= '0';
               ramwr <= '0';
               ramcs <= (others => '0');
               if brwack/=brwreq then
                  if brd='1' then
                     rstate <= RS_READ_0;
                  else
                     rstate <= RS_WRITE_0;
                  end if;
               elsif wack/=wreq then
                  rstate <= RS_WRITE_0B;
               end if;

            when RS_READ_0 =>
               ramaddr <= BnMCS(0) & BMA;
               ramrd <= '1';
               ramcs(conv_integer(BnMCS(0))) <= '1';
               rstate <= RS_READ_1;
            when RS_READ_1 =>
               addrval <= '1';
               ramrd <= '1';
               brwack <= brwreq;
               rstate <= RS_READ_2;
            when RS_READ_2 =>
               ramrdata <= RD;
               ramrd <= '0';
               ramcs <= (others => '0');
               rstate <= RS_IDLE;

            when RS_WRITE_0 =>
               ramaddr <= BnMCS(0) & BMA;
               ramwdata <= BMD;
               ramwr <= '1';
               ramcs(conv_integer(BnMCS(0))) <= '1';
               rstate <= RS_WRITE_1;
            when RS_WRITE_0B =>
               ramaddr <= waddr;
               ramwdata <= wdata;
               ramwr <= '1';
               ramcs(conv_integer(waddr(21))) <= '1';
               rstate <= RS_WRITE_1B;
            when RS_WRITE_1 =>
               addrval <= '0';
               ramwr <= '1';
               brwack <= brwreq;
               rstate <= RS_WRITE_2;
            when RS_WRITE_1B =>
               addrval <= '0';
               ramwr <= '1';
               wack <= wreq;
               rstate <= RS_WRITE_2;
            when RS_WRITE_2 =>
--             ramrdata <= X"ff";
               ramwr <= '0';
               ramcs <= (others => '0');
               rstate <= RS_IDLE;

            when others =>
               rstate <= RS_IDLE;
         end case;
      end if;
   end process;

   --da_1793
   DAnRST <= nIC;
   DAMUTE <= srbmute;
   DABCK <= BBCO;
   DALRCK <= BLRO;
   DADATA <= BDO(conv_integer(seloutput));
   DAFMT <= "000";
   DADEMP <= "00";

   --tos
   TX <= txd when(enbspdif='1') else '0';
   process(nIC, BCLKO)
      variable preamble: std_logic_vector(3 downto 0);
      variable cstatus: std_logic;
   begin
      if nIC='0' then
         framecnt <= (others => '0');
         divcnt <= (others => '0');
         bitcnt <= (others => '0');
         parity <= '0';
         sbit <= '0';
         btxd <= '0';
         txd <= '0';
      elsif BCLKO'event and BCLKO='1' then

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
               preamble := "1000";  --"Z"
            else
               preamble := "0010";  --"X"
            end if;
         else
            --ch.b(right)
            preamble := "0100";     --"Y"
         end if;

         --channel status
         case framecnt is
            --frame2
            --  1: copyright is not asserted for this data
            when X"02" =>
               cstatus := '1';
            --frame27~24
            --  sampling frequency
            --    0000: 44.1k
            --    0010: 48k
            --    0011: 32k
            when X"1b" =>
               cstatus := '0';
            when X"1a" =>
               cstatus := '0';
            when X"19" =>
               cstatus := '0';
            when X"18" =>
               cstatus := '0';
            --frame32
            --  maximum audio sample word length
            --    0: 20bit
            when X"20" =>
               cstatus := '0';
            --frame35~33
            --  audio sample word length
            --    001: 16bit
            --    010: 18bit
            when X"23" =>
               cstatus := '0';
            when X"22" =>
               cstatus := '0';
            when X"21" =>
               cstatus := '1';
            --others
            when others =>
               cstatus := '0';
         end case;

         --div counter
         --  0~2
         if srlrck="10" then
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
         if srlrck="10" then
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
                  sbit <= cstatus;
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
                  txd <= btxd xor preamble(3);
               when "000101" =>
                  txd <= btxd xor preamble(2);
               when "000110" =>
                  txd <= btxd xor preamble(1);
               when "000111" =>
                  txd <= btxd xor preamble(0);
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
   D <= rdata when(selncs='0' and nRD='0' and A(3)='1') else "ZZZZZZZZ";
   process(nIC, BCLKO)
      variable busy: std_logic;
   begin
      if nIC='0' then
         srcswr <= (others => '0');
         srcsrd <= (others => '0');
         regindex <= (others => '0');
         seloutput <= "10";
         enbspdif <= '0';
         enbmute <= '0';
         waddr <= (others => '0');
         watemp <= (others => '0');
         wdata <= (others => '0');
         wreq <= '0';
         rdata <= (others => '0');
      elsif BCLKO'event and BCLKO='1' then
         --
         srcswr <= srcswr(0) & ((not selncs) and (not nWR));
         srcsrd <= srcsrd(0) & ((not selncs) and (not nRD));
         if srcswr="01" then
            case A(3 downto 0) is
               when X"0" | X"2" | X"4" | X"6" =>
                  --opl4, address
               when X"1" | X"3" | X"5" | X"7" =>
                  --opl4, data
               when X"8" | X"a" | X"c" | X"e" =>
                  --cpld, address
                  regindex <= D(3 downto 0);
               when X"9" | X"b" | X"d" | X"f" =>
                  --cpld, data
                  case regindex is
                     when X"1" =>
                        --cpld, mode
                        --  b6-5: do, 0~2
                        --  b4: spdif, enable/disable#
                        --  b3: mute, enable/disable#
                        case D(6 downto 5) is
                           when "00" | "01" =>
                              seloutput <= D(6 downto 5);
                           when others =>
                              seloutput <= "10";
                        end case;
                        enbspdif <= D(4);
                        enbmute <= D(3);
                     when X"2" =>
                        --ram, low address
                        waddr(15 downto 8) <= D;
                        watemp <= (others => '0');
                     when X"3" =>
                        --ram, high address
                        waddr(21 downto 16) <= D(5 downto 0);
                     when X"8" =>
                        --ram, data
                        waddr(7 downto 0) <= watemp;
                        watemp <= watemp + 1;
                        wdata <= D;
                        wreq <= not wreq;
                     when others =>
                        null;
                  end case;
               when others =>
                  null;
            end case;
         end if;
         --
         if srcsrd="01" then
            busy := not (wreq xor wack);
            case A(3 downto 0) is
               when X"8" | X"a" | X"c" | X"e" =>
                  --cpld, address
                  rdata <= (not busy) & "000" & busy & busy & "00";
               when X"9" | X"b" | X"d" | X"f" =>
                  --cpld, data
                  rdata <= (not busy) & "000" & busy & busy & "00";
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
