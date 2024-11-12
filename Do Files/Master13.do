clear all
set more off
set trace on
global user "`:environment USERPROFILE'"
global Folder "$user/OneDrive/EESP_ECONOMIA_mestrado_acad�mico/Disserta��o/ICE/dados_ICE/An�lise_Leonardo"
global output "$Folder/resultados"
global Bases "$Folder/Bases"
global Dofiles "$Folder/Do-files"

cd "$Folder"
log using mylog.txt
/*
|---------------------------------------------------------------------------|
|                          Construi��o da  Base                             |
|---------------------------------------------------------------------------|
*/

/*
do-file que, a partir das bases dos microdados agregados do ENEM, SAEB/PB, 
CENSO ESCOLAR, das informa��es sobre o programa MAIS EDUCA��O, 
dos indicadores do inep e das bases sobre o programa - orginal e alavancas -, 
e cria a base final usada para analise sobre as notas, o ice_clean.dta
*/

*do "$Dofiles/base.do"
*do "$Dofiles/base13.do"  *caso esteja usando stata13

/*
na an�lise anterior, foi discriminada a base original da base para 
os vasos de vari�veis de fluxo.
*/

*do "$Dofiles/base_fluxo.do"
*do "$Dofiles/base_fluxo13.do" *caso esteja usando stata13


/*PARA AS ETAPAS ABAIXO, NECESS�RIO DELETAR OS XLSX DA PASTA RESULTADO
, POIS O COMANDO OUTREG VAI ADICIONANDO LINHAS NAS TABELAS DOS ARQUIVOS,
SE TAIS ARQUIVOS J� EXISTIREM*/


/*
|---------------------------------------------------------------------------|
|                  Ensino M�dio - ENEM e fluxo                            |
|---------------------------------------------------------------------------|
*/
/*
do-file: usando a base no ice_clean.dta, gera os pscores, gera as dummies
de intera��o de turno e alavanca, gera notas padronizadas, e faz as estima��es:
	


 */
do "$Dofiles/em_enem.do"




/*
|---------------------------------------------------------------------------|
|                       Ensino Fundamental - PB/SAEB                        |
|---------------------------------------------------------------------------|
*/

do "$Dofiles/ef_pbsaeb.do"



/*
|---------------------------------------------------------------------------|
|                                Spillover                                  |
|---------------------------------------------------------------------------|
*/



do "Dofiles/spillover.do"



/*

