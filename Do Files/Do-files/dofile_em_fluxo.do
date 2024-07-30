********************************************************************************
*									EM										   *
********************************************************************************


	use "$Folder/ice_clean_fluxo.dta", clear

	* Painel
	iis codigo_escola
	tis ano

	*Dropar RJ
	drop if codigo_uf==33

	* Gerar pscores
	do "$Dofiles/pscore.do"

	* Interacoees de turno e alavancas
	do "$Dofiles/turno_alavanca.do"

	* Padronizar
	do "$Dofiles/padronizar_notas.do"

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
		outreg2 using "${output}ICE_resultados_ps_em_new.xls", ///
			excel append label ctitle(`outcome', controle pub, tudo) 

		* Ensino médio integral
		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] if dep!=4 ///
			&(integral==1|ice==0) , fe cluster(codigo_uf)
		outreg2 using "${output}ICE_resultados_ps_em_new.xls", ///
			excel append label ctitle(`outcome', controle pub, integral) 

		*Integral vs Semi-Integral
		xtreg  `outcome'_std d_ice d_ice_inte d_ano* `controles' [pw=pscore_total] ///
			if dep!=4 , fe cluster(codigo_uf)
		outreg2 using "${output}ICE_resultados_ps_em_new.xls", ///
			excel append label ctitle(`outcome', controle pub) 
		lincom d_ice + d_ice_inte 

		*Por nível de apoio
		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] if ///
			dep!=4&(d_rigor1==1|ice==0)&(integral==1|ice==0), fe cluster(codigo_uf)
		outreg2 using "${output}ICE_resultados_ps_em_new.xls", ///
			excel append label ctitle(`outcome', apoio forte)

		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] if ///
			dep!=4&(d_rigor3==1|ice==0)&(integral==1|ice==0), fe cluster(codigo_uf)
		outreg2 using "${output}ICE_resultados_ps_em_new.xls", ///
			excel append label ctitle(`outcome', apoio medio)

		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] if ///
			dep!=4&(d_rigor2==1|ice==0)&(integral==1|ice==0), fe cluster(codigo_uf)
		outreg2 using "${output}ICE_resultados_ps_em_new.xls", ///
			excel append label ctitle(`outcome', apoio fraco)

		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] if ///
			dep!=4&(d_rigor4==1|ice==0)&(integral==1|ice==0), fe cluster(codigo_uf)
		outreg2 using "${output}ICE_resultados_ps_em_new.xls", ///
			excel append label ctitle(`outcome', sem apoio)

		xtreg  `outcome'_std d_ice d_ano* `controles' [pw=pscore_total] if ///
			dep!=4&(d_rigor4==0|ice==0)&(integral==1|ice==0) , fe cluster(codigo_uf)
		outreg2 using "${output}ICE_resultados_ps_em_new.xls", ///
			excel append label ctitle(`outcome', com algum apoio)
	}


	********************************************************************************
	*									Resultados Por Estado                      *
	********************************************************************************
	
	local controles e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria ///
		n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep rural agua eletricidade ///
		esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca internet

	*Geral Estado
	foreach outcome in "apr_em" "rep_em" "aba_em" "dist_em" {
		foreach xx in 23 26 35 52 {
			xtreg `outcome'`xx'_std d_ice d_ano* `controles' [pw=pscore_total] if dep!=4  & codigo_uf==`xx', fe 
			outreg2 using "${output}ICE_resultados_ps_em_`xx'_new.xls", excel append label ctitle(`outcome') 
		}
		
		*Interegral vs Semi PE 
		xtreg `outcome'26_std d_ice d_ice_inte d_ano* `controles' [pw=pscore_total] ///
			if dep!=4&(uf=="PE")&(ano_ice==2008|ano_ice==2009|ano_ice==2010) , fe 
		outreg2 using "${output}ICE_resultados_ps_em_PE_semi_int.xls", excel append label ctitle(`outcome') 

		*Interegral vs Semi PE e CE
		xtreg `outcome'2326_std d_ice d_ice_inte d_ano* `controles' [pw=pscore_total] ///
			if dep!=4&(uf=="PE"|uf=="CE")&(ano_ice==2008|ano_ice==2009|ano_ice==2010) , fe cluster(codigo_uf)
		outreg2 using "${output}ICE_resultados_ps_em_PE_CE_semi_int.xls", excel append label ctitle(`outcome') 

		*Geral PE e CE
		xtreg `outcome'2326_std d_ice  d_ano* `controles' [pw=pscore_total] if ///
			dep!=4&(uf=="PE"|uf=="CE") , fe cluster(codigo_uf)
		outreg2 using "${output}ICE_resultados_ps_em_PE_CE.xls", excel append label ctitle(`outcome') 

		*Geral SP e GP
		xtreg `outcome'3552_std d_ice  d_ano* `controles' [pw=pscore_total] if dep!=4&(uf=="GO"|uf=="SP") , fe cluster(codigo_uf)
		outreg2 using "${output}ICE_resultados_ps_em_SP_GO.xls", excel append label ctitle(`outcome') 

	}
	********************************************************************************
	* 							Resultados cumulativos							   *
	********************************************************************************
	
	*Dummies Cumulativos - Declara outro painel - Nao trocar de ordem
	do "$Dofiles/dummies_cumulativos.do"

	foreach outcome in "apr_em" "rep_em" "aba_em" "dist_em" {
		*Acumulado
		xtreg  `outcome'_std  d_ice1 d_ice2 d_ice3 d_ice4 d_ice5 d_ice6 d_ice7 ///
			d_ice8 d_ice9  d_ano* `controles' [pw=pscore_total] if dep!=4&(tempo==0| ///
			tempo==1|tempo==2| tempo==3| tempo==4 | tempo==5 | tempo==6| tempo==7 | ///
			tempo==8 | tempo==9 ) , fe cluster(codigo_uf)
		outreg2 using "${output}ICE_resultados_cum_em_new.xls", excel append label ctitle(`outcome', 9 anos) 

		xtreg  `outcome'26_std  d_ice1 d_ice2 d_ice3 d_ice4 d_ice5 d_ice6 d_ice7 ///
			d_ice8 d_ice9  d_ano* `controles' [pw=pscore_total] if dep!=4&(tempo==0| ///
			tempo==1|tempo==2| tempo==3| tempo==4 | tempo==5 | tempo==6| tempo==7 | ///
			tempo==8 | tempo==9 ) &uf=="PE", fe 
		outreg2 using "${output}ICE_resultados_cum_em_new.xls", excel append label ctitle(`outcome', 9 anos, pe) 

		xtreg  `outcome'35_std  d_ice1 d_ice2 d_ice3 d_ice4 d_ice5 d_ice6 d_ice7 ///
			d_ice8 d_ice9  d_ano* `controles' [pw=pscore_total] if dep!=4&(tempo==0| ///
			tempo==1|tempo==2| tempo==3| tempo==4 | tempo==5 | tempo==6| tempo==7 | ///
			tempo==8 | tempo==9 ) &uf=="SP", fe 
		outreg2 using "${output}ICE_resultados_cum_em_new.xls", excel append label ctitle(`outcome', 9 anos, sp) 

	}

