package CONSTANTS is
   constant IVDELAY : time := 0.1 ns;
   constant NDDELAY : time := 0.2 ns;
constant ANDDELAY : time := 0.2 ns;-------------
constant XORDELAY : time := 0.2 ns;------------
   constant NDDELAYRISE : time := 0.6 ns;
   constant NDDELAYFALL : time := 0.4 ns;
   constant NRDELAY : time := 0.2 ns;
   constant DRCAS : time := 1 ns;
   constant DRCAC : time := 2 ns;
   constant NumBit : integer := 32;	
   constant tp_mux : time := 0.5 ns; 	
   constant BLOCKS : integer := 8;
   constant BitBlock : integer := 4;
end CONSTANTS;
