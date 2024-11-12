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

log using "$Logfolder/ef_diff_in_diff_cum_v1.log", replace

use "$folderservidor\dados_EF_14_v2.dta", clear

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

	
by codigo_escola, sort: gen nvals = _n == 1 
count if nvals==1 & ice==1
*temos 212 escolas do ensino fundamental que entraram no ice
* 212
* xtset codigo_escola ano
xtset codigo_escola ano_prova_brasil


gen tempo=.
* como a prova brasil é aplicada somente em anos impares
* mas o programa é implementado em anos pares e impares,

* criaremos uma variável nova que recebe o ano anterior 
* ao ano da implementação do programa, se o ano de implementação
* for um ano par, que não houve prova brasil

* e que recebe o ano de implementação do programa, se esse ano for 
* impar
gen ano_ice_impar =.

replace ano_ice_impar = ano_ice if mod(ano_ice,2)==1
replace ano_ice_impar = ano_ice - 1 if mod(ano_ice,2)==0
order ano_ice_impar, after(ano_ice)

replace tempo=0 if ano==ano_ice_impar-6
replace tempo=1 if ano==ano_ice_impar-4
replace tempo=2 if ano==ano_ice_impar-2
replace tempo=3 if ano==ano_ice_impar
replace tempo=4 if ano==ano_ice_impar+2
replace tempo=5 if ano==ano_ice_impar+4
replace tempo=6 if ano==ano_ice_impar+6

tab tempo, gen(d_tempo)




replace  d_tempo1 = 0 if  d_tempo1==.
replace  d_tempo2 = 0 if  d_tempo2==.
replace  d_tempo3 = 0 if  d_tempo3==.
replace  d_tempo4 = 0 if  d_tempo4==.
replace  d_tempo5 = 0 if  d_tempo5==.
replace  d_tempo6 = 0 if  d_tempo6==.
replace  d_tempo7 = 0 if  d_tempo7==.



gen d_ice_pre3=ice*d_tempo1
gen d_ice_pre2=ice*d_tempo2
gen d_ice_pre1=ice*d_tempo3
gen d_ice_inicio=ice*d_tempo4
gen d_ice_pos1=ice*d_tempo5
gen d_ice_pos2=ice*d_tempo6
gen d_ice_pos3=ice*d_tempo7


replace d_ice_pre3=0 if ice==0
replace d_ice_pre2=0 if ice==0
replace d_ice_pre1=0 if ice==0
replace d_ice_inicio=0 if ice==0
replace d_ice_pos1=0 if ice==0
replace d_ice_pos2=0 if ice==0
replace d_ice_pos3=0 if ice==0

global todos_anos d_ice_pre3 d_ice_pre2 d_ice_pre1 d_ice_inicio  ///
	d_ice_pos1 d_ice_pos2 d_ice_pos3

	
gen uf_ano = .
forvalues y = 2007(2)2015{
	foreach x in "23" "26" "32" "33" "35" "52"{
		replace uf_ano = `x'.`y' if ano_prova_brasil == `y' & codigo_uf == `x'
	
	}
}
egen double_cluster=group(codigo_uf ano_prova_brasil)	
*notas
*media_lp_prova_brasil_9_std

	xtreg media_lp_prova_brasil_9_std  $todos_anos ///
		d_ano* $controles $estado ///
		if (d_dep4==0|ice==1), fe 
	outreg2 using "$output/ef_diff_in_diff_cum_v1.xls", excel replace label ///
		 ctitle(pb port,  fe)
		 
	xtreg media_lp_prova_brasil_9_std  $todos_anos ///
		d_ano* $controles $estado ///
		if (d_dep4==0|ice==1), fe cluster(codigo_uf)
	outreg2 using "$output/ef_diff_in_diff_cum_v1.xls", excel replace label ///
		 ctitle(pb port,  cluster estado)
	
	xtreg media_lp_prova_brasil_9_std  $todos_anos ///
		d_ano* $controles $estado ///
		if (d_dep4==0|ice==1), fe cluster(cod_meso)
	outreg2 using "$output/ef_diff_in_diff_cum_v1.xls", excel append label ///
		 ctitle(pb port,  cluster meso)

	xtreg media_lp_prova_brasil_9_std  $todos_anos ///
		d_ano* $controles $estado ///
		if (d_dep4==0|ice==1),  fe vce(cluster double_cluster) nonest
	outreg2 using "$output/ef_diff_in_diff_cum_v1.xls", excel append label ///
		 ctitle(pb port,  cluster ano estado)
		 
foreach x in  "media_mt_prova_brasil_9_std" "media_pb_9_std" "apr_ef_std" "rep_ef_std" "aba_ef_std" "dist_ef_std"  {	 
	xtreg `x' $todos_anos d_ano* $controles $estado ///
		if (d_dep4==0|ice==1), fe
	outreg2 using "$output/ef_diff_in_diff_cum_v1.xls", ///
		excel append label ///
		ctitle(`x',  fe)
		
	xtreg `x' $todos_anos d_ano* $controles $estado ///
		if (d_dep4==0|ice==1), fe cluster(codigo_uf)
	outreg2 using "$output/ef_diff_in_diff_cum_v1.xls", ///
		excel append label ///
		ctitle(`x',  cluster estado)
		
	xtreg `x' $todos_anos d_ano* $controles $estado ///
		if (d_dep4==0|ice==1), fe cluster(cod_meso)
	outreg2 using "$output/ef_diff_in_diff_cum_v1.xls", ///
		excel append label ///
		ctitle(`x',  cluster meso)
	xtreg `x' $todos_anos d_ano* $controles $estado ///
		if (d_dep4==0|ice==1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/ef_diff_in_diff_cum_v1.xls", ///
		excel append label ///
		ctitle(`x',  cluster ano estado)
}
