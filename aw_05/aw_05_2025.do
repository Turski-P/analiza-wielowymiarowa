/***********************************************************/
/****            Analiza Wielowymiarowa                 ****/
/****                  zajecia 05                       ****/
/**** Skalowanie wielowymiarowe i obserwacje nietypowe  ****/
/***********************************************************/ 

/// SKALOWANIE WIELOWYMIAROWE

/// Dane i przyklad zostaly pozyczone z podrecznika Stata MV

/// Zaladowanie danych z internetu. Jezeli nie dziala, zbior danych jest w materialach do zajec
/// Dane dotycza charakterystyk odzywczych platkow sniadanowych
use https://www.stata-press.com/data/r17/cerealnut
des

/// Podstawowy opis statystyczny cech charakterystycznych płatkow sniadaniowych
summarize calories-K, sep(4)

/// Zastepujemy odstepy w nazwach znakiem podreslenia dla czytelnosci wykresow
replace brand = subinstr(brand," ","_",.)

/// Polecenie mds wykonuje skalowanie wielowymiarowe na podstawie podanych charakterystyk opcja "id" jest niezbedna, identyfikuje obserwacje
mds calories-K, id(brand)

/// Dwie pierwsze wartosci wlasne wyjasniaja 99,7% niepodobienstwa
mds calories-K, id(brand) std
/// opcja "std" przed wykonaniem obliczen standaryzuje wartosci charakterystyk

/// OBSERWACJE NIETYPOWE

******************************************************
* Analiza obserwacji nietypowych (outliers)
* przy użyciu Pythona w środowisku Stata
******************************************************

/// Wczytanie danych do pakietu Stata; 
cd // tu nazwa katalogu w którym są dane boston.dta
use boston.dta, clear
export delimited using "boston.csv", replace

/// Uruchomienie sekcji Python
/// Uwaga kod python trzeba wywolac w calosci od znacznika "python:" do znacznika "end"

python:

import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from scipy.stats import chi2
import scipy as sp

# Wczytanie danych Boston z biblioteki sklearn

df = pd.read_csv('boston.csv')

# Zmienna zależna
y = df['MEDV']

# Wybrane zmienne
df_all = df[['CRIM', 'ZN', 'INDUS', 'CHAS','NOX','RM', 'AGE', 'DIS', 'RAD', 'TAX', 'PTRATIO', 'B', 'LSTAT']]

# Podziały danych
df_1 = df_all[['TAX', 'B']]
df_2 = df_all[['CRIM', 'ZN', 'INDUS', 'RM', 'AGE', 'DIS', 'RAD', 'PTRATIO','LSTAT']]
df_3 = df_all[['CHAS', 'NOX']]

# Wizualizacje
sns.boxplot(data=df_2, orient="h", palette="Set2")
plt.title("Boxplot dla wybranych zmiennych")
plt.show()

sns.boxplot(x=df_all["CRIM"])
plt.xlabel('Crime rate per capita')
plt.title("Boxplot dla CRIM")
plt.show()

# Wykres rozrzutu
sns.scatterplot(x="LSTAT", y="CRIM", data=df_all)
plt.title("Zależność między LSTAT a CRIM")
plt.show()

# ----------------------------------------------------
# Funkcja do wyznaczania odległości Mahalanobisa
# ----------------------------------------------------
def mahalanobis_method(df):
    x_minus_mu = df - np.mean(df, axis=0)
    cov = np.cov(df.values.T)
    inv_covmat = sp.linalg.inv(cov)
    left_term = np.dot(x_minus_mu, inv_covmat)
    mahal = np.dot(left_term, x_minus_mu.T)
    md = np.sqrt(mahal.diagonal())

    # Wyznacz próg
    C = np.sqrt(chi2.ppf((1-0.001), df=df.shape[1]))
    outlier = [i for i, val in enumerate(md) if val > C]

    return outlier, md

# Obserwacje odstające w 2D (LSTAT, CRIM)
df_bivariate = df_all[['LSTAT', 'CRIM']]
outliers_mahal_bi, md_bi = mahalanobis_method(df_bivariate)
print("Obserwacje odstające (2D):", outliers_mahal_bi)

# Obserwacje odstające dla wszystkich zmiennych
outliers_mahal, md = mahalanobis_method(df_all)
print("Obserwacje odstające (wielowymiarowe):", outliers_mahal)

end

/// Przekazanie wyników z Pythona do Stata
python:
# Możesz zapisać indeksy outlierów do pliku CSV, by wczytać je do Stata
outliers_df = pd.DataFrame({'outlier_index': outliers_mahal})
outliers_df.to_csv("outliers_mahal.csv", index=False)
end

/// Wczytanie wynikow z Pythona do Stata
import delimited "outliers_mahal.csv", clear
list

