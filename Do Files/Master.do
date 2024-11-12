clear all

global user "`:environment USERPROFILE'"
global Folder "$user/OneDrive/EESP_ECONOMIA_mestrado_acadêmico/Dissertação/ICE/dados_ICE/Análise_Leonardo"
global output "$Folder/resultados"
global Bases "$Folder/Bases"
global Dofiles "$Folder/Do-files"

/*
|---------------------------------------------------------------------------|
|                          Construição da  Base                             |
|---------------------------------------------------------------------------|
*/
*incompleto, as bases dos microdados agregados não estão disponíveis
*supostamente se encontram numa pasta chamada Dados Importados
*paralelamente, estou criando essas bases diretamente dos microdados 

/*
do-file que, a partir das bases dos microdados agregados do ENEM, SAEB/PB, 
CENSO ESCOLAR, e das bases sobre o programa - orginal e alavancas -, cria a
base final usada para analise sobre as notas, o ice_clean.dta
*/

*do "$Dofiles/base.do"
*do "$Dofiles/base13.do"  *caso esteja usando stata13

/*
do-file que, a partir das bases dos microdados agregados do ENEM, SAEB/PB, 
CENSO ESCOLAR, e das bases sobre o programa - orginal e alavancas -, cria a
base final usada para analise sobre fluxo, o ice_clean_fluxo.dta
*/

*do "$Dofiles/base_fluxo.do"
*do "$Dofiles/base_fluxo13.do" *caso esteja usando stata13


/*
Assim, sem a pasta Dados Importados, vamos prosseguir diretamenete com
as bases prontas disponibilizadas
*/

/*PARA AS ETAPAS ABAIXO, NECESSÁRIO DELETAR OS XLSX DA PASTA RESULTADO
, POIS O COMANDO OUTREG VAI ADICIONANDO LINHAS NAS TABELAS DOS ARQUIVOS,
SE TAIS ARQUIVOS JÁ EXISTIREM*/
/*
|---------------------------------------------------------------------------|
|                  Ensino Médio - notas do ENEM                             |
|---------------------------------------------------------------------------|
*/

/*
Do-file que, usando a base ice_clean.dta, executa os seguintes passos:
1.a cria os propensity scores
1.b cria as dummies de interações turno e alavanca
1.c padroniza as notas
1.d estima os resultados gerais nas notas do enem
1.e estima por estados
1.f estima os resultaods cumulativos nas notas do enem
*/

do "$Dofiles/em_enem_notas.do"

*do "$Dofiles/em_enem_notas13.do" *caso stata13

/*
|---------------------------------------------------------------------------|
|                       Ensino Médio - Fluxo                                |
|---------------------------------------------------------------------------|
*/

/*
Do-file que, usando a base ice_clean.dta, executa os seguintes passos:
1.a cria os propensity scores
1.b cria as dummies de interações turno e alavanca
1.c padroniza as notas
1.d estima os resultados gerais nas notas do enem
1.e estima por estados
1.f estima os resultaods cumulativos nas notas do enem
*/

do "$Dofiles/em_fluxo.do"

*do "$Dofiles/em_fluxo13.do" *caso stata13

/*
|---------------------------------------------------------------------------|
|                       Ensino Fundamental - PB/SAEB                        |
|---------------------------------------------------------------------------|
*/

/*
Do-file que, usando a base ice_clean_fluxo.dta, executa os seguintes passos:
1.a cria os propensity scores
1.b cria as dummies de interações turno e alavanca
1.c padroniza as notas
1.d estima os resultados gerais nas notas do pb/saeb
1.e estima por estados
1.f estima os resultaods cumulativos nas notas do pb/saeb
*/

do "$Dofiles/ef_pbsaeb.do"

*do "$Dofiles/em_fluxo13.do" *caso stata13

do "$Dofiles/ef_pbsaeb_estado.do"

*do "$Dofiles/em_fluxo_estado13.do" *caso stata13


/*
|---------------------------------------------------------------------------|
|                                Spillover                                  |
|---------------------------------------------------------------------------|
*/

/*

*/

do "Dofiles/spillover.do"



/*
|---------------------------------------------------------------------------|
|                             Spillover Fluxo                               |
|---------------------------------------------------------------------------|
*/

/*

*/

do "Dofiles/spillover_fluxo.do"


