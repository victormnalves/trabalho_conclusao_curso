/*		           Ensino M�dio - Alavancas                                 */

/*

estima��o do efeito em nota e em fluxo, usando as vari�veis de alavanca.
note que
*/
capture log close

clear all
set more off

*cd "`:environment USERPROFILE'\OneDrive\EESP - ECONOMIA - mestrado acad�mico\Disserta��o\ICE\dados ICE"
global user "`:environment USERPROFILE'"
*global Folder "$user/OneDrive/EESP_ECONOMIA_mestrado_acad�mico/Disserta��o/ICE/dados_ICE/An�lise_Leonardo"
global Folder "D:\OneDrive\EESP_ECONOMIA_mestrado_acad�mico\Disserta��o\ICE\dados_ICE\An�lise_Leonardo"
global output "$Folder/resultados"
global Bases "$Folder/Bases"
global dofiles "$Folder/Do-Files"
global Logfolder "$Folder/Log"

log using "$Logfolder/em_alavancas.log", replace

/*                                  NOTAS                                 */
