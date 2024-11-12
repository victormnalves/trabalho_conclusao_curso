
/*
Teste Placebo na base de Ensino Fundamental

*/



/*
em escolas com o ensino fundamental e o ensino integral, a implementação 
do programa em somente uma das modalidades não deferia ter impacto na 
nota da outra modalidade
*/

/*
dessa forma, vamos estimar o impacto 


*/
sysdir set PLUS \\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\ado
*sysdir set PLUS \\fs-eesp-01\EESP\Usuarios\bruna.mirelle\makoto\ado
clear all
set more off, permanently

capture log close

global folderservidor "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"
global user "`:environment USERPROFILE'"
global Folder "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"
global output "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\resultados_v3"
global Bases "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"
global dofiles "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\Do-Files"
global Logfolder "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\logfiles"

log using "$Logfolder/ef_placebo.log", replace

use "$folderservidor\dados_EF_14_pb_only.dta", clear

global estado d_uf*
global outcomes apr_ef_std rep_ef_std aba_ef_std dist_ef_std ///
	media_lp_prova_brasil_9_std media_mt_prova_brasil_9_std ///
	media_pb_9_std
	

global controles pb_esc_sup_mae_9 pb_esc_sup_pai_9 ///
	rural  	///
	predio diretoria sala_professores biblioteca internet lixo_coleta ///
	eletricidade agua esgoto lab_info lab_ciencias quadra_esportes ///
 	n_salas_utilizadas ///
	pib_capita_reais_real_2015 pop mais_educ ///
	n_turmas_ef n_alunos_ef n_mulheres_ef n_brancos_ef
	
global estado d_uf*

by codigo_escola, sort: gen nvals = _n == 1 
count if nvals==1 & ice==1
*temos 212 escolas do ensino fundamental que entraram no ice
* 212
* xtset codigo_escola ano
xtset  codigo_escola ano_prova_brasil

gen uf_ano = .
forvalues y = 2007(2)2015{
	foreach x in "23" "26" "32" "33" "35" "52"{
		replace uf_ano = `x'.`y' if ano_prova_brasil == `y' & codigo_uf == `x'
	
	}
}
egen double_cluster=group(codigo_uf ano_prova_brasil)

gen somente_fundamental = 0
replace somente_fundamental = 1 if ensino_fundamental == 1 & ensino_medio == 0
gen somente_ensino_medio = 0
replace somente_ensino_medio = 1  if ensino_medio ==1 & ensino_fundamental ==0
replace ice = 1 if ano_ice!=.
gen ensino_medio_e_fund=0
replace ensino_medio_e_fund=1 if ensino_medio==1 & ensino_fundamental==1






	forvalues a=2004(1)2015{

	replace ice_`a' = 1 if ano_ice==ano
	
	}
forvalues x=2004(1)2015{
		replace d_ice=1 if ice_`x'==1 &ano==`x' 
		
}

replace ice = 0 if somente_ensino_medio ==0
replace ice = 1 if somente_ensino_medio ==1
replace d_ice = 0 if ice ==0


*notas
*media_lp_prova_brasil_9_std
	xtreg media_lp_prova_brasil_9_std d_ice  d_ano* $controles $estado ///
		if (d_dep4==0|ice==1), fe
	outreg2 using "$output/ef_diff_in_diff_placebo_v1.xls", excel replace label ///
		ctitle(pb port,  fe)
	xtreg media_lp_prova_brasil_9_std d_ice  d_ano* $controles $estado ///
		if (d_dep4==0|ice==1), fe cluster(codigo_uf)
	outreg2 using "$output/ef_diff_in_diff_placebo_v1.xls", excel append label ///
		 ctitle(pb port,  cluster estado)
		 
	xtreg media_lp_prova_brasil_9_std d_ice  d_ano* $controles $estado ///
		if (d_dep4==0|ice==1), fe cluster(cod_meso)
	outreg2 using "$output/ef_diff_in_diff_placebo_v1.xls", excel append label ///
		 ctitle(pb port,  cluster meso)
	xtreg media_lp_prova_brasil_9_std d_ice  d_ano* $controles $estado ///
		if (d_dep4==0|ice==1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/ef_diff_in_diff_placebo_v1.xls", excel append label ///
		 ctitle(pb port,  cluster ano estado)		

*fluxo 
	
foreach x in "media_mt_prova_brasil_9_std" "media_pb_9_std" "apr_ef_std" "rep_ef_std" "aba_ef_std" "dist_ef_std"  {	 
	xtreg `x' d_ice d_ano* $controles $estado ///
		if (d_dep4==0|ice==1), fe 
	outreg2 using "$output/ef_diff_in_diff_placebo_v1.xls", ///
		excel append label ///
		ctitle(`x',  fe)
	xtreg `x' d_ice d_ano* $controles $estado ///
		if (d_dep4==0|ice==1), fe cluster(codigo_uf)
	outreg2 using "$output/ef_diff_in_diff_placebo_v1.xls", ///
		excel append label ///
		ctitle(`x',  cluster estado)
	xtreg `x' d_ice d_ano* $controles $estado ///
		if (d_dep4==0|ice==1), fe cluster(cod_meso)
	outreg2 using "$output/ef_diff_in_diff_placebo_v1.xls", ///
		excel append label ///
		ctitle(`x',  cluster meso)
	xtreg `x' d_ice d_ano* $controles $estado ///
		if (d_dep4==0|ice==1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/ef_diff_in_diff_placebo_v1.xls", ///
		excel append label ///
		ctitle(`x',  cluster ano estado)
}

