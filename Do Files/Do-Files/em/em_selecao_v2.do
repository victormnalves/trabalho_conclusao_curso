*******************************************************************************
/*						ENSINO MÉDIO EFEITO SELEÇÃO							*/	
*******************************************************************************
/*
aqui vamos ver qual é o impacto da nota no enem na composição 

*/
sysdir set PLUS \\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\ado

capture log close
clear all
set more off, permanently

global user "`:environment USERPROFILE'"
global Folder "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"
global output "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\resultados_v3"
global Bases "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"
global dofiles "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\Do-Files"
global Logfolder "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\logfiles"



global folderservidor "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"

log using "$Logfolder/em_spillover.log", replace
use "$folderservidor\dados_EM_14_enem_only.dta", clear

global controles_selecao rural  	///
	predio diretoria sala_professores biblioteca internet lixo_coleta ///
	eletricidade agua esgoto lab_info lab_ciencias quadra_esportes  	///
	n_alunos_em_ep n_mulheres_em_ep pib_capita_reais_real_2015 pop mais_educ 
	
	
global controles_enem concluir_em_ano_enem e_mora_mais_de_6_pessoas ///
	e_escol_sup_pai	///
	e_escol_sup_mae e_renda_familia_5_salarios e_trabalhou_ou_procurou

global c_concluir_em_ano_enem ///
	e_mora_mais_de_6_pessoas ///
	e_escol_sup_pai	///
	e_escol_sup_mae ///
	e_renda_familia_5_salarios ///
	e_trabalhou_ou_procurou
global c_e_mora_mais_de_6_pessoas ///
	concluir_em_ano_enem ///
	e_escol_sup_pai	///
	e_escol_sup_mae ///
	e_renda_familia_5_salarios ///
	e_trabalhou_ou_procurou
global 	c_e_escol_sup_pai ///
	concluir_em_ano_enem ///
	e_mora_mais_de_6_pessoas ///
	e_escol_sup_mae 	///
	e_renda_familia_5_salarios ///
	e_trabalhou_ou_procurou
	
global c_e_escol_sup_mae ///
	concluir_em_ano_enem ///
	e_mora_mais_de_6_pessoas ///
	e_escol_sup_pai	///
	e_renda_familia_5_salarios ///
	e_trabalhou_ou_procurou

global c_e_renda_familia_5_salarios ///
	concluir_em_ano_enem ///
	e_mora_mais_de_6_pessoas ///
	e_escol_sup_mae 	///
	e_escol_sup_pai	///
	e_trabalhou_ou_procurou	
	
global c_e_trabalhou_ou_procurou ///
	concluir_em_ano_enem ///
	e_mora_mais_de_6_pessoas ///
	e_escol_sup_mae 	///
	e_escol_sup_pai	///
	e_renda_familia_5_salarios
egen double_cluster=group(codigo_uf ano)
gen uf_ano = .

*gerando variável dummy fake
set seed 339487731
gen uniform = runiform()
gen fake = .
replace fake = 0 if uniform<0.5
replace fake = 1 if uniform>=0.5
summ fake


forvalues y = 2003(1)2015{
	foreach x in "23" "26" "32" "33" "35" "52"{
		replace uf_ano = `x'.`y' if ano == `y' & codigo_uf == `x'
	
	}
}
/****************************************************************************/
/*concluir_em_ano_enem*/
/****************************************************************************/

	xtreg concluir_em_ano_enem  d_ice_fluxo d_ano* $controles_selecao  ///
	$c_concluir_em_ano_enem $estado ///
	if (d_dep4 == 0 | ice == 1), fe 
	outreg2 using "$output/em_diff_in_diff_selecao_v1.xls", excel replace label ctitle(concluir_em_ano_enem,  fe)
	
	*cluster codigo_uf
	xtreg concluir_em_ano_enem d_ice_fluxo d_ano* $controles_selecao ///
	$c_concluir_em_ano_enem $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(codigo_uf)
	outreg2 using "$output/em_diff_in_diff_selecao_v1.xls", excel append label ctitle(concluir_em_ano_enem,  cluster estado)

	*cluster cod_meso
	xtreg concluir_em_ano_enem d_ice_fluxo d_ano* $controles_selecao ///
	$c_concluir_em_ano_enem $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(cod_meso)	
	outreg2 using "$output/em_diff_in_diff_selecao_v1.xls", excel append label ctitle(concluir_em_ano_enem,  cluster meso)

	*cluster uf ano
	xtreg concluir_em_ano_enem d_ice_fluxo d_ano* $controles_selecao ///
	$c_concluir_em_ano_enem $estado ///
	if (d_dep4 == 0 | ice == 1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/em_diff_in_diff_selecao_v1.xls", excel append label ctitle(concluir_em_ano_enem,  cluster uf ano)

	xtreg concluir_em_ano_enem fake d_ano* $controles_selecao ///
	$c_concluir_em_ano_enem $estado ///
	if (d_dep4 == 0 | ice == 1), fe 
	outreg2 using "$output/em_diff_in_diff_selecao_fake_v1.xls", excel replace label ctitle(concluir_em_ano_enem fake,  fe)
	
	*cluster codigo_uf
	xtreg concluir_em_ano_enem fake d_ano*  $controles_selecao ///
	$c_concluir_em_ano_enem $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(codigo_uf)
	outreg2 using "$output/em_diff_in_diff_selecao_fake_v1.xls", excel append label ctitle(concluir_em_ano_enem fake,  cluster estado)

	*cluster cod_meso
	xtreg concluir_em_ano_enem fake d_ano*  $controles_selecao ///
	$c_concluir_em_ano_enem $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(cod_meso)	
	outreg2 using "$output/em_diff_in_diff_selecao_fake_v1.xls", excel append label ctitle(concluir_em_ano_enem fake,  cluster meso)

	*cluster uf ano
	xtreg concluir_em_ano_enem fake d_ano* $controles_selecao ///
	$c_concluir_em_ano_enem $estado ///
	if (d_dep4 == 0 | ice == 1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/em_diff_in_diff_selecao_fake_v1.xls", excel append label ctitle(concluir_em_ano_enem fake,  cluster uf ano)

	
	
/****************************************************************************/
/*e_mora_mais_de_6_pessoas*/
/****************************************************************************/

	xtreg e_mora_mais_de_6_pessoas  d_ice_fluxo d_ano* $controles_selecao ///
	$c_e_mora_mais_de_6_pessoas $estado ///
	if (d_dep4 == 0 | ice == 1), fe 
	outreg2 using "$output/em_diff_in_diff_selecao_v1.xls", excel append label ctitle(e_mora_mais_de_6_pessoas,  fe)
	
	*cluster codigo_uf
	xtreg e_mora_mais_de_6_pessoas d_ice_fluxo d_ano*  $controles_selecao ///
	$c_e_mora_mais_de_6_pessoas $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(codigo_uf)
	outreg2 using "$output/em_diff_in_diff_selecao_v1.xls", excel append label ctitle(e_mora_mais_de_6_pessoas,  cluster estado)

	*cluster cod_meso
	xtreg e_mora_mais_de_6_pessoas d_ice_fluxo d_ano* $controles_selecao ///
	 $c_e_mora_mais_de_6_pessoas $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(cod_meso)	
	outreg2 using "$output/em_diff_in_diff_selecao_v1.xls", excel append label ctitle(e_mora_mais_de_6_pessoas,  cluster meso)

	*cluster uf ano
	xtreg e_mora_mais_de_6_pessoas d_ice_fluxo d_ano* $controles_selecao ///
	$c_e_mora_mais_de_6_pessoas $estado ///
	if (d_dep4 == 0 | ice == 1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/em_diff_in_diff_selecao_v1.xls", excel append label ctitle(e_mora_mais_de_6_pessoas,  cluster uf ano)

	xtreg e_mora_mais_de_6_pessoas fake d_ano* $controles_selecao ///
	$c_e_mora_mais_de_6_pessoas $estado ///
	if (d_dep4 == 0 | ice == 1), fe 
	outreg2 using "$output/em_diff_in_diff_selecao_fake_v1.xls", excel append label ctitle(e_mora_mais_de_6_pessoas fake,  fe)
	
	*cluster codigo_uf
	xtreg e_mora_mais_de_6_pessoas fake d_ano*  $controles_selecao ///
	$c_e_mora_mais_de_6_pessoas $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(codigo_uf)
	outreg2 using "$output/em_diff_in_diff_selecao_fake_v1.xls", excel append label ctitle(e_mora_mais_de_6_pessoas fake,  cluster estado)

	*cluster cod_meso
	xtreg e_mora_mais_de_6_pessoas fake d_ano*  $controles_selecao ///
	$c_e_mora_mais_de_6_pessoas $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(cod_meso)	
	outreg2 using "$output/em_diff_in_diff_selecao_fake_v1.xls", excel append label ctitle(e_mora_mais_de_6_pessoas fake,  cluster meso)

	*cluster uf ano
	xtreg e_mora_mais_de_6_pessoas fake d_ano* $controles_selecao ///
	$c_e_mora_mais_de_6_pessoas $estado ///
	if (d_dep4 == 0 | ice == 1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/em_diff_in_diff_selecao_fake_v1.xls", excel append label ctitle(e_mora_mais_de_6_pessoas fake,  cluster uf ano)

	
	

	
/****************************************************************************/
/*e_escol_sup_pai*/
/****************************************************************************/

	xtreg e_escol_sup_pai  d_ice_fluxo d_ano* $controles_selecao ///
	$c_e_escol_sup_pai $estado ///
	if (d_dep4 == 0 | ice == 1), fe 
	outreg2 using "$output/em_diff_in_diff_selecao_v1.xls", excel append label ctitle(e_escol_sup_pai,  fe)
	
	*cluster codigo_uf
	xtreg e_escol_sup_pai d_ice_fluxo d_ano*  $controles_selecao ///
	$c_e_escol_sup_pai $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(codigo_uf)
	outreg2 using "$output/em_diff_in_diff_selecao_v1.xls", excel append label ctitle(e_escol_sup_pai,  cluster estado)

	*cluster cod_meso
	xtreg e_escol_sup_pai d_ice_fluxo d_ano*  $controles_selecao ///
	$c_e_escol_sup_pai $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(cod_meso)	
	outreg2 using "$output/em_diff_in_diff_selecao_v1.xls", excel append label ctitle(e_escol_sup_pai,  cluster meso)

	*cluster uf ano
	xtreg e_escol_sup_pai d_ice_fluxo d_ano* $controles_selecao ///
	$c_e_escol_sup_pai $estado ///
	if (d_dep4 == 0 | ice == 1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/em_diff_in_diff_selecao_v1.xls", excel append label ctitle(e_escol_sup_pai,  cluster uf ano)

	xtreg e_escol_sup_pai fake d_ano* $controles_selecao ///
	$c_e_escol_sup_pai $estado ///
	if (d_dep4 == 0 | ice == 1), fe 
	outreg2 using "$output/em_diff_in_diff_selecao_fake_v1.xls", excel append label ctitle(e_escol_sup_pai fake,  fe)
	
	*cluster codigo_uf
	xtreg e_escol_sup_pai fake d_ano*  $controles_selecao ///
	$c_e_escol_sup_pai $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(codigo_uf)
	outreg2 using "$output/em_diff_in_diff_selecao_fake_v1.xls", excel append label ctitle(e_escol_sup_pai fake,  cluster estado)

	*cluster cod_meso
	xtreg e_escol_sup_pai fake d_ano* $controles_selecao ///
	 $c_e_escol_sup_pai $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(cod_meso)	
	outreg2 using "$output/em_diff_in_diff_selecao_fake_v1.xls", excel append label ctitle(e_escol_sup_pai fake,  cluster meso)

	*cluster uf ano
	xtreg e_escol_sup_pai fake d_ano* $controles_selecao ///
	 $c_e_escol_sup_pai $estado ///
	if (d_dep4 == 0 | ice == 1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/em_diff_in_diff_selecao_fake_v1.xls", excel append label ctitle(e_escol_sup_pai fake,  cluster uf ano)
	


	
/****************************************************************************/
/*e_escol_sup_mae*/
/****************************************************************************/

	xtreg e_escol_sup_mae  d_ice_fluxo d_ano* $controles_selecao ///
	$c_e_escol_sup_mae $estado ///
	if (d_dep4 == 0 | ice == 1), fe 
	outreg2 using "$output/em_diff_in_diff_selecao_v1.xls", excel append label ctitle(e_escol_sup_mae,  fe)
	
	*cluster codigo_uf
	xtreg e_escol_sup_mae d_ice_fluxo d_ano*  $controles_selecao ///
	$c_e_escol_sup_mae $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(codigo_uf)
	outreg2 using "$output/em_diff_in_diff_selecao_v1.xls", excel append label ctitle(e_escol_sup_mae,  cluster estado)

	*cluster cod_meso
	xtreg e_escol_sup_mae d_ice_fluxo d_ano*  $controles_selecao ///
	$c_e_escol_sup_mae $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(cod_meso)	
	outreg2 using "$output/em_diff_in_diff_selecao_v1.xls", excel append label ctitle(e_escol_sup_mae,  cluster meso)

	*cluster uf ano
	xtreg e_escol_sup_mae d_ice_fluxo d_ano* $controles_selecao ///
	$c_e_escol_sup_mae $estado ///
	if (d_dep4 == 0 | ice == 1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/em_diff_in_diff_selecao_v1.xls", excel append label ctitle(e_escol_sup_mae,  cluster uf ano)

	xtreg e_escol_sup_mae fake d_ano* $controles_selecao ///
	$c_e_escol_sup_mae $estado ///
	if (d_dep4 == 0 | ice == 1), fe 
	outreg2 using "$output/em_diff_in_diff_selecao_fake_v1.xls", excel append label ctitle(e_escol_sup_mae fake,  fe)
	
	*cluster codigo_uf
	xtreg e_escol_sup_mae fake d_ano*  $controles_selecao ///
	$c_e_escol_sup_mae $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(codigo_uf)
	outreg2 using "$output/em_diff_in_diff_selecao_fake_v1.xls", excel append label ctitle(e_escol_sup_mae fake,  cluster estado)

	*cluster cod_meso
	xtreg e_escol_sup_mae fake d_ano*  $controles_selecao ///
	$c_e_escol_sup_mae $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(cod_meso)	
	outreg2 using "$output/em_diff_in_diff_selecao_fake_v1.xls", excel append label ctitle(e_escol_sup_mae fake,  cluster meso)

	*cluster uf ano
	xtreg e_escol_sup_mae fake d_ano* $controles_selecao ///
	$c_e_escol_sup_mae $estado ///
	if (d_dep4 == 0 | ice == 1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/em_diff_in_diff_selecao_fake_v1.xls", excel append label ctitle(e_escol_sup_mae fake,  cluster uf ano)
		

	
/****************************************************************************/
/*e_renda_familia_5_salarios*/
/****************************************************************************/

	xtreg e_renda_familia_5_salarios  d_ice_fluxo d_ano* $controles_selecao ///
	$c_e_renda_familia_5_salarios $estado ///
	if (d_dep4 == 0 | ice == 1), fe 
	outreg2 using "$output/em_diff_in_diff_selecao_v1.xls", excel append label ctitle(e_renda_familia_5_salarios,  fe)
	
	*cluster codigo_uf
	xtreg e_renda_familia_5_salarios d_ice_fluxo d_ano*  $controles_selecao ///
	$c_e_renda_familia_5_salarios $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(codigo_uf)
	outreg2 using "$output/em_diff_in_diff_selecao_v1.xls", excel append label ctitle(e_renda_familia_5_salarios,  cluster estado)

	*cluster cod_meso
	xtreg e_renda_familia_5_salarios d_ice_fluxo d_ano*  $controles_selecao ///
	$c_e_renda_familia_5_salarios $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(cod_meso)	
	outreg2 using "$output/em_diff_in_diff_selecao_v1.xls", excel append label ctitle(e_renda_familia_5_salarios,  cluster meso)

	*cluster uf ano
	xtreg e_renda_familia_5_salarios d_ice_fluxo d_ano* $controles_selecao ///
	$c_e_renda_familia_5_salarios $estado ///
	if (d_dep4 == 0 | ice == 1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/em_diff_in_diff_selecao_v1.xls", excel append label ctitle(e_renda_familia_5_salarios,  cluster uf ano)

	xtreg e_renda_familia_5_salarios fake d_ano* $controles_selecao ///
	$c_e_renda_familia_5_salarios $estado ///
	if (d_dep4 == 0 | ice == 1), fe 
	outreg2 using "$output/em_diff_in_diff_selecao_fake_v1.xls", excel append label ctitle(e_renda_familia_5_salarios fake,  fe)
	
	*cluster codigo_uf
	xtreg e_renda_familia_5_salarios fake d_ano*  $controles_selecao ///
	$c_e_renda_familia_5_salarios $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(codigo_uf)
	outreg2 using "$output/em_diff_in_diff_selecao_fake_v1.xls", excel append label ctitle(e_renda_familia_5_salarios fake,  cluster estado)

	*cluster cod_meso
	xtreg e_renda_familia_5_salarios fake d_ano*  $controles_selecao ///
	$c_e_renda_familia_5_salarios $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(cod_meso)	
	outreg2 using "$output/em_diff_in_diff_selecao_fake_v1.xls", excel append label ctitle(e_renda_familia_5_salarios fake,  cluster meso)

	*cluster uf ano
	xtreg e_renda_familia_5_salarios fake d_ano* $controles_selecao ///
	$c_e_renda_familia_5_salarios $estado ///
	if (d_dep4 == 0 | ice == 1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/em_diff_in_diff_selecao_fake_v1.xls", excel append label ctitle(e_renda_familia_5_salarios fake,  cluster uf ano)

	
	
/****************************************************************************/
/*e_trabalhou_ou_procurou*/
/****************************************************************************/

	xtreg e_trabalhou_ou_procurou  d_ice_fluxo d_ano* $controles_selecao ///
	$c_e_trabalhou_ou_procurou $estado ///
	if (d_dep4 == 0 | ice == 1), fe 
	outreg2 using "$output/em_diff_in_diff_selecao_v1.xls", excel append label ctitle(e_trabalhou_ou_procurou,  fe)
	
	*cluster codigo_uf
	xtreg e_trabalhou_ou_procurou d_ice_fluxo d_ano*  $controles_selecao ///
	$c_e_trabalhou_ou_procurou $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(codigo_uf)
	outreg2 using "$output/em_diff_in_diff_selecao_v1.xls", excel append label ctitle(e_trabalhou_ou_procurou,  cluster estado)

	*cluster cod_meso
	xtreg e_trabalhou_ou_procurou d_ice_fluxo d_ano*  $controles_selecao ///
	$c_e_trabalhou_ou_procurou $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(cod_meso)	
	outreg2 using "$output/em_diff_in_diff_selecao_v1.xls", excel append label ctitle(e_trabalhou_ou_procurou,  cluster meso)

	*cluster uf ano
	xtreg e_trabalhou_ou_procurou d_ice_fluxo d_ano* $controles_selecao ///
	$c_e_trabalhou_ou_procurou $estado ///
	if (d_dep4 == 0 | ice == 1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/em_diff_in_diff_selecao_v1.xls", excel append label ctitle(e_trabalhou_ou_procurou,  cluster uf ano)

	xtreg e_trabalhou_ou_procurou fake d_ano* $controles_selecao ///
	$c_e_trabalhou_ou_procurou $estado ///
	if (d_dep4 == 0 | ice == 1), fe 
	outreg2 using "$output/em_diff_in_diff_selecao_fake_v1.xls", excel append label ctitle(e_trabalhou_ou_procurou fake,  fe)
	
	*cluster codigo_uf
	xtreg e_trabalhou_ou_procurou fake d_ano*  $controles_selecao ///
	$c_e_trabalhou_ou_procurou $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(codigo_uf)
	outreg2 using "$output/em_diff_in_diff_selecao_fake_v1.xls", excel append label ctitle(e_trabalhou_ou_procurou fake,  cluster estado)

	*cluster cod_meso
	xtreg e_trabalhou_ou_procurou fake d_ano*  $controles_selecao ///
	$c_e_trabalhou_ou_procurou $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(cod_meso)	
	outreg2 using "$output/em_diff_in_diff_selecao_fake_v1.xls", excel append label ctitle(e_trabalhou_ou_procurou fake,  cluster meso)

	*cluster uf ano
	xtreg e_trabalhou_ou_procurou fake d_ano* $controles_selecao ///
	$c_e_trabalhou_ou_procurou $estado ///
	if (d_dep4 == 0 | ice == 1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/em_diff_in_diff_selecao_fake_v1.xls", excel append label ctitle(e_trabalhou_ou_procurou fake,  cluster uf ano)
			
	/*
foreach x in "e_mora_mais_de_6_pessoas"  "e_escol_sup_pai" "e_escol_sup_mae" "e_renda_familia_5_salarios" "e_trabalhou_ou_procurou"{
	xtreg `x' d_ice_fluxo d_ano* $controles_selecao  $estado ///
	if (d_dep4 == 0 | ice == 1), fe 
	outreg2 using "$output/em_diff_in_diff_selecao_v1.xls", excel append label ctitle(`x',  fe)
	
	*cluster codigo_uf
	xtreg `x' d_ice_fluxo d_ano*  $controles_selecao  $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(codigo_uf)
	outreg2 using "$output/em_diff_in_diff_selecao_v1.xls", excel append label ctitle(`x',  cluster estado)

	*cluster cod_meso
	xtreg `x' d_ice_fluxo d_ano*  $controles_selecao  $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(cod_meso)	
	outreg2 using "$output/em_diff_in_diff_selecao_v1.xls", excel append label ctitle(`x',  cluster meso)

	*cluster uf ano
	xtreg `x' d_ice_fluxo d_ano* $controles_selecao  $estado ///
	if (d_dep4 == 0 | ice == 1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/em_diff_in_diff_selecao_v1.xls", excel append label ctitle(`x',  cluster uf ano)

	xtreg `x' fake d_ano* $controles_selecao  $estado ///
	if (d_dep4 == 0 | ice == 1), fe 
	outreg2 using "$output/em_diff_in_diff_selecao_fake_v1.xls", excel append label ctitle(`x' fake,  fe)
	
	*cluster codigo_uf
	xtreg `x' fake d_ano*  $controles_selecao  $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(codigo_uf)
	outreg2 using "$output/em_diff_in_diff_selecao_fake_v1.xls", excel append label ctitle(`x' fake,  cluster estado)

	*cluster cod_meso
	xtreg `x' fake d_ano*  $controles_selecao $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(cod_meso)	
	outreg2 using "$output/em_diff_in_diff_selecao_fake_v1.xls", excel append label ctitle(`x' fake,  cluster meso)

	*cluster uf ano
	xtreg `x' fake d_ano* $controles_selecao  $estado ///
	if (d_dep4 == 0 | ice == 1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/em_diff_in_diff_selecao_fake_v1.xls", excel append label ctitle(`x' fake,  cluster uf ano)



}
*/
/*concluir_em_ano_enem*/
/*e_mora_mais_de_6_pessoas*/
/*e_escol_sup_pai*/
/*e_escol_sup_mae*/
/*e_renda_familia_5_salarios*/
/*e_trabalhou_ou_procurou*/


