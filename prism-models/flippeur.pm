// modélisation du Flippeur ou machine a boules en québécois

module Monnayeur
    monnaie: [0..2];

    mo: [0..3] init 1;
    // mo=0 idle   => flippeur en cours d'utilisation
    // mo=1 active => attente d'argent
    // mo=2 wait   => attente du choix du joueur
    // mo=3 done   => le joueur a quitté le flippeur

    [] mo=1 & monnaie < 2 -> (monnaie'=monnaie+1);
    [] mo=1 & monnaie < 2 -> (monnaie'=monnaie);

    [lancer_partie] mo=1 & monnaie >= 1 -> (monnaie'=0) & (mo'=0);

    [partie_fini] mo=0 -> (mo'=2);
    [] mo=2 -> (mo'=1);
    [] mo=2 -> (mo'=3);
endmodule

const int MAX_BILLES = 3;

module MachineABoules
    ma: [0..2] init 0;
    // ma=0 idle   => le flippeur attend qu'un joueur insert assez d'argent pour lancer une partie
    // ma=1 active => une bille est en jeu
    // ma=2 lost   => une bille est perdue

    nb_billes: [0..3];
    s: [0..30];

    [lancer_partie] ma=0 -> (nb_billes'=MAX_BILLES) & (ma'=1) & (s'=1);
    [] ma=2 & nb_billes > 0 -> (ma'=1) & (s'=1);
    [partie_fini] ma=2 & nb_billes <= 0 -> (ma'=0);

    [rebond] ma=1 & s=1 -> 
          1/20:(s'=2)
        + 1/20:(s'=4)
        + 1/20:(s'=6)
        + 1/20:(s'=7)
        + 1/20:(s'=9)
        + 1/20:(s'=10)
        + 1/20:(s'=11)
        + 1/20:(s'=12)
        + 1/20:(s'=16)
        + 1/20:(s'=17)
        + 1/20:(s'=18)
        + 1/20:(s'=19)
        + 1/20:(s'=20)
        + 1/20:(s'=24)
        + 1/20:(s'=25)
        + 1/20:(s'=26)
        + 1/20:(s'=27)
        + 1/20:(s'=28)
        + 1/20:(s'=29)
        + 1/20:(s'=30);
    
    // Slider droit
    [rebond] ma=1 & s=2 ->
          1/8:(s'=2)
        + 1/8:(s'=10)
        + 1/8:(s'=11)
        + 1/8:(s'=12)
        + 1/8:(s'=26)
        + 1/8:(s'=28)
        + 1/8:(s'=29)
        + 1/8:(s'=30);
    [rebond] ma=1 & s=3 ->
          1/4:(s'=26)
        + 1/4:(s'=28)
        + 1/4:(s'=29)
        + 1/4:(s'=30);

    // Slider gauche
    [rebond] ma=1 & s=4 ->
          1/8:(s'=4)
        + 1/8:(s'=18)
        + 1/8:(s'=24)
        + 1/8:(s'=25)
        + 1/8:(s'=27)
        + 1/8:(s'=28)
        + 1/8:(s'=29)
        + 1/8:(s'=30);
    [rebond] ma=1 & s=5 ->
          1/4:(s'=27)
        + 1/4:(s'=28)
        + 1/4:(s'=29)
        + 1/4:(s'=30);

    // Petit bumper
    [rebond] ma=1 & s=6 ->
          1/8:(s'=4)
        + 1/8:(s'=6)
        + 1/8:(s'=18)
        + 1/8:(s'=19)
        + 1/8:(s'=20)
        + 1/8:(s'=24)
        + 1/8:(s'=25)
        + 1/8:(s'=27);
    [rebond] ma=1 & s=7 ->
          1/8:(s'=2)
        + 1/8:(s'=7)
        + 1/8:(s'=10)
        + 1/8:(s'=11)
        + 1/8:(s'=12)
        + 1/8:(s'=16)
        + 1/8:(s'=17)
        + 1/8:(s'=26);
    [rebond] ma=1 & s=8 ->
          1/9:(s'=4)
        + 1/9:(s'=18)
        + 1/9:(s'=19)
        + 1/9:(s'=20)
        + 1/9:(s'=24)
        + 1/9:(s'=25)
        + 1/9:(s'=27)
        + 1/9:(s'=29)
        + 1/9:(s'=30);
    [rebond] ma=1 & s=9 ->
          1/9:(s'=2)
        + 1/9:(s'=10)
        + 1/9:(s'=11)
        + 1/9:(s'=12)
        + 1/9:(s'=16)
        + 1/9:(s'=17)
        + 1/9:(s'=26)
        + 1/9:(s'=28)
        + 1/9:(s'=30);

    // Gros bumper droit
    [rebond] ma=1 & s=10 ->
          1/20:(s'=2)
        + 1/20:(s'=4)
        + 1/20:(s'=6)
        + 1/20:(s'=7)
        + 1/20:(s'=9)
        + 1/20:(s'=10)
        + 1/20:(s'=11)
        + 1/20:(s'=12)
        + 1/20:(s'=16)
        + 1/20:(s'=17)
        + 1/20:(s'=18)
        + 1/20:(s'=19)
        + 1/20:(s'=20)
        + 1/20:(s'=24)
        + 1/20:(s'=25)
        + 1/20:(s'=26)
        + 1/20:(s'=27)
        + 1/20:(s'=28)
        + 1/20:(s'=29)
        + 1/20:(s'=30);
    [rebond] ma=1 & s=11 ->
          1/13:(s'=2)
        + 1/13:(s'=6)
        + 1/13:(s'=7)
        + 1/13:(s'=9)
        + 1/13:(s'=10)
        + 1/13:(s'=11)
        + 1/13:(s'=12)
        + 1/13:(s'=16)
        + 1/13:(s'=17)
        + 1/13:(s'=26)
        + 1/13:(s'=28)
        + 1/13:(s'=29)
        + 1/13:(s'=30);
    [rebond] ma=1 & s=12 -> 
          1/3:(s'=2)
        + 1/3:(s'=26)
        + 1/3:(s'=30);
    [rebond] ma=1 & s=13 ->
          1/3:(s'=26)
        + 1/3:(s'=28)
        + 1/3:(s'=30);
    [rebond] ma=1 & s=14 ->
          1/5:(s'=26)
        + 1/5:(s'=27)
        + 1/5:(s'=28)
        + 1/5:(s'=29)
        + 1/5:(s'=30);
    [rebond] ma=1 & s=15 ->
          1/6:(s'=21)
        + 1/6:(s'=22)
        + 1/6:(s'=27)
        + 1/6:(s'=28)
        + 1/6:(s'=29)
        + 1/6:(s'=30);
    [rebond] ma=1 & s=16 ->
          1/7:(s'=19)
        + 1/7:(s'=20)
        + 1/7:(s'=21)
        + 1/7:(s'=27)
        + 1/7:(s'=28)
        + 1/7:(s'=29)
        + 1/7:(s'=30);
    [rebond] ma=1 & s=17 ->
          1/18:(s'=4)
        + 1/18:(s'=6)
        + 1/18:(s'=7)
        + 1/18:(s'=8)
        + 1/18:(s'=9)
        + 1/18:(s'=10)
        + 1/18:(s'=11)
        + 1/18:(s'=12)
        + 1/18:(s'=16)
        + 1/18:(s'=17)
        + 1/18:(s'=18)
        + 1/18:(s'=19)
        + 1/18:(s'=20)
        + 1/18:(s'=24)
        + 1/18:(s'=25)
        + 1/18:(s'=27)
        + 1/18:(s'=29)
        + 1/18:(s'=30);


    // Gros bumper gauche
    [rebond] ma=1 & s=18 ->
          1/20:(s'=2)
        + 1/20:(s'=4)
        + 1/20:(s'=6)
        + 1/20:(s'=7)
        + 1/20:(s'=8)
        + 1/20:(s'=10)
        + 1/20:(s'=11)
        + 1/20:(s'=12)
        + 1/20:(s'=16)
        + 1/20:(s'=17)
        + 1/20:(s'=18)
        + 1/20:(s'=19)
        + 1/20:(s'=20)
        + 1/20:(s'=24)
        + 1/20:(s'=25)
        + 1/20:(s'=26)
        + 1/20:(s'=27)
        + 1/20:(s'=28)
        + 1/20:(s'=29)
        + 1/20:(s'=30);
    [rebond] ma=1 & s=25 ->
          1/13:(s'=4)
        + 1/13:(s'=6)
        + 1/13:(s'=7)
        + 1/13:(s'=8)
        + 1/13:(s'=18)
        + 1/13:(s'=19)
        + 1/13:(s'=20)
        + 1/13:(s'=24)
        + 1/13:(s'=25)
        + 1/13:(s'=27)
        + 1/13:(s'=28)
        + 1/13:(s'=29)
        + 1/13:(s'=30);
    [rebond] ma=1 & s=24 ->
          1/3:(s'=4)
        + 1/3:(s'=27)
        + 1/3:(s'=30);
    [rebond] ma=1 & s=23 ->
          1/3:(s'=27)
        + 1/3:(s'=29)
        + 1/3:(s'=30);
    [rebond] ma=1 & s=22 ->
          1/5:(s'=26)
        + 1/5:(s'=27)
        + 1/5:(s'=28)
        + 1/5:(s'=29)
        + 1/5:(s'=30);
    [rebond] ma=1 & s=21 ->
          1/6:(s'=14)
        + 1/6:(s'=15)
        + 1/6:(s'=26)
        + 1/6:(s'=28)
        + 1/6:(s'=29)
        + 1/6:(s'=30);
    [rebond] ma=1 & s=20 ->
          1/7:(s'=15)
        + 1/7:(s'=16)
        + 1/7:(s'=17)
        + 1/7:(s'=26)
        + 1/7:(s'=28)
        + 1/7:(s'=29)
        + 1/7:(s'=30);
    [rebond] ma=1 & s=19 ->
          1/18:(s'=2)
        + 1/18:(s'=6)
        + 1/18:(s'=7)
        + 1/18:(s'=8)
        + 1/18:(s'=9)
        + 1/18:(s'=10)
        + 1/18:(s'=11)
        + 1/18:(s'=12)
        + 1/18:(s'=16)
        + 1/18:(s'=17)
        + 1/18:(s'=18)
        + 1/18:(s'=19)
        + 1/18:(s'=20)
        + 1/18:(s'=24)
        + 1/18:(s'=25)
        + 1/18:(s'=26)
        + 1/18:(s'=28)
        + 1/18:(s'=30);

    // Slider recuperation droit
    [rebond] ma=1 & s=26 ->
          1/4:(s'=26)
        + 1/4:(s'=28)
        + 1/4:(s'=29)
        + 1/4:(s'=30);

    // Slider recuperation gauche
    [rebond] ma=1 & s=27 ->
          1/4:(s'=27)
        + 1/4:(s'=28)
        + 1/4:(s'=29)
        + 1/4:(s'=30);

    // Flipper droit
    [rebond] ma=1 & s=28 ->
          1/16:(s'=4)
        + 1/16:(s'=5)
        + 1/16:(s'=8)
        + 1/16:(s'=9)
        + 1/16:(s'=14)
        + 1/16:(s'=15)
        + 1/16:(s'=16)
        + 1/16:(s'=20)
        + 1/16:(s'=21)
        + 1/16:(s'=22)
        + 1/16:(s'=23)
        + 1/16:(s'=26)
        + 1/16:(s'=27)
        + 1/16:(s'=28)
        + 1/16:(s'=29)
        + 1/16:(s'=30);
    [rebond] ma=1 & s=28 -> (s'=30);

    // Flipper gauche
    [rebond] ma=1 & s=29 ->
          1/16:(s'=2)
        + 1/16:(s'=5)
        + 1/16:(s'=8)
        + 1/16:(s'=9)
        + 1/16:(s'=22)
        + 1/16:(s'=21)
        + 1/16:(s'=20)
        + 1/16:(s'=16)
        + 1/16:(s'=15)
        + 1/16:(s'=14)
        + 1/16:(s'=13)
        + 1/16:(s'=26)
        + 1/16:(s'=27)
        + 1/16:(s'=28)
        + 1/16:(s'=29)
        + 1/16:(s'=30);
    [rebond] ma=1 & s=29 -> (s'=30);

    // Perdu
    [] ma=1 & s=30 & nb_billes >= 1 -> (nb_billes'=nb_billes-1) & (ma'=2);
endmodule

const int MAX_REBONDS;

module CompteurRebonds
    count: [0..MAX_REBONDS+1];
    // count_petits: [0..MAX_REBONDS+1];

    [rebond] count <= MAX_REBONDS -> (count'=min(count+1, MAX_REBONDS+1));
    // [rebond] count_petits <= MAX_REBONDS -> (count_petits'=min(count_petits+1, MAX_REBONDS+1));
    [done] mo=3 -> (count'=MAX_REBONDS+1);
endmodule

formula slider = s >= 2 & s <= 5;
formula gros_bumper = s >= 10 & s <= 25;
formula petit_bumper = s >= 6 & s <= 9;

// REWARDS

// machine a boules:

rewards "points"
    // [] s=2 : 20;
    [rebond] slider: 1;
    [rebond] gros_bumper: 2;
    [rebond] petit_bumper: 3;
endrewards

rewards "rebonds"
    [] s >= 2 & s <= 30 : 1;
endrewards

//global:

rewards "nb_partie_lance"
	[lancer_partie] true: 1;
endrewards


// LABELS
label "fin_session_de_jeu" = mo=3;
label "partie_commencee" = mo=1;
