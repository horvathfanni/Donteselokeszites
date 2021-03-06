set Rendezvenyek;
set Napok;

param sospogacsa{r in Rendezvenyek, n in Napok};
param eladasiar{r in Rendezvenyek};
param tavolsag{ r in Rendezvenyek};

set Pogacsatipusok;
param sulesido{p in Pogacsatipusok};
param egytalca{p in Pogacsatipusok};
param maxtalcasutonkent{ p in Pogacsatipusok};

set Hazhozszallitas;
param kapacitas { h in Hazhozszallitas};
param fogyasztas{ h in Hazhozszallitas};
param uzemanyagar{ h in Hazhozszallitas};

param beszerar;
param fizetes;
param dolgozokszama;

param elsoinditas;
param sutesekkozott;
 
#Valtozok

#melyik nap hova szállítunk
var szallitas{r in Rendezvenyek, n in Napok}, binary;

#mennyit dolgoznak az emberek
var munkaido {n in Napok}, integer, >=0;



#segedek
var beszerzesi;
var eladasi;
var munkaber;
var szallitasikoltseg;
var munkaidoosszesen;

var sutesszam {n in Napok, p in Pogacsatipusok}, integer;


#korlatozosok
#termek nepszerusitese
s.t. egyszer_mindenhova_kell{r in Rendezvenyek}:
sum{n in Napok} szallitas[r,n]>=1;

#minimumum 35kg pogacsanak kell az autoben leni
s.t. egy_nap_minimum_35kg{n in Napok}:
sum{r in Rendezvenyek} szallitas[r,n]*sospogacsa[r,n]>=35;

#egy nap max 60kg
s.t. nem_Szallithatunk_60kgnal_tobbet_naponta{n in Napok, h in Hazhozszallitas}: 
sum{r in Rendezvenyek} sospogacsa[r,n]*szallitas[r,n]<=kapacitas[h];

#egynap max 70km
s.t. egy_nap_max_70km_tehetunk_meg{n in Napok}:
sum{r in Rendezvenyek} tavolsag[r]*szallitas[r,n] <=70;

#hanysutes
s.t. Sutesszam{n in Napok, p in Pogacsatipusok}:
sutesszam[n,p] >= sum {r in Rendezvenyek}(sospogacsa[r,n]*szallitas[r,n])
  /(egytalca[p]*maxtalcasutonkent[p]);

#munkaido
s.t. munkaido_kiszamitas{n in Napok}:
 munkaido[n]>= elsoinditas 
 + sum {p in Pogacsatipusok} sulesido[p] * sutesszam[n,p]
 + sutesekkozott * (sum {p in Pogacsatipusok} sutesszam[n,p]-1);

#egy nap max 12h munka
s.t.munkaido_korlat1{n in Napok}:
munkaido[n]<=12*60;






s.t. beszerarConstraint:
beszerzesi=sum{r in Rendezvenyek, n in Napok} szallitas[r,n]*sospogacsa[r,n]*beszerar;

s.t. eladasiarConstraint:
eladasi=sum{r in Rendezvenyek, n in Napok} szallitas[r,n]*sospogacsa[r,n]*eladasiar[r];

s.t. munkabConstraint:
munkaber=sum{n in Napok} dolgozokszama*munkaido[n]/60*fizetes;

s.t. szallitasikoltsegConstraint:
szallitasikoltseg=sum{r in Rendezvenyek,n in Napok, h in Hazhozszallitas} (szallitas[r,n]*tavolsag[r])*(fogyasztas[h]/100)*uzemanyagar[h];

s.t. munkaidoConstraint{p in Pogacsatipusok}:
munkaidoosszesen=sum{n in Napok} munkaido[n];

#célfüggvény
maximize bevetel:
-beszerzesi
-munkaber
-szallitasikoltseg
+eladasi;

solve;

printf "-----------------------\n";
printf "\n\nProfit: %.2f\n\n",bevetel;
printf "-----------------------\n";
printf "beszerzesi ar:\t-%d\n",  beszerzesi;

printf "munkaber:\t-%d\n",  munkaber;

printf "szallitasi koltseg:\t-%d\n",  szallitasikoltseg;
printf "eladasi ar:\t+%d\n",  eladasi;


printf "-----------------------\n";
printf "    ";
for {n in Napok} printf "%2s%12s",' ',n;
printf "\n";
for {r in Rendezvenyek}{
printf "%10s\t", r;

for { n in Napok} printf "%7d", szallitas[r,n];

printf "\n";
}




	printf "\n";
	


printf "\n";

end;
