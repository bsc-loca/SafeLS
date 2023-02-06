library ieee;
use ieee.std_logic_1164.all;
library std;
use std.STANDARD.BOOLEAN;
library grlib;
use grlib.amba.all;
use ieee.numeric_std.all;
library gaisler;
use gaisler.noelv.all;


entity l_register_output_generator is
  port (
    clk           : in  std_ulogic; -- cpu clock
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
end;


architecture rtl of l_register_output_generator is
  signal reg_ahbo        : ahb_mst_out_type; 
  signal reg_irqo        : nv_irq_out_type;    
  signal reg_dbgo        : nv_debug_out_type;  
  signal reg_eto         : nv_etrace_out_type;
  signal reg_cnt         : nv_counter_out_type;
begin


  reg_ahbo <= in_ahbo;        
  reg_irqo <= in_irqo;         
  reg_dbgo <= in_dbgo;         
  reg_eto <= in_eto;         
  reg_cnt <= in_cnt;         


  outputs_reg: process(reg_ahbo, reg_dbgo, clk) 
  begin
    if rising_edge(clk) then 
      ahbo  <= reg_ahbo;
      dbgo  <= reg_dbgo; 
      irqo  <= reg_irqo;  
      eto   <= reg_eto; 
      cnt   <= reg_cnt;
    end if;
  end process;
end architecture;
