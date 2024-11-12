/******************************  ICE Alavancas  ******************************/
clear all
set more off
set trace on


import excel "E:\ICE\Base_geral_escolas_alavancas.xlsx", sheet("Plan1") firstrow

rename UF uf
rename MUNICPIO nome_municipio
rename ESCOLA nome_escola
rename Ano ano_ice
rename CdigoINEP codigo_escola
rename BomengajamentodoGovernador al_engaj_gov
rename Bomengajamentodosecretriode al_engaj_sec
rename TimedaSEDUCdedicadoparaimpl al_time_seduc
rename Implantaodosmarcoslegaisna al_marcos_lei
rename Implantaodetodososmarcosl al_todos_marcos
rename Implantaodoprocessodesele al_sel_dir
rename L al_sel_prof
rename Implantaodoprojetodevidan al_proj_vida

* atribuindo 1 a sim e 0 a não para os valores das variáveis dummies
foreach x of varlist al_engaj_gov al_engaj_sec al_time_seduc al_marcos_lei al_todos_marcos al_sel_dir al_sel_prof al_proj_vida {
replace `x'="1" if `x'=="SIM"
replace `x'="0" if `x'=="NAO"
replace `x'="0" if `x'=="NÃO"
}
*destring as variáveis dummy
destring al_engaj_gov al_engaj_sec al_time_seduc al_marcos_lei al_todos_marcos al_sel_dir al_sel_prof al_proj_vida, replace


format codigo_escola %16.0f

*imputando o codigo da escola correto para a escola Lourenço filho
replace codigo_escola = 35003980 if nome_escola=="LOURENCO FILHO"



*corrigindo número inep da escola genesio boamorte
replace codigo_escola = 35034472 if nome_escola == "GENESIO BOAMORTE"


*na base original já temos o ano de entrada da escola


drop ano_ice
save "E:\bases_dta\ice_dados\ice_alavancas.dta", replace
save "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\ice_dados\ice_alavancas.dta", replace

use"E:\bases_dta\ice_dados\ice_alavancas.dta", clear

*merge com a base inicial do ice
merge 1:1 codigo_escola using "E:\bases_dta\ice_dados\ice_original_nota.dta"

save "E:\bases_dta\ice_dados\base_final_ice_nota.dta", replace
save "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\ice_dados\base_final_ice_nota.dta", replace


use"E:\bases_dta\ice_dados\ice_alavancas.dta", clear

*merge com a base inicial do ice
merge 1:1 codigo_escola using "E:\bases_dta\ice_dados\ice_original_fluxo.dta"

save "E:\bases_dta\ice_dados\base_final_ice_fluxo.dta", replace
save "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\ice_dados\base_final_ice_fluxo.dta", replace
