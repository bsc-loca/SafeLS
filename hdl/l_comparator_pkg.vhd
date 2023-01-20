

library ieee;
use ieee.std_logic_1164.all;
library grlib;
use grlib.config_types.all;
use grlib.config.all;
use grlib.amba.all;
use grlib.stdlib.all;
use ieee.numeric_std.all;
use grlib.riscv.all;
library techmap;
use techmap.gencomp.all;
use techmap.netcomp.all;
library gaisler;
use gaisler.noelv.XLEN;
use gaisler.noelv.nv_irq_in_type;
use gaisler.noelv.nv_irq_out_type;
use gaisler.noelv.nv_debug_in_type;
use gaisler.noelv.nv_debug_out_type;
use gaisler.noelv.nv_counter_out_type;
use gaisler.noelv.nv_etrace_out_type;
use gaisler.noelvint.all;
use gaisler.utilnv.u2vec;

-- Package Declaration Section
package l_comparator_pkg is


  component l_comparator is
    port (
      clk           : in  std_ulogic; -- cpu clock
      rstn          : in  std_ulogic; 
      
      -------------------------------------------------------------------------------------------
        -- Front Signals CMP - NoelVCPU
      -------------------------------------------------------------------------------------------
  
      ahbi        : in  ahb_mst_in_type;
      ahbo        : out ahb_mst_out_type; -- pertanyen a la MMU/Cache Controller
      ahbsi       : in  ahb_slv_in_type;
      ahbso       : in  ahb_slv_out_vector; -- pertanyen a la MMU/Cache Controller
      ------------------------------------------------------------------- End bus signals
      irqi        : in  nv_irq_in_type;     -- irq in
      irqo        : out nv_irq_out_type;    -- irq out
      ------------------------------------------------------------------- End Interrupt signals
      dbgi        : in  nv_debug_in_type;   -- debug in
      dbgo        : out nv_debug_out_type;  -- debug out
      ------------------------------------------------------------------- End debug signals
      eto         : out nv_etrace_out_type;
      cnt         : out nv_counter_out_type; -- Perf event Out Port
  
      
      -------------------------------------------------------------------------------------------
        -- Signals CPUCoreNV - CMP
      -------------------------------------------------------------------------------------------
  
       -- Master Signals 
  
      mahbi        : out  ahb_mst_in_type;
      mahbsi       : out  ahb_slv_in_type;
      mahbso       : out  ahb_slv_out_vector; -- pertanyen a la MMU/Cache Controller
      mirqi        : out  nv_irq_in_type;     -- irq in
      mdbgi        : out  nv_debug_in_type;   -- debug in
  
      mirqo        : in nv_irq_out_type;    -- irq out
      mahbo        : in ahb_mst_out_type; -- pertanyen a la MMU/Cache Controller
      mdbgo        : in nv_debug_out_type;  -- debug out
      meto         : in nv_etrace_out_type;
      mcnt         : in nv_counter_out_type; -- Perf event Out Port
  
  
       -- Slave Signals
  
      sahbi        : out  ahb_mst_in_type;
      sahbsi       : out  ahb_slv_in_type;
      sahbso       : out  ahb_slv_out_vector; -- pertanyen a la MMU/Cache Controller
      sirqi        : out  nv_irq_in_type;     -- irq in
      sdbgi        : out  nv_debug_in_type;   -- debug in
  
      sirqo        : in nv_irq_out_type;    -- irq out
      sahbo        : in ahb_mst_out_type; -- pertanyen a la MMU/Cache Controller
      sdbgo        : in nv_debug_out_type;  -- debug out
      seto         : in nv_etrace_out_type;
      scnt         : in nv_counter_out_type -- Perf event Out Port
      );
  end component l_comparator;











end package;