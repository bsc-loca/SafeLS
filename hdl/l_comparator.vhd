library ieee;
use ieee.std_logic_1164.all;
library std;
use std.STANDARD.BOOLEAN;
library grlib;
use grlib.amba.all;
use ieee.numeric_std.all;
library gaisler;
use gaisler.noelv.all;
library safety;
use safety.l_noelvcpu_pkg.all;



entity l_comparator is
  generic (
    ncycles  : integer := 2      
    );
  port (

    clk           : in  std_ulogic; 
    rstn          : in  std_ulogic; 
    
    -- Front Signals CMP - NoelVCPU
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

  -- Hold output slave signals
  signal reg_hsirqo        : nv_irq_out_type;    
  signal reg_hsahbo        : ahb_mst_out_type; 
  signal reg_hsdbgo        : nv_debug_out_type;  
  signal reg_hseto         : nv_etrace_out_type;
  signal reg_hscnt         : nv_counter_out_type;

  type t_ahbi is array (ncycles DOWNTO 0) of ahb_mst_in_type;
  type t_ahbsi is array (ncycles DOWNTO 0) of ahb_slv_in_type;
  type t_ahbso is array (ncycles DOWNTO 0) of ahb_slv_out_vector;
  type t_irqi is array (ncycles DOWNTO 0) of nv_irq_in_type;
  type t_dbgi is array (ncycles DOWNTO 0) of nv_debug_in_type;
  type t_sirqo is array (ncycles DOWNTO 0) of nv_irq_out_type;
  type t_sahbo is array (ncycles DOWNTO 0) of ahb_mst_out_type;
  type t_sdbgo is array (ncycles DOWNTO 0) of nv_debug_out_type;
  type t_seto is array (ncycles DOWNTO 0) of nv_etrace_out_type;
  type t_scnt is array (ncycles DOWNTO 0) of nv_counter_out_type;

  signal v_ahbi        : t_ahbi;
  signal v_ahbsi       : t_ahbsi;
  signal v_ahbso       : t_ahbso; -- 
  signal v_irqi        : t_irqi;    
  signal v_dbgi        : t_dbgi;  
  signal v_irqo       : t_sirqo;    
  signal v_ahbo       : t_sahbo; 
  signal v_dbgo       : t_sdbgo;  
  signal v_eto        : t_seto;
  signal v_cnt        : t_scnt;

  signal rreg_ahbi        : ahb_mst_in_type;
  signal rreg_ahbsi       : ahb_slv_in_type;
  signal rreg_ahbso       : ahb_slv_out_vector;
  signal rreg_irqi        : nv_irq_in_type;
  signal rreg_dbgi        : nv_debug_in_type;

  signal rreg_ahbo        : ahb_mst_out_type; 
  signal rreg_irqo       : nv_irq_out_type;
  signal rreg_dbgo       : nv_debug_out_type;
  signal rreg_eto        : nv_etrace_out_type; 
  signal rreg_cnt        : nv_counter_out_type; 

begin


  v_ahbi(0)  <= ahbi;    
  v_ahbsi(0) <= ahbsi;
  v_ahbso(0) <= ahbso;
  v_irqi(0)  <= irqi;
  v_dbgi(0)  <= dbgi;


  in_reg_loop: for c in 0 to ncycles generate
    l_in_if_0: if (c < ncycles) generate
      in_reg: l_register_input_generator
        port map (
          clk         => clk,    
          rstn        => rstn,    
          ahbi        => v_ahbi(c),
          ahbsi       => v_ahbsi(c),
          ahbso       => v_ahbso(c), 
          irqi        => v_irqi(c),     
          dbgi        => v_dbgi(c),   
          out_ahbi    => v_ahbi(c+1),
          out_ahbsi   => v_ahbsi(c+1),
          out_ahbso   => v_ahbso(c+1), 
          out_irqi    => v_irqi(c+1),     
          out_dbgi    => v_dbgi(c+1)
          );
    end generate;
    l_in_if_n0: if (c = ncycles) generate
      in_reg: l_register_input_generator
        port map (
          clk         => clk,    
          rstn        => rstn,    
          ahbi        => v_ahbi(c),
          ahbsi       => v_ahbsi(c),
          ahbso       => v_ahbso(c), 
          irqi        => v_irqi(c),     
          dbgi        => v_dbgi(c),   
          out_ahbi    => rreg_ahbi,
          out_ahbsi   => rreg_ahbsi,
          out_ahbso   => rreg_ahbso, 
          out_irqi    => rreg_irqi,     
          out_dbgi    => rreg_dbgi
          );
    end generate; 
  end generate;


  sahbi <= rreg_ahbi; 
  sahbsi <= rreg_ahbsi; 
  sahbso <= rreg_ahbso; 
  sirqi <= rreg_irqi; 
  sdbgi <= rreg_dbgi; 


  -- Assignació directa de les entrades a Head
  mahbi  <= ahbi;
  mahbsi <= ahbsi;
  mahbso <= ahbso;
  mdbgi  <= dbgi;
  mirqi  <= irqi;


  v_ahbo(0) <= mahbo;       
  v_irqo(0) <= mirqo;         
  v_dbgo(0) <= mdbgo;      
  v_eto(0) <= meto;      
  v_cnt(0) <= mcnt; 


  out_reg_loop: for c in 0 to ncycles generate
    l_out_if_0: if (c < ncycles) generate
      out_reg: l_register_output_generator
        port map(
          clk      => clk,      
          rstn     => rstn,           
          in_ahbo  =>  v_ahbo(c),       
          in_irqo  =>  v_irqo(c),         
          in_dbgo  =>  v_dbgo(c),      
          in_eto   =>  v_eto(c),      
          in_cnt   =>  v_cnt(c),      
          ahbo     =>  v_ahbo(c+1),    
          irqo     =>  v_irqo(c+1),      
          dbgo     =>  v_dbgo(c+1),   
          eto      =>  v_eto(c+1),  
          cnt      => v_cnt(c+1)
          );
    end generate;
    l_out_if_n0: if (c = ncycles) generate
      out_reg: l_register_output_generator
        port map(
          clk      => clk,      
          rstn     => rstn,       
          in_ahbo  => v_ahbo(c),       
          in_irqo  => v_irqo(c),         
          in_dbgo  => v_dbgo(c),      
          in_eto   => v_eto(c),      
          in_cnt   => v_cnt(c),      
          ahbo     => rreg_ahbo,    
          irqo     => rreg_irqo,      
          dbgo     => rreg_dbgo,   
          eto      => rreg_eto,  
          cnt      => rreg_cnt
          );
    end generate; 
  end generate; 
    

  outputs_reg: process(rreg_ahbo, rreg_dbgo) 
  begin
    if rising_edge(clk) then 
      reg_ahbo  <= rreg_ahbo;
      reg_irqo  <= rreg_irqo; 
      reg_dbgo  <= rreg_dbgo;  
      reg_eto   <= rreg_eto; 
      reg_cnt   <= rreg_cnt;
    end if;
  end process;


  out_hold_slv: process(sahbo, sdbgo)
  begin
    if rising_edge(clk) then 
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
