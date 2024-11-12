/*

difference in differences multiple treatement periods 
(staggered)
amostra pareada nas características observáveis no censo
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

log using "$Logfolder/em_diff-in-diff_cum_par_cens_esc.log", replace
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

gen ano_ice_fluxo = ano_ice
gen ano_ice_nota = ano_ice
forvalues a=2004(1)2015{

replace ano_ice_nota = ano_ice + 2 if(codigo_uf==26|codigo_uf==23)


}

*gerando as variáveis de temoi relativo a entrada no programa
*lembrando que para escolas do ce e do pe, do ensino médio, o programa foi implementado
*no primeiro ano. então, existe um lag de 2 anos para o efeito.
gen tempo_fluxo=.
gen tempo_nota=.


replace tempo_nota=0 if ano==ano_ice_nota-6
replace tempo_nota=1 if ano==ano_ice_nota-5
replace tempo_nota=2 if ano==ano_ice_nota-4
replace tempo_nota=3 if ano==ano_ice_nota-3 
replace tempo_nota=4 if ano==ano_ice_nota-2
replace tempo_nota=5 if ano==ano_ice_nota-1
replace tempo_nota=6 if ano==ano_ice_nota
replace tempo_nota=7 if ano==ano_ice_nota+1 
replace tempo_nota=8 if ano==ano_ice_nota+2
replace tempo_nota=9 if ano==ano_ice_nota+3
replace tempo_nota=10 if ano==ano_ice_nota+4
replace tempo_nota=11 if ano==ano_ice_nota+5
replace tempo_nota=12 if ano==ano_ice_nota+6

replace tempo_fluxo=0 if ano==ano_ice_fluxo-6
replace tempo_fluxo=1 if ano==ano_ice_fluxo-5
replace tempo_fluxo=2 if ano==ano_ice_fluxo-4
replace tempo_fluxo=3 if ano==ano_ice_fluxo-3 
replace tempo_fluxo=4 if ano==ano_ice_fluxo-2
replace tempo_fluxo=5 if ano==ano_ice_fluxo-1
replace tempo_fluxo=6 if ano==ano_ice_fluxo
replace tempo_fluxo=7 if ano==ano_ice_fluxo+1 
replace tempo_fluxo=8 if ano==ano_ice_fluxo+2
replace tempo_fluxo=9 if ano==ano_ice_fluxo+3
replace tempo_fluxo=10 if ano==ano_ice_fluxo+4
replace tempo_fluxo=11 if ano==ano_ice_fluxo+5
replace tempo_fluxo=12 if ano==ano_ice_fluxo+6

tab tempo_nota, gen(d_tempo_nota)
replace  d_tempo_nota1 = 0 if  d_tempo_nota1==.
replace  d_tempo_nota2 = 0 if  d_tempo_nota2==.
replace  d_tempo_nota3 = 0 if  d_tempo_nota3==.
replace  d_tempo_nota4 = 0 if  d_tempo_nota4==.
replace  d_tempo_nota5 = 0 if  d_tempo_nota5==.
replace  d_tempo_nota6 = 0 if  d_tempo_nota6==.
replace  d_tempo_nota7 = 0 if  d_tempo_nota7==.
replace  d_tempo_nota8 = 0 if  d_tempo_nota8==.
replace  d_tempo_nota9 = 0 if  d_tempo_nota9==.
replace  d_tempo_nota10 = 0 if  d_tempo_nota10==.
replace  d_tempo_nota11 = 0 if  d_tempo_nota11==.
replace  d_tempo_nota12 = 0 if  d_tempo_nota12==.
replace  d_tempo_nota13 = 0 if  d_tempo_nota13==.

tab tempo_fluxo, gen(d_tempo_fluxo)
replace  d_tempo_fluxo1 = 0 if  d_tempo_fluxo1==.
replace  d_tempo_fluxo2 = 0 if  d_tempo_fluxo2==.
replace  d_tempo_fluxo3 = 0 if  d_tempo_fluxo3==.
replace  d_tempo_fluxo4 = 0 if  d_tempo_fluxo4==.
replace  d_tempo_fluxo5 = 0 if  d_tempo_fluxo5==.
replace  d_tempo_fluxo6 = 0 if  d_tempo_fluxo6==.
replace  d_tempo_fluxo7 = 0 if  d_tempo_fluxo7==.
replace  d_tempo_fluxo8 = 0 if  d_tempo_fluxo8==.
replace  d_tempo_fluxo9 = 0 if  d_tempo_fluxo9==.
replace  d_tempo_fluxo10 = 0 if  d_tempo_fluxo10==.
replace  d_tempo_fluxo11 = 0 if  d_tempo_fluxo11==.
replace  d_tempo_fluxo12 = 0 if  d_tempo_fluxo12==.
replace  d_tempo_fluxo13 = 0 if  d_tempo_fluxo13==.


gen d_ice_nota_pre6=ice*d_tempo_nota1
gen d_ice_nota_pre5=ice*d_tempo_nota2
gen d_ice_nota_pre4=ice*d_tempo_nota3
gen d_ice_nota_pre3=ice*d_tempo_nota4
gen d_ice_nota_pre2=ice*d_tempo_nota5
gen d_ice_nota_pre1=ice*d_tempo_nota6
gen d_ice_nota_inicio=ice*d_tempo_nota7
gen d_ice_nota_pos1=ice*d_tempo_nota8
gen d_ice_nota_pos2=ice*d_tempo_nota9
gen d_ice_nota_pos3=ice*d_tempo_nota10
gen d_ice_nota_pos4=ice*d_tempo_nota11
gen d_ice_nota_pos5=ice*d_tempo_nota12
gen d_ice_nota_pos6=ice*d_tempo_nota13


replace d_ice_nota_pre6=0 if ice==0
replace d_ice_nota_pre5=0 if ice==0
replace d_ice_nota_pre4=0 if ice==0
replace d_ice_nota_pre3=0 if ice==0
replace d_ice_nota_pre2=0 if ice==0
replace d_ice_nota_pre1=0 if ice==0
replace d_ice_nota_inicio=0 if ice==0
replace d_ice_nota_pos1=0 if ice==0
replace d_ice_nota_pos2=0 if ice==0
replace d_ice_nota_pos3=0 if ice==0
replace d_ice_nota_pos4=0 if ice==0
replace d_ice_nota_pos5=0 if ice==0
replace d_ice_nota_pos6=0 if ice==0

gen d_ice_nota_inte_pre6=ice_inte*d_tempo_nota1
gen d_ice_nota_inte_pre5=ice_inte*d_tempo_nota2
gen d_ice_nota_inte_pre4=ice_inte*d_tempo_nota3
gen d_ice_nota_inte_pre3=ice_inte*d_tempo_nota4
gen d_ice_nota_inte_pre2=ice_inte*d_tempo_nota5
gen d_ice_nota_inte_pre1=ice_inte*d_tempo_nota6
gen d_ice_nota_inte_inicio=ice_inte*d_tempo_nota7
gen d_ice_nota_inte_pos1=ice_inte*d_tempo_nota8
gen d_ice_nota_inte_pos2=ice_inte*d_tempo_nota9
gen d_ice_nota_inte_pos3=ice_inte*d_tempo_nota10
gen d_ice_nota_inte_pos4=ice_inte*d_tempo_nota11
gen d_ice_nota_inte_pos5=ice_inte*d_tempo_nota12
gen d_ice_nota_inte_pos6=ice_inte*d_tempo_nota13

replace d_ice_nota_inte_pre6=0 if ice==0
replace d_ice_nota_inte_pre5=0 if ice==0
replace d_ice_nota_inte_pre4=0 if ice==0
replace d_ice_nota_inte_pre3=0 if ice==0
replace d_ice_nota_inte_pre2=0 if ice==0
replace d_ice_nota_inte_pre1=0 if ice==0
replace d_ice_nota_inte_inicio=0 if ice==0
replace d_ice_nota_inte_pos1=0 if ice==0
replace d_ice_nota_inte_pos2=0 if ice==0
replace d_ice_nota_inte_pos3=0 if ice==0
replace d_ice_nota_inte_pos4=0 if ice==0
replace d_ice_nota_inte_pos5=0 if ice==0
replace d_ice_nota_inte_pos6=0 if ice==0

*dummies de fluxo


gen d_ice_fluxo_pre6=ice*d_tempo_fluxo1
gen d_ice_fluxo_pre5=ice*d_tempo_fluxo2
gen d_ice_fluxo_pre4=ice*d_tempo_fluxo3
gen d_ice_fluxo_pre3=ice*d_tempo_fluxo4
gen d_ice_fluxo_pre2=ice*d_tempo_fluxo5
gen d_ice_fluxo_pre1=ice*d_tempo_fluxo6
gen d_ice_fluxo_inicio=ice*d_tempo_fluxo7
gen d_ice_fluxo_pos1=ice*d_tempo_fluxo8
gen d_ice_fluxo_pos2=ice*d_tempo_fluxo9
gen d_ice_fluxo_pos3=ice*d_tempo_fluxo10
gen d_ice_fluxo_pos4=ice*d_tempo_fluxo11
gen d_ice_fluxo_pos5=ice*d_tempo_fluxo12
gen d_ice_fluxo_pos6=ice*d_tempo_fluxo13

replace d_ice_fluxo_pre6=0 if ice==0
replace d_ice_fluxo_pre5=0 if ice==0
replace d_ice_fluxo_pre4=0 if ice==0
replace d_ice_fluxo_pre3=0 if ice==0
replace d_ice_fluxo_pre2=0 if ice==0
replace d_ice_fluxo_pre1=0 if ice==0
replace d_ice_fluxo_inicio=0 if ice==0
replace d_ice_fluxo_pos1=0 if ice==0
replace d_ice_fluxo_pos2=0 if ice==0
replace d_ice_fluxo_pos3=0 if ice==0
replace d_ice_fluxo_pos4=0 if ice==0
replace d_ice_fluxo_pos5=0 if ice==0
replace d_ice_fluxo_pos6=0 if ice==0


gen d_ice_fluxo_inte_pre6=ice_inte*d_tempo_fluxo1
gen d_ice_fluxo_inte_pre5=ice_inte*d_tempo_fluxo2
gen d_ice_fluxo_inte_pre4=ice_inte*d_tempo_fluxo3
gen d_ice_fluxo_inte_pre3=ice_inte*d_tempo_fluxo4
gen d_ice_fluxo_inte_pre2=ice_inte*d_tempo_fluxo5
gen d_ice_fluxo_inte_pre1=ice_inte*d_tempo_fluxo6
gen d_ice_fluxo_inte_inicio=ice_inte*d_tempo_fluxo7
gen d_ice_fluxo_inte_pos1=ice_inte*d_tempo_fluxo8
gen d_ice_fluxo_inte_pos2=ice_inte*d_tempo_fluxo9
gen d_ice_fluxo_inte_pos3=ice_inte*d_tempo_fluxo10
gen d_ice_fluxo_inte_pos4=ice_inte*d_tempo_fluxo11
gen d_ice_fluxo_inte_pos5=ice_inte*d_tempo_fluxo12
gen d_ice_fluxo_inte_pos6=ice_inte*d_tempo_fluxo13

replace d_ice_fluxo_inte_pre6=0 if ice==0
replace d_ice_fluxo_inte_pre5=0 if ice==0
replace d_ice_fluxo_inte_pre4=0 if ice==0
replace d_ice_fluxo_inte_pre3=0 if ice==0
replace d_ice_fluxo_inte_pre2=0 if ice==0
replace d_ice_fluxo_inte_pre1=0 if ice==0
replace d_ice_fluxo_inte_inicio=0 if ice==0
replace d_ice_fluxo_inte_pos1=0 if ice==0
replace d_ice_fluxo_inte_pos2=0 if ice==0
replace d_ice_fluxo_inte_pos3=0 if ice==0
replace d_ice_fluxo_inte_pos4=0 if ice==0
replace d_ice_fluxo_inte_pos5=0 if ice==0
replace d_ice_fluxo_inte_pos6=0 if ice==0



global nota_todos_anos d_ice_nota_pre6 d_ice_nota_pre5 d_ice_nota_pre4 d_ice_nota_pre3 ///
 d_ice_nota_pre2 d_ice_nota_pre1 d_ice_nota_inicio d_ice_nota_pos1 				///
 d_ice_nota_pos2 d_ice_nota_pos3 d_ice_nota_pos4 d_ice_nota_pos5 d_ice_nota_pos6

global nota_todos_anos_integral d_ice_nota_inte_pre6 d_ice_nota_inte_pre5 				///
d_ice_nota_inte_pre4 d_ice_nota_inte_pre3 d_ice_nota_inte_pre2					///
d_ice_nota_inte_pre1 d_ice_nota_inte_inicio  d_ice_nota_inte_pos1				///
d_ice_nota_inte_pos2 d_ice_nota_inte_pos3 					///
d_ice_nota_inte_pos4 d_ice_nota_inte_pos5 d_ice_nota_inte_pos6					
 
global nota_alguns_anos d_ice_nota_pre3 d_ice_nota_pre2 d_ice_nota_pre1 			///
d_ice_nota_inicio d_ice_nota_pos1 d_ice_nota_pos2 d_ice_nota_pos3 d_ice_nota_pos4 

global nota_alguns_anos_integral d_ice_nota_inte_pre3 d_ice_nota_inte_pre2 ///
d_ice_nota_inte_pre1 d_ice_nota_inte_inicio  d_ice_nota_inte_pos1 ///
d_ice_nota_inte_pos2 d_ice_nota_inte_pos3 d_ice_nota_inte_pos4

global fluxo_todos_anos d_ice_fluxo_pre6 d_ice_fluxo_pre5 d_ice_fluxo_pre4 ///
d_ice_fluxo_pre3 d_ice_fluxo_pre2 d_ice_fluxo_pre1 d_ice_fluxo_inicio ///
d_ice_fluxo_pos1 d_ice_fluxo_pos2 d_ice_fluxo_pos3 d_ice_fluxo_pos4  d_ice_fluxo_pos5

global fluxo_todos_anos_integral d_ice_fluxo_inte_pre6 d_ice_fluxo_inte_pre5 ///
d_ice_fluxo_inte_pre4 d_ice_fluxo_inte_pre3 d_ice_fluxo_inte_pre2 ///
d_ice_fluxo_inte_pre1 d_ice_fluxo_inte_inicio d_ice_fluxo_inte_pos1 ///
d_ice_fluxo_inte_pos2 d_ice_fluxo_inte_pos3 d_ice_fluxo_inte_pos4 d_ice_fluxo_inte_pos5

global fluxo_alguns_anos d_ice_fluxo_pre3 d_ice_fluxo_pre2 d_ice_fluxo_pre1 d_ice_fluxo_inicio ///
d_ice_fluxo_pos1 d_ice_fluxo_pos2 d_ice_fluxo_pos3 d_ice_fluxo_pos4

global fluxo_alguns_anos_integral  d_ice_fluxo_inte_pre3 d_ice_fluxo_inte_pre2 ///
d_ice_fluxo_inte_pre1 d_ice_fluxo_inte_inicio d_ice_fluxo_inte_pos1 ///
d_ice_fluxo_inte_pos2 d_ice_fluxo_inte_pos3 d_ice_fluxo_inte_pos4 

xtset codigo_escola ano

*notas
*enem_nota_objetivab_std

xtreg  enem_nota_objetivab_std  $nota_alguns_anos /// $nota_todos_anos_integral ///
	d_ano* $controles  if (d_dep4 == 0 | ice == 1)  , fe cluster(codigo_uf)
outreg2 using "$output/em_diff_in_diff_cum_par_cen_esc.xls", excel replace label ctitle(enem objetiva, cumulativo alguns , fe cluster uf)  


xtreg  enem_nota_objetivab_std  $nota_alguns_anos /// $nota_todos_anos_integral ///
	d_ano* $controles if (d_dep4 == 0 | ice == 1) , fe cluster(cod_meso)
outreg2 using "$output/em_diff_in_diff_cum_par_cen_esc.xls", excel append label ctitle(enem objetiva,  cumulativo alguns, fe cluster meso)


*enem_nota_matematica_std enem_nota_redacao_std
foreach x in "enem_nota_matematica_std" "enem_nota_redacao_std" {
xtreg  `x'  $nota_alguns_anos /// $nota_todos_anos_integral ///
	d_ano* $controles  if (d_dep4 == 0 | ice == 1)  , fe cluster(codigo_uf)
outreg2 using "$output/em_diff_in_diff_cum_par_cen_esc.xls", excel append label ctitle(`x', cumulativo alguns, fe cluster uf) 

xtreg  `x'  $nota_alguns_anos /// $nota_todos_anos_integral ///
	d_ano* $controles if (d_dep4 == 0 | ice == 1) , fe cluster(cod_meso)
outreg2 using "$output/em_diff_in_diff_cum_par_cen_esc.xls", excel append label ctitle(`x',  cumulativo alguns, fe cluster meso) 

}

*fluxo
*apr_em_std
xtreg  apr_em_std  $fluxo_alguns_anos ///$fluxo_todos_anos_integral ///
	d_ano* $controles if (d_dep4 == 0 | ice == 1)   , fe cluster(codigo_uf)
outreg2 using "$output/em_diff_in_diff_cum_par_cen_esc_flux.xls", excel replace label ctitle(apr_em_std, cumulativo alguns, fe cluster uf)

xtreg  apr_em_std  $fluxo_alguns_anos /// $fluxo_todos_anos_integral ///
	d_ano* $controles if (d_dep4 == 0 | ice == 1) , fe cluster(cod_meso)
outreg2 using "$output/em_diff_in_diff_cum_par_cen_esc_flux.xls", excel append label ctitle(apr_em_std,  cumulativo alguns, fe cluster meso )

*rep_em_std aba_em_std dist_em_std
foreach x in "rep_em_std" "aba_em_std" "dist_em_std"   {
xtreg  `x'  $fluxo_alguns_anos ///$fluxo_todos_anos_integral ///
	d_ano* $controles  if (d_dep4 == 0 | ice == 1)  , fe cluster(codigo_uf)
outreg2 using "$output/em_diff_in_diff_cum_par_cen_esc_flux.xls", excel append label ctitle(`x', cumulativo alguns, fe cluster uf) 

xtreg  `x'  $fluxo_alguns_anos /// $nota_todos_anos_integral ///
	d_ano* $controles if (d_dep4 == 0 | ice == 1) , fe cluster(cod_meso)
outreg2 using "$output/em_diff_in_diff_cum_par_cen_esc_flux.xls", excel append label ctitle(`x',  cumulativo alguns, fe cluster meso) 

}
