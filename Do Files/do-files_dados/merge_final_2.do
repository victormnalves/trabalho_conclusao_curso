/*************************** Base Final - Alternativo *******************************/
/*
mergeando as bases
censo escolar, 
Saeb, 
Prova Brasil, 
Mais educação,
Indicadores do INEP, 
ICE

segundo método, similar a análise anterior
*/


clear all
set more off, permanently

capture log close
global user "`:environment USERPROFILE'"
*global Folder "$user/OneDrive/EESP_ECONOMIA_mestrado_acadêmico/Dissertação/ICE/dados_ICE/Análise_Leonardo"
global Folder "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo"
global output "$Folder/resultados"
global Bases "$Folder/Bases"
global dofiles "$Folder/Do-Files"
global Logfolder "$Folder/Log"
log using "$Logfolder/new_merge.log", replace



use "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\enem\enem_todos_1.dta", clear
merge 1:1 codigo_escola ano using "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\saeb_prova_brasil\saeb_todos_1.dta"
drop _m
merge 1:1 codigo_escola ano using "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\saeb_prova_brasil\provabrasil_todos_1.dta"
drop _m
merge 1:1 codigo_escola ano using "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\indicadores_inep\fluxo_2007a2015.dta"
drop _m

drop if codigo_escola==.
save "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\aux_enem_saeb_provabrasil.dta", replace


use "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\aux_enem_saeb_provabrasil.dta"
merge 1:1 codigo_escola ano using "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\censo_escolar\censo_escolar_PE_1.dta"
drop if _m==1
drop _m
save "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\aux_enem_saeb_provabrasil_censo_pe.dta", replace

use "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\aux_enem_saeb_provabrasil.dta"
merge 1:1 codigo_escola ano using "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\censo_escolar\censo_escolar_CE_1.dta"
drop if _m==1
drop _m
save "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\aux_enem_saeb_provabrasil_censo_ce.dta", replace

use "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\aux_enem_saeb_provabrasil.dta"
merge 1:1 codigo_escola ano using "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\censo_escolar\censo_escolar_RJ_1.dta"
drop if _m==1
drop _m
save "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\aux_enem_saeb_provabrasil_censo_rj.dta", replace

use "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\aux_enem_saeb_provabrasil.dta"
merge 1:1 codigo_escola ano using "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\censo_escolar\censo_escolar_SP_1.dta"
drop if _m==1
drop _m
save "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\aux_enem_saeb_provabrasil_censo_sp.dta", replace

use "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\aux_enem_saeb_provabrasil.dta"
merge 1:1 codigo_escola ano using "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\censo_escolar\censo_escolar_GO_1.dta"
drop if _m==1
drop _m
save "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\aux_enem_saeb_provabrasil_censo_go.dta", replace

use "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\aux_enem_saeb_provabrasil.dta"
merge 1:1 codigo_escola ano using "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\censo_escolar\censo_escolar_ES_1.dta"
drop if _m==1
drop _m
save "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\aux_enem_saeb_provabrasil_censo_es.dta", replace

