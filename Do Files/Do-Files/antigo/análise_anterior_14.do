
	*--------------------------------------------------------------------------*				
	*								Load Data
	*--------------------------------------------------------------------------*			
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
global Folder "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\bases da análise anterior"
global output "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\bases da análise anterior"
global Bases "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\bases da análise anterior"
global dofiles "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\Do-Files\"
global Logfolder "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\bases da análise anterior"


global folderservidor "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"

log using "$Logfolder/em_análise_anterior.log", replace
	use "$Folder/ice_clean.dta", clear

	* Painel
	iis codigo_escola
	tis ano

	*Dropar RJ
	drop if codigo_uf==33

	* Gerar pscores
	do "$dofiles/em_pscore_14.do"

	* Interacoees de turno e alavancas
	do "$dofiles/turno_alavanca_14.do"

	* Padronizar
	do "$dofiles/em_padronizar_notas_14.do"

	*drop pb_* mais_educacao_* al_* *_aux_*

	*---------------------------------------------------------------------------
	*									Resultados Gerais                      *
	*---------------------------------------------------------------------------

	local controles e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria ///
	n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep  rural agua eletricidade ///
	esgoto lixo_coleta sala_professores  lab_info lab_ciencias quadra_esportes biblioteca  ///
	 internet

	foreach outcome in "enem_nota_matematica" "enem_nota_ciencias" "enem_nota_humanas" ///
	"enem_nota_linguagens" "enem_nota_redacao" "enem_nota_objetivab" {


	*Controlando por carateristicas dos alunos e da escola 
	*------------------------------------------------------

		* Ensino médio geral

		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] if dep!=4  , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_new.xls", excel replace label ctitle(`outcome', controle pub, tudo) 

		* Ensino médio integral
		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] if dep!=4 &(integral==1|ice==0) , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_new.xls", excel append label ctitle(`outcome', controle pub, integral) 

		*Integral vs Semi-Integral
		xtreg  `outcome'_std d_ice d_ice_inte d_ano* `controles' [pw=pscore_total] if dep!=4 , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_new.xls", excel append label ctitle(`outcome', controle pub) 
		lincom d_ice + d_ice_inte 



}

	*---------------------------------------------------------------------------
	* 							Resultados cumulativos						   *
	*---------------------------------------------------------------------------

	local controles e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria ///
	n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep rural agua eletricidade ///
	esgoto lixo_coleta sala_professores  lab_info lab_ciencias quadra_esportes biblioteca ///
	internet
	gen tempo=.

replace tempo=0 if ano==ano_ice-6
replace tempo=1 if ano==ano_ice-5
replace tempo=2 if ano==ano_ice-4
replace tempo=3 if ano==ano_ice-3 
replace tempo=4 if ano==ano_ice-2
replace tempo=5 if ano==ano_ice-1
replace tempo=6 if ano==ano_ice
replace tempo=7 if ano==ano_ice+1 
replace tempo=8 if ano==ano_ice+2
replace tempo=9 if ano==ano_ice+3
replace tempo=10 if ano==ano_ice+4
replace tempo=11 if ano==ano_ice+5
replace tempo=12 if ano==ano_ice+6


iis codigo_escol
tis tempo

tab tempo, gen(d_tempo)

gen d_ice1=ice*d_tempo1
gen d_ice2=ice*d_tempo2
gen d_ice3=ice*d_tempo3
gen d_ice4=ice*d_tempo4
gen d_ice5=ice*d_tempo5
gen d_ice6=ice*d_tempo6
gen d_ice7=d_ice*d_tempo7
gen d_ice8=d_ice*d_tempo8
gen d_ice9=d_ice*d_tempo9
gen d_ice10=d_ice*d_tempo10
gen d_ice11=d_ice*d_tempo11
gen d_ice12=d_ice*d_tempo12
gen d_ice13=d_ice*d_tempo13

	foreach outcome in "enem_nota_objetivab" {
		*Acumulado
		xtreg  `outcome'_std  d_ice1 d_ice2 d_ice3 d_ice4 d_ice5 d_ice6 d_ice7 d_ice8 d_ice9 d_ice10 d_ice11 d_ice12 d_ice13 ///
			d_ano* `controles' [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2| tempo==3| ///
	tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 |tempo==10|tempo==11|tempo==12 ) , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_cum_em_new.xls", excel replace label ctitle(`outcome', 9 anos) 


	}

	
	
	

	use "$Folder/ice_clean_fluxo.dta", clear

	* Painel
	iis codigo_escola
	tis ano

	*Dropar RJ
	drop if codigo_uf==33

	* Gerar pscores
	do "$dofiles/em_pscore_14.do"

	* Interacoees de turno e alavancas
	do "$dofiles/turno_alavanca_14.do"

	* Padronizar
	do "$dofiles/em_padronizar_notas_14.do"

	*drop pb_* mais_educacao_* al_* *_aux_*

	*---------------------------------------------------------------------------
	*									Resultados Gerais                      *
	*---------------------------------------------------------------------------
	
	local controles e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios ///
		e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep ///
		rural agua eletricidade esgoto lixo_coleta sala_professores  lab_info ///
		lab_ciencias quadra_esportes biblioteca   internet

	foreach outcome in "apr_em" "rep_em" "aba_em" "dist_em" {
	
	*---------------------------------------------------------------------------
	*			Controlando por carateristicas dos alunos e da escola 
	*---------------------------------------------------------------------------

		* Ensino médio geral
		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] if dep!=4, ///
			fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_new.xls", ///
			excel append label ctitle(`outcome', controle pub, tudo) 

		* Ensino médio integral
		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] if dep!=4 ///
			&(integral==1|ice==0) , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_new.xls", ///
			excel append label ctitle(`outcome', controle pub, integral) 

		*Integral vs Semi-Integral
		xtreg  `outcome'_std d_ice d_ice_inte d_ano* `controles' [pw=pscore_total] ///
			if dep!=4 , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_new.xls", ///
			excel append label ctitle(`outcome', controle pub) 
		lincom d_ice + d_ice_inte 

	}

	********************************************************************************
	* 							Resultados cumulativos							   *
	********************************************************************************
	gen tempo =.
replace tempo=0 if ano==ano_ice-6
replace tempo=1 if ano==ano_ice-5
replace tempo=2 if ano==ano_ice-4
replace tempo=3 if ano==ano_ice-3 
replace tempo=4 if ano==ano_ice-2
replace tempo=5 if ano==ano_ice-1
replace tempo=6 if ano==ano_ice
replace tempo=7 if ano==ano_ice+1 
replace tempo=8 if ano==ano_ice+2
replace tempo=9 if ano==ano_ice+3
replace tempo=10 if ano==ano_ice+4
replace tempo=11 if ano==ano_ice+5
replace tempo=12 if ano==ano_ice+6


iis codigo_escol
tis tempo

tab tempo, gen(d_tempo)

gen d_ice1=ice*d_tempo1
gen d_ice2=ice*d_tempo2
gen d_ice3=ice*d_tempo3
gen d_ice4=ice*d_tempo4
gen d_ice5=ice*d_tempo5
gen d_ice6=ice*d_tempo6
gen d_ice7=d_ice*d_tempo7
gen d_ice8=d_ice*d_tempo8
gen d_ice9=d_ice*d_tempo9
gen d_ice10=d_ice*d_tempo10
gen d_ice11=d_ice*d_tempo11
gen d_ice12=d_ice*d_tempo12
gen d_ice13=d_ice*d_tempo13


	foreach outcome in "apr_em" "rep_em" "aba_em" "dist_em" {
		*Acumulado
		xtreg  `outcome'_std  d_ice1 d_ice2 d_ice3 d_ice4 d_ice5 d_ice6 d_ice7 d_ice8 d_ice9 d_ice10 d_ice11 d_ice12 d_ice13 ///
			  d_ano* `controles' [pw=pscore_total] if (tempo==0|tempo==1|tempo==2| tempo==3| ///
	tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 |tempo==10|tempo==11|tempo==12 ) , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_cum_em_new.xls", excel append label ctitle(`outcome', 9 anos) 


	}


log close


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
bysort codigo_municipio_novo ano: egen n_com_ice = sum (d_ice)


*dropando escolas sem cod_munic, ie só com info de fluxo e sem info de enem
drop if codigo_municipio_novo ==.
/*
gera dummy se o município tem escola ice integral
*/
gen m_tem_ice = 0
replace m_tem_ice= 1 if n_com_ice > 0
*(21,864 real changes made)



/* gera por municipio, uma variável que é a soma das dummies ice_inte
isto é, n_com_ice2 é a soma de escolas ice integrais ao longo do tempo*/
bysort codigo_municipio_novo: egen n_com_ice2 = sum (ice_inte2)


/*gera dummy se municipio teve ice integral*/
gen m_teve_ice = 0
replace m_teve_ice = 1 if n_com_ice2 > 0
drop ice
rename m_teve_ice ice


/*dropando as escolas que tiveram ice */
drop if d_ice == 1

/*dropando se é escola privada*/
drop if dep == 4	


/*colapsando em município e em ano*/

collapse (mean) ice codigo_uf taxa_participacao_enem 						///
	enem_nota_matematica enem_nota_ciencias enem_nota_humanas 				///
	enem_nota_linguagens enem_nota_redacao enem_nota_objetiva				///
	apr_em rep_em aba_em dist_em											///
	m_tem_ic d_ano* e_escol_sup_pai e_escol_sup_mae 	///
	e_renda_familia_5_salarios e_mora_mais_de_6_pessoas						///
		concluir_em_ano_enem predio						/// 
	n_alunos_em_ep 				///
	  rural lixo_coleta eletricidade agua esgoto				/// 
	n_salas_utilizadas									///					
	diretoria sala_professores lab_info lab_ciencias ///
	quadra_esportes internet ///
	, 	///
	by(codigo_municipio_novo ano)

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



iis codigo_municipio_novo
tis ano
/*----------Propensity Score----------*/

set matsize 10000

local controles_pscore  concluir_em_ano_enem e_mora_mais_de_6_pessoas e_escol_sup_pai	///
	e_escol_sup_mae e_renda_familia_5_salarios  predio 	///
	diretoria sala_professores lab_info lab_ciencias quadra_esportes internet		 ///
	rural lixo_coleta eletricidade agua  esgoto n_salas_utilizadas					///
	n_alunos_em_ep

	
pscore ice n_alunos_em_ep `controles_pscore' if ano == 2003, pscore(pscores_todos)

gen pscore_total = .

replace pscore_total = 1 if ice==1

replace pscore_total = 1 / (1-pscores_todos) if ice == 0

bysort codigo_municipio_novo: egen pscore_total_aux=max(pscore_total)
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



local controles  concluir_em_ano_enem e_mora_mais_de_6_pessoas e_escol_sup_pai	///
	e_escol_sup_mae e_renda_familia_5_salarios  predio 	///
	diretoria sala_professores lab_info lab_ciencias quadra_esportes internet 	///
	rural lixo_coleta eletricidade agua esgoto n_salas_utilizadas				///
	 
	
	/*
xtreg para as variáveis da prova brasil padronizadas
com controles de escola
*/

xtreg enem_nota_objetivab_std m_tem_ice d_ano* `controles' [pw=pscore_total], ///
		fe  vce(rob)
outreg2 using "$output/em_spillover.xls", excel replace label ctitle(enem_nota_objetivab, fe  uf)

foreach x in "enem_nota_matematica"  "enem_nota_redacao"   "enem_nota_ciencias" "enem_nota_humanas" ///
	"enem_nota_linguagens" {
	xtreg `x'_std m_tem_ice d_ano* `controles' [pw=pscore_total], ///
		fe vce(rob)
	outreg2 using "$output/em_spillover.xls",			///
		excel append label ctitle(`x', fe  uf) 

}

foreach x in "apr_em" "rep_em" "aba_em" "dist_em" {
	xtreg `x'_std m_tem_ice d_ano* `controles' [pw=pscore_total], ///
		fe vce(rob)
	outreg2 using "$output/em_spillover.xls",			///
		excel append label ctitle(`x', fe  uf) 

}


log close
