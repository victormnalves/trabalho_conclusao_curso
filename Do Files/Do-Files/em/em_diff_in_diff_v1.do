/*
Difference-in-Difference Estimation


*/

/*
o objetivo nessa rotina é estimar o efeito médio do tratamento nos tratados,
pelo método de diferenças em diferenças.
o tratamento é ter o ice na sua escola.
a estrutura de dados é um painel desbalanceado, onde a unidade é a escola 
e o tempo é o ano.


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

log using "$Logfolder/em_diff-in-diff.log", replace
use "$folderservidor\dados_EM_14_enem_only.dta", clear
/// use "$folderservidor\dados_EM_par_cen_esc.dta", clear


global estado d_uf*
global outcomes apr_em_std rep_em_std aba_em_std dist_em_std ///
enem_nota_matematica_std  enem_nota_ciencias_std /// 
enem_nota_humanas_std enem_nota_linguagens_std  ///
enem_nota_redacao_std enem_nota_objetivab_std  ///


global controles  concluir_em_ano_enem e_mora_mais_de_6_pessoas e_escol_sup_pai	///
	e_escol_sup_mae e_renda_familia_5_salarios e_trabalhou_ou_procurou rural  	///
	predio diretoria sala_professores biblioteca internet lixo_coleta ///
	eletricidade agua esgoto lab_info lab_ciencias quadra_esportes  	///
	n_alunos_em_ep n_mulheres_em_ep pib_capita_reais_real_2015 pop mais_educ 

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


*notas
*enem_nota_objetivo,std
	*fe
	xtreg enem_nota_objetivab_std d_ice_nota d_ano* $controles $estado if (d_dep4 == 0 | ice == 1), fe 
	outreg2 using "$output/em_diff_in_diff_v1.xls", excel replace label ctitle(enem objetiva,  fe)

	*cluster codigo_uf
	xtreg enem_nota_objetivab_std d_ice_nota d_ano* $controles $estado if (d_dep4 == 0 | ice == 1), fe cluster(codigo_uf)
	outreg2 using "$output/em_diff_in_diff_v1.xls", excel append label ctitle(enem objetiva,  cluster estado)

	*cluster cod_meso
	xtreg enem_nota_objetivab_std d_ice_nota d_ano* $controles $estado if (d_dep4 == 0 | ice == 1), fe cluster(cod_meso)
	outreg2 using "$output/em_diff_in_diff_v1.xls", excel append label ctitle(enem objetiva,  cluster meso)


	*cluster uf ano
	xtreg enem_nota_objetivab_std d_ice_nota d_ano* $controles $estado if (d_dep4 == 0 | ice == 1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/em_diff_in_diff_v1.xls", excel append label ctitle(enem objetiva,  cluster uf ano)



foreach x in "enem_nota_redacao_std"  {	

	*fe
	xtreg `x' d_ice_nota d_ano* $controles $estado ///
		if (d_dep4 == 0 | ice == 1), fe 
	outreg2 using "$output/em_diff_in_diff_v1.xls", excel append label ctitle(`x',  fe)
	
	*cluster codigo_uf
	xtreg `x' d_ice_nota d_ano*  $controles $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(codigo_uf)
	outreg2 using "$output/em_diff_in_diff_v1.xls", excel append label ctitle(`x',  cluster estado)

	*cluster cod_meso
	xtreg `x' d_ice_nota d_ano*  $controles $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(cod_meso)	
	outreg2 using "$output/em_diff_in_diff_v1.xls", excel append label ctitle(`x',  cluster meso)

	*cluster uf ano
	xtreg `x' d_ice_nota d_ano* $controles $estado ///
		if (d_dep4 == 0 | ice == 1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/em_diff_in_diff_v1.xls", excel append label ctitle(`x',  cluster uf ano)
}

foreach x in "apr_em_std" "rep_em_std" "aba_em_std" "dist_em_std"  {	
*enem_nota_redacao_std
	*fe
	xtreg `x' d_ice_fluxo d_ano* $controles $estado ///
	if (d_dep4 == 0 | ice == 1), fe 
	outreg2 using "$output/em_diff_in_diff_v1.xls", excel append label ctitle(`x',  fe)
	
	*cluster codigo_uf
	xtreg `x' d_ice_fluxo d_ano*  $controles $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(codigo_uf)
	outreg2 using "$output/em_diff_in_diff_v1.xls", excel append label ctitle(`x',  cluster estado)

	*cluster cod_meso
	xtreg `x' d_ice_fluxo d_ano*  $controles $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(cod_meso)	
	outreg2 using "$output/em_diff_in_diff_v1.xls", excel append label ctitle(`x',  cluster meso)

	*cluster uf ano
	xtreg `x' d_ice_fluxo d_ano* $controles $estado ///
	if (d_dep4 == 0 | ice == 1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/em_diff_in_diff_v1.xls", excel append label ctitle(`x',  cluster uf ano)
}

	
*subamostras restringindo em algumas caracterísicas


/*
como a implementação do programa tem características distintas?
*/

*PE na fase inicial  

/* 
aqui vamos estimar o efeito do programa somente no estado da paraíba, até 2011,
que é até quando o efeito da primeira fase do programa é sentido
aqui não tem há indicadores de fluxo, pois ela só começou em 2007
*/
*notas
*enem_nota_objetivo,std
	*sem cluster
	xtreg enem_nota_objetivab_std d_ice_nota  d_ano* ///
	 $controles  $estado ///
	if (d_dep4 == 0 | ice == 1)&codigo_uf==26& ano<2011, fe 
	outreg2 using "$output/em_diff_in_diff_PE_in_v1.xls", excel replace label ctitle(enem objetiva PE inicial,  sem cluster)

	*cluster cod_meso
	xtreg enem_nota_objetivab_std d_ice_nota d_ano* ///
	$controles $estado ///
	if (d_dep4 == 0 | ice == 1)&codigo_uf==26& ano<2011 , fe cluster(cod_meso)
	outreg2 using "$output/em_diff_in_diff_PE_in_v1.xls", excel append label ctitle(enem objetiva PE inicial,  cluster meso)

	*cluster estado ano
	xtreg enem_nota_objetivab_std d_ice_nota d_ano* ///
	$controles $estado ///
	if (d_dep4 == 0 | ice == 1)&codigo_uf==26& ano<2011 , fe vce(cluster double_cluster) nonest
	outreg2 using "$output/em_diff_in_diff_PE_in_v1.xls", excel append label ctitle(enem objetiva PE inicial,  cluster ano uf)

*enem_nota_redacao_std
	*cluster codigo_uf
	xtreg enem_nota_redacao_std d_ice_nota d_ano*  ///
	$controles  $estado ///
	if (d_dep4 == 0 | ice == 1)&codigo_uf==26& ano<2011, fe 
	outreg2 using "$output/em_diff_in_diff_PE_in_v1.xls", excel append label ctitle(enem redacao PE inicial,  sem cluster)

	*cluster cod_meso
	xtreg enem_nota_redacao_std d_ice_nota d_ano*  ///
	$controles  $estado ///
	if (d_dep4 == 0 | ice == 1)&codigo_uf==26& ano<2011, fe cluster(cod_meso)	
	outreg2 using "$output/em_diff_in_diff_PE_in_v1.xls", excel append label ctitle(enem redacao PE inicial,  cluster meso)


	*cluster estado ano
	xtreg enem_nota_redacao_std d_ice_nota d_ano*  ///
	$controles  $estado ///
	if (d_dep4 == 0 | ice == 1)&codigo_uf==26& ano<2011, fe vce(cluster double_cluster) nonest	
	outreg2 using "$output/em_diff_in_diff_PE_in_v1.xls", excel append label ctitle(enem redacao PE inicial,  cluster ano uf)

/*
PE geral

*/

*enem_nota_objetivo,std
	*sem cluster
	xtreg enem_nota_objetivab_std d_ice_nota  d_ano* ///
	 $controles  $estado ///
	if (d_dep4 == 0 | ice == 1)&codigo_uf==26, fe 
	outreg2 using "$output/em_diff_in_diff_PE_ge_v1.xls", excel replace label ctitle(enem objetiva PE geral,  sem cluster)

	*cluster cod_meso
	xtreg enem_nota_objetivab_std d_ice_nota d_ano* ///
	$controles $estado ///
	if (d_dep4 == 0 | ice == 1)&codigo_uf==26 , fe cluster(cod_meso)
	outreg2 using "$output/em_diff_in_diff_PE_ge_v1.xls", excel append label ctitle(enem objetiva PE geral,  cluster meso)

	*cluster estado ano
	xtreg enem_nota_objetivab_std d_ice_nota d_ano*  ///
	$controles  $estado ///
	if (d_dep4 == 0 | ice == 1)&codigo_uf==26 , fe vce(cluster double_cluster) nonest	
	outreg2 using "$output/em_diff_in_diff_PE_ge_v1.xls", excel append label ctitle(enem objetiva PE geral,  cluster ano uf)

*enem_nota_redacao_std
	*sem cluster 
	xtreg enem_nota_redacao_std d_ice_nota d_ano*  ///
	$controles  $estado ///
	if (d_dep4 == 0 | ice == 1)&codigo_uf==26, fe 
	outreg2 using "$output/em_diff_in_diff_PE_ge_v1.xls", excel append label ctitle(enem redacao PE geral,  sem cluster)

	*cluster cod_meso
	xtreg enem_nota_redacao_std d_ice_nota d_ano*  ///
	$controles  $estado ///
	if (d_dep4 == 0 | ice == 1)&codigo_uf==26, fe cluster(cod_meso)	
	outreg2 using "$output/em_diff_in_diff_PE_ge_v1.xls", excel append label ctitle(enem redacao PE geral,  cluster meso)

	*cluster estado ano
	xtreg enem_nota_redacao_std d_ice_nota d_ano*  ///
	$controles $estado ///
	if (d_dep4 == 0 | ice == 1)&codigo_uf==26 , fe vce(cluster double_cluster) nonest	
	outreg2 using "$output/em_diff_in_diff_PE_ge_v1.xls", excel append label ctitle(enem redacao PE geral,  cluster ano uf)

	
*fluxo

*apr_em_std
	*sem cluster 
	xtreg apr_em_std d_ice_fluxo  d_ano*  ///
	$controles $estado if (d_dep4 == 0 | ice == 1)&codigo_uf==26, fe 
	outreg2 using "$output/em_diff_in_diff_PE_ge_v1.xls", excel append label ctitle(aprovacao PE geral,  sem cluster )

	*cluster cod_meso
	xtreg apr_em_std d_ice_fluxo d_ano*  ///
	$controles $estado if (d_dep4 == 0 | ice == 1)&codigo_uf==26, fe cluster(cod_meso)	
	outreg2 using "$output/em_diff_in_diff_PE_ge_v1.xls", excel append label ctitle(aprovacao PE geral,  cluster meso)

	*cluster estado ano
	xtreg apr_em_std d_ice_fluxo d_ano*  ///
	$controles $estado ///
	if (d_dep4 == 0 | ice == 1)&codigo_uf==26 , fe vce(cluster double_cluster) nonest	
	outreg2 using "$output/em_diff_in_diff_PE_ge_v1.xls", excel append label ctitle(aprovacao PE geral,  cluster ano uf)
*rep_em_std 
	*sem cluster
	xtreg rep_em_std d_ice_fluxo  d_ano*  ///
	$controles $estado if (d_dep4 == 0 | ice == 1)&codigo_uf==26, fe 
	outreg2 using "$output/em_diff_in_diff_PE_ge_v1.xls", excel append label ctitle(reprovacao PE geral,  sem  cluster )

	*cluster cod_meso
	xtreg rep_em_std d_ice_fluxo d_ano*  ///
	$controles $estado if (d_dep4 == 0 | ice == 1)&codigo_uf==26, fe cluster(cod_meso)	
	outreg2 using "$output/em_diff_in_diff_PE_ge_v1.xls", excel append label ctitle(reprovacao PE geral,  cluster meso)

	*cluster estado ano
	xtreg rep_em_std d_ice_fluxo d_ano*  ///
	$controles $estado ///
	if (d_dep4 == 0 | ice == 1)&codigo_uf==26 , fe vce(cluster double_cluster) nonest	
	outreg2 using "$output/em_diff_in_diff_PE_ge_v1.xls", excel append label ctitle(reprovacao PE geral,  cluster ano uf)
*dist_em_std 
	*sem cluster
	xtreg dist_em_std d_ice_fluxo  d_ano*  ///
	$controles $estado if (d_dep4 == 0 | ice == 1)&codigo_uf==26, fe 
	outreg2 using "$output/em_diff_in_diff_PE_ge_v1.xls", excel append label ctitle(distorcao PE geral,  sem cluster)

	*cluster cod_meso
	xtreg dist_em_std d_ice_fluxo d_ano*  ///
	$controles $estado if (d_dep4 == 0 | ice == 1)&codigo_uf==26, fe cluster(cod_meso)	
	outreg2 using "$output/em_diff_in_diff_PE_ge_v1.xls", excel append label ctitle(distorcao PE geral,  cluster meso)

	*cluster estado ano
	xtreg dist_em_std d_ice_fluxo d_ano*  ///
	$controles $estado ///
	if (d_dep4 == 0 | ice == 1)&codigo_uf==26 , fe vce(cluster double_cluster) nonest	
	outreg2 using "$output/em_diff_in_diff_PE_ge_v1.xls", excel append label ctitle(distorcao PE geral,  cluster ano uf)
*aba_em_std 
	*sem cluster
	xtreg aba_em_std d_ice_fluxo  d_ano*  ///
	$controles $estado if (d_dep4 == 0 | ice == 1)&codigo_uf==26, fe 
	outreg2 using "$output/em_diff_in_diff_PE_ge_v1.xls", excel append label ctitle(abandono PE geral,  sem cluster)

	*cluster cod_meso
	xtreg aba_em_std d_ice_fluxo d_ano*  ///
	$controles $estado if (d_dep4 == 0 | ice == 1)&codigo_uf==26, fe cluster(cod_meso)	
	outreg2 using "$output/em_diff_in_diff_PE_ge_v1.xls", excel append label ctitle(abandono PE geral,  cluster meso)

	*cluster estado ano
	xtreg aba_em_std d_ice_fluxo d_ano*  ///
	$controles $estado ///
	if (d_dep4 == 0 | ice == 1)&codigo_uf==26 , fe vce(cluster double_cluster) nonest	
	outreg2 using "$output/em_diff_in_diff_PE_ge_v1.xls", excel append label ctitle(distorcao PE geral,  cluster ano uf)

/*não inicial */





*enem_nota_objetivo,std
	*sem cluster
	xtreg enem_nota_objetivab_std d_ice_nota  d_ano* ///
	 $controles  /// $estado ///
	if (d_dep4 == 0 | ice == 1)&ano>=2008, fe 
	outreg2 using "$output/em_diff_in_diff_not_ini_v1.xls", excel replace label ctitle(enem objetiva nao inicial,  sem cluster)

	*cluster cod_meso
	xtreg enem_nota_objetivab_std d_ice_nota d_ano* ///
	$controles ///$estado ///
	if (d_dep4 == 0 | ice == 1)&ano>=2008 , fe cluster(cod_meso)
	outreg2 using "$output/em_diff_in_diff_not_ini_v1.xls", excel append label ctitle(enem objetiva nao inicial,  cluster meso)

	*cluster estado ano
	xtreg enem_nota_objetivab_std d_ice_nota d_ano*  ///
	$controles /// $estado ///
	if (d_dep4 == 0 | ice == 1)&ano>=2008 , fe vce(cluster double_cluster) nonest	
	outreg2 using "$output/em_diff_in_diff_not_ini_v1.xls", excel append label ctitle(enem objetiva nao inicial,  cluster ano uf)

*enem_nota_redacao_std
	*sem cluster 
	xtreg enem_nota_redacao_std d_ice_nota d_ano*  ///
	$controles /// $estado ///
	if (d_dep4 == 0 | ice == 1)&ano>=2008, fe 
	outreg2 using "$output/em_diff_in_diff_not_ini_v1.xls", excel append label ctitle(enem redacao nao inicial,  sem cluster)

	*cluster cod_meso
	xtreg enem_nota_redacao_std d_ice_nota d_ano*  ///
	$controles /// $estado ///
	if (d_dep4 == 0 | ice == 1)&ano>=2008, fe cluster(cod_meso)	
	outreg2 using "$output/em_diff_in_diff_not_ini_v1.xls", excel append label ctitle(enem redacao nao inicial,  cluster meso)

	*cluster estado ano
	xtreg enem_nota_redacao_std d_ice_nota d_ano*  ///
	$controles /// $estado ///
	if (d_dep4 == 0 | ice == 1)&ano>=2008 , fe vce(cluster double_cluster) nonest	
	outreg2 using "$output/em_diff_in_diff_not_ini_v1.xls", excel append label ctitle(enem redacao nao inicial,  cluster ano uf)
*fluxo
*aba_em_std dist_em_std rep_em_std apr_em_std
foreach x in "aba_em_std" "dist_em_std" "rep_em_std" "apr_em_std"   {	 
	*sem cluster
	xtreg `x' d_ice_fluxo  d_ano*  ///
	$controles $estado if (d_dep4 == 0 | ice == 1)&ano>=2008 , fe 
	outreg2 using "$output/em_diff_in_diff_not_ini_v1.xls", excel append label ctitle(`x' nao inicial,  sem cluster)

	*cluster cod_meso
	xtreg `x' d_ice_fluxo d_ano*  ///
	$controles $estado if (d_dep4 == 0 | ice == 1)&ano>=2008 , fe cluster(cod_meso)	
	outreg2 using "$output/em_diff_in_diff_not_ini_v1.xls", excel append label ctitle(`x' nao inicial,  cluster meso)

	*cluster estado ano
	xtreg `x' d_ice_fluxo d_ano*  ///
	$controles $estado ///
	if (d_dep4 == 0 | ice == 1)&ano>=2008  , fe vce(cluster double_cluster) nonest	
	outreg2 using "$output/em_diff_in_diff_not_ini_v1.xls", excel append label ctitle(`x' nao inicial,  cluster ano uf)



}
