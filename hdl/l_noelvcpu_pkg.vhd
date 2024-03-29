
library ieee;
use ieee.std_logic_1164.all;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
library gaisler;
use gaisler.noelvint.all;
use gaisler.noelv.all;
use gaisler.arith.all;


package l_noelvcpu_pkg is


  component l_noelvcpu is
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
  end component l_noelvcpu;


  component l_register_output_generator is
    port (
      clk           : in  std_ulogic; 
      rstn          : in  std_ulogic; 
      in_ahbo        : in ahb_mst_out_type; 
      in_irqo        : in nv_irq_out_type;    
      in_dbgo        : in nv_debug_out_type;  
      in_eto         : in nv_etrace_out_type;
      in_cnt         : in nv_counter_out_type; 
      ahbo        : out ahb_mst_out_type; 
      irqo        : out nv_irq_out_type;    
      dbgo        : out nv_debug_out_type;  
      eto         : out nv_etrace_out_type;
      cnt         : out nv_counter_out_type  
      );
  end component;


  component l_register_input_generator is
    port (
      clk           : in  std_ulogic; 
      rstn          : in  std_ulogic; 
      ahbi        : in  ahb_mst_in_type;
      ahbsi       : in  ahb_slv_in_type;
      ahbso       : in  ahb_slv_out_vector; 
      irqi        : in  nv_irq_in_type;     
      dbgi        : in  nv_debug_in_type;   
      out_ahbi        : out  ahb_mst_in_type;
      out_ahbsi       : out  ahb_slv_in_type;
      out_ahbso       : out  ahb_slv_out_vector; 
      out_irqi        : out  nv_irq_in_type;     
      out_dbgi        : out  nv_debug_in_type 
      );
  end component;


end package;