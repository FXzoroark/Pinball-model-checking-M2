pta

const int DELAI_MAX_INTERACTION;

module Monnayeur
	resetT: clock;
	delaiInteraction: clock;
	
	jouer: bool init false;
	rendu: [0..199] init 0;
	monnaie: [0..200] init 0;

	reset: bool init false;

	invariant // TODO: ne sert a rien
		(delaiInteraction <= DELAI_MAX_INTERACTION => true)
	endinvariant
	
	[] monnaie >= 0 & monnaie < 100 & delaiInteraction >= 1 ->
			   1/9:(monnaie'=monnaie+1)   & (delaiInteraction'=0) & (resetT'=0)
			 + 1/9:(monnaie'=monnaie+2)   & (delaiInteraction'=0) & (resetT'=0)
			 + 1/9:(monnaie'=monnaie+5)   & (delaiInteraction'=0) & (resetT'=0)
			 + 1/9:(monnaie'=monnaie+10)  & (delaiInteraction'=0) & (resetT'=0)
			 + 1/9:(monnaie'=monnaie+20)  & (delaiInteraction'=0) & (resetT'=0)
			 + 1/9:(monnaie'=monnaie+50)  & (delaiInteraction'=0) & (resetT'=0)
			 + 1/9:(monnaie'=monnaie+100) & (delaiInteraction'=0) & (resetT'=0)
			 + 1/9:(monnaie'=monnaie+200) & (delaiInteraction'=0) & (resetT'=0)
			 + 1/9:(monnaie'=monnaie);
	[] monnaie >= 100 -> (rendu'=monnaie-100) & (jouer'=true);

	[] resetT >= 100 & jouer=false -> (resetT'=0) & (rendu'=monnaie) & (monnaie'=0) & (reset'=true);

	[] jouer=true -> (jouer'=true);
endmodule

label "done" = jouer=true;
label "reset" = reset=true;
