/*
Análise
1. ICE e ENEM

*/
*------------------------------------------------------------------------------
********************************************************************************
*********************************** 1. ICE e ENEM ******************************
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

/* 
é uma análise em painel. 
Para tal, vamos definir as variáveis de 
tempo e observação
*/
iis codigo_escola
tis ano

/*
Dropar RJ: no rio, somente escolas fundamentais tiveram o programa. 
como é uma análise do enem, podemos dropar as observações de escolas do rio 
*/
drop if codigo_uf==33


*********************************** 1a. Propensity scores ***********************
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

pscore ice n_alunos_em taxa_participacao_enem  if ano==2003&codigo_uf==26&dep!=4, pscore(pscores_pe)

pscore ice n_alunos_em_ep taxa_participacao_enem  if ano==2007&codigo_uf==23&dep!=4, pscore(pscores_ce)

*pscore ice n_alunos_ef  if ano==2010&codigo_uf==33&dep!=4, pscore(pscores_rj)

pscore ice n_alunos_em taxa_participacao_enem   if ano==2011&codigo_uf==35&dep!=4, pscore(pscores_sp)

pscore ice n_alunos_em taxa_participacao_enem if ano==2012&codigo_uf==52&dep!=4, pscore(pscores_go)

gen pscore_total=.

/*
probabilidade de ser tratado é 1 se foi tratado
*/

replace pscore_total = 1 if ice == 1

/*o propensity score de cada escola em cada ano vai ser um um peso com base no 
propensity score criado anteriormente*/

replace pscore_total=1/(1-pscores_pe) if codigo_uf==26&dep!=4&ice==0

replace pscore_total=1/(1-pscores_ce) if codigo_uf==23&dep!=4&ice==0

*replace pscore_total=1/(1-pscores_rj) if codigo_uf==33&dep!=4&ice==0

replace pscore_total=1/(1-pscores_sp) if codigo_uf==35&dep!=4&ice==0

replace pscore_total=1/(1-pscores_go) if codigo_uf==52&dep!=4&ice==0

*For each category of codigo_escola, generate pscore_total_aux = maximo do pscore_total
*sort arranges the observations of the current data into ascending order
/*
aqui, o propesnity score de cada escala tem que ser equalizado para rodar
o xtreg. isto é, cada escola, ao longo dos anos, tem que ter o mesmo pscore
assim, o max do pscore ao longo dos anos é atribuído como pscore da escola
*/

bysort codigo_escola: egen pscore_total_aux = max(pscore_total)
replace pscore_total = pscore_total_aux

/*
In -xt- analyses, the weight must be constant within panels
o pscore_total será usado como peso weight no xtreg 
*/


*********************************** 1b. Interações Turno e Alavanca ***********************
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


*********************************** 1c. Padronização Notas ***********************
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
*********************************** 1d. Estimações e resultados ***************** 
***********************************        Resultados Gerais    ****************

/*
selecionando os controles para as estimações - caracteristicas da escola que 
venham a impactar a nota média do enem da escola
*/
local controles e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria ///
n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep  rural agua eletricidade ///
esgoto lixo_coleta sala_professores  lab_info lab_ciencias quadra_esportes biblioteca  /// 
internet
	 
/*
foreach que para cada nota padronizada,

faz um xtreg fe, 
com d_ice e d_ano*`controles' (fazendo interação da d_ano com cada um dos controles) 
ie somente os controles do ano vão impactar nos outcomes notas
utilizando o pscore_total como peso
clusterizando o erro por estado

depois da regressão, gera tabelas outreg para excel
*/	 
foreach outcome in "enem_nota_matematica" "enem_nota_ciencias" "enem_nota_humanas" ///
	"enem_nota_linguagens" "enem_nota_redacao" "enem_nota_objetivab" {


	*Controlando por carateristicas dos alunos e da escola 
	*------------------------------------------------------

		* Ensino médio geral
		/*
		aqui o xtreg só roda nas escolas cujo dep! = 4 ie
		em todas as escolas do ensino medio em geral que não são privadas
		*/
		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] if dep!=4  , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_new.xls", excel append label ctitle(`outcome', controle pub, tudo) 

		* Ensino médio integral
		/*
		aqui o xtreg só roda nas escolas cujo dep! = 4 e (integral ==1 ou ice==0)  ie
		em todas as escolas do ensino medio em geral que não são privadas
		e que ou são ensino integral somente ou que não receberam o ice
		isto é, ver o impacto do ice integral no outcome
		*/	
		
		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] if dep!=4 &(integral==1|ice==0) , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_new.xls", excel append label ctitle(`outcome', controle pub, integral) 

		*Integral vs Semi-Integral
		/*
		aqui o xtreg só roda nas escolas cujo dep! = 4 ie
		em todas as escoas do ensino medio em geral que não são privadas
		colocando interações entre ice e ice integral
		*/
		xtreg  `outcome'_std d_ice d_ice_inte d_ano* `controles' [pw=pscore_total] if dep!=4 , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_new.xls", excel append label ctitle(`outcome', controle pub) 
		lincom d_ice + d_ice_inte 

		*Por nível de apoio
		
		/*
		Aqui, o xtreg foi restringidos os tratados para só um tipo de nível de apoio
		*/
		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] if dep!=4&(d_rigor1==1|ice==0) & ///
			(integral==1|ice==0), fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_new.xls", excel append label ctitle(`outcome', apoio forte)

		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] if dep!=4&(d_rigor3==1|ice==0) & ///
			(integral==1|ice==0), fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_new.xls", excel append label ctitle(`outcome', apoio medio)

		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] if dep!=4&(d_rigor2==1|ice==0) & ///
			(integral==1|ice==0), fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_new.xls", excel append label ctitle(`outcome', apoio fraco)

		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] if dep!=4&(d_rigor4==1|ice==0) & ///
			(integral==1|ice==0), fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_new.xls", excel append label ctitle(`outcome', sem apoio)

		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] if dep!=4&(d_rigor4==0|ice==0) & ///
			(integral==1|ice==0) , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_new.xls", excel append label ctitle(`outcome', com algum apoio)
	}

	 
	 
*********************************** 1e. Estimações e resultados ***************** 
**********************************     Resultados por Estado    ****************
/*
Fazendo uma análise similar a anterior, no entando, como variável dependente temos
somente a enem_nota_objetivab 
*/
	 
local X e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria ///
	n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep rural agua eletricidade ///
	esgoto lixo_coleta sala_professores  lab_info lab_ciencias quadra_esportes biblioteca ///
	internet

	*Geral Estado
	foreach outcome in   "enem_nota_objetivab"{
		/*
		aqui faz a xtereg para cada uma das notas padronizadas por estado,
		limitando a amostra em escolas não privadas e só especificamente no estado
		em questão
		*/
		foreach uf in 23 26 35 52 {
			xtreg `outcome'`uf'_std d_ice d_ano* `controles' [pw=pscore_total] if dep != 4  & codigo_uf == `uf', fe 
			outreg2 using "$output/ICE_resultados_ps_em_`uf'_new.xls", excel append label ctitle(`outcome') 
		}

		*Interegral vs Semi PE
		/*
		xtreg para notas padronizadsa de PE, com dummy de período integral, para 
		os anos de 2008, 2009, 2010
		*/
		xtreg `outcome'26_std d_ice d_ice_inte d_ano* `controles' [pw=pscore_total] if dep != 4 & (uf == "PE") & ///
				(ano_ice==2008|ano_ice==2009|ano_ice==2010) , fe 
		outreg2 using "$output/ICE_resultados_ps_em_PE_semi_int.xls", excel append label ctitle(`outcome') 

		*Interegral vs Semi PE e CE
		/*
		xtreg para notas padronizadsa de PE e CE,
		com dummy de período integral, para 
		os anos de 2008, 2009, 2010
		*/
		xtreg `outcome'2326_std d_ice d_ice_inte d_ano* `controles' [pw=pscore_total] if dep != 4 & ///
			(uf=="PE"|uf=="CE")&(ano_ice==2008|ano_ice==2009|ano_ice==2010) , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_PE_CE_semi_int.xls", excel append label ctitle(`outcome') 

		*Geral PE e CE
		
		/*
		xtreg para notas padronizadsa de PE e CE,  
		
		*/
		xtreg `outcome'2326_std d_ice  d_ano* `controles' [pw=pscore_total] if dep != 4 & ///
			(uf=="PE"|uf=="CE") , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_PE_CE.xls", excel append label ctitle(`outcome') 

		*Geral SP e GO
		/*
		xtreg para notas padronizadsa de PE e CE,  
		
		*/
		
		xtreg `outcome'3552_std d_ice  d_ano* `controles' [pw=pscore_total] if dep !=4 & ///
			(uf=="GO"|uf=="SP") , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_SP_GO.xls", excel append label ctitle(`outcome') 

	}

*********************************** 1f. Estimações e resultados ***************** 
**********************************     Resultados cumulativos    ****************
/*
Para encontrarmos efeitos cumulativos, precisamos de deummies cumulativas
*/

*Note que aqui é declarado outro painel, onde as unidades de tempo são
*em relação ao ano do ice de cada escola
* Resultados cumulativos
gen tempo=.
replace tempo=0 if ano==ano_ice-1
replace tempo=1 if ano==ano_ice
replace tempo=2 if ano==ano_ice+1
replace tempo=3 if ano==ano_ice+2 
replace tempo=4 if ano==ano_ice+3
replace tempo=5 if ano==ano_ice+4
replace tempo=6 if ano==ano_ice+5
replace tempo=7 if ano==ano_ice+6 
replace tempo=8 if ano==ano_ice+7
replace tempo=9 if ano==ano_ice+8
replace tempo=10 if ano==ano_ice+9
replace tempo=11 if ano==ano_ice+10
replace tempo=12 if ano==ano_ice+11

iis codigo_escol
tis tempo

tab tempo, gen(d_tempo)

gen d_ice1=d_ice*d_tempo2
gen d_ice2=d_ice*d_tempo3
gen d_ice3=d_ice*d_tempo4
gen d_ice4=d_ice*d_tempo5
gen d_ice5=d_ice*d_tempo6
gen d_ice6=d_ice*d_tempo7
gen d_ice7=d_ice*d_tempo8
gen d_ice8=d_ice*d_tempo9
gen d_ice9=d_ice*d_tempo10




local controles e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria ///
n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep rural agua eletricidade ///
esgoto lixo_coleta sala_professores  lab_info lab_ciencias quadra_esportes biblioteca ///
internet

/*
Aqui, xtreg fixed effects será feito com os controles usuais interagindo com o ano em questão
mais, teremos uma dummy para cada ano de participação da escola no programa
e também, para o ano anterior
o pseo será o propensity score já calculado previamente
escolas privadas serão desconsideradas nessas análises
*/
foreach outcome in "enem_nota_objetivab" {
	*Acumulado
	xtreg  `outcome'_std  d_ice1 d_ice2 d_ice3 d_ice4 d_ice5 d_ice6 d_ice7 d_ice8 d_ice9  ///
		d_ano* `controles' [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2| tempo==3| ///
		tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 ) , fe cluster(codigo_uf)
	outreg2 using "$output/ICE_resultados_cum_em_new.xls", excel append label ctitle(`outcome', 9 anos) 

	/*somente para PE*/
	*sem cluster
	xtreg  `outcome'26_std  d_ice1 d_ice2 d_ice3 d_ice4 d_ice5 d_ice6 d_ice7 d_ice8 d_ice9 ///
		d_ano* `controles' [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2| tempo==3| ///
		tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 ) &uf=="PE", fe 
	outreg2 using "$output/ICE_resultados_cum_em_new.xls", excel append label ctitle(`outcome', 9 anos, pe) 
	
	/*somente para SP*/
	*sem cluster
	xtreg  `outcome'35_std  d_ice1 d_ice2 d_ice3 d_ice4 d_ice5 d_ice6 d_ice7 d_ice8 d_ice9 ///
		d_ano* `controles' [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2| tempo==3| ///
		tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 ) &uf=="SP", fe 
	outreg2 using "$output/ICE_resultados_cum_em_new.xls", excel append label ctitle(`outcome', 9 anos, sp) 

}



