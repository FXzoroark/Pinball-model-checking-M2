// modélisation du Flippeur ou machine a boules en québécois

const int DELAI_MAX_INTERACTION = 20;

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
		(mo=1 => delai_interaction <= DELAI_MAX_INTERACTION & reset <= 1010) &
        	(mo=2 => true)
	endinvariant
	
	[] mo=1 & monnaie < 100 & delai_interaction >= 10 ->
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

	[reset_monnayeur] mo=1 & reset >= 1000 -> (reset'=0) & (monnaie'=0);

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
const int REBOND;

module MachineABoules
   temps_rebond: clock;

    ma: [0..2];
    // ma=0 idle   => le flippeur attend qu'un joueur insert assez d'argent pour lancer une partie
    // ma=1 ready to launch => le flippeur attend que la bille soit mise en jeu
    // ma=2 active => une bille est en jeu

    nb_billes: [0..3];
    s: [0..30];

    invariant
        (ma=0 => true) &
        (ma=1 => true) &
        (ma=2 => temps_rebond <= 5)
    endinvariant

    [lancer_partie] ma=0 -> (nb_billes'=MAX_BILLES) & (ma'=1);
    
    [pret_a_lancer] ma=1 & nb_billes > 0 -> true;
    [bille_mise_en_jeu] ma=1  & nb_billes > 0-> 1:(nb_billes'=nb_billes-1) & (ma'=2) & (s'=1);
    [partie_fini] ma=1 & nb_billes = 0 -> (ma'=0);

    [] temps_rebond>=REBOND & ma=2 & s=1 -> 
          1/20:(s'=2) & (temps_rebond'=0)
        + 1/20:(s'=4) & (temps_rebond'=0)
        + 1/20:(s'=6) & (temps_rebond'=0)
        + 1/20:(s'=7) & (temps_rebond'=0)
        + 1/20:(s'=9) & (temps_rebond'=0)
        + 1/20:(s'=10) & (temps_rebond'=0)
        + 1/20:(s'=11) & (temps_rebond'=0)
        + 1/20:(s'=12) & (temps_rebond'=0)
        + 1/20:(s'=16) & (temps_rebond'=0)
        + 1/20:(s'=17) & (temps_rebond'=0)
        + 1/20:(s'=18) & (temps_rebond'=0)
        + 1/20:(s'=19) & (temps_rebond'=0)
        + 1/20:(s'=20) & (temps_rebond'=0)
        + 1/20:(s'=24) & (temps_rebond'=0)
        + 1/20:(s'=25) & (temps_rebond'=0)
        + 1/20:(s'=26) & (temps_rebond'=0)
        + 1/20:(s'=27) & (temps_rebond'=0)
        + 1/20:(s'=28) & (temps_rebond'=0)
        + 1/20:(s'=29) & (temps_rebond'=0)
        + 1/20:(s'=30) & (temps_rebond'=0);
    
    // Slider droit
    [] temps_rebond>=REBOND & ma=2 & s=2 ->
          1/8:(s'=2) & (temps_rebond'=0)
        + 1/8:(s'=10) & (temps_rebond'=0)
        + 1/8:(s'=11) & (temps_rebond'=0)
        + 1/8:(s'=12) & (temps_rebond'=0)
        + 1/8:(s'=26) & (temps_rebond'=0)
        + 1/8:(s'=28) & (temps_rebond'=0)
        + 1/8:(s'=29) & (temps_rebond'=0)
        + 1/8:(s'=30) & (temps_rebond'=0);
    [] temps_rebond>=REBOND & ma=2 & s=3 ->
          1/4:(s'=26) & (temps_rebond'=0)
        + 1/4:(s'=28) & (temps_rebond'=0)
        + 1/4:(s'=29) & (temps_rebond'=0)
        + 1/4:(s'=30) & (temps_rebond'=0);

    // Slider gauche
    [] temps_rebond>=REBOND & ma=2 & s=4 ->
          1/8:(s'=4) & (temps_rebond'=0)
        + 1/8:(s'=18) & (temps_rebond'=0)
        + 1/8:(s'=24) & (temps_rebond'=0)
        + 1/8:(s'=25) & (temps_rebond'=0)
        + 1/8:(s'=27) & (temps_rebond'=0)
        + 1/8:(s'=28) & (temps_rebond'=0)
        + 1/8:(s'=29) & (temps_rebond'=0)
        + 1/8:(s'=30) & (temps_rebond'=0);
    [] temps_rebond>=REBOND & ma=2 & s=5 ->
          1/4:(s'=27) & (temps_rebond'=0)
        + 1/4:(s'=28) & (temps_rebond'=0)
        + 1/4:(s'=29) & (temps_rebond'=0)
        + 1/4:(s'=30) & (temps_rebond'=0);

    // Petit bumper
    [] temps_rebond>=REBOND & ma=2 & s=6 ->
          1/8:(s'=4) & (temps_rebond'=0)
        + 1/8:(s'=6) & (temps_rebond'=0)
        + 1/8:(s'=18) & (temps_rebond'=0)
        + 1/8:(s'=19) & (temps_rebond'=0)
        + 1/8:(s'=20) & (temps_rebond'=0)
        + 1/8:(s'=24) & (temps_rebond'=0)
        + 1/8:(s'=25) & (temps_rebond'=0)
        + 1/8:(s'=27) & (temps_rebond'=0);
    [] temps_rebond>=REBOND & ma=2 & s=7 ->
          1/8:(s'=2) & (temps_rebond'=0)
        + 1/8:(s'=7) & (temps_rebond'=0)
        + 1/8:(s'=10) & (temps_rebond'=0)
        + 1/8:(s'=11) & (temps_rebond'=0)
        + 1/8:(s'=12) & (temps_rebond'=0)
        + 1/8:(s'=16) & (temps_rebond'=0)
        + 1/8:(s'=17) & (temps_rebond'=0)
        + 1/8:(s'=26) & (temps_rebond'=0);
    [] temps_rebond>=REBOND & ma=2 & s=8 ->
          1/9:(s'=4) & (temps_rebond'=0)
        + 1/9:(s'=18) & (temps_rebond'=0)
        + 1/9:(s'=19) & (temps_rebond'=0)
        + 1/9:(s'=20) & (temps_rebond'=0)
        + 1/9:(s'=24) & (temps_rebond'=0)
        + 1/9:(s'=25) & (temps_rebond'=0)
        + 1/9:(s'=27) & (temps_rebond'=0)
        + 1/9:(s'=29) & (temps_rebond'=0)
        + 1/9:(s'=30) & (temps_rebond'=0);
    [] temps_rebond>=REBOND & ma=2 & s=9 ->
          1/9:(s'=2) & (temps_rebond'=0)
        + 1/9:(s'=10) & (temps_rebond'=0)
        + 1/9:(s'=11) & (temps_rebond'=0)
        + 1/9:(s'=12) & (temps_rebond'=0)
        + 1/9:(s'=16) & (temps_rebond'=0)
        + 1/9:(s'=17) & (temps_rebond'=0)
        + 1/9:(s'=26) & (temps_rebond'=0)
        + 1/9:(s'=28) & (temps_rebond'=0)
        + 1/9:(s'=30) & (temps_rebond'=0);

    // Gros bumper droit
    [] temps_rebond>=REBOND & ma=2 & s=10 ->
          1/20:(s'=2) & (temps_rebond'=0)
        + 1/20:(s'=4) & (temps_rebond'=0)
        + 1/20:(s'=6) & (temps_rebond'=0)
        + 1/20:(s'=7) & (temps_rebond'=0)
        + 1/20:(s'=9) & (temps_rebond'=0)
        + 1/20:(s'=10) & (temps_rebond'=0)
        + 1/20:(s'=11) & (temps_rebond'=0)
        + 1/20:(s'=12) & (temps_rebond'=0)
        + 1/20:(s'=16) & (temps_rebond'=0)
        + 1/20:(s'=17) & (temps_rebond'=0)
        + 1/20:(s'=18) & (temps_rebond'=0)
        + 1/20:(s'=19) & (temps_rebond'=0)
        + 1/20:(s'=20) & (temps_rebond'=0)
        + 1/20:(s'=24) & (temps_rebond'=0)
        + 1/20:(s'=25) & (temps_rebond'=0)
        + 1/20:(s'=26) & (temps_rebond'=0)
        + 1/20:(s'=27) & (temps_rebond'=0)
        + 1/20:(s'=28) & (temps_rebond'=0)
        + 1/20:(s'=29) & (temps_rebond'=0)
        + 1/20:(s'=30) & (temps_rebond'=0);
    [] temps_rebond>=REBOND & ma=2 & s=11 ->
          1/13:(s'=2) & (temps_rebond'=0)
        + 1/13:(s'=6) & (temps_rebond'=0)
        + 1/13:(s'=7) & (temps_rebond'=0)
        + 1/13:(s'=9) & (temps_rebond'=0)
        + 1/13:(s'=10) & (temps_rebond'=0)
        + 1/13:(s'=11) & (temps_rebond'=0)
        + 1/13:(s'=12) & (temps_rebond'=0)
        + 1/13:(s'=16) & (temps_rebond'=0)
        + 1/13:(s'=17) & (temps_rebond'=0)
        + 1/13:(s'=26) & (temps_rebond'=0)
        + 1/13:(s'=28) & (temps_rebond'=0)
        + 1/13:(s'=29) & (temps_rebond'=0)
        + 1/13:(s'=30) & (temps_rebond'=0);
    [] temps_rebond>=REBOND & ma=2 & s=12 -> 
          1/3:(s'=2) & (temps_rebond'=0)
        + 1/3:(s'=26) & (temps_rebond'=0)
        + 1/3:(s'=30) & (temps_rebond'=0);
    [] temps_rebond>=REBOND & ma=2 & s=13 ->
          1/3:(s'=26) & (temps_rebond'=0)
        + 1/3:(s'=28) & (temps_rebond'=0)
        + 1/3:(s'=30) & (temps_rebond'=0);
    [] temps_rebond>=REBOND & ma=2 & s=14 ->
          1/5:(s'=26) & (temps_rebond'=0)
        + 1/5:(s'=27) & (temps_rebond'=0)
        + 1/5:(s'=28) & (temps_rebond'=0)
        + 1/5:(s'=29) & (temps_rebond'=0)
        + 1/5:(s'=30) & (temps_rebond'=0);
    [] temps_rebond>=REBOND & ma=2 & s=15 ->
          1/6:(s'=21) & (temps_rebond'=0)
        + 1/6:(s'=22) & (temps_rebond'=0)
        + 1/6:(s'=27) & (temps_rebond'=0)
        + 1/6:(s'=28) & (temps_rebond'=0)
        + 1/6:(s'=29) & (temps_rebond'=0)
        + 1/6:(s'=30) & (temps_rebond'=0);
    [] temps_rebond>=REBOND & ma=2 & s=16 ->
          1/7:(s'=19) & (temps_rebond'=0)
        + 1/7:(s'=20) & (temps_rebond'=0)
        + 1/7:(s'=21) & (temps_rebond'=0)
        + 1/7:(s'=27) & (temps_rebond'=0)
        + 1/7:(s'=28) & (temps_rebond'=0)
        + 1/7:(s'=29) & (temps_rebond'=0)
        + 1/7:(s'=30) & (temps_rebond'=0);
    [] temps_rebond>=REBOND & ma=2 & s=17 ->
          1/18:(s'=4) & (temps_rebond'=0)
        + 1/18:(s'=6) & (temps_rebond'=0)
        + 1/18:(s'=7) & (temps_rebond'=0)
        + 1/18:(s'=8) & (temps_rebond'=0)
        + 1/18:(s'=9) & (temps_rebond'=0)
        + 1/18:(s'=10) & (temps_rebond'=0)
        + 1/18:(s'=11) & (temps_rebond'=0)
        + 1/18:(s'=12) & (temps_rebond'=0)
        + 1/18:(s'=16) & (temps_rebond'=0)
        + 1/18:(s'=17) & (temps_rebond'=0)
        + 1/18:(s'=18) & (temps_rebond'=0)
        + 1/18:(s'=19) & (temps_rebond'=0)
        + 1/18:(s'=20) & (temps_rebond'=0)
        + 1/18:(s'=24) & (temps_rebond'=0)
        + 1/18:(s'=25) & (temps_rebond'=0)
        + 1/18:(s'=27) & (temps_rebond'=0)
        + 1/18:(s'=29) & (temps_rebond'=0)
        + 1/18:(s'=30) & (temps_rebond'=0);


    // Gros bumper gauche
    [] temps_rebond>=REBOND & ma=2 & s=18 ->
          1/20:(s'=2) & (temps_rebond'=0)
        + 1/20:(s'=4) & (temps_rebond'=0)
        + 1/20:(s'=6) & (temps_rebond'=0)
        + 1/20:(s'=7) & (temps_rebond'=0)
        + 1/20:(s'=8) & (temps_rebond'=0)
        + 1/20:(s'=10) & (temps_rebond'=0)
        + 1/20:(s'=11) & (temps_rebond'=0)
        + 1/20:(s'=12) & (temps_rebond'=0)
        + 1/20:(s'=16) & (temps_rebond'=0)
        + 1/20:(s'=17) & (temps_rebond'=0)
        + 1/20:(s'=18) & (temps_rebond'=0)
        + 1/20:(s'=19) & (temps_rebond'=0)
        + 1/20:(s'=20) & (temps_rebond'=0)
        + 1/20:(s'=24) & (temps_rebond'=0)
        + 1/20:(s'=25) & (temps_rebond'=0)
        + 1/20:(s'=26) & (temps_rebond'=0)
        + 1/20:(s'=27) & (temps_rebond'=0)
        + 1/20:(s'=28) & (temps_rebond'=0)
        + 1/20:(s'=29) & (temps_rebond'=0)
        + 1/20:(s'=30) & (temps_rebond'=0);
    [] temps_rebond>=REBOND & ma=2 & s=25 ->
          1/13:(s'=4) & (temps_rebond'=0)
        + 1/13:(s'=6) & (temps_rebond'=0)
        + 1/13:(s'=7) & (temps_rebond'=0)
        + 1/13:(s'=8) & (temps_rebond'=0)
        + 1/13:(s'=18) & (temps_rebond'=0)
        + 1/13:(s'=19) & (temps_rebond'=0)
        + 1/13:(s'=20) & (temps_rebond'=0)
        + 1/13:(s'=24) & (temps_rebond'=0)
        + 1/13:(s'=25) & (temps_rebond'=0)
        + 1/13:(s'=27) & (temps_rebond'=0)
        + 1/13:(s'=28) & (temps_rebond'=0)
        + 1/13:(s'=29) & (temps_rebond'=0)
        + 1/13:(s'=30) & (temps_rebond'=0);
    [] temps_rebond>=REBOND & ma=2 & s=24 ->
          1/3:(s'=4) & (temps_rebond'=0)
        + 1/3:(s'=27) & (temps_rebond'=0)
        + 1/3:(s'=30) & (temps_rebond'=0);
    [] temps_rebond>=REBOND & ma=2 & s=23 ->
          1/3:(s'=27) & (temps_rebond'=0)
        + 1/3:(s'=29) & (temps_rebond'=0)
        + 1/3:(s'=30) & (temps_rebond'=0);
    [] temps_rebond>=REBOND & ma=2 & s=22 ->
          1/5:(s'=26) & (temps_rebond'=0)
        + 1/5:(s'=27) & (temps_rebond'=0)
        + 1/5:(s'=28) & (temps_rebond'=0)
        + 1/5:(s'=29) & (temps_rebond'=0)
        + 1/5:(s'=30) & (temps_rebond'=0);
    [] temps_rebond>=REBOND & ma=2 & s=21 ->
          1/6:(s'=14) & (temps_rebond'=0)
        + 1/6:(s'=15) & (temps_rebond'=0)
        + 1/6:(s'=26) & (temps_rebond'=0)
        + 1/6:(s'=28) & (temps_rebond'=0)
        + 1/6:(s'=29) & (temps_rebond'=0)
        + 1/6:(s'=30) & (temps_rebond'=0);
    [] temps_rebond>=REBOND & ma=2 & s=20 ->
          1/7:(s'=15) & (temps_rebond'=0)
        + 1/7:(s'=16) & (temps_rebond'=0)
        + 1/7:(s'=17) & (temps_rebond'=0)
        + 1/7:(s'=26) & (temps_rebond'=0)
        + 1/7:(s'=28) & (temps_rebond'=0)
        + 1/7:(s'=29) & (temps_rebond'=0)
        + 1/7:(s'=30) & (temps_rebond'=0);
    [] temps_rebond>=REBOND & ma=2 & s=19 ->
          1/18:(s'=2) & (temps_rebond'=0)
        + 1/18:(s'=6) & (temps_rebond'=0)
        + 1/18:(s'=7) & (temps_rebond'=0)
        + 1/18:(s'=8) & (temps_rebond'=0)
        + 1/18:(s'=9) & (temps_rebond'=0)
        + 1/18:(s'=10) & (temps_rebond'=0)
        + 1/18:(s'=11) & (temps_rebond'=0)
        + 1/18:(s'=12) & (temps_rebond'=0)
        + 1/18:(s'=16) & (temps_rebond'=0)
        + 1/18:(s'=17) & (temps_rebond'=0)
        + 1/18:(s'=18) & (temps_rebond'=0)
        + 1/18:(s'=19) & (temps_rebond'=0)
        + 1/18:(s'=20) & (temps_rebond'=0)
        + 1/18:(s'=24) & (temps_rebond'=0)
        + 1/18:(s'=25) & (temps_rebond'=0)
        + 1/18:(s'=26) & (temps_rebond'=0)
        + 1/18:(s'=28) & (temps_rebond'=0)
        + 1/18:(s'=30) & (temps_rebond'=0);

    // Slider recuperation droit
    [] temps_rebond>=REBOND & ma=2 & s=26 ->
          1/4:(s'=26) & (temps_rebond'=0)
        + 1/4:(s'=28) & (temps_rebond'=0)
        + 1/4:(s'=29) & (temps_rebond'=0)
        + 1/4:(s'=30) & (temps_rebond'=0);

    // Slider recuperation gauche
    [] temps_rebond>=REBOND & ma=2 & s=27 ->
          1/4:(s'=27) & (temps_rebond'=0)
        + 1/4:(s'=28) & (temps_rebond'=0)
        + 1/4:(s'=29) & (temps_rebond'=0)
        + 1/4:(s'=30) & (temps_rebond'=0);

    // Flipper droit
    [] temps_rebond>=REBOND & ma=2 & s=28 ->
          1/16:(s'=4) & (temps_rebond'=0)
        + 1/16:(s'=5) & (temps_rebond'=0)
        + 1/16:(s'=8) & (temps_rebond'=0)
        + 1/16:(s'=9) & (temps_rebond'=0)
        + 1/16:(s'=14) & (temps_rebond'=0)
        + 1/16:(s'=15) & (temps_rebond'=0)
        + 1/16:(s'=16) & (temps_rebond'=0)
        + 1/16:(s'=20) & (temps_rebond'=0)
        + 1/16:(s'=21) & (temps_rebond'=0)
        + 1/16:(s'=22) & (temps_rebond'=0)
        + 1/16:(s'=23) & (temps_rebond'=0)
        + 1/16:(s'=26) & (temps_rebond'=0)
        + 1/16:(s'=27) & (temps_rebond'=0)
        + 1/16:(s'=28) & (temps_rebond'=0)
        + 1/16:(s'=29) & (temps_rebond'=0)
        + 1/16:(s'=30) & (temps_rebond'=0);

    // Flipper gauche
    [] temps_rebond>=REBOND & ma=2 & s=29 ->
          1/16:(s'=2) & (temps_rebond'=0)
        + 1/16:(s'=5) & (temps_rebond'=0)
        + 1/16:(s'=8) & (temps_rebond'=0)
        + 1/16:(s'=9) & (temps_rebond'=0)
        + 1/16:(s'=22) & (temps_rebond'=0)
        + 1/16:(s'=21) & (temps_rebond'=0)
        + 1/16:(s'=20) & (temps_rebond'=0)
        + 1/16:(s'=16) & (temps_rebond'=0)
        + 1/16:(s'=15) & (temps_rebond'=0)
        + 1/16:(s'=14) & (temps_rebond'=0)
        + 1/16:(s'=13) & (temps_rebond'=0)
        + 1/16:(s'=26) & (temps_rebond'=0)
        + 1/16:(s'=27) & (temps_rebond'=0)
        + 1/16:(s'=28) & (temps_rebond'=0)
        + 1/16:(s'=29) & (temps_rebond'=0)
        + 1/16:(s'=30) & (temps_rebond'=0);

    // Perdu
    [] ma=2 & s=30 -> (ma'=1);
endmodule

formula slider = s >= 2 & s <= 5;
formula gros_bumper = s >= 10 & s <= 25;
formula petit_bumper = s >= 6 & s <= 9;

// REWARDS

// monnayeur:

rewards "nb_reset_monnayeur"
	[reset_monnayeur] true: 1;
endrewards

rewards "count_monnaie_rendue"
	monnaie >= 100: monnaie - 100;
	[reset_monnayeur] true : monnaie;
endrewards

// machine a boules:

rewards "points"
    [] slider : 20;
    [] gros_bumper : 40;
    [] petit_bumper : 100;
endrewards

//global:

rewards "nb_partie_lance"
	[lancer_partie] true: 1;
endrewards

rewards "temps_session_de_jeu"
	true: 1;
endrewards


// LABELS
label "fin_session_de_jeu" = mo=2;
