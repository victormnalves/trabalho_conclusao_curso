
*em alavancas

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



log using "$Logfolder/em_ps_alavancas_pca.log", replace


use "$folderservidor\em_com_censo_escolar_14.dta", clear
replace ice=0 if ice ==.
xtset codigo_escola ano
/*
como o tratamento não é aleatório, precisamos usar alguma metodologia para fazer 
a análise do programa. Aqui, vamos calcular os propensity scores, para fazer 
regressões em painel ponderadas
*/

set matsize 10000

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

local controles_pscore  concluir_em_ano_enem e_mora_mais_de_6_pessoas e_escol_sup_pai	///
	e_escol_sup_mae e_renda_familia_5_salarios e_trabalhou_ou_procurou predio 	///
	diretoria sala_professores lab_info lab_ciencias quadra_esportes internet		 ///
	rural lixo_coleta eletricidade agua  esgoto n_salas_utilizadas					///
	n_alunos_em_ep pib_capita_reais_real_2015 pop mais_educ
//mdesc `controles_pscore' taxa_participacao_enem if ano ==2003

local estado d_uf*



pscore ice `controles_pscore' taxa_participacao_enem if ano == 2003, pscore(pscores_todos)

/*
pscore ice `controles_pscore' taxa_participacao_enem if ano==2003&codigo_uf==26&dep!=4, pscore(pscores_pe)

pscore ice `controles_pscore' taxa_participacao_enem if ano==2007&codigo_uf==23&dep!=4, pscore(pscores_ce)

pscore ice `controles_pscore' taxa_participacao_enem if ano==2011&codigo_uf==35&dep!=4, pscore(pscores_sp)

pscore ice `controles_pscore' taxa_participacao_enem if ano==2012&codigo_uf==52&dep!=4, pscore(pscores_go)


*/




gen pscore_total=.

replace pscore_total = 1 if ice == 1
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
/*
bysort codigo_escola: egen pscore_total_estado_aux = max(pscore_total_estado)
replace pscore_total_estado = pscore_total_estado_aux
*/
/*
In -xt- analyses, the weight must be constant within panels
o pscore_total será usado como peso weight no xtreg 
*/

/*
apr_em_std rep_em_std aba_em_std dist_em_std 
enem_nota_matematica_std  enem_nota_ciencias_std 
enem_nota_humanas_std enem_nota_linguagens_std 
enem_nota_redacao_std enem_nota_objetivab_std
*/
gen alavanca_politica =.
gen alavanca_selecao =.
pca al_engaj_gov al_engaj_sec al_time_seduc al_marcos_lei al_todos_marcos al_sel_dir al_sel_prof al_proj_vida
foreach i in 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015{
pca al_engaj_gov al_engaj_sec al_time_seduc al_marcos_lei al_todos_marcos al_sel_dir al_sel_prof al_proj_vida if ano ==`i'
predict pc1 pc2, score 

replace alavanca_politica = pc1 if ano ==`i'
replace alavanca_selecao = pc2 if ano ==`i'
drop pc1 pc2
}





local alavancas_fluxo d_ice_fluxo_al1 d_ice_fluxo_al2 d_ice_fluxo_al3 d_ice_fluxo_al4 d_ice_fluxo_al5 d_ice_fluxo_al6 d_ice_fluxo_al7 d_ice_fluxo_al8 
local alavancas_fluxo_todas d_ice_fluxo_al1 d_ice_fluxo_al2 d_ice_fluxo_al3 d_ice_fluxo_al4 d_ice_fluxo_al5 d_ice_fluxo_al6 d_ice_fluxo_al7 d_ice_fluxo_al8 d_ice_fluxo_al9
local alavancas_nota d_ice_nota_al1 d_ice_nota_al2 d_ice_nota_al3 d_ice_nota_al4 d_ice_nota_al5 d_ice_nota_al6 d_ice_nota_al7 d_ice_nota_al8 
local alavancas_nota_todas d_ice_nota_al1 d_ice_nota_al2 d_ice_nota_al3 d_ice_nota_al4 d_ice_nota_al5 d_ice_nota_al6 d_ice_nota_al7 d_ice_nota_al8 d_ice_nota_al9
local controles  concluir_em_ano_enem e_mora_mais_de_6_pessoas e_escol_sup_pai	///
	e_escol_sup_mae e_renda_familia_5_salarios e_trabalhou_ou_procurou predio 	///
	diretoria sala_professores lab_info lab_ciencias quadra_esportes internet 	///
	rural lixo_coleta eletricidade agua esgoto n_salas_utilizadas				///
	n_alunos_em_ep pib_capita_reais_real_2015 pop mais_educ


xtreg enem_nota_objetivab_std d_ice_nota d_ano* `controles' `estado' `alavancas_nota' [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "$output/ ICE_em_ps_alavancas.xls", excel replace label ctitle(enem objetiva, fe cluster estado ps, alavancas)

xtreg enem_nota_objetivab_std d_ice_nota d_ano* `controles' `estado' alavanca_politica alavanca_selecao d_ice_nota_al8 [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "$output/ ICE_em_ps_alavancas.xls", excel append label ctitle(enem objetiva, fe cluster estado ps, alavancas)


xtreg enem_nota_matematica_std d_ice_nota d_ano* `controles' `estado' `alavancas_nota'  [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "$output/ ICE_em_ps_alavancas.xls", excel append label ctitle(matematica, fe cluster estado ps, alavancas)

xtreg enem_nota_matematica_std d_ice_nota d_ano* `controles' `estado' alavanca_politica alavanca_selecao d_ice_nota_al8 [pw=pscore_total] , fe cluster(codigo_uf)
outreg2 using "$output/ ICE_em_ps_alavancas.xls", excel append label ctitle(matematica, fe cluster estado ps, alavancas todas)

xtreg enem_nota_redacao_std d_ice_nota  d_ano*  `controles' `estado' `alavancas_nota' [pw=pscore_total] , fe cluster(codigo_uf)
outreg2 using "$output/ ICE_em_ps_alavancas.xls", excel append label ctitle(redacao, fe cluster estado ps, alavancas)

xtreg enem_nota_redacao_std d_ice_nota  d_ano*  `controles' `estado' alavanca_politica alavanca_selecao d_ice_nota_al8 [pw=pscore_total] , fe cluster(codigo_uf)
outreg2 using "$output/ ICE_em_ps_alavancas.xls", excel append label ctitle(redacao, fe cluster estado, alavancas_todas)



xtreg apr_em_std d_ice_fluxo d_ano*  `controles' `estado' `alavancas_fluxo' [pw=pscore_total] , fe cluster(codigo_uf)
outreg2 using "$output/ ICE_em_ps_alavancas.xls", excel append label ctitle(aprovacao, fe cluster estado ps, alavancas)

xtreg apr_em_std d_ice_fluxo d_ano*  `controles' `estado' alavanca_politica alavanca_selecao d_ice_nota_al8 [pw=pscore_total] , fe cluster(codigo_uf)
outreg2 using "$output/ ICE_em_ps_alavancas.xls", excel append label ctitle(aprovacao, fe cluster estado ps, alavancas todas)


xtreg rep_em_std d_ice_fluxo d_ano* `controles' `estado' `alavancas_fluxo' [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "$output/ ICE_em_ps_alavancas.xls", excel append label ctitle(reprovacao, fe cluster estado ps, alavancas)

xtreg rep_em_std d_ice_fluxo d_ano* `controles' `estado' alavanca_politica alavanca_selecao d_ice_nota_al8 [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "$output/ ICE_em_ps_alavancas.xls", excel append label ctitle(reprovacao, fe cluster estado ps, alavancas todas)


xtreg aba_em_std d_ice_fluxo d_ano* `controles' `estado' `alavancas_fluxo' [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "$output/ ICE_em_ps_alavancas.xls", excel append label ctitle(abandono, fe cluster estado ps, alavancas)

xtreg aba_em_std d_ice_fluxo d_ano* `controles' `estado' alavanca_politica alavanca_selecao d_ice_nota_al8 [pw=pscore_total] , fe cluster(codigo_uf)
outreg2 using "$output/ ICE_em_ps_alavancas.xls", excel append label ctitle(abandono, fe cluster estado ps, alavancas todas)

