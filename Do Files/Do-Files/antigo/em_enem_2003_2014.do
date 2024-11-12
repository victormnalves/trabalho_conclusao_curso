/*----------------------------Ensino M�dio - ENEM e fluxo---------------------------*/
/*
aqui vamos estimar o impacto do programa ICE nas nota e em fluxo
como o programa n�o foi aleatoriezado, fazer um propensity score matching
em seguida, ser� necess�rio criar as dummies de alavanca e fazer intera��es
de turno
depois, padronizar as notas
com todas essas etaps, ser�o estimados regerss�es em painel ponderadas pelo
propensity score
*/
capture log close

clear all
set more off


*cd "`:environment USERPROFILE'\OneDrive\EESP - ECONOMIA - mestrado acad�mico\Disserta��o\ICE\dados ICE"
global user "`:environment USERPROFILE'"
*global Folder "$user/OneDrive/EESP_ECONOMIA_mestrado_acad�mico/Disserta��o/ICE/dados_ICE/An�lise_Leonardo"
global Folder "D:\OneDrive\EESP_ECONOMIA_mestrado_acad�mico\Disserta��o\ICE\dados_ICE\An�lise_Leonardo"
global output "$Folder/resultados"
global Bases "$Folder/Bases"
global dofiles "$Folder/Do-Files"
global Logfolder "$Folder/Log"

log using "$Logfolder/em_enem.log", replace

/*------------------------- Estima��es e Resultados-------------------------*/
/*
Notas:
	resultados gerais
		
	resultados por estados
	resultados cumulativos
vari�veis de fluxo:
	resultados gerais
	resultados por estados
	resultados cumulativos
*/

*****************************   NOTAS   *****************************

* a base de dados para an�lise de impacto do ice em nota � ice_clean.dta
use "$Bases/ice_clean_notas.dta", clear

drop if ano==2015
/* 
� uma an�lise em painel. 
Para tal, vamos definir as vari�veis de 
tempo e observa��o
*/
iis codigo_escola
tis ano

/*
Dropar RJ e ES: no rio e no esp�rito santo, somente escolas fundamentais tiveram o programa. 
como � uma an�lise do enem, podemos dropar as observa��es de escolas do rio do ES
*/
drop if codigo_uf==33 | codigo_uf==32

******************* PSCORE *******************
*chamando o dofile que gera os pscores para ensino m�dio
do "$dofiles/em_pscore.do"

******************* INTERA��ES DE TURNO E ALAVANCAS *******************
*gerando dummies de intera��o de turno e alavancas
do "$dofiles/turno_alavanca.do"

****************** PADRONIZA��O DE NOTAS - EM ******************
*gerando notas do enem padronizadas por estado
do "$dofiles/em_padronizar_notas.do"


***************************   Resultados Gerais  ***************************

/*
selecionando os controles para as estima��es - caracteristicas da escola que 
venham a impactar a nota m�dia do enem da escola
*/
local controles e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria ///
n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep  rural agua eletricidade ///
esgoto lixo_coleta sala_professores  lab_info lab_ciencias quadra_esportes biblioteca  /// 
internet
	 
/*
foreach que para cada nota padronizada,

faz um xtreg fe, 
com d_ice e d_ano*`controles' (fazendo intera��o da d_ano com cada um dos controles) 
ie somente os controles do ano v�o impactar nos outcomes notas
utilizando o pscore_total como peso
clusterizando o erro por estado

depois da regress�o, gera tabelas outreg para excel
*/	 
foreach outcome in "enem_nota_matematica" "enem_nota_ciencias" "enem_nota_humanas" ///
	"enem_nota_linguagens" "enem_nota_redacao" "enem_nota_objetivab" {
	

	*Lembrando que enem_nota_objetivab � ou a nota da prova objetiva quando era s� uma prova, ou a soma das notas das provas objetivas, quando eram quatro provas
	*Controlando por carateristicas dos alunos e da escola 
	*------------------------------------------------------
		*a vari�vel integral vem da base do ice
		* Ensino m�dio geral
		/*
		aqui o xtreg s� roda nas escolas cujo dep! = 4 ie
		em todas as escoas do ensino medio em geral que n�o s�o privadas
		*/
		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] if dep!=4  , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_2003_2014.xls", excel append label ctitle(`outcome', controle pub, tudo) 

		* Ensino m�dio integral
		/*
		aqui o xtreg s� roda nas escolas cujo dep! = 4 e (integral ==1 ou ice==0)  ie
		em todas as escolas do ensino medio em geral que n�o s�o privadas
		e que ou s�o ensino integral somente ou que n�o receberam o ice
		isto �, ver o impacto do ice integral no outcome
		*/	
		
		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] if dep!=4 &(integral==1|ice==0) , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_2003_2014.xls", excel append label ctitle(`outcome', controle pub, integral) 

		*Integral vs Semi-Integral
		/*
		aqui o xtreg s� roda nas escolas cujo dep! = 4 ie
		em todas as escoas do ensino medio em geral que n�o s�o privadas
		colocando intera��es entre ice e ice integral e escolhendo escolas com integral e semi integral
		d_ice_inte: indica se a escola, em um dado ano, entrou no programa na modalidade integral
		*/
		xtreg  `outcome'_std d_ice d_ice_inte d_ano* `controles' [pw=pscore_total] if dep!=4 , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_2003_2014.xls", excel append label ctitle(`outcome', controle pub) 
		lincom d_ice + d_ice_inte 

		*Por n�vel de apoio
		
		/*
		Aqui, o xtreg foi restringidos os tratados para s� um tipo de n�vel de apoio
		
		replace ice_rigor="Sem Apoio" if ice_rigor==""&ice==1
		tab ice_rigor if ice==1, gen(d_rigor)
		
		d_rigor1 indica se rigor foi forte
		d_rigor2 indica se rigor foi fraco
		d_rigor3 indica se rigor foi m�dio
		d_rigor4 indica se n�o houve rigor

		*/
		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] if dep!=4&(d_rigor1==1|ice==0) & ///
			(integral==1|ice==0), fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_2003_2014.xls", excel append label ctitle(`outcome', apoio forte)

		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] if dep!=4&(d_rigor3==1|ice==0) & ///
			(integral==1|ice==0), fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_2003_2014.xls", excel append label ctitle(`outcome', apoio medio)

		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] if dep!=4&(d_rigor2==1|ice==0) & ///
			(integral==1|ice==0), fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_2003_2014.xls", excel append label ctitle(`outcome', apoio fraco)

		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] if dep!=4&(d_rigor4==1|ice==0) & ///
			(integral==1|ice==0), fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_2003_2014.xls", excel append label ctitle(`outcome', sem apoio)

		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] if dep!=4&(d_rigor4==0|ice==0) & ///
			(integral==1|ice==0) , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_2003_2014.xls", excel append label ctitle(`outcome', com algum apoio)
}


***************************   Resultados por Estado  ***************************
/*
Fazendo uma an�lise similar a anterior, no entando, como vari�vel dependente temos
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
		limitando a amostra em escolas n�o privadas e s� especificamente no estado
		em quest�o
		*/
		foreach uf in 23 26 35 52 {
			xtreg `outcome'`uf'_std d_ice d_ano* `controles' [pw=pscore_total] if dep != 4  & codigo_uf == `uf', fe 
			outreg2 using "$output/ICE_resultados_ps_em_`uf'_2003_2014.xls", excel append label ctitle(`outcome') 
		}

		*Interegral vs Semi PE
		/*
		xtreg para notas padronizadas de PE, com dummy de per�odo integral, para 
		os anos de 2008, 2009, 2010
		*/
		xtreg `outcome'26_std d_ice d_ice_inte d_ano* `controles' [pw=pscore_total] if dep != 4 & (uf == "PE") & ///
				(ano_ice==2008|ano_ice==2009|ano_ice==2010) , fe 
		outreg2 using "$output/ICE_resultados_ps_em_PE_semi_int_2003_2014.xls", excel append label ctitle(`outcome') 

		*Interegral vs Semi PE e CE
		/*
		xtreg para notas padronizadas de PE e CE,
		com dummy de per�odo integral, para 
		os anos de 2008, 2009, 2010
		*/
		xtreg `outcome'2326_std d_ice d_ice_inte d_ano* `controles' [pw=pscore_total] if dep != 4 & ///
			(uf=="PE"|uf=="CE")&(ano_ice==2008|ano_ice==2009|ano_ice==2010) , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_PE_CE_semi_int_2003_2014.xls", excel append label ctitle(`outcome') 

		*Geral PE e CE
		
		/*
		xtreg para notas padronizadsa de PE e CE,  
		
		*/
		xtreg `outcome'2326_std d_ice  d_ano* `controles' [pw=pscore_total] if dep != 4 & ///
			(uf=="PE"|uf=="CE") , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_PE_CE_2003_2014.xls", excel append label ctitle(`outcome') 

		*Geral SP e GO
		/*
		xtreg para notas padronizadsa de SP e GO,  
		
		*/
		
		xtreg `outcome'3552_std d_ice  d_ano* `controles' [pw=pscore_total] if dep !=4 & ///
			(uf=="GO"|uf=="SP") , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_SP_GO_2003_2014.xls", excel append label ctitle(`outcome') 

}
***************************   Resultados Cumulativos  ***************************
/*
Para encontrarmos efeitos cumulativos, precisamos de dummies cumulativas
*/

*Note que aqui � declarado outro painel, onde as unidades de tempo s�o
*em rela��o ao ano do ice de cada escola
* Resultados cumulativos
do "$dofiles/dummies_cumulativos.do"



local controles e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria ///
n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep rural agua eletricidade ///
esgoto lixo_coleta sala_professores  lab_info lab_ciencias quadra_esportes biblioteca ///
internet

/*
Aqui, xtreg fixed effects ser� feito com os controles usuais interagindo com o ano em quest�o
mais, teremos uma dummy para cada ano de participa��o da escola no programa
e tamb�m, para o ano anterior
o peso ser� o propensity score j� calculado previamente
escolas privadas ser�o desconsideradas nessas an�lises
*/
foreach outcome in "enem_nota_objetivab" {
	*Acumulado
	xtreg  `outcome'_std  d_ice1 d_ice2 d_ice3 d_ice4 d_ice5 d_ice6 d_ice7 d_ice8 d_ice9  ///
		d_ano* `controles' [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2| tempo==3| ///
		tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 ) , fe cluster(codigo_uf)
	outreg2 using "$output/ICE_resultados_cum_em_2003_2014.xls", excel append label ctitle(`outcome', 9 anos) 

	/*somente para PE*/
	*sem cluster
	xtreg  `outcome'26_std  d_ice1 d_ice2 d_ice3 d_ice4 d_ice5 d_ice6 d_ice7 d_ice8 d_ice9 ///
		d_ano* `controles' [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2| tempo==3| ///
		tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 ) &uf=="PE", fe 
	outreg2 using "$output/ICE_resultados_cum_em_2003_2014.xls", excel append label ctitle(`outcome', 9 anos, pe) 
	
	/*somente para SP*/
	*sem cluster
	xtreg  `outcome'35_std  d_ice1 d_ice2 d_ice3 d_ice4 d_ice5 d_ice6 d_ice7 d_ice8 d_ice9 ///
		d_ano* `controles' [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2| tempo==3| ///
		tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 ) &uf=="SP", fe 
	outreg2 using "$output/ICE_resultados_cum_em_2003_2014.xls", excel append label ctitle(`outcome', 9 anos, sp) 

}



*****************************   FLUXO   *****************************

* a base de dados para an�lise de impacto do ice em fluxo � ice_clean.dta
use "$Bases/ice_clean_fluxo.dta", clear
drop if ano==2015

/* 
� uma an�lise em painel. 
Para tal, vamos definir as vari�veis de 
tempo e observa��o
*/
iis codigo_escola
tis ano

/*
Dropar RJ e ES: no rio e no esp�rito santo, somente escolas fundamentais tiveram o programa. 
como � uma an�lise do enem, podemos dropar as observa��es de escolas do rio do ES
*/
drop if codigo_uf==33 | codigo_uf==32



******************* PSCORE *******************
*chamando o dofile que gera os pscores para ensino m�dio
do "$dofiles/em_pscore.do"

******************* INTERA��ES DE TURNO E ALAVANCAS *******************
*gerando dummies de intera��o de turno e alavancas
do "$dofiles/turno_alavanca.do"

****************** PADRONIZA��O DE FLUXO - EM ******************
*gerando ntoas do enem padronizadas
do "$dofiles/em_padronizar_notas.do"

***************************   Resultados Gerais  ***************************


/*
selecionando os controles para as estima��es - caracteristicas da escola que 
venham a impactar em fluxo m�dio da escola
*/
	local controles e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios ///
		e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep ///
		rural agua eletricidade esgoto lixo_coleta sala_professores  lab_info ///
		lab_ciencias quadra_esportes biblioteca   internet
/*
foreach que para cada vari�vel de fluxo - aprova��o, reprova��o, abandono, dist�ncia,


faz um xtreg fe, 
com d_ice e d_ano*`controles' (fazendo intera��o da d_ano com cada um dos controles) 
ie somente os controles do ano v�o impactar nos outcomes de fluxo
utilizando o pscore_total como peso
clusterizando o erro por estado

depois da regress�o, gera tabelas outreg para excel
*/	

foreach outcome in "apr_em" "rep_em" "aba_em" "dist_em" {

		* Ensino m�dio geral
		/*
		aqui o xtreg s� roda nas escolas cujo dep! = 4 ie
		em todas as escoas do ensino medio em geral que n�o s�o privadas
		*/
		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] ///
			if dep!=4, fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_2003_2014.xls", ///
			excel append label ctitle(`outcome', controle pub, tudo) 

		* Ensino m�dio integral
		/*
		aqui o xtreg s� roda nas escolas cujo dep! = 4 e (integral ==1 ou ice==0)  ie
		em todas as escolas do ensino medio em geral que n�o s�o privadas
		e que ou s�o ensino integral somente ou que n�o receberam o ice
		isto �, ver o impacto do ice integral no outcome
		*/
		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] ///
			if dep!=4 &(integral==1|ice==0) , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_2003_2014.xls", ///
			excel append label ctitle(`outcome', controle pub, integral) 
		
		*Integral vs Semi-Integral
		/*
		aqui o xtreg s� roda nas escolas cujo dep! = 4 ie
		em todas as escolas do ensino medio em geral que n�o s�o privadas
		colocando intera��es entre ice e ice integral
		*/
		xtreg  `outcome'_std d_ice d_ice_inte d_ano* `controles' [pw=pscore_total] ///
			if dep!=4 &(integral==1|ice==0) , fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_2003_2014.xls", ///
			excel append label ctitle(`outcome', controle pub, integral) 
		lincom d_ice + d_ice_inte 
		/* 
		lincom computes point estimates, standard errors, t or z statistics, 
		p-values, and confidence intervals for linear combinations of coefficients 
		after any estimation command. Results can optionally be displayed as 
		odds ratios, hazard ratios, incidence-rate ratios, or relative-risk ratios
		*/
		
		
		*Por n�vel de apoio
		
		/*
		Aqui, o xtreg foi restringidos os tratados para s� um tipo de n�vel de apoio
		*/
		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] ///
			if dep!=4&(d_rigor1==1|ice==0)&(integral==1|ice==0), /// 
			fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_2003_2014.xls", ///
			excel append label ctitle(`outcome', apoio forte)

		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] /// 
			if dep!=4&(d_rigor3==1|ice==0)&(integral==1|ice==0), /// 
			fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_2003_2014.xls", ///
			excel append label ctitle(`outcome', apoio medio)

		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] /// 
			if dep!=4&(d_rigor2==1|ice==0)&(integral==1|ice==0), /// 
			fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_2003_2014.xls", ///
			excel append label ctitle(`outcome', apoio fraco)

		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] ///
			if dep!=4&(d_rigor4==1|ice==0)&(integral==1|ice==0), ///
			fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_2003_2014.xls", ///
			excel append label ctitle(`outcome', sem apoio)

		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] ///
			if dep!=4&(d_rigor4==0|ice==0)&(integral==1|ice==0) , ///
			fe cluster(codigo_uf)
		outreg2 using "$output/ICE_resultados_ps_em_2003_2014.xls", ///
			excel append label ctitle(`outcome', com algum apoio)
	
				
		
}	

**********************************     Resultados por Estado    ****************
/*
Fazendo uma an�lise similar a anterior 
*/

local controles e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios ///
	e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep ///
	rural agua eletricidade esgoto lixo_coleta sala_professores lab_info ///
	lab_ciencias quadra_esportes biblioteca internet

	*Geral Estado
foreach outcome in "apr_em" "rep_em" "aba_em" "dist_em" {
	
	/*
	aqui faz a xtereg para cada uma das vari�veis de fluxo,,
	limitando a amostra em escolas n�o privadas e s� especificamente no estado
	em quest�o
	*/
		foreach xx in 23 26 35 52 {
			xtreg `outcome'`xx'_std d_ice d_ano* `controles' [pw=pscore_total] ///
				if dep!=4  & codigo_uf==`xx', fe 
			outreg2 using "$output/ICE_resultados_ps_em_`xx'_2003_2014.xls", ///
				excel append label ctitle(`outcome') 
		}
	*Interegral vs Semi PE 
	/*
	xtreg para as vari�veis de fluxo de PE, 
	com dummy de per�odo integral,
	para os anos de 2008, 2009, 2010
	*/
	
	xtreg `outcome'26_std d_ice d_ice_inte d_ano* `controles' /// 
		[pw=pscore_total] if dep != 4 & (uf=="PE") & ///
		(ano_ice==2008|ano_ice==2009|ano_ice==2010) , fe 
	outreg2 using "$output/ICE_resultados_ps_em_PE_semi_int_2003_2014.xls", ///
		excel append label ctitle(`outcome') 

	*Interegral vs Semi PE e CE
	/*
	xtreg para as vari�veis de fluxo de PE, com dummy de per�odo integral, 
	paraos anos de 2008, 2009, 2010
	*/
	xtreg `outcome'2326_std d_ice d_ice_inte d_ano* `controles' ///
		[pw=pscore_total] if dep!=4&(uf=="PE"|uf=="CE") & ///
		(ano_ice==2008|ano_ice==2009|ano_ice==2010) , fe cluster(codigo_uf)
	outreg2 using "$output/ICE_resultados_ps_em_PE_CE_semi_int_2003_2014.xls", ///
		excel append label ctitle(`outcome') 

	
	*Geral PE e CE
	
	/*
	xtreg para as vari�veis de fluxo de PE e CE,  
	
	*/
	xtreg `outcome'2326_std d_ice  d_ano* `controles' ///
		[pw=pscore_total] if dep!=4&(uf=="PE"|uf=="CE") , ///
		fe cluster(codigo_uf)
	outreg2 using "$output/ICE_resultados_ps_em_PE_CE_2003_2014.xls", ///
		excel append label ctitle(`outcome') 

	*Geral SP e GO
	/*
	xtreg para notas padronizadsa de PE e CE,  
	
	*/
	xtreg `outcome'3552_std d_ice  d_ano* `controles' ///
		[pw=pscore_total] if dep!=4&(uf=="GO"|uf=="SP") , ///
		fe cluster(codigo_uf)
	outreg2 using "$output/ICE_resultados_ps_em_SP_GO_2003_2014.xls", ///
		excel append label ctitle(`outcome') 

}
**********************************     Resultados cumulativos    ****************
/*
Para encontrarmos efeitos cumulativos, precisamos de deummies cumulativas
*/

*Note que aqui � declarado outro painel, onde as unidades de tempo s�o
*em rela��o ao ano do ice de cada escola
* Resultados cumulativos

do "$dofiles/dummies_cumulativos.do"

/*
Aqui, xtreg fixed effects ser� feito com os controles usuais 
interagindo com o ano em quest�o
teremos uma dummy para cada ano de participa��o da escola no programa
e tamb�m, para o ano anterior
o pseo ser� o propensity score j� calculado previamente
escolas privadas ser�o desconsideradas nessas an�lises
*/


foreach outcome in "apr_em" "rep_em" "aba_em" "dist_em" {
	*Acumulado
	xtreg  `outcome'_std  d_ice1 d_ice2 d_ice3 d_ice4 d_ice5 d_ice6 d_ice7 ///
		d_ice8 d_ice9  d_ano* `controles' [pw=pscore_total] if dep!=4 /// 
		&(tempo==0| tempo==1|tempo==2| tempo==3| tempo==4 | tempo==5 | ///
		tempo==6| tempo==7 | tempo==8 | tempo==9 ) , fe cluster(codigo_uf)
	outreg2 using "$output/ICE_resultados_cum_em_2003_2014.xls", ///
		excel append label ctitle(`outcome', 9 anos) 

	xtreg  `outcome'26_std  d_ice1 d_ice2 d_ice3 d_ice4 d_ice5 d_ice6 d_ice7 ///
		d_ice8 d_ice9  d_ano* `controles' [pw=pscore_total] if dep!=4 /// 
		& (tempo==0| tempo==1|tempo==2| tempo==3| tempo==4 | tempo==5 ///
		| tempo==6| tempo==7 | tempo==8 | tempo==9 ) &uf=="PE", fe 
	outreg2 using "$output/ICE_resultados_cum_em_2003_2014.xls", ///
		excel append label ctitle(`outcome', 9 anos, pe) 

	xtreg `outcome'35_std  d_ice1 d_ice2 d_ice3 d_ice4 d_ice5 d_ice6 d_ice7 ///
		d_ice8 d_ice9  d_ano* `controles' [pw=pscore_total] if dep!=4 ///
		& (tempo==0| tempo==1|tempo==2| tempo==3| tempo==4 | tempo==5 ///
		| tempo==6| tempo==7 | tempo==8 | tempo==9 ) &uf=="SP", fe 
	outreg2 using "$output/ICE_resultados_cum_em_2003_2014.xls", ///
		excel append label ctitle(`outcome', 9 anos, sp) 

}

log close
