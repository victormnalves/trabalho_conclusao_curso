/*em_spillover*/


capture log close
clear all
set more off, permanently

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

log using "$Logfolder/em_ps_spillover.log", replace
use "$folderservidor\em_com_censo_escolar_14.dta", clear

/*----------interações e variáveis novas + collapse----------*/

/* 
lembrando que d_ice é a dummy que assumi 1 no ano de entrada da escola no 
programa
*/
/*mantendo só escolas com alunos de ensino médio e que não estão no RJ*/
keep if n_alunos_em_ep > 0
drop if codigo_uf == 33 | codigo_uf == 32

/*
/*gera dummy se é ice e integral*/
gen ice_inte = 0  
replace ice_inte=1 if integral==1 
*/

/*
/*
gera dummy de interação entre entrada e integral
d_ice_inte assumi 1 no ano que a escola integral entrou
*/
gen d_ice_nota_inte=d_ice_nota*ice_inte
gen d_ice_fluxo_inte=d_ice_fluxo*ice_inte
*/
/*
gera dummy de interação entre integral e ser ice
ice_inte2 assumi 1 quando a escola é ice e integral
*/
gen ice_inte2=ice*ice_inte


/*
gera por municipio, para cada ano, uma variável que é a soma das dummies de
ice_inte
isto é, n_com_ice é o número de escolas ice integrais, em um dado ano
*/

bysort cod_munic ano: egen n_com_ice = sum (d_ice_fluxo)

*dropando escolas sem cod_munic, ie só com info de fluxo e sem info de enem
drop if cod_munic ==.
/*
gera dummy se o município tem escola ice integral
*/
gen m_tem_ice= 0
replace m_tem_ice = 1 if n_com_ice > 0
*(21,864 real changes made)



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

/*dropando se é escola privada*/
drop if dep == 4	


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

	
/*
gen igual =1 if ice==m_tem_ice
mdesc igual
. tab ice

 (mean) ice |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |     12,708       79.20       79.20
          1 |      3,337       20.80      100.00
------------+-----------------------------------
      Total |     16,045      100.00

. tab ice if ano==2003

 (mean) ice |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        985       79.18       79.18
          1 |        259       20.82      100.00
------------+-----------------------------------
      Total |      1,244      100.00

*/	
	
/*declarando painel*/



iis cod_munic
tis ano
/*----------Propensity Score----------*/

set matsize 10000

local controles_pscore  concluir_em_ano_enem e_mora_mais_de_6_pessoas e_escol_sup_pai	///
	e_escol_sup_mae e_renda_familia_5_salarios e_trabalhou_ou_procurou predio 	///
	diretoria sala_professores lab_info lab_ciencias quadra_esportes internet		 ///
	rural lixo_coleta eletricidade agua  esgoto n_salas_utilizadas					///
	n_alunos_em_ep pib_capita_reais_real_2015 pop mais_educ

	
pscore ice n_alunos_em_ep `controles_pscore' if ano == 2003, pscore(pscores_todos)

gen pscore_total = .

replace pscore_total = 1 if ice==1

replace pscore_total = 1 / (1-pscores_todos) if ice == 0

bysort cod_munic: egen pscore_total_aux=max(pscore_total)
replace pscore_total=pscore_total_aux


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



global controles  concluir_em_ano_enem e_mora_mais_de_6_pessoas e_escol_sup_pai	///
	e_escol_sup_mae e_renda_familia_5_salarios e_trabalhou_ou_procurou predio 	///
	diretoria sala_professores lab_info lab_ciencias quadra_esportes internet 	///
	rural lixo_coleta eletricidade agua esgoto n_salas_utilizadas				///
	n_alunos_em_ep pib_capita_reais_real_2015 pop mais_educ
	
global outcomes apr_em_std rep_em_std aba_em_std dist_em_std ///
enem_nota_matematica_std  enem_nota_ciencias_std /// 
enem_nota_humanas_std enem_nota_linguagens_std  ///
enem_nota_redacao_std enem_nota_objetivab_std  ///

tabstat $outcomes if ano ==2003, by(ice) stat(mean sd) 
tabstat $outcomes  if ano ==2004, by(ice) stat(mean sd) 
tabstat $outcomes  if ano ==2005, by(ice) stat(mean sd) 
tabstat $outcomes  if ano ==2006, by(ice) stat(mean sd) 
tabstat $outcomes  if ano ==2007, by(ice) stat(mean sd) 
tabstat $outcomes  if ano ==2008, by(ice) stat(mean sd) 
tabstat $outcomes  if ano ==2009, by(ice) stat(mean sd) 
tabstat $outcomes  if ano ==2010, by(ice) stat(mean sd) 
tabstat $outcomes  if ano ==2011, by(ice) stat(mean sd) 
tabstat $outcomes  if ano ==2012, by(ice) stat(mean sd) 
tabstat $outcomes  if ano ==2013, by(ice) stat(mean sd) 
tabstat $outcomes  if ano ==2014, by(ice) stat(mean sd) 
tabstat $outcomes  if ano ==2015, by(ice) stat(mean sd)
	
/*----------resultado e estimações----------*/



	/*
xtreg para as variáveis da prova brasil padronizadas
com controles de escola
*/

xtreg enem_nota_objetivab_std m_tem_ice d_ano*	///
	 $controles /*[pw=pscore_total]*/, ///	
	fe  vce(rob)
outreg2 using "$output/em_spillover.xls", excel replace label ctitle(enem_nota_objetivab, fe  uf)

foreach x in "enem_nota_matematica"  "enem_nota_redacao"   "enem_nota_ciencias" "enem_nota_humanas" ///
	"enem_nota_linguagens" {
	xtreg `x'_std m_tem_ice d_ano* $controles /*[pw=pscore_total]*/, ///
		fe vce(rob)
	outreg2 using "$output/em_spillover.xls",			///
		excel append label ctitle(`x', fe  uf) 

}

foreach x in "apr_em" "rep_em" "aba_em" "dist_em" {
	xtreg `x'_std m_tem_ice d_ano* $controles /*[pw=pscore_total]*/, ///
		fe vce(rob)
	outreg2 using "$output/em_spillover.xls",			///
		excel append label ctitle(`x', fe  uf) 

}

xtreg enem_nota_objetivab_std m_tem_ice d_ano*	///
	 $controles [pw=pscore_total], ///	
	fe  vce(rob)
outreg2 using "$output/em_ps_spillover.xls", excel replace label ctitle(enem_nota_objetivab, fe  uf)

foreach x in "enem_nota_matematica"  "enem_nota_redacao"   "enem_nota_ciencias" "enem_nota_humanas" ///
	"enem_nota_linguagens" {
	xtreg `x'_std m_tem_ice d_ano* $controles [pw=pscore_total], ///
		fe vce(rob)
	outreg2 using "$output/em_ps_spillover.xls",			///
		excel append label ctitle(`x', fe  uf) 

}

foreach x in "apr_em" "rep_em" "aba_em" "dist_em" {
	xtreg `x'_std m_tem_ice d_ano* $controles [pw=pscore_total], ///
		fe vce(rob)
	outreg2 using "$output/em_ps_spillover.xls",			///
		excel append label ctitle(`x', fe  uf) 

}

log close
/*
****************************************************************************
/* 							análise por estado	   						  */
****************************************************************************
log using "$Logfolder/em_ps_spillover_estado.log", replace
use "$folderservidor\em_com_censo_escolar_14.dta", clear

/*----------interações e variáveis novas + collapse----------*/

/* 
lembrando que d_ice é a dummy que assumi 1 no ano de entrada da escola no 
programa
*/
/*mantendo só escolas com alunos de ensino médio e que não estão no RJ*/
keep if n_alunos_em_ep > 0
drop if codigo_uf == 33 | codigo_uf == 32

/*
/*gera dummy se é ice e integral*/
gen ice_inte = 0  
replace ice_inte=1 if integral==1 
*/

/*
/*
gera dummy de interação entre entrada e integral
d_ice_inte assumi 1 no ano que a escola integral entrou
*/
gen d_ice_nota_inte=d_ice_nota*ice_inte
gen d_ice_fluxo_inte=d_ice_fluxo*ice_inte
*/
/*
gera dummy de interação entre integral e ser ice
ice_inte2 assumi 1 quando a escola é ice e integral
*/
gen ice_inte2=ice*ice_inte


/*
gera por municipio, para cada ano, uma variável que é a soma das dummies de
ice_inte
isto é, n_com_ice é o número de escolas ice integrais, em um dado ano
*/
bysort cod_munic ano: egen n_com_ice_nota = sum (d_ice_nota_inte)
bysort cod_munic ano: egen n_com_ice_fluxo = sum (d_ice_fluxo_inte)
/*
gera dummy se o município tem escola ice integral
*/
gen m_tem_ice_nota = 0
replace m_tem_ice_nota = 1 if n_com_ice_nota > 0

gen m_tem_ice_fluxo = 0
replace m_tem_ice_fluxo = 1 if n_com_ice_fluxo > 0


/* gera por municipio, uma variável que é a soma das dummies ice_inte
isto é, n_com_ice2 é a soma de escolas ice integrais ao longo do tempo*/
bysort cod_munic: egen n_com_ice2 = sum (ice_inte2)


/*gera dummy se municipio teve ice integral*/
gen m_teve_ice = 0
replace m_teve_ice = 1 if n_com_ice2 > 0
drop ice
rename m_teve_ice ice


/*dropando as escolas que tiveram ice depois de terem tido o ice*/
drop if d_ice_nota == 1
drop if d_ice_fluxo ==1
/*dropando se é escola privada*/
drop if dep == 4	


/*colapsando em município e em ano*/

collapse (mean) ice codigo_uf taxa_participacao_enem 						///
	enem_nota_matematica enem_nota_ciencias enem_nota_humanas 				///
	enem_nota_linguagens enem_nota_redacao enem_nota_objetiva				///
	apr_em rep_em aba_em dist_em											///
	m_tem_ice_fluxo m_tem_ice_nota d_ano* e_escol_sup_pai e_escol_sup_mae 	///
	e_renda_familia_5_salarios e_mora_mais_de_6_pessoas						///
	e_trabalhou_ou_procurou	concluir_em_ano_enem predio						/// 
	n_alunos_em_ep n_mulheres_em_ep				///
	n_brancos_em_ep  rural lixo_coleta eletricidade agua esgoto				/// 
	n_salas_utilizadas									///					
	diretoria sala_professores lab_info lab_ciencias ///
	quadra_esportes internet ///
	pib_capita_reais_real_2015 pop mais_educ, 	///
	by(cod_munic ano)

/*

. tab ice

 (mean) ice |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |     12,708       79.20       79.20
          1 |      3,337       20.80      100.00
------------+-----------------------------------
      Total |     16,045      100.00

. tab ice if ano==2003

 (mean) ice |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        985       79.18       79.18
          1 |        259       20.82      100.00
------------+-----------------------------------
      Total |      1,244      100.00

*/	
	
/*declarando painel*/



iis cod_munic
tis ano


/*----------Propensity Score----------*/


set matsize 10000

/*
gerando os propensity scores
a probabilidade condicional do município ter ice dado o número médio
de alunos  e taxa de participação do enem
o pscore vai ser calculado no ano em que o ice foi implementado no estado
*/

pscore ice n_alunos_em taxa_participacao_enem if ano == 2003 & codigo_uf	///	
	== 26, pscore(pscores_pe)

pscore ice n_alunos_em_ep taxa_participacao_enem if ano == 2007 & 			///
	codigo_uf==23, pscore(pscores_ce)

*pscore ice n_alunos_ef if ano==2010&codigo_uf==33, pscore(pscores_rj)
*Rj não tem ice ensino médio

pscore ice n_alunos_em taxa_participacao_enem if ano == 2011 & codigo_uf 	///
	== 35, pscore(pscores_sp)

pscore ice n_alunos_em taxa_participacao_enem if ano==2012&codigo_uf==52,	///
	pscore(pscores_go)


gen pscore_total=.

replace pscore_total=1 if ice==1

replace pscore_total=1/(1-pscores_pe) if codigo_uf==26&ice==0

replace pscore_total=1/(1-pscores_ce) if codigo_uf==23&ice==0

*replace pscore_total=1/(1-pscores_rj) if codigo_uf==33&ice==0
*Rj não tem ice ensino médio

replace pscore_total=1/(1-pscores_sp) if codigo_uf==35&ice==0

replace pscore_total=1/(1-pscores_go) if codigo_uf==52&ice==0

bysort cod_munic: egen pscore_total_aux=max(pscore_total)
replace pscore_total=pscore_total_aux
/*----------padronização de notas e variáveis fluxo----------*/

/*
para os anos que haviam quatro cadernos do enem, 
consolidar em uma nota média para a prova inteira
*/

gen enem_nota_objetivab=(enem_nota_matematica + enem_nota_ciencias + ///
	enem_nota_humanas+enem_nota_linguagens)/4

/*for each que gerará a nota padronizada e variável de fluxo padronizada
por cidade , padronizando no estado*/

foreach xx in 26 23 35 52 {

/*gerando as variáveis  padronizadas no estado */
foreach x in "enem_nota_matematica" "enem_nota_ciencias"			///
	"enem_nota_humanas" "enem_nota_linguagens" "apr_em" "rep_em" 	///
	"aba_em" "dist_em" {
egen `x'_std_`xx'=std(`x') if codigo_uf==`xx'
}

foreach a in 2003 2004 2005 2006 2007 2008 {
egen enem_nota_red_std_aux_`a'_`xx'=std(enem_nota_redacao) if 		///
	ano==`a' & codigo_uf==`xx'
}
egen enem_nota_red_std_`xx'=std(enem_nota_redacao) if ano>=2009 & 	///
	codigo_uf==`xx'

foreach a in 2003 2004 2005 2006 2007 2008 {
replace enem_nota_red_std_`xx'=enem_nota_red_std_aux_`a'_`xx' if	///
	ano==`a' & codigo_uf==`xx'
}

foreach a in 2003 2004 2005 2006 2007 2008 {
	egen enem_nota_ob_std_aux_`a'_`xx'=std(enem_nota_objetiva) if 	///
	ano==`a' & codigo_uf==`xx'
}


egen enem_nota_ob_std_`xx'=std(enem_nota_objetivab) if ano>=2009 & 	///
	codigo_uf==`xx'

foreach a in 2003 2004 2005 2006 2007 2008 {
	replace enem_nota_ob_std_`xx'=enem_nota_ob_std_aux_`a'_`xx' if	///
	ano==`a'& codigo_uf==`xx'
}


}

local controles  concluir_em_ano_enem e_mora_mais_de_6_pessoas e_escol_sup_pai	///
	e_escol_sup_mae e_renda_familia_5_salarios e_trabalhou_ou_procurou predio 	///
	diretoria sala_professores lab_info lab_ciencias quadra_esportes internet 	///
	rural lixo_coleta eletricidade agua esgoto n_salas_utilizadas				///
	n_alunos_em_ep pib_capita_reais_real_2015 pop mais_educ



/*----------resultado e estimações por estado----------*/
foreach xx in 26 23 35 52 {
foreach x in  "apr_em_std" "rep_em_std" "aba_em_std" "dist_em_std" {


***Controlando por demais carateristicas da escola 
xtreg `x'_`xx' m_tem_ice_nota d_ano* `controles' [pw=pscore_total], fe 
outreg2 using "$output/ICE_resultados_spillover_uf_new.xls", excel append label ctitle(`x', `xx') 

}
}
*/
