

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

log using "$Logfolder/em_diff-in-diff_par_cens_esc.log", replace
use "$folderservidor\dados_EM_par_cen_esc.dta", clear

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

tabstat $controles, by(d_entrada_2008) stat(mean sd)
 
eststo controle: quietly estpost summarize ///
    $controles if d_entrada_2008 == 0
eststo tratado: quietly estpost summarize ///
    $controles if d_entrada_2008 == 1
eststo diff: quietly estpost ttest ///
    $controles, by(d_entrada_2008) unequal
esttab controle tratado diff, ///
cells("mean(pattern(1 1 0) fmt(2)) sd(pattern(1 1 0)) b(star pattern(0 0 1) fmt(2)) t(pattern(0 0 1) par fmt(2))") ///
label

*enem_nota_objetivo,std
	*cluster codigo_uf
	xtreg enem_nota_objetivab_std d_ice_nota d_ano* $controles $estado if (d_dep4 == 0 | ice == 1), fe cluster(codigo_uf)
	outreg2 using "$output/em_diff_in_diff_par_cen_esc_v1.xls", excel replace label ctitle(enem objetiva,  cluster estado)

	*cluster cod_meso
	xtreg enem_nota_objetivab_std d_ice_nota d_ano* $controles $estado if (d_dep4 == 0 | ice == 1), fe cluster(cod_meso)
	outreg2 using "$output/em_diff_in_diff_par_cen_esc_v1.xls", excel append label ctitle(enem objetiva,  cluster meso)

