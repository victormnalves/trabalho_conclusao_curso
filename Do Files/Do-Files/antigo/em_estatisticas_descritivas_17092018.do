/*estatisticas descritivas*/


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

log using "$Logfolder/em_estatisticas descritivas.log", replace

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

global outcomes apr_em_std rep_em_std aba_em_std dist_em_std 	///
enem_nota_matematica_std  enem_nota_ciencias_std 				/// 
enem_nota_humanas_std enem_nota_linguagens_std 					///
enem_nota_redacao_std enem_nota_objetivab_std  					///

global controles  concluir_em_ano_enem e_mora_mais_de_6_pessoas e_escol_sup_pai	///
	e_escol_sup_mae e_renda_familia_5_salarios e_trabalhou_ou_procurou predio 	///
	diretoria sala_professores lab_info lab_ciencias quadra_esportes internet 	///
	rural lixo_coleta eletricidade agua esgoto n_salas_utilizadas				///
	n_alunos_em_ep pib_capita_reais_real_2015 pop mais_educ 

global controles_pscore  concluir_em_ano_enem e_mora_mais_de_6_pessoas e_escol_sup_pai	///
	e_escol_sup_mae e_renda_familia_5_salarios e_trabalhou_ou_procurou predio 			///
	diretoria sala_professores lab_info lab_ciencias quadra_esportes internet			///
	rural lixo_coleta eletricidade agua  esgoto n_salas_utilizadas						///
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


***********************************************************************************************************************
***********************************************************************************************************************
***********************************************************************************************************************
foreach x in $controles{
	gen `x'_pond = `x'* pscore_total
}

foreach x in $outcomes{
	gen `x'_pond = `x'* pscore_total
}


global outcomes_ponderado pr_em_std_pond rep_em_std_pond aba_em_std_pond dist_em_std_pond 	///
enem_nota_matematica_std_pond  enem_nota_ciencias_std_pond				/// 
enem_nota_humanas_std_pond enem_nota_linguagens_std_pond 					///
enem_nota_redacao_std_pond enem_nota_objetivab_std_pond 					///

global controles_ponderado concluir_em_ano_enem_pond e_mora_mais_de_6_pessoas_pond e_escol_sup_pai_pond	///
	e_escol_sup_mae_pond e_renda_familia_5_salarios_pond e_trabalhou_ou_procurou_pond predio_pond 	///
	diretoria_pond sala_professores_pond lab_info_pond lab_ciencias_pond quadra_esportes_pond internet_pond 	///
	rural_pond lixo_coleta_pond eletricidade_pond agua_pond esgoto_pond n_salas_utilizadas_pond				///
	n_alunos_em_ep_pond pib_capita_reais_real_2015_pond pop_pond mais_educ_pond 



tabstat $outcomes  if ano ==2003&dep!=4, by(ice) stat(mean sd) 
tabstat $outcomes  if ano ==2004&dep!=4, by(ice) stat(mean sd) 
tabstat $outcomes  if ano ==2005&dep!=4, by(ice) stat(mean sd) 
tabstat $outcomes  if ano ==2006&dep!=4, by(ice) stat(mean sd) 
tabstat $outcomes  if ano ==2007&dep!=4, by(ice) stat(mean sd) 
tabstat $outcomes  if ano ==2008&dep!=4, by(ice) stat(mean sd) 
tabstat $outcomes  if ano ==2009&dep!=4, by(ice) stat(mean sd) 
tabstat $outcomes  if ano ==2010&dep!=4, by(ice) stat(mean sd) 
tabstat $outcomes  if ano ==2011&dep!=4, by(ice) stat(mean sd) 
tabstat $outcomes  if ano ==2012&dep!=4, by(ice) stat(mean sd) 
tabstat $outcomes  if ano ==2013&dep!=4, by(ice) stat(mean sd) 
tabstat $outcomes  if ano ==2014&dep!=4, by(ice) stat(mean sd) 
tabstat $outcomes  if ano ==2015&dep!=4, by(ice) stat(mean sd)


/*
criando uma variável que indica se a escola é do grupo do tratamento (ie, foi ou será tratada eventualmente)
mas ainda não foi tratada
*/
gen ice_n_tratada_nota = .
gen ice_n_tratada_fluxo = .

replace ice_n_tratada_nota = 1 if ice==1 & d_ice_nota==0
replace ice_n_tratada_fluxo = 1 if ice==1 & d_ice_fluxo==0
replace ice_n_tratada_nota = 0 if ice==0 
replace ice_n_tratada_fluxo = 0 if ice==0 
foreach x in $controles {
	ttest `x', by(ice_n_tratada_fluxo)
	mean `x'
}



foreach x in $controles_ponderado {
	ttest `x', by(ice_n_tratada_fluxo)
	mean `x'
}

foreach x in "enem_nota_redacao_std" "enem_nota_objetivab_std"  {
ttest `x', by(ice_n_tratada_nota) 
mean `x'
}


*comparando outcomes no pre tratamento
foreach x in "enem_nota_redacao_std" "enem_nota_objetivab_std"  {
ttest `x' if ano == 2003, by(ice) 
mean `x' if ano == 2003
}
foreach x in "enem_nota_redacao_std_pond" "enem_nota_objetivab_std_pond" {
ttest `x' if ano == 2003, by(ice_n_tratada_nota)
mean `x' if ano == 2003
}

foreach x in "enem_nota_redacao_std" "enem_nota_objetivab_std"  {
ttest `x' if ano == 2007, by(ice_n_tratada_nota) 
mean `x' if ano == 2007
}
foreach x in "enem_nota_redacao_std_pond" "enem_nota_objetivab_std_pond" {
ttest `x' if ano == 2007, by(ice_n_tratada_nota)
mean `x' if ano == 2007
}



eststo tratados: quietly estpost summarize ///
    $controles if ice_n_tratada_nota == 1
eststo controles: quietly estpost summarize ///
	$controles if ice_n_tratada_nota ==0
eststo diff: quietly estpost ttest ///
    $controles, by(ice_n_tratada_nota) unequal

esttab tratados controles diff , ///
cells("mean(pattern(1 1 0) fmt(2)) sd(pattern(1 1 0)) b(star pattern(0 0 1) fmt(2)) t(pattern(0 0 1) par fmt(2))") ///
label

eststo tratados_pond: quietly estpost summarize ///
    $controles_ponderado if ice_n_tratada_nota == 1
eststo controles_pond: quietly estpost summarize ///
	$controles_ponderado if ice_n_tratada_nota ==0
eststo diff_pond: quietly estpost ttest ///
    $controles_ponderado, by(ice_n_tratada_nota) unequal

esttab tratados_pond controles_pond diff_pond ,  ///
cells("mean(pattern(1 1 0) fmt(2)) sd(pattern(1 1 0)) b(star pattern(0 0 1) fmt(2)) t(pattern(0 0 1) par fmt(2))") ///
label


/*
eststo summstats: estpost summarize $controles ice
eststo tratados: estpost summarize $controles if ice_n_tratada_nota ==1
eststo controles:  estpost summarize $controles if ice_n_tratada_nota ==0
eststo diff: estpost ttest $controles , by(ice_n_tratada_nota)
esttab summstats tratados controles diff, replace main(mean %6.2f) aux(sd) mtitle("Amostra" "Escolas tratadas" "Escolas não tratadas")
esttab summstats tratados controles, replace cell("mean sd") mtitle("Amostra" "Escolas tratadas" "Escolas não tratadas")
*/
/*
ssc install estout
eststo summstats: estpost summarize audit_fee ln_AF total_asset ln_TA net_income ln_NI busy chTA big_4
eststo big_4: estpost summarize audit_fee ln_AF total_asset ln_TA net_income ln_NI busy chTA  if big_4==1
eststo non_big_4: estpost summarize  audit_fee ln_AF total_asset ln_TA net_income ln_NI busy chTA  if big_4==0
esttab summstats big_4 non_big_4 using descriptive statistics.rtf, replace main(mean %6.2f) aux(sd) mtitle("Total sample" "Big Four clients" "Non-Big Four clients")
esttab summstats big_4 non_big_4 using descriptive statistics.rtf, replace cell("mean sd") mtitle("Total sample" "Big Four clients" "Non-Big Four clients")
*/

/*
* testando novo peso de propensity score
gen pscore_total_2=.

forvalues x=2003(1)2015{
pscore ice $controles_pscore  if ano == `x', pscore(pscores_todos_2_`x')
replace pscore_total_2 = 1 /(1-pscores_todos_2_`x') if ice==0& pscores_todos_2_`x'!=.
replace pscore_total_2 = 1 /(pscores_todos_2_`x') if ice==1 & pscores_todos_2_`x'!=.
}

sort codigo_escola ano




/* 
aqui, no xtreg, o propensity para cada escola deve ser constante ao longo do tmepo. 
o algoritmo abaixo atribui o propensity score mais antigo da escola a propria escola
*/
bysort codigo_escola: egen ano_aux_2 = min(ano)
gen pscore_total_2_aux=.
replace pscore_total_2_aux = pscore_total_2 if ano_aux_2 ==ano

bysort codigo_escola: egen pscore_total_2_aux_2 = max(pscore_total_2_aux)

replace pscore_total_2 = pscore_total_2_aux_2

foreach x in $controles{
	gen `x'_p_2 = `x'* pscore_total_2
}

foreach x in $outcomes{
	gen `x'_p_2 = `x'* pscore_total_2
}

global outcomes_ponderado_2 pr_em_std_p_2 rep_em_std_p_2 aba_em_std_p_2 dist_em_std_p_2 	///
enem_nota_matematica_std_p_2  enem_nota_ciencias_std_p_2				/// 
enem_nota_humanas_std_p_2 enem_nota_linguagens_std_p_2 					///
enem_nota_redacao_std_p_2 enem_nota_objetivab_std_pond-2 					///

global controles_ponderado_2 concluir_em_ano_enem_p_2 e_mora_mais_de_6_pessoas_p_2 e_escol_sup_pai_p_2	///
	e_escol_sup_mae_p_2 e_renda_familia_5_salarios_p_2 e_trabalhou_ou_procurou_p_2 predio_p_2 	///
	diretoria_p_2 sala_professores_p_2 lab_info_p_2 lab_ciencias_p_2 quadra_esportes_p_2 internet_p_2 	///
	rural_p_2 lixo_coleta_p_2 eletricidade_p_2 agua_p_2 esgoto_p_2 n_salas_utilizadas_p_2				///
	n_alunos_em_ep_p_2 pib_capita_reais_real_2015_p_2 pop_p_2 mais_educ_p_2 

	eststo tratados_pond_2: quietly estpost summarize ///
    $controles_ponderado_2 if ice_n_tratada_nota == 1
eststo controles_pond_2: quietly estpost summarize ///
	$controles_ponderado_2 if ice_n_tratada_nota ==0
eststo diff_pond_2: quietly estpost ttest ///
    $controles_ponderado_2, by(ice_n_tratada_nota) unequal

esttab tratados_pond_2 controles_pond_2 diff_pond_2, ///
cells("mean(pattern(1 1 0) fmt(2)) sd(pattern(1 1 0)) b(star pattern(0 0 1) fmt(2)) t(pattern(0 0 1) par fmt(2))") ///
label

*/
