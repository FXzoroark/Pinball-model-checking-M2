// modélisation du Flippeur ou machine a boules en québécois
pta

const int MAX_BILLES = 3;

module MachineABoules
    nbBilles: int;
    s: [0..29] init 0;

    invariant
		(nbBilles != 0 => true)
    endinvariant

    [syncr] -> (nbBilles' = MAX_BILLES)
    
    [] s = 0 -> (nbBilles' = nbBilles-1)

    [] nbBilles = 0 -> (nbBilles' = 0) 
endmodule

label "fin_de_partie" = nbBilles = 0;