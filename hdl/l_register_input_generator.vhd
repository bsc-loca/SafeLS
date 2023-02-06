library ieee;
use ieee.std_logic_1164.all;
library std;
use std.STANDARD.BOOLEAN;
library grlib;
use grlib.amba.all;
use ieee.numeric_std.all;
library gaisler;
use gaisler.noelv.all;


entity l_register_input_generator is
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
end;


architecture rtl of l_register_input_generator is
  signal reg_ahbi        : ahb_mst_in_type;
  signal reg_ahbsi       : ahb_slv_in_type;
  signal reg_ahbso       : ahb_slv_out_vector; 
  signal reg_irqi        : nv_irq_in_type;     
  signal reg_dbgi        : nv_debug_in_type;
begin


  reg_ahbi <= ahbi;  
  reg_ahbsi <= ahbsi;  
  reg_ahbso <= ahbso;  
  reg_irqi <= irqi;  
  reg_dbgi <= dbgi;  


  inputs_reg: process(reg_ahbi, reg_dbgi, clk) 
  begin
    if rising_edge(clk) then 
      out_ahbi  <= reg_ahbi;
      out_ahbsi <= reg_ahbsi;
      out_ahbso <= reg_ahbso;
      out_dbgi  <= reg_dbgi;
      out_irqi  <= reg_irqi;
    end if;
  end process;
end architecture;
