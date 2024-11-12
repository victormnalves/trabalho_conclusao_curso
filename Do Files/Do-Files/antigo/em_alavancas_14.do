/*		           Ensino Médio - Alavancas                                 */

/*

estimação do efeito em nota e em fluxo, usando as variáveis de alavanca.
note que
*/
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
global output "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\resultados_alavancas"
global Bases "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"
global dofiles "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\Do-Files"
global Logfolder "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\logfiles"


global folderservidor "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"


log using "$folderservidor\logfiles//em_alavancas.log", replace

****************************************************************************
/*                                  NOTAS                                 */
****************************************************************************

*para analisar o impacto das alavancas na nota, vamos usar a base notas_alavancas
use "$Bases/ice_clean_notas_alavancas.dta", clear

drop if ano == 2015

/* 
análise em painel: declarando as variáveis de tempo (ano) e de observação
e de escola
*/
iis codigo_escola
tis ano

/*
Dropar RJ e ES: no rio e no espírito santo, somente escolas fundamentais tiveram o programa. 
como é uma análise do enem, podemos dropar as observações de escolas do rio do ES
*/
drop if codigo_uf==33 | codigo_uf==32

******************* PSCORE *******************
*chamando o dofile que gera os pscores para ensino médio
do "$dofiles/em_pscore_14.do"

******************* INTERAÇÕES DE TURNO E ALAVANCAS *******************
*gerando dummies de interação de turno e alavancas
do "$dofiles/turno_alavanca_14.do"

* note que as alavancas tem alta correlação linear entre si
* vamos agregar alavancas em grupo maiores

* alavanca engajamento: bom engajamento com o governador e/ou com o secretário da educação?
gen d_ice_alav_engajamento_gov_sec =.
replace d_ice_alav_engajamento_gov_sec = 1 if d_ice_al1==1 | d_ice_al2==1
replace d_ice_alav_engajamento_gov_sec = 0 if d_ice_al1==0 & d_ice_al2==0

* alavanca time seduc: time da seduc dedicado para a implantação do programa?
gen d_ice_alav_seduc = d_ice_al3


* alavanca marcos legais: implantação dos marcos legais na forma da lei dentro ou não do cronograma estipulado 
gen d_ice_alav_marcos_legais =.
replace d_ice_alav_marcos_legais = 1 if d_ice_al4==1 | d_ice_al5==1
replace d_ice_alav_marcos_legais = 0 if d_ice_al4==0 & d_ice_al5==0

* alavanca seleção: processo de seleção ou remoção de professores ou de diretores?
gen d_ice_alav_processo_seletivo = .
replace d_ice_alav_processo_seletivo = 1 if d_ice_al6==1 | d_ice_al7==1
replace d_ice_alav_processo_seletivo = 0 if d_ice_al6==0 & d_ice_al7==0


* Implantação do projeto de vida na Matriz Curricular
gen d_ice_alav_projeto_vida = d_ice_al8

****************** PADRONIZAÇÃO DE NOTAS - EM ******************
*gerando notas do enem padronizadas por estado
do "$dofiles/em_padronizar_notas_14.do"



*dummies de estado

tab codigo_uf, gen(d_estado)
****************************************************************************
/*                          Resultados Gerais           	              */
****************************************************************************

/*
selecionando os controles para as estimações - caracteristicas da escola que 
venham a impactar a nota média do enem da escola
*/

local controles e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria ///
n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep  rural agua eletricidade ///
esgoto lixo_coleta sala_professores  lab_info lab_ciencias quadra_esportes biblioteca  /// 
internet 
local estado d_estado*
local alavancas d_ice_al1 d_ice_al2 d_ice_al3 d_ice_al4 d_ice_al5 d_ice_al6 d_ice_al7 d_ice_al8 d_ice_al9
local alavancas_agregadas d_ice_alav_engajamento_gov_sec d_ice_alav_seduc d_ice_alav_marcos_legais d_ice_alav_processo_seletivo d_ice_alav_processo_seletivo d_ice_alav_projeto_vida

foreach outcome in "enem_nota_matematica" "enem_nota_redacao" "enem_nota_objetivab" "apr_em" "rep_em" "aba_em" "dist_em"{
	xtreg `outcome'_std d_ice d_ano* `alavancas' `controles' `estado' [pw=pscore_total] if dep!=4  , fe cluster(codigo_uf)
	outreg2 using "$output/ICE_resultados_ps_em_alavancas.xls", excel append label ctitle(`outcome', controle pub, tudo alavancas)

	xtreg `outcome'_std d_ice d_ano* d_ice_al1 `controles' `estado' [pw=pscore_total] if dep!=4  , fe cluster(codigo_uf)
	outreg2 using "$output/ICE_resultados_ps_em_alavancas.xls", excel append label ctitle(`outcome', controle pub, tudo alavanca 1)
	
	
	xtreg `outcome'_std d_ice d_ano* d_ice_al2 `controles' `estado' [pw=pscore_total] if dep!=4  , fe cluster(codigo_uf)
	outreg2 using "$output/ICE_resultados_ps_em_alavancas.xls", excel append label ctitle(`outcome', controle pub, tudo alavanca 2)
	
	xtreg `outcome'_std d_ice d_ano* d_ice_al3 `controles' `estado' [pw=pscore_total] if dep!=4  , fe cluster(codigo_uf)
	outreg2 using "$output/ICE_resultados_ps_em_alavancas.xls", excel append label ctitle(`outcome', controle pub, tudo alavanca 3)
	
	xtreg `outcome'_std d_ice d_ano* d_ice_al4 `controles' `estado' [pw=pscore_total] if dep!=4  , fe cluster(codigo_uf)
	outreg2 using "$output/ICE_resultados_ps_em_alavancas.xls", excel append label ctitle(`outcome', controle pub, tudo alavanca 4)
	xtreg `outcome'_std d_ice d_ano* d_ice_al5 `controles' `estado' [pw=pscore_total] if dep!=4  , fe cluster(codigo_uf)
	outreg2 using "$output/ICE_resultados_ps_em_alavancas.xls", excel append label ctitle(`outcome', controle pub, tudo alavanca 5)
	xtreg `outcome'_std d_ice d_ano* d_ice_al6 `controles' `estado' [pw=pscore_total] if dep!=4  , fe cluster(codigo_uf)
	outreg2 using "$output/ICE_resultados_ps_em_alavancas.xls", excel append label ctitle(`outcome', controle pub, tudo alavanca 6)
	xtreg `outcome'_std d_ice d_ano* d_ice_al7 `controles'  `estado'[pw=pscore_total] if dep!=4  , fe cluster(codigo_uf)
	outreg2 using "$output/ICE_resultados_ps_em_alavancas.xls", excel append label ctitle(`outcome', controle pub, tudo alavanca 7)
	xtreg `outcome'_std d_ice d_ano* d_ice_al8 `controles' `estado' [pw=pscore_total] if dep!=4  , fe cluster(codigo_uf)
	outreg2 using "$output/ICE_resultados_ps_em_alavancas.xls", excel append label ctitle(`outcome', controle pub, tudo alavanca 8)
	
	xtreg `outcome'_std d_ice d_ano* d_ice_al9 `controles' `estado' [pw=pscore_total] if dep!=4  , fe cluster(codigo_uf)
	outreg2 using "$output/ICE_resultados_ps_em_alavancas.xls", excel append label ctitle(`outcome', controle pub, tudo alavanca 9)

	
	
	
	
	xtreg `outcome'_std d_ice d_ano* `alavancas_agregadas' `controles'  `estado' [pw=pscore_total] if dep!=4  , fe cluster(codigo_uf)
	outreg2 using "$output/ICE_resultados_ps_em_alavancas.xls", excel append label ctitle(`outcome', controle pub, tudo alavancas agregado)
	xtreg `outcome'_std  d_ano* `alavancas' `controles' `estado'  [pw=pscore_total] if dep!=4  , fe cluster(codigo_uf)
	outreg2 using "$output/ICE_resultados_ps_em_alavancas.xls", excel append label ctitle(`outcome', controle pub, tudo alavancas sem d_ice)
	xtreg `outcome'_std  d_ano* `alavancas_agregadas' `controles' `estado' [pw=pscore_total] if dep!=4  , fe cluster(codigo_uf)
	outreg2 using "$output/ICE_resultados_ps_em_alavancas.xls", excel append label ctitle(`outcome', controle pub, tudo alavancas sem d_ice)
	
	
	
	}
	

	
/*efeito fixo - sem propensity score*/


local controles e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria ///
n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep  rural agua eletricidade ///
esgoto lixo_coleta sala_professores  lab_info lab_ciencias quadra_esportes biblioteca  /// 
internet

local alavancas d_ice_al1 d_ice_al2 d_ice_al3 d_ice_al4 d_ice_al5 d_ice_al6 d_ice_al7 d_ice_al8 d_ice_al9
local alavancas_agregadas d_ice_alav_engajamento_gov_sec d_ice_alav_seduc d_ice_alav_marcos_legais d_ice_alav_processo_seletivo d_ice_alav_processo_seletivo d_ice_alav_projeto_vida

foreach outcome in "enem_nota_matematica" "enem_nota_redacao" "enem_nota_objetivab" "apr_em" "rep_em" "aba_em" "dist_em"{
	xtreg `outcome'_std d_ice d_ano* `alavancas' `controles' `estado' if dep!=4  , fe cluster(codigo_uf)
	outreg2 using "$output/ICE_resultados_em_alavancas.xls", excel append label ctitle(`outcome', controle pub, tudo alavancas)



	
	
	
	
	xtreg `outcome'_std d_ice d_ano* `alavancas_agregadas' `controles' `estado' if dep!=4  , fe cluster(codigo_uf)
	outreg2 using "$output/ICE_resultados_em_alavancas.xls", excel append label ctitle(`outcome', controle pub, tudo alavancas agregado)
	xtreg `outcome'_std  d_ano* `alavancas' `controles'  `estado'  if dep!=4  , fe cluster(codigo_uf)
	outreg2 using "$output/ICE_resultados_em_alavancas.xls", excel append label ctitle(`outcome', controle pub, tudo alavancas sem d_ice)
	xtreg `outcome'_std  d_ano* `alavancas_agregadas' `controles'  `estado' if dep!=4  , fe cluster(codigo_uf)
	outreg2 using "$output/ICE_resultados_em_alavancas.xls", excel append label ctitle(`outcome', controle pub, tudo alavancas sem d_ice)
	
	
	
	}
