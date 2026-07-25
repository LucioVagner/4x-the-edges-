Library IEEE;
USE IEEE.std_logic_1164.all;

Entity FSM is
Port(DataIn : in std_logic_vector(7 downto 0);
	  clk,reset : in std_logic;
	  N,Z,cout,ov : out std_logic;
	  DataOut,R0,R1,R2,R3,R4,R5,R6,R7 : out std_logic_vector(7 downto 0);
	  HEX0,HEX1,HEX2 : out std_logic_vector(6 downto 0)
	  );
end FSM;

architecture arq of FSM is

component datapath is
Port(DataIn : in std_logic_vector(7 downto 0);
     C : in std_logic_vector(27 downto 0);
	  clk,reset : in std_logic;
	  N,Z,cout,ov : out std_logic;
	  DataOut,R0,R1,R2,R3,R4,R5,R6,R7 : out std_logic_vector(7 downto 0)
	  );
end component;

component bin2bcd is
Port(bin      : in  std_logic_vector(7 downto 0);
     centena  : out std_logic_vector(3 downto 0);
	  dezena   : out std_logic_vector(3 downto 0);
	  unidade  : out std_logic_vector(3 downto 0)
	  );
end component;

component bcd7seg is
Port(bcd : in  std_logic_vector(3 downto 0);
     hex : out std_logic_vector(6 downto 0)
	  );
end component;

-- Tema 13: soma das arestas do prisma retangular reto
-- alocacao: R7=altura R6=largura R5=comprimento R4=soma_final
--
-- algoritmo em nivel de registradores (versao otimizada):
--   R7 <- DataIn
--   R6 <- DataIn
--   R5 <- DataIn , R4 <- R7 + R6   (quando o clock bater, deixo o R5
--        escutando o DataIn e o R4 escutando o ula_out, ao mesmo tempo)
--   R4 <- R4 + R5
--   R4 <- R4 sl
--   R4 <- R4 sl
--   DataOut <- R4

type t_state is (S0,S1,S2,S3,S4,S5,S6,S7);
signal estado_atual, prox_estado : t_state; 
signal C : std_logic_vector(27 downto 0);


signal DataOut_i : std_logic_vector(7 downto 0);


signal bcd_centena, bcd_dezena, bcd_unidade : std_logic_vector(3 downto 0);


begin

P1: process(clk,reset)
begin
   if reset = '0' then
	   estado_atual <= S0;
		
	elsif clk'event and clk = '1' then
	   estado_atual <= prox_estado;
	end if;
end process;

P2: process(estado_atual,reset)
begin
  case estado_atual is
      when S0 => 
	       if reset = '0' then
			   prox_estado <= S0;
			else
			   prox_estado <= S1;
			end if;
	       C(7 downto 0)  <= "00000000";--Mux2:1 0-DataIn  1-Data_Ula
			 C(15 downto 8) <= "00000000";--load
			 C(18 downto 16) <= "000"; -- OpA
			 C(21 downto 19) <= "000"; -- OpB
			 C(23 downto 22) <= "00"; -- OpC
			 C(24) <= '0'; -- 0-soma  1-subtrai
			 C(25) <= '0'; -- 0- SLL  1-SRL
			 C(26) <= '0'; -- 0- Soma/Sub  1-Shifter
			 C(27) <= '0'; -- 0- DataUla  1-OpA

		when S1 => 
		     C(7 downto 0)  <= "00000000";--Mux2:1 0-DataIn  1-Data_Ula
			  C(15 downto 8) <= "10000000";--load R7
			  C(18 downto 16) <= "000"; -- OpA
			  C(21 downto 19) <= "000"; -- OpB
			  C(23 downto 22) <= "00"; -- OpC
			  C(24) <= '0'; -- 0-soma  1-subtrai
			  C(25) <= '0'; -- 0- SLL  1-SRL
			  C(26) <= '0'; -- 0- Soma/Sub  1-Shifter
			  C(27) <= '0'; -- 0- DataUla  1-OpA
			  prox_estado <= S2;

		when S2 => 
		     C(7 downto 0)  <= "00000000";--Mux2:1 0-DataIn  1-Data_Ula
			  C(15 downto 8) <= "01000000";--load R6
			  C(18 downto 16) <= "000"; -- OpA
			  C(21 downto 19) <= "000"; -- OpB
			  C(23 downto 22) <= "00"; -- OpC
			  C(24) <= '0'; -- 0-soma  1-subtrai
			  C(25) <= '0'; -- 0- SLL  1-SRL
			  C(26) <= '0'; -- 0- Soma/Sub  1-Shifter
			  C(27) <= '0'; -- 0- DataUla  1-OpA
			  prox_estado <= S3;

		when S3 => 
		     C(7 downto 0)  <= "00010000";--Mux2:1 R4=1(Data_Ula) R5=0(DataIn)
			  C(15 downto 8) <= "00110000";--load R5 e R4
			  C(18 downto 16) <= "111"; -- OpA=R7
			  C(21 downto 19) <= "110"; -- OpB=R6
			  C(23 downto 22) <= "00"; -- OpC
			  C(24) <= '0'; -- 0-soma  1-subtrai  (R7+R6)
			  C(25) <= '0'; -- 0- SLL  1-SRL
			  C(26) <= '0'; -- 0- Soma/Sub  1-Shifter
			  C(27) <= '0'; -- 0- DataUla  1-OpA
			  prox_estado <= S4;

		when S4 =>
		     C(7 downto 0)  <= "00010000";--Mux2:1 R4=1(Data_Ula)
			  C(15 downto 8) <= "00010000";--load R4
			  C(18 downto 16) <= "100"; -- OpA=R4
			  C(21 downto 19) <= "101"; -- OpB=R5
			  C(23 downto 22) <= "00"; -- OpC
			  C(24) <= '0'; -- 0-soma  1-subtrai  (R4+R5)
			  C(25) <= '0'; -- 0- SLL  1-SRL
			  C(26) <= '0'; -- 0- Soma/Sub  1-Shifter
			  C(27) <= '0'; -- 0- DataUla  1-OpA
			  prox_estado <= S5;

		when S5 => 
		     C(7 downto 0)  <= "00010000";--Mux2:1 R4=1(Data_Ula)
			  C(15 downto 8) <= "00010000";--load R4
			  C(18 downto 16) <= "000"; -- OpA
			  C(21 downto 19) <= "000"; -- OpB
			  C(23 downto 22) <= "00"; -- OpC=R4 (entrada do shifter)
			  C(24) <= '0'; -- 0-soma  1-subtrai
			  C(25) <= '0'; -- 0- SLL  1-SRL
			  C(26) <= '1'; -- 0- Soma/Sub  1-Shifter
			  C(27) <= '0'; -- 0- DataUla  1-OpA
			  prox_estado <= S6;

		when S6 => 
		     C(7 downto 0)  <= "00010000";--Mux2:1 R4=1(Data_Ula)
			  C(15 downto 8) <= "00010000";--load R4
			  C(18 downto 16) <= "000"; -- OpA
			  C(21 downto 19) <= "000"; -- OpB
			  C(23 downto 22) <= "00"; -- OpC=R4 (entrada do shifter)
			  C(24) <= '0'; -- 0-soma  1-subtrai
			  C(25) <= '0'; -- 0- SLL  1-SRL
			  C(26) <= '1'; -- 0- Soma/Sub  1-Shifter
			  C(27) <= '0'; -- 0- DataUla  1-OpA
			  prox_estado <= S7;

		when S7 => --ninguem carrega nada, so jogo o R4 pra fora em DataOut
		     C(7 downto 0)  <= "00000000";--Mux2:1 (nenhum load neste estado)
			  C(15 downto 8) <= "00000000";--load
			  C(18 downto 16) <= "000"; -- OpA
			  C(21 downto 19) <= "000"; -- OpB
			  C(23 downto 22) <= "00"; -- OpC=R4 (selecionado p/ DataOut)
			  C(24) <= '0'; -- 0-soma  1-subtrai
			  C(25) <= '0'; -- 0- SLL  1-SRL
			  C(26) <= '0'; -- 0- Soma/Sub  1-Shifter
			  C(27) <= '0'; -- 0- DataUla  1-OpA
			  prox_estado <= S0;

  end case;
		
end process;

DP: datapath port map(DataIn,
                      C,
							 clk,
							 reset,
							 N,
							 Z,
							 cout,
							 ov,
							 DataOut_i,
							 R0,
							 R1,
							 R2,
							 R3,
							 R4,
							 R5,
							 R6,
							 R7);

DataOut <= DataOut_i;


CONV: bin2bcd port map(DataOut_i, bcd_centena, bcd_dezena, bcd_unidade);

D2: bcd7seg port map(bcd_centena, HEX2);
D1: bcd7seg port map(bcd_dezena,  HEX1);
D0: bcd7seg port map(bcd_unidade, HEX0);

end arq;