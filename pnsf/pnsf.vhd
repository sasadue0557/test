library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pnsf is
   Port(
      --osc
      CLK: in std_logic;      --21.47727M
      --cpu
      BnRST: out std_logic;
      BnNMI: out std_logic;   --open drain
      BnIRQ: out std_logic;   --open drain
      BA: in std_logic_vector(15 downto 0);
      BD: inout std_logic_vector(7 downto 0);
      BPhi2: in std_logic;
      BRnW: in std_logic;
      --ram
      RA: out std_logic_vector(18 downto 0);
      RD: inout std_logic_vector(7 downto 0);
      RnOE: out std_logic;
      RnWE: out std_logic;
      RnCE: out std_logic;
      --ext
      EnIRQ: in std_logic;
      EnRS: out std_logic;
      EA: out std_logic_vector(14 downto 0);
      ED: inout std_logic_vector(7 downto 0);
      EPhi2: out std_logic;
      ERnW: out std_logic;
      --bus
      A: in std_logic_vector(1 downto 0);
      D: inout std_logic_vector(7 downto 0);
      nRD: in std_logic;
      nWR: in std_logic;
      nCS: in std_logic;
      nIC: in std_logic
   );
   --
   attribute BUFG: string;
   attribute BUFG of CLK: signal is "CLK";
   --
   attribute SLEW: string;
   attribute SLEW of BnRST: signal is "SLOW";
   attribute SLEW of BnNMI: signal is "SLOW";
   attribute SLEW of BnIRQ: signal is "SLOW";
   attribute SLEW of BD: signal is "SLOW";
   attribute SLEW of RA: signal is "SLOW";
   attribute SLEW of RD: signal is "SLOW";
   attribute SLEW of RnOE: signal is "SLOW";
   attribute SLEW of RnWE: signal is "SLOW";
   attribute SLEW of RnCE: signal is "SLOW";
   attribute SLEW of EnRS: signal is "SLOW";
   attribute SLEW of EA: signal is "SLOW";
   attribute SLEW of ED: signal is "SLOW";
   attribute SLEW of EPhi2: signal is "SLOW";
   attribute SLEW of ERnW: signal is "SLOW";
   attribute SLEW of D: signal is "SLOW";
   --
   attribute PULLUP: string;
   attribute PULLUP of EnIRQ: signal is "TRUE";
   --
   attribute LOC: string;
   attribute LOC of CLK: signal is "P125";
   attribute LOC of BnRST: signal is "P93";
   attribute LOC of BnNMI: signal is "P80";
   attribute LOC of BnIRQ: signal is "P81";
   attribute LOC of BA: signal is "P113 P112 P111 P110 P109 P108 P107 P106 P103 P102 P101 P100 P99 P98 P97 P96";
   attribute LOC of BD: signal is "P92 P91 P90 P88 P87 P86 P84 P83";
   attribute LOC of BPhi2: signal is "P82";
   attribute LOC of BRnW: signal is "P79";
   attribute LOC of RA: signal is "P49 P48 P47 P46 P40 P39 P38 P37 P36 P53 P54 P55 P56 P60 P68 P69 P70 P71 P72";
   attribute LOC of RD: signal is "P44 P43 P42 P41 P62 P63 P65 P66";
   attribute LOC of RnOE: signal is "P45";
   attribute LOC of RnWE: signal is "P61";
   attribute LOC of RnCE: signal is "P67";
   attribute LOC of EnIRQ: signal is "P140";
   attribute LOC of EnRS: signal is "P22";
   attribute LOC of EA: signal is "P8 P7 P6 P5 P15 P32 P31 P30 P21 P19 P18 P16 P14 P12 P9";
   attribute LOC of ED: signal is "P29 P28 P27 P2 P141 P142 P143 P1";
   attribute LOC of EPhi2: signal is "P25";
   attribute LOC of ERnW: signal is "P23";
   attribute LOC of A: signal is "P118 P117";
   attribute LOC of D: signal is "P121 P122 P131 P132 P134 P136 P137 P138";
   attribute LOC of nRD: signal is "P120";
   attribute LOC of nWR: signal is "P119";
   attribute LOC of nCS: signal is "P133";
   attribute LOC of nIC: signal is "P128";
end pnsf;

architecture rtl of pnsf is
   --osc
   --cpu
   signal srbphi2: std_logic_vector(1 downto 0);
   signal cpurdata: std_logic_vector(7 downto 0);
   signal cpurack: std_logic;
   --
   signal fppunmi: std_logic;
   signal enbppuintr: std_logic;
   signal ppuintrreq: std_logic;
   signal ppuintrack: std_logic;
   signal enbromwrite: std_logic;
   subtype sb_bank is std_logic_vector(6 downto 0);
   type type_bank67 is array(0 to 1) of sb_bank;
   signal bank67reg: type_bank67;
   type type_bank is array(0 to 7) of sb_bank;
   signal bankreg: type_bank;
   signal cpldrdata: std_logic_vector(7 downto 0);
   signal cpldrack: std_logic;
   --ram
   signal fram, from: std_logic;
   --ext
   signal fextirq: std_logic;
   --bus
   signal srcswr: std_logic_vector(1 downto 0);
   signal srcsrd: std_logic_vector(1 downto 0);
   signal regindex: std_logic_vector(7 downto 0);
   signal enbstop: std_logic;
   signal enbcpureset: std_logic;
   signal busramaddr: std_logic_vector(20 downto 0);
   signal busramwdata: std_logic_vector(7 downto 0);
   signal busramwreq: std_logic;
   signal vbdivcnt: std_logic_vector(15 downto 0);
   signal busrdata: std_logic_vector(7 downto 0);
   --dipsw
   signal selncs: std_logic;
   --
   constant PAGE_RAMCTL: std_logic_vector(sb_bank'range) := "1110110";  --0x76=((-((0xf000-0x6000)>>12))-1)&0x7f
begin

   --osc

   --cpu
   BnRST <= '0' when(enbcpureset='1') else '1';
   BnNMI <= '0' when(enbcpureset='0' and enbppuintr='1' and fppunmi='1') else 'Z';
   BnIRQ <= '0' when(enbcpureset='0' and fextirq='1') else 'Z';
   BD <= cpurdata when(enbcpureset='0' and srbphi2(1)='1' and BRnW='1' and cpurack='1') else (others => 'Z');
   process(RD, fram, from, cpldrdata, cpldrack)
      variable v_data: std_logic_vector(cpurdata'range);
   begin
      v_data := (others => '1');
      if (fram or from)='1' then
         v_data := v_data and RD;
      end if;
      if cpldrack='1' then
         v_data := v_data and cpldrdata;
      end if;
      cpurdata <= v_data;
      cpurack <= (fram or from) or cpldrack;
   end process;

   --
   process(enbcpureset, CLK)
   begin
      if enbcpureset='1' then
         srbphi2 <= (others => '0');
      elsif CLK'event and CLK='1' then
         srbphi2 <= BPhi2 & srbphi2(1);
      end if;
   end process;

   --
   fppunmi <= '1' when(ppuintrreq/=ppuintrack) else '0';
   process(enbcpureset, CLK)
      variable v_vbcnt: std_logic_vector(vbdivcnt'range);
   begin
      if enbcpureset='1' then
         v_vbcnt := (others => '0');
         enbppuintr <= '0';
         ppuintrreq <= '0';
         ppuintrack <= '0';
         enbromwrite <= '0';
         bankreg(7) <= PAGE_RAMCTL;
         cpldrdata <= (others => '0');
         cpldrack <= '0';
      elsif CLK'event and CLK='1' then
         --read
         case srbphi2 is
            when "01" | "00" =>
               cpldrack <= '0';
            when "10" =>
               --1.7897725M, 21.47727M/12
               if conv_integer(v_vbcnt)=0 then
                  v_vbcnt := vbdivcnt;
                  if v_vbcnt>=X"4000" and fppunmi='0' then
                     ppuintrreq <= not ppuintrreq;
                  end if;
               else
                  v_vbcnt := v_vbcnt - 1;
               end if;
               --
               cpldrack <= '0';
               if BRnW='1' and BA(15 downto 12)=X"2" then
                  case BA(2 downto 0) is
                     when "010" =>
                        --ppu, $2002
                        --  b7: vblank, vblank/no#
                        --  b0: stop, stop/no#
                        if fppunmi='1' then
                           ppuintrack <= not ppuintrack;
                        end if;
                        cpldrdata <= fppunmi & "000000" & enbstop;
                        cpldrack <= '1';
                     when others =>
                        null;
                  end case;
               end if;
            when "11" =>
               null;
            when others =>
               null;
         end case;
         --write
         if BPhi2='1' and BRnW='0' then
            case BA(15 downto 12) is
               when X"2" =>
                  if BA(2 downto 0)="000" then
                     --ppu, $2000
                     --  b7: vblank nmi, enable/disable#
                     enbppuintr <= BD(7);
                  end if;
               when X"3" =>
                  if BA(11 downto 0)=X"800" then
                     --rom, $3800
                     --  b7: rom($8000~$ffff) write, enable/disable#
                     enbromwrite <= BD(7);
                  end if;
               when X"5" =>
                  case BA(11 downto 0) is
                     when X"ff6" | X"ff7" =>
                        --bank, $5ff6~$5ff7
                        bank67reg(conv_integer(BA(0))) <= BD(6 downto 0);
                     when X"ff8" | X"ff9" | X"ffa" | X"ffb" | X"ffc" | X"ffd" | X"ffe" | X"fff" =>
                        --bank, $5ff8~$5fff
                        bankreg(conv_integer(BA(2 downto 0))) <= BD(6 downto 0);
                     when others =>
                        null;
                  end case;
               when others =>
                  null;
            end case;
         end if;
      end if;
   end process;

   --ram
   RD <= busramwdata when(enbcpureset='1' and busramwreq='1') else
      BD when(enbcpureset='0' and BPhi2='1' and BRnW='0' and fram='1') else (others => 'Z');
   RnOE <= '1' when(enbcpureset='1') else
      '0' when(enbcpureset='0' and srbphi2(1)='1' and BRnW='1' and (fram or from)='1') else '1';
   RnWE <= '0' when(enbcpureset='1' and busramwreq='1') else
      '0' when(enbcpureset='0' and BPhi2='1' and BRnW='0' and fram='1') else '1';
   RnCE <= '0';
   process(enbcpureset, enbromwrite, busramaddr, BA)
   begin
      fram <= '0';
      from <= '0';
      if enbcpureset='1' then
         if busramaddr(20)='0' then
            RA <= busramaddr(18 downto 0);
         else
            RA <= PAGE_RAMCTL & busramaddr(11 downto 0);
         end if;
      else
         case BA(15 downto 12) is
            when X"0" | X"1" =>
               --ram, $0000~$07ff
               fram <= '1';
               RA(18 downto 11) <= PAGE_RAMCTL & "0";
            when X"3" =>
               --ctl, $3800~$3fff
               from <= '1';
               RA(18 downto 11) <= PAGE_RAMCTL & "1";
            when X"6" | X"7" =>
               --ram, $6000~$7fff
               fram <= '1';
               RA(18 downto 11) <= bank67reg(conv_integer(BA(12))) & BA(11);
            when X"8" | X"9" | X"a" | X"b" | X"c" | X"d" | X"e" | X"f" =>
               --rom, $8000~$ffff
               if enbromwrite='1' then
                  fram <= '1';
               else
                  from <= '1';
               end if;
               RA(18 downto 11) <= bankreg(conv_integer(BA(14 downto 12))) & BA(11);
            when others =>
               RA(18 downto 11) <= PAGE_RAMCTL & "1";
         end case;
         RA(10 downto 0) <= BA(10 downto 0);
      end if;
   end process;

   --ext
   fextirq <= '1' when(EnIRQ='0') else '0';
   EnRS <= not BA(15) when(enbcpureset='0' and srbphi2(1)='1') else '1';
   EA <= BA(14 downto 0) when(enbcpureset='0') else (others => '0');
   ED <= BD when(enbcpureset='0' and srbphi2(1)='1' and BRnW='0') else (others => 'Z');
   EPhi2 <= BPhi2;
   ERnW <= BRnW when(enbcpureset='0') else '0';

   --bus
   D <= busrdata when(selncs='0' and nRD='0' and nWR='1') else (others => 'Z');
   process(nIC, CLK)
      variable v_busy: std_logic;
   begin
      if nIC='0' then
         srcswr <= (others => '0');
         srcsrd <= (others => '0');
         regindex <= (others => '0');
         enbstop <= '1';
         enbcpureset <= '1';
         busramaddr <= (others => '0');
         busramwdata <= (others => '0');
         busramwreq <= '0';
         vbdivcnt <= (others => '0');
         busrdata <= (others => '0');
      elsif CLK'event and CLK='1' then
         --
         srcswr <= ((not selncs) and (not nWR)) & srcswr(1);
         srcsrd <= ((not selncs) and (not nRD)) & srcsrd(1);
         if srcswr="10" then
            case A is
               when "00" =>
                  --cpld, address
               when "01" =>
                  --cpld, data
               when "10" =>
                  --cpld, address
                  if D(7 downto 5)="000" then
                     regindex <= D;
                  else
                     regindex <= X"1f";
                  end if;
               when "11" =>
                  --cpld, data
                  case regindex is
                     when X"01" =>
                        --cpld, mode
                        --  b1: stop, enable/disable#
                        --  b0: cpu_reset, enable/disable#
                        enbstop <= D(1);
                        enbcpureset <= D(0);
                     when X"02" =>
                        --ram, low address
                        busramaddr(15 downto 8) <= D;
                        busramaddr(7 downto 0) <= (others => '0');
                     when X"03" =>
                        --ram, high address
                        --  b4: 0=$000000-$07ffff, rom
                        --      1=$100000-$1007ff, ram
                        --      1=$100800-$100fff, ctl
                        busramaddr(20 downto 16) <= D(4 downto 0);
                     when X"08" =>
                        --ram, write data
                        busramwdata <= D;
                        busramwreq <= '1';
                     when X"09" =>
                        --ppu, low vblank timing
                        vbdivcnt(7 downto 0) <= D;
                     when X"0a" =>
                        --ppu, high vblank timing
                        vbdivcnt(15 downto 8) <= D;
                     when X"18" =>
                        --ram, read data
                        busramaddr(7 downto 0) <= D;
                     when others =>
                        null;
                  end case;
               when others =>
                  null;
            end case;
         elsif srcswr="01" then
            if busramwreq='1' then
               busramaddr(7 downto 0) <= busramaddr(7 downto 0) + 1;
               busramwreq <= '0';
            end if;
         end if;
         --
         if srcsrd="10" then
            v_busy := not '0';
            case A is
               when "00" | "10" =>
                  --cpld, address
                  busrdata <= (not v_busy) & "000" & v_busy & v_busy & "00";
               when "01" | "11" =>
                  --cpld, data
                  busrdata <= X"ff";
               when others =>
                  null;
            end case;
         end if;
      end if;
   end process;

   --dipsw
   process(nCS)
   begin
      selncs <= nCS;
   end process;

end rtl;
