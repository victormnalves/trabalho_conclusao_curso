/*	ice base inicial alavancas	*/
capture log close
clear all
set more off
set trace on

global user "`:environment USERPROFILE'"

global Folder "$user/\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo"
global Logfolder "$Folder/Log"

log using "$Logfolder/base_ice_alavancas.log", replace


use "E:\bases_dta\ice_dados\base_final_ice_fluxo", clear
* 737 observações totais
* 9 observações estão somente na base de alavancas
* 95 observações estão somente na base inicial do ice

keep if _m==3
* 104 observations deleted

save "E:\bases_dta\ice_dados\base_final_ice_fluxo_alavancas.dta", replace
save "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\ice_dados\base_final_ice_fluxo_alavancas.dta", replace


use "E:\bases_dta\ice_dados\base_final_ice_nota", clear

keep if _m==3
* 104 observations deleted
save "E:\bases_dta\ice_dados\base_final_ice_nota_alavancas.dta", replace
save "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\ice_dados\base_final_ice_nota_alavancas.dta", replace

log close
