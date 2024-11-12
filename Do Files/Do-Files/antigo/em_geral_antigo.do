/*cumulativo antigo*/




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
global output "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\resultados_v3\em_antigo"
global Bases "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"
global dofiles "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\Do-Files"
global Logfolder "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\logfiles"


global folderservidor "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"



log using "$Logfolder/em_antigo.log", replace

use "$Bases/bases da análise anterior/ice_clean_fluxo.dta", clear
forvalues a=2004(1)2015{
gen ice_nota_`a' = ice_`a'
replace ice_nota_`a'=0 if (ano>`a'-2&ano<=`a')&(uf=="PE"|uf=="CE")&ensino_fundamental==0 


}

forvalues a=2004(1)2015{
gen ice_fluxo_`a' = ice_`a'
}
forvalues a=2004(1)2015{

replace ice_nota_`a'=0 if ice_nota_`a' ==.
replace ice_fluxo_`a'=0 if ice_fluxo_`a' ==.
}


*gerando dummy de participação do programa

gen d_ice_fluxo=0
gen d_ice_nota=0
	forvalues x=2004(1)2015{
	replace d_ice_fluxo=1 if ice_fluxo_`x'==1 &ano==`x' 
	replace d_ice_nota=1 if ice_nota_`x'==1 &ano==`x'
	}

/*dummy ice integral*/
*variávei que indica se escola em um dado ano  participou do ICE integral
gen ice_inte=0
replace ice_inte=1 if ice_jornada=="INTEGRAL" 
replace ice_inte=1 if ice_jornada=="Integral" 

/*dummy ice semi-integral*/
*variávei que indica se escola em um dado ano participou do ICE semi-integral
gen ice_semi_inte=0
replace ice_semi_inte=1 if ice_jornada=="Semi-integral"
replace ice_semi_inte=1 if ice_jornada=="SEMI-INTEGRAL"

tab ice_segmento, gen(d_segmento)
* note que existem escolars que tem ensino médio, mas só receberam o programa no ensino fundamental
* então, para avaliar o impacto do programa na nota do enem, precisamos atribuir zero para as
* as escolas que tem somente EF
replace ice = 0 if d_segmento1==1 | d_segmento3==1
replace d_ice_fluxo = 0 if d_segmento1==1 | d_segmento3==1 
replace d_ice_nota = 0 if d_segmento1==1 | d_segmento3==1

*gerando dummy de segmento

forvalues x=2004(1)2015{
replace ice_fluxo_`x'=0 if d_segmento1==1 | d_segmento3==1 
replace ice_nota_`x'=0 if d_segmento1==1 | d_segmento3==1 
}
/*dummy interação ice e integral*/
*variável que indica se escola em um dado ano entrou no programa
*na modalidade integral
gen d_ice_fluxo_inte=d_ice_fluxo*ice_inte
gen d_ice_nota_inte=d_ice_nota*ice_inte
/*dummy interação ice e semi-integral*/
*variável que indica se escola em um dado ano entrou no programa
*na modalidade semi-integral
gen d_ice_fluxo_semi_inte=d_ice_fluxo*ice_semi_inte
gen d_ice_nota_semi_inte=d_ice_nota*ice_semi_inte



gen al_outros=0
replace al_outros=1 if (al_engaj_gov==1|al_time_seduc==1|al_marcos_lei==1|al_proj_vida==1)

*teve bom engajamento do governador
gen d_ice_nota_al1=d_ice_nota*al_engaj_gov
gen d_ice_fluxo_al1=d_ice_fluxo*al_engaj_gov

*teve bom engajamento do secretário de educação
gen d_ice_nota_al2=d_ice_nota*al_engaj_sec
gen d_ice_fluxo_al2=d_ice_fluxo*al_engaj_sec

*tinha time da SEDUC deducado para a implantação do programa
gen d_ice_nota_al3=d_ice_nota*al_time_seduc
gen d_ice_fluxo_al3=d_ice_fluxo*al_time_seduc

*teve implantação dos marcos legais na forma da Lei?
gen d_ice_nota_al4=d_ice_nota*al_marcos_lei
gen d_ice_fluxo_al4=d_ice_fluxo*al_marcos_lei

*teve Implantação de todos os marcos legais previstos no cronograma estipulado?
gen d_ice_nota_al5=d_ice_nota*al_todos_marcos
gen d_ice_fluxo_al5=d_ice_fluxo*al_todos_marcos


*teve Implantação do processo de seleção e remoção de diretores?
gen d_ice_nota_al6=d_ice_nota*al_sel_dir
gen d_ice_fluxo_al6=d_ice_fluxo*al_sel_dir

*teve Implantação do processo de seleção e remoção de professores?
gen d_ice_nota_al7=d_ice_nota*al_sel_prof
gen d_ice_fluxo_al7=d_ice_fluxo*al_sel_prof

*teve Implantação do projeto de vida na Matriz Curricular?
gen d_ice_nota_al8=d_ice_nota*al_proj_vida
gen d_ice_fluxo_al8=d_ice_fluxo*al_proj_vida

gen d_ice_nota_al9=d_ice_nota*al_outros
gen d_ice_fluxo_al9=d_ice_fluxo*al_outros


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

local controles_pscore  concluir_em_ano_enem e_mora_mais_de_6_pessoas e_escol_sup_pai	///
	e_escol_sup_mae e_renda_familia_5_salarios  predio 	///
	diretoria sala_professores lab_info lab_ciencias quadra_esportes internet		 ///
	rural lixo_coleta eletricidade agua  esgoto n_salas_utilizadas					///
	n_alunos_em_ep  
//mdesc `controles_pscore' taxa_participacao_enem if ano ==2003

local estado d_uf*

local alavancas_fluxo d_ice_fluxo_al1 d_ice_fluxo_al2 d_ice_fluxo_al3 d_ice_fluxo_al4 d_ice_fluxo_al5 d_ice_fluxo_al6 d_ice_fluxo_al7 d_ice_fluxo_al8 
local alavancas_fluxo_todas d_ice_fluxo_al1 d_ice_fluxo_al2 d_ice_fluxo_al3 d_ice_fluxo_al4 d_ice_fluxo_al5 d_ice_fluxo_al6 d_ice_fluxo_al7 d_ice_fluxo_al8 d_ice_fluxo_al9
local alavancas_nota d_ice_nota_al1 d_ice_nota_al2 d_ice_nota_al3 d_ice_nota_al4 d_ice_nota_al5 d_ice_nota_al6 d_ice_nota_al7 d_ice_nota_al8 
local alavancas_nota_todas d_ice_nota_al1 d_ice_nota_al2 d_ice_nota_al3 d_ice_nota_al4 d_ice_nota_al5 d_ice_nota_al6 d_ice_nota_al7 d_ice_nota_al8 d_ice_nota_al9


pscore ice `controles_pscore' taxa_participacao_enem if ano == 2003, pscore(pscores_todos)

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
/*
bysort codigo_escola: egen pscore_total_estado_aux = max(pscore_total_estado)
replace pscore_total_estado = pscore_total_estado_aux
*/
/*
In -xt- analyses, the weight must be constant within panels
o pscore_total será usado como peso weight no xtreg 
*/

/*
apr_em_std rep_em_std aba_em_std dist_em_std 
enem_nota_matematica_std  enem_nota_ciencias_std 
enem_nota_humanas_std enem_nota_linguagens_std 
enem_nota_redacao_std enem_nota_objetivab_std
*/



local controles  concluir_em_ano_enem e_mora_mais_de_6_pessoas e_escol_sup_pai	///
	e_escol_sup_mae e_renda_familia_5_salarios  predio 	///
	diretoria sala_professores lab_info lab_ciencias quadra_esportes internet 	///
	rural lixo_coleta eletricidade agua esgoto n_salas_utilizadas				///
	n_alunos_em_ep  


local estado d_uf*

local alavancas_fluxo d_ice_fluxo_al1 d_ice_fluxo_al2 d_ice_fluxo_al3 d_ice_fluxo_al4 d_ice_fluxo_al5 d_ice_fluxo_al6 d_ice_fluxo_al7 d_ice_fluxo_al8 
local alavancas_fluxo_todas d_ice_fluxo_al1 d_ice_fluxo_al2 d_ice_fluxo_al3 d_ice_fluxo_al4 d_ice_fluxo_al5 d_ice_fluxo_al6 d_ice_fluxo_al7 d_ice_fluxo_al8 d_ice_fluxo_al9
local alavancas_nota d_ice_nota_al1 d_ice_nota_al2 d_ice_nota_al3 d_ice_nota_al4 d_ice_nota_al5 d_ice_nota_al6 d_ice_nota_al7 d_ice_nota_al8 
local alavancas_nota_todas d_ice_nota_al1 d_ice_nota_al2 d_ice_nota_al3 d_ice_nota_al4 d_ice_nota_al5 d_ice_nota_al6 d_ice_nota_al7 d_ice_nota_al8 d_ice_nota_al9

*primeiro, nas notas
*enem_nota_objetivab_std


xtreg enem_nota_objetivab_std d_ice_nota d_ano* `controles' `estado' [pw=pscore_total] , fe rob
outreg2 using "$output/ICE_em_ps_todos_estados_obj_2.xls", excel  replace label ctitle(enem objetiva, fe rob ps)

/*
xtreg enem_nota_objetivab_std d_ice_nota d_ano* `controles' `estado' [pw=pscore_total], fe cluster(cod_meso)
outreg2 using "$output/ICE_em_ps_todos_estados_obj_2.xls", excel append label ctitle(enem objetiva, fe cluster ps mesoregião)

xtreg enem_nota_objetivab_std d_ice_nota  d_ano* `controles' `estado' `alavancas_nota' [pw=pscore_total], fe cluster(cod_meso)
outreg2 using "$output/ICE_em_ps_todos_estados_obj_2.xls", excel append label ctitle(enem objetiva, fe cluster ps estado)

xtreg enem_nota_objetivab_std d_ice_nota d_ano* `controles' `estado' if dep!=4 [pw=pscore_total], fe cluster(cod_meso)
outreg2 using "$output/ICE_em_ps_todos_estados_obj_2.xls", excel append label ctitle(enem objetiva, fe cluster ps mesoregião)
*/

xtreg enem_nota_objetivab_std d_ice_nota d_ano* `controles' `estado' [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_obj_2.xls", excel append label ctitle(enem objetiva, fe cluster estado ps)

xtreg enem_nota_objetivab_std d_ice_nota d_ice_nota_inte d_ano* `controles' `estado' [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_obj_2.xls", excel append label ctitle(enem objetiva, fe cluster estado ps, integral)

xtreg enem_nota_objetivab_std d_ice_nota d_ice_nota_semi_inte d_ano* `controles' `estado' [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_obj_2.xls", excel append label ctitle(enem objetiva, fe cluster estado ps, semi integral)


xtreg enem_nota_objetivab_std d_ice_nota d_ano* `controles' `estado' `alavancas_nota' [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_obj_2.xls", excel append label ctitle(enem objetiva, fe cluster estado ps, alavancas)

xtreg enem_nota_objetivab_std d_ice_nota d_ano* `controles' `estado' `alavancas_nota_todas' [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_obj_2.xls", excel append label ctitle(enem objetiva, fe cluster estado ps, alavancas todas)

xtreg enem_nota_objetivab_std d_ice_nota d_ano* `controles' `estado' [pw=pscore_total] if dep!=4 , fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_obj_2.xls", excel append label ctitle(enem objetiva, fe cluster estado ps, publicas)

*enem_nota_matematica_std


xtreg enem_nota_matematica_std d_ice_nota d_ano* `controles' `estado' [pw=pscore_total], fe rob
outreg2 using "$output/ICE_em_ps_todos_estados_mat_2.xls", excel  replace label ctitle(matematica, fe rob ps)
/*
xtreg enem_nota_matematica_std d_ice_nota d_ano* d_rigor* d_segmento* `controles' `estado' [pw=pscore_total], fe cluster(cod_meso)
outreg2 using "$output/ICE_em_ps_todos_estados_mat_2.xls", excel append label ctitle(matematica, fe cluster mesoregião ps)

xtreg enem_nota_matematica_std d_ice_nota d_ano* `controles' `estado' `alavancas_nota'  [pw=pscore_total], fe cluster(cod_meso)
outreg2 using "$output/ICE_em_ps_todos_estados_mat_2.xls", excel append label ctitle(matematica, fe cluster estado ps)

xtreg enem_nota_matematica_std d_ice_nota d_ano* `controles' `estado' if dep!=4  [pw=pscore_total], fe cluster(cod_meso)
outreg2 using "$output/ICE_em_ps_todos_estados_mat_2.xls", excel append label ctitle(matematica, fe cluster mesoregião ps)
*/
xtreg enem_nota_matematica_std d_ice_nota d_ano* `controles' `estado' [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_mat_2.xls", excel append label ctitle(matematica, fe cluster estado ps)

xtreg enem_nota_matematica_std d_ice_nota d_ice_nota_inte d_ano* `controles' `estado' [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_mat_2.xls", excel append label ctitle(matematica, fe cluster estado ps, integral )


xtreg enem_nota_matematica_std d_ice_nota d_ice_nota_semi_inte d_ano* `controles' `estado' [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_mat_2.xls", excel append label ctitle(matematica, fe cluster estado ps,semi integral )

xtreg enem_nota_matematica_std d_ice_nota d_ano* `controles' `estado' `alavancas_nota'  [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_mat_2.xls", excel append label ctitle(matematica, fe cluster estado ps, alavancas)

xtreg enem_nota_matematica_std d_ice_nota d_ano* `controles' `estado' `alavancas_nota_todas' [pw=pscore_total] , fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_mat_2.xls", excel append label ctitle(matematica, fe cluster estado ps, alavancas todas)

xtreg enem_nota_matematica_std d_ice_nota d_ano* `controles' `estado'  [pw=pscore_total] if dep!=4 , fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_mat_2.xls", excel append label ctitle(matematica, fe cluster estado ps, publicas)

*enem_nota_redacao_std


xtreg enem_nota_redacao_std d_ice_nota d_ano* `controles' `estado' [pw=pscore_total], fe rob
outreg2 using "$output/ICE_em_ps_todos_estados_redacao_2.xls", excel replace label ctitle(redacao, fe rob ps)
/*
xtreg enem_nota_redacao_std d_ice_nota d_ano*  `controles' `estado' [pw=pscore_total], fe cluster(cod_meso)
outreg2 using "$output/ICE_em_ps_todos_estados_redacao_2.xls", excel append label ctitle(redacao, fe cluster mesoregião ps)

xtreg enem_nota_redacao_std d_ice_nota d_ano* `controles' `estado' `alavancas_nota' [pw=pscore_total], fe cluster(cod_meso)
outreg2 using "$output/ICE_em_ps_todos_estados_redacao_2.xls", excel append label ctitle(redacao, fe cluster estado ps)

xtreg enem_nota_redacao_std d_ice_nota d_ano*  `controles' `estado' [pw=pscore_total] if dep!=4 , fe cluster(cod_meso)
outreg2 using "$output/ICE_em_ps_todos_estados_redacao_2.xls", excel append label ctitle(redacao, fe cluster mesoregião ps)
*/


local controles  concluir_em_ano_enem e_mora_mais_de_6_pessoas e_escol_sup_pai	///
	e_escol_sup_mae e_renda_familia_5_salarios  predio 	///
	diretoria sala_professores lab_info lab_ciencias quadra_esportes internet 	///
	rural lixo_coleta eletricidade agua esgoto n_salas_utilizadas				///
	n_alunos_em_ep  

local estado d_uf*

local alavancas_fluxo d_ice_fluxo_al1 d_ice_fluxo_al2 d_ice_fluxo_al3 d_ice_fluxo_al4 d_ice_fluxo_al5 d_ice_fluxo_al6 d_ice_fluxo_al7 d_ice_fluxo_al8 
local alavancas_fluxo_todas d_ice_fluxo_al1 d_ice_fluxo_al2 d_ice_fluxo_al3 d_ice_fluxo_al4 d_ice_fluxo_al5 d_ice_fluxo_al6 d_ice_fluxo_al7 d_ice_fluxo_al8 d_ice_fluxo_al9
local alavancas_nota d_ice_nota_al1 d_ice_nota_al2 d_ice_nota_al3 d_ice_nota_al4 d_ice_nota_al5 d_ice_nota_al6 d_ice_nota_al7 d_ice_nota_al8 
local alavancas_nota_todas d_ice_nota_al1 d_ice_nota_al2 d_ice_nota_al3 d_ice_nota_al4 d_ice_nota_al5 d_ice_nota_al6 d_ice_nota_al7 d_ice_nota_al8 d_ice_nota_al9


xtreg enem_nota_redacao_std d_ice_nota d_ano*  `controles' `estado' [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_redacao_2.xls", excel append label ctitle(redacao, fe cluster estado ps)

xtreg enem_nota_redacao_std d_ice_nota d_ice_nota_inte d_ano*  `controles' `estado' [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_redacao_2.xls", excel append label ctitle(redacao, fe cluster estado ps, integral)

xtreg enem_nota_redacao_std d_ice_nota d_ice_nota_semi_inte d_ano*  `controles' `estado' [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_redacao_2.xls", excel append label ctitle(redacao, fe cluster estado ps,semi integral)


xtreg enem_nota_redacao_std d_ice_nota  d_ano*  `controles' `estado' `alavancas_nota' [pw=pscore_total] , fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_redacao_2.xls", excel append label ctitle(redacao, fe cluster estado ps, alavancas)

xtreg enem_nota_redacao_std d_ice_nota  d_ano*  `controles' `estado' `alavancas_nota_todas' [pw=pscore_total] , fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_redacao_2.xls", excel append label ctitle(redacao, fe cluster estado, alavancas_todas)

xtreg enem_nota_redacao_std d_ice_nota d_ano*  `controles' `estado' [pw=pscore_total] if dep!=4 , fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_redacao_2.xls", excel append label ctitle(redacao, fe cluster estado, escolas publicas)

*(outras notas fazer depois)

*agora, variáveis de fluxo
*apr_em_std


xtreg apr_em_std d_ice_fluxo d_ano*  `controles' `estado' [pw=pscore_total], fe rob
outreg2 using "$output/ICE_em_ps_todos_estados_aprov_2.xls", excel replace label ctitle(aprovacao, fe rob ps)
/*
xtreg apr_em_std d_ice_fluxo d_ano*  `controles' `estado', fe cluster(cod_meso)
outreg2 using "$output/ICE_em_ps_todos_estados_aprov_2.xls", excel append label ctitle(aprovacao, fe cluster mesoregião ps)

xtreg apr_em_std d_ice_fluxo d_ano*  `controles' `estado' `alavancas_fluxo' , fe cluster(cod_meso)
outreg2 using "$output/ICE_em_ps_todos_estados_aprov_2.xls", excel append label ctitle(aprovacao, fe cluster estado ps)

xtreg apr_em_std d_ice_fluxo d_ano*  `controles' `estado' if dep!=4 , fe cluster(cod_meso)
outreg2 using "$output/ICE_em_ps_todos_estados_aprov_2.xls", excel append label ctitle(aprovacao, fe cluster mesoregião ps)
*/
xtreg apr_em_std d_ice_fluxo d_ano*  `controles' `estado' [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_aprov_2.xls", excel append label ctitle(aprovacao, fe cluster estado ps)

xtreg apr_em_std d_ice_fluxo d_ice_fluxo_inte d_ano*  `controles' `estado' [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_aprov_2.xls", excel append label ctitle(aprovacao, fe cluster estado ps, integral)

xtreg apr_em_std d_ice_fluxo d_ice_fluxo_semi_inte d_ano*  `controles' `estado' [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_aprov_2.xls", excel append label ctitle(aprovacao, fe cluster estado ps,semi integral)



xtreg apr_em_std d_ice_fluxo d_ano*  `controles' `estado' `alavancas_fluxo' [pw=pscore_total] , fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_aprov_2.xls", excel append label ctitle(aprovacao, fe cluster estado ps, alavancas)

xtreg apr_em_std d_ice_fluxo d_ano*  `controles' `estado' `alavancas_fluxo_todas' [pw=pscore_total] , fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_aprov_2.xls", excel append label ctitle(aprovacao, fe cluster estado ps, alavancas todas)

xtreg apr_em_std d_ice_fluxo d_ano* `controles' `estado' [pw=pscore_total] if dep!=4 , fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_aprov_2.xls", excel append label ctitle(aprovacao, fe cluster estado ps, publicas)

* rep_em_std 


xtreg rep_em_std d_ice_fluxo d_ano* `controles' `estado' [pw=pscore_total], fe rob
outreg2 using "$output/ICE_em_ps_todos_estados_reprov_2.xls", excel replace label ctitle(reprovacao, fe rob ps)
/*
xtreg rep_em_std d_ice_fluxo d_ano*  `controles' `estado' [pw=pscore_total], fe cluster(cod_meso)
outreg2 using "$output/ICE_em_ps_todos_estados_reprov_2.xls", excel append label ctitle(reprovacao, fe cluster mesoregião ps)

xtreg rep_em_std d_ice_fluxo d_ano*  `controles' `estado' `alavancas_fluxo' [pw=pscore_total], fe cluster(cod_meso)
outreg2 using "$output/ICE_em_ps_todos_estados_reprov_2.xls", excel append label ctitle(reprovacao, fe cluster estado ps)

xtreg rep_em_std d_ice_fluxo d_ano*  `controles' `estado' if dep!=4 [pw=pscore_total], fe cluster(cod_meso)
outreg2 using "$output/ICE_em_ps_todos_estados_reprov_2.xls", excel append label ctitle(reprovacao, fe cluster mesoregião ps)
*/
xtreg rep_em_std d_ice_fluxo d_ano* `controles' `estado' [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_reprov_2.xls", excel append label ctitle(reprovacao, fe cluster estado ps)

xtreg rep_em_std d_ice_fluxo d_ice_fluxo_inte d_ano* `controles' `estado' [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_reprov_2.xls", excel append label ctitle(reprovacao, fe cluster estado ps, integral)

xtreg rep_em_std d_ice_fluxo d_ice_fluxo_semi_inte d_ano* `controles' `estado' [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_reprov_2.xls", excel append label ctitle(reprovacao, fe cluster estado ps, semi integral)


xtreg rep_em_std d_ice_fluxo d_ano* `controles' `estado' `alavancas_fluxo' [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_reprov_2.xls", excel append label ctitle(reprovacao, fe cluster estado ps, alavancas)

xtreg rep_em_std d_ice_fluxo d_ano* `controles' `estado' `alavancas_fluxo_todas' [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_reprov_2.xls", excel append label ctitle(reprovacao, fe cluster estado ps, alavancas todas)

xtreg apr_em_std d_ice_fluxo d_ano* `controles' `estado' [pw=pscore_total] if dep!=4 , fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_reprov_2.xls", excel append label ctitle(reprovacao, fe cluster estado ps, publicas)


*aba_em_std 


xtreg aba_em_std d_ice_fluxo d_ano* `controles' `estado' [pw=pscore_total], fe rob
outreg2 using "$output/ICE_em_ps_todos_estados_aband_2.xls", excel replace label ctitle(abandono, fe rob ps)
/*
xtreg aba_em_std d_ice_fluxo d_ano* `controles' `estado' [pw=pscore_total], fe cluster(cod_meso)
outreg2 using "$output/ICE_em_ps_todos_estados_aband_2.xls", excel append label ctitle(abandono, fe cluster mesoregião ps)

xtreg aba_em_std d_ice_fluxo d_ano* `controles' `estado' `alavancas_fluxo' [pw=pscore_total], fe cluster(cod_meso)
outreg2 using "$output/ICE_em_ps_todos_estados_aband_2.xls", excel append label ctitle(abandono, fe cluster estado ps)

xtreg aba_em_std d_ice_fluxo d_ano* `controles' `estado' if dep!=4 [pw=pscore_total], fe cluster(cod_meso)
outreg2 using "$output/ICE_em_ps_todos_estados_aband_2.xls", excel append label ctitle(abandono, fe cluster mesoregião ps)
*/
xtreg aba_em_std d_ice_fluxo  d_ano* `controles' `estado' [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_aband_2.xls", excel append label ctitle(abandono, fe cluster estado)

xtreg aba_em_std d_ice_fluxo d_ice_fluxo_inte d_ano* `controles' `estado' [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_aband_2.xls", excel append label ctitle(abandono, fe cluster estado ps, integral)

xtreg aba_em_std d_ice_fluxo d_ice_fluxo_semi_inte d_ano* `controles' `estado' [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_aband_2.xls", excel append label ctitle(abandono, fe cluster estado ps, semi integral)


xtreg aba_em_std d_ice_fluxo d_ano* `controles' `estado' `alavancas_fluxo' [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_aband_2.xls", excel append label ctitle(abandono, fe cluster estado ps, alavancas)

xtreg aba_em_std d_ice_fluxo d_ano* `controles' `estado' `alavancas_fluxo_todas' [pw=pscore_total] , fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_aband_2.xls", excel append label ctitle(abandono, fe cluster estado ps, alavancas todas)

xtreg aba_em_std d_ice_fluxo d_ano* `controles' `estado' [pw=pscore_total] if dep!=4 , fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_aband_2.xls", excel append label ctitle(abandono, fe cluster estado ps, publicas)

*dist_em_std 

xtreg dist_em_std d_ice_fluxo d_ano* `controles' `estado' [pw=pscore_total], fe rob
outreg2 using "$output/ICE_em_ps_todos_estados_dist_2.xls", excel replace label ctitle(distancia, fe rob ps)
/*
xtreg dist_em_std d_ice_fluxo d_ano*  `controles' `estado' [pw=pscore_total], fe cluster(cod_meso)
outreg2 using "$output/ICE_em_ps_todos_estados_dist_2.xls", excel append label ctitle(distancia, fe cluster mesoregião ps)

xtreg dist_em_std d_ice_fluxo d_ano*  `controles' `estado' `alavancas_fluxo' [pw=pscore_total], fe cluster(cod_meso)
outreg2 using "$output/ICE_em_ps_todos_estados_dist_2.xls", excel append label ctitle(distancia, fe cluster estado ps)

xtreg dist_em_std d_ice_fluxo d_ano*  `controles' `estado' [pw=pscore_total] if dep!=4 , fe cluster(cod_meso)
outreg2 using "$output/ICE_em_ps_todos_estados_dist_2.xls", excel append label ctitle(distancia, fe cluster mesoregião ps)
*/
xtreg dist_em_std d_ice_fluxo d_ano*  `controles' `estado' [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_dist_2.xls", excel append label ctitle(distancia, fe cluster estado ps)

xtreg dist_em_std d_ice_fluxo d_ice_fluxo_inte d_ano*  `controles' `estado' [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_dist_2.xls", excel append label ctitle(distancia, fe cluster estado ps, integral)

xtreg dist_em_std d_ice_fluxo d_ice_fluxo_semi_inte d_ano*  `controles' `estado' [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_dist_2.xls", excel append label ctitle(distancia, fe cluster estado ps, semi integral)




xtreg dist_em_std d_ice_fluxo d_ano*  `controles' `estado' `alavancas_fluxo' [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_dist_2.xls", excel append label ctitle(distancia, fe cluster estado ps, alavancas)

xtreg dist_em_std d_ice_fluxo d_ano*  `controles' `estado' `alavancas_fluxo_todas' [pw=pscore_total] , fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_dist_2.xls", excel append label ctitle(distancia, fe cluster estado ps, alavancas todas)

xtreg dist_em_std d_ice_fluxo d_ano*  `controles' `estado' [pw=pscore_total] if dep!=4 , fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_dist_2.xls", excel append label ctitle(distancia, fe cluster estado ps, publicas)


/*

6) efeitos fixos com propensity score com todos os estados cumulativo
propensity score com algoritmo do imbens
	fe cluster em estado
	a) todas as escolas
	b) só escolas públicas
usando como variável de outcome 
apr_em_std rep_em_std aba_em_std dist_em_std 
enem_nota_matematica_std  enem_nota_ciencias_std 
enem_nota_humanas_std enem_nota_linguagens_std 
enem_nota_redacao_std enem_nota_objetivab_std	

*/
use "$folderservidor\em_com_censo_escolar_14.dta", clear
replace ice=0 if ice ==.
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

local controles_pscore  concluir_em_ano_enem e_mora_mais_de_6_pessoas e_escol_sup_pai	///
	e_escol_sup_mae e_renda_familia_5_salarios  predio 	///
	diretoria sala_professores lab_info lab_ciencias quadra_esportes internet		 ///
	rural lixo_coleta eletricidade agua  esgoto n_salas_utilizadas					///
	n_alunos_em_ep  
//mdesc `controles_pscore' taxa_participacao_enem if ano ==2003

local estado d_uf*

local alavancas_fluxo d_ice_fluxo_al1 d_ice_fluxo_al2 d_ice_fluxo_al3 d_ice_fluxo_al4 d_ice_fluxo_al5 d_ice_fluxo_al6 d_ice_fluxo_al7 d_ice_fluxo_al8 
local alavancas_fluxo_todas d_ice_fluxo_al1 d_ice_fluxo_al2 d_ice_fluxo_al3 d_ice_fluxo_al4 d_ice_fluxo_al5 d_ice_fluxo_al6 d_ice_fluxo_al7 d_ice_fluxo_al8 d_ice_fluxo_al9
local alavancas_nota d_ice_nota_al1 d_ice_nota_al2 d_ice_nota_al3 d_ice_nota_al4 d_ice_nota_al5 d_ice_nota_al6 d_ice_nota_al7 d_ice_nota_al8 
local alavamcas_nota_todas d_ice_nota_al1 d_ice_nota_al2 d_ice_nota_al3 d_ice_nota_al4 d_ice_nota_al5 d_ice_nota_al6 d_ice_nota_al7 d_ice_nota_al8 d_ice_nota_al9


pscore ice `controles_pscore' taxa_participacao_enem if ano == 2003, pscore(pscores_todos)

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
/*
bysort codigo_escola: egen pscore_total_estado_aux = max(pscore_total_estado)
replace pscore_total_estado = pscore_total_estado_aux
*/
/*
In -xt- analyses, the weight must be constant within panels
o pscore_total será usado como peso weight no xtreg 
*/

/*
apr_em_std rep_em_std aba_em_std dist_em_std 
enem_nota_matematica_std  enem_nota_ciencias_std 
enem_nota_humanas_std enem_nota_linguagens_std 
enem_nota_redacao_std enem_nota_objetivab_std
*/


gen tempo=.

replace tempo=0 if ano==ano_ice-6
replace tempo=1 if ano==ano_ice-5
replace tempo=2 if ano==ano_ice-4
replace tempo=3 if ano==ano_ice-3 
replace tempo=4 if ano==ano_ice-2
replace tempo=5 if ano==ano_ice-1
replace tempo=6 if ano==ano_ice
replace tempo=7 if ano==ano_ice+1 
replace tempo=8 if ano==ano_ice+2
replace tempo=9 if ano==ano_ice+3
replace tempo=10 if ano==ano_ice+4
replace tempo=11 if ano==ano_ice+5
replace tempo=12 if ano==ano_ice+6


iis codigo_escol
tis tempo

tab tempo, gen(d_tempo)

gen d_ice_nota_pre6=ice*d_tempo1
gen d_ice_nota_pre5=ice*d_tempo2
gen d_ice_nota_pre4=ice*d_tempo3
gen d_ice_nota_pre3=ice*d_tempo4
gen d_ice_nota_pre2=ice*d_tempo5
gen d_ice_nota_pre1=ice*d_tempo6
gen d_ice_nota_inicio=d_ice_nota*d_tempo7
gen d_ice_nota_pos1=d_ice_nota*d_tempo8
gen d_ice_nota_pos2=d_ice_nota*d_tempo9
gen d_ice_nota_pos3=d_ice_nota*d_tempo10
gen d_ice_nota_pos4=d_ice_nota*d_tempo11
gen d_ice_nota_pos5=d_ice_nota*d_tempo12
gen d_ice_nota_pos6=d_ice_nota*d_tempo13


gen d_ice_nota_inte_pre6=ice_inte*d_tempo1
gen d_ice_nota_inte_pre5=ice_inte*d_tempo2
gen d_ice_nota_inte_pre4=ice_inte*d_tempo3
gen d_ice_nota_inte_pre3=ice_inte*d_tempo4
gen d_ice_nota_inte_pre2=ice_inte*d_tempo5
gen d_ice_nota_inte_pre1=ice_inte*d_tempo6
gen d_ice_nota_inte_inicio=d_ice_nota_inte*d_tempo7
gen d_ice_nota_inte_pos1=d_ice_nota_inte*d_tempo8
gen d_ice_nota_inte_pos2=d_ice_nota_inte*d_tempo9
gen d_ice_nota_inte_pos3=d_ice_nota_inte*d_tempo10
gen d_ice_nota_inte_pos4=d_ice_nota_inte*d_tempo11
gen d_ice_nota_inte_pos5=d_ice_nota_inte*d_tempo12
gen d_ice_nota_inte_pos6=d_ice_nota_inte*d_tempo13


gen d_ice_fluxo_pre6=ice*d_tempo1
gen d_ice_fluxo_pre5=ice*d_tempo2
gen d_ice_fluxo_pre4=ice*d_tempo3
gen d_ice_fluxo_pre3=ice*d_tempo4
gen d_ice_fluxo_pre2=ice*d_tempo5
gen d_ice_fluxo_pre1=ice*d_tempo6
gen d_ice_fluxo_inicio=d_ice_fluxo*d_tempo7
gen d_ice_fluxo_pos1=d_ice_fluxo*d_tempo8
gen d_ice_fluxo_pos2=d_ice_fluxo*d_tempo9
gen d_ice_fluxo_pos3=d_ice_fluxo*d_tempo10
gen d_ice_fluxo_pos4=d_ice_fluxo*d_tempo11
gen d_ice_fluxo_pos5=d_ice_fluxo*d_tempo12



gen d_ice_fluxo_inte_pre6=ice_inte*d_tempo1
gen d_ice_fluxo_inte_pre5=ice_inte*d_tempo2
gen d_ice_fluxo_inte_pre4=ice_inte*d_tempo3
gen d_ice_fluxo_inte_pre3=ice_inte*d_tempo4
gen d_ice_fluxo_inte_pre2=ice_inte*d_tempo5
gen d_ice_fluxo_inte_pre1=ice_inte*d_tempo6
gen d_ice_fluxo_inte_inicio=d_ice_fluxo_inte*d_tempo7
gen d_ice_fluxo_inte_pos1=d_ice_fluxo_inte*d_tempo8
gen d_ice_fluxo_inte_pos2=d_ice_fluxo_inte*d_tempo9
gen d_ice_fluxo_inte_pos3=d_ice_fluxo_inte*d_tempo10
gen d_ice_fluxo_inte_pos4=d_ice_fluxo_inte*d_tempo11
gen d_ice_fluxo_inte_pos5=d_ice_fluxo_inte*d_tempo12


local controles  concluir_em_ano_enem e_mora_mais_de_6_pessoas e_escol_sup_pai	///
	e_escol_sup_mae e_renda_familia_5_salarios  predio 	///
	diretoria sala_professores lab_info lab_ciencias quadra_esportes internet 	///
	rural lixo_coleta eletricidade agua esgoto n_salas_utilizadas				///
	n_alunos_em_ep  


local estado d_uf*

local alavancas_fluxo d_ice_fluxo_al1 d_ice_fluxo_al2 d_ice_fluxo_al3 d_ice_fluxo_al4 d_ice_fluxo_al5 d_ice_fluxo_al6 d_ice_fluxo_al7 d_ice_fluxo_al8 d_ice_fluxo_al9
local alavancas_nota d_ice_nota_al1 d_ice_nota_al2 d_ice_nota_al3 d_ice_nota_al4 d_ice_nota_al5 d_ice_nota_al6 d_ice_nota_al7 d_ice_nota_al8 d_ice_nota_al9

local nota_todos_anos d_ice_nota_pre6 d_ice_nota_pre5 d_ice_nota_pre4 d_ice_nota_pre3 ///
 d_ice_nota_pre2 d_ice_nota_pre1 d_ice_nota_inicio d_ice_nota_pos1 				///
 d_ice_nota_pos2 d_ice_nota_pos3 d_ice_nota_pos4 d_ice_nota_pos5 d_ice_nota_pos6

local nota_todos_anos_integral d_ice_nota_inte_pre6 d_ice_nota_inte_pre5 				///
d_ice_nota_inte_pre4 d_ice_nota_inte_pre3 d_ice_nota_inte_pre2					///
d_ice_nota_inte_pre1 d_ice_nota_inte_inicio  d_ice_nota_inte_pos1				///
d_ice_nota_inte_pos2 d_ice_nota_inte_pos3 					///
d_ice_nota_inte_pos4 d_ice_nota_inte_pos5 d_ice_nota_inte_pos6					
 
local nota_alguns_anos d_ice_nota_pre3 d_ice_nota_pre2 d_ice_nota_pre1 			///
d_ice_nota_inicio d_ice_nota_pos1 d_ice_nota_pos2 d_ice_nota_pos3 d_ice_nota_pos4 

local nota_alguns_anos_integral d_ice_nota_inte_pre3 d_ice_nota_inte_pre2 ///
d_ice_nota_inte_pre1 d_ice_nota_inte_inicio  d_ice_nota_inte_pos1 ///
d_ice_nota_inte_pos2 d_ice_nota_inte_pos3 d_ice_nota_inte_pos4

local fluxo_todos_anos d_ice_fluxo_pre6 d_ice_fluxo_pre5 d_ice_fluxo_pre4 ///
d_ice_fluxo_pre3 d_ice_fluxo_pre2 d_ice_fluxo_pre1 d_ice_fluxo_inicio ///
d_ice_fluxo_pos1 d_ice_fluxo_pos2 d_ice_fluxo_pos3 d_ice_fluxo_pos4  d_ice_fluxo_pos5

local fluxo_todos_anos_integral d_ice_fluxo_inte_pre6 d_ice_fluxo_inte_pre5 ///
d_ice_fluxo_inte_pre4 d_ice_fluxo_inte_pre3 d_ice_fluxo_inte_pre2 ///
d_ice_fluxo_inte_pre1 d_ice_fluxo_inte_inicio d_ice_fluxo_inte_pos1 ///
d_ice_fluxo_inte_pos2 d_ice_fluxo_inte_pos3 d_ice_fluxo_inte_pos4 d_ice_fluxo_inte_pos5

local fluxo_alguns_anos d_ice_fluxo_pre3 d_ice_fluxo_pre2 d_ice_fluxo_pre1 d_ice_fluxo_inicio ///
d_ice_fluxo_pos1 d_ice_fluxo_pos2 d_ice_fluxo_pos3 d_ice_fluxo_pos4

local fluxo_alguns_anos_integral  d_ice_fluxo_inte_pre3 d_ice_fluxo_inte_pre2 ///
d_ice_fluxo_inte_pre1 d_ice_fluxo_inte_inicio d_ice_fluxo_inte_pos1 ///
d_ice_fluxo_inte_pos2 d_ice_fluxo_inte_pos3 d_ice_fluxo_inte_pos4 


local controles  concluir_em_ano_enem e_mora_mais_de_6_pessoas e_escol_sup_pai	///
	e_escol_sup_mae e_renda_familia_5_salarios  predio 	///
	diretoria sala_professores lab_info lab_ciencias quadra_esportes internet 	///
	rural lixo_coleta eletricidade agua esgoto n_salas_utilizadas				///
	n_alunos_em_ep  


local estado d_uf*

local alavancas_fluxo d_ice_fluxo_al1 d_ice_fluxo_al2 d_ice_fluxo_al3 d_ice_fluxo_al4 d_ice_fluxo_al5 d_ice_fluxo_al6 d_ice_fluxo_al7 d_ice_fluxo_al8 d_ice_fluxo_al9
local alavancas_nota d_ice_nota_al1 d_ice_nota_al2 d_ice_nota_al3 d_ice_nota_al4 d_ice_nota_al5 d_ice_nota_al6 d_ice_nota_al7 d_ice_nota_al8 d_ice_nota_al9

//xtreg dist_em_std d_ice_fluxo d_ano*  `controles' `estado' if dep!=4 , fe cluster(codigo_uf)
//outreg2 using "$output/ICE_em_todos_estados_aband_2.xls", excel append label ctitle(distancia, fe cluster estado, publicas)
*enem_nota_objetivab_std
xtreg  enem_nota_objetivab_std  `nota_todos_anos' `nota_todos_anos_integral' ///
	d_ano* `controles' [pw=pscore_total] if (tempo==0|tempo==1|tempo==2| tempo==3| ///
	tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 |tempo==10|tempo==11|tempo==12 ) , fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_nota_cum_2.xls", excel replace label ctitle(enem objetiva,cumulativo todos integral, fe ps) 

xtreg  enem_nota_objetivab_std  `nota_todos_anos' /// `nota_todos_anos_integral' ///
	d_ano* `controles' [pw=pscore_total] if (tempo==0|tempo==1|tempo==2| tempo==3| ///
	tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 |tempo==10|tempo==11|tempo==12 ) , fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_nota_cum_2.xls", excel append label ctitle(enem objetiva,  cumulativo todos, fe ps) 

xtreg  enem_nota_objetivab_std  `nota_alguns_anos' `nota_alguns_anos_integral' ///
	d_ano* `controles' [pw=pscore_total] if (tempo==0|tempo==1|tempo==2| tempo==3| ///
	tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 |tempo==10|tempo==11|tempo==12 ) , fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_nota_cum_2.xls", excel append label ctitle(enem objetiva,cumulativo alguns integral,fe ps) 

xtreg  enem_nota_objetivab_std  `nota_alguns_anos' ///`nota_alguns_anos_integral' ///
	d_ano* `controles' [pw=pscore_total] if (tempo==0|tempo==1|tempo==2| tempo==3| ///
	tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 |tempo==10|tempo==11|tempo==12 ) , fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_nota_cum_2.xls", excel append label ctitle(enem objetiva,cumulativo alguns, fe ps) 

xtreg  enem_nota_objetivab_std   `nota_alguns_anos_integral' ///`nota_alguns_anos' ///
	d_ano* `controles' [pw=pscore_total] if (tempo==0|tempo==1|tempo==2| tempo==3| ///
	tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 |tempo==10|tempo==11|tempo==12 ) , fe cluster(codigo_uf)
outreg2 using "$output/ICE_em_ps_todos_estados_nota_cum_2.xls", excel append label ctitle(enem objetiva,cumulativo alguns somente integral, fe ps) 



*enem_nota_matematica_std
xtreg  enem_nota_matematica_std  `nota_todos_anos' `nota_todos_anos_integral' ///
	d_ano* `controles' [pw=pscore_total] if (tempo==0|tempo==1|tempo==2| tempo==3| ///
	tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 |tempo==10|tempo==11|tempo==12 ) , fe cluster(codigo_uf)
	
outreg2 using "$output/ICE_em_ps_todos_estados_nota_cum_2.xls", excel append label ctitle(matematica, cumulativas todos intergal, fe ps ) 

xtreg  enem_nota_matematica_std  `nota_todos_anos'  /// `nota_todos_anos_integral' ///
	d_ano* `controles' [pw=pscore_total] if (tempo==0|tempo==1|tempo==2| tempo==3| ///
	tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 |tempo==10|tempo==11|tempo==12 ) , fe cluster(codigo_uf)
	
outreg2 using "$output/ICE_em_ps_todos_estados_nota_cum_2.xls", excel append label ctitle(matematica, cumulativas todos, fe ps ) 

xtreg  enem_nota_matematica_std  `nota_alguns_anos' `nota_alguns_anos_integral' ///
	d_ano* `controles' [pw=pscore_total] if (tempo==0|tempo==1|tempo==2| tempo==3| ///
	tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 |tempo==10|tempo==11|tempo==12 ) , fe cluster(codigo_uf)
	
outreg2 using "$output/ICE_em_ps_todos_estados_nota_cum_2.xls", excel append label ctitle(matematica, cumulativas alguns integral, fe ps ) 

xtreg  enem_nota_matematica_std  `nota_alguns_anos' ///`nota_alguns_anos_integral' ///
	d_ano* `controles' [pw=pscore_total] if (tempo==0|tempo==1|tempo==2| tempo==3| ///
	tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 |tempo==10|tempo==11|tempo==12 ) , fe cluster(codigo_uf)
	
outreg2 using "$output/ICE_em_ps_todos_estados_nota_cum_2.xls", excel append label ctitle(matematica, cumulativas alguns, fe ps ) 


xtreg  enem_nota_matematica_std  `nota_alguns_anos_integral' /// `nota_alguns_anos' ///
	d_ano* `controles' [pw=pscore_total] if (tempo==0|tempo==1|tempo==2| tempo==3| ///
	tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 |tempo==10|tempo==11|tempo==12 ) , fe cluster(codigo_uf)
	
outreg2 using "$output/ICE_em_ps_todos_estados_nota_cum_2.xls", excel append label ctitle(matematica, cumulativas alguns somente integral, fe ps ) 


*enem_nota_redacao_std

xtreg  enem_nota_redacao_std  `nota_todos_anos' `nota_todos_anos_integral' ///
	d_ano* `controles' [pw=pscore_total] if (tempo==0|tempo==1|tempo==2| tempo==3| ///
	tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 |tempo==10|tempo==11|tempo==12 ) , fe cluster(codigo_uf)
	
outreg2 using "$output/ICE_em_ps_todos_estados_nota_cum_2.xls", excel append label ctitle(redacao, cumulativas todos integral,  ps) 

xtreg  enem_nota_redacao_std  `nota_todos_anos' /// `nota_todos_anos_integral' ///
	d_ano* `controles' [pw=pscore_total] if (tempo==0|tempo==1|tempo==2| tempo==3| ///
	tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 |tempo==10|tempo==11|tempo==12 ) , fe cluster(codigo_uf)
	
outreg2 using "$output/ICE_em_ps_todos_estados_nota_cum_2.xls", excel append label ctitle(redacao, cumulativas todos,  ps) 


xtreg  enem_nota_redacao_std  `nota_alguns_anos' `nota_alguns_anos_integral' ///
	d_ano* `controles' [pw=pscore_total] if (tempo==0|tempo==1|tempo==2| tempo==3| ///
	tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 |tempo==10|tempo==11|tempo==12 ) , fe cluster(codigo_uf)
	
outreg2 using "$output/ICE_em_ps_todos_estados_nota_cum_2.xls", excel append label ctitle(redacao, cumulativas alguns integral, ps) 

xtreg  enem_nota_redacao_std  `nota_alguns_anos' ///`nota_alguns_anos_integral' ///
	d_ano* `controles' [pw=pscore_total] if (tempo==0|tempo==1|tempo==2| tempo==3| ///
	tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 |tempo==10|tempo==11|tempo==12 ) , fe cluster(codigo_uf)
	
outreg2 using "$output/ICE_em_ps_todos_estados_nota_cum_2.xls", excel append label ctitle(redacao, cumulativas alguns, ps) 


xtreg  enem_nota_redacao_std   `nota_alguns_anos_integral' /// `nota_alguns_anos'///
	d_ano* `controles' [pw=pscore_total] if (tempo==0|tempo==1|tempo==2| tempo==3| ///
	tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 |tempo==10|tempo==11|tempo==12 ) , fe cluster(codigo_uf)
	
outreg2 using "$output/ICE_em_ps_todos_estados_nota_cum_2.xls", excel append label ctitle(redacao, cumulativas somente integral, ps) 





*apr_em_std 
xtreg  apr_em_std `fluxo_todos_anos' `fluxo_todos_anos_integral'    ///
	d_ano* `controles' [pw=pscore_total] if (tempo==0|tempo==1|tempo==2| tempo==3| ///
	tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 |tempo==10|tempo==11|tempo==12 ) , fe cluster(codigo_uf)
		
outreg2 using "$output/ICE_em_ps_todos_estados_fluxo_cum_2.xls", excel replace label ctitle(aprovacao, cumulativas todos integral, ps) 

xtreg  apr_em_std `fluxo_todos_anos' ///`fluxo_todos_anos_integral'    ///
	d_ano* `controles' [pw=pscore_total] if (tempo==0|tempo==1|tempo==2| tempo==3| ///
	tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 |tempo==10|tempo==11|tempo==12 ) , fe cluster(codigo_uf)
		
outreg2 using "$output/ICE_em_ps_todos_estados_fluxo_cum_2.xls", excel append label ctitle(aprovacao, cumulativas todos, ps) 


xtreg  apr_em_std `fluxo_alguns_anos' `fluxo_alguns_anos_integral'    ///
	d_ano* `controles' [pw=pscore_total] if (tempo==0|tempo==1|tempo==2| tempo==3| ///
	tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 |tempo==10|tempo==11|tempo==12 ) , fe cluster(codigo_uf)
		
outreg2 using "$output/ICE_em_ps_todos_estados_fluxo_cum_2.xls", excel append label ctitle(aprovacao, cumulativas alguns integral, ps) 
xtreg  apr_em_std `fluxo_alguns_anos' /// `fluxo_alguns_anos_integral'    ///
	d_ano* `controles' [pw=pscore_total] if (tempo==0|tempo==1|tempo==2| tempo==3| ///
	tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 |tempo==10|tempo==11|tempo==12 ) , fe cluster(codigo_uf)
		
outreg2 using "$output/ICE_em_ps_todos_estados_fluxo_cum_2.xls", excel append label ctitle(aprovacao, cumulativas alguns, ps) 

xtreg  apr_em_std  `fluxo_alguns_anos_integral'    ///`fluxo_alguns_anos'///
	d_ano* `controles' [pw=pscore_total] if (tempo==0|tempo==1|tempo==2| tempo==3| ///
	tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 |tempo==10|tempo==11|tempo==12 ) , fe cluster(codigo_uf)
		
outreg2 using "$output/ICE_em_ps_todos_estados_fluxo_cum_2.xls", excel append label ctitle(aprovacao, cumulativas alguns somente integral, ps) 

*rep_em_std 
xtreg  rep_em_std `fluxo_todos_anos' `fluxo_todos_anos_integral'    ///
	d_ano* `controles' [pw=pscore_total] if (tempo==0|tempo==1|tempo==2| tempo==3| ///
	tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 |tempo==10|tempo==11|tempo==12 ) , fe cluster(codigo_uf)
		
outreg2 using "$output/ICE_em_ps_todos_estados_fluxo_cum_2.xls", excel append label ctitle(reprovacao, cumulativas todos integral, ps) 

xtreg  rep_em_std `fluxo_todos_anos' ///`fluxo_todos_anos_integral'    ///
	d_ano* `controles' [pw=pscore_total] if (tempo==0|tempo==1|tempo==2| tempo==3| ///
	tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 |tempo==10|tempo==11|tempo==12 ) , fe cluster(codigo_uf)
		
outreg2 using "$output/ICE_em_ps_todos_estados_fluxo_cum_2.xls", excel append label ctitle(reprovacao, cumulativas todos,  ps) 



xtreg  rep_em_std `fluxo_alguns_anos' `fluxo_alguns_anos_integral'    ///
	d_ano* `controles' [pw=pscore_total] if (tempo==0|tempo==1|tempo==2| tempo==3| ///
	tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 |tempo==10|tempo==11|tempo==12 ) , fe cluster(codigo_uf)
		
		
outreg2 using "$output/ICE_em_ps_todos_estados_fluxo_cum_2.xls", excel append label ctitle(reprovacao, cumulativas alguns integral, ps)


xtreg  rep_em_std `fluxo_alguns_anos' ///`fluxo_alguns_anos_integral'    ///
	d_ano* `controles' [pw=pscore_total] if (tempo==0|tempo==1|tempo==2| tempo==3| ///
	tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 |tempo==10|tempo==11|tempo==12 ) , fe cluster(codigo_uf)
		
		
outreg2 using "$output/ICE_em_ps_todos_estados_fluxo_cum_2.xls", excel append label ctitle(reprovacao, cumulativas alguns, ps)

xtreg  rep_em_std  `fluxo_alguns_anos_integral'    /// `fluxo_alguns_anos'///
	d_ano* `controles' [pw=pscore_total] if (tempo==0|tempo==1|tempo==2| tempo==3| ///
	tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 |tempo==10|tempo==11|tempo==12 ) , fe cluster(codigo_uf)
		
		
outreg2 using "$output/ICE_em_ps_todos_estados_fluxo_cum_2.xls", excel append label ctitle(reprovacao, cumulativas alguns somente integral, ps)

*aba_em_std 
xtreg  aba_em_std `fluxo_todos_anos' `fluxo_todos_anos_integral'    ///
	d_ano* `controles' [pw=pscore_total] if (tempo==0|tempo==1|tempo==2| tempo==3| ///
	tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 |tempo==10|tempo==11|tempo==12 ) , fe cluster(codigo_uf)
		
		
outreg2 using "$output/ICE_em_ps_todos_estados_fluxo_cum_2.xls", excel append label ctitle(abandono, cumulativas todos integral, ps) 

xtreg  aba_em_std `fluxo_todos_anos' ///`fluxo_todos_anos_integral'    ///
	d_ano* `controles' [pw=pscore_total] if (tempo==0|tempo==1|tempo==2| tempo==3| ///
	tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 |tempo==10|tempo==11|tempo==12 ) , fe cluster(codigo_uf)
		
		
outreg2 using "$output/ICE_em_ps_todos_estados_fluxo_cum_2.xls", excel append label ctitle(abandono, cumulativas todos,  ps) 


xtreg  aba_em_std `fluxo_alguns_anos' `fluxo_alguns_anos_integral'    ///
	d_ano* `controles' [pw=pscore_total] if (tempo==0|tempo==1|tempo==2| tempo==3| ///
	tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 |tempo==10|tempo==11|tempo==12 ) , fe cluster(codigo_uf)
		
		
outreg2 using "$output/ICE_em_ps_todos_estados_fluxo_cum_2.xls", excel append label ctitle(abandono, cumulativas alguns integral, ps) 


xtreg  aba_em_std `fluxo_alguns_anos' /// `fluxo_alguns_anos_integral'    ///
	d_ano* `controles' [pw=pscore_total] if (tempo==0|tempo==1|tempo==2| tempo==3| ///
	tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 |tempo==10|tempo==11|tempo==12 ) , fe cluster(codigo_uf)
		
		
outreg2 using "$output/ICE_em_ps_todos_estados_fluxo_cum_2.xls", excel append label ctitle(abandono, cumulativas alguns, ps)

xtreg  aba_em_std `fluxo_alguns_anos_integral'    /// `fluxo_alguns_anos'  ///
	d_ano* `controles' [pw=pscore_total] if (tempo==0|tempo==1|tempo==2| tempo==3| ///
	tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 |tempo==10|tempo==11|tempo==12 ) , fe cluster(codigo_uf)
		
		
outreg2 using "$output/ICE_em_ps_todos_estados_fluxo_cum_2.xls", excel append label ctitle(abandono, cumulativas alguns somente integral, ps) 


*dist_em_std 
xtreg  dist_em_std  `fluxo_todos_anos' `fluxo_todos_anos_integral'    ///
	d_ano* `controles' [pw=pscore_total] if (tempo==0|tempo==1|tempo==2| tempo==3| ///
	tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 |tempo==10|tempo==11|tempo==12 ) , fe cluster(codigo_uf)
		
outreg2 using "$output/ICE_em_ps_todos_estados_fluxo_cum_2.xls", excel append label ctitle(distancia, cumulativas todos integral, ps) 

xtreg  dist_em_std  `fluxo_todos_anos' /// `fluxo_todos_anos_integral'    ///
	d_ano* `controles' [pw=pscore_total] if (tempo==0|tempo==1|tempo==2| tempo==3| ///
	tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 |tempo==10|tempo==11|tempo==12 ) , fe cluster(codigo_uf)
		
outreg2 using "$output/ICE_em_ps_todos_estados_fluxo_cum_2.xls", excel append label ctitle(distancia, cumulativas todos,  ps) 


xtreg  dist_em_std `fluxo_alguns_anos' `fluxo_alguns_anos_integral'    ///
	d_ano* `controles' [pw=pscore_total] if (tempo==0|tempo==1|tempo==2| tempo==3| ///
	tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 |tempo==10|tempo==11|tempo==12 ) , fe cluster(codigo_uf)
		
outreg2 using "$output/ICE_em_ps_todos_estados_fluxo_cum_2.xls", excel append label ctitle(distancia, cumulativas alguns integral, ps)

xtreg  dist_em_std `fluxo_alguns_anos' ///`fluxo_alguns_anos_integral'    ///
	d_ano* `controles' [pw=pscore_total] if (tempo==0|tempo==1|tempo==2| tempo==3| ///
	tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 |tempo==10|tempo==11|tempo==12 ) , fe cluster(codigo_uf)
		
outreg2 using "$output/ICE_em_ps_todos_estados_fluxo_cum_2.xls", excel append label ctitle(distancia, cumulativas alguns, ps)

 xtreg  dist_em_std  `fluxo_alguns_anos_integral'    /// `fluxo_alguns_anos'///
	d_ano* `controles' [pw=pscore_total] if (tempo==0|tempo==1|tempo==2| tempo==3| ///
	tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 |tempo==10|tempo==11|tempo==12 ) , fe cluster(codigo_uf)
		
outreg2 using "$output/ICE_em_ps_todos_estados_fluxo_cum_2.xls", excel append label ctitle(distancia, cumulativas alguns  somente integral, ps)



