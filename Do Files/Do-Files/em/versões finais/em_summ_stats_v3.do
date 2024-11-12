/*summary statistics
em e ef
*/


sysdir set PLUS \\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\ado

capture log close
clear all
set more off, permanently

global user "`:environment USERPROFILE'"
global Folder "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"
global output "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\resultados finais"
global Bases "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"
global dofiles "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\Do-Files"
global Logfolder "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\logfiles"

global folderservidor "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"

log using "$Logfolder/em_summ_stats_v3.log", replace
use "$folderservidor\dados_EM_14_v3.dta", clear
set matsize 10000

global outcomes_em apr_em_std rep_em_std aba_em_std dist_em_std ///
	enem_nota_redacao_std enem_nota_objetivab_std  

global outcomes_em_2003	enem_nota_redacao_std enem_nota_objetivab_std  
	
global outcomes_ef apr_ef_std rep_ef_std aba_ef_std dist_ef_std ///
	media_lp_prova_brasil_9_std media_mt_prova_brasil_9_std ///
	media_pb_9_std
global controles_em  concluir_em_ano_enem e_mora_mais_de_6_pessoas e_escol_sup_pai	///
	e_escol_sup_mae e_renda_familia_5_salarios e_trabalhou_ou_procurou rural  	///
	predio diretoria sala_professores biblioteca internet lixo_coleta ///
	eletricidade agua esgoto lab_info lab_ciencias quadra_esportes  	///
	n_alunos_em_ep n_mulheres_em_ep pib_capita_reais_real_2015 pop mais_educ ///
	n_prof_em_ep n_prof_tecn n_prof_eja n_prof_em_ef_comp n_prof_em_em ///
	n_prof_em_sup p_em_superior
	
	
local estado d_uf*



global controles_ef pb_esc_sup_mae_9 pb_esc_sup_pai_9 ///
	rural  	///
	predio diretoria sala_professores biblioteca internet lixo_coleta ///
	eletricidade agua esgoto lab_info lab_ciencias quadra_esportes ///
 	n_salas_utilizadas ///
	pib_capita_reais_real_2015 pop mais_educ ///
	n_turmas_ef n_alunos_ef n_mulheres_ef n_brancos_ef ///
		n_prof_ef n_prof_em_ep n_prof_tecn n_prof_eja  ///
	n_prof_ef_todos_ef_comp n_prof_ef_todos_em ///
	n_prof_ef_todos_sup p_ef_superior

/*
alavanca 1 - teve bom engajamento do governador
alavanca 2 - teve bom engajamento do secretário de educação
alavanca 3 - tinha time da SEDUC dedicado para a implantação do programa
alavanca 4 - teve implantação dos marcos legais na forma da Lei?
alavanca 5 - teve Implantação de todos os marcos legais previstos no cronograma estipulado?
alavanca 6 - teve Implantação do processo de seleção e remoção de diretores?
alavanca 7 - teve Implantação do processo de seleção e remoção de professores?
alavanca 8 - teve Implantação do projeto de vida na Matriz Curricular?
*/
global treatement_dummy d_ice_nota d_ice_fluxo








outreg2 using "$output/em_descriptive_stats_v3.xls", replace sum(log) keep($outcomes_em $controles_em) eqkeep(N mean sd)


use "$folderservidor\dados_EM_14_v3.dta", clear
*2004 é o primeiro ano ice
keep if ano ==2004
outreg2 using "$output/em_descriptive_stats_2004_v3.xls", replace sum(log) keep($outcomes_em $controles_em d_ice_fluxo) eqkeep(N mean sd)

use "$folderservidor\dados_EM_14_v3.dta", clear
keep if ano == 2009
outreg2 using "$output/em_descriptive_stats_2009_v3.xls", replace sum(log) keep($outcomes_em $controles_em d_ice_fluxo) eqkeep(N mean sd)


use "$folderservidor\dados_EM_14_v3.dta", clear
keep if ano == 2015 
outreg2 using "$output/em_descriptive_stats_2015_v3.xls", replace sum(log) keep($outcomes_em $controles_em d_ice_fluxo) eqkeep(N mean sd)



use "$folderservidor\dados_EF_14_v3.dta", clear
outreg2 using "$output/ef_descriptive_stats_v3.xls", replace sum(log) keep($outcomes_ef $controles_ef) eqkeep(N mean sd)

*2011 é o primeiro ano do ice fundamental

use "$folderservidor\dados_EF_14_v3.dta", clear
keep if ano == 2011
outreg2 using "$output/ef_descriptive_stats_2011_v3.xls", replace sum(log) keep($outcomes_ef $controles_ef d_ice) eqkeep(N mean sd)
use "$folderservidor\dados_EF_14_v3.dta", clear
keep if ano == 2013
outreg2 using "$output/ef_descriptive_stats_2013_v3.xls", replace sum(log) keep($outcomes_ef $controles_ef d_ice) eqkeep(N mean sd)
use "$folderservidor\dados_EF_14_v3.dta", clear
keep if ano == 2015
outreg2 using "$output/ef_descriptive_stats_2015_v3.xls", replace sum(log) keep($outcomes_ef $controles_ef d_ice) eqkeep(N mean sd)


use "$folderservidor\dados_EM_14_v3.dta", clear

keep if ano == 2003
tabstat $outcomes_em $controles_em, by(ice) stat(mean sd)
eststo controle: quietly estpost summarize ///
    $outcomes_em $controles_em if ice == 0 & ano ==2003
eststo tratado: quietly estpost summarize ///
    $outcomes_em $controles_em if ice == 1 & ano ==2003
eststo diff: quietly estpost ttest ///
    enem_nota_redacao_std enem_nota_objetivab_std  $controles_em, by(ice) unequal
esttab controle tratado diff, ///
cells("mean(pattern(1 1 0) fmt(2)) sd(pattern(1 1 0)) b(star pattern(0 0 1) fmt(2)) t(pattern(0 0 1) par fmt(2))") ///
label

use "$folderservidor\dados_EM_par_nota_v3.dta", clear
keep if ano == 2003
tabstat $outcomes_em $controles_em, by(ice) stat(mean sd)
eststo controle: quietly estpost summarize ///
    $outcomes_em $controles_em if ice == 0 & ano ==2003
eststo tratado: quietly estpost summarize ///
    $outcomes_em $controles_em if ice == 1 & ano ==2003
eststo diff: quietly estpost ttest ///
    enem_nota_redacao_std enem_nota_objetivab_std   $controles_em, by(ice) unequal
esttab controle tratado diff, ///
cells("mean(pattern(1 1 0) fmt(2)) sd(pattern(1 1 0)) b(star pattern(0 0 1) fmt(2)) t(pattern(0 0 1) par fmt(2))") ///
label


use "$folderservidor\dados_EF_14_v3.dta", clear

keep if ano == 2011
tabstat 	$outcomes_ef $controles_ef, by(ice) stat(mean sd)
eststo controle: quietly estpost summarize ///
    $outcomes_ef $controles_ef if ice == 0 & ano ==2011
eststo tratado: quietly estpost summarize ///
    $outcomes_ef $controles_ef if ice == 1 & ano ==2011
eststo diff: quietly estpost ttest ///
    $outcomes_ef $controles_ef, by(ice) unequal
esttab controle tratado diff, ///
cells("mean(pattern(1 1 0) fmt(2)) sd(pattern(1 1 0)) b(star pattern(0 0 1) fmt(2)) t(pattern(0 0 1) par fmt(2))") ///
label

use "$folderservidor\dados_EF_par_v3.dta", clear
keep if ano == 2011
tabstat $outcomes_ef $controles_ef, by(ice) stat(mean sd)
eststo controle: quietly estpost summarize ///
    $outcomes_ef $controles_ef if ice == 0 & ano ==2011
eststo tratado: quietly estpost summarize ///
    $outcomes_ef $controles_ef if ice == 1 & ano ==2011
eststo diff: quietly estpost ttest ///
    $outcomes_ef $controles_ef, by(ice) unequal
esttab controle tratado diff, ///
cells("mean(pattern(1 1 0) fmt(2)) sd(pattern(1 1 0)) b(star pattern(0 0 1) fmt(2)) t(pattern(0 0 1) par fmt(2))") ///
label


use "$folderservidor\dados_EF_14_v3.dta", clear

keep if ano == 2007
tabstat media_lp_prova_brasil_9_std media_mt_prova_brasil_9_std $controles_ef, by(ice) stat(mean sd)
eststo controle: quietly estpost summarize ///
    media_lp_prova_brasil_9_std media_mt_prova_brasil_9_std $controles_ef if ice == 0 & ano ==2007
eststo tratado: quietly estpost summarize ///
    media_lp_prova_brasil_9_std media_mt_prova_brasil_9_std $controles_ef if ice == 1 & ano ==2007
eststo diff: quietly estpost ttest ///
    media_lp_prova_brasil_9_std media_mt_prova_brasil_9_std $controles_ef, by(ice) unequal
esttab controle tratado diff, ///
cells("mean(pattern(1 1 0) fmt(2)) sd(pattern(1 1 0)) b(star pattern(0 0 1) fmt(2)) t(pattern(0 0 1) par fmt(2))") ///
label

use "$folderservidor\dados_EF_par_v3.dta", clear
keep if ano == 2007
tabstat media_lp_prova_brasil_9_std media_mt_prova_brasil_9_std $controles_ef, by(ice) stat(mean sd)
eststo controle: quietly estpost summarize ///
    media_lp_prova_brasil_9_std media_mt_prova_brasil_9_std $controles_ef if ice == 0 & ano ==2007
eststo tratado: quietly estpost summarize ///
    media_lp_prova_brasil_9_std media_mt_prova_brasil_9_std $controles_ef if ice == 1 & ano ==2007
eststo diff: quietly estpost ttest ///
    media_lp_prova_brasil_9_std media_mt_prova_brasil_9_std $controles_ef, by(ice) unequal
esttab controle tratado diff, ///
cells("mean(pattern(1 1 0) fmt(2)) sd(pattern(1 1 0)) b(star pattern(0 0 1) fmt(2)) t(pattern(0 0 1) par fmt(2))") ///
label





forvalues  a = 2003(1)2015{


use "$folderservidor\dados_EM_14_v3.dta", clear

keep if ano ==`a'
outreg2 using "$output/em_descriptive_stats_all_v3.xls", append sum(log) keep($outcomes_em $controles_em d_ice_fluxo) eqkeep(N mean sd)



}


use "$folderservidor\dados_EM_cidades_v3.dta", clear
global controles_cid  concluir_em_ano_enem e_mora_mais_de_6_pessoas e_escol_sup_pai	///
	e_escol_sup_mae e_renda_familia_5_salarios e_trabalhou_ou_procurou predio 	///
	diretoria sala_professores lab_info lab_ciencias quadra_esportes internet 	///
	rural lixo_coleta eletricidade agua esgoto 				///
	n_alunos_em_ep n_mulheres_em_ep taxa_participacao_enem pib_capita_reais_real_2015 pop mais_educ ///
	n_prof_em_ep n_prof_tecn n_prof_eja n_prof_em_ef_comp n_prof_em_em ///
	n_prof_em_sup p_em_superior ///
	numero_escolas_por_cidade

global outcomes_em apr_em_std rep_em_std aba_em_std dist_em_std ///
	enem_nota_redacao_std enem_nota_objetivab_std  
keep if ano ==2003 
count if m_teve_ice


use "$folderservidor\dados_EM_cidades_v3.dta", clear
outreg2 using "$output/em_descriptive_stats_cid_v3.xls", replace sum(log) keep($outcomes_em $controles_cid) eqkeep(N mean sd)
keep if ano == 2004
tabstat $outcomes_em $controles_em, by(m_teve_ice) stat(mean sd)
eststo controle: quietly estpost summarize ///
    $outcomes_em $controles_em if m_teve_ice == 0 & ano ==2004
eststo tratado: quietly estpost summarize ///
    $outcomes_em $controles_em if m_teve_ice == 1 & ano ==2004
eststo diff: quietly estpost ttest ///
    enem_nota_redacao_std enem_nota_objetivab_std  $controles_em, by(m_teve_ice) unequal
esttab controle tratado diff, ///
cells("mean(pattern(1 1 0) fmt(2)) sd(pattern(1 1 0)) b(star pattern(0 0 1) fmt(2)) t(pattern(0 0 1) par fmt(2))") ///
label
count if m_teve_ice == 1


use "$folderservidor\EM_cidades_matched_v3.dta", clear

keep if ano == 2004
tabstat  enem_nota_redacao_std enem_nota_objetivab_std $controles_cid, by(m_teve_ice) stat(mean sd)
eststo controle: quietly estpost summarize ///
     enem_nota_redacao_std enem_nota_objetivab_std $controles_cid if m_teve_ice == 0 & ano ==2004
eststo tratado: quietly estpost summarize ///
     enem_nota_redacao_std enem_nota_objetivab_std $controles_cid if m_teve_ice == 1 & ano ==2004
eststo diff: quietly estpost ttest ///
    enem_nota_redacao_std enem_nota_objetivab_std $controles_cid, by(m_teve_ice) unequal
esttab controle tratado diff, ///
cells("mean(pattern(1 1 0) fmt(2)) sd(pattern(1 1 0)) b(star pattern(0 0 1) fmt(2)) t(pattern(0 0 1) par fmt(2))") ///
label
count if m_teve_ice == 1




use "$folderservidor\dados_EM_14_v3.dta", clear



summ enem_nota_objetivab if ano ==2013
summ enem_nota_objetivab if ano ==2013 & d_ice_nota==1

summ enem_nota_redacao if ano ==2013

summ enem_nota_redacao if ano ==2013 & d_ice_nota ==1

summ n_alunos_em_ep if ano==2010
summ apr_em if ano == 2010 
summ apr_em if ano == 2010  & d_ice_nota==1
summ rep_em if ano == 2010 
summ rep_em if ano == 2010  & d_ice_nota==1
summ aba_em if ano == 2010 
summ aba_em if ano == 2010  & d_ice_nota==1
summ dist_em if ano == 2010 
summ dist_em if ano == 2010  & d_ice_nota==1


    

summ e_mora_mais_de_6_pessoas if ano==2010
summ concluir_em_ano_enem if ano==2010
summ e_escol_sup_pai if ano==2010
summ e_escol_sup_mae if ano==2010
summ e_renda_familia_5_salarios if ano==2010
summ e_trabalhou_ou_procurou if ano==2010
 




use "$folderservidor\dados_EF_14_v3.dta", clear

summ media_lp_prova_brasil_9 if ano ==2013
summ media_lp_prova_brasil_9 if ano ==2013 & d_ice==1

summ media_mt_prova_brasil_9 if ano ==2013

summ media_mt_prova_brasil_9 if ano ==2013 & d_ice==1

summ n_alunos_ef if ano==2013
summ apr_ef if ano == 2013 
summ apr_ef if ano == 2013  & d_ice==1
summ rep_ef if ano == 2013 
summ rep_ef if ano == 2013  & d_ice==1
summ aba_ef if ano == 2013 
summ aba_ef if ano == 2013  & d_ice==1
summ dist_ef if ano == 2013 
summ dist_ef if ano == 2013  & d_ice==1
