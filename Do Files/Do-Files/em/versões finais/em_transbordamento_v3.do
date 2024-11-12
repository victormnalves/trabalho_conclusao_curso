*******************************************************************************
/*				ENSINO MÉDIO EFEITO TRANSBORDAMENTO							*/	
*******************************************************************************
/*

vamos calcular o efeito do program aplicado ao ensino fundamental
no ensino médio


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

log using "$Logfolder/em_transbordamento_v3.log", replace
use "$folderservidor\dados_EM_14_v3.dta", clear

global estado d_uf*
global outcomes apr_em_std rep_em_std aba_em_std dist_em_std ///
enem_nota_matematica_std  enem_nota_ciencias_std /// 
enem_nota_humanas_std enem_nota_linguagens_std  ///
enem_nota_redacao_std enem_nota_objetivab_std  ///


global controles  concluir_em_ano_enem e_mora_mais_de_6_pessoas e_escol_sup_pai	///
	e_escol_sup_mae e_renda_familia_5_salarios e_trabalhou_ou_procurou rural  	///
	predio diretoria sala_professores biblioteca internet lixo_coleta ///
	eletricidade agua esgoto lab_info lab_ciencias quadra_esportes  	///
	n_alunos_em_ep n_mulheres_em_ep pib_capita_reais_real_2015 pop mais_educ ///
	n_prof_em_ep n_prof_tecn n_prof_eja n_prof_em_ef_comp n_prof_em_em ///
	n_prof_em_sup
local estado d_uf*

xtset codigo_escola ano
/**/
gen uf_ano = .
forvalues y = 2003(1)2015{
	foreach x in "23" "26" "32" "33" "35" "52"{
		replace uf_ano = `x'.`y' if ano == `y' & codigo_uf == `x'
	
	}
}
egen double_cluster=group(codigo_uf ano)

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
		replace d_ice_fluxo=1 if ice_`x'==1 &ano==`x' 
		replace d_ice_nota=1 if ice_`x'==1 &ano==`x' 
}

replace ice = 0 if somente_fundamental ==0
replace ice = 1 if somente_fundamental ==1
replace d_ice_fluxo = 0 if ice ==0
replace d_ice_nota = 0 if ice==0



*notas
*enem_nota_objetivo,std
	*fe
	xtreg enem_nota_objetivab_std d_ice_nota d_ano* $controles $estado if (d_dep4 == 0 | ice == 1), fe 
	outreg2 using "$output/em_transbord_v3.xls", excel replace label ctitle(enem objetiva,  fe)

	*cluster codigo_uf
	xtreg enem_nota_objetivab_std d_ice_nota d_ano* $controles $estado if (d_dep4 == 0 | ice == 1), fe cluster(codigo_uf)
	outreg2 using "$output/em_transbord_v3.xls", excel append label ctitle(enem objetiva,  cluster estado)

	*cluster cod_meso
	xtreg enem_nota_objetivab_std d_ice_nota d_ano* $controles $estado if (d_dep4 == 0 | ice == 1), fe cluster(cod_meso)
	outreg2 using "$output/em_transbord_v3.xls", excel append label ctitle(enem objetiva,  cluster meso)


	*cluster uf ano
	xtreg enem_nota_objetivab_std d_ice_nota d_ano* $controles $estado if (d_dep4 == 0 | ice == 1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/em_transbord_v3.xls", excel append label ctitle(enem objetiva,  cluster uf ano)


	*cluster cidade
	xtreg enem_nota_objetivab_std d_ice_nota d_ano* $controles $estado if (d_dep4 == 0 | ice == 1), fe vce(cluster cod_munic)
	outreg2 using "$output/em_transbord_v3.xls", excel append label ctitle(enem objetiva,  cluster cidade)



foreach x in "enem_nota_redacao_std"  {	

	*fe
	xtreg `x' d_ice_nota d_ano* $controles $estado ///
		if (d_dep4 == 0 | ice == 1), fe 
	outreg2 using "$output/em_transbord_v3.xls", excel append label ctitle(`x',  fe)
	
	*cluster codigo_uf
	xtreg `x' d_ice_nota d_ano*  $controles $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(codigo_uf)
	outreg2 using "$output/em_transbord_v3.xls", excel append label ctitle(`x',  cluster estado)

	*cluster cod_meso
	xtreg `x' d_ice_nota d_ano*  $controles $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(cod_meso)	
	outreg2 using "$output/em_transbord_v3.xls", excel append label ctitle(`x',  cluster meso)

	*cluster uf ano
	xtreg `x' d_ice_nota d_ano* $controles $estado ///
		if (d_dep4 == 0 | ice == 1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/em_transbord_v3.xls", excel append label ctitle(`x',  cluster uf ano)
	*cluster uf ano
	xtreg `x' d_ice_nota d_ano* $controles $estado ///
		if (d_dep4 == 0 | ice == 1), fe vce(cluster cod_munic)
	outreg2 using "$output/em_transbord_v3.xls", excel append label ctitle(`x',  cluster cidades)
}

foreach x in "apr_em_std" "rep_em_std" "aba_em_std" "dist_em_std"  {	
*enem_nota_redacao_std
	*fe
	xtreg `x' d_ice_fluxo d_ano* $controles $estado ///
	if (d_dep4 == 0 | ice == 1), fe 
	outreg2 using "$output/em_transbord_v3.xls", excel append label ctitle(`x',  fe)
	
	*cluster codigo_uf
	xtreg `x' d_ice_fluxo d_ano*  $controles $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(codigo_uf)
	outreg2 using "$output/em_transbord_v3.xls", excel append label ctitle(`x',  cluster estado)

	*cluster cod_meso
	xtreg `x' d_ice_fluxo d_ano*  $controles $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(cod_meso)	
	outreg2 using "$output/em_transbord_v3.xls", excel append label ctitle(`x',  cluster meso)

	*cluster uf ano
	xtreg `x' d_ice_fluxo d_ano* $controles $estado ///
	if (d_dep4 == 0 | ice == 1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/em_transbord_v3.xls", excel append label ctitle(`x',  cluster uf ano)
	
	*cluster cidades
	xtreg `x' d_ice_fluxo d_ano* $controles $estado ///
	if (d_dep4 == 0 | ice == 1), fe vce(cluster cod_munic)
	outreg2 using "$output/em_transbord_v3.xls", excel append label ctitle(`x',  cluster cidades)
}
