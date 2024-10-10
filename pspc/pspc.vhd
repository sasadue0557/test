library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pspc is
   Port(
      --ssmp
      BnPORS: out std_logic;                    --open drain
      BHA: out std_logic_vector(3 downto 0);    --open drain
      BHD: inout std_logic_vector(7 downto 0);  --open drain
      BnHRD: out std_logic;                     --open drain
      BnHWR: out std_logic;                     --open drain
      --sdsp
      BnPORD: out std_logic;  --open drain
      BHCLK: in std_logic;    --12.288M, 384fs
      BBCK: in std_logic;     --48fs, rising edge
      BLRCK: in std_logic;    --fs=32k, high=left, left>right
      BDATA: in std_logic;    --16bit, MSB first, right justified
      BnMUTE: in std_logic;   --low=active
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
      nIRQ: out std_logic;    --open drain
      --dipsw
      nDSW: in std_logic_vector(3 downto 0)
   );
   --
   attribute BUFG: string;
   attribute BUFG of BHCLK: signal is "CLK";
   --
   attribute SLEW: string;
   attribute SLEW of BnPORS: signal is "SLOW";
   attribute SLEW of BHA: signal is "SLOW";
   attribute SLEW of BHD: signal is "SLOW";
   attribute SLEW of BnHRD: signal is "SLOW";
   attribute SLEW of BnHWR: signal is "SLOW";
   attribute SLEW of BnPORD: signal is "SLOW";
   attribute SLEW of DAnRST: signal is "SLOW";
   attribute SLEW of DAMUTE: signal is "SLOW";
   attribute SLEW of DABCK: signal is "SLOW";
   attribute SLEW of DALRCK: signal is "SLOW";
   attribute SLEW of DADATA: signal is "SLOW";
   attribute SLEW of DAFMT: signal is "SLOW";
   attribute SLEW of DADEMP: signal is "SLOW";
   attribute SLEW of TX: signal is "SLOW";
   attribute SLEW of D: signal is "SLOW";
   attribute SLEW of nIRQ: signal is "SLOW";
   --
   attribute PULLUP: string;
   attribute PULLUP of nDSW: signal is "TRUE";
   --
   attribute LOC: string;
   attribute LOC of BnPORS: signal is "P7";
   attribute LOC of BHA: signal is "P117 P118 P120 P119";
   attribute LOC of BHD: signal is "P6 P142 P141 P140 P139 P134 P133 P132";
   attribute LOC of BnHRD: signal is "P131";
   attribute LOC of BnHWR: signal is "P121";
   attribute LOC of BnPORD: signal is "P8";
   attribute LOC of BHCLK: signal is "P126";
   attribute LOC of BBCK: signal is "P11";
   attribute LOC of BLRCK: signal is "P10";
   attribute LOC of BDATA: signal is "P9";
   attribute LOC of BnMUTE: signal is "P12";
   attribute LOC of DAnRST: signal is "P27";
   attribute LOC of DAMUTE: signal is "P22";
   attribute LOC of DABCK: signal is "P25";
   attribute LOC of DALRCK: signal is "P26";
   attribute LOC of DADATA: signal is "P23";
   attribute LOC of DAFMT: signal is "P28 P29 P30";
   attribute LOC of DADEMP: signal is "P31 P32";
   attribute LOC of TX: signal is "P38";
   attribute LOC of A7: signal is "P78";
   attribute LOC of A: signal is "P80 P83 P92 P84";
   attribute LOC of D: signal is "P91 P93 P96 P98 P100 P102 P111 P113";
   attribute LOC of nRD: signal is "P97";
   attribute LOC of nWR: signal is "P94";
   attribute LOC of nCS: signal is "P112 P110 P101 P99";
   attribute LOC of nIC: signal is "P81";
   attribute LOC of nIRQ: signal is "P79";
   attribute LOC of nDSW: signal is "P68 P69 P70 P71";
end pspc;

architecture rtl of pspc is
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
   --ssmp
   type ssmp_state is (
      SS_IDLE,
      SS_READ_0, SS_READ_1, SS_READ_2, SS_READ_3, SS_READ_4,
      SS_WRITE_0, SS_WRITE_1, SS_WRITE_2, SS_WRITE_3, SS_WRITE_4
   );
   signal sstate: ssmp_state;
   signal baddr: std_logic_vector(BHA'range);
   signal baddroe: std_logic_vector(BHA'range);
   signal brdata: std_logic_vector(BHD'range);
   signal bwdata: std_logic_vector(BHD'range);
   signal bwdataoe: std_logic_vector(BHD'range);
   signal brd: sb_odoutst;
   signal bwr: sb_odoutst;
   signal wack: std_logic;
   signal rack: std_logic;
   --sdsp
   signal srbck: std_logic_vector(1 downto 0);
   signal srlrck: std_logic_vector(1 downto 0);
   signal srbdata: std_logic;
   signal sradata: std_logic_vector(17 downto 0);
   signal srbmute: std_logic;
   signal adata: std_logic_vector(17 downto 0);
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
   signal enbspdif: std_logic;
   signal enbmute: std_logic;
   signal enbsdspreset: std_logic;
   signal enbssmpreset: std_logic;
   signal addr: std_logic_vector(1 downto 0);
   signal wdata: std_logic_vector(BHD'range);
   signal wreq: std_logic;
   signal rreq: std_logic;
   signal rdata: std_logic_vector(D'range);
   --dipsw
   signal selncs: std_logic;
begin

-- BnPORS <= '0' when(nIC='0' or enbssmpreset='1') else 'Z';
   process(BHCLK, nIC, enbssmpreset)
      variable st: sb_odoutst;
   begin
      if nIC='0' or enbssmpreset='1' then
         st := (others => '1');
      elsif BHCLK'event and BHCLK='1' then
         st := st(0) & '0';
      end if;
      BnPORS <= odout(st);
   end process;

o_bha: for i in BHA'range generate
      BHA(i) <= baddr(i) when(baddroe(i)='1') else 'Z';
   end generate;
o_bhd: for i in BHD'range generate
      BHD(i) <= bwdata(i) when(bwdataoe(i)='1') else 'Z';
   end generate;
   BnHRD <= odout(brd);
   BnHWR <= odout(bwr);

   --ssmp
   process(nIC, BHCLK)
      variable actcnt: std_logic_vector(2 downto 0);
   begin
      if nIC='0' then
         actcnt := (others => '0');
         --
         sstate <= SS_IDLE;
         baddr <= "01" & "11";
         baddroe <= "10" & "00";
         brdata <= (others => '0');
         bwdata <= (others => '1');
         bwdataoe <= (others => '0');
         brd <= (others => '0');
         bwr <= (others => '0');
         wack <= '0';
         rack <= '0';
      elsif BHCLK'event and BHCLK='1' then
         --
         case sstate is
            when SS_IDLE =>
               baddr(1 downto 0) <= "11";
               baddroe(1 downto 0) <= "00";
               bwdata <= (others => '1');
               bwdataoe <= (others => '0');
               brd <= (others => '0');
               bwr <= (others => '0');
               if rack/=rreq then
                  sstate <= SS_READ_0;
               elsif wack/=wreq then
                  sstate <= SS_WRITE_0;
               end if;

            when SS_READ_0 =>
               baddr(1 downto 0) <= addr;
               baddroe(1 downto 0) <= not addr;
               bwdata <= (others => '1');
               bwdataoe <= (others => '0');
               brd <= (others => '0');
               rack <= rreq;
               sstate <= SS_READ_1;
            when SS_READ_1 =>
               brd <= "01";
               actcnt := (others => '1');
               sstate <= SS_READ_2;
            when SS_READ_2 =>
               brdata <= BHD;
               brd <= "11";
               actcnt := actcnt - 1;
               if conv_integer(actcnt)<1 then
                  sstate <= SS_READ_3;
               end if;
            when SS_READ_3 =>
               brd <= "10";
               sstate <= SS_READ_4;
            when SS_READ_4 =>
               baddr(1 downto 0) <= "11";
               bwdataoe <= not brdata;
               brd <= (others => '0');
               sstate <= SS_IDLE;

            when SS_WRITE_0 =>
               baddr(1 downto 0) <= addr;
               baddroe(1 downto 0) <= not addr;
               bwdata <= wdata;
               bwdataoe <= not wdata;
               bwr <= (others => '0');
               wack <= wreq;
               sstate <= SS_WRITE_1;
            when SS_WRITE_1 =>
               bwr <= "01";
               actcnt := (others => '1');
               sstate <= SS_WRITE_2;
            when SS_WRITE_2 =>
               bwr <= "11";
               actcnt := actcnt - 1;
               if conv_integer(actcnt)<1 then
                  sstate <= SS_WRITE_3;
               end if;
            when SS_WRITE_3 =>
               bwr <= "10";
               sstate <= SS_WRITE_4;
            when SS_WRITE_4 =>
               baddr(1 downto 0) <= "11";
               bwdata <= (others => '1');
               bwr <= (others => '0');
               sstate <= SS_IDLE;

            when others =>
               sstate <= SS_IDLE;
         end case;
      end if;
   end process;

-- BnPORD <= '0' when(nIC='0' or enbsdspreset='1') else 'Z';
   process(BHCLK, nIC, enbsdspreset)
      variable st: sb_odoutst;
   begin
      if nIC='0' or enbsdspreset='1' then
         st := (others => '1');
      elsif BHCLK'event and BHCLK='1' then
         st := st(0) & '0';
      end if;
      BnPORD <= odout(st);
   end process;

   --sdsp
   process(nIC, BHCLK)
      variable mute: std_logic;
   begin
      if nIC='0' then
         srbck <= (others => '0');
         srlrck <= (others => '0');
         srbdata <= '0';
         sradata <= (others => '0');
         srbmute <= '0';
         mute := '0';
         adata <= (others => '0');
      elsif BHCLK'event and BHCLK='1' then
         --
         srbck <= srbck(0) & BBCK;
         srlrck <= srlrck(0) & BLRCK;  --high=left
         srbdata <= BDATA;
         if srbck="01" then
            sradata <= sradata(16 downto 2) & srbdata & "00";  --16bit
--          sradata <= sradata(16 downto 0) & srbdata;   --18bit
         end if;
         --
         srbmute <= (not BnMUTE) or enbmute;    --high=active
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

   --da_1793
   DAnRST <= nIC;
   DAMUTE <= srbmute;
   DABCK <= BBCK;
   DALRCK <= BLRCK;
   DADATA <= BDATA;
   DAFMT <= "000";
   DADEMP <= "00";

   --tos
   TX <= txd when(enbspdif='1') else '0';
   process(nIC, BHCLK)
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
      elsif BHCLK'event and BHCLK='1' then

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
               cstatus := '1';
            when X"18" =>
               cstatus := '1';
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
   D <= brdata when(selncs='0' and nRD='0' and A(2)='0') else
      rdata when(selncs='0' and nRD='0' and A(2)='1') else
      "ZZZZZZZZ";
   nIRQ <= 'Z';
   process(nIC, BHCLK)
      variable busy: std_logic;
   begin
      if nIC='0' then
         srcswr <= (others => '0');
         srcsrd <= (others => '0');
         regindex <= (others => '0');
         enbspdif <= '0';
         enbmute <= '0';
         enbsdspreset <= '0';
         enbssmpreset <= '0';
         addr <= (others => '0');
         wdata <= (others => '0');
         wreq <= '0';
         rreq <= '0';
         rdata <= (others => '0');
      elsif BHCLK'event and BHCLK='1' then
         --
         srcswr <= srcswr(0) & ((not selncs) and (not nWR));
         srcsrd <= srcsrd(0) & ((not selncs) and (not nRD));
         if srcswr="01" then
            case A(3 downto 0) is
               when X"0" | X"1" | X"2" | X"3" | X"8" | X"9" | X"a" | X"b" =>
                  --ssmp
                  addr <= A(1 downto 0);
                  wdata <= D;
                  wreq <= not wreq;
               when X"4" | X"6" | X"c" | X"e" =>
                  --cpld, address
                  regindex <= D(3 downto 0);
               when X"5" | X"7" | X"d" | X"f" =>
                  --cpld, data
                  case regindex is
                     when X"1" =>
                        --cpld, mode
                        --  b4: spdif, enable/disable#
                        --  b3: mute, enable/disable#
                        --  b1: sdsp_reset, enable/disable#
                        --  b0: ssmp_reset, enable/disable#
                        enbspdif <= D(4);
                        enbmute <= D(3);
                        enbsdspreset <= D(1);
                        enbssmpreset <= D(0);
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
            case A(3 downto 0) is
               when X"0" | X"1" | X"2" | X"3" | X"8" | X"9" | X"a" | X"b" =>
                  --ssmp
                  addr <= A(1 downto 0);
                  rreq <= not rreq;
               when X"4" | X"6" | X"c" | X"e" =>
                  --cpld, address
                  rdata <= (not busy) & "000" & busy & busy & "00";
               when X"5" | X"7" | X"d" | X"f" =>
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
