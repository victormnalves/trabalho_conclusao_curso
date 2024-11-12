*enem público cumulativo
capture log close
clear all
set more off


global user "`:environment USERPROFILE'"
global Folder "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"
global output "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\resultados_v3"
global Bases "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"
global dofiles "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\Do-Files"
global Logfolder "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\logfiles"



global folderservidor "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"

log using "$Logfolder/em_publica_cumulativa_14092018.log", replace

use "$folderservidor\em_com_censo_escolar_14.dta", clear
by codigo_escola, sort: gen n_codigo_escola = _n == 1
gen n_observac = 1
count if n_codigo_escola

count if n_observac


replace ice=0 if ice ==.
drop if dep ==4

count if n_codigo_escola
count if n_observac


global estado d_uf*


global alavancas_fluxo d_ice_fluxo_al1 d_ice_fluxo_al2 d_ice_fluxo_al3 d_ice_fluxo_al4 d_ice_fluxo_al5 d_ice_fluxo_al6 d_ice_fluxo_al7 d_ice_fluxo_al8 
global alavancas_fluxo_todas d_ice_fluxo_al1 d_ice_fluxo_al2 d_ice_fluxo_al3 d_ice_fluxo_al4 d_ice_fluxo_al5 d_ice_fluxo_al6 d_ice_fluxo_al7 d_ice_fluxo_al8 d_ice_fluxo_al9
global alavancas_nota d_ice_nota_al1 d_ice_nota_al2 d_ice_nota_al3 d_ice_nota_al4 d_ice_nota_al5 d_ice_nota_al6 d_ice_nota_al7 d_ice_nota_al8 
global alavancas_nota_todas d_ice_nota_al1 d_ice_nota_al2 d_ice_nota_al3 d_ice_nota_al4 d_ice_nota_al5 d_ice_nota_al6 d_ice_nota_al7 d_ice_nota_al8 d_ice_nota_al9

global outcomes apr_em_std rep_em_std aba_em_std dist_em_std ///
enem_nota_matematica_std  enem_nota_ciencias_std /// 
enem_nota_humanas_std enem_nota_linguagens_std  ///
enem_nota_redacao_std enem_nota_objetivab_std  ///

global controles  concluir_em_ano_enem e_mora_mais_de_6_pessoas e_escol_sup_pai	///
	e_escol_sup_mae e_renda_familia_5_salarios e_trabalhou_ou_procurou predio 	///
	diretoria sala_professores lab_info lab_ciencias quadra_esportes internet 	///
	rural lixo_coleta eletricidade agua esgoto n_salas_utilizadas				///
	n_alunos_em_ep pib_capita_reais_real_2015 pop mais_educ 

global controles_pscore  concluir_em_ano_enem e_mora_mais_de_6_pessoas e_escol_sup_pai	///
	e_escol_sup_mae e_renda_familia_5_salarios e_trabalhou_ou_procurou predio 	///
	diretoria sala_professores lab_info lab_ciencias quadra_esportes internet		 ///
	rural lixo_coleta eletricidade agua  esgoto n_salas_utilizadas					///
	n_alunos_em_ep pib_capita_reais_real_2015 pop mais_educ /*taxa_participacao_enem*/

	/// tirando taxa de participação do enem pois há muitos missings e não é significativo no probit
global outros  n_codigo_escola n_observac


keep $estado $alavancas_fluxo $alavancas_fluxo_todas $alavancas_nota_todas ///
$controles  $outros ///
ice ice_inte codigo_escola ano ano_ice taxa_participacao_enem ///
codigo_uf dep cod_meso /// 
apr_em_std rep_em_std aba_em_std dist_em_std ///
enem_nota_matematica_std  enem_nota_ciencias_std /// 
enem_nota_humanas_std enem_nota_linguagens_std  ///
enem_nota_redacao_std enem_nota_objetivab_std  ///
d_ice_nota d_ano* d_ice_nota_inte ///
d_ice_fluxo d_ice_fluxo_inte
 	
	
foreach x in $controles {
drop if `x'==.

}
	
count if n_codigo_escola
count if n_observac




****************************************************************************************************************************************************************************************************************
****************************************************************************************************************************************************************************************************************
****************************************************************************************************************************************************************************************************************
****************************************************************************************************************************************************************************************************************
*calculando propensity score
*calcular dentro de cada ano
* atribuir um propensity score por cada escola, que vai ser definido como o propensity score do primeiro ano que a escola apareceu na base

/*
nas análises anterior, eu estava calculando o propensity score somente para 2003. No entano, escolas presentes no censo escolar ou no enem 
Xsomente nos anos subsequentes não estavam entrando para a análise
*/
set matsize 10000
gen pscore_total=.
forvalues x=2003(1)2015{
pscore ice $controles_pscore  if ano == `x', pscore(pscores_todos_`x')
replace pscore_total = 1 /(1-pscores_todos_`x') if ice==0& pscores_todos_`x'!=.

}

sort codigo_escola ano


replace pscore_total = 1 if ice == 1

/* 
aqui, no xtreg, o propensity para cada escola deve ser constante ao longo do tmepo. 
o algoritmo abaixo atribui o propensity score mais antigo da escola a propria escola
*/
bysort codigo_escola: egen ano_aux = min(ano)
gen pscore_total_aux=.
replace pscore_total_aux = pscore_total if ano_aux ==ano

bysort codigo_escola: egen pscore_total_aux_2 = max(pscore_total_aux)

replace pscore_total = pscore_total_aux_2

****************************************************************************************************************************************************************************************************************
****************************************************************************************************************************************************************************************************************
****************************************************************************************************************************************************************************************************************
****************************************************************************************************************************************************************************************************************
/*
agora, vamos calcular o efeito cumulativo
para tal, precisamos de dummies que indiquem anos pré e pos tratamento
será uma análise de painel, usando como variável dependente as notas e as variáveis de fluxo
e como independetes controles da escola $controle, dummies de ano e efeito fixo em escola,
fazendo cluster em estado
depois disso, estimar a regressão com e sem propensity score
sem e com interação 
*/

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

*gerando as dummies de tempo

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

*gerando as dummies nota 

gen d_ice_nota_pre6=d_tempo_nota1
gen d_ice_nota_pre5=d_tempo_nota2
gen d_ice_nota_pre4=d_tempo_nota3
gen d_ice_nota_pre3=d_tempo_nota4
gen d_ice_nota_pre2=d_tempo_nota5
gen d_ice_nota_pre1=d_tempo_nota6
gen d_ice_nota_inicio=d_tempo_nota7
gen d_ice_nota_pos1=d_tempo_nota8
gen d_ice_nota_pos2=d_tempo_nota9
gen d_ice_nota_pos3=d_tempo_nota10
gen d_ice_nota_pos4=d_tempo_nota11
gen d_ice_nota_pos5=d_tempo_nota12
gen d_ice_nota_pos6=d_tempo_nota13


/*

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
*/

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

gen d_ice_fluxo_pre6=d_tempo_fluxo1
gen d_ice_fluxo_pre5=d_tempo_fluxo2
gen d_ice_fluxo_pre4=d_tempo_fluxo3
gen d_ice_fluxo_pre3=d_tempo_fluxo4
gen d_ice_fluxo_pre2=d_tempo_fluxo5
gen d_ice_fluxo_pre1=d_tempo_fluxo6
gen d_ice_fluxo_inicio=d_tempo_fluxo7
gen d_ice_fluxo_pos1=d_tempo_fluxo8
gen d_ice_fluxo_pos2=d_tempo_fluxo9
gen d_ice_fluxo_pos3=d_tempo_fluxo10
gen d_ice_fluxo_pos4=d_tempo_fluxo11
gen d_ice_fluxo_pos5=d_tempo_fluxo12
gen d_ice_fluxo_pos6=d_tempo_fluxo13
/*
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
*/
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

xtreg  enem_nota_objetivab_std  $nota_todos_anos $nota_todos_anos_integral ///
	d_ano* $controles    , fe cluster(codigo_uf)
outreg2 using "$output/em_publica_cumulativa_nota_fe_14092018.xls", excel replace label ctitle(enem objetiva, cumulativo todos integral, fe cluster uf)  

xtreg  enem_nota_objetivab_std  $nota_todos_anos /// $nota_todos_anos_integral ///
	d_ano* $controles  , fe cluster(codigo_uf)
outreg2 using "$output/em_publica_cumulativa_nota_fe_14092018.xls", excel append label ctitle(enem objetiva,  cumulativo todos, fe cluster uf)

xtreg  enem_nota_objetivab_std  $nota_todos_anos $nota_todos_anos_integral ///
	d_ano* $controles [pw=pscore_total]   , fe cluster(codigo_uf)
outreg2 using "$output/em_publica_cumulativa_nota_fe_14092018.xls", excel append label ctitle(enem objetiva, cumulativo todos integral, fe cluster uf ps) 

xtreg  enem_nota_objetivab_std  $nota_todos_anos /// $nota_todos_anos_integral ///
	d_ano* $controles [pw=pscore_total] , fe cluster(codigo_uf)
outreg2 using "$output/em_publica_cumulativa_nota_fe_14092018.xls", excel append label ctitle(enem objetiva,  cumulativo todos, fe cluster uf ps) 

*enem_nota_matematica_std enem_nota_redacao_std
foreach x in "enem_nota_matematica_std" "enem_nota_redacao_std" {
xtreg  `x'  $nota_todos_anos $nota_todos_anos_integral ///
	d_ano* $controles    , fe cluster(codigo_uf)
outreg2 using "$output/em_publica_cumulativa_nota_fe_14092018.xls", excel append label ctitle(`x', cumulativo todos integral, fe cluster uf) 

xtreg  `x'  $nota_todos_anos /// $nota_todos_anos_integral ///
	d_ano* $controles  , fe cluster(codigo_uf)
outreg2 using "$output/em_publica_cumulativa_nota_fe_14092018.xls", excel append label ctitle(`x',  cumulativo todos, fe cluster uf) 

xtreg  `x'  $nota_todos_anos $nota_todos_anos_integral ///
	d_ano* $controles [pw=pscore_total]   , fe cluster(codigo_uf)
outreg2 using "$output/em_publica_cumulativa_nota_fe_14092018.xls", excel append label ctitle(`x', cumulativo todos integral, fe cluster uf ps) 

xtreg  `x'  $nota_todos_anos /// $nota_todos_anos_integral ///
	d_ano* $controles [pw=pscore_total] , fe cluster(codigo_uf)
outreg2 using "$output/em_publica_cumulativa_nota_fe_14092018.xls", excel append label ctitle(`x',  cumulativo todos, fe cluster uf ps) 

}

*fluxo
*apr_em_std
xtreg  apr_em_std  $fluxo_todos_anos $fluxo_todos_anos_integral ///
	d_ano* $controles    , fe cluster(codigo_uf)
outreg2 using "$output/em_publica_cumulativa_fluxo_fe_14092018.xls", excel replace label ctitle(apr_em_std, cumulativo todos integral, fe cluster uf)

xtreg  apr_em_std  $fluxo_todos_anos /// $fluxo_todos_anos_integral ///
	d_ano* $controles  , fe cluster(codigo_uf)
outreg2 using "$output/em_publica_cumulativa_fluxo_fe_14092018.xls", excel append label ctitle(apr_em_std,  cumulativo todos, fe cluster uf )

xtreg  apr_em_std  $fluxo_todos_anos $fluxo_todos_anos_integral ///
	d_ano* $controles [pw=pscore_total]   , fe cluster(codigo_uf)
outreg2 using "$output/em_publica_cumulativa_fluxo_fe_14092018.xls", excel append label ctitle(apr_em_std, cumulativo todos integral, fe cluster uf ps) 

xtreg  apr_em_std  $fluxo_todos_anos /// $fluxo_todos_anos_integral ///
	d_ano* $controles [pw=pscore_total] , fe cluster(codigo_uf)
outreg2 using "$output/em_publica_cumulativa_fluxo_fe_14092018.xls", excel append label ctitle(apr_em_std,  cumulativo todos, fe cluster uf ps) 

*rep_em_std aba_em_std dist_em_std
foreach x in "rep_em_std" "aba_em_std" "dist_em_std"   {
xtreg  `x'  $fluxo_todos_anos $fluxo_todos_anos_integral ///
	d_ano* $controles    , fe cluster(codigo_uf)
outreg2 using "$output/em_publica_cumulativa_fluxo_fe_14092018.xls", excel append label ctitle(`x', cumulativo todos integral, fe cluster uf) 

xtreg  `x'  $fluxo_todos_anos /// $nota_todos_anos_integral ///
	d_ano* $controles  , fe cluster(codigo_uf)
outreg2 using "$output/em_publica_cumulativa_fluxo_fe_14092018.xls", excel append label ctitle(`x',  cumulativo todos, fe cluster uf) 

xtreg  `x'  $fluxo_todos_anos $fluxo_todos_anos_integral ///
	d_ano* $controles [pw=pscore_total]   , fe cluster(codigo_uf)
outreg2 using "$output/em_publica_cumulativa_fluxo_fe_14092018.xls", excel append label ctitle(`x', cumulativo todos integral, fe cluster uf ps) 

xtreg  `x'  $fluxo_todos_anos /// $fluxo_todos_anos_integral ///
	d_ano* $controles [pw=pscore_total] , fe cluster(codigo_uf)
outreg2 using "$output/em_publica_cumulativa_fluxo_fe_14092018.xls", excel append label ctitle(`x',  cumulativo todos, fe cluster uf ps) 
}




reg  enem_nota_objetivab_std  $nota_todos_anos $nota_todos_anos_integral ///
	d_ano* $controles   $estado    ,  cluster(codigo_uf)
outreg2 using "$output/em_publica_cumulativa_nota_14092018.xls", excel replace label ctitle(enem objetiva, cumulativo todos integral,  cluster uf) 

reg  enem_nota_objetivab_std  $nota_todos_anos /// $nota_todos_anos_integral ///
	d_ano* $controles  $estado  ,  cluster(codigo_uf)
outreg2 using "$output/em_publica_cumulativa_nota_14092018.xls", excel append label ctitle(enem objetiva,  cumulativo todos, cluster uf)


reg  enem_nota_objetivab_std  $nota_todos_anos $nota_todos_anos_integral ///
	d_ano* $controles  $estado  [pw=pscore_total]   , cluster(codigo_uf)
outreg2 using "$output/em_publica_cumulativa_nota_14092018.xls", excel append label ctitle(enem objetiva, cumulativo todos integral,  cluster uf ps) 

reg  enem_nota_objetivab_std  $nota_todos_anos /// $nota_todos_anos_integral ///
	d_ano* $controles  $estado  [pw=pscore_total] ,  cluster(codigo_uf)
outreg2 using "$output/em_publica_cumulativa_nota_fe_14092018.xls", excel append label ctitle(enem objetiva,  cumulativo todos, cluster uf ps) 

*enem_nota_matematica_std enem_nota_redacao_std
foreach x in "enem_nota_matematica_std" "enem_nota_redacao_std" {
reg  `x'  $nota_todos_anos $nota_todos_anos_integral ///
	d_ano* $controles  $estado   ,  cluster(codigo_uf)
outreg2 using "$output/em_publica_cumulativa_nota_14092018.xls", excel append label ctitle(`x', cumulativo todos integral,  cluster uf) 

reg  `x'  $nota_todos_anos /// $nota_todos_anos_integral ///
	d_ano* $controles $estado  ,  cluster(codigo_uf)
outreg2 using "$output/em_publica_cumulativa_nota_14092018.xls", excel append label ctitle(`x',  cumulativo todos,  cluster uf) 

reg  `x'  $nota_todos_anos $nota_todos_anos_integral ///
	d_ano* $controles $estado  [pw=pscore_total]   ,  cluster(codigo_uf)
outreg2 using "$output/em_publica_cumulativa_nota_14092018.xls", excel append label ctitle(`x', cumulativo todos integral,  cluster uf ps) 

reg  `x'  $nota_todos_anos /// $nota_todos_anos_integral ///
	d_ano* $controles $estado [pw=pscore_total] ,  cluster(codigo_uf)
outreg2 using "$output/em_publica_cumulativa_nota_14092018.xls", excel append label ctitle(`x',  cumulativo todos,  cluster uf ps) 

}
*fluxo
*apr_em_std
reg  apr_em_std  $fluxo_todos_anos $fluxo_todos_anos_integral ///
	d_ano* $controles  $estado  ,  cluster(codigo_uf)
outreg2 using "$output/em_publica_cumulativa_fluxo_14092018.xls", excel replace label ctitle(apr_em_std, cumulativo todos integral,  cluster uf)

reg  apr_em_std  $fluxo_todos_anos /// $fluxo_todos_anos_integral ///
	d_ano* $controles $estado ,  cluster(codigo_uf)
outreg2 using "$output/em_publica_cumulativa_fluxo_14092018.xls", excel append label ctitle(apr_em_std,  cumulativo todos,  cluster uf )

reg  apr_em_std  $fluxo_todos_anos $fluxo_todos_anos_integral ///
	d_ano* $controles $estado [pw=pscore_total]   ,  cluster(codigo_uf)
outreg2 using "$output/em_publica_cumulativa_fluxo_14092018.xls", excel append label ctitle(apr_em_std, cumulativo todos integral,  cluster uf ps) 

reg  apr_em_std  $fluxo_todos_anos /// $fluxo_todos_anos_integral ///
	d_ano* $controles  $estado [pw=pscore_total] ,  cluster(codigo_uf)
outreg2 using "$output/em_publica_cumulativa_fluxo_14092018.xls", excel append label ctitle(apr_em_std,  cumulativo todos,  cluster uf ps) 

*rep_em_std aba_em_std dist_em_std
foreach x in "rep_em_std" "aba_em_std" "dist_em_std"   {

reg  `x'  $fluxo_todos_anos $fluxo_todos_anos_integral ///
	d_ano* $controles  $estado  ,  cluster(codigo_uf)
outreg2 using "$output/em_publica_cumulativa_fluxo_14092018.xls", excel append label ctitle(`x', cumulativo todos integral,  cluster uf)

reg  `x'  $fluxo_todos_anos /// $fluxo_todos_anos_integral ///
	d_ano* $controles $estado ,  cluster(codigo_uf)
outreg2 using "$output/em_publica_cumulativa_fluxo_14092018.xls", excel append label ctitle(`x',  cumulativo todos,  cluster uf )

reg  `x'  $fluxo_todos_anos $fluxo_todos_anos_integral ///
	d_ano* $controles $estado [pw=pscore_total]   ,  cluster(codigo_uf)
outreg2 using "$output/em_publica_cumulativa_fluxo_14092018.xls", excel append label ctitle(`x', cumulativo todos integral,  cluster uf ps) 

reg  `x'  $fluxo_todos_anos /// $fluxo_todos_anos_integral ///
	d_ano* $controles  $estado [pw=pscore_total] ,  cluster(codigo_uf)
outreg2 using "$output/em_publica_cumulativa_fluxo_14092018.xls", excel append label ctitle(`x',  cumulativo todos,  cluster uf ps) 
}
log close
