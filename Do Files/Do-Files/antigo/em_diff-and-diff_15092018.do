/*diff and diff*/

*enem público geral
capture log close
clear all
set more off


global user "`:environment USERPROFILE'"
global Folder "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"
global output "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\resultados_v3"
global Bases "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"
global dofiles "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\Do-Files"
global Logfolder "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\logfiles"



global folderservidor "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"

log using "$Logfolder/em_publica_diff_14092018.log", replace

use "$folderservidor\em_com_censo_escolar_14.dta", clear
by codigo_escola, sort: gen n_codigo_escola = _n == 1
gen n_observac = 1
count if n_codigo_escola

count if n_observac


replace ice=0 if ice ==.
drop if dep ==4

count if n_codigo_escola
count if n_observac


global estado d_uf*


global alavancas_fluxo d_ice_fluxo_al1 d_ice_fluxo_al2 d_ice_fluxo_al3 d_ice_fluxo_al4 d_ice_fluxo_al5 d_ice_fluxo_al6 d_ice_fluxo_al7 d_ice_fluxo_al8 
global alavancas_fluxo_todas d_ice_fluxo_al1 d_ice_fluxo_al2 d_ice_fluxo_al3 d_ice_fluxo_al4 d_ice_fluxo_al5 d_ice_fluxo_al6 d_ice_fluxo_al7 d_ice_fluxo_al8 d_ice_fluxo_al9
global alavancas_nota d_ice_nota_al1 d_ice_nota_al2 d_ice_nota_al3 d_ice_nota_al4 d_ice_nota_al5 d_ice_nota_al6 d_ice_nota_al7 d_ice_nota_al8 
global alavancas_nota_todas d_ice_nota_al1 d_ice_nota_al2 d_ice_nota_al3 d_ice_nota_al4 d_ice_nota_al5 d_ice_nota_al6 d_ice_nota_al7 d_ice_nota_al8 d_ice_nota_al9

global outcomes apr_em_std rep_em_std aba_em_std dist_em_std ///
enem_nota_matematica_std  enem_nota_ciencias_std /// 
enem_nota_humanas_std enem_nota_linguagens_std  ///
enem_nota_redacao_std enem_nota_objetivab_std  ///

global controles  concluir_em_ano_enem e_mora_mais_de_6_pessoas e_escol_sup_pai	///
	e_escol_sup_mae e_renda_familia_5_salarios e_trabalhou_ou_procurou predio 	///
	diretoria sala_professores lab_info lab_ciencias quadra_esportes internet 	///
	rural lixo_coleta eletricidade agua esgoto n_salas_utilizadas				///
	n_alunos_em_ep pib_capita_reais_real_2015 pop mais_educ 

global controles_pscore  concluir_em_ano_enem e_mora_mais_de_6_pessoas e_escol_sup_pai	///
	e_escol_sup_mae e_renda_familia_5_salarios e_trabalhou_ou_procurou predio 	///
	diretoria sala_professores lab_info lab_ciencias quadra_esportes internet		 ///
	rural lixo_coleta eletricidade agua  esgoto n_salas_utilizadas					///
	n_alunos_em_ep pib_capita_reais_real_2015 pop mais_educ /*taxa_participacao_enem*/

	/// tirando taxa de participação do enem pois há muitos missings e não é significativo no probit
global outros  n_codigo_escola n_observac


keep $estado $alavancas_fluxo $alavancas_fluxo_todas $alavancas_nota_todas ///
$controles  $outros ///
ice ice_inte codigo_escola ano ano_ice taxa_participacao_enem ///
codigo_uf dep cod_meso /// 
apr_em_std rep_em_std aba_em_std dist_em_std ///
enem_nota_matematica_std  enem_nota_ciencias_std /// 
enem_nota_humanas_std enem_nota_linguagens_std  ///
enem_nota_redacao_std enem_nota_objetivab_std  ///
d_ice_nota d_ano* d_ice_nota_inte ///
d_ice_fluxo d_ice_fluxo_inte
 	
	
foreach x in $controles {
drop if `x'==.

}
	
count if n_codigo_escola
count if n_observac

xtset codigo_escola ano


****************************************************************************************************************************************************************************************************************
****************************************************************************************************************************************************************************************************************
****************************************************************************************************************************************************************************************************************
****************************************************************************************************************************************************************************************************************
*calculando propensity score
* calcular dentro de cada ano
* atribuir um propensity score por cada escola, que vai ser definido como o propensity score do primeiro ano que a escola apareceu na base

/*
nas análises anterior, eu estava calculando o propensity score somente para 2003. No entano, escolas presentes no censo escolar ou no enem 
Xsomente nos anos subsequentes não estavam entrando para a análise
*/
set matsize 10000
gen pscore_total=.
forvalues x=2003(1)2015{
pscore ice $controles_pscore  if ano == `x', pscore(pscores_todos_`x')
replace pscore_total = 1 /(1-pscores_todos_`x') if ice==0& pscores_todos_`x'!=.

}

sort codigo_escola ano


replace pscore_total = 1 if ice == 1

/* 
aqui, no xtreg, o propensity para cada escola deve ser constante ao longo do tmepo. 
o algoritmo abaixo atribui o propensity score mais antigo da escola a propria escola
*/
bysort codigo_escola: egen ano_aux = min(ano)
gen pscore_total_aux=.
replace pscore_total_aux = pscore_total if ano_aux ==ano

bysort codigo_escola: egen pscore_total_aux_2 = max(pscore_total_aux)

replace pscore_total = pscore_total_aux_2

****************************************************************************************************************************************************************************************************************
****************************************************************************************************************************************************************************************************************
****************************************************************************************************************************************************************************************************************
****************************************************************************************************************************************************************************************************************

/*
vamos calcular agora o efeito geral
será uma análise de painel, usando como variável dependente as notas e as variáveis de fluxo
e como independetes controles da escola $controle, dummies de ano e efeito fixo em escola,
fazendo cluster em estado
vamos analisar com o propensity score  e sem o propensity score
com e sem interação de ensino integral

*/


****************************************************************************************************************************************************************
*notas
*enem_nota_objetivab_std

*sem propensity score
reg enem_nota_objetivab_std ice d_ice_nota d_ano* $controles $estado ,  cluster(codigo_uf)
outreg2 using "$output/em_publica_diff_notas_14092018.xls", excel replace label ctitle(enem objetiva,  cluster estado)

reg enem_nota_objetivab_std ice d_ice_nota d_ice_nota_inte d_ano* $controles $estado,  cluster(codigo_uf)
outreg2 using "$output/em_publica_diff_notas_14092018.xls", excel append label ctitle(enem objetiva,  cluster estado, integral)

*com propensity score
reg enem_nota_objetivab_std ice d_ice_nota d_ano* $controles $estado [pw=pscore_total],  cluster(codigo_uf)
outreg2 using "$output/em_publica_diff_notas_14092018.xls", excel append label ctitle(enem objetiva,  cluster estado ps)

reg enem_nota_objetivab_std ice d_ice_nota d_ice_nota_inte d_ano* $controles $estado [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "$output/em_publica_diff_notas_14092018.xls", excel append label ctitle(enem objetiva, fe cluster estado ps, integral)



*enem_nota_matematica_std, enem_nota_redacao_std
reg x in "enem_nota_matematica_std" "enem_nota_redacao_std" {
*sem propensity score
reg `x'  ice d_ice_nota  d_ano* $controles $estado,  cluster(codigo_uf)
outreg2 using "$output/em_publica_diff_notas_14092018.xls", excel append label ctitle( `x',  cluster estado)

reg `x' ice d_ice_nota  d_ice_nota_inte d_ano* $controles $estado,  cluster(codigo_uf)
outreg2 using "$output/em_publica_diff_notas_14092018.xls", excel append label ctitle( `x',  cluster estado, integral)

*com propensity score
reg `x' ice d_ice_nota  d_ano* $controles $estado [pw=pscore_total],  cluster(codigo_uf)
outreg2 using "$output/em_publica_diff_notas_14092018.xls", excel append label ctitle( `x',  cluster estado ps)

reg `x' ice d_ice_nota  d_ice_nota_inte d_ano* $controles $estado [pw=pscore_total],  cluster(codigo_uf)
outreg2 using "$output/em_publica_diff_notas_14092018.xls", excel append label ctitle( `x',  cluster estado ps, integral)

}


****************************************************************************************************************************************************************
*fluxo
*apr_em_std

*sem propensity score
reg apr_em_std ice d_ice_fluxo  d_ano* $controles $estado ,  cluster(codigo_uf)
outreg2 using "$output/em_publica_diff_fluxo_14092018.xls", excel replace label ctitle(apr_em_std,  cluster estado)

reg apr_em_std ice d_ice_fluxo   d_ice_fluxo_inte d_ano* $controles $estado,  cluster(codigo_uf)
outreg2 using "$output/em_publica_diff_fluxo_14092018.xls", excel append label ctitle(apr_em_std,  cluster estado, integral)

*com propensity score
reg apr_em_std ice d_ice_fluxo  d_ano* $controles $estado [pw=pscore_total],  cluster(codigo_uf)
outreg2 using "$output/em_publica_diff_fluxo_14092018.xls", excel append label ctitle(apr_em_std,  cluster estado ps)

reg apr_em_std  ice d_ice_fluxo  d_ice_fluxo_inte d_ano* $controles $estado [pw=pscore_total],  cluster(codigo_uf)
outreg2 using "$output/em_publica_diff_fluxo_14092018.xls", excel append label ctitle(apr_em_std,  cluster estado ps, integral)

*rep_em_std aba_em_std dist_em_std
foreach x in "rep_em_std" "aba_em_std" "dist_em_std" {
*sem propensity score
reg `x'ice d_ice_fluxo  d_ano* $controles $estado,  cluster(codigo_uf)
outreg2 using "$output/em_publica_diff_fluxo_14092018.xls", excel append label ctitle( `x',  cluster estado)

reg `x' ice d_ice_fluxo  d_ice_fluxo_inte d_ano* $controles $estado,  cluster(codigo_uf)
outreg2 using "$output/em_publica_diff_fluxo_14092018.xls", excel append label ctitle( `x',  cluster estado, integral)

*com propensity score
reg `x' ice d_ice_fluxo  d_ano* $controles $estado [pw=pscore_total],  cluster(codigo_uf)
outreg2 using "$output/em_publica_diff_fluxo_14092018.xls", excel append label ctitle( `x',  cluster estado ps)

reg `x' ice d_ice_fluxo  d_ice_fluxo_inte d_ano* $controles $estado [pw=pscore_total],  cluster(codigo_uf)
outreg2 using "$output/em_publica_diff_fluxo_14092018.xls", excel append label ctitle( `x',  cluster estado ps, integral)

}
log close

 
