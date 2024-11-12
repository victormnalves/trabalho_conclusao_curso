/*----------------------------Ensino Médio - ENEM e fluxo - velho---------------------------*/
/*
aqui vamos estimar o impacto do programa ICE nas nota e em fluxo
como o programa não foi aleatoriezado, fazer um propensity score matching
em seguida, será necessário criar as dummies de alavanca e fazer interações
de turno
depois, padronizar as notas
com todas essas etaps, serão estimados regerssões em painel ponderadas pelo
propensity score
*/
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
global output "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\resultados_em"
global Bases "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"
global dofiles "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\Do-Files"
global Logfolder "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\logfiles"


global folderservidor "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"

log using "$Logfolder/em_enem_antigo.log", replace

/*------------------------- Estimações e Resultados-------------------------*/
/*
Notas:
	resultados gerais
		
	resultados por estados
	resultados cumulativos
variáveis de fluxo:
	resultados gerais
	resultados por estados
	resultados cumulativos
*/

*****************************   NOTAS   *****************************

* a base de dados para análise de impacto do ice em nota é ice_clean.dta
use "$Bases/bases da análise anterior\ice_clean.dta", clear
drop if ano==2015
/* 
é uma análise em painel. 
Para tal, vamos definir as variáveis de 
tempo e observação
*/
iis codigo_escola
tis ano

/*
Dropar RJ e ES: no rio e no espírito santo, somente escolas fundamentais tiveram o programa. 
como é uma análise do enem, podemos dropar as observações de escolas do rio do ES
*/
drop if codigo_uf==33 | codigo_uf==32

******************* PSCORE *******************
*chamando o dofile que gera os pscores para ensino médio
do "$dofiles/em_pscore_14.do"

******************* INTERAÇÕES DE TURNO E ALAVANCAS *******************
*gerando dummies de interação de turno e alavancas
do "$dofiles/turno_alavanca_14.do"

****************** PADRONIZAÇÃO DE NOTAS - EM ******************
*gerando notas do enem padronizadas por estado
do "$dofiles/em_padronizar_notas_14.do"


***************************   Resultados Gerais  ***************************

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
		*a variável integral vem da base do ice
		* Ensino médio geral
		/*
		aqui o xtreg só roda nas escolas cujo dep! = 4 ie
		em todas as escoas do ensino medio em geral que não são privadas
		*/
		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] if dep!=4  , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_2003_2014_antigo.xls", excel append label ctitle(`outcome', controle pub, tudo) 

		* Ensino médio integral
		/*
		aqui o xtreg só roda nas escolas cujo dep! = 4 e (integral ==1 ou ice==0)  ie
		em todas as escolas do ensino medio em geral que não são privadas
		e que ou são ensino integral somente ou que não receberam o ice
		isto é, ver o impacto do ice integral no outcome
		*/	
		
		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] if dep!=4 &(integral==1|ice==0) , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_2003_2014_antigo.xls", excel append label ctitle(`outcome', controle pub, integral) 

		*Integral vs Semi-Integral
		/*
		aqui o xtreg só roda nas escolas cujo dep! = 4 ie
		em todas as escoas do ensino medio em geral que não são privadas
		colocando interações entre ice e ice integral e escolhendo escolas com integral e semi integral
		*/
		xtreg  `outcome'_std d_ice d_ice_inte d_ano* `controles' [pw=pscore_total] if dep!=4 , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_2003_2014_antigo.xls", excel append label ctitle(`outcome', controle pub) 
		lincom d_ice + d_ice_inte 

		*Por nível de apoio
		
		/*
		Aqui, o xtreg foi restringidos os tratados para só um tipo de nível de apoio
		*/
		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] if dep!=4&(d_rigor1==1|ice==0) & ///
			(integral==1|ice==0), fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_2003_2014_antigo.xls", excel append label ctitle(`outcome', apoio forte)

		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] if dep!=4&(d_rigor3==1|ice==0) & ///
			(integral==1|ice==0), fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_2003_2014_antigo.xls", excel append label ctitle(`outcome', apoio medio)

		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] if dep!=4&(d_rigor2==1|ice==0) & ///
			(integral==1|ice==0), fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_2003_2014_antigo.xls", excel append label ctitle(`outcome', apoio fraco)

		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] if dep!=4&(d_rigor4==1|ice==0) & ///
			(integral==1|ice==0), fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_2003_2014_antigo.xls", excel append label ctitle(`outcome', sem apoio)

		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] if dep!=4&(d_rigor4==0|ice==0) & ///
			(integral==1|ice==0) , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_2003_2014_antigo.xls", excel append label ctitle(`outcome', com algum apoio)
}


***************************   Resultados por Estado  ***************************
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
			outreg2 using "$output/ICE_resultados_ps_em_`uf'_2003_2014_antigo.xls", excel append label ctitle(`outcome') 
		}

		*Interegral vs Semi PE
		/*
		xtreg para notas padronizadsa de PE, com dummy de período integral, para 
		os anos de 2008, 2009, 2010
		*/
		xtreg `outcome'26_std d_ice d_ice_inte d_ano* `controles' [pw=pscore_total] if dep != 4 & (uf == "PE") & ///
				(ano_ice==2008|ano_ice==2009|ano_ice==2010) , fe 
		outreg2 using "$output/ICE_resultados_ps_em_PE_semi_int_2003_2014_antigo.xls", excel append label ctitle(`outcome') 

		*Interegral vs Semi PE e CE
		/*
		xtreg para notas padronizadsa de PE e CE,
		com dummy de período integral, para 
		os anos de 2008, 2009, 2010
		*/
		xtreg `outcome'2326_std d_ice d_ice_inte d_ano* `controles' [pw=pscore_total] if dep != 4 & ///
			(uf=="PE"|uf=="CE")&(ano_ice==2008|ano_ice==2009|ano_ice==2010) , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_PE_CE_semi_int_2003_2014_antigo.xls", excel append label ctitle(`outcome') 

		*Geral PE e CE
		
		/*
		xtreg para notas padronizadsa de PE e CE,  
		
		*/
		xtreg `outcome'2326_std d_ice  d_ano* `controles' [pw=pscore_total] if dep != 4 & ///
			(uf=="PE"|uf=="CE") , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_PE_CE_2003_2014_antigo.xls", excel append label ctitle(`outcome') 

		*Geral SP e GO
		/*
		xtreg para notas padronizadsa de SP e GO,  
		
		*/
		
		xtreg `outcome'3552_std d_ice  d_ano* `controles' [pw=pscore_total] if dep !=4 & ///
			(uf=="GO"|uf=="SP") , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_SP_GO_2003_2014_antigo.xls", excel append label ctitle(`outcome') 

}
***************************   Resultados Cumulativos  ***************************
/*
Para encontrarmos efeitos cumulativos, precisamos de dummies cumulativas
*/

*Note que aqui é declarado outro painel, onde as unidades de tempo são
*em relação ao ano do ice de cada escola
* Resultados cumulativos
do "$dofiles/dummies_cumulativos_14.do"



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
	outreg2 using "$output/ICE_resultados_cum_ps_em_2003_2014_antigo.xls", excel append label ctitle(`outcome', 9 anos) 

	/*somente para PE*/
	*sem cluster
	xtreg  `outcome'26_std  d_ice1 d_ice2 d_ice3 d_ice4 d_ice5 d_ice6 d_ice7 d_ice8 d_ice9 ///
		d_ano* `controles' [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2| tempo==3| ///
		tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 ) &uf=="PE", fe 
	outreg2 using "$output/ICE_resultados_cum_ps_em_2003_2014_antigo.xls", excel append label ctitle(`outcome', 9 anos, pe) 
	
	/*somente para SP*/
	*sem cluster
	xtreg  `outcome'35_std  d_ice1 d_ice2 d_ice3 d_ice4 d_ice5 d_ice6 d_ice7 d_ice8 d_ice9 ///
		d_ano* `controles' [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2| tempo==3| ///
		tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 ) &uf=="SP", fe 
	outreg2 using "$output/ICE_resultados_cum_ps_em_2003_2014_antigo.xls", excel append label ctitle(`outcome', 9 anos, sp) 

}



*****************************   FLUXO   *****************************

* a base de dados para análise de impacto do ice em fluxo é ice_clean.dta
use "$Bases/bases da análise anterior\ice_clean_fluxo.dta", clear
drop if ano==2015

/* 
é uma análise em painel. 
Para tal, vamos definir as variáveis de 
tempo e observação
*/
iis codigo_escola
tis ano

/*
Dropar RJ e ES: no rio e no espírito santo, somente escolas fundamentais tiveram o programa. 
como é uma análise do enem, podemos dropar as observações de escolas do rio do ES
*/
drop if codigo_uf==33 | codigo_uf==32



******************* PSCORE *******************
*chamando o dofile que gera os pscores para ensino médio
do "$dofiles/em_pscore_14.do"

******************* INTERAÇÕES DE TURNO E ALAVANCAS *******************
*gerando dummies de interação de turno e alavancas
do "$dofiles/turno_alavanca_14.do"

****************** PADRONIZAÇÃO DE FLUXO - EM ******************
*gerando ntoas do enem padronizadas
do "$dofiles/em_padronizar_notas_14.do"

***************************   Resultados Gerais  ***************************


/*
selecionando os controles para as estimações - caracteristicas da escola que 
venham a impactar em fluxo médio da escola
*/
	local controles e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios ///
		e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep ///
		rural agua eletricidade esgoto lixo_coleta sala_professores  lab_info ///
		lab_ciencias quadra_esportes biblioteca   internet
/*
foreach que para cada variável de fluxo - aprovação, reprovação, abandono, distância,


faz um xtreg fe, 
com d_ice e d_ano*`controles' (fazendo interação da d_ano com cada um dos controles) 
ie somente os controles do ano vão impactar nos outcomes de fluxo
utilizando o pscore_total como peso
clusterizando o erro por estado

depois da regressão, gera tabelas outreg para excel
*/	

foreach outcome in "apr_em" "rep_em" "aba_em" "dist_em" {

		* Ensino médio geral
		/*
		aqui o xtreg só roda nas escolas cujo dep! = 4 ie
		em todas as escoas do ensino medio em geral que não são privadas
		*/
		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] ///
			if dep!=4, fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_2003_2014_antigo.xls", ///
			excel append label ctitle(`outcome', controle pub, tudo) 

		* Ensino médio integral
		/*
		aqui o xtreg só roda nas escolas cujo dep! = 4 e (integral ==1 ou ice==0)  ie
		em todas as escolas do ensino medio em geral que não são privadas
		e que ou são ensino integral somente ou que não receberam o ice
		isto é, ver o impacto do ice integral no outcome
		*/
		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] ///
			if dep!=4 &(integral==1|ice==0) , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_2003_2014_antigo.xls", ///
			excel append label ctitle(`outcome', controle pub, integral) 
		
		*Integral vs Semi-Integral
		/*
		aqui o xtreg só roda nas escolas cujo dep! = 4 ie
		em todas as escolas do ensino medio em geral que não são privadas
		colocando interações entre ice e ice integral
		*/
		xtreg  `outcome'_std d_ice d_ice_inte d_ano* `controles' [pw=pscore_total] ///
			if dep!=4 &(integral==1|ice==0) , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_2003_2014_antigo.xls", ///
			excel append label ctitle(`outcome', controle pub, integral) 
		lincom d_ice + d_ice_inte 
		/* 
		lincom computes point estimates, standard errors, t or z statistics, 
		p-values, and confidence intervals for linear combinations of coefficients 
		after any estimation command. Results can optionally be displayed as 
		odds ratios, hazard ratios, incidence-rate ratios, or relative-risk ratios
		*/
		
		
		*Por nível de apoio
		
		/*
		Aqui, o xtreg foi restringidos os tratados para só um tipo de nível de apoio
		*/
		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] ///
			if dep!=4&(d_rigor1==1|ice==0)&(integral==1|ice==0), /// 
			fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_2003_2014_antigo.xls", ///
			excel append label ctitle(`outcome', apoio forte)

		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] /// 
			if dep!=4&(d_rigor3==1|ice==0)&(integral==1|ice==0), /// 
			fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_2003_2014_antigo.xls", ///
			excel append label ctitle(`outcome', apoio medio)

		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] /// 
			if dep!=4&(d_rigor2==1|ice==0)&(integral==1|ice==0), /// 
			fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_2003_2014_antigo.xls", ///
			excel append label ctitle(`outcome', apoio fraco)

		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] ///
			if dep!=4&(d_rigor4==1|ice==0)&(integral==1|ice==0), ///
			fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_2003_2014_antigo.xls", ///
			excel append label ctitle(`outcome', sem apoio)

		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] ///
			if dep!=4&(d_rigor4==0|ice==0)&(integral==1|ice==0) , ///
			fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_2003_2014_antigo.xls", ///
			excel append label ctitle(`outcome', com algum apoio)
	
				
		
}	

**********************************     Resultados por Estado    ****************
/*
Fazendo uma análise similar a anterior 
*/

local controles e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios ///
	e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep ///
	rural agua eletricidade esgoto lixo_coleta sala_professores lab_info ///
	lab_ciencias quadra_esportes biblioteca internet

	*Geral Estado
foreach outcome in "apr_em" "rep_em" "aba_em" "dist_em" {
	
	/*
	aqui faz a xtereg para cada uma das variáveis de fluxo,,
	limitando a amostra em escolas não privadas e só especificamente no estado
	em questão
	*/
		foreach xx in 23 26 35 52 {
			xtreg `outcome'`xx'_std d_ice d_ano* `controles' [pw=pscore_total] ///
				if dep!=4  & codigo_uf==`xx', fe 
			outreg2 using "$output/ICE_resultados_ps_em_`xx'_2003_2014_antigo.xls", ///
				excel append label ctitle(`outcome') 
		}
	*Interegral vs Semi PE 
	/*
	xtreg para as variáveis de fluxo de PE, 
	com dummy de período integral,
	para os anos de 2008, 2009, 2010
	*/
	
	xtreg `outcome'26_std d_ice d_ice_inte d_ano* `controles' /// 
		[pw=pscore_total] if dep != 4 & (uf=="PE") & ///
		(ano_ice==2008|ano_ice==2009|ano_ice==2010) , fe 
	outreg2 using "$output/ICE_resultados_ps_em_PE_semi_int_2003_2014_antigo.xls", ///
		excel append label ctitle(`outcome') 

	*Interegral vs Semi PE e CE
	/*
	xtreg para as variáveis de fluxo de PE, com dummy de período integral, 
	paraos anos de 2008, 2009, 2010
	*/
	xtreg `outcome'2326_std d_ice d_ice_inte d_ano* `controles' ///
		[pw=pscore_total] if dep!=4&(uf=="PE"|uf=="CE") & ///
		(ano_ice==2008|ano_ice==2009|ano_ice==2010) , fe cluster(codigo_uf)
	outreg2 using "$output/ICE_resultados_ps_em_PE_CE_semi_int_2003_2014_antigo.xls", ///
		excel append label ctitle(`outcome') 

	
	*Geral PE e CE
	
	/*
	xtreg para as variáveis de fluxo de PE e CE,  
	
	*/
	xtreg `outcome'2326_std d_ice  d_ano* `controles' ///
		[pw=pscore_total] if dep!=4&(uf=="PE"|uf=="CE") , ///
		fe cluster(codigo_uf)
	outreg2 using "$output/ICE_resultados_ps_em_PE_CE_2003_2014_antigo.xls", ///
		excel append label ctitle(`outcome') 

	*Geral SP e GO
	/*
	xtreg para notas padronizadsa de PE e CE,  
	
	*/
	xtreg `outcome'3552_std d_ice  d_ano* `controles' ///
		[pw=pscore_total] if dep!=4&(uf=="GO"|uf=="SP") , ///
		fe cluster(codigo_uf)
	outreg2 using "$output/ICE_resultados_ps_em_SP_GO_2003_2014_antigo.xls", ///
		excel append label ctitle(`outcome') 

}
**********************************     Resultados cumulativos    ****************
/*
Para encontrarmos efeitos cumulativos, precisamos de deummies cumulativas
*/

*Note que aqui é declarado outro painel, onde as unidades de tempo são
*em relação ao ano do ice de cada escola
* Resultados cumulativos

do "$dofiles/dummies_cumulativos_14.do"

/*
Aqui, xtreg fixed effects será feito com os controles usuais 
interagindo com o ano em questão
teremos uma dummy para cada ano de participação da escola no programa
e também, para o ano anterior
o pseo será o propensity score já calculado previamente
escolas privadas serão desconsideradas nessas análises
*/


foreach outcome in "apr_em" "rep_em" "aba_em" "dist_em" {
	*Acumulado
	xtreg  `outcome'_std  d_ice1 d_ice2 d_ice3 d_ice4 d_ice5 d_ice6 d_ice7 ///
		d_ice8 d_ice9  d_ano* `controles' [pw=pscore_total] if dep!=4 /// 
		&(tempo==0| tempo==1|tempo==2| tempo==3| tempo==4 | tempo==5 | ///
		tempo==6| tempo==7 | tempo==8 | tempo==9 ) , fe cluster(codigo_uf)
	outreg2 using "$output/ICE_resultados_cum_ps_em_2003_2014_antigo.xls", ///
		excel append label ctitle(`outcome', 9 anos) 

	xtreg  `outcome'26_std  d_ice1 d_ice2 d_ice3 d_ice4 d_ice5 d_ice6 d_ice7 ///
		d_ice8 d_ice9  d_ano* `controles' [pw=pscore_total] if dep!=4 /// 
		& (tempo==0| tempo==1|tempo==2| tempo==3| tempo==4 | tempo==5 ///
		| tempo==6| tempo==7 | tempo==8 | tempo==9 ) &uf=="PE", fe 
	outreg2 using "$output/ICE_resultados_cum_ps_em_2003_2014_antigo.xls", ///
		excel append label ctitle(`outcome', 9 anos, pe) 

	xtreg `outcome'35_std  d_ice1 d_ice2 d_ice3 d_ice4 d_ice5 d_ice6 d_ice7 ///
		d_ice8 d_ice9  d_ano* `controles' [pw=pscore_total] if dep!=4 ///
		& (tempo==0| tempo==1|tempo==2| tempo==3| tempo==4 | tempo==5 ///
		| tempo==6| tempo==7 | tempo==8 | tempo==9 ) &uf=="SP", fe 
	outreg2 using "$output/ICE_resultados_cum_ps_em_2003_2014_antigo.xls", ///
		excel append label ctitle(`outcome', 9 anos, sp) 

}

********************************************************************************
********************************************************************************
/*				 	Efeitos fixos sem propensity score como peso			  */
********************************************************************************
********************************************************************************
* a base de dados para análise de impacto do ice em nota é ice_clean.dta
use "$Bases/bases da análise anterior\ice_clean.dta", clear

drop if ano==2015
/* 
é uma análise em painel. 
Para tal, vamos definir as variáveis de 
tempo e observação
*/
iis codigo_escola
tis ano

/*
Dropar RJ e ES: no rio e no espírito santo, somente escolas fundamentais tiveram o programa. 
como é uma análise do enem, podemos dropar as observações de escolas do rio do ES
*/
drop if codigo_uf==33 | codigo_uf==32

******************* PSCORE *******************
*chamando o dofile que gera os pscores para ensino médio
do "$dofiles/em_pscore_14.do"

******************* INTERAÇÕES DE TURNO E ALAVANCAS *******************
*gerando dummies de interação de turno e alavancas
do "$dofiles/turno_alavanca_14.do"

****************** PADRONIZAÇÃO DE NOTAS - EM ******************
*gerando notas do enem padronizadas por estado
do "$dofiles/em_padronizar_notas_14.do"


***************************   Resultados Gerais  ***************************

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
		*a variável integral vem da base do ice
		* Ensino médio geral
		/*
		aqui o xtreg só roda nas escolas cujo dep! = 4 ie
		em todas as escoas do ensino medio em geral que não são privadas
		*/
		xtreg  `outcome'_std d_ice d_ano* `controles'  if dep!=4  , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_em_2003_2014_antigo.xls", excel append label ctitle(`outcome', controle pub, tudo) 

		* Ensino médio integral
		/*
		aqui o xtreg só roda nas escolas cujo dep! = 4 e (integral ==1 ou ice==0)  ie
		em todas as escolas do ensino medio em geral que não são privadas
		e que ou são ensino integral somente ou que não receberam o ice
		isto é, ver o impacto do ice integral no outcome
		*/	
		
		xtreg  `outcome'_std d_ice d_ano* `controles'  if dep!=4 &(integral==1|ice==0) , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_em_2003_2014_antigo.xls", excel append label ctitle(`outcome', controle pub, integral) 

		*Integral vs Semi-Integral
		/*
		aqui o xtreg só roda nas escolas cujo dep! = 4 ie
		em todas as escoas do ensino medio em geral que não são privadas
		colocando interações entre ice e ice integral e escolhendo escolas com integral e semi integral
		*/
		xtreg  `outcome'_std d_ice d_ice_inte d_ano* `controles'  if dep!=4 , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_em_2003_2014_antigo.xls", excel append label ctitle(`outcome', controle pub) 
		lincom d_ice + d_ice_inte 

		*Por nível de apoio
		
		/*
		Aqui, o xtreg foi restringidos os tratados para só um tipo de nível de apoio
		*/
		xtreg  `outcome'_std d_ice d_ano* `controles'  if dep!=4&(d_rigor1==1|ice==0) & ///
			(integral==1|ice==0), fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_em_2003_2014_antigo.xls", excel append label ctitle(`outcome', apoio forte)

		xtreg  `outcome'_std d_ice d_ano* `controles'  if dep!=4&(d_rigor3==1|ice==0) & ///
			(integral==1|ice==0), fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_em_2003_2014_antigo.xls", excel append label ctitle(`outcome', apoio medio)

		xtreg  `outcome'_std d_ice d_ano* `controles'  if dep!=4&(d_rigor2==1|ice==0) & ///
			(integral==1|ice==0), fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_em_2003_2014_antigo.xls", excel append label ctitle(`outcome', apoio fraco)

		xtreg  `outcome'_std d_ice d_ano* `controles'  if dep!=4&(d_rigor4==1|ice==0) & ///
			(integral==1|ice==0), fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_em_2003_2014_antigo.xls", excel append label ctitle(`outcome', sem apoio)

		xtreg  `outcome'_std d_ice d_ano* `controles'  if dep!=4&(d_rigor4==0|ice==0) & ///
			(integral==1|ice==0) , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_em_2003_2014_antigo.xls", excel append label ctitle(`outcome', com algum apoio)
}


***************************   Resultados por Estado  ***************************
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
			xtreg `outcome'`uf'_std d_ice d_ano* `controles'  if dep != 4  & codigo_uf == `uf', fe 
			outreg2 using "$output/ICE_resultados_em_`uf'_2003_2014_antigo.xls", excel append label ctitle(`outcome') 
		}

		*Interegral vs Semi PE
		/*
		xtreg para notas padronizadsa de PE, com dummy de período integral, para 
		os anos de 2008, 2009, 2010
		*/
		xtreg `outcome'26_std d_ice d_ice_inte d_ano* `controles'  if dep != 4 & (uf == "PE") & ///
				(ano_ice==2008|ano_ice==2009|ano_ice==2010) , fe 
		outreg2 using "$output/ICE_resultados_em_PE_semi_int_2003_2014_antigo.xls", excel append label ctitle(`outcome') 

		*Interegral vs Semi PE e CE
		/*
		xtreg para notas padronizadsa de PE e CE,
		com dummy de período integral, para 
		os anos de 2008, 2009, 2010
		*/
		xtreg `outcome'2326_std d_ice d_ice_inte d_ano* `controles'  if dep != 4 & ///
			(uf=="PE"|uf=="CE")&(ano_ice==2008|ano_ice==2009|ano_ice==2010) , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_em_PE_CE_semi_int_2003_2014_antigo.xls", excel append label ctitle(`outcome') 

		*Geral PE e CE
		
		/*
		xtreg para notas padronizadsa de PE e CE,  
		
		*/
		xtreg `outcome'2326_std d_ice  d_ano* `controles'  if dep != 4 & ///
			(uf=="PE"|uf=="CE") , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_em_PE_CE_2003_2014_antigo.xls", excel append label ctitle(`outcome') 

		*Geral SP e GO
		/*
		xtreg para notas padronizadsa de SP e GO,  
		
		*/
		
		xtreg `outcome'3552_std d_ice  d_ano* `controles'  if dep !=4 & ///
			(uf=="GO"|uf=="SP") , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_em_SP_GO_2003_2014_antigo.xls", excel append label ctitle(`outcome') 

}
***************************   Resultados Cumulativos  ***************************
/*
Para encontrarmos efeitos cumulativos, precisamos de dummies cumulativas
*/

*Note que aqui é declarado outro painel, onde as unidades de tempo são
*em relação ao ano do ice de cada escola
* Resultados cumulativos
do "$dofiles/dummies_cumulativos_14.do"



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
		d_ano* `controles'  if dep!=4&(tempo==0|tempo==1|tempo==2| tempo==3| ///
		tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 ) , fe cluster(codigo_uf)
	outreg2 using "$output/ICE_resultados_cum_em_2003_2014_antigo.xls", excel append label ctitle(`outcome', 9 anos) 

	/*somente para PE*/
	*sem cluster
	xtreg  `outcome'26_std  d_ice1 d_ice2 d_ice3 d_ice4 d_ice5 d_ice6 d_ice7 d_ice8 d_ice9 ///
		d_ano* `controles'  if dep!=4&(tempo==0|tempo==1|tempo==2| tempo==3| ///
		tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 ) &uf=="PE", fe 
	outreg2 using "$output/ICE_resultados_cum_em_2003_2014_antigo.xls", excel append label ctitle(`outcome', 9 anos, pe) 
	
	/*somente para SP*/
	*sem cluster
	xtreg  `outcome'35_std  d_ice1 d_ice2 d_ice3 d_ice4 d_ice5 d_ice6 d_ice7 d_ice8 d_ice9 ///
		d_ano* `controles'  if dep!=4&(tempo==0|tempo==1|tempo==2| tempo==3| ///
		tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 ) &uf=="SP", fe 
	outreg2 using "$output/ICE_resultados_cum_em_2003_2014_antigo.xls", excel append label ctitle(`outcome', 9 anos, sp) 

}



*****************************   FLUXO   *****************************

* a base de dados para análise de impacto do ice em fluxo é ice_clean.dta
use "$Bases/bases da análise anterior\ice_clean_fluxo.dta", clear
drop if ano==2015

/* 
é uma análise em painel. 
Para tal, vamos definir as variáveis de 
tempo e observação
*/
iis codigo_escola
tis ano

/*
Dropar RJ e ES: no rio e no espírito santo, somente escolas fundamentais tiveram o programa. 
como é uma análise do enem, podemos dropar as observações de escolas do rio do ES
*/
drop if codigo_uf==33 | codigo_uf==32



******************* PSCORE *******************
*chamando o dofile que gera os pscores para ensino médio
do "$dofiles/em_pscore_14.do"

******************* INTERAÇÕES DE TURNO E ALAVANCAS *******************
*gerando dummies de interação de turno e alavancas
do "$dofiles/turno_alavanca_14.do"

****************** PADRONIZAÇÃO DE FLUXO - EM ******************
*gerando ntoas do enem padronizadas
do "$dofiles/em_padronizar_notas_14.do"

***************************   Resultados Gerais  ***************************


/*
selecionando os controles para as estimações - caracteristicas da escola que 
venham a impactar em fluxo médio da escola
*/
	local controles e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios ///
		e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep ///
		rural agua eletricidade esgoto lixo_coleta sala_professores  lab_info ///
		lab_ciencias quadra_esportes biblioteca   internet
/*
foreach que para cada variável de fluxo - aprovação, reprovação, abandono, distância,


faz um xtreg fe, 
com d_ice e d_ano*`controles' (fazendo interação da d_ano com cada um dos controles) 
ie somente os controles do ano vão impactar nos outcomes de fluxo
utilizando o pscore_total como peso
clusterizando o erro por estado

depois da regressão, gera tabelas outreg para excel
*/	

foreach outcome in "apr_em" "rep_em" "aba_em" "dist_em" {

		* Ensino médio geral
		/*
		aqui o xtreg só roda nas escolas cujo dep! = 4 ie
		em todas as escoas do ensino medio em geral que não são privadas
		*/
		xtreg  `outcome'_std d_ice d_ano* `controles'  ///
			if dep!=4, fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_em_2003_2014_antigo.xls", ///
			excel append label ctitle(`outcome', controle pub, tudo) 

		* Ensino médio integral
		/*
		aqui o xtreg só roda nas escolas cujo dep! = 4 e (integral ==1 ou ice==0)  ie
		em todas as escolas do ensino medio em geral que não são privadas
		e que ou são ensino integral somente ou que não receberam o ice
		isto é, ver o impacto do ice integral no outcome
		*/
		xtreg  `outcome'_std d_ice d_ano* `controles'  ///
			if dep!=4 &(integral==1|ice==0) , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_em_2003_2014_antigo.xls", ///
			excel append label ctitle(`outcome', controle pub, integral) 
		
		*Integral vs Semi-Integral
		/*
		aqui o xtreg só roda nas escolas cujo dep! = 4 ie
		em todas as escolas do ensino medio em geral que não são privadas
		colocando interações entre ice e ice integral
		*/
		xtreg  `outcome'_std d_ice d_ice_inte d_ano* `controles'  ///
			if dep!=4 &(integral==1|ice==0) , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_em_2003_2014_antigo.xls", ///
			excel append label ctitle(`outcome', controle pub, integral) 
		lincom d_ice + d_ice_inte 
		/* 
		lincom computes point estimates, standard errors, t or z statistics, 
		p-values, and confidence intervals for linear combinations of coefficients 
		after any estimation command. Results can optionally be displayed as 
		odds ratios, hazard ratios, incidence-rate ratios, or relative-risk ratios
		*/
		
		
		*Por nível de apoio
		
		/*
		Aqui, o xtreg foi restringidos os tratados para só um tipo de nível de apoio
		*/
		xtreg  `outcome'_std d_ice d_ano* `controles'  ///
			if dep!=4&(d_rigor1==1|ice==0)&(integral==1|ice==0), /// 
			fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_em_2003_2014_antigo.xls", ///
			excel append label ctitle(`outcome', apoio forte)

		xtreg  `outcome'_std d_ice d_ano* `controles'  /// 
			if dep!=4&(d_rigor3==1|ice==0)&(integral==1|ice==0), /// 
			fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_em_2003_2014_antigo.xls", ///
			excel append label ctitle(`outcome', apoio medio)

		xtreg  `outcome'_std d_ice d_ano* `controles'  /// 
			if dep!=4&(d_rigor2==1|ice==0)&(integral==1|ice==0), /// 
			fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_em_2003_2014_antigo.xls", ///
			excel append label ctitle(`outcome', apoio fraco)

		xtreg  `outcome'_std d_ice d_ano* `controles'  ///
			if dep!=4&(d_rigor4==1|ice==0)&(integral==1|ice==0), ///
			fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_em_2003_2014_antigo.xls", ///
			excel append label ctitle(`outcome', sem apoio)

		xtreg  `outcome'_std d_ice d_ano* `controles'  ///
			if dep!=4&(d_rigor4==0|ice==0)&(integral==1|ice==0) , ///
			fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_em_2003_2014_antigo.xls", ///
			excel append label ctitle(`outcome', com algum apoio)
	
				
		
}	

**********************************     Resultados por Estado    ****************
/*
Fazendo uma análise similar a anterior 
*/

local controles e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios ///
	e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep ///
	rural agua eletricidade esgoto lixo_coleta sala_professores lab_info ///
	lab_ciencias quadra_esportes biblioteca internet

	*Geral Estado
foreach outcome in "apr_em" "rep_em" "aba_em" "dist_em" {
	
	/*
	aqui faz a xtereg para cada uma das variáveis de fluxo,,
	limitando a amostra em escolas não privadas e só especificamente no estado
	em questão
	*/
		foreach xx in 23 26 35 52 {
			xtreg `outcome'`xx'_std d_ice d_ano* `controles'  ///
				if dep!=4  & codigo_uf==`xx', fe 
			outreg2 using "$output/ICE_resultados_em_`xx'_2003_2014_antigo.xls", ///
				excel append label ctitle(`outcome') 
		}
	*Interegral vs Semi PE 
	/*
	xtreg para as variáveis de fluxo de PE, 
	com dummy de período integral,
	para os anos de 2008, 2009, 2010
	*/
	
	xtreg `outcome'26_std d_ice d_ice_inte d_ano* `controles' /// 
		 if dep != 4 & (uf=="PE") & ///
		(ano_ice==2008|ano_ice==2009|ano_ice==2010) , fe 
	outreg2 using "$output/ICE_resultados_em_PE_semi_int_2003_2014_antigo.xls", ///
		excel append label ctitle(`outcome') 

	*Interegral vs Semi PE e CE
	/*
	xtreg para as variáveis de fluxo de PE, com dummy de período integral, 
	paraos anos de 2008, 2009, 2010
	*/
	xtreg `outcome'2326_std d_ice d_ice_inte d_ano* `controles' ///
		 if dep!=4&(uf=="PE"|uf=="CE") & ///
		(ano_ice==2008|ano_ice==2009|ano_ice==2010) , fe cluster(codigo_uf)
	outreg2 using "$output/ICE_resultados_em_PE_CE_semi_int_2003_2014_antigo.xls", ///
		excel append label ctitle(`outcome') 

	
	*Geral PE e CE
	
	/*
	xtreg para as variáveis de fluxo de PE e CE,  
	
	*/
	xtreg `outcome'2326_std d_ice  d_ano* `controles' ///
		 if dep!=4&(uf=="PE"|uf=="CE") , ///
		fe cluster(codigo_uf)
	outreg2 using "$output/ICE_resultados_em_PE_CE_2003_2014_antigo.xls", ///
		excel append label ctitle(`outcome') 

	*Geral SP e GO
	/*
	xtreg para notas padronizadsa de PE e CE,  
	
	*/
	xtreg `outcome'3552_std d_ice  d_ano* `controles' ///
		 if dep!=4&(uf=="GO"|uf=="SP") , ///
		fe cluster(codigo_uf)
	outreg2 using "$output/ICE_resultados_em_SP_GO_2003_2014_antigo.xls", ///
		excel append label ctitle(`outcome') 

}
**********************************     Resultados cumulativos    ****************
/*
Para encontrarmos efeitos cumulativos, precisamos de deummies cumulativas
*/

*Note que aqui é declarado outro painel, onde as unidades de tempo são
*em relação ao ano do ice de cada escola
* Resultados cumulativos

do "$dofiles/dummies_cumulativos_14.do"

/*
Aqui, xtreg fixed effects será feito com os controles usuais 
interagindo com o ano em questão
teremos uma dummy para cada ano de participação da escola no programa
e também, para o ano anterior
o pseo será o propensity score já calculado previamente
escolas privadas serão desconsideradas nessas análises
*/


foreach outcome in "apr_em" "rep_em" "aba_em" "dist_em" {
	*Acumulado
	xtreg  `outcome'_std  d_ice1 d_ice2 d_ice3 d_ice4 d_ice5 d_ice6 d_ice7 ///
		d_ice8 d_ice9  d_ano* `controles'  if dep!=4 /// 
		&(tempo==0| tempo==1|tempo==2| tempo==3| tempo==4 | tempo==5 | ///
		tempo==6| tempo==7 | tempo==8 | tempo==9 ) , fe cluster(codigo_uf)
	outreg2 using "$output/ICE_resultados_cum_em_2003_2014_antigo.xls", ///
		excel append label ctitle(`outcome', 9 anos) 

	xtreg  `outcome'26_std  d_ice1 d_ice2 d_ice3 d_ice4 d_ice5 d_ice6 d_ice7 ///
		d_ice8 d_ice9  d_ano* `controles'  if dep!=4 /// 
		& (tempo==0| tempo==1|tempo==2| tempo==3| tempo==4 | tempo==5 ///
		| tempo==6| tempo==7 | tempo==8 | tempo==9 ) &uf=="PE", fe 
	outreg2 using "$output/ICE_resultados_cum_em_2003_2014_antigo.xls", ///
		excel append label ctitle(`outcome', 9 anos, pe) 

	xtreg `outcome'35_std  d_ice1 d_ice2 d_ice3 d_ice4 d_ice5 d_ice6 d_ice7 ///
		d_ice8 d_ice9  d_ano* `controles'  if dep!=4 ///
		& (tempo==0| tempo==1|tempo==2| tempo==3| tempo==4 | tempo==5 ///
		| tempo==6| tempo==7 | tempo==8 | tempo==9 ) &uf=="SP", fe 
	outreg2 using "$output/ICE_resultados_cum_em_2003_2014_antigo.xls", ///
		excel append label ctitle(`outcome', 9 anos, sp) 

}







log close





