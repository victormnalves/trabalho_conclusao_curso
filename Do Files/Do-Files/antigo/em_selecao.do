
*em escola pública seleção

capture log close

clear all
set more off

*cd "`:environment USERPROFILE'\OneDrive\EESP - ECONOMIA - mestrado acadêmico\Dissertação\ICE\dados ICE"
global user "`:environment USERPROFILE'"
*global Folder "$user/OneDrive/EESP_ECONOMIA_mestrado_acadêmico/Dissertação/ICE/dados_ICE/Análise_Leonardo"
/*
global Folder "D:\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo"
global output "$Folder/resultados"
global Bases "$folderservidor"
global dofiles "$Folder/Do-Files"
global Logfolder "$Folder/Log"
*/
global Folder "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"
global output "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\resultados_v3"
global Bases "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"
global dofiles "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\Do-Files"
global Logfolder "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\logfiles"


global folderservidor "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"
******************************************* só esocla pública*******************
log using "$Logfolder/em_ps_geral_todos_estados_publica.log", replace

use "$folderservidor\em_com_censo_escolar_14.dta", clear
replace ice=0 if ice ==.

*aqui é só escola pública
drop if dep ==4
xtset codigo_escola ano
/*
como o tratamento não é aleatório, precisamos usar alguma metodologia para fazer 
a análise do programa. Aqui, vamos calcular os propensity scores, para fazer 
regressões em painel ponderadas
*/

set matsize 10000

/*
geraremos um pscore, ie, a probabilidade condicional de receber o tratamento, 
dado características predeterminadas
no nosso caso, será estimada a probabilidade cond de determinada
escola receber tratamento ice, dado o número de alunos

pscore treatment [varlist] [weight] [if exp] [in range] , pscore(newvar) [ 
blockid(newvar) detail logit comsup level(#) numblo(#) ]
ver https://www.stata-journal.com/sjpdf.html?articlenum=st0026
*/

*note que estamos fazendo o propensity score por estado e no ano em que a primeira escola foi tratada no estado

global controles_selecao  	///
	 predio 	///
	diretoria sala_professores lab_info lab_ciencias quadra_esportes internet		 ///
	rural lixo_coleta eletricidade agua  esgoto n_salas_utilizadas					///
	n_alunos_em_ep pib_capita_reais_real_2015 pop mais_educ
//mdesc `controles_pscore' taxa_participacao_enem if ano ==2003

global estado d_uf*

pscore ice $controles_selecao taxa_participacao_enem if ano == 2003, pscore(pscores_todos)

/*
pscore ice `controles_pscore' taxa_participacao_enem if ano==2003&codigo_uf==26&dep!=4, pscore(pscores_pe)

pscore ice `controles_pscore' taxa_participacao_enem if ano==2007&codigo_uf==23&dep!=4, pscore(pscores_ce)

pscore ice `controles_pscore' taxa_participacao_enem if ano==2011&codigo_uf==35&dep!=4, pscore(pscores_sp)

pscore ice `controles_pscore' taxa_participacao_enem if ano==2012&codigo_uf==52&dep!=4, pscore(pscores_go)


*/




gen pscore_total=.

replace pscore_total = 1 if ice == 1
replace pscore_total = 1 /(1-pscores_todos) if ice==0
/*
gen pscore_total_estado=.
replace pscore_total_estado = 1 if ice == 1


replace pscore_total_estado=1/(1-pscores_pe) if codigo_uf==26&dep!=4&ice==0

replace pscore_total_estado=1/(1-pscores_ce) if codigo_uf==23&dep!=4&ice==0

replace pscore_total_estado=1/(1-pscores_sp) if codigo_uf==35&dep!=4&ice==0

replace pscore_total_estado=1/(1-pscores_go) if codigo_uf==52&dep!=4&ice==0
*/
*For each category of codigo_escola, generate pscore_total_aux = maximo do pscore_total
*sort arranges the observations of the current data into ascending order
/*
aqui, o propesnity score de cada escola tem que ser equalizado para rodar
o xtreg. isto é, cada escola, ao longo dos anos, tem que ter o mesmo pscore
assim, o max do pscore ao longo dos anos é atribuído como pscore da escola
*/
bysort codigo_escola: egen pscore_total_aux = max(pscore_total)
replace pscore_total = pscore_total_aux

global outcomes_selecao concluir_em_ano_enem e_mora_mais_de_6_pessoas e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_trabalhou_ou_procurou

xtreg concluir_em_ano_enem d_ice_nota d_ano* $controles_selecao , fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_selecao.xls", excel  replace label ctitle(concluir_em_ano_enem, fe cluster estado)

xtreg concluir_em_ano_enem d_ice_nota d_ano*  $controles_selecao [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_selecao.xls", excel append label ctitle(concluir_em_ano_enem, fe cluster estado ps)

xtreg concluir_em_ano_enem d_ice_nota d_ice_nota_inte d_ano* $controles_selecao [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_selecao.xls", excel append label ctitle(concluir_em_ano_enem, fe cluster estado ps, integral)





foreach x in "e_mora_mais_de_6_pessoas" "e_escol_sup_pai" "e_escol_sup_mae" "e_renda_familia_5_salarios" "e_trabalhou_ou_procurou" ///
{
	xtreg `x' d_ice_nota d_ano* $controles_selecao , fe cluster(codigo_uf)
	outreg2 using "$output/ICE_em_selecao.xls", excel  append label ctitle(`x', fe cluster estado)

	xtreg `x' d_ice_nota d_ano*  $controles_selecao [pw=pscore_total], fe cluster(codigo_uf)
	outreg2 using "$output/ICE_em_selecao.xls", excel append label ctitle(`x', fe cluster estado ps)

	xtreg `x' d_ice_nota d_ice_nota_inte d_ano* $controles_selecao [pw=pscore_total], fe cluster(codigo_uf)
	outreg2 using "$output/ICE_em_selecao.xls", excel append label ctitle(`x', fe cluster estado ps, integral)
}
