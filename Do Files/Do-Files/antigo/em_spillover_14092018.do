*enem público cumulativo
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

log using "$Logfolder/em_publica_cumulativa_14092018.log", replace

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
codigo_uf dep cod_meso cod_munic /// 
taxa_participacao_enem 						///
	enem_nota_matematica enem_nota_ciencias enem_nota_humanas 				///
	enem_nota_linguagens enem_nota_redacao enem_nota_objetiva				///
	apr_em rep_em aba_em dist_em ///
d_ice_nota d_ano* d_ice_nota_inte  ///
d_ice_fluxo d_ice_fluxo_inte ///
n_mulheres_em_ep n_brancos_em_ep
 	
	
foreach x in $controles {
drop if `x'==.

}
	
count if n_codigo_escola
count if n_observac

/*
gera por municipio, para cada ano, uma variável que é a soma das dummies de
d_ice_fluxo
isto é, n_com_ice é o número de escolas ice, em um dado ano
*/
bysort cod_munic ano: egen n_com_ice = sum (d_ice_fluxo)
drop if cod_munic ==.

/*
gera dummy que indica que o município tem ice
*/
gen m_tem_ice= 0
replace m_tem_ice = 1 if n_com_ice > 0


*criando variável para o propensity score
/* gera por municipio, uma variável que é a soma das dummies ice_inte
isto é, n_com_ice2 é a soma de escolas ice integrais ao longo do tempo*/
bysort cod_munic: egen n_com_ice2 = sum (ice)


/*gera dummy se municipio teve ice integral*/
gen m_teve_ice = 0
replace m_teve_ice = 1 if n_com_ice2 > 0
drop ice

rename m_teve_ice ice

/*dropando as escolas que tiveram ice */
drop if d_ice_fluxo == 1

/*colapsando em município e em ano*/

collapse (mean) ice codigo_uf taxa_participacao_enem 						///
	enem_nota_matematica enem_nota_ciencias enem_nota_humanas 				///
	enem_nota_linguagens enem_nota_redacao enem_nota_objetiva				///
	apr_em rep_em aba_em dist_em											///
	m_tem_ice  d_ano* e_escol_sup_pai e_escol_sup_mae 	///
	e_renda_familia_5_salarios e_mora_mais_de_6_pessoas						///
	e_trabalhou_ou_procurou	concluir_em_ano_enem predio						/// 
	n_alunos_em_ep n_mulheres_em_ep				///
	n_brancos_em_ep  rural lixo_coleta eletricidade agua esgoto				/// 
	n_salas_utilizadas									///					
	diretoria sala_professores lab_info lab_ciencias ///
	quadra_esportes internet ///
	pib_capita_reais_real_2015 pop mais_educ, 	///
	by(cod_munic ano)

	
xtset cod_munic ano

****************************************************************************************************************************************************************************************************************
****************************************************************************************************************************************************************************************************************
****************************************************************************************************************************************************************************************************************
****************************************************************************************************************************************************************************************************************
* calculando propensity score
* calcular dentro de cada ano
* atribuir um propensity score por cada cidade, que vai ser definido como o propensity score do primeiro ano que a escola apareceu na base


set matsize 10000
gen pscore_total=.

forvalues x=2003(1)2015{
pscore ice $controles_pscore  if ano == `x', pscore(pscores_todos_`x')
replace pscore_total = 1 /(1-pscores_todos_`x') if ice==0& pscores_todos_`x'!=.

}
sort cod_munic ano

replace pscore_total = 1 if ice == 1

/* 
aqui, no xtreg, o propensity para cada escola deve ser constante ao longo do tmepo. 
o algoritmo abaixo atribui o propensity score mais antigo da escola a propria escola
*/
bysort cod_munic: egen ano_aux = min(ano)
gen pscore_total_aux=.
replace pscore_total_aux = pscore_total if ano_aux ==ano

bysort cod_munic: egen pscore_total_aux_2 = max(pscore_total_aux)

replace pscore_total = pscore_total_aux_2


****************************************************************************************************************************************************************************************************************
****************************************************************************************************************************************************************************************************************
****************************************************************************************************************************************************************************************************************
****************************************************************************************************************************************************************************************************************
/*gerando as variáveis padronizadas*/
foreach x in "enem_nota_matematica" "enem_nota_ciencias" "enem_nota_humanas" ///
	"enem_nota_linguagens"  ///
	"apr_em" "rep_em" "aba_em" "dist_em" {
		egen `x'_std=std(`x')
}
	
foreach a in 2003 2004 2005 2006 2007 2008 {
egen enem_nota_redacao_std_aux_`a'=std(enem_nota_redacao) if ano==`a'
}
egen enem_nota_redacao_std=std(enem_nota_redacao) if ano>=2009

foreach a in 2003 2004 2005 2006 2007 2008 {
replace enem_nota_redacao_std=enem_nota_redacao_std_aux_`a' if ano==`a'
}

foreach a in 2003 2004 2005 2006 2007 2008 {
egen enem_nota_objetiva_std_aux_`a'=std(enem_nota_objetiva) if ano==`a'
}
gen enem_nota_objetivab=(enem_nota_matematica +enem_nota_ciencias +enem_nota_humanas+enem_nota_linguagens)/4
egen enem_nota_objetivab_std=std(enem_nota_objetivab) if ano>=2009

foreach a in 2003 2004 2005 2006 2007 2008 {
replace enem_nota_objetivab_std=enem_nota_objetiva_std_aux_`a' if ano==`a'
}
drop enem_nota_redacao_std_aux_2003 - enem_nota_redacao_std_aux_2008 
drop enem_nota_objetiva_std_aux_2003 - enem_nota_objetiva_std_aux_2008


xtreg enem_nota_objetivab_std m_tem_ice d_ano*	///
	 $controles /*[pw=pscore_total]*/, ///	
	fe  vce(rob)
outreg2 using "$output/em_spillover.xls", excel replace label ctitle(enem_nota_objetivab, fe )
xtreg enem_nota_objetivab_std m_tem_ice d_ano*	///
	 $controles /*[pw=pscore_total]*/, ///	
	fe  cluster(codigo_uf)
outreg2 using "$output/em_spillover.xls", excel append label ctitle(enem_nota_objetivab, fe cluster uf)

foreach x in "enem_nota_matematica"  "enem_nota_redacao"   "enem_nota_ciencias" "enem_nota_humanas" ///
	"enem_nota_linguagens" {
	xtreg `x'_std m_tem_ice d_ano* $controles /*[pw=pscore_total]*/, ///
		fe vce(rob)
	outreg2 using "$output/em_spillover.xls",			///
		excel append label ctitle(`x', fe ) 
	xtreg `x'_std m_tem_ice d_ano* $controles /*[pw=pscore_total]*/, ///
		fe cluster(codigo_uf)
	outreg2 using "$output/em_spillover.xls",			///
		excel append label ctitle(`x', fe cluster uf) 

}

foreach x in "apr_em" "rep_em" "aba_em" "dist_em" {
	xtreg `x'_std m_tem_ice d_ano* $controles /*[pw=pscore_total]*/, ///
		fe vce(rob)
	outreg2 using "$output/em_spillover.xls",			///
		excel append label ctitle(`x', fe ) 
	xtreg `x'_std m_tem_ice d_ano* $controles /*[pw=pscore_total]*/, ///
		fe cluster(codigo_uf)
	outreg2 using "$output/em_spillover.xls",			///
		excel append label ctitle(`x', fe cluster uf) 
}

**************************************************************
**************************************************************
*propensity score
**************************************************************


xtreg enem_nota_objetivab_std m_tem_ice d_ano*	///
	 $controles [pw=pscore_total], ///	
	fe  vce(rob)
outreg2 using "$output/em_ps_spillover.xls", excel replace label ctitle(enem_nota_objetivab,ps fe)

xtreg enem_nota_objetivab_std m_tem_ice d_ano*	///
	 $controles [pw=pscore_total], ///	
	fe  cluster(codigo_uf)
outreg2 using "$output/em_ps_spillover.xls", excel append label ctitle(enem_nota_objetivab,ps fe cluster uf)

foreach x in "enem_nota_matematica"  "enem_nota_redacao"   "enem_nota_ciencias" "enem_nota_humanas" ///
	"enem_nota_linguagens" {
	xtreg `x'_std m_tem_ice d_ano* $controles [pw=pscore_total], ///
		fe vce(rob)
	outreg2 using "$output/em_ps_spillover.xls",			///
		excel append label ctitle(`x', fe ps) 
	xtreg `x'_std m_tem_ice d_ano* $controles [pw=pscore_total], ///
		fe cluster(codigo_uf)
	outreg2 using "$output/em_ps_spillover.xls",			///
		excel append label ctitle(`x', fe ps cluster uf) 
}

foreach x in "apr_em" "rep_em" "aba_em" "dist_em" {
	xtreg `x'_std m_tem_ice d_ano* $controles [pw=pscore_total], ///
		fe vce(rob)
	outreg2 using "$output/em_ps_spillover.xls",			///
		excel append label ctitle(`x', fe ps) 
	xtreg `x'_std m_tem_ice d_ano* $controles [pw=pscore_total], ///
		fe cluster(codigo_uf)
	outreg2 using "$output/em_ps_spillover.xls",			///
		excel append label ctitle(`x', fe ps cluster uf) 
}

log close
