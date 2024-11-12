/*------------------------ Spillover-----------------------*/
/*
aqui vamos estimar o impacto do programa ICE nas escolas da cidade onde o
programa foi introduzido
para isso, agregaremos as informações de escola em município
com a unidade de observação sendo o município ao longo dos anos,
será feito um propensity score para cada observação
as notas das provas do enem pré 2009 (pré TRI) serão padronizadas, e em seguida,
serão estimados regressões em painel, usando como pesos o propensity score de 
cada observação
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

log using "$Logfolder/spillover.log", replace



/*
spillover em nota enem em
	interações e variáveis novas + collapse
	propensity score
	padronização das notas do enem
	resultados e estimações
spillover em nota saeb/pb ef
	interações e variáveis novas + collapse
	propensity score
	padronização das notas do enem
	resultados e estimações
spillover em fluxo em
	interações e variáveis novas + collapse
	propensity score
	padronização das notas do enem
	resultados e estimações
spillover em fluxo	ef
	interações e variáveis novas + collapse
	propensity score
	resultados e estimações
*/
/**********************Spillover Nota - ENEM*************************/
use "$Bases/ice_clean_notas.dta", clear
drop if ano==2015

/*----------interações e variáveis novas + collapse----------*/

/* 
lembrando que d_ice é a dummy que assumi 1 no ano de entrada da escola no 
programa
*/

/*mantendo só escolas com alunos de ensino médio e que não estão no RJ*/
keep if n_alunos_em_ep > 0
drop if codigo_uf == 33 | codigo_uf == 32

/*gera dummy se é ice e integral*/
gen ice_inte = 0  
replace ice_inte=1 if integral==1 

/*
gera dummy de interação entre entrada e integral
d_ice_inte assumi 1 no ano que a escola integral entrou
*/
gen d_ice_inte=d_ice*ice_inte


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
bysort codigo_municipio_novo ano: egen n_com_ice = sum (d_ice_inte)

/*
gera dummy se o município tem escola ice integral
*/
gen m_tem_ice = 0
replace m_tem_ice = 1 if n_com_ice > 0

/* gera por municipio, uma variável que é a soma das dummies ice_inte
isto é, n_com_ice2 é a soma de escolas ice integrais ao longo do tempo*/
bysort codigo_municipio_novo: egen n_com_ice2 = sum (ice_inte2)


/*gera dummy se municipio teve ice integral*/
gen m_teve_ice = 0
replace m_teve_ice = 1 if n_com_ice2 > 0
drop ice
rename m_teve_ice ice

/*dropando as escolas que tiveram ice depois de terem tido o ice*/
drop if d_ice == 1

/*dropando se é escola privada*/
drop if dep == 4

/*colapsando em municipio e em ano*/
collapse (mean) ice codigo_uf taxa_participacao_enem 					/// 
	enem_nota_matematica enem_nota_ciencias enem_nota_humanas			/// 
	enem_nota_linguagens enem_nota_redacao enem_nota_objetiva m_tem_ice	///
	d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios 	///
	e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep 				///
	n_brancos_ef_em_ep rural agua eletricidade esgoto lixo_coleta 		///
	sala_professores lab_info lab_ciencias quadra_esportes biblioteca 	///
	internet n_alunos_em n_alunos_ef n_alunos_ep n_alunos_ef_em 		///
	n_alunos_em_ep apr_em rep_em aba_em dist_em, 						///
	by(codigo_municipio_novo ano)

/* declarando o painel*/


iis codigo_municipio_novo
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

bysort codigo_municipio_novo: egen pscore_total_aux=max(pscore_total)
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
/*----------resultado e estimações por estado----------*/
foreach xx in 26 23 35 52 {
foreach x in "enem_nota_matematica_std" "enem_nota_ciencias_std" 		///
	"enem_nota_humanas_std" "enem_nota_linguagens_std" 					///
	"enem_nota_red_std"  "enem_nota_ob_std"  {
	/*
	Aqui, para cada estado, para cada variável padronizada, temos que
	é feita uma xtreg de cada uma dessas variáveis em caracterísicas
	das escola,
	colocando como peso o propensity score
	*/

	***Controlando por demais carateristicas da escola 
	xtreg `x'_`xx' m_tem_ice d_ano* e_escol_sup_pai e_escol_sup_mae 	/// 
		e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep     ///
		n_mulheres_ef_em_ep n_brancos_ef_em_ep rural agua eletricidade  /// 
		esgoto lixo_coleta sala_professores lab_info lab_ciencias       ///
		quadra_esportes biblioteca   internet [pw=pscore_total], fe 
	outreg2 using "$output/ICE_resultados_spillover_uf_new.xls", 		///
		excel append label ctitle(`x', `xx') 

}
}


/**********************Spillover Nota - PB/SAEB*************************/
use "$Bases/ice_clean_notas.dta", clear


/*----------interações e variáveis novas + collapse----------*/
/* 
mantendo somente as escolas cujo número de alunos 
no ensino fund é maior que zero
*/
keep if n_alunos_ef > 0

/*
mantendo somente os estados onde ice foi implantando para fundamental
isto é 
São Paulo 35 e Rio de Janeiro 33
*/
keep if codigo_uf == 33 | codigo_uf == 35

/*gera dummy  se é ice e integral*/
gen ice_inte = 0 
replace ice_inte = 1 if integral == 1 


/*
gera dummy de interação entre entrada e integral
d_ice_inte assumi 1 para a escola integral no ano que ela entrou no ICE
*/
gen d_ice_inte = d_ice * ice_inte

/*
gera dummy de interação entre integral e ser ice
ice_inte2 assumi 1 quando a escola é ice e integral
*/
gen ice_inte2 = ice * ice_inte



/*
gera por municipio, para cada ano, uma variável que é a soma das dummies de
ice_inte
isto é, n_com_ice é o número de escolas ice integrais, em um dado ano
*/
bysort codigo_municipio_novo ano: egen n_com_ice = sum (d_ice_inte)

/*
gera dummy se o município tem escola ice integral
*/
gen m_tem_ice = 0
replace m_tem_ice = 1 if n_com_ice > 0



/* gera por municipio, uma variável que é a soma das dummies ice_inte
isto é, n_com_ice2 é a soma de escolas integrais ao longo do tempo*/
bysort codigo_municipio_novo: egen n_com_ice2 = sum (ice_inte2)

/*gera dummy se municipio teve ice integral*/
gen m_teve_ice = 0
replace m_teve_ice = 1 if n_com_ice2 > 0
drop ice
rename m_teve_ice ice


/*dropando as escolas que tiveram ice depois de terem tido o ice*/
drop if d_ice == 1

/*dropando se é escola privada*/
drop if dep == 4

/*colapsando em municipio e em ano*/

collapse (mean) ice codigo_uf taxa_participacao_pb_9 pb_esc_sup_mae_9 		///
	pb_esc_sup_pai_9 media_lp_prova_brasil_9 media_mt_prova_brasil_9		///
	media_pb_9 m_tem_ice d_ano* e_escol_sup_pai e_escol_sup_mae 		///
	e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep			///
	n_mulheres_ef_em_ep n_brancos_ef_em_ep rural agua eletricidade 		///
	esgoto lixo_coleta sala_professores lab_info lab_ciencias			///
	quadra_esportes biblioteca internet n_alunos_em n_alunos_ef			///
	n_alunos_ep n_alunos_ef_em n_alunos_em_ep apr_em rep_em aba_em		///
	dist_em, by(codigo_municipio_novo ano)
	
/* definindo o painel*/

iis codigo_municipio_novo
tis ano
/*----------Propensity Score----------*/

set matsize 10000

/*
gerando os propensity scores
a probabilidade condicional do município ter ice dado o número médio
de alunos  e taxa de participação do enem
o pscore vai ser calculado no ano em que o ice foi implementado no estado
*/

*pscore ice n_alunos_em taxa_participacao_enem if ano==2003&codigo_uf==26, pscore(pscores_pe)

*pscore ice n_alunos_em_ep taxa_participacao_enem if ano==2007&codigo_uf==23, pscore(pscores_ce)

*pscore ice n_alunos_ef taxa_participacao_pb if ano==2010&codigo_uf==33, pscore(pscores_rj)

pscore ice n_alunos_ef taxa_participacao_pb_9 if ano==2011&codigo_uf==35, pscore(pscores_sp)

*gerando o pscore para o espírito santo
*pscore ice n_alunos_ef taxa_participacao_pb_9   if ano==2011&codigo_uf==32, pscore(pscores_es)

*pscore ice n_alunos_em taxa_participacao_enem if ano==2012&codigo_uf==52, pscore(pscores_go)

gen pscore_total=.
replace pscore_total=1 if ice==1

*replace pscore_total=1/(1-pscores_pe) if codigo_uf==26&ice==0

*replace pscore_total=1/(1-pscores_ce) if codigo_uf==23&ice==0

*replace pscore_total=1/(1-pscores_rj) if codigo_uf==33&ice==0

replace pscore_total=1/(1-pscores_sp) if codigo_uf==35&ice==0

*replace pscore_total=1/(1-pscores_go) if codigo_uf==52&ice==0

bysort codigo_municipio_novo: egen pscore_total_aux=max(pscore_total)
replace pscore_total=pscore_total_aux
/*
aqui, o propesnity score de cada escola tem que ser equalizado para rodar
o xtreg. isto é, cada escola, ao longo dos anos, tem que ter o mesmo pscore
assim, o max do pscore ao longo dos anos é atribuído como pscore da escola
note que o pscore é calculado nos períodos pré tratamento, caso a escola venha
a ser tratada

*/

/*----------resultado e estimações por estado----------*/


/*gerando as variáveis padronizadas*/
foreach x in "media_lp_prova_brasil_9" "media_mt_prova_brasil_9"  	///
	"media_pb_9" "apr_em" "rep_em" "aba_em" "dist_em" {
		egen `x'_std=std(`x')
}

/*
xtreg para as variáveis da prova brasil padronizadas
com controles de escola
*/
foreach x in  "media_lp_prova_brasil_9_std" 						/// 
	"media_mt_prova_brasil_9_std" "media_pb_9_std"  {

	xtreg `x' m_tem_ice d_ano* pb_esc_sup_mae pb_esc_sup_pai				///
		n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep rural		///
		agua eletricidade esgoto lixo_coleta sala_professores lab_info		///
		lab_ciencias quadra_esportes biblioteca internet [pw=pscore_total], ///
		fe cluster(codigo_uf)
	outreg2 using "$output/ICE_resultados_spillover_ef_2003_2014.xls",			///
		excel append label ctitle(`x', escola2) 


}




/**********************Spillover Fluxo EM*************************/
use "$Bases/ice_clean_fluxo.dta", clear
drop if ano==2015
/*----------interações e variáveis novas + collapse----------*/
/* 
lembrando que d_ice é a dummy que assumi 1 no ano de entrada da escola no 
programa
*/
/*mantendo só escolas com alunos de ensino médio e  que não estão no RJ*/
keep if n_alunos_em_ep > 0
drop if codigo_uf == 33

/*gera dummy  se é ice e integral*/
gen ice_inte = 0 
replace ice_inte=1 if integral==1 


/*
gera dummy de interação entre entrada e integral
d_ice_inte assumi 1 no ano que a escola integral entrou
*/
gen d_ice_inte=d_ice*ice_inte

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
bysort codigo_municipio_novo ano: egen n_com_ice = sum (d_ice_inte)

/*
gera dummy se o município tem escola ice integral
*/
gen m_tem_ice = 0
replace m_tem_ice = 1 if n_com_ice > 0


/* gera por municipio, uma variável que é a soma das dummies ice_inte
isto é, n_com_ice2 é a soma de escolas integrais ao longo do tempo*/
bysort codigo_municipio_novo: egen n_com_ice2 = sum (ice_inte2)

/*gera dummy se municipio teve ice integral*/
gen m_teve_ice = 0
replace m_teve_ice = 1 if n_com_ice2 > 0
drop ice
rename m_teve_ice ice

/*dropando as escolas que tiveram ice depois de terem tido o ice*/
drop if d_ice == 1

/*dropando se é escola privada*/
drop if dep == 4

/*colapsando em municipio e em ano*/
collapse (mean) ice codigo_uf taxa_participacao_enem 					/// 
	enem_nota_matematica enem_nota_ciencias enem_nota_humanas			/// 
	enem_nota_linguagens enem_nota_redacao enem_nota_objetiva m_tem_ice	///
	d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios 	///
	e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep 				///
	n_brancos_ef_em_ep rural agua eletricidade esgoto lixo_coleta 		///
	sala_professores lab_info lab_ciencias quadra_esportes biblioteca 	///
	internet n_alunos_em n_alunos_ef n_alunos_ep n_alunos_ef_em 		///
	n_alunos_em_ep apr_em rep_em aba_em dist_em, 						///
	by(codigo_municipio_novo ano)

	
/* definindo o painel*/


iis codigo_municipio_novo
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

bysort codigo_municipio_novo: egen pscore_total_aux=max(pscore_total)
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





/*----------resultado e estimações por estado----------*/
foreach xx in 26 23 35 52 {
foreach x in  "apr_em_std" "rep_em_std" "aba_em_std" "dist_em_std" {


***Controlando por demais carateristicas da escola 
xtreg `x'_`xx' m_tem_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total], fe 
outreg2 using "${output}ICE_resultados_spillover_uf_new.xls", excel append label ctitle(`x', `xx') 

}
}




/**********************Spillover Fluxo EF*************************/
use "$Bases/ice_clean_fluxo.dta", clear
/*----------interações e variáveis novas + collapse----------*/
keep if n_alunos_ef>0
keep if codigo_uf==33 | codigo_uf==35

gen ice_inte=0
replace ice_inte=1 if integral==1 

gen d_ice_inte=d_ice*ice_inte
gen ice_inte2=ice*ice_inte

bysort codigo_municipio_novo ano: egen n_com_ice=sum(d_ice_inte)
gen m_tem_ice=0
replace m_tem_ice=1 if n_com_ice>0

bysort codigo_municipio_novo: egen n_com_ice2=sum(ice_inte2)
gen m_teve_ice=0
replace m_teve_ice=1 if n_com_ice2>0
drop ice
rename m_teve_ice ice

drop if d_ice==1
drop if dep==4
collapse (mean) ice codigo_uf taxa_participacao_pb_9 pb_esc_sup_mae_9 		///
	pb_esc_sup_pai_9 media_lp_prova_brasil_9 media_mt_prova_brasil_9 		///
	media_pb_9 m_tem_ice d_ano* e_escol_sup_pai e_escol_sup_mae 		///
	e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep 		///
	n_mulheres_ef_em_ep n_brancos_ef_em_ep rural agua eletricidade 		///
	esgoto lixo_coleta sala_professores lab_info lab_ciencias 			///
	quadra_esportes biblioteca internet n_alunos_em n_alunos_ef 		///
	n_alunos_ep n_alunos_ef_em n_alunos_em_ep apr_em rep_em aba_em 		///
	dist_em, by(codigo_municipio_novo ano)


iis codigo_municipio_novo
tis ano


/*----------Propensity Score----------*/
* Gerar pscores

set matsize 10000



*pscore ice n_alunos_em taxa_participacao_enem if ano==2003&codigo_uf==26, pscore(pscores_pe)

*pscore ice n_alunos_em_ep taxa_participacao_enem if ano==2007&codigo_uf==23, pscore(pscores_ce)

*pscore ice n_alunos_ef taxa_participacao_pb_9 if ano==2010&codigo_uf==33, pscore(pscores_rj)

pscore ice n_alunos_ef taxa_participacao_pb_9 if ano==2011&codigo_uf==35, pscore(pscores_sp)

*pscore ice n_alunos_ef taxa_participacao_pb_9 if ano==2011&codigo_uf==32, pscore(pscores_es)


*pscore ice n_alunos_em taxa_participacao_enem if ano==2012&codigo_uf==52, pscore(pscores_go)


gen pscore_total=.
replace pscore_total=1 if ice==1

*replace pscore_total=1/(1-pscores_pe) if codigo_uf==26&ice==0

*replace pscore_total=1/(1-pscores_ce) if codigo_uf==23&ice==0

*replace pscore_total=1/(1-pscores_rj) if codigo_uf==33&ice==0

replace pscore_total=1/(1-pscores_sp) if codigo_uf==35&ice==0

*replace pscore_total=1/(1-pscores_es) if codigo_uf==32&ice==0

*replace pscore_total=1/(1-pscores_go) if codigo_uf==52&ice==0

bysort codigo_municipio_novo: egen pscore_total_aux=max(pscore_total)
replace pscore_total=pscore_total_aux



/*----------padronização de notas e variáveis fluxo----------*/
foreach x in "media_lp_prova_brasil_9" "media_mt_prova_brasil_9" "media_pb_9" "apr_em" "rep_em" "aba_em" "dist_em" {
egen `x'_std=std(`x')
}
/*----------resultado e estimações por estado----------*/

/*
xtreg para as variáveis da prova brasil padronizadas
com controles de escola
*/
foreach x in  "media_lp_prova_brasil_9_std" 						/// 
	"media_mt_prova_brasil_9_std" "media_pb_9_std"  {

	xtreg `x' m_tem_ice d_ano* pb_esc_sup_mae pb_esc_sup_pai				///
		n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep rural		///
		agua eletricidade esgoto lixo_coleta sala_professores lab_info		///
		lab_ciencias quadra_esportes biblioteca internet [pw=pscore_total], ///
		fe cluster(codigo_uf)
	outreg2 using "$output/ICE_resultados_spillover_ef_2003_2014.xls",			///
		excel append label ctitle(`x', escola2) 


}


log close
