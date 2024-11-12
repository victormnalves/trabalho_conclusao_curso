/**missings enem todos**/
clear all
capture log close
set more off, permanently
global user "`:environment USERPROFILE'"
*global Folder "$user/OneDrive/EESP_ECONOMIA_mestrado_acad�mico/Disserta��o/ICE/dados_ICE/An�lise_Leonardo"
global Folder "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acad�mico\Disserta��o\ICE\dados_ICE\An�lise_Leonardo\"
global output "$Folder/resultados"
global Bases "$Folder/Bases"
global dofiles "$Folder/Do-Files"
global Logfolder "$Folder/Log"

log using "$Logfolder/enem_missings.log", replace
cd "E:\bases_dta\enem\"


use "enem_todos.dta", clear

*use "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acad�mico\Disserta��o\ICE\dados_ICE\An�lise_Leonardo\Bases\enem\enem_todos.dta", clear

mdesc
*analisando o mdesc, podemos ver que as vari�veis com menor frequencia de
*missings s�o

* renda_familia � ok
tab ano if e_renda_familia_5_salarios !=.
tab ano if e_renda_familia_6_salarios !=.

tab ano if e_renda_familia_5_salarios ==.
tab ano if e_renda_familia_6_salarios ==.

tab ano if e_mora_mais_de_6 !=.
tab ano if e_mora_mais_de_6 ==.
tab ano if e_casa_p !=.
tab ano if e_casa_p==.
gen ano_casa = ano if e_casa_p==.
hist ano_casa, freq
*nota-se que 2015 tem alta frequencia de missings para e_casa_p
*isteo �, 2015 n�o tem essa vari�vel
drop ano_casa

tab ano if e_automovel !=.
tab ano if e_automovel==.
gen ano_auto = ano if e_automovel==.
hist ano_auto, freq
*nota-se que 2010 tem alta frquencia de missings para e_automovel
*isto �, 2010 n�o tem essa vari�vel
drop ano_auto

*escol pai e m�e � ok
tab ano if e_escol_sup_mae !=.
tab ano if e_escol_sup_mae ==.
gen ano_escolmae = ano if e_escol_sup_mae==.
hist ano_escolmae, freq
drop ano_escolmae

tab ano if e_escol_sup_pai!=.
tab ano if e_escol_sup_pai ==.
gen ano_escolpai = ano if e_escol_sup_pai==.
hist ano_escolpai, freq
*para escolaridade pai e mae, o missings est� relativamente bem distribuido entre escolar
drop ano_escolpai


*essa vari�vel s� tem a partir de 2010
tab ano if e_trabalhou !=.
tab ano if e_trabalhou ==.
gen ano_trabalho = ano if e_trabalhou==.
hist ano_trabalho, freq
drop ano_trabalho

*essa vari�vel s� tem de 2003 a 2009
tab ano if e_tem_filho !=.
tab ano if e_tem_filho ==.
gen ano_casa = ano if e_casa_p==.
hist ano_casa, freq
drop ano_casa
 
 
	tab ano if enem_nota_ob ==.
	tab ano if enem_nota_ob !=.
	tab ano if enem_nota_red ==.
	tab ano if enem_nota_red !=.
	tab ano if enem_nota_mat ==.
	tab ano if enem_nota_mat !=.
	tab ano if enem_nota_cie ==.
	tab ano if enem_nota_cie !=.
	tab ano if enem_nota_lin ==.
	tab ano if enem_nota_lin !=.
	tab ano if enem_nota_hum ==.
	tab ano if enem_nota_hum !=.
log close
