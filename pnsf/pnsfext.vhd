library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--library UNISIM;
--use UNISIM.Vcomponents.all;

entity pnsfext is
   Port(
      --osc
      CLK: in std_logic;      --21.47727M
      --cpu
      BnRST: out std_logic;   --open drain
      BnNMI: out std_logic;   --open drain
      BnIRQ: out std_logic;   --open drain
      BNC: out std_logic;
      BA: in std_logic_vector(15 downto 0);
      BD: inout std_logic_vector(7 downto 0);
      BPhi2: in std_logic;
      BRnW: in std_logic;
      --ram
      RA: out std_logic_vector(19 downto 0);
      RD: inout std_logic_vector(7 downto 0);
      RnRD: out std_logic;
      RnWR: out std_logic;
      RnCS: out std_logic;
      --ext
      EnRST: out std_logic;   --open drain
      EnIRQ: in std_logic;
      EnRS: out std_logic_vector(2 downto 0);
      EA14: out std_logic_vector(2 downto 0);
      EA: out std_logic_vector(13 downto 0);
      ED: inout std_logic_vector(7 downto 0);
      EPhi2: out std_logic;
      ERnW: out std_logic;
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
   --
   attribute SLEW: string;
   attribute SLEW of BnRST: signal is "SLOW";
   attribute SLEW of BnNMI: signal is "SLOW";
   attribute SLEW of BnIRQ: signal is "SLOW";
   attribute SLEW of BNC: signal is "SLOW";
   attribute SLEW of BD: signal is "SLOW";
   attribute SLEW of RA: signal is "SLOW";
   attribute SLEW of RD: signal is "SLOW";
   attribute SLEW of RnRD: signal is "SLOW";
   attribute SLEW of RnWR: signal is "SLOW";
   attribute SLEW of RnCS: signal is "SLOW";
   attribute SLEW of EnRST: signal is "SLOW";
   attribute SLEW of EnRS: signal is "SLOW";
   attribute SLEW of EA14: signal is "SLOW";
   attribute SLEW of EA: signal is "SLOW";
   attribute SLEW of ED: signal is "SLOW";
   attribute SLEW of EPhi2: signal is "SLOW";
   attribute SLEW of ERnW: signal is "SLOW";
   attribute SLEW of D: signal is "SLOW";
   attribute SLEW of nIRQ: signal is "SLOW";
   --
   attribute IOSTANDARD: string;
   attribute IOSTANDARD of CLK: signal is "LVTTL";
   attribute IOSTANDARD of BnRST: signal is "LVTTL";
   attribute IOSTANDARD of BnNMI: signal is "LVTTL";
   attribute IOSTANDARD of BnIRQ: signal is "LVTTL";
   attribute IOSTANDARD of BNC: signal is "LVTTL";
   attribute IOSTANDARD of BA: signal is "LVTTL";
   attribute IOSTANDARD of BD: signal is "LVTTL";
   attribute IOSTANDARD of BPhi2: signal is "LVTTL";
   attribute IOSTANDARD of BRnW: signal is "LVTTL";
   attribute IOSTANDARD of RA: signal is "LVTTL";
   attribute IOSTANDARD of RD: signal is "LVTTL";
   attribute IOSTANDARD of RnRD: signal is "LVTTL";
   attribute IOSTANDARD of RnWR: signal is "LVTTL";
   attribute IOSTANDARD of RnCS: signal is "LVTTL";
   attribute IOSTANDARD of EnRST: signal is "LVTTL";
   attribute IOSTANDARD of EnIRQ: signal is "LVTTL";
   attribute IOSTANDARD of EnRS: signal is "LVTTL";
   attribute IOSTANDARD of EA14: signal is "LVTTL";
   attribute IOSTANDARD of EA: signal is "LVTTL";
   attribute IOSTANDARD of ED: signal is "LVTTL";
   attribute IOSTANDARD of EPhi2: signal is "LVTTL";
   attribute IOSTANDARD of ERnW: signal is "LVTTL";
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
   attribute DRIVE of BnRST: signal is "2";
   attribute DRIVE of BnNMI: signal is "2";
   attribute DRIVE of BnIRQ: signal is "2";
   attribute DRIVE of BNC: signal is "2";
   attribute DRIVE of BD: signal is "2";
   attribute DRIVE of RA: signal is "2";
   attribute DRIVE of RD: signal is "2";
   attribute DRIVE of RnRD: signal is "2";
   attribute DRIVE of RnWR: signal is "2";
   attribute DRIVE of RnCS: signal is "2";
   attribute DRIVE of EnRST: signal is "4";
   attribute DRIVE of EnRS: signal is "4";
   attribute DRIVE of EA14: signal is "4";
   attribute DRIVE of EA: signal is "4";
   attribute DRIVE of ED: signal is "4";
   attribute DRIVE of EPhi2: signal is "4";
   attribute DRIVE of ERnW: signal is "4";
   attribute DRIVE of D: signal is "4";
   attribute DRIVE of nIRQ: signal is "4";
   --
   attribute PULLUP: string;
-- attribute PULLUP of BD: signal is "TRUE";    --test
-- attribute PULLUP of ED: signal is "TRUE";    --test
   attribute PULLUP of nDSW: signal is "TRUE";
   --
   attribute KEEPER: string;
   attribute KEEPER of BD: signal is "TRUE";
   attribute KEEPER of RD: signal is "TRUE";
   attribute KEEPER of ED: signal is "TRUE";
   --
   attribute LOC: string;
   attribute LOC of CLK: signal is "P185";
   attribute LOC of BnRST: signal is "P164";
   attribute LOC of BnNMI: signal is "P161";
   attribute LOC of BnIRQ: signal is "P163";
   attribute LOC of BNC: signal is "P168";
   attribute LOC of BA: signal is "P205 P204 P203 P202 P201 P200 P199 P195 P194 P193 P192 P191 P189 P188 P167 P165";
   attribute LOC of BD: signal is "P180 P179 P178 P176 P175 P174 P173 P172";
   attribute LOC of BPhi2: signal is "P166";
   attribute LOC of BRnW: signal is "P162";
   attribute LOC of RA: signal is "P141 P140 P139 P138 P136 P112 P111 P110 P109 P102 P101 P119 P121 P122 P123 P125 P126 P127 P129 P132";
   attribute LOC of RD: signal is "P115 P114 P113 P100 P147 P148 P135 P134";
   attribute LOC of RnRD: signal is "P120";
   attribute LOC of RnWR: signal is "P142";
   attribute LOC of RnCS: signal is "P133";
   attribute LOC of EnRST: signal is "P98";
   attribute LOC of EnIRQ: signal is "P97";
   attribute LOC of EnRS: signal is "P48 P47 P57";
   attribute LOC of EA14: signal is "P45 P44 P46";
   attribute LOC of EA: signal is "P63 P61 P58 P60 P62 P67 P68 P70 P73 P75 P84 P87 P89 P94";
   attribute LOC of ED: signal is "P69 P71 P74 P83 P86 P88 P90 P95";
   attribute LOC of EPhi2: signal is "P59";
   attribute LOC of ERnW: signal is "P96";
   attribute LOC of A: signal is "P9 P8 P14 P16 P20 P17";
   attribute LOC of D: signal is "P18 P21 P23 P30 P33 P35 P37 P42";
   attribute LOC of nRD: signal is "P29";
   attribute LOC of nWR: signal is "P22";
   attribute LOC of nCS: signal is "P41 P36 P34 P31";
   attribute LOC of nIC: signal is "P15";
   attribute LOC of nIRQ: signal is "P10";
   attribute LOC of nDSW: signal is "P4 P5 P6 P7";
end pnsfext;

architecture rtl of pnsfext is
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
   --
   function conv_rs(ers: std_logic_vector(1 downto 0)) return std_logic_vector is
      variable v_rs: std_logic_vector(EnRS'range);
   begin
      case ers is
         when "00" | "01" | "10" =>
            v_rs := conv_std_logic_vector(2**conv_integer(ers), v_rs'length);
         when others =>
            v_rs := (others => '0');
      end case;
      return v_rs;
   end function;
   --cpu
   signal srbphi2: std_logic_vector(1 downto 0);
   signal srbrnw: std_logic_vector(1 downto 0);
   signal srba: std_logic_vector(31 downto 0);
   signal srbd: std_logic_vector(15 downto 0);
   signal cpurdata: std_logic_vector(7 downto 0);
   signal cpurack: std_logic;
   --
   signal fppunmi: std_logic;
   signal enbppuintr: std_logic;
   signal ppuintrreq: std_logic;
   signal ppuintrack: std_logic;
   signal enbromwrite: std_logic;
   signal enbextmask: std_logic_vector(5 downto 0);
   type type_cpu is array(0 to 31) of std_logic_vector(7 downto 0);
   signal cpureg: type_cpu;
   type type_bank is array(0 to 15) of std_logic_vector(8 downto 0);
   signal bankreg: type_bank;
   signal fpgardata: std_logic_vector(7 downto 0);
   signal fpgarack: std_logic;
   --ram
   type ram_state is ( RS_NOP, RS_IDLE, RS_READ_0, RS_READ_1, RS_WRITE_0, RS_WRITE_1 );
   signal rstate: ram_state;
   signal ramaddr: std_logic_vector(RA'range);
   signal ramwdata: std_logic_vector(7 downto 0);
   signal ramrd: std_logic;
   signal ramwr: std_logic;
   signal ramcs: std_logic;
   --
   type type_intram is array(0 to 4095) of std_logic_vector(7 downto 0);
   signal intram: type_intram;
   signal intramaddr: std_logic_vector(11 downto 0);
   signal intramrdata: std_logic_vector(7 downto 0);
   signal intramwdata: std_logic_vector(7 downto 0);
   signal intramwe: std_logic;
   signal intramen: std_logic;
   --
   signal cpuramrdata: std_logic_vector(7 downto 0);
   signal cpuramrack: std_logic;
   signal busramrdata: std_logic_vector(7 downto 0);
   signal busramrwack: std_logic;
   --ext
   signal fextirq: std_logic;
   type ext_state is ( ES_NOP, ES_CPU, ES_BUS );
   signal estate: ext_state;
   signal extrs: std_logic_vector(EnRS'range);
   signal exta14: std_logic_vector(EA14'range);
   signal extaddr: std_logic_vector(EA'range);
   signal extwdata: std_logic_vector(7 downto 0);
   signal extrnw: std_logic;
   --
   signal sred: std_logic_vector(15 downto 0);
   signal cpuextrdata: std_logic_vector(7 downto 0);
   signal cpuextrack: std_logic;
   signal busextrdata: std_logic_vector(7 downto 0);
   signal busextrwack: std_logic;
   --bus
   constant BIT_VRC6:   integer := 0;
   constant BIT_VRC7:   integer := 1;
   constant BIT_RP2C33: integer := 2;
   constant BIT_MMC5:   integer := 3;
   constant BIT_163:    integer := 4;
   constant BIT_5B:     integer := 5;
   constant DEF_VRC6:   std_logic_vector(1 downto 0) := "01";
   constant DEF_VRC7:   std_logic_vector(1 downto 0) := "00";
   constant DEF_RP2C33: std_logic_vector(1 downto 0) := "01";
   constant DEF_MMC5:   std_logic_vector(1 downto 0) := "00";
   constant DEF_163:    std_logic_vector(1 downto 0) := "10";
   constant DEF_5B:     std_logic_vector(1 downto 0) := "01";
   signal sric: std_logic;
   signal srcswr: std_logic_vector(1 downto 0);
   signal srcsrd: std_logic_vector(1 downto 0);
   signal sraddr: std_logic_vector(5 downto 0);
   signal srdata: std_logic_vector(15 downto 0);
   signal regindex: std_logic_vector(11 downto 0);
   signal enbcpuregread: std_logic;
   signal enbmmc5romread: std_logic;
   signal enb163regread: std_logic;
   signal enbnc: std_logic;
   signal enbstop: std_logic;
   signal enbcpureset: std_logic;
   signal busramatemp: std_logic_vector(20 downto 0);
   signal busramaddr: std_logic_vector(busramatemp'range);
   signal busramwdata: std_logic_vector(7 downto 0);
   signal busramrnw: std_logic;
   signal busramrwreq: std_logic;
   signal vbdivcnt: std_logic_vector(15 downto 0);
   type type_romsel is array(0 to 5) of std_logic_vector(1 downto 0);
   signal extromsel: type_romsel;
   signal busextrs: std_logic_vector(EnRS'range);
   signal busextaddr: std_logic_vector(BA'range);
   signal busextwdata: std_logic_vector(7 downto 0);
   signal busextrnw: std_logic;
   signal busextrwreq: std_logic;
   signal busrdata: std_logic_vector(7 downto 0);
   --dipsw
   signal selncs: std_logic;
   --
   attribute RAM_STYLE: string;
   attribute RAM_STYLE of cpureg: signal is "DISTRIBUTED";
   attribute RAM_STYLE of bankreg: signal is "DISTRIBUTED";
   attribute RAM_STYLE of intram: signal is "BLOCK";
   --
   procedure conv_addr(
      addr: in std_logic_vector(7 downto 0);
      ers: out std_logic_vector(EnRS'range);
      eaddr: out std_logic_vector(BA'range)) is
   begin
      --
      ers := (others => '0');
      eaddr := (others => '0');
      case addr is
--       when X"00" | X"01" | X"02" | X"03" | X"04" | X"05" | X"06" | X"07" |
--          X"08" | X"09" | X"0a" | X"0b" | X"0c" | X"0d" | X"0e" | X"0f" |
--          X"10" | X"11" | X"12" | X"13" | X"14" | X"15" | X"16" | X"17" =>
--          --cpu
--          eaddr := X"40" & "000" & addr(4 downto 0);
--       when X"1f" =>
--          --bank
--          eaddr := X"5fff";
         when X"28" | X"29" | X"2a" | X"2b" =>
            eaddr := X"904" & "00" & addr(1 downto 0);
            ers := conv_rs(extromsel(BIT_VRC6));
         when X"2c" | X"2d" | X"2e" | X"2f" =>
            eaddr := X"a05" & "00" & addr(1 downto 0);
            ers := conv_rs(extromsel(BIT_VRC6));
         when X"30" | X"31" | X"32" | X"33" =>
            eaddr := X"b05" & "00" & addr(1 downto 0);
            ers := conv_rs(extromsel(BIT_VRC6));
         when X"38" =>
            eaddr := X"9011";
            ers := conv_rs(extromsel(BIT_VRC7));
         when X"39" =>
            eaddr := X"9031";
            ers := conv_rs(extromsel(BIT_VRC7));
         when X"3a" =>
            eaddr := X"e003";
            ers := conv_rs(extromsel(BIT_VRC7));
         when X"40" | X"41" | X"42" | X"43" | X"44" | X"45" | X"46" | X"47" |
            X"48" | X"49" | X"4a" | X"4b" | X"4c" | X"4d" | X"4e" | X"4f" |
            X"50" | X"51" | X"52" | X"53" | X"54" | X"55" | X"56" | X"57" |
            X"58" | X"59" | X"5a" | X"5b" | X"5c" | X"5d" | X"5e" | X"5f" |
            X"60" | X"61" | X"62" | X"63" | X"64" | X"65" | X"66" | X"67" |
            X"68" | X"69" | X"6a" | X"6b" | X"6c" | X"6d" | X"6e" | X"6f" |
            X"70" | X"71" | X"72" | X"73" | X"74" | X"75" | X"76" | X"77" |
            X"78" | X"79" | X"7a" | X"7b" | X"7c" | X"7d" | X"7e" | X"7f" |
            X"80" | X"81" | X"82" | X"83" | X"84" | X"85" | X"86" | X"87" |
            X"88" | X"89" | X"8a" | X"8b" | X"8c" | X"8d" | X"8e" | X"8f" |
            X"90" | X"91" | X"92" | X"93" | X"94" | X"95" | X"96" | X"97" |
            X"98" | X"99" | X"9a" | X"9b" | X"9c" | X"9d" | X"9e" | X"9f" |
            X"a0" | X"a1" | X"a2" | X"a3" | X"a4" | X"a5" | X"a6" | X"a7" |
            X"a8" | X"a9" | X"aa" | X"ab" | X"ac" | X"ad" | X"ae" | X"af" |
            X"b0" | X"b1" | X"b2" | X"b3" | X"b4" | X"b5" | X"b6" | X"b7" |
            X"b8" | X"b9" | X"ba" | X"bb" | X"bc" | X"bd" | X"be" | X"bf" =>
            eaddr := X"40" & (addr-X"20");
            ers := conv_rs(extromsel(BIT_RP2C33));
         when X"d0" | X"d1" | X"d2" | X"d3" | X"d4" | X"d5" | X"d6" | X"d7" |
            X"d8" | X"d9" | X"da" | X"db" | X"dc" | X"dd" | X"de" | X"df" |
            X"e0" | X"e1" | X"e2" | X"e3" | X"e4" | X"e5" | X"e6" | X"e7" =>
            eaddr := X"50" & (addr-X"d0");
            ers := conv_rs(extromsel(BIT_MMC5));
         when X"f0" =>
            eaddr := X"f853";
            ers := conv_rs(extromsel(BIT_163));
         when X"f1" =>
            eaddr := X"4853";
            ers := conv_rs(extromsel(BIT_163));
         when X"f2" =>
            eaddr := X"e053";
            ers := conv_rs(extromsel(BIT_163));
         when X"f8" =>
            eaddr := X"c053";
            ers := conv_rs(extromsel(BIT_5B));
         when X"f9" =>
            eaddr := X"e053";
            ers := conv_rs(extromsel(BIT_5B));
         when X"fa" =>
            eaddr := X"8053";
            ers := conv_rs(extromsel(BIT_5B));
         when X"fb" =>
            eaddr := X"a053";
            ers := conv_rs(extromsel(BIT_5B));
         when others =>
            null;
      end case;
   end conv_addr;
begin

   --cpu
-- BnRST <= '0' when(enbcpureset='1') else 'Z';
   process(CLK)
      variable v_st: sb_odoutst;
   begin
      if CLK'event and CLK='1' then
         if enbcpureset='1' then
            v_st := (others => '1');
         else
            v_st := v_st(0) & '0';
         end if;
      end if;
      BnRST <= odout(v_st);
   end process;
   BnNMI <= '0' when(enbcpureset='0' and enbppuintr='1' and fppunmi='1') else 'Z';
   BnIRQ <= '0' when(enbcpureset='0' and fextirq='1') else 'Z';
   BNC <= enbnc;
   BD <= cpurdata when(enbcpureset='0' and srbphi2(1)='1' and srbrnw(1)='1' and cpurack='1') else (others => 'Z');
   process(cpuramrdata, cpuramrack, fpgardata, fpgarack, cpuextrdata, cpuextrack)
      variable v_data: std_logic_vector(cpurdata'range);
   begin
      v_data := (others => '1');
      if cpuramrack='1' then
         v_data := v_data and cpuramrdata;
      end if;
      if fpgarack='1' then
         v_data := v_data and fpgardata;
      end if;
      if cpuextrack='1' then
         v_data := v_data and cpuextrdata;
      end if;
      cpurdata <= v_data;
      cpurack <= cpuramrack or fpgarack or cpuextrack;
   end process;

   --
   process(CLK)
      variable v_bphi2, v_bphi2b: std_logic;
      variable v_phi2: std_logic;
      variable v_cnt: integer range 0 to 15;
   begin
      if CLK'event and CLK='1' then
         v_bphi2b := v_bphi2;
         v_bphi2 := BPhi2;
         if enbcpureset='1' then
            if v_cnt>=(12-1) then   --2a03h
               v_cnt := 0;
            else
               v_cnt := v_cnt + 1;
            end if;
            srbrnw <= (others => '0');
            srba <= (others => '0');
            srbd <= (others => '0');
         else
            if v_bphi2b='1' and v_bphi2='0' then
               v_cnt := 0;
            else
               v_cnt := v_cnt + 1;
            end if;
            srbrnw <= BRnW & srbrnw(1);
            srba <= BA & srba(31 downto 16);
            srbd <= BD & srbd(15 downto 8);
         end if;
--       if v_cnt<4 then            --2a03h
         if v_cnt<5 then            --2a03h+ext(ssgl/ssglp, phim duty)
            v_phi2 := '0';
         else
            v_phi2 := '1';
         end if;
         srbphi2 <= v_phi2 & srbphi2(1);
      end if;
   end process;

   --
   fppunmi <= '1' when(ppuintrreq/=ppuintrack) else '0';
   process(CLK)
      variable v_vbcnt: std_logic_vector(vbdivcnt'range);
      variable v_brnw: std_logic;
      variable v_baddr: std_logic_vector(BA'range);
      variable v_bdata: std_logic_vector(BD'range);
   begin
      if CLK'event and CLK='1' then
         if enbcpureset='1' then
            v_vbcnt := (others => '0');
            enbppuintr <= '0';
            ppuintrreq <= '0';
            ppuintrack <= '0';
            enbromwrite <= '0';
            enbextmask <= (others => '0');
            bankreg(15) <= "1" & X"00";
            fpgardata <= (others => '0');
            fpgarack <= '0';
         else
            --read
            case srbphi2 is
               when "01" | "00" =>
                  fpgarack <= '0';
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
                  v_brnw := srbrnw(1);
                  v_baddr := srba(31 downto 16);
                  fpgarack <= '0';
                  if v_brnw='1' then
                     case v_baddr(15 downto 12) is
                        when X"2" =>
                           if v_baddr(2 downto 0)="010" then
                              --ppu, $2002
                              --  b7: vblank, vblank/no#
                              --  b0: stop, stop/no#
                              if fppunmi='1' then
                                 ppuintrack <= not ppuintrack;
                              end if;
                              fpgardata <= fppunmi & "000000" & enbstop;
                              fpgarack <= '1';
                           end if;
                        when X"4" =>
                           case v_baddr(11 downto 0) is
                              when X"000" | X"001" | X"002" | X"003" | X"004" | X"005" | X"006" | X"007" |
                                 X"008" | X"009" | X"00a" | X"00b" | X"00c" | X"00d" | X"00e" | X"00f" |
                                 X"010" | X"011" | X"012" | X"013" =>
                                 --cpu, $4000~$4013
                                 fpgardata <= cpureg(conv_integer(v_baddr(4 downto 0)));
                                 fpgarack <= enbcpuregread;
                              when X"016" | X"017" =>
                                 --cpu, $4016~$4017
                                 fpgardata <= (others => '0');
                                 fpgarack <= '1';
                              when others =>
                                 null;
                           end case;
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
            case srbphi2 is
               when "01" =>
                  v_brnw := srbrnw(0);
                  v_baddr := srba(15 downto 0);
                  v_bdata := srbd(7 downto 0);
                  if v_brnw='0' then
                     case v_baddr(15 downto 12) is
                        when X"2" =>
                           if v_baddr(2 downto 0)="000" then
                              --ppu, $2000
                              --  b7: vblank nmi, enable/disable#
                              enbppuintr <= v_bdata(7);
                           end if;
                        when X"3" =>
                           if v_baddr(11 downto 0)=X"800" then
                              --rom/ext, $3800
                              --  b7: rom($8000~$ffff) write, enable/disable#
                              --  b5: mask 5b, enable/disable#
                              --  b4: mask 163, enable/disable#
                              --  b3: mask mmc5, enable/disable#
                              --  b2: mask rp2c33, enable/disable#
                              --  b1: mask vrc7, enable/disable#
                              --  b0: mask vrc6, enable/disable#
                              enbromwrite <= v_bdata(7);
                              enbextmask(BIT_5B) <= v_bdata(5);
                              enbextmask(BIT_163) <= v_bdata(4);
                              enbextmask(BIT_MMC5) <= v_bdata(3);
                              enbextmask(BIT_RP2C33) <= v_bdata(2);
                              enbextmask(BIT_VRC7) <= v_bdata(1);
                              enbextmask(BIT_VRC6) <= v_bdata(0);
                           end if;
                        when X"4" =>
                           if v_baddr(11 downto 5)="0000000" then
                              --cpu, $4000~$401f
                              cpureg(conv_integer(v_baddr(4 downto 0))) <= v_bdata;
                           end if;
                        when X"5" =>
                           if v_baddr(11 downto 0)>=X"ff6" then
                              --bank, $5ff6~$5ff7/$5ff8~$5fff
                              bankreg(conv_integer(v_baddr(3 downto 0))) <= "0" & v_bdata;
                           end if;
                        when others =>
                           null;
                     end case;
                  end if;
               when "00" =>
                  null;
               when "10" | "11" =>
                  null;
               when others =>
                  null;
            end case;
         end if;
      end if;
   end process;

   --ram
   RA <= ramaddr;
   RD <= ramwdata when(ramwr='1') else (others => 'Z');
   RnRD <= '0' when(ramrd='1') else '1';
   RnWR <= '0' when(ramwr='1') else '1';
   RnCS <= '0' when(ramcs='1') else '1';
   process(CLK)
   begin
      if CLK'event and CLK='1' then
         if intramen='1' then
            if intramwe='1' then
               intram(conv_integer(intramaddr)) <= intramwdata;
               intramrdata <= intramwdata;
            else
               intramrdata <= intram(conv_integer(intramaddr));
            end if;
         end if;
      end if;
   end process;

   --
   process(CLK)
      variable v_brnw: std_logic;
      variable v_baddr: std_logic_vector(BA'range);
      variable v_bdata: std_logic_vector(BD'range);
      variable v_addr: std_logic_vector(20 downto 0);
   begin
      if CLK'event and CLK='1' then
         if sric='1' then
            rstate <= RS_NOP;
            ramaddr <= (others => '0');
            ramwdata <= (others => '0');
            ramrd <= '0';
            ramwr <= '0';
            ramcs <= '0';
            intramaddr <= (others => '0');
            intramwdata <= (others => '0');
            intramwe <= '0';
            intramen <= '0';
            cpuramrdata <= (others => '0');
            cpuramrack <= '0';
            busramrdata <= (others => '0');
            busramrwack <= '0';
         else
            case srbphi2 is
               when "01" =>
                  ramrd <= '0';
                  ramwr <= '0';
                  ramcs <= '0';
                  intramwe <= '0';
                  intramen <= '0';
                  cpuramrack <= '0';
                  if busramrwack/=busramrwreq then
                     rstate <= RS_IDLE;
                  else
                     rstate <= RS_NOP;
                  end if;
               when "00" | "10" =>
                  cpuramrack <= '0';
                  case rstate is
                     when RS_IDLE =>
                        if busramaddr(20)='0' then
                           ramaddr <= busramaddr(ramaddr'range);
                           ramwdata <= busramwdata;
                           ramcs <= '1';
                           if busramrnw='1' then
                              ramrd <= '1';
                              rstate <= RS_READ_0;
                           else
                              ramwr <= '1';
                              rstate <= RS_WRITE_0;
                           end if;
                        else
                           intramaddr <= busramaddr(intramaddr'range);
                           intramwdata <= busramwdata;
                           intramen <= '1';
                           if busramrnw='1' then
                              intramwe <= '0';
                              rstate <= RS_READ_0;
                           else
                              intramwe <= '1';
                              rstate <= RS_WRITE_0;
                           end if;
                        end if;
                     when RS_READ_0 =>
                        rstate <= RS_READ_1;
                     when RS_READ_1 =>
                        if busramaddr(20)='0' then
                           ramrd <= '0';
                           ramcs <= '0';
                           busramrdata <= RD;
                        else
                           intramwe <= '0';
                           intramen <= '0';
                           busramrdata <= intramrdata;
                        end if;
                        busramrwack <= not busramrwack;
                        rstate <= RS_NOP;
                     when RS_WRITE_0 =>
                        rstate <= RS_WRITE_1;
                     when RS_WRITE_1 =>
                        if busramaddr(20)='0' then
                           ramwr <= '0';
                           ramcs <= '0';
                        else
                           intramwe <= '0';
                           intramen <= '0';
                        end if;
                        busramrwack <= not busramrwack;
                        rstate <= RS_NOP;
                     when others =>
                        rstate <= RS_NOP;
                  end case;

               when "11" =>
                  v_brnw := srbrnw(1);
                  v_baddr := srba(31 downto 16);
                  v_bdata := srbd(15 downto 8);
                  v_addr := (others => '1');
                  if v_brnw='1' then
                     case v_baddr(15 downto 12) is
                        when X"0" | X"1" =>
                           --ram, $0000~$07ff
                           v_addr := "1" & X"00" & "0" & v_baddr(10 downto 0);
                        when X"3" =>
                           --ctl, $3800~$3fff
                           v_addr := "1" & X"00" & "1" & v_baddr(10 downto 0);
                        when X"6" | X"7" | X"8" | X"9" | X"a" | X"b" | X"c" | X"d" | X"e" | X"f" =>
                           --ram, $6000~$7fff
                           --rom, $8000~$ffff
                           v_addr := bankreg(conv_integer(v_baddr(15 downto 12))) & v_baddr(11 downto 0);
                        when others =>
                           null;
                     end case;
                  else
                     case v_baddr(15 downto 12) is
                        when X"0" | X"1" =>
                           --ram, $0000~$07ff
                           v_addr := "1" & X"00" & "0" & v_baddr(10 downto 0);
                        when X"6" | X"7" =>
                           --ram, $6000~$7fff
                           v_addr := bankreg(conv_integer(v_baddr(15 downto 12))) & v_baddr(11 downto 0);
                        when X"8" | X"9" | X"a" | X"b" | X"c" | X"d" | X"e" | X"f" =>
                           --rom, $8000~$ffff
                           if enbromwrite='1' then
                              v_addr := bankreg(conv_integer(v_baddr(15 downto 12))) & v_baddr(11 downto 0);
                           end if;
                        when others =>
                           null;
                     end case;
                  end if;
                  --
                  rstate <= RS_NOP;
                  if enbcpureset='1' or conv_integer(not v_addr)=0 then
                     ramrd <= '0';
                     ramwr <= '0';
                     ramcs <= '0';
                     intramwe <= '0';
                     intramen <= '0';
                  else
                     if v_addr(20)='0' then
                        ramaddr <= v_addr(ramaddr'range);
                        ramwdata <= v_bdata;
                        ramcs <= '1';
                        if v_brnw='1' then
                           ramrd <= '1';
                           cpuramrdata <= RD;
                           cpuramrack <= '1';
                        else
                           ramwr <= '1';
                        end if;
                     else
                        intramaddr <= v_addr(intramaddr'range);
                        intramwdata <= v_bdata;
                        intramen <= '1';
                        if v_brnw='1' then
                           intramwe <= '0';
                           cpuramrdata <= intramrdata;
                           cpuramrack <= '1';
                        else
                           intramwe <= '1';
                        end if;
                     end if;
                  end if;

               when others =>
                  rstate <= RS_NOP;
            end case;
         end if;
      end if;
   end process;

   --ext
   fextirq <= '1' when(EnIRQ='0') else '0';
-- EnRST <= '0' when(sric='1') else 'Z';
   process(CLK)
      variable v_st: sb_odoutst;
   begin
      if CLK'event and CLK='1' then
         if sric='1' then
            v_st := (others => '1');
         else
            v_st := v_st(0) & '0';
         end if;
      end if;
      EnRST <= odout(v_st);
   end process;
   EnRS <= (not extrs) when(srbphi2(0)='1') else (others => '1');
   EA14 <= exta14;
   EA <= extaddr;
   ED <= extwdata when(srbphi2(0)='1' and extrnw='0' and conv_integer(extrs or exta14)/=0) else (others => 'Z');
   EPhi2 <= srbphi2(1);
   ERnW <= extrnw;
   process(CLK)
      variable v_rs: std_logic_vector(EnRS'range);
      variable v_rnw: std_logic;
      variable v_addr: std_logic_vector(BA'range);
      variable v_data: std_logic_vector(BD'range);
   begin
      if CLK'event and CLK='1' then
         if sric='1' then
            estate <= ES_NOP;
            extrs <= (others => '0');
            exta14 <= (others => '0');
            extaddr <= (others => '0');
            extwdata <= (others => '0');
            extrnw <= '0';
            --
            sred <= (others => '0');
            cpuextrdata <= (others => '0');
            cpuextrack <= '0';
            busextrdata <= (others => '0');
            busextrwack <= '0';
         else
            --
            case srbphi2 is
               when "01" =>
                  if estate=ES_BUS then
                     busextrwack <= not busextrwack;
                  end if;
               when "00" =>
                  if busextrwack/=busextrwreq then
                     estate <= ES_BUS;
                  elsif enbcpureset='1' then
                     estate <= ES_NOP;
                  else
                     estate <= ES_CPU;
                  end if;
               when "10" | "11" =>
                  null;
               when others =>
                  estate <= ES_NOP;
            end case;
            --
            v_rs := (others => '0');
            case estate is
               when ES_CPU =>
                  v_rnw := srbrnw(1);
                  v_addr := srba(31 downto 16);
                  v_data := srbd(15 downto 8);
                  if v_rnw='1' then
                     case v_addr(15 downto 4) is
                        when X"402" | X"403" | X"404" | X"405" | X"406" | X"407" | X"408" | X"409" =>
                           --rp2c33, $4020~$409f
                           if enbextmask(BIT_RP2C33)='0' then
                              v_rs := conv_rs(extromsel(BIT_RP2C33));
                           end if;
                        when X"480" =>
                           --163, $4800
                           if v_addr(3 downto 0)=X"0" and enbextmask(BIT_163)='0' and enb163regread='1' then
                              v_rs := conv_rs(extromsel(BIT_163));
                              v_addr(7 downto 0) := X"53";
                           end if;
                        when others =>
                           null;
                     end case;
                  else
                     case v_addr(15 downto 4) is
                        when X"900" =>
                           --vrc6, $9000~$9003
                           if v_addr(3 downto 2)="00" and enbextmask(BIT_VRC6)='0' then
                              v_rs := conv_rs(extromsel(BIT_VRC6));
                              v_addr(7 downto 4) := X"4";
                           end if;
                        when X"a00" | X"b00" =>
                           --vrc6, $a000~$a003/$b000~$b003
                           if v_addr(3 downto 2)="00" and enbextmask(BIT_VRC6)='0' then
                              v_rs := conv_rs(extromsel(BIT_VRC6));
                              v_addr(7 downto 4) := X"5";
                           end if;
                        when X"901" | X"903" =>
                           --vrc7, $9010/$9030
                           if v_addr(3 downto 0)=X"0" and enbextmask(BIT_VRC7)='0' then
                              v_rs := conv_rs(extromsel(BIT_VRC7));
                              v_addr(3 downto 0) := X"1";
                           end if;
                        when X"310" =>
                           --vrc7, $3100($e000)
                           if v_addr(3 downto 0)=X"0" and enbextmask(BIT_VRC7)='0' then
                              v_rs := conv_rs(extromsel(BIT_VRC7));
                              v_addr(15 downto 0) := X"e003";
                           end if;
                        when X"402" | X"403" | X"404" | X"405" | X"406" | X"407" | X"408" | X"409" =>
                           --rp2c33, $4020~$409f
                           if enbextmask(BIT_RP2C33)='0' then
                              v_rs := conv_rs(extromsel(BIT_RP2C33));
                           end if;
                        when X"500" | X"501" =>
                           --mmc5, $5000~$501f
                           if enbextmask(BIT_MMC5)='0' then
                              v_rs := conv_rs(extromsel(BIT_MMC5));
                           end if;
                        when X"f80" | X"480" =>
                           --163, $f800/$4800
                           if v_addr(3 downto 0)=X"0" and enbextmask(BIT_163)='0' then
                              v_rs := conv_rs(extromsel(BIT_163));
                              v_addr(7 downto 0) := X"53";
                           end if;
                        when X"340" =>
                           --163, $3400($e000)
                           if v_addr(3 downto 0)=X"0" and enbextmask(BIT_163)='0' then
                              v_rs := conv_rs(extromsel(BIT_163));
                              v_addr(15 downto 0) := X"e053";
                           end if;
                        when X"c00" | X"e00" =>
                           --5b, $c000/$e000
                           if v_addr(3 downto 0)=X"0" and enbextmask(BIT_5B)='0' then
                              v_rs := conv_rs(extromsel(BIT_5B));
                              v_addr(7 downto 0) := X"53";
                           end if;
                        when X"358" =>
                           --5b, $3580($8000)
                           if v_addr(3 downto 0)=X"0" and enbextmask(BIT_5B)='0' then
                              v_rs := conv_rs(extromsel(BIT_5B));
                              v_addr(15 downto 0) := X"8053";
                           end if;
                        when X"35a" =>
                           --5b, $35a0($a000)
                           if v_addr(3 downto 0)=X"0" and enbextmask(BIT_5B)='0' then
                              v_rs := conv_rs(extromsel(BIT_5B));
                              v_addr(15 downto 0) := X"a053";
                           end if;
                        when others =>
                           null;
                     end case;
                  end if;
               when ES_BUS =>
                  v_rs := busextrs;
                  v_rnw := busextrnw;
                  v_addr := busextaddr;
                  v_data := busextwdata;
               when others =>
                  null;
            end case;
            --
            if conv_integer(v_rs)=0 then
               v_rs := (others => '0');
               v_rnw := '0';
               v_addr := (others => '0');
               v_data := (others => '0');
            end if;
            extrs <= v_rs and (v_addr(15) & v_addr(15) & v_addr(15));
            exta14 <= v_rs and (v_addr(14) & v_addr(14) & v_addr(14));
            extaddr <= v_addr(13 downto 0);
            extwdata <= v_data;
            extrnw <= v_rnw;
            --
            sred <= ED & sred(15 downto 8);
            cpuextrack <= '0';
            if conv_integer(v_rs)/=0 and v_rnw='1' then
               case srbphi2 is
                  when "10" | "11" =>
                     case estate is
                        when ES_CPU =>
                           cpuextrdata <= sred(15 downto 8);
                           cpuextrack <= '1';
                        when ES_BUS =>
                           busextrdata <= sred(15 downto 8);
                        when others =>
                           null;
                     end case;
                  when others =>
                     null;
               end case;
            end if;
         end if;
      end if;
   end process;

   --bus
   D <= busrdata when(selncs='0' and nRD='0' and nWR='1') else (others => 'Z');
   nIRQ <= 'Z';
   process(CLK)
      variable v_rs: std_logic_vector(EnRS'range);
      variable v_addr: std_logic_vector(BA'range);
      variable v_romsel: std_logic_vector(1 downto 0);
      variable v_busy: std_logic;
   begin
      if CLK'event and CLK='1' then
         sric <= not nIC;
         if sric='1' then
            srcswr <= (others => '0');
            srcsrd <= (others => '0');
            sraddr <= (others => '0');
            srdata <= (others => '0');
            regindex <= (others => '0');
            enbcpuregread <= '0';
            enbmmc5romread <= '0';
            enb163regread <= '0';
            enbnc <= '0';
            enbstop <= '1';
            enbcpureset <= '1';
            busramatemp <= (others => '0');
            busramaddr <= (others => '0');
            busramwdata <= (others => '0');
            busramrnw <= '0';
            busramrwreq <= '0';
            vbdivcnt <= (others => '0');
            extromsel(BIT_VRC6) <= DEF_VRC6;
            extromsel(BIT_VRC7) <= DEF_VRC7;
            extromsel(BIT_RP2C33) <= DEF_RP2C33;
            extromsel(BIT_MMC5) <= DEF_MMC5;
            extromsel(BIT_163) <= DEF_163;
            extromsel(BIT_5B) <= DEF_5B;
            busextrs <= (others => '0');
            busextaddr <= (others => '0');
            busextwdata <= (others => '0');
            busextrnw <= '0';
            busextrwreq <= '0';
            busrdata <= (others => '0');
         else
            srcswr <= ((not selncs) and (not nWR)) & srcswr(1);
            srcsrd <= ((not selncs) and (not nRD)) & srcsrd(1);
            sraddr <= A(2 downto 0) & sraddr(5 downto 3);
            srdata <= D & srdata(15 downto 8);
            if srcswr="01" then
               case sraddr(2 downto 0) is
                  when "000" | "010" | "100" | "110" =>
                     --fpga/ext, address
                     regindex <= "00" & sraddr(2 downto 1) & srdata(7 downto 0);
                  when "001" | "011" | "101" | "111" =>
                     --fpga/ext, data
                     case regindex(11 downto 8) is
                        when X"2" =>
                           --ext write data
                           conv_addr(regindex(7 downto 0), v_rs, v_addr);
                           if conv_integer(v_rs)/=0 then
                              busextrs <= v_rs;
                              busextaddr <= v_addr;
                              busextwdata <= srdata(7 downto 0);
                              busextrnw <= '0';
                              busextrwreq <= not busextrwreq;
                           end if;
                        when others =>
                           case regindex is
                              when X"301" =>
                                 --fpga, mode
                                 --  b7: cpu_regread, enable/disable#
                                 --  b6: mmc5_romread, enable/disable#
                                 --  b5: 163_regread, enable/disable#
                                 --  b3: nc, high/low#
                                 --  b1: stop, enable/disable#
                                 --  b0: cpu_reset, enable/disable#
                                 enbcpuregread <= srdata(7);
                                 enbmmc5romread <= srdata(6);
                                 enb163regread <= srdata(5);
                                 enbnc <= srdata(3);
                                 enbstop <= srdata(1);
                                 enbcpureset <= srdata(0);
                              when X"302" =>
                                 --ram, low address
                                 busramatemp(15 downto 8) <= srdata(7 downto 0);
                                 busramatemp(7 downto 0) <= (others => '0');
                              when X"303" =>
                                 --ram, high address
                                 --  b4: 0=$000000-$0fffff, rom
                                 --      1=$100000-$1007ff, ram
                                 --      1=$100800-$100fff, ctl
                                 busramatemp(20 downto 16) <= srdata(4 downto 0);
                              when X"308" =>
                                 --ram, write data
                                 busramaddr <= busramatemp;
                                 busramatemp <= busramatemp + 1;
                                 busramwdata <= srdata(7 downto 0);
                                 busramrnw <= '0';
                                 busramrwreq <= not busramrwreq;
                              when X"309" =>
                                 --ppu, low vblank timing
                                 vbdivcnt(7 downto 0) <= srdata(7 downto 0);
                              when X"30a" =>
                                 --ppu, high vblank timing
                                 vbdivcnt(15 downto 8) <= srdata(7 downto 0);
                              when X"318" =>
                                 --ram, read data
                                 busramaddr <= busramatemp(20 downto 8) & srdata(7 downto 0);
                                 busramatemp(7 downto 0) <= srdata(7 downto 0);
                                 busramrnw <= '1';
                                 busramrwreq <= not busramrwreq;

                              when X"344" =>
                                 --cpu/ext, romsel
                                 --  b6-4: 0=vrc6
                                 --        1=vrc7
                                 --        2=rp2c33
                                 --        3=mmc5
                                 --        4=163
                                 --        5=5b
                                 --  b1-0: 0=rs0
                                 --        1=rs1
                                 --        2=rs2
                                 --        3=default
                                 v_romsel := srdata(1 downto 0);
                                 case srdata(6 downto 4) is
                                    when "000" =>
                                       if v_romsel="11" then
                                          v_romsel := DEF_VRC6;
                                       end if;
                                       extromsel(BIT_VRC6) <= v_romsel;
                                    when "001" =>
                                       if v_romsel="11" then
                                          v_romsel := DEF_VRC7;
                                       end if;
                                       extromsel(BIT_VRC7) <= v_romsel;
                                    when "010" =>
                                       if v_romsel="11" then
                                          v_romsel := DEF_RP2C33;
                                       end if;
                                       extromsel(BIT_RP2C33) <= v_romsel;
                                    when "011" =>
                                       if v_romsel="11" then
                                          v_romsel := DEF_MMC5;
                                       end if;
                                       extromsel(BIT_MMC5) <= v_romsel;
                                    when "100" =>
                                       if v_romsel="11" then
                                          v_romsel := DEF_163;
                                       end if;
                                       extromsel(BIT_163) <= v_romsel;
                                    when "101" =>
                                       if v_romsel="11" then
                                          v_romsel := DEF_5B;
                                       end if;
                                       extromsel(BIT_5B) <= v_romsel;
                                    when others =>
                                       null;
                                 end case;

                              when X"382" =>
                                 --ext, low address
                                 busextaddr(7 downto 0) <= srdata(7 downto 0);
                              when X"383" =>
                                 --ext, high address
                                 busextaddr(15 downto 8) <= srdata(7 downto 0);
                              when X"384" =>
                                 --ext, romsel
                                 --  b2: rs2, enable/disable#
                                 --  b1: rs1, enable/disable#
                                 --  b0: rs0, enable/disable#
                                 busextrs <= srdata(2 downto 0);
                              when X"388" =>
                                 --ext, write data
                                 busextwdata <= srdata(7 downto 0);
                                 if conv_integer(busextrs)/=0 then
                                    busextrnw <= '0';
                                    busextrwreq <= not busextrwreq;
                                 end if;
                              when X"398" =>
                                 --ext, read data
                                 busextaddr(7 downto 0) <= srdata(7 downto 0);
                                 case busextrs is
                                    when "001" | "010" | "100" =>
                                       busextrnw <= '1';
                                       busextrwreq <= not busextrwreq;
                                    when others =>
                                       null;
                                 end case;
                              when others =>
                                 null;
                           end case;
                     end case;
                  when others =>
                     null;
               end case;
            end if;
            --
            if srcsrd="10" then
               v_busy := not ((busramrwreq xor busramrwack) or (busextrwreq xor busextrwack));
               case sraddr(5 downto 3) is
                  when "000" | "010" | "100" | "110" =>
                     --fpga/ext, address
                     busrdata <= (not v_busy) & "000" & v_busy & v_busy & "00";
                  when "001" | "011" | "101" | "111" =>
                     --fpga/ext, data
                     case regindex is
                        when X"318" =>
                           --ram, read data
                           busrdata <= busramrdata;
                        when X"398" =>
                           --ext, read data
                           busrdata <= busextrdata;
                        when others =>
                           busrdata <= X"ff";
                     end case;
                  when others =>
                     null;
               end case;
            end if;
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
