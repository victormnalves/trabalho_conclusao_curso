/*******************************Append**************************************/


clear all
global user "`:environment USERPROFILE'"
*global dropbox "$user/Dropbox"
global dropboxA "$user/dropbox gmail/Dropbox"
global onedrive "$user/OneDrive"
clear
set more off

use "E:\bases_dta\saeb_prova_brasil\2003\saeb2003.dta", clear
append using "E:\bases_dta\saeb_prova_brasil\2005\saeb2005.dta"
destring codigo_escola, replace
append using "E:\bases_dta\saeb_prova_brasil\2011\saeb2011.dta"
append using "E:\bases_dta\saeb_prova_brasil\2013\saeb2013.dta"
append using "E:\bases_dta\saeb_prova_brasil\2015\saeb2015.dta"
gen ano = ano_saeb 
drop _m
drop if codigo_escola==.
save "E:\bases_dta\saeb_prova_brasil\saeb_todos.dta", replace
save "$onedrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\PROVA_BRASIL_SAEB\saeb_todos.dta", replace
