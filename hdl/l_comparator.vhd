library ieee;
use ieee.std_logic_1164.all;
library std;
use std.STANDARD.BOOLEAN;
library grlib;
use grlib.amba.all;
use ieee.numeric_std.all;
library gaisler;
use gaisler.noelv.all;

entity l_comparator is
  port (

    clk           : in  std_ulogic; -- cpu clock
    rstn          : in  std_ulogic; 
    
    -- Front Signals CMP - NoelVCPU

    ahbi        : in  ahb_mst_in_type;
    ahbo        : out ahb_mst_out_type; -- pertanyen a la MMU/Cache Controller
    ahbsi       : in  ahb_slv_in_type;
    ahbso       : in  ahb_slv_out_vector; -- pertanyen a la MMU/Cache Controller
    irqi        : in  nv_irq_in_type;     -- irq in
    irqo        : out nv_irq_out_type;    -- irq out
    dbgi        : in  nv_debug_in_type;   -- debug in
    dbgo        : out nv_debug_out_type;  -- debug out
    eto         : out nv_etrace_out_type;
    cnt         : out nv_counter_out_type; -- Perf event Out Port
    --equal         : out std_logic; 
    equals        : out std_logic_vector(4 DOWNTO 0); 

     -- Master Signals 

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

     -- Slave Signals

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
end;

architecture rtl of l_comparator is
  signal reg_ahbo        : ahb_mst_out_type; 
  signal reg_irqo       : nv_irq_out_type;
  signal reg_dbgo       : nv_debug_out_type;
  signal reg_eto        : nv_etrace_out_type; 
  signal reg_cnt        : nv_counter_out_type;  
  signal reg_equal      : std_logic;

  -- Hold input signals

  signal reg_hahbi        : ahb_mst_in_type;
  signal reg_hahbsi       : ahb_slv_in_type;
  signal reg_hahbso       : ahb_slv_out_vector; 
  signal reg_hirqi        : nv_irq_in_type;    
  signal reg_hdbgi        : nv_debug_in_type;   

  -- Hold output signals

  signal reg_hahbo        : ahb_mst_out_type; 
  signal reg_hirqo       : nv_irq_out_type;
  signal reg_hdbgo       : nv_debug_out_type;
  signal reg_heto        : nv_etrace_out_type; 
  signal reg_hcnt        : nv_counter_out_type;  

  -- Hold output slave signals
  signal reg_hsirqo        : nv_irq_out_type;    
  signal reg_hsahbo        : ahb_mst_out_type; 
  signal reg_hsdbgo        : nv_debug_out_type;  
  signal reg_hseto         : nv_etrace_out_type;
  signal reg_hscnt         : nv_counter_out_type; 
begin


  inputs_reg: process(ahbi, dbgi, clk) 
  begin
    if rising_edge(clk) then -- Register inputs to delay Tail inputs
      sahbi  <= ahbi;
      sahbsi <= ahbsi;
      sahbso <= ahbso;
      sdbgi  <= dbgi;
      sirqi  <= irqi;
    end if;
  end process;

  -- Assignació directa de les entrades a Head
  mahbi  <= ahbi;
  mahbsi <= ahbsi;
  mahbso <= ahbso;
  mdbgi  <= dbgi;
  mirqi  <= irqi;

  outputs_reg: process(mahbo, mdbgo) --clk
  begin
    if rising_edge(clk) then -- Register outputs to delay Head inputs
      reg_ahbo  <= mahbo;
      reg_dbgo  <= mdbgo; 
      reg_irqo  <= mirqo;  
      reg_eto   <= meto; 
      reg_cnt   <= mcnt;
    end if;
  end process;

  out_hold_slv: process(sahbo, sdbgo) --clk
  begin
    if rising_edge(clk) then -- Register outputs to delay Head inputs
      reg_hsahbo  <= sahbo; 
      reg_hsirqo  <= sirqo;
      reg_hsdbgo  <= sdbgo;  
      reg_hseto   <= seto; 
      reg_hscnt   <= scnt;
    end if;
  end process;



  ahbo0: process (clk, reg_ahbo, reg_dbgo)
  begin
    if rising_edge(clk) then 
      --equal <= '0';
      equals <= (others =>'0');
      if (reg_hsahbo /= reg_ahbo) then   
        --equal <= '1';
        equals(4) <= '1'; 
      end if;
      if (reg_hsirqo /= reg_irqo) then 
        --equal <= '1'; 
        equals(3) <= '1';
      end if;
      if (reg_hsdbgo /= reg_dbgo) then 
        --equal <= '1'; 
        equals(2) <= '1';
      end if;
      if (reg_hseto /= reg_eto) then 
        --equal <= '1';  
        equals(1) <= '1';    
      end if;
      if (reg_hscnt /= reg_cnt) then
        --equal <= '1'; 
        equals(0) <= '1';
      end if;
    end if;
  end process;

    -- Deixem passar les sortides de Head cap a fora del core 
    ahbo <= mahbo;
    irqo <= mirqo;
    dbgo <= mdbgo;
    eto  <= meto;
    cnt  <= mcnt; 

end architecture;