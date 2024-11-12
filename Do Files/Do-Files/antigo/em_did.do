*estatisticas descritivas e balanceamento

capture log close

clear all
set more off

*cd "`:environment USERPROFILE'\OneDrive\EESP - ECONOMIA - mestrado acadêmico\Dissertação\ICE\dados ICE"
global user "`:environment USERPROFILE'"
*global Folder "$user/OneDrive/EESP_ECONOMIA_mestrado_acadêmico/Dissertação/ICE/dados_ICE/Análise_Leonardo"
/*
global Folder "D:\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo"
global output "$Folder/resultados"
global Bases "$folderservidor"
global dofiles "$Folder/Do-Files"
global Logfolder "$Folder/Log"
*/
global Folder "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"
global output "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\resultados_v3"
global Bases "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"
global dofiles "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\Do-Files"
global Logfolder "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\logfiles"


global folderservidor "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"

log using "$Logfolder/em_assessing_balance.log", replace
use "$folderservidor\em_com_censo_escolar_14.dta", clear

local estado d_uf*


local alavancas_fluxo d_ice_fluxo_al1 d_ice_fluxo_al2 d_ice_fluxo_al3 d_ice_fluxo_al4 d_ice_fluxo_al5 d_ice_fluxo_al6 d_ice_fluxo_al7 d_ice_fluxo_al8 
local alavancas_fluxo_todas d_ice_fluxo_al1 d_ice_fluxo_al2 d_ice_fluxo_al3 d_ice_fluxo_al4 d_ice_fluxo_al5 d_ice_fluxo_al6 d_ice_fluxo_al7 d_ice_fluxo_al8 d_ice_fluxo_al9
local alavancas_nota d_ice_nota_al1 d_ice_nota_al2 d_ice_nota_al3 d_ice_nota_al4 d_ice_nota_al5 d_ice_nota_al6 d_ice_nota_al7 d_ice_nota_al8 
local alavancas_nota_todas d_ice_nota_al1 d_ice_nota_al2 d_ice_nota_al3 d_ice_nota_al4 d_ice_nota_al5 d_ice_nota_al6 d_ice_nota_al7 d_ice_nota_al8 d_ice_nota_al9

local controles  concluir_em_ano_enem e_mora_mais_de_6_pessoas e_escol_sup_pai	///
	e_escol_sup_mae e_renda_familia_5_salarios e_trabalhou_ou_procurou predio 	///
	diretoria sala_professores lab_info lab_ciencias quadra_esportes internet 	///
	rural lixo_coleta eletricidade agua esgoto n_salas_utilizadas				///
	n_alunos_em_ep pib_capita_reais_real_2015 pop mais_educ

keep `estado' `alavancas_fluxo' `alavancas_fluxo_todas' `alavancas_nota_todas' ///
`controles' ///
ice ice_inte codigo_escola ano ano_ice taxa_participacao_enem ///
codigo_uf dep cod_meso /// 
apr_em_std rep_em_std aba_em_std dist_em_std ///
enem_nota_matematica_std  enem_nota_ciencias_std /// 
enem_nota_humanas_std enem_nota_linguagens_std  ///
enem_nota_redacao_std enem_nota_objetivab_std  ///
d_ice_nota d_ano* d_ice_nota_semi_inte  d_ice_nota_inte ///
d_ice_fluxo* d_ice_fluxo_semi_inte  d_ice_fluxo_inte ///

local outcomes apr_em_std rep_em_std aba_em_std dist_em_std ///
enem_nota_matematica_std  enem_nota_ciencias_std /// 
enem_nota_humanas_std enem_nota_linguagens_std  ///
enem_nota_redacao_std enem_nota_objetivab_std  ///



local controles  concluir_em_ano_enem e_mora_mais_de_6_pessoas e_escol_sup_pai	///
	e_escol_sup_mae e_renda_familia_5_salarios e_trabalhou_ou_procurou predio 	///
	diretoria sala_professores lab_info lab_ciencias quadra_esportes internet 	///
	rural lixo_coleta eletricidade agua esgoto n_salas_utilizadas				///
	n_alunos_em_ep pib_capita_reais_real_2015 pop mais_educ
	
	
gen tempo=.
/*
replace tempo=0 if ano==ano_ice-6
replace tempo=1 if ano==ano_ice-5
*/

replace tempo=0 if ano==ano_ice-3 
replace tempo=1 if ano==ano_ice-2
replace tempo=2 if ano==ano_ice-1
replace tempo=3 if ano==ano_ice
replace tempo=4 if ano==ano_ice+1 
replace tempo=5 if ano==ano_ice+2
replace tempo=6 if ano==ano_ice+3
/*
replace tempo=10 if ano==ano_ice+4
replace tempo=11 if ano==ano_ice+5
replace tempo=12 if ano==ano_ice+6
*/


tab tempo, gen(d_tempo)
/*
gen d_ice_nota_pre6=ice*d_tempo1
gen d_ice_nota_pre5=ice*d_tempo2
gen d_ice_nota_pre4=ice*d_tempo3
gen d_ice_nota_pre3=ice*d_tempo4
gen d_ice_nota_pre2=ice*d_tempo5
gen d_ice_nota_pre1=ice*d_tempo6
*/
gen d_ice_nota_inicio=d_ice_nota*d_tempo3
/*
gen d_ice_nota_pos1=d_ice_nota*d_tempo8
gen d_ice_nota_pos2=d_ice_nota*d_tempo9
gen d_ice_nota_pos3=d_ice_nota*d_tempo10
gen d_ice_nota_pos4=d_ice_nota*d_tempo11
gen d_ice_nota_pos5=d_ice_nota*d_tempo12
gen d_ice_nota_pos6=d_ice_nota*d_tempo13


gen d_ice_nota_inte_pre6=ice_inte*d_tempo1
gen d_ice_nota_inte_pre5=ice_inte*d_tempo2
gen d_ice_nota_inte_pre4=ice_inte*d_tempo3
gen d_ice_nota_inte_pre3=ice_inte*d_tempo4
gen d_ice_nota_inte_pre2=ice_inte*d_tempo5
gen d_ice_nota_inte_pre1=ice_inte*d_tempo6
*/
gen d_ice_nota_inte_inicio=d_ice_nota_inte*d_tempo3
/*
gen d_ice_nota_inte_pos1=d_ice_nota_inte*d_tempo8
gen d_ice_nota_inte_pos2=d_ice_nota_inte*d_tempo9
gen d_ice_nota_inte_pos3=d_ice_nota_inte*d_tempo10
gen d_ice_nota_inte_pos4=d_ice_nota_inte*d_tempo11
gen d_ice_nota_inte_pos5=d_ice_nota_inte*d_tempo12
gen d_ice_nota_inte_pos6=d_ice_nota_inte*d_tempo13


gen d_ice_fluxo_pre6=ice*d_tempo1
gen d_ice_fluxo_pre5=ice*d_tempo2
gen d_ice_fluxo_pre4=ice*d_tempo3
gen d_ice_fluxo_pre3=ice*d_tempo4
gen d_ice_fluxo_pre2=ice*d_tempo5
gen d_ice_fluxo_pre1=ice*d_tempo6
*/
gen d_ice_fluxo_inicio=d_ice_fluxo*d_tempo3
/*
gen d_ice_fluxo_pos1=d_ice_fluxo*d_tempo8
gen d_ice_fluxo_pos2=d_ice_fluxo*d_tempo9
gen d_ice_fluxo_pos3=d_ice_fluxo*d_tempo10
gen d_ice_fluxo_pos4=d_ice_fluxo*d_tempo11
gen d_ice_fluxo_pos5=d_ice_fluxo*d_tempo12



gen d_ice_fluxo_inte_pre6=ice_inte*d_tempo1
gen d_ice_fluxo_inte_pre5=ice_inte*d_tempo2
gen d_ice_fluxo_inte_pre4=ice_inte*d_tempo3
gen d_ice_fluxo_inte_pre3=ice_inte*d_tempo4
gen d_ice_fluxo_inte_pre2=ice_inte*d_tempo5
gen d_ice_fluxo_inte_pre1=ice_inte*d_tempo6
gen d_ice_fluxo_inte_inicio=d_ice_fluxo_inte*d_tempo7
gen d_ice_fluxo_inte_pos1=d_ice_fluxo_inte*d_tempo8
gen d_ice_fluxo_inte_pos2=d_ice_fluxo_inte*d_tempo9
gen d_ice_fluxo_inte_pos3=d_ice_fluxo_inte*d_tempo10
gen d_ice_fluxo_inte_pos4=d_ice_fluxo_inte*d_tempo11
gen d_ice_fluxo_inte_pos5=d_ice_fluxo_inte*d_tempo12
*/
drop if tempo ==.
iis codigo_escol
tis ano

iis codigo_escol
tis ano

set trace off

tsset codigo_escola ano
ddid apr_em_std d_ice_nota  d_ano* `controles' taxa_participacao_enem, model(fe) pre(3) post(3) vce(robust) graph test_tt



/*tsset id time
xi: ddid y D x , model(fe) pre(6) post(6) vce(robust) graph test_tt*/
