library ieee;
use ieee.numeric_bit.all;
use ieee.math_real.all;

package secded is
  function secded_message_size(size:  natural) return natural;
end secded;

package body secded is
  function secded_message_size(size:  natural) return natural is
  begin
    return size + 2 + natural(floor(log2(real(size)+1.1)));
  end function;
end secded;

library ieee;
use ieee.numeric_bit.all;
use ieee.math_real.all;
library work;
use work.secded.secded_message_size;

entity secded_enc is
    generic(
             data_size: positive := 16
           );
    port(
      u_data: in bit_vector(data_size-1 downto 0);
      mem_data: out bit_vector(secded_message_size(data_size)-1 downto 0)
    );
end entity;


architecture encript of secded_enc is
    function mem_to_u(a:natural) return natural is
        begin
            return a - natural(ceil(log2(real(a))-0.0000001));
    end function;

    
    function check(a,b: natural) return bit_vector is
        begin
           return bit_vector((to_unsigned(a, 32) srl b) mod 2);
    end function;
    
    type matr is array(natural(floor(log2(real(secded_message_size(data_size)))-0.01)) downto 0) of bit_vector(secded_message_size(data_size)-1 downto 0);
    signal syndr_matr, p_matr: matr;
    signal mem_data1,mem_data2,mem_data3,mem_data_p, parity :bit_vector(secded_message_size(data_size)-1 downto 0);
begin
  mark_parity: for  i in natural(floor(log2(real(secded_message_size(data_size)))-0.01)) downto 0 generate
    parity((to_integer(to_unsigned(1, 32) sll i) - 1))<= '1';  
  end generate mark_parity;
  
  propagate_u_data: for  i in secded_message_size(data_size)-2 downto 0 generate
    mem_data1(i)<= u_data(mem_to_u(i+1)-1) when parity(i) = '0' else '0';  
  end generate propagate_u_data;

  compute_mem_data: for i in natural(floor(log2(real(secded_message_size(data_size)))-0.01)) downto 0 generate
      gene1:for j in secded_message_size(data_size)-2 downto 0 generate
        syndr_matr(i)(j) <=(not(parity(j))) and check(j+1, i)(0) and mem_data1(j);
    	end generate gene1;
  end generate compute_mem_data;

  compute_parity_bits: for i in natural(floor(log2(real(secded_message_size(data_size)))-0.01)) downto 0 generate
      p_matr(i)(0) <= syndr_matr(i)(0);
      gene2:for j in secded_message_size(data_size)-2 downto 1 generate
        p_matr(i)(j) <= syndr_matr(i)(j) xor p_matr(i)(j-1); 
      end generate gene2;
  end generate compute_parity_bits;

  assign_parity: for i in natural(floor(log2(real(secded_message_size(data_size)))-0.01)) downto 0 generate
      mem_data2(to_integer(to_unsigned(1, 32) sll i) - 1) <= p_matr(i)(secded_message_size(data_size)-2);
  end generate assign_parity;

  create_mem_data_3: for i in secded_message_size(data_size)-2 downto 0 generate
      mem_data3(i) <= mem_data1(i) when parity(i) = '0' else mem_data2(i); 
  end generate create_mem_data_3;

  mem_data_p(0) <= mem_data3(0);
  compute_overall_parity: for i in secded_message_size(data_size)-2 downto 1 generate
      mem_data_p(i) <= mem_data3(i) xor mem_data_p(i-1);
  end generate compute_overall_parity;

  mem_data3(secded_message_size(data_size)-1)<= mem_data_p(secded_message_size(data_size)-2);

  pass_to_mem_data: for i in secded_message_size(data_size)-1 downto 0 generate
      mem_data(i) <= mem_data3(i);
  end generate pass_to_mem_data;

end encript;

library ieee;
use ieee.numeric_bit.all;
use ieee.math_real.all;
library work;
use work.secded.secded_message_size;

entity secded_dec is
  generic(
           data_size: positive := 16
         );
  port(
    mem_data: in bit_vector(secded_message_size(data_size)-1 downto 0);
    u_data: out bit_vector(data_size-1 downto 0);
    uncorrectable_error: out bit
  );
end entity;

architecture arch of secded_dec is
  function mem_to_u(a:natural) return natural is
    begin
        return a - natural(ceil(log2(real(a))-0.0000001));
  end function;
  component secded_enc is
    generic(
             data_size: positive := 16
           );
    port(
      u_data: in bit_vector(data_size-1 downto 0);
      mem_data: out bit_vector(secded_message_size(data_size)-1 downto 0)
    );
  end component;
  type int_array is array (data_size-1 downto 0) of natural;
  signal data: bit_vector(data_size-1 downto 0);
  signal parity, r_mem_data, xor_mem_data: bit_vector(secded_message_size(data_size)-1 downto 0);
  signal p: bit_vector(natural(floor(log2(real(secded_message_size(data_size))))) downto 0);
  signal syndrome:natural;
  signal u_to_mem: int_array;
  signal p5:bit;
begin
  mark_parity: for  i in natural(floor(log2(real(secded_message_size(data_size)))-0.01)) downto 0 generate
    parity((to_integer(to_unsigned(1, 32) sll i) - 1))<= '1';  
  end generate mark_parity;

  u_to_mem(0)<= 2;
  calculate_u_to_mem: for i in data_size - 1 downto 1 generate
    u_to_mem(i) <= (u_to_mem(i-1) + 1) when parity(u_to_mem(i-1) + 1) = '0' else u_to_mem(i-1) + 2;
  end generate calculate_u_to_mem;

  get_u_data: for i in data_size -1 downto 0 generate
    data(i)<=mem_data(u_to_mem(i));
  end generate get_u_data;

  compute_received_mem_data: secded_enc generic map (data_size => data_size)
                                        port map (u_data => data, mem_data => r_mem_data);

  compute_syndrome: for i in natural(floor(log2(real(secded_message_size(data_size)))-0.01)) downto 0 generate
    p(i) <= r_mem_data((to_integer(to_unsigned(1, 32) sll i) - 1)) xor mem_data((to_integer(to_unsigned(1, 32) sll i) - 1));
  end generate compute_syndrome;

  syndrome<=TO_INTEGER(unsigned(p));

  compute_u_data: for i in data_size-1 downto 0 generate
    u_data(i)<= data(i) when (syndrome - 1) /= u_to_mem(i) else not(data(i));
  end generate compute_u_data;

  xor_mem_data(0)<=mem_data(0);
  compute_xor: for i in secded_message_size(data_size)-1 downto 1 generate
    xor_mem_data(i)<= xor_mem_data(i-1) xor mem_data(i);
  end generate compute_xor;
  p5<=xor_mem_data(secded_message_size(data_size)-1);

  uncorrectable_error<= '0' when syndrome = 0 and p5 = '0' else
                        '0' when p5 = '1' else
                        '1' when syndrome /= 0 and p5 = '0' else
                        '0';
end architecture;