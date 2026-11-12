/***********************************************************/
/****            Analiza Wielowymiarowa                 ****/
/****                  zajecia 02                       ****/
/****             Statystyczne podstawy                 ****/
/***********************************************************/

/// ZMIENNE I PRZEKSZTAŁCENIA

/// ustawienie liczby obserwacji w zbiorze
set obs 1000

/// ustawienie startowej wartości generatora liczb pseudolosowych
set seed 1234

///  wylosowanie liczb losowych z rozkladu jednostajnego, opcja double nakazuje wykonanie operacji o podwojonej precyzji numeryczne
gen double u=uniform()

///  przeksztalcenie zmiennej u w zmienną o rozkladzie normalnym
gen double x1 = invnorm(u)

/// histogram
histogram x1

/// opis statystyczny zmiennej, opcja "det" nakazuje wyswietlenie szczegłowych statystyk
su x1, det
 
///  przekształcenie zmiennej u w zmienną o rozkładzie t-Studenta o 5 stopniach swobowy
gen double x2 = invt(5,u)

/// histogram, opcja "norm" nakazuje narysowanie dopasowej do danych gęstości o rozkładzie normalnym
hist x2, norm

///  szczegółowy opis statystyczny zmiennej
su x2, det

///  przekształcenie zmiennej u w zmienną o rozkładzie chi-kwadrat o 2 stopniach swobody
gen double x3 = invchi2(2,u)

/// histogram
hist x3, norm

///  szczegółowy opis statystyczny zmiennej
su x3, det

/// przekształcenie zmiennej u w zmienną o rozkładzie F o 2,10 stopniach swobody
gen double x4 = invF(2,10,u) 

/// histogram
hist x4, norm

///  szczegółowy opis statystyczny zmiennej
su x4, det

/// STATYSTYKI OPISOWE

/// Załadowanie domyślnego zbioru danych programu stata auto.dta
sysuse auto, clear

/// wartości kwartyli czyli centyli 25, 50 i 75
tabstat price, stat(q)

/// odstep miedzykwantylowy
tabstat price, stat(iqr)

/// wykres pudelkowy
/// dolna i górna krawędż pudełka to odpowiednio wartość pierwszego i trzeciego kwartyla, linia w poprzek pudełka prezentuje wartość medany, a "wasy" pokazują 95% przedział ufności
graph box price

///  histogram, opcja bin określa liczbę prostokątów, opcja freq przelicza gestosc na częstości
histogram price, bin(15)
histogram price, bin(15) freq

/// estymator jądrowy
/// o wygładzeniu rozkładu decyduje opcja "bwidth" - szerokosc pasma
kdensity price
kdensity price, bwidth(10)
kdensity price, bwidth(100)
kdensity price, bwidth(1000) 

/// Stata ma ograniczenie, pracować można wyłącznie z jedynm zbiorem danych równocześnie
/// wyczyszczenie pamieci
clear

/// zaladowanie zbioru danych auto dostarczonych z pakietem Stata
sysuse auto

/// jednowymiarowa tabela czestosci
tab foreign


