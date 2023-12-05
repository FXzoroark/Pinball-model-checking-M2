// modélisation du Flippeur ou machine a boules en québécois

pta

const int DELAI_MAX_INTERACTION = 2;

module Monnayeur

	monnaie: [0..299];

	mo: [0..2] init 1;
	// mo=0 idle   => flippeur en cours d'utilisation
	// mo=1 active => attente d'argent
	// mo=2 done   => le joueur a quitté le flippeur

	reset:             clock;
	delai_interaction: clock;


	invariant
		(mo=0 => true) &
		(mo=1 => delai_interaction <= DELAI_MAX_INTERACTION & reset <= 101) &
        (mo=2 => true)
	endinvariant
	
	[] mo=1 & monnaie < 100 & delai_interaction >= 1 ->
			   1/9:(monnaie'=monnaie+1)   & (delai_interaction'=0) & (reset'=0)
			 + 1/9:(monnaie'=monnaie+2)   & (delai_interaction'=0) & (reset'=0)
			 + 1/9:(monnaie'=monnaie+5)   & (delai_interaction'=0) & (reset'=0)
			 + 1/9:(monnaie'=monnaie+10)  & (delai_interaction'=0) & (reset'=0)
			 + 1/9:(monnaie'=monnaie+20)  & (delai_interaction'=0) & (reset'=0)
			 + 1/9:(monnaie'=monnaie+50)  & (delai_interaction'=0) & (reset'=0)
			 + 1/9:(monnaie'=monnaie+100) & (delai_interaction'=0) & (reset'=0)
			 + 1/9:(monnaie'=monnaie+200) & (delai_interaction'=0) & (reset'=0)
			 + 1/9:(monnaie'=monnaie);

	[lancer_partie] mo=1 & monnaie >= 100 -> (monnaie'=0) & (mo'=0);

	[reset_monnayeur] mo=1 & reset >= 100 -> (reset'=0) & (monnaie'=0);

	[partie_fini] mo=0 -> 
		           2/3:(mo'=1) & (delai_interaction'=0) & (reset'=0)
		         + 1/3:(mo'=2);

endmodule


module Lanceur
	l: [0..2];
	// l=0 => il n'y a pas de bille dans le lanceur
	// l=1 => la bille s'apprete à être lancer
	// l=2 => la bille a été propulser dans le jeu



	[pret_a_lancer] l=0 -> (l'=1);
	[] 		        l=1 ->    9/10:(l'=2)
				            + 1/10:(l'=1);

	[bille_mise_en_jeu] l=2 -> (l'=0);

endmodule

const int MAX_BILLES = 3;

module MachineABoules

    ma: [0..2];
    // ma=0 idle   => le flippeur attend qu'un joueur insert assez d'argent pour lancer une partie
    // ma=1 ready to launch => le flippeur attend que la bille soit mise en jeu
    // ma=2 active => une bille est en jeu

    nb_billes: [0..3];
    s: [0..29];


    [lancer_partie] ma=0 -> (nb_billes'=MAX_BILLES) & (ma'=1);
    
    [pret_a_lancer] ma=1 & nb_billes > 0 -> true;
    [bille_mise_en_jeu] ma=1  & nb_billes > 0-> 1:(nb_billes'=nb_billes-1) & (ma'=2) & (s'=1);
    [partie_fini] ma=1 & nb_billes = 0 -> (ma'=0);

    [] ma=2 & s=1 -> (ma'=1);


endmodule


// REWARDS
// monnayeur:

rewards "nb_reset_monnayeur"
	[reset_monnayeur] true: 1;
endrewards

rewards "count_monnaie_rendue"
	monnaie >= 100: monnaie - 100;
	[reset_monnayeur] true : monnaie;
endrewards

//global

rewards "nb_partie_lance"
	[lancer_partie] true: 1;
endrewards

rewards "temps_session_de_jeu"
	true: 1;
endrewards


// LABELS
label "fin_session_de_jeu" = mo=2;