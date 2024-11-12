/*

em mahalobis output only

usando somente as variáveis defasadas
*/

sysdir set PLUS \\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\ado

capture log close
clear all
set more off, permanently
/*
********************************************************************************
********************************************************************************
********************************************************************************
mahalanobis matching 


********************************************************************************
********************************************************************************
********************************************************************************
*/

global folderservidor "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"
log using "$folderservidor\logfiles/em_maha_output_3_v3.log", replace

*pareando em outcomes passados

*/

********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
/*
(A) PAREANDO EM OUTCOMES PASSADOS

*/
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************

/*
********************************************************************************
notas
********************************************************************************
*/
/*
use "$folderservidor\dados_EM_14_v4.dta", clear

keep if (d_ice_nota_lag ==0 | d_ice_nota_lag ==.) & d_ice_nota ==1
376

use "$folderservidor\dados_EM_14_v4.dta", clear

keep if d_ice_nota_lag_2==0 & d_ice_nota_lag ==0 & d_ice_nota ==1
391
*/

use "$folderservidor\dados_EM_14_v3.dta", clear
	xtset codigo_escola ano
	* declarando dados como painel
	* ano é t e codigo_escola é i
	
	keep if ice==0 | (d_ice_nota_lag_2==0 & d_ice_nota_lag ==0 & d_ice_nota ==1)
	*391 escolas tratadas sobraram
	gen enem_nota_objetivab_std_trend_2 = enem_nota_objetivab_std_lag_2 - enem_nota_objetivab_std_lag
	gen enem_nota_objetivab_std_trend_1 = enem_nota_objetivab_std_lag - enem_nota_objetivab_std

	gen enem_nota_redacao_std_trend_2 = enem_nota_redacao_std_lag_2 - enem_nota_redacao_std_lag
	gen enem_nota_redacao_std_trend_1 = enem_nota_redacao_std_lag - enem_nota_redacao_std

	gen double cod_match_notas =. 
	
	mahapick enem_nota_objetivab_std_trend_2 - enem_nota_redacao_std_trend_1 ///
		, ///
		idvar(codigo_escola) treated(escola_ice_em) ///
		pickids(cod_match_notas) clear ///
		genfile($folderservidor\matches_notas_3.dta) replace  ///
		nummatches(3) matchon(ano) sliceby(ano) score


use "$folderservidor\matches_notas_3.dta", clear
keep codigo_escola
sort codigo_escola
quietly by codigo_escola:  gen dup = cond(_N==1,0,_n)
sort codigo_escola dup
drop if dup >=2
drop dup

merge 1:m codigo_escola using "$folderservidor\dados_EM_14_v3.dta"



keep if _m == 3


save "$folderservidor\dados_EM_par_nota_v5.dta", replace
/*
********************************************************************************
fluxo
********************************************************************************
*/


use "$folderservidor\dados_EM_14_v3.dta", clear
	xtset codigo_escola ano
	* declarando dados como painel
	* ano é t e codigo_escola é i
	
	keep if ice==0 | (d_ice_fluxo_lag_2==0 & d_ice_fluxo_lag ==0 & d_ice_fluxo ==1)
	*391 escolas tratadas sobraram
	gen apr_em_std_trend_2 = apr_em_std_lag_2 - apr_em_std_lag
	gen rep_em_std_trend_2 = rep_em_std_lag_2 - rep_em_std_lag
	gen aba_em_std_trend_2 = aba_em_std_lag_2 - aba_em_std_lag
	gen dist_em_std_trend_2 = dist_em_std_lag_2 - dist_em_std_lag	
	
	gen apr_em_std_trend_1 = apr_em_std_lag - apr_em_std
	gen rep_em_std_trend_1 = rep_em_std_lag - rep_em_std
	gen aba_em_std_trend_1 = aba_em_std_lag - aba_em_std
	gen dist_em_std_trend_1 = dist_em_std_lag - dist_em_std
	
	gen double cod_match_fluxo =. 
	
	mahapick  apr_em_std_trend_2 - dist_em_std_trend_1 ///
		, ///
		idvar(codigo_escola) treated(escola_ice_em) ///
		pickids(cod_match_fluxo) clear ///
		genfile($folderservidor\matches_fluxo_3.dta) replace  ///
		nummatches(3) matchon(ano) sliceby(ano)  score


use "$folderservidor\matches_fluxo_3.dta", clear
keep codigo_escola
sort codigo_escola
quietly by codigo_escola:  gen dup = cond(_N==1,0,_n)
sort codigo_escola dup
drop if dup >=2
drop dup

merge 1:m codigo_escola using "$folderservidor\dados_EM_14_v3.dta"



keep if _m == 3


save "$folderservidor\dados_EM_par_fluxo_v5.dta", replace


/**
notas individualmente
**/
foreach x in "objetivab" "redacao"{


use "$folderservidor\dados_EM_14_v3.dta", clear
	xtset codigo_escola ano
	* declarando dados como painel
	* ano é t e codigo_escola é i
	
	keep if ice==0 | (d_ice_nota_lag_2==0 & d_ice_nota_lag ==0 & d_ice_nota ==1)
	*391 escolas tratadas sobraram
	
	gen enem_nota_`x'_std_trend_2 = enem_nota_`x'_std_lag_2 - enem_nota_`x'_std_lag
	gen enem_nota_`x'_std_trend_1 = enem_nota_`x'_std_lag - enem_nota_`x'_std


	gen double cod_match_notas_`x' =. 
	
	mahapick enem_nota_`x'_std_trend_2 enem_nota_`x'_std_trend_1 ///
		, ///
		idvar(codigo_escola) treated(escola_ice_em) ///
		pickids(cod_match_notas_`x') clear ///
		genfile($folderservidor\matches_notas_`x'_3.dta) replace  ///
		nummatches(3) matchon(ano) sliceby(ano)  score


use "$folderservidor\matches_notas_`x'_3.dta", clear
keep codigo_escola
sort codigo_escola
quietly by codigo_escola:  gen dup = cond(_N==1,0,_n)
sort codigo_escola dup
drop if dup >=2
drop dup

merge 1:m codigo_escola using "$folderservidor\dados_EM_14_v3.dta"



keep if _m == 3


save "$folderservidor\dados_EM_par_nota_`x'_v5.dta", replace
}



/**
fluxo individualmente
**/
foreach x in "apr" "rep" "aba" "dist"{


use "$folderservidor\dados_EM_14_v3.dta", clear
	xtset codigo_escola ano
	* declarando dados como painel
	* ano é t e codigo_escola é i
	
	keep if ice==0 | (d_ice_fluxo_lag_2==0 & d_ice_fluxo_lag ==0 & d_ice_fluxo ==1)
	*391 escolas tratadas sobraram
	
	
	gen double cod_match_fluxo_`x' =. 
	gen `x'_em_std_trend_2= `x'_em_std_lag_2 - `x'_em_std_lag
	gen `x'_em_std_trend_1 = `x'_em_std_lag - `x'_em_std
	mahapick `x'_em_std_trend_2 `x'_em_std_trend_1, ///
		idvar(codigo_escola) treated(escola_ice_em) ///
		pickids(cod_match_fluxo_`x') clear ///
		genfile($folderservidor\matches_fluxo_`x'_3.dta) replace  ///
		nummatches(3) matchon(ano) sliceby(ano)    score


use "$folderservidor\matches_fluxo_`x'_3.dta", clear
keep codigo_escola
sort codigo_escola
quietly by codigo_escola:  gen dup = cond(_N==1,0,_n)
sort codigo_escola dup
drop if dup >=2
drop dup

merge 1:m codigo_escola using "$folderservidor\dados_EM_14_v3.dta"



keep if _m == 3


save "$folderservidor\dados_EM_par_fluxo_`x'_v5.dta", replace
}
