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
xtset codigo_escola ano
xtdescribe

local estado d_uf*


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
	n_alunos_em_ep pib_capita_reais_real_2015 pop mais_educ taxa_participacao_enem

global controles_pscore  concluir_em_ano_enem e_mora_mais_de_6_pessoas e_escol_sup_pai	///
	e_escol_sup_mae e_renda_familia_5_salarios e_trabalhou_ou_procurou predio 	///
	diretoria sala_professores lab_info lab_ciencias quadra_esportes internet		 ///
	rural lixo_coleta eletricidade agua  esgoto n_salas_utilizadas					///
	n_alunos_em_ep pib_capita_reais_real_2015 pop mais_educ taxa_participacao_enem

	
keep $estado $alavancas_fluxo $alavancas_fluxo_todas $alavancas_nota_todas ///
$controles ///
ice ice_inte codigo_escola ano ano_ice taxa_participacao_enem ///
codigo_uf dep cod_meso /// 
apr_em_std rep_em_std aba_em_std dist_em_std ///
enem_nota_matematica_std  enem_nota_ciencias_std /// 
enem_nota_humanas_std enem_nota_linguagens_std  ///
enem_nota_redacao_std enem_nota_objetivab_std  ///
d_ice_nota d_ano* d_ice_nota_semi_inte 	
	
foreach x in $controles {
drop if `x'==.

}



by codigo_escola, sort: gen nvals = _n == 1
count if nvals


xtreg enem_nota_objetivab_std d_ice_nota d_ano* `controles' `estado'  , fe rob
sum $controles_pescore if e(sample)
bys codigo_escola: sum $controles_pescore if e(sample)

drop if enem_nota_objetivab_std==.& enem_nota_redacao_std==.& dist_em_std==.& aba_em_std==.& rep_em_std==.& apr_em_std==.& enem_nota_linguagens_std==.& enem_nota_humanas_std==.& enem_nota_ciencias_std==.& enem_nota_matematica_std==.


bys  codigo_escola: gen nyears=_N

drop if nyears<13


count if nvals

count if ice==1&ano==2003
/*
tabstat `outcomes' `controles' if ano ==2003, by(ice) stat(mean sd) 
tabstat `outcomes' `controles' if ano ==2004, by(ice) stat(mean sd) 
tabstat `outcomes' `controles' if ano ==2005, by(ice) stat(mean sd) 
tabstat `outcomes' `controles' if ano ==2006, by(ice) stat(mean sd) 
tabstat `outcomes' `controles' if ano ==2007, by(ice) stat(mean sd) 
tabstat `outcomes' `controles' if ano ==2008, by(ice) stat(mean sd) 
tabstat `outcomes' `controles' if ano ==2009, by(ice) stat(mean sd) 
tabstat `outcomes' `controles' if ano ==2010, by(ice) stat(mean sd) 
tabstat `outcomes' `controles' if ano ==2011, by(ice) stat(mean sd) 
tabstat `outcomes' `controles' if ano ==2012, by(ice) stat(mean sd) 
tabstat `outcomes' `controles' if ano ==2013, by(ice) stat(mean sd) 
tabstat `outcomes' `controles' if ano ==2014, by(ice) stat(mean sd) 
tabstat `outcomes' `controles' if ano ==2015, by(ice) stat(mean sd) 


tabstat $outcomes  if ano ==2003, by(ice) stat(mean sd) 
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
*/



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



collapse  (mean) ice $outcomes $controles, by(codigo_escola)


foreach x in $controles {
ttest `x', by(ice)
mean `x'
}


ttest 

/*
teffects ipw (enem_nota_objetivab_std) (ice $controles_pscore,probit)  if ano==2003,  osample(newvar)
drop if newvar==1

drop newvar
teffects ipw (enem_nota_objetivab_std) (ice $controles_pscore, probit)  if ano==2003
 tebalance overid, nolog
 */
/*
geraremos um pscore, ie, a probabilidade condicional de receber o tratamento, 
dado características predeterminadas
no nosso caso, será estimada a probabilidade cond de determinada
escola receber tratamento ice, dado o número de alunos

pscore treatment [varlist] [weight] [if exp] [in range] , pscore(newvar) [ 
blockid(newvar) detail logit comsup level(#) numblo(#) ]
ver https://www.stata-journal.com/sjpdf.html?articlenum=st0026
*/

*note que estamos fazendo o propensity score por estado e no ano em que a primeira escola foi tratada no estado
set matsize 10000

//mdesc `controles_pscore' taxa_participacao_enem if ano ==2003

local estado d_uf*



pscore ice `controles_pscore'  if ano == 2003, pscore(pscores_todos)

/*
pscore ice `controles_pscore' taxa_participacao_enem if ano==2003&codigo_uf==26&dep!=4, pscore(pscores_pe)

pscore ice `controles_pscore' taxa_participacao_enem if ano==2007&codigo_uf==23&dep!=4, pscore(pscores_ce)

pscore ice `controles_pscore' taxa_participacao_enem if ano==2011&codigo_uf==35&dep!=4, pscore(pscores_sp)

pscore ice `controles_pscore' taxa_participacao_enem if ano==2012&codigo_uf==52&dep!=4, pscore(pscores_go)


*/


drop pscore_total

gen pscore_total=.

replace pscore_total = 1 / pscores_todos if ice == 1
replace pscore_total = 1 /(1-pscores_todos) if ice==0
/*
gen pscore_total_estado=.
replace pscore_total_estado = 1 if ice == 1


replace pscore_total_estado=1/(1-pscores_pe) if codigo_uf==26&dep!=4&ice==0

replace pscore_total_estado=1/(1-pscores_ce) if codigo_uf==23&dep!=4&ice==0

replace pscore_total_estado=1/(1-pscores_sp) if codigo_uf==35&dep!=4&ice==0

replace pscore_total_estado=1/(1-pscores_go) if codigo_uf==52&dep!=4&ice==0
*/
*For each category of codigo_escola, generate pscore_total_aux = maximo do pscore_total
*sort arranges the observations of the current data into ascending order
/*
aqui, o propesnity score de cada escola tem que ser equalizado para rodar
o xtreg. isto é, cada escola, ao longo dos anos, tem que ter o mesmo pscore
assim, o max do pscore ao longo dos anos é atribuído como pscore da escola
*/
bysort codigo_escola: egen pscore_total_aux = max(pscore_total)
replace pscore_total = pscore_total_aux

local controles  concluir_em_ano_enem e_mora_mais_de_6_pessoas e_escol_sup_pai	///
	e_escol_sup_mae e_renda_familia_5_salarios e_trabalhou_ou_procurou predio 	///
	diretoria sala_professores lab_info lab_ciencias quadra_esportes internet 	///
	rural lixo_coleta eletricidade agua esgoto n_salas_utilizadas				///
	n_alunos_em_ep pib_capita_reais_real_2015 pop mais_educ taxa_participacao_enem
foreach x of local controles{
	gen `x'_pond = `x'/ pscore_total
}

local controles_pond concluir_em_ano_enem_pond e_mora_mais_de_6_pessoas_pond 	///
e_escol_sup_pai_pond e_escol_sup_mae_pond e_renda_familia_5_salarios_pond ///
 e_trabalhou_ou_procurou_pond  predio_pond  	///
	diretoria_pond  sala_professores_pond  lab_info_pond  lab_ciencias_pond  quadra_esportes_pond  internet_pond  	///
	rural_pond  lixo_coleta_pond  eletricidade_pond  agua_pond  esgoto_pond ///
	n_salas_utilizadas_pond taxa_participacao_enem_pond				///
	n_alunos_em_ep_pond  pib_capita_reais_real_2015_pond  pop_pond  mais_educ_pond 

	
	tabstat `controles_pond' if ano ==2003, by(ice) stat(mean sd) 
	
	/*
logit treat $xvars
predit pi, p
gen ipw=1
replace ipw=1/pi if treat==1
replace ipw 1/(1-pi) if treat==0

the use them as pweights

[pw=ipw]
*/
local controles_pscore  concluir_em_ano_enem e_mora_mais_de_6_pessoas e_escol_sup_pai	///
	e_escol_sup_mae e_renda_familia_5_salarios e_trabalhou_ou_procurou predio 	///
	diretoria sala_professores lab_info lab_ciencias quadra_esportes internet		 ///
	rural lixo_coleta eletricidade agua  esgoto n_salas_utilizadas					///
	n_alunos_em_ep pib_capita_reais_real_2015 pop mais_educ
logit ice `controles_pscore' taxa_participacao_enem if ano == 2003
predict pi_logit, p
gen ipw_logit=.
replace ipw_logit=1/pi_logit if ice==1
replace ipw_logit=1/(1-pi_logit) if ice==0	

probit ice `controles_pscore' taxa_participacao_enem if ano == 2003
predict pi_probit, p
gen ipw_probit=.
replace ipw_probit=1/pi_probit if ice==1
replace ipw_probit=1/(1-pi_probit) if ice==0

pscore ice `controles_pscore' taxa_participacao_enem if ano == 2003, pscore(pscores_todos)
gen pscore_total=.

replace pscore_total = 1 / pscores_todos if ice == 1
replace pscore_total = 1 /(1-pscores_todos) if ice==0


bysort codigo_escola: egen pscore_total_aux = max(pscore_total)
replace pscore_total = pscore_total_aux


local controles  concluir_em_ano_enem e_mora_mais_de_6_pessoas e_escol_sup_pai	///
	e_escol_sup_mae e_renda_familia_5_salarios e_trabalhou_ou_procurou predio 	///
	diretoria sala_professores lab_info lab_ciencias quadra_esportes internet 	///
	rural lixo_coleta eletricidade agua esgoto n_salas_utilizadas				///
	n_alunos_em_ep pib_capita_reais_real_2015 pop mais_educ taxa_participacao_enem
foreach x of local controles{
	gen `x'_pond = `x'* pscore_total
}

local controles_pond concluir_em_ano_enem_pond e_mora_mais_de_6_pessoas_pond 	///
e_escol_sup_pai_pond e_escol_sup_mae_pond e_renda_familia_5_salarios_pond ///
 e_trabalhou_ou_procurou_pond  predio_pond  	///
	diretoria_pond  sala_professores_pond  lab_info_pond  lab_ciencias_pond  quadra_esportes_pond  internet_pond  	///
	rural_pond  lixo_coleta_pond  eletricidade_pond  agua_pond  esgoto_pond ///
	n_salas_utilizadas_pond taxa_participacao_enem_pond				///
	n_alunos_em_ep_pond  pib_capita_reais_real_2015_pond  pop_pond  mais_educ_pond 

	
	tabstat `controles_pond' if ano ==2003, by(ice) stat(mean sd) 


local controles  concluir_em_ano_enem e_mora_mais_de_6_pessoas e_escol_sup_pai	///
	e_escol_sup_mae e_renda_familia_5_salarios e_trabalhou_ou_procurou predio 	///
	diretoria sala_professores lab_info lab_ciencias quadra_esportes internet 	///
	rural lixo_coleta eletricidade agua esgoto n_salas_utilizadas				///
	n_alunos_em_ep pib_capita_reais_real_2015 pop mais_educ taxa_participacao_enem

teffects ipw (enem_nota_objetivab_std) (ice `controles' , probit) if ano==2003, osample()
local controles  concluir_em_ano_enem e_mora_mais_de_6_pessoas e_escol_sup_pai	///
	e_escol_sup_mae e_renda_familia_5_salarios e_trabalhou_ou_procurou predio 	///
	diretoria sala_professores lab_info lab_ciencias quadra_esportes internet 	///
	rural lixo_coleta eletricidade agua esgoto n_salas_utilizadas				///
	n_alunos_em_ep pib_capita_reais_real_2015 pop mais_educ taxa_participacao_enem

tebalance overid `controles', nolog


teffects ipw (enem_nota_objetivab_std) (ice `controles' , probit) if ano==2015, osample()
tebalance overid, nolog
