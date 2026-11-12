/***********************************************************/
/****            Analiza Wielowymiarowa                 ****/
/****                  zajêcia 03                       ****/
/****      Testy parametryczne i nieparametryczne       ****/
/***********************************************************/ 

/// Wnioskowanie na podstawie testow statystycznych przeprowadzane jest przy standardowym w naukach spolecznych poziomie istotnosci 0.05,
/// chyba, że zaznaczono inaczej 
sysuse auto
/// 1. SPOSOBY ZAPOZNANIA SIĘ Z ZAWARTOŚCIĄ ZBIORU DANYCH 
/// Opis zawartosci zbioru danych 
describe
/// Ksiazka kodowa zbioru, przydatna w przypadku zmiennych jakosciowych 
codebook
/// Wyswietlenie danych 
list
/// ja polecam do przegladania danych 
browse
/// Szybki przeglad zmiennych 
inspect
/// Statystyki opisowe 
summarize

/// 2. TESTY PARAMETRYCZNE I NIEPARAMETRYCZNE DLA ŚREDNICH 
/// test t dla srednich przy zalozeniu rownej wariancji 
ttest price, by(foreign)

/// Warto zwrocic uwage ze roznica wynosi -312.2587 jednak p-value dla wszytskich hipotez jest dosyc niskie, gdyz odchylenie standardowe jest relatywnie wysokie.

/// test t dla srednich bez zalozenia o rownej wariancji 
ttest price, by(foreign) unequal

/// Histogram zmiennej price */
histogram price, bin(10)
/// Czy rozklad zmiennej jest zblizony do rozkladu normalnego, jesli nie to jaki ma rozklad ?  

gen lprice = ln(price)
/// Czy po transformacji zmienna ma rozklad zblizony do normalnego? 
histogram lprice, bin(10)

/// Przeprowadzmy test dla przeksztalconej zmiennej 
ttest lprice, by(foreign)

ttest lprice, by(foreign) unequal

/// Test dla proporcji */
/// Dla jednej proby */
/// Sprawdzamy, czy udzial wartosci 'foreign' dla zmiennej 'foreign' wynosi 0.4
/// STATA "wie", ze chodzi nam o wartosc 'foreign' a nie o 'domestic', ponieważ to wartosc 'foreign' jest oznaczona jako '1' 
prtest foreign==.4
/// Proszę zwrocić uwagę, że na dole wskazane sa hipotezy alternatywne (Ha) a nie zerowe.
/// Wyniki wskazują na:
//  - brak podstaw do odrzucenia H0 o proporcji 0.4 na korzysc Ha ze p > 0.4 (Zatem proporcja jest wieksza niz 0.4)
//  - brak podstaw do odrzucenia 0.4 na korzysc Ha ze  p != 0.4 (Zatem proporcja jest rozna od 0.4)
//  - odrzucenie H0 o proporcji 0.4 na korzysc Ha ze  p < 0.4 (Zatem proporcja jest mniejsza niz 0.4)

/// Mozna sprawdzic, ze w rzeczywistosci w tych danych p=0.3 (udzial foreign).
/// Teraz testy wykaza brak podstaw do odrzucenia H0 dla kazdej hipotezy alternatywnej:
prtest foreign==.3

/// Tworzymy zmienna 0-1 o wartosci 1 dla ceny pow. 10.000$ 
gen price_10 = (price>10000)
/// Sprawdzamy czy udzial samochodow o cenie pow. 10.000$ jest taki sam jak zagranicznych 
prtest price_10==foreign

/// Testy wskazuja na:
//  - odrzucenie H0 o rownosci na korzysc Ha ze prop(price_10) - prop(foreign) < 0 (zatem, wiekszy jest udzial samochodów zagranicznych)
//  - odrzucenie H0 o rownosci na korzysc Ha ze prop(price_10) - prop(foreign) != 0 (zatem udziały nie są równe) 
//  - brak podstaw do odrzucenia H0 o rownosci w porownaniu z Ha ze prop(price_10) - prop(foreign) > 0 (zatem nie można odrzucić hipotezy o równości proporcji wzgledem alternatywy, ze wiekszy jest udzial samochodów drozszych niz 10k USD)

/// Testy dla wariancji 
/// Test F 
sdtest price,by(foreign)
/// Badamy wariancje zmiennej price w dwoch podprobach pogrupowanych na podstawie zmiennej foreign, H0: rowne wariancje
/// Odp. Brak podstaw do odrzucenia H0 wobec kazdej z hipotez alternatywnych 

/// Test Levene 
/// W0 - wartosc statystyki Levene, 
/// W50 - wartosc statystyki dla testu w ktorym zamiast sredniej wykorzystano mediane 
/// W10 - wartosc statystyki dla testu w ktorym zamiast sredniej wykorzystano ucieta srednia '10% trimmed mean'
robvar price, by(foreign)
/// Odp. H0: wariancje sa rowne, wiec dla kazdego z wariantow tego testu brak podstaw do odrzucenia H0 o rownosci wariancji 

/// Tabelaryczny opis zmiennych 
/// Tabela krzyzowa: po poleceniu tabulate wymieniamy dwie nazwy zmiennych 
tab rep78 foreign

/// Testy dla rozkladow 
/// Test Kurskalla - Wallisa 
/// H0: Równosc dystrybuant rozk³adow w porownywanych populacjach 
kwallis price,by(foreign)

/// Test Kolmogorowa - Smirnowa 
ksmirnov price,by(foreign)


/// ******************************************************* CWICZENIA*****************************************************************************************
/// 3. Cwiczenie **/
/// Na postawie danych z 4 kwartalu 2009 roku bedziemy porownywac: 
/// (a) place kobiet i mezczyzn w Polsce 
/// (b) wyksztalcenie kobiet i mezczyznw Polsce 
/// Prosze sciagnac dane ze strony www.ekonometria.wne.uw.edu.pl i zaladowac do Stata 

/// Kilka ulatwien 
/// Zmiana nazwy zmiennej 
rename pl plec
/// Utworzenie etykiety 
label define plec_lab 1 "Mezczyzna" 2 "Kobieta"
/// Nadanie etykiety wartosciom zmiennej 
label values plec plec_lab
/// Utworzenie zmiennej placa, w bazie wartosc "99999" oznacza odmowe odpowiedz 
gen placa = P37 if (P37!=99999)

/// Potrzebujemy zmiennych: plec, wyksztalcenie, placa
keep plec wyksz  placa

/// Korzystajac z odpowiednich testow, prosze sprawdzic: 

/// Czy srednia placa kobiet jest rowna sredniej placy mezczyzn 

/// Czy zroznicowanie plac kobiet jest rowne zroznicowaniu plac mezczyzn 

/// Czy rozklad plac kobiet jest rowny rozkladowi plac mezczyzn 

/// Kto jest lepiej wyksztalcony kobiety czy mezczyzni 

/// Czy zroznicowanie poziomu wyksztalcenia jest wieksze wsrod kobiet czy wsrod mezczyzn 

/// Czy rozklad wyksztalcenia kobiet jest rozkladowi wyksztalcenia mezczyzn 



/// 4. Cwiczenie **/
/// Bedziemy pracowac na danych z badania Diagnoza Spoleczna z 2011 roku 
/// Prosze sciagnac dane ze strony www.ekonometria.wne.uw.edu.pl i zaladowac zbior osob do Stata 
clear
/// Prosze zapoznac sie z zawartoscia zbioru i odpowiedziec na pytania, przeprowadzajac odpowiednie testy 
/// Potrzebne zmienne: identyfikator osoby (dla porzadku), plec, waga, wzrost,wyksztalcenie,zarobki 


/// Czy kobiety przecietnie wiecej waza od mezczyzn? 


/// Czy kobiety sa przecietnie wyzsze od mezczyzn? 


/// Czy kobiety sa lepiej wyksztalcone od mezczyzn? 


/// Czy wsrod osob o wyzszym wyksztalceniu kobiety przecietnie wiecej waza od mezczyzn? 


/// Czy wsrod osob o wyzszym wyksztalceniu przecietnie wyzsze od mezczyzn? 


/// Czy wsrod osob o wyzszym wyksztalceniu kobiety wiecej zarabiaja od mezczyzn? 
