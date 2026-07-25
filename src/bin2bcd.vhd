Library IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;

Entity bin2bcd is
Port(bin      : in  std_logic_vector(7 downto 0);
     centena  : out std_logic_vector(3 downto 0);
	  dezena   : out std_logic_vector(3 downto 0);
	  unidade  : out std_logic_vector(3 downto 0)
	  );
end bin2bcd;

architecture arq of bin2bcd is
begin

process(bin)
   variable reg : std_logic_vector(19 downto 0);
begin
   reg := (others => '0');
   reg(7 downto 0) := bin;

   for i in 0 to 7 loop
     
      if reg(11 downto 8) >= "0101" then
         reg(11 downto 8) := reg(11 downto 8) + "0011";
      end if;
      if reg(15 downto 12) >= "0101" then
         reg(15 downto 12) := reg(15 downto 12) + "0011";
      end if;
      if reg(19 downto 16) >= "0101" then
         reg(19 downto 16) := reg(19 downto 16) + "0011";
      end if;

      reg := reg(18 downto 0) & '0'; 
   end loop;

   unidade <= reg(11 downto 8);
   dezena  <= reg(15 downto 12);
   centena <= reg(19 downto 16);
end process;

end arq;
