/*******************************Append**************************************/
clear all
global user "`:environment USERPROFILE'"
*global dropbox "$user/Dropbox"
global dropboxA "$user/dropbox gmail/Dropbox"
global onedrive "$user/OneDrive"
clear
set more off

use "E:\bases_dta\saeb_prova_brasil\2007\provabrasil2007.dta",clear
append using "E:\bases_dta\saeb_prova_brasil\2009\provabrasil2009.dta"
append using "E:\bases_dta\saeb_prova_brasil\2011\provabrasil2011.dta"
*rename ano ano_prova_brasil
append using "E:\bases_dta\saeb_prova_brasil\2013\provabrasil2013.dta"
append using "E:\bases_dta\saeb_prova_brasil\2015\provabrasil2015.dta"

gen ano = ano_prova_brasil

drop if codigo_escola==.
save "E:\bases_dta\saeb_prova_brasil\provabrasil_todos.dta", replace
save "$onedrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\PROVA_BRASIL_SAEB\provabrasil_todos.dta", replace
