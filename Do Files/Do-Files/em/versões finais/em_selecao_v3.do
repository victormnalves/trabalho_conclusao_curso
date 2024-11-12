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
global output "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\resultados finais"
global Bases "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"
global dofiles "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\Do-Files"
global Logfolder "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\logfiles"



global folderservidor "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"

log using "$Logfolder/em_selecao_v3.log", replace
use "$folderservidor\dados_EM_14_v3.dta", clear

global controles_fisico rural  	///
	predio diretoria sala_professores biblioteca internet lixo_coleta ///
	eletricidade agua esgoto lab_info lab_ciencias quadra_esportes  	///
	 mais_educ 
	
global controles_cidade  pib_capita_reais_real_2015  pop

global controles_professores n_prof_em_ep n_prof_tecn n_prof_eja ///
	n_prof_em_ef_comp n_prof_em_em ///
	n_prof_em_sup

global controles_alunos n_alunos_em_ep n_mulheres_em_ep

global controles_enem concluir_em_ano_enem e_mora_mais_de_6_pessoas ///
	e_escol_sup_pai	///
	e_escol_sup_mae e_renda_familia_5_salarios e_trabalhou_ou_procurou

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


/*Efeito Seleção do programa*/
/*Impacto nas caracterísitcas do ENEM*/
capture erase "$output/em_diff_in_diff_selecao_enem_v3.xls"
foreach x in $controles_enem{

	xtreg `x'  d_ice_fluxo d_ano* $controles_fisico  ///
	$controles_cidade $controles_alunos $controles_professores ///
	if (d_dep4 == 0 | ice == 1), fe 
	outreg2 using "$output/em_diff_in_diff_selecao_enem_v3.xls", excel append label ctitle(`x',  fe)
	
	*cluster codigo_uf
	xtreg `x' d_ice_fluxo d_ano* $controles_fisico  ///
	$controles_cidade $controles_alunos $controles_professores ///
		if (d_dep4 == 0 | ice == 1), fe cluster(codigo_uf)
	outreg2 using "$output/em_diff_in_diff_selecao_enem_v3.xls", excel append label ctitle(`x',  cluster estado)

	*cluster cod_meso
	xtreg `x' d_ice_fluxo d_ano*  $controles_fisico  ///
	$controles_cidade $controles_alunos $controles_professores ///
		if (d_dep4 == 0 | ice == 1), fe cluster(cod_meso)	
	outreg2 using "$output/em_diff_in_diff_selecao_enem_v3.xls", excel append label ctitle(`x',  cluster meso)

	*cluster uf ano
	xtreg `x' d_ice_fluxo d_ano*  $controles_fisico  ///
	$controles_cidade $controles_alunos $controles_professores ///
	if (d_dep4 == 0 | ice == 1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/em_diff_in_diff_selecao_enem_v3.xls", excel append label ctitle(`x',  cluster uf ano)

	*cluster cidade
	xtreg `x' d_ice_fluxo d_ano*  $controles_fisico  ///
	$controles_cidade $controles_alunos $controles_professores ///
	if (d_dep4 == 0 | ice == 1), fe vce(cluster cod_munic)
	outreg2 using "$output/em_diff_in_diff_selecao_enem_v3.xls", excel append label ctitle(`x',  cluster cidade)

}	

capture erase "$output/em_diff_in_diff_selecao_fis_v3.xls"
/*Impacto nas caracterísitcas físicas da escola*/
foreach x in $controles_fisico{

	xtreg `x'  d_ice_fluxo d_ano* $controles_enem  ///
	$controles_cidade $controles_alunos $controles_professores ///
	if (d_dep4 == 0 | ice == 1), fe 
	outreg2 using "$output/em_diff_in_diff_selecao_fis_v3.xls", excel append label ctitle(`x',  fe)
	
	*cluster codigo_uf
	xtreg `x' d_ice_fluxo d_ano* $controles_enem  ///
	$controles_cidade $controles_alunos $controles_professores ///
		if (d_dep4 == 0 | ice == 1), fe cluster(codigo_uf)
	outreg2 using "$output/em_diff_in_diff_selecao_fis_v3.xls", excel append label ctitle(`x',  cluster estado)

	*cluster cod_meso
	xtreg `x' d_ice_fluxo d_ano*  $controles_enem  ///
	$controles_cidade $controles_alunos $controles_professores ///
		if (d_dep4 == 0 | ice == 1), fe cluster(cod_meso)	
	outreg2 using "$output/em_diff_in_diff_selecao_fis_v3.xls", excel append label ctitle(`x',  cluster meso)

	*cluster uf ano
	xtreg `x' d_ice_fluxo d_ano*  $controles_enem  ///
	$controles_cidade $controles_alunos $controles_professores ///
	if (d_dep4 == 0 | ice == 1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/em_diff_in_diff_selecao_fis_v3.xls", excel append label ctitle(`x',  cluster uf ano)

	*cluster cidade
	xtreg `x' d_ice_fluxo d_ano*  $controles_enem  ///
	$controles_cidade $controles_alunos $controles_professores ///
	if (d_dep4 == 0 | ice == 1), fe vce(cluster cod_munic)
	outreg2 using "$output/em_diff_in_diff_selecao_fis_v3.xls", excel append label ctitle(`x',  cluster cidade)

}	
capture erase "$output/em_diff_in_diff_selecao_alun_v3.xls"
/*Impacto nas caracterísitcas de número na escola*/
foreach x in $controles_alunos{

	xtreg `x'  d_ice_fluxo d_ano* $controles_enem  ///
	$controles_cidade $controles_fisico $controles_professores ///
	if (d_dep4 == 0 | ice == 1), fe 
	outreg2 using "$output/em_diff_in_diff_selecao_alun_v3.xls", excel append label ctitle(`x',  fe)
	
	*cluster codigo_uf
	xtreg `x' d_ice_fluxo d_ano* $controles_enem  ///
	$controles_cidade $controles_fisico $controles_professores ///
		if (d_dep4 == 0 | ice == 1), fe cluster(codigo_uf)
	outreg2 using "$output/em_diff_in_diff_selecao_alun_v3.xls", excel append label ctitle(`x',  cluster estado)

	*cluster cod_meso
	xtreg `x' d_ice_fluxo d_ano*  $controles_enem  ///
	$controles_cidade $controles_fisico $controles_professores ///
		if (d_dep4 == 0 | ice == 1), fe cluster(cod_meso)	
	outreg2 using "$output/em_diff_in_diff_selecao_alun_v3.xls", excel append label ctitle(`x',  cluster meso)

	*cluster uf ano
	xtreg `x' d_ice_fluxo d_ano*  $controles_enem  ///
	$controles_cidade $controles_fisico $controles_professores ///
	if (d_dep4 == 0 | ice == 1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/em_diff_in_diff_selecao_alun_v3.xls", excel append label ctitle(`x',  cluster uf ano)

	*cluster cidade
	xtreg `x' d_ice_fluxo d_ano*  $controles_enem  ///
	$controles_cidade $controles_fisico $controles_professores ///
	if (d_dep4 == 0 | ice == 1), fe vce(cluster cod_munic)
	outreg2 using "$output/em_diff_in_diff_selecao_alun_v3.xls", excel append label ctitle(`x',  cluster cidade)

}	
/*Impacto nas caracterísitcas de professores  na escola*/

/*gen n_total_em = n_prof_em_ef_incomp + n_prof_em_ef_comp + n_prof_em_em + n_prof_em_sup
gen p_em_superior = .
replace p_em_superior = n_prof_em_sup/n_total_em
order n_total_em p_em_superior, after (n_prof_em_sup)*/
capture erase "$output/em_diff_in_diff_selecao_prof_v3.xls"
foreach x in $controles_professores p_em_superior{

	xtreg `x'  d_ice_fluxo d_ano* $controles_enem  ///
	$controles_cidade $controles_fisico $controles_alunos ///
	if (d_dep4 == 0 | ice == 1), fe 
	outreg2 using "$output/em_diff_in_diff_selecao_prof_v3.xls", excel append label ctitle(`x',  fe)
	
	*cluster codigo_uf
	xtreg `x' d_ice_fluxo d_ano* $controles_enem  ///
	$controles_cidade $controles_fisico $controles_alunos ///
		if (d_dep4 == 0 | ice == 1), fe cluster(codigo_uf)
	outreg2 using "$output/em_diff_in_diff_selecao_prof_v3.xls", excel append label ctitle(`x',  cluster estado)

	*cluster cod_meso
	xtreg `x' d_ice_fluxo d_ano*  $controles_enem  ///
	$controles_cidade $controles_fisico $controles_alunos ///
		if (d_dep4 == 0 | ice == 1), fe cluster(cod_meso)	
	outreg2 using "$output/em_diff_in_diff_selecao_prof_v3.xls", excel append label ctitle(`x',  cluster meso)

	*cluster uf ano
	xtreg `x' d_ice_fluxo d_ano*  $controles_enem  ///
	$controles_cidade $controles_fisico $controles_alunos ///
	if (d_dep4 == 0 | ice == 1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/em_diff_in_diff_selecao_prof_v3.xls", excel append label ctitle(`x',  cluster uf ano)

	*cluster cidade
	xtreg `x' d_ice_fluxo d_ano*  $controles_enem  ///
	$controles_cidade $controles_fisico $controles_alunos ///
	if (d_dep4 == 0 | ice == 1), fe vce(cluster cod_munic)
	outreg2 using "$output/em_diff_in_diff_selecao_prof_v3.xls", excel append label ctitle(`x',  cluster cidade)

}	

log close
