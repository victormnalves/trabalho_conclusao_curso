/*------------------------PB/SAEB - Ensino Fundamental-----------------------*/
/*
aqui vamos estimar o impacto do programa ICE nas nota e em fluxo
como o programa não foi aleatoriezado, fazer um propensity score matching
em seguida, será necessário criar as dummies de alavanca e fazer interações
de turno
depois, padronizar as notas
com todas essas etaps, serão estimados regerssões em painel ponderadas pelo
propensity score
*/
capture log close
clear all
set more off


*cd "`:environment USERPROFILE'\OneDrive\EESP - ECONOMIA - mestrado acadêmico\Dissertação\ICE\dados ICE"
global user "`:environment USERPROFILE'"
*global Folder "$user/OneDrive/EESP_ECONOMIA_mestrado_acadêmico/Dissertação/ICE/dados_ICE/Análise_Leonardo"
global Folder "D:\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo"
global output "$Folder/resultados"
global Bases "$Folder/Bases"
global dofiles "$Folder/Do-Files"
global Logfolder "$Folder/Log"

log using "$Logfolder/ef_pbsaeb.log", replace
*use "$Bases/ice_clean.dta", clear
use "$Bases/ice_clean_notas.dta", clear
set matsize 10000

/*------------------------- Estimações e Resultados-------------------------*/
/*
Notas:
	resultados gerais
	resultados por estados

*/

*****************************   NOTAS   *****************************
***************************   Resultados Gerais  ***************************
set matsize 10000
use "$Bases/ice_clean_notas.dta", clear
drop if ano==2015
keep if n_alunos_ef>0
keep if codigo_uf==33|codigo_uf==35 |codigo_uf==32

* Painel
iis codigo_escola
tis ano

replace ice=0 if ensino_fundamental==0

******************* PSCORE *******************
*chamando o dofile que gera os pscores para ensino médio
do "$dofiles/ef_pscore.do"

******************* INTERAÇÕES DE TURNO E ALAVANCAS *******************
*gerando dummies de interação de turno e alavancas
do "$dofiles/turno_alavanca.do"

****************** PADRONIZAÇÃO DE NOTAS - EM ******************
*gerando ntoas do enem padronizadas
*do "$dofiles/ef_padroninzar_notas.do"

*****************       Resultados Gerais    ****************

/*
selecionando os controles para as estimações - caracteristicas da escola que 
venham a impactar a nota média da prova brail saeb da escola
*/

local controles pb_esc_sup_mae_9 pb_esc_sup_pai_9 n_alunos_ef_em_ep ///
	n_mulheres_ef_em_ep n_brancos_ef_em_ep rural agua eletricidade esgoto ///
	lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes  ///
	biblioteca internet
/*
foreach que para cada nota padronizada, e variável de fluxo

faz um xtreg fe, 
com d_ice e d_ano*`controles' (fazendo interação da d_ano com cada um dos 
controles) 
ie somente os controles do ano vão impactar nos outcomes notas
utilizando o pscore_total como peso
clusterizando o erro por estado

depois da regressão, gera tabelas outreg para excel
*/	
	foreach outcomes in "media_lp_prova_brasil_9_std" ///
		"media_mt_prova_brasil_9_std" "media_pb_9_std" "apr_ef_std" ///
		"rep_ef_std" "aba_ef_std" "dist_ef_std" {

		*Geral
		/*
		aqui o xtreg só roda nas escolas cujo dep! = 4 ie
		em todas as escolas do ensino medio em geral que não são privadas
		*/
		xtreg `outcomes' d_ice d_ano* `controles' [pw=pscore_total] ///
		if dep!=4 , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_ef_2003_2014.xls", ///
			excel append label ctitle(`outcomes', controle pub) 

		*Por nível de apoio
		/*
		Aqui, o xtreg foi restringidos os tratados para só um 
		tipo de nível de apoio
		*/	
		xtreg `outcomes' d_ice d_ano* `controles' [pw=pscore_total] if ///
			dep!=4&(d_rigor1==1|ice==0), fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_ef_2003_2014.xls", ///
			excel append label ctitle(`outcomes', apoio forte)

		xtreg `outcomes' d_ice d_ano* `controles' [pw=pscore_total] if ///
			dep!=4&(d_rigor3==1|ice==0), fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_ef_2003_2014.xls", ///
			excel append label ctitle(`outcomes', apoio medio)

		xtreg `outcomes' d_ice d_ano* `controles' [pw=pscore_total] if ///
			dep!=4&(d_rigor2==1|ice==0), fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_ef_2003_2014.xls", ///
			excel append label ctitle(`outcomes', apoio fraco)

		xtreg `outcomes' d_ice d_ano* `controles' [pw=pscore_total] if ///
			dep!=4&(d_rigor4==1|ice==0), fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_ef_2003_2014.xls", ///
			excel append label ctitle(`outcomes', sem apoio)

		xtreg `outcomes' d_ice d_ano* `controles' [pw=pscore_total] if ///
			dep!=4&(d_rigor4==0|ice==0) , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_ef_2003_2014.xls", ///
			excel append label ctitle(`outcomes', com algum apoio)

	}
*****************       Resultados por Estado    ****************
use "$Bases/ice_clean_notas.dta", clear
drop if ano==2015

* Painel
iis codigo_escola
tis ano


keep if codigo_uf==33|codigo_uf==35|codigo_uf==23|codigo_uf==26|codigo_uf==32

drop if ice_seg=="EM"

replace ice=0 if ensino_fundamental==0

do "$dofiles/ef_pscore.do"

keep if ano==2009|ano==2011|ano==2013|ano==2015

* Interacoees de turno e alavancas
do "$dofiles/turno_alavanca.do"

* Padronizar
*do "$Dofiles/padronizar_notas.do"
	
local controles pb_esc_sup_mae_9 pb_esc_sup_pai_9 nalunos nbrancos nmulheres ///
rural agua eletricidade esgoto lixo_coleta sala_professores lab_info ///
lab_ciencias quadra_esportes biblioteca   internet


	* Geral
	foreach outcomes in "media_lp_prova_brasil_9" "media_mt_prova_brasil_9"  ///
						"media_pb_9" "apr_ef" "rep_ef"  "aba_ef" "dist_ef" {
		foreach uf in 33 35  {
			xtreg `outcomes'`uf'_std d_ice d_ano* `controles' [pw=pscore_total] if ///
				dep!=4  & codigo_uf==`uf', fe 
			outreg2 using "$output/ICE_resultados_ps_ef_2003_2014_`uf'.xls", ///
				excel append label ctitle(`outcomes', controle pub) 
		}
	}

	
log close

