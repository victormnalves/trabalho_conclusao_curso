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


*/
do "$Dofiles/dados_EM_v1.do"
