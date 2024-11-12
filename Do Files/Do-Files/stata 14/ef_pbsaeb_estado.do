/*
Análise
3. ICE e SAEB/PB 
e. por estados

*/
*------------------------------------------------------------------------------
********************************************************************************
*********************************** 3. ICE e SAEB/PB ******************************
********************************************************************************
/*------------------------------------------------------------------------------
a base de dados final para análise de impacto em nota é ice_clean.dta
*/

clear all
set more off
*cd "`:environment USERPROFILE'\OneDrive\EESP - ECONOMIA - mestrado acadêmico\Dissertação\ICE\dados ICE"
global user "`:environment USERPROFILE'"
global Folder "$user/OneDrive/EESP_ECONOMIA_mestrado_acadêmico/Dissertação/ICE/dados_ICE/Análise_Leonardo"
global output "$Folder/resultados"
global Bases "$Folder/Bases"

use "$Bases/ice_clean.dta", clear
*use "$Bases/ice_clean13.dta", clear
set matsize 10000


/* 
é uma análise em painel. 
Para tal, vamos definir as variáveis de 
tempo e observação
*/
iis codigo_escola
tis ano

/*
mantando somente as escolas fundamentas para análise
e as escolas ou do estado do rio (33) ou de ce (23) ou de pe (26)
*/

	keep if codigo_uf==33|codigo_uf==35|codigo_uf==23|codigo_uf==26

	drop if ice_seg=="EM"

/*
se a escola não for ensino fundamental, não considera como tratado
(para esta análise especifica sobre efeito na pb/saeb
*/
replace ice=0 if ensino_fundamental==0


*********************************** 3a. Propensity scores ***********************
/*
como o tratamento não é aleatório, precisamos usar alguma metodologia para fazer 
a análise do programa. Aqui, vamos calcular os propensity scores, para fazer 
regressões em painel ponderadas
*/

set matsize 5000

/*
geraremos um pscore, ie, a probabilidade condicional de receber o tratamento, 
dado características predeterminadas
no nosso caso, será estimada a probabilidade cond de determinada
escola receber tratamento ice, dado o número de alunos

pscore treatment [varlist] [weight] [if exp] [in range] , pscore(newvar) [ 
blockid(newvar) detail logit comsup level(#) numblo(#) ]
ver https://www.stata-journal.com/sjpdf.html?articlenum=st0026
*/

/*
gerando um pscore para cada escola, por estado
probabilidade de ser tratado dado número de alunos eno ensino médio e taxa de participação
gerando para cada estado
aqui, condicional em numero de alunos e taxa de participação de alunos, a participação do ice é 
independente
*/

*pscore ice n_alunos_em taxa_participacao_enem  if ano==2003&codigo_uf==26&dep!=4, pscore(pscores_pe)

*pscore ice n_alunos_em_ep taxa_participacao_enem  if ano==2007&codigo_uf==23&dep!=4, pscore(pscores_ce)

pscore ice n_alunos_ef taxa_participacao_pb  if ano==2009&codigo_uf==33&dep!=4, pscore(pscores_rj)

pscore ice n_alunos_ef taxa_participacao_pb   if ano==2011&codigo_uf==35&dep!=4, pscore(pscores_sp)

*pscore ice n_alunos_em taxa_participacao_enem if ano==2012&codigo_uf==52&dep!=4, pscore(pscores_go)


gen pscore_total=.

/*
probabilidade de ser tratado é 1 se foi tratado
*/

replace pscore_total = 1 if ice == 1

/*o propensity score de cada escola em cada ano vai ser um um peso com base no 
propensity score criado anteriormente*/

*replace pscore_total=1/(1-pscores_pe) if codigo_uf==26&dep!=4&ice==0

*replace pscore_total=1/(1-pscores_ce) if codigo_uf==23&dep!=4&ice==0

replace pscore_total=1/(1-pscores_rj) if codigo_uf==33&dep!=4&ice==0

replace pscore_total=1/(1-pscores_sp) if codigo_uf==35&dep!=4&ice==0

*replace pscore_total=1/(1-pscores_go) if codigo_uf==52&dep!=4&ice==0

*For each category of codigo_escola, generate pscore_total_aux = maximo do pscore_total
*sort arranges the observations of the current data into ascending order
/*
aqui, o propesnity score de cada escala tem que ser equalizado para rodar
o xtreg. isto é, cada escola, ao longo dos anos, tem que ter o mesmo pscore
assim, o max do pscore ao longo dos anos é atribuído como pscore da escola
*/

bysort codigo_escola: egen pscore_total_aux=max(pscore_total)
replace pscore_total=pscore_total_aux

/*
In -xt- analyses, the weight must be constant within panels
o pscore_total será usado como peso weight no xtreg 
*/




/*somente anos impares entre 2009 e 2013*/
keep if ano==2009|ano==2011|ano==2013


*********************************** 3b. Interações Turno e Alavanca ***********************
/*dummy ice integral*/
gen ice_inte=0
replace ice_inte=1 if ice_jornada=="INTEGRAL" 
replace ice_inte=1 if ice_jornada=="Integral" 

/*dummy ice semi-integral*/
gen ice_semi_inte=0
replace ice_semi_inte=1 if ice_jornada=="Semi-integral"
replace ice_semi_inte=1 if ice_jornada=="SEMI-INTEGRAL"

/*lembrando d_ice é a dummy de ano  de entrada do ICE*/
/*dummy interação ice e integral*/
gen d_ice_inte=d_ice*ice_inte

/*dummy interação ice e semi-integral*/
gen d_ice_semi_inte=d_ice*ice_semi_inte

/*colocando zero nos missings nas dummies de alavancas*/
foreach x in "al_engaj_gov" "al_engaj_sec" "al_time_seduc" "al_marcos_lei" "al_todos_marcos" "al_sel_dir" "al_sel_prof" "al_proj_vida" {
replace `x'=0 if `x'==.
}

/*gerando as interações en a dummy ice e dummies de alavanca*/
gen al_outros=0
replace al_outros=1 if (al_engaj_gov==1|al_time_seduc==1|al_marcos_lei==1|al_proj_vida==1)
gen d_ice_al1=d_ice*al_engaj_gov
gen d_ice_al2=d_ice*al_engaj_sec
gen d_ice_al3=d_ice*al_time_seduc
gen d_ice_al4=d_ice*al_marcos_lei
gen d_ice_al5=d_ice*al_todos_marcos
gen d_ice_al6=d_ice*al_sel_dir
gen d_ice_al7=d_ice*al_sel_prof
gen d_ice_al8=d_ice*al_proj_vida
gen d_ice_al9=d_ice*al_outros


*********************************** 3c. Padronização Notas ***********************
/*fazendo mais notas padronizadas*/


/*para as escolas do CE uf 23 e PE uf 26*/
*gerando as notas padronizadas  da redação, das escolas CE e PE
foreach a in 2003 2004 2005 2006 2007 2008 {
capture egen enem_nota_redacao2326_std_aux_`a'=std(enem_nota_redacao) if ano==`a' & (codigo_uf==23|codigo_uf==26)
}
capture egen enem_nota_redacao2326_std=std(enem_nota_redacao) if ano>=2009 & (codigo_uf==23|codigo_uf==26)


foreach a in 2003 2004 2005 2006 2007 2008 {
replace enem_nota_redacao2326_std=enem_nota_redacao_std_aux_`a' if ano==`a' & (codigo_uf==23|codigo_uf==26)
}
*gerando as notas padronizadas para prova objetiva quando era só um caderno das escolas CE e PE
foreach a in 2003 2004 2005 2006 2007 2008 {
capture egen enem_nota_objetiva2326_std_aux_`a'=std(enem_nota_objetiva) if ano==`a' &(codigo_uf==23|codigo_uf==26)
}
*gerando as notas padronizadas para prova objetiva quando eram quatro cadernos das escolas CE e PE
gen enem_nota_objetivab2326=(enem_nota_matematica +enem_nota_ciencias +enem_nota_humanas+enem_nota_linguagens)/4 if (codigo_uf==23|codigo_uf==26)
capture egen enem_nota_objetivab2326_std=std(enem_nota_objetivab) if ano>=2009 & (codigo_uf==23|codigo_uf==26)

foreach a in 2003 2004 2005 2006 2007 2008 {
replace enem_nota_objetivab2326_std=enem_nota_objetiva_std_aux_`a' if ano==`a' & (codigo_uf==23|codigo_uf==26)

}


/*para as escolas do SP uf 25 e GO uf 52*/

foreach a in 2003 2004 2005 2006 2007 2008 {
capture egen enem_nota_redacao3552_std_aux_`a'=std(enem_nota_redacao) if ano==`a' & (codigo_uf==35|codigo_uf==52)
}
capture egen enem_nota_redacao3552_std=std(enem_nota_redacao) if ano>=2009 & (codigo_uf==35|codigo_uf==52)

foreach a in 2003 2004 2005 2006 2007 2008 {
replace enem_nota_redacao3552_std=enem_nota_redacao_std_aux_`a' if ano==`a' & (codigo_uf==35|codigo_uf==52)
}

foreach a in 2003 2004 2005 2006 2007 2008 {
capture egen enem_nota_objetiva3552_std_aux_`a'=std(enem_nota_objetiva) if ano==`a' &(codigo_uf==35|codigo_uf==52)
}

gen enem_nota_objetivab3552=(enem_nota_matematica +enem_nota_ciencias +enem_nota_humanas+enem_nota_linguagens)/4 if (codigo_uf==35|codigo_uf==52)
capture egen enem_nota_objetivab3552_std=std(enem_nota_objetivab) if ano>=2009 & (codigo_uf==35|codigo_uf==52)

foreach a in 2003 2004 2005 2006 2007 2008 {
replace enem_nota_objetivab3552_std=enem_nota_objetiva_std_aux_`a' if ano==`a' & (codigo_uf==35|codigo_uf==52)

}
/*gerando a variável padronizada para as variáveis de fluxo*/
foreach x in "apr_em" "rep_em"  "aba_em" "dist_em" {
egen `x'3552_std=std(`x') if (codigo_uf==35|codigo_uf==52) 
egen `x'2326_std=std(`x') if (codigo_uf==23|codigo_uf==26)
}




*********************************** 3e. Estimações e resultados ***************** 
***********************************     Resultados por estados   ****************

/*
selecionando os controles para as estimações - caracteristicas da escola que 
venham a impactar a nota média da prova brail saeb da escola
*/


local controles pb_esc_sup_mae pb_esc_sup_pai nalunos nbrancos nmulheres ///
rural agua eletricidade esgoto lixo_coleta sala_professores lab_info ///
lab_ciencias quadra_esportes biblioteca   internet
/*
foreach que para cada nota padronizada,
para cada estado 33 e 35 (rj e sp)
faz um xtreg fe, 
com d_ice e d_ano*`controles' (fazendo interação da d_ano com cada um dos 
controles) 
ie somente os controles do ano vão impactar nos outcomes notas
utilizando o pscore_total como peso


depois da regressão, gera tabelas outreg para excel
*/	

	* Geral
foreach outcomes in "media_lp_prova_brasil_9" "media_mt_prova_brasil_9"  ///
					"media_pb_9" "apr_ef" "rep_ef"  "aba_ef" "dist_ef" {
	foreach uf in 33 35  {
		xtreg `outcomes'`uf'_std d_ice d_ano* `controles' [pw=pscore_total] if ///
			dep!=4  & codigo_uf==`uf', fe 
		outreg2 using "$output/ICE_resultados_ps_ef_`uf'.xls", ///
			excel append label ctitle(`outcomes', controle pub) 
	}
}

