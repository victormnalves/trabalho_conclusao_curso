sysdir set PLUS \\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\ado
clear all 
set more off, permanently
capture log close

global folderservidor "\\fs-essp-01\EESP\Usuarios\leonardo.kawahara"
global Dofiles "\\tsclient\C\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\do-files_dados"


/*
|-------------------------------------------------------------------------|
|                          Construição da Base                            |
|-------------------------------------------------------------------------|
*/

/*
do-file que agrega as bases SAEB/PB, censo escolar, indicadores de 
fluxo, pib per capita. Em seguida, exclui variáveis desnecessárias e
cria novas, agrega a base de informações do programa, realiza o pca
cria dummies e interações resultando no arquivo dados_EF_14_v1.dta

*/
do "$Dofiles/dados_EF_v2.do"



/*
|-------------------------------------------------------------------------|
|                          Propensity Score	                              |
|-------------------------------------------------------------------------|
*/
