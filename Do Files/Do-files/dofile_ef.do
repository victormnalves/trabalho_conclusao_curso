********************************************************************************
*									RESULTADOS EF 
********************************************************************************

	set matsize 10000
	use "$Folder/ice_clean.dta", clear

	keep if n_alunos_ef>0
	keep if codigo_uf==33|codigo_uf==35

	* Painel
	iis codigo_escola
	tis ano

	replace ice=0 if ensino_fundamental==0

	*Pscore
	do "$Dofiles/pscore_ef.do"

	* Interacoees de turno e alavancas
	do "$Dofiles/turno_alavanca.do"

	* Padronizar
	do "$Dofiles/padronizar_notas.do"

	*---------------------------------------------------------------------------
	* 										Resultados
	*---------------------------------------------------------------------------	

	local controles pb_esc_sup_mae pb_esc_sup_pai n_alunos_ef_em_ep ///
	n_mulheres_ef_em_ep n_brancos_ef_em_ep rural agua eletricidade esgoto ///
	lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca ///
	internet
	
	foreach outcomes in "media_lp_prova_brasil_9_std" "media_mt_prova_brasil_9_std" ///
				 "media_pb_9_std" "apr_ef_std" "rep_ef_std" "aba_ef_std" "dist_ef_std" {

		*Geral
		xtreg `outcomes' d_ice d_ano* `controles' [pw=pscore_total] if dep!=4 , ///
			fe cluster(codigo_uf)
		outreg2 using "${output}ICE_resultados_ps_ef.xls", ///
			excel append label ctitle(`outcomes', controle pub) 

		*Por nnível de apoio
		xtreg `outcomes' d_ice d_ano* `controles' [pw=pscore_total] if ///
			dep!=4&(d_rigor1==1|ice==0), fe cluster(codigo_uf)
		outreg2 using "${output}ICE_resultados_ps_ef.xls", ///
			excel append label ctitle(`outcomes', apoio forte)

		xtreg `outcomes' d_ice d_ano* `controles' [pw=pscore_total] if ///
			dep!=4&(d_rigor3==1|ice==0), fe cluster(codigo_uf)
		outreg2 using "${output}ICE_resultados_ps_ef.xls", ///
			excel append label ctitle(`outcomes', apoio medio)

		xtreg `outcomes' d_ice d_ano* `controles' [pw=pscore_total] if ///
			dep!=4&(d_rigor2==1|ice==0), fe cluster(codigo_uf)
		outreg2 using "${output}ICE_resultados_ps_ef.xls", ///
			excel append label ctitle(`outcomes', apoio fraco)

		xtreg `outcomes' d_ice d_ano* `controles' [pw=pscore_total] if ///
			dep!=4&(d_rigor4==1|ice==0), fe cluster(codigo_uf)
		outreg2 using "${output}ICE_resultados_ps_ef.xls", ///
			excel append label ctitle(`outcomes', sem apoio)

		xtreg `outcomes' d_ice d_ano* `controles' [pw=pscore_total] if ///
			dep!=4&(d_rigor4==0|ice==0) , fe cluster(codigo_uf)
		outreg2 using "${output}ICE_resultados_ps_ef.xls", ///
			excel append label ctitle(`outcomes', com algum apoio)

	}

	*---------------------------------------------------------------------------
	*								POR ESTADO EF 
	*---------------------------------------------------------------------------

	use "$Folder/ice_clean.dta", clear

	* Painel
	iis codigo_escola
	tis ano

	keep if codigo_uf==33|codigo_uf==35|codigo_uf==23|codigo_uf==26

	drop if ice_seg=="EM"
	replace ice=0 if ensino_fundamental==0

	do "$Dofiles/pscore_ef.do"
	
	keep if ano==2009|ano==2011|ano==2013

	* Interacoees de turno e alavancas
	do "$Dofiles/turno_alavanca.do"

	* Padronizar
	do "$Dofiles/padronizar_notas.do"
	
	local controles pb_esc_sup_mae pb_esc_sup_pai nalunos nbrancos nmulheres ///
	rural agua eletricidade esgoto lixo_coleta sala_professores lab_info ///
	lab_ciencias quadra_esportes biblioteca   internet


	* Geral
	foreach outcomes in "media_lp_prova_brasil_9" "media_mt_prova_brasil_9"  ///
						"media_pb_9" "apr_ef" "rep_ef"  "aba_ef" "dist_ef" {
		foreach uf in 33 35  {
			xtreg `outcomes'`uf'_std d_ice d_ano* `controles' [pw=pscore_total] if ///
				dep!=4  & codigo_uf==`uf', fe 
			outreg2 using "${output}ICE_resultados_ps_ef_`uf'.xls", ///
				excel append label ctitle(`outcomes', controle pub) 
		}
	}

