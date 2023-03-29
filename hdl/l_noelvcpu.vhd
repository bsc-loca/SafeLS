
library ieee;
use ieee.std_logic_1164.all;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
library gaisler;
use gaisler.noelvint.all;
use gaisler.noelv.all;
use gaisler.arith.all;


entity l_noelvcpu is
  generic (
    hindex   : integer;
    fabtech  : integer;
    memtech  : integer;
    mularch  : integer;
    cached   : integer;
    wbmask   : integer;
    busw     : integer;
    cmemconf : integer;
    rfconf   : integer;
    fpuconf  : integer;
    tcmconf  : integer;
    mulconf  : integer;
    disas    : integer;
    pbaddr   : integer;
    cfg      : integer;
    scantest : integer
    );
  port (
    clk   : in  std_ulogic;
    rstn  : in  std_ulogic;
    ahbi  : in  ahb_mst_in_type;
    ahbo  : out ahb_mst_out_type;
    ahbsi : in  ahb_slv_in_type;
    ahbso : in  ahb_slv_out_vector;
    irqi  : in  nv_irq_in_type;
    irqo  : out nv_irq_out_type;
    dbgi  : in  nv_debug_in_type;
    dbgo  : out nv_debug_out_type;
    eto   : out nv_etrace_out_type;
    cnt   : out nv_counter_out_type
    );
end;

architecture hier of l_noelvcpu is

attribute DONT_TOUCH : string;


  component l_comparator is
    port (
      clk           : in  std_ulogic; 
      rstn          : in  std_ulogic; 

      ahbi        : in  ahb_mst_in_type;
      ahbo        : out ahb_mst_out_type; 
      ahbsi       : in  ahb_slv_in_type;
      ahbso       : in  ahb_slv_out_vector;  
      irqi        : in  nv_irq_in_type;     
      irqo        : out nv_irq_out_type;    
      dbgi        : in  nv_debug_in_type;   
      dbgo        : out nv_debug_out_type;  
      eto         : out nv_etrace_out_type;
      cnt         : out nv_counter_out_type; 
      
      mahbi        : out  ahb_mst_in_type;
      mahbsi       : out  ahb_slv_in_type;
      mahbso       : out  ahb_slv_out_vector; 
      mirqi        : out  nv_irq_in_type;     
      mdbgi        : out  nv_debug_in_type;   
      mirqo        : in nv_irq_out_type;    
      mahbo        : in ahb_mst_out_type; 
      mdbgo        : in nv_debug_out_type; 
      meto         : in nv_etrace_out_type;
      mcnt         : in nv_counter_out_type;

      sahbi        : out  ahb_mst_in_type;
      sahbsi       : out  ahb_slv_in_type;
      sahbso       : out  ahb_slv_out_vector; 
      sirqi        : out  nv_irq_in_type;     
      sdbgi        : out  nv_debug_in_type;   
      sirqo        : in nv_irq_out_type;    
      sahbo        : in ahb_mst_out_type; 
      sdbgo        : in nv_debug_out_type; 
      seto         : in nv_etrace_out_type;
      scnt         : in nv_counter_out_type 
      );
  end component l_comparator;





  signal msig_ahbi  : ahb_mst_in_type;
  signal msig_ahbo  : ahb_mst_out_type;
  signal msig_ahbsi : ahb_slv_in_type;
  signal msig_ahbso : ahb_slv_out_vector;
  signal msig_irqi  : nv_irq_in_type;
  signal msig_irqo  : nv_irq_out_type;
  signal msig_dbgi  : nv_debug_in_type;
  signal msig_dbgo  : nv_debug_out_type;
  signal msig_eto   : nv_etrace_out_type;
  signal msig_cnt   : nv_counter_out_type;

  signal ssig_ahbi  : ahb_mst_in_type;
  signal ssig_ahbo  : ahb_mst_out_type;
  signal ssig_ahbsi : ahb_slv_in_type;
  signal ssig_ahbso : ahb_slv_out_vector;
  signal ssig_irqi  : nv_irq_in_type;
  signal ssig_irqo  : nv_irq_out_type;
  signal ssig_dbgi  : nv_debug_in_type;
  signal ssig_dbgo  : nv_debug_out_type;
  signal ssig_eto   : nv_etrace_out_type;
  signal ssig_cnt   : nv_counter_out_type;

  signal vcc            : std_logic;
  signal gnd            : std_logic;

  type cfg_i_type is record
    single_issue  : integer;
    ext_m         : integer;
    ext_a         : integer;
    ext_c         : integer;
    ext_h         : integer;
    ext_zba       : integer;
    ext_zbb       : integer;
    ext_zbc       : integer;
    ext_zbs       : integer;
    ext_zbkb      : integer;
    ext_zbkc      : integer;
    ext_zbkx      : integer;
    ext_sscofpmf  : integer;
    mode_s        : integer;
    mode_u        : integer;
    fpulen        : integer;
    pmp_no_tor    : integer;
    pmp_entries   : integer;
    pmp_g         : integer;
    perf_cnts     : integer;
    perf_evts     : integer;
    perf_bits     : integer;
    tbuf          : integer;
    trigger       : integer;
    icen          : integer;
    iways         : integer;
    iwaysize      : integer;
    ilinesize     : integer;
    dcen          : integer;
    dways         : integer;
    dwaysize      : integer;
    dlinesize     : integer;
    mmuen         : integer;
    itlbnum       : integer;
    dtlbnum       : integer;
    htlbnum       : integer;
    div_hiperf    : integer;
    div_small     : integer;
    late_branch   : integer;
    late_alu      : integer;
    bhtentries    : integer;
    bhtlength     : integer;
    predictor     : integer;
    btbentries    : integer;
    btbsets       : integer;
  end record;
  constant cfg_none : cfg_i_type := (
    single_issue  => 0,
    ext_m         => 0,
    ext_a         => 0,
    ext_c         => 0,
    ext_h         => 0,
    ext_zba       => 0,
    ext_zbb       => 0,
    ext_zbc       => 0,
    ext_zbs       => 0,
    ext_zbkb      => 0,
    ext_zbkc      => 0,
    ext_zbkx      => 0,
    ext_sscofpmf  => 0,
    mode_s        => 0,
    mode_u        => 0,
    fpulen        => 0,
    pmp_no_tor    => 0,
    pmp_entries   => 0,
    pmp_g         => 0,
    perf_cnts     => 0,
    perf_evts     => 0,
    perf_bits     => 0,
    tbuf          => 0,
    trigger       => 0,
    icen          => 0,
    iways         => 4,
    iwaysize      => 4,
    ilinesize     => 8,
    dcen          => 0,
    dways         => 4,
    dwaysize      => 4,
    dlinesize     => 8,
    mmuen         => 0,
    itlbnum       => 2,
    dtlbnum       => 2,
    htlbnum       => 1,
    div_hiperf    => 0,
    div_small     => 0,
    late_branch   => 0,
    late_alu      => 0,
    bhtentries    => 32,
    bhtlength     => 2,
    predictor     => 0,
    btbentries    => 8,
    btbsets       => 1);

  type cfg_type is array (natural range <>) of cfg_i_type;

  constant cfg_c : cfg_type(0 to 7) := (
    -- HPP
    0 => (
      single_issue  => 0,
      ext_m         => 1,
      ext_a         => 1,
      ext_c         => 1,
      ext_h         => 1,
      ext_zba       => 1,
      ext_zbb       => 1,
      ext_zbc       => 1,
      ext_zbs       => 1,
      ext_zbkb      => 1,
      ext_zbkc      => 1,
      ext_zbkx      => 1,
      ext_sscofpmf  => 1,
      mode_s        => 1,
      mode_u        => 1,
      fpulen        => 64,
      pmp_no_tor    => 0,
      pmp_entries   => 8,
      pmp_g         => 10,
      perf_cnts     => 16,
      perf_evts     => 32,
      perf_bits     => 32,
      tbuf          => 4,
      trigger       => 32*0 + 16*1 + 2,
      icen          => 1,
      iways         => 4,
      iwaysize      => 4,
      ilinesize     => 8,
      dcen          => 1,
      dways         => 4,
      dwaysize      => 4,
      dlinesize     => 8,
      mmuen         => 1,
      itlbnum       => 8,
      dtlbnum       => 8,
      htlbnum       => 8,
      div_hiperf    => 1,
      div_small     => 0,
      late_branch   => 1,
      late_alu      => 1,
      bhtentries    => 128,
      bhtlength     => 5,
      predictor     => 2,
      btbentries    => 16,
      btbsets       => 2),
    -- GPP (dual-issue)
    1 => (
      single_issue  => 0,
      ext_m         => 1,
      ext_a         => 1,
      ext_c         => 1,
      ext_h         => 1,
      ext_zba       => 1,
      ext_zbb       => 1,
      ext_zbc       => 0,
      ext_zbs       => 1,
      ext_zbkb      => 1,
      ext_zbkc      => 1,
      ext_zbkx      => 1,
      ext_sscofpmf  => 1,
      mode_s        => 1,
      mode_u        => 1,
      fpulen        => 64,
      pmp_no_tor    => 0,
      pmp_entries   => 8,
      pmp_g         => 10,
      perf_cnts     => 16,
      perf_evts     => 16,
      perf_bits     => 32,
      tbuf          => 4,
      trigger       => 32*0 + 16*1 + 2,
      icen          => 1,
      iways         => 4,
      iwaysize      => 4,
      ilinesize     => 8,
      dcen          => 1,
      dways         => 4,
      dwaysize      => 4,
      dlinesize     => 8,
      mmuen         => 1,
      itlbnum       => 8,
      dtlbnum       => 8,
      htlbnum       => 8,
      div_hiperf    => 1,
      div_small     => 0,
      late_branch   => 1,
      late_alu      => 1,
      bhtentries    => 128,
      bhtlength     => 5,
      predictor     => 2,
      btbentries    => 16,
      btbsets       => 2),
    -- GPP (single-issue)
    2 => (
      single_issue  => 1,
      ext_m         => 1,
      ext_a         => 1,
      ext_c         => 1,
      ext_h         => 1,
      ext_zba       => 1,
      ext_zbb       => 1,
      ext_zbc       => 0,
      ext_zbs       => 1,
      ext_zbkb      => 1,
      ext_zbkc      => 0,
      ext_zbkx      => 0,
      ext_sscofpmf  => 1,
      mode_s        => 1,
      mode_u        => 1,
      fpulen        => 64,
      pmp_no_tor    => 0,
      pmp_entries   => 8,
      pmp_g         => 10,
      perf_cnts     => 16,
      perf_evts     => 16,
      perf_bits     => 32,
      tbuf          => 4,
      trigger       => 32*0 + 16*1 + 2,
      icen          => 1,
      iways         => 4,
      iwaysize      => 4,
      ilinesize     => 8,
      dcen          => 1,
      dways         => 4,
      dwaysize      => 4,
      dlinesize     => 8,
      mmuen         => 1,
      itlbnum       => 8,
      dtlbnum       => 8,
      htlbnum       => 8,
      div_hiperf    => 1,
      div_small     => 0,
      late_branch   => 1,
      late_alu      => 1,
      bhtentries    => 128,
      bhtlength     => 5,
      predictor     => 2,
      btbentries    => 16,
      btbsets       => 2),
    -- MIN (FPU)
    3 => (
      single_issue  => 1,
      ext_m         => 1,
      ext_a         => 1,
      ext_c         => 1,
      ext_h         => 0,
      ext_zba       => 0,
      ext_zbb       => 0,
      ext_zbc       => 0,
      ext_zbs       => 0,
      ext_zbkb      => 0,
      ext_zbkc      => 0,
      ext_zbkx      => 0,
      ext_sscofpmf  => 0,
      mode_s        => 0,
      mode_u        => 1,
      fpulen        => 64,
      pmp_no_tor    => 0,
      pmp_entries   => 8,
      pmp_g         => 10,
      perf_cnts     => 16,
      perf_evts     => 16,
      perf_bits     => 32,
      tbuf          => 4,
      trigger       => 32*0 + 16*0 + 2,
      icen          => 1,
      iways         => 2,
      iwaysize      => 4,
      ilinesize     => 8,
      dcen          => 1,
      dways         => 2,
      dwaysize      => 4,
      dlinesize     => 8,
      mmuen         => 0,
      itlbnum       => 2,
      dtlbnum       => 2,
      htlbnum       => 1,
      div_hiperf    => 0,
      div_small     => 0,
      late_branch   => 1,
      late_alu      => 1,
      bhtentries    => 64,
      bhtlength     => 5,
      predictor     => 2,
      btbentries    => 16,
      btbsets       => 2),
    -- MIN (no FPU)
    4 => (
      single_issue  => 1,
      ext_m         => 1,
      ext_a         => 1,
      ext_c         => 1,
      ext_h         => 0,
      ext_zba       => 0,
      ext_zbb       => 0,
      ext_zbc       => 0,
      ext_zbs       => 0,
      ext_zbkb      => 0,
      ext_zbkc      => 0,
      ext_zbkx      => 0,
      ext_sscofpmf  => 0,
      mode_s        => 0,
      mode_u        => 1,
      fpulen        => 0,
      pmp_no_tor    => 0,
      pmp_entries   => 8,
      pmp_g         => 10,
      perf_cnts     => 16,
      perf_evts     => 16,
      perf_bits     => 32,
      tbuf          => 4,
      trigger       => 32*0 + 16*0 + 2,
      icen          => 1,
      iways         => 2,
      iwaysize      => 4,
      ilinesize     => 8,
      dcen          => 1,
      dways         => 2,
      dwaysize      => 4,
      dlinesize     => 8,
      mmuen         => 0,
      itlbnum       => 2,
      dtlbnum       => 2,
      htlbnum       => 1,
      div_hiperf    => 0,
      div_small     => 0,
      late_branch   => 1,
      late_alu      => 1,
      bhtentries    => 64,
      bhtlength     => 5,
      predictor     => 2,
      btbentries    => 16,
      btbsets       => 2),
    -- TIN
    5 => (
      single_issue  => 1,
      ext_m         => 1,
      ext_a         => 0,
      ext_c         => 0,
      ext_h         => 0,
      ext_zba       => 0,
      ext_zbb       => 0,
      ext_zbc       => 0,
      ext_zbs       => 0,
      ext_zbkb      => 0,
      ext_zbkc      => 0,
      ext_zbkx      => 0,
      ext_sscofpmf  => 0,
      mode_s        => 0,
      mode_u        => 0,
      fpulen        => 0,
      pmp_no_tor    => 0,
      pmp_entries   => 0,
      pmp_g         => 10,
      perf_cnts     => 0,
      perf_evts     => 0,
      perf_bits     => 0,
      tbuf          => 1,
      trigger       => 32*0 + 16*0 + 0,
      icen          => 0,
      iways         => 1,
      iwaysize      => 1,
      ilinesize     => 8,
      dcen          => 0,
      dways         => 1,
      dwaysize      => 1,
      dlinesize     => 8,
      mmuen         => 0,
      itlbnum       => 2,
      dtlbnum       => 2,
      htlbnum       => 1,
      div_hiperf    => 0,
      div_small     => 1,
      late_branch   => 0,
      late_alu      => 0,
      bhtentries    => 32,
      bhtlength     => 2,
      predictor     => 2,
      btbentries    => 8,
      btbsets       => 2),
    -- GPP-lite (dual-issue)
    6 => (
      single_issue  => 0,
      ext_m         => 1,
      ext_a         => 1,
      ext_c         => 1,
      ext_h         => 1,
      ext_zba       => 1,
      ext_zbb       => 1,
      ext_zbc       => 0,
      ext_zbs       => 1,
      ext_zbkb      => 1,
      ext_zbkc      => 0,
      ext_zbkx      => 0,
      ext_sscofpmf  => 0,
      mode_s        => 1,
      mode_u        => 1,
      fpulen        => 64,
      pmp_no_tor    => 0,
      pmp_entries   => 0,
      pmp_g         => 10,
      perf_cnts     => 3,
      perf_evts     => 16,
      perf_bits     => 32,
      tbuf          => 4,
      trigger       => 32*0 + 16*0 + 2,
      icen          => 1,
      iways         => 4,
      iwaysize      => 4,
      ilinesize     => 8,
      dcen          => 1,
      dways         => 4,
      dwaysize      => 4,
      dlinesize     => 8,
      mmuen         => 1,
      itlbnum       => 8,
      dtlbnum       => 8,
      htlbnum       => 8,
      div_hiperf    => 1,
      div_small     => 0,
      late_branch   => 1,
      late_alu      => 1,
      bhtentries    => 64,
      bhtlength     => 5,
      predictor     => 2,
      btbentries    => 16,
      btbsets       => 2),
    others => cfg_none
    );

attribute DONT_TOUCH of cmp0 : label is "TRUE";

begin
  vcc <= '1'; gnd <= '0';

  u0 : cpucorenv -- NOEL-V Core MASTER
    generic map (
      hindex          => hindex,    
      fabtech         => fabtech,
      memtech         => memtech,
      -- BHT
      bhtentries      => cfg_c(cfg).bhtentries,
      bhtlength       => cfg_c(cfg).bhtlength,
      predictor       => cfg_c(cfg).predictor,
      -- BTB
      btbentries      => cfg_c(cfg).btbentries,
      btbsets         => cfg_c(cfg).btbsets,
      -- Caches
      icen            => cfg_c(cfg).icen,
      iways           => cfg_c(cfg).iways,
      ilinesize       => cfg_c(cfg).ilinesize,
      iwaysize        => cfg_c(cfg).iwaysize,
      dcen            => cfg_c(cfg).dcen,
      dways           => cfg_c(cfg).dways,
      dlinesize       => cfg_c(cfg).dlinesize,
      dwaysize        => cfg_c(cfg).dwaysize,
      -- MMU
      mmuen           => cfg_c(cfg).mmuen,
      itlbnum         => cfg_c(cfg).itlbnum,
      dtlbnum         => cfg_c(cfg).dtlbnum,
      htlbnum         => cfg_c(cfg).htlbnum,
      tlbforepl       => 4,
      riscv_mmu       => 2,
      pmp_no_tor      => cfg_c(cfg).pmp_no_tor,
      pmp_entries     => cfg_c(cfg).pmp_entries,
      pmp_g           => cfg_c(cfg).pmp_g,
      -- Extensions
      ext_m           => cfg_c(cfg).ext_m,
      ext_a           => cfg_c(cfg).ext_a,
      ext_c           => cfg_c(cfg).ext_c,
      ext_h           => cfg_c(cfg).ext_h,
      ext_zba         => cfg_c(cfg).ext_zba,
      ext_zbb         => cfg_c(cfg).ext_zbb,
      ext_zbc         => cfg_c(cfg).ext_zbc,
      ext_zbs         => cfg_c(cfg).ext_zbs,
      ext_zbkb        => cfg_c(cfg).ext_zbkb,
      ext_zbkc        => cfg_c(cfg).ext_zbkc,
      ext_zbkx        => cfg_c(cfg).ext_zbkx,
      ext_sscofpmf    => cfg_c(cfg).ext_sscofpmf,
      mode_s          => cfg_c(cfg).mode_s,
      mode_u          => cfg_c(cfg).mode_u,
      fpulen          => cfg_c(cfg).fpulen,
      trigger         => cfg_c(cfg).trigger,
      -- Advanced Features
      late_branch     => cfg_c(cfg).late_branch,
      late_alu        => cfg_c(cfg).late_alu,
      -- Core
      cached          => cached,
      wbmask          => wbmask,
      busw            => busw,
      cmemconf        => cmemconf,
      rfconf          => rfconf,
--      rfconf          => 1,  -- qqq Use this for DC
      tcmconf         => tcmconf,
      mulconf         => mulconf,
      tbuf            => cfg_c(cfg).tbuf,
      physaddr        => 32,
      rstaddr         => 16#C0000#,
      -- Misc
      dmen            => 1,
      pbaddr          => pbaddr,
      disas           => disas,
      perf_cnts       => cfg_c(cfg).perf_cnts,
      perf_evts       => cfg_c(cfg).perf_evts,
      perf_bits       => cfg_c(cfg).perf_bits,
      illegalTval0    => 0,
      no_muladd       => 0,
      single_issue    => cfg_c(cfg).single_issue,
      mularch         => mularch,
      div_hiperf      => cfg_c(cfg).div_hiperf,
      div_small       => cfg_c(cfg).div_small,
      hw_fpu          => 1 + 2*fpuconf,
      scantest        => scantest,
      endian          => 1  -- Only Little-endian is supported
      )
    port map (
      clk             => clk,
      gclk            => clk,
      rstn            => rstn,

      ahbi            => msig_ahbi,
      ahbo            => msig_ahbo,
      ahbsi           => msig_ahbsi,
      ahbso           => msig_ahbso,
      irqi            => msig_irqi,
      irqo            => msig_irqo,
      dbgi            => msig_dbgi,
      dbgo            => msig_dbgo,
      eto             => msig_eto,
      cnt             => msig_cnt
      );




  u1 : cpucorenv -- NOEL-V Core SLAVE
    generic map (
      hindex          => hindex, 
      fabtech         => fabtech,
      memtech         => memtech,
      -- BHT
      bhtentries      => cfg_c(cfg).bhtentries,
      bhtlength       => cfg_c(cfg).bhtlength,
      predictor       => cfg_c(cfg).predictor,
      -- BTB
      btbentries      => cfg_c(cfg).btbentries,
      btbsets         => cfg_c(cfg).btbsets,
      -- Caches
      icen            => cfg_c(cfg).icen,
      iways           => cfg_c(cfg).iways,
      ilinesize       => cfg_c(cfg).ilinesize,
      iwaysize        => cfg_c(cfg).iwaysize,
      dcen            => cfg_c(cfg).dcen,
      dways           => cfg_c(cfg).dways,
      dlinesize       => cfg_c(cfg).dlinesize,
      dwaysize        => cfg_c(cfg).dwaysize,
      -- MMU
      mmuen           => cfg_c(cfg).mmuen,
      itlbnum         => cfg_c(cfg).itlbnum,
      dtlbnum         => cfg_c(cfg).dtlbnum,
      htlbnum         => cfg_c(cfg).htlbnum,
      tlbforepl       => 4,
      riscv_mmu       => 2,
      pmp_no_tor      => cfg_c(cfg).pmp_no_tor,
      pmp_entries     => cfg_c(cfg).pmp_entries,
      pmp_g           => cfg_c(cfg).pmp_g,
      -- Extensions
      ext_m           => cfg_c(cfg).ext_m,
      ext_a           => cfg_c(cfg).ext_a,
      ext_c           => cfg_c(cfg).ext_c,
      ext_h           => cfg_c(cfg).ext_h,
      ext_zba         => cfg_c(cfg).ext_zba,
      ext_zbb         => cfg_c(cfg).ext_zbb,
      ext_zbc         => cfg_c(cfg).ext_zbc,
      ext_zbs         => cfg_c(cfg).ext_zbs,
      ext_zbkb        => cfg_c(cfg).ext_zbkb,
      ext_zbkc        => cfg_c(cfg).ext_zbkc,
      ext_zbkx        => cfg_c(cfg).ext_zbkx,
      ext_sscofpmf    => cfg_c(cfg).ext_sscofpmf,
      mode_s          => cfg_c(cfg).mode_s,
      mode_u          => cfg_c(cfg).mode_u,
      fpulen          => cfg_c(cfg).fpulen,
      trigger         => cfg_c(cfg).trigger,
      -- Advanced Features
      late_branch     => cfg_c(cfg).late_branch,
      late_alu        => cfg_c(cfg).late_alu,
      -- Core
      cached          => cached,
      wbmask          => wbmask,
      busw            => busw,
      cmemconf        => cmemconf,
      rfconf          => rfconf,
      -- rfconf          => 1,  -- qqq Use this for DC
      tcmconf         => tcmconf,
      mulconf         => mulconf,
      tbuf            => cfg_c(cfg).tbuf,
      physaddr        => 32,
      rstaddr         => 16#C0000#,
      -- Misc
      dmen            => 1,
      pbaddr          => pbaddr,
      disas           => disas,
      perf_cnts       => cfg_c(cfg).perf_cnts,
      perf_evts       => cfg_c(cfg).perf_evts,
      perf_bits       => cfg_c(cfg).perf_bits,
      illegalTval0    => 0,
      no_muladd       => 0,
      single_issue    => cfg_c(cfg).single_issue,
      mularch         => mularch,
      div_hiperf      => cfg_c(cfg).div_hiperf,
      div_small       => cfg_c(cfg).div_small,
      hw_fpu          => 1 + 2*fpuconf,
      scantest        => scantest,
      endian          => 1  -- Only Little-endian is supported
      )
    port map (
      clk             => clk,
      gclk            => clk,
      rstn            => rstn,

      ahbi            => ssig_ahbi,
      ahbo            => ssig_ahbo,
      ahbsi           => ssig_ahbsi,
      ahbso           => ssig_ahbso,
      irqi            => ssig_irqi,
      irqo            => ssig_irqo,
      dbgi            => ssig_dbgi,
      dbgo            => ssig_dbgo,
      eto             => ssig_eto,
      cnt             => ssig_cnt
      );

  cmp0 : l_comparator -- Comparator
    port map (
      clk             => clk,
      rstn            => rstn,
        -- SIGNALS TO NOELVCPU
      ahbi            => ahbi,
      ahbo            => ahbo,
      ahbsi           => ahbsi,
      ahbso           => ahbso,
      irqi            => irqi,
      irqo            => irqo,
      dbgi            => dbgi,
      dbgo            => dbgo,
      eto             => eto,
      cnt             => cnt,
        -- MASTER
      mahbi            => msig_ahbi,
      mahbo            => msig_ahbo,
      mahbsi           => msig_ahbsi,
      mahbso           => msig_ahbso,
      mirqi            => msig_irqi,
      mirqo            => msig_irqo,
      mdbgi            => msig_dbgi,
      mdbgo            => msig_dbgo,
      meto             => msig_eto,
      mcnt             => msig_cnt,
        -- SLAVE
      sahbi            => ssig_ahbi,
      sahbo            => ssig_ahbo,
      sahbsi           => ssig_ahbsi,
      sahbso           => ssig_ahbso,
      sirqi            => ssig_irqi,
      sirqo            => ssig_irqo,
      sdbgi            => ssig_dbgi,
      sdbgo            => ssig_dbgo,
      seto             => ssig_eto,
      scnt             => ssig_cnt      
      );






end;
