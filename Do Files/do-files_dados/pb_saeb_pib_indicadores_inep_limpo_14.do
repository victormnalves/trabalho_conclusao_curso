/*********************Base final versão 3 EF***************/
/*
mergeando as bases
prova brasil
saeb
pib por cidade 
indicadores do inep
*/

clear all
set more off, permanently

capture log close
global user "`:environment USERPROFILE'"
*global Folder "$user/OneDrive/EESP_ECONOMIA_mestrado_acadêmico/Dissertação/ICE/dados_ICE/Análise_Leonardo"
global Folder "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo"
global output "$Folder/resultados"
global Bases "$Folder/Bases"
global dofiles "$Folder/Do-Files"
global Logfolder "$Folder/Log"
global folderservidor "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"
log using "$folderservidor\\logfiles/ajuste_pb_saeb_pib_indicadores_inep_v3.log", replace

**************************criando a base de ef****************************


*ajustando a base do saeb
use "$folderservidor\saeb_prova_brasil\saeb_todos.dta", clear
gen ano = ano_saeb 
drop _m
drop if codigo_escola==.
/*
. drop if codigo_escola==.
(7,913 observations deleted)
. tab ano

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      1,308        0.73        0.73
       2005 |      1,147        0.64        1.37
       2011 |     58,960       32.79       34.15
       2013 |     60,285       33.52       67.68
       2015 |     58,123       32.32      100.00
------------+-----------------------------------
      Total |    179,823      100.00


*/
*analisando os missings do saeb
*as variáveis que estão presentes em todos os anos são relacionadas ao método de seleção
* do diretor
*especialmente seleção, eleição, indicação
keep ano_saeb ano s_metodo_esc_dir_selecao s_metodo_esc_dir_eleicao s_metodo_esc_dir_sel_ele s_metodo_esc_dir_indic s_metodo_esc_dir_concurso s_metodo_esc_dir_sel_indic codigo_escola

merge 1:1 codigo_escola ano using "$folderservidor\saeb_prova_brasil\provabrasil_todos.dta"


drop _merge



*mantendo somente as escolas com notas da prova brasil no ano de interesse
keep if media_lp_prova_brasil_9!=. & media_mt_prova_brasil_9!=.
* analisando os missings da prova brasil

*não há padrão claro para os missing 
mdesc media_lp_prova_brasil_5 - pb_tx_partic5

*variáveis que seguem não apresentam missings sistemáticos são 
*media_lp_prova_brasil_9 media_mt_prova_brasil_9 pb_esc_sup_mae_9 pb_esc_sup_pai_9

keep  ano_saeb ano codigo_escola media_lp_prova_brasil_9 media_mt_prova_brasil_9 pb_esc_sup_mae_9 pb_esc_sup_pai_9 pb_n_partic_9 pb_tx_partic_9
mdesc codigo_escola

save "$folderservidor\saeb_prova_brasil\pb_saeb_limpo.dta", replace 


use "$folderservidor\indicadores_inep\fluxo_2007a2015.dta", clear
keep if dist_ef!=. | aba_ef!= . | rep_ef!= .  | apr_ef != .
drop dist_em aba_em rep_em apr_em
gen ef_fluxo = 1
save "$folderservidor\indicadores_inep\fluxo_2007a2015_ef.dta", replace

use "$folderservidor\saeb_prova_brasil\pb_saeb_limpo.dta", clear
merge 1:1 codigo_escola ano using "$folderservidor\indicadores_inep\fluxo_2007a2015_ef.dta"
drop _m

sort ano codigo_escola

gen media_pb_9=(media_lp_prova_brasil_9+ media_mt_prova_brasil_9)/2

******* Padronizacao das notas *****

foreach x in "media_lp_prova_brasil_9" "media_mt_prova_brasil_9" "media_pb_9" "apr_ef"  "rep_ef"  "aba_ef"  "dist_ef"  {
egen `x'_std=std(`x')
}
save "$folderservidor\pb_saeb_inep_limpo.dta", replace
use "$folderservidor\pb_saeb_inep_limpo.dta", clear
merge 1:1 codigo_escola ano using "$folderservidor\censo_escolar\censo_escolar_todos.dta"

*dropando valores do censo que não tem nem nota nem indicadores de fluxo
drop if _merge == 2

*dropando valores do censo que não tem características no censo

drop if _merge == 1
drop _merge

tostring codigo_municipio_novo, gen(codigo_municipios) format(%20.0g) 
gen cod_aux1=substr(codigo_municipios,1,2) 
gen cod_aux2=substr(codigo_municipios,strlen(codigo_municipios) - 4,5)
gen cod_munic = cod_aux1 +cod_aux2

destring cod_munic, replace
order cod_munic, after (codigo_municipios)
drop codigo_municipios cod_aux1 cod_aux2 
sort cod_munic
rename codigo_municipio codigo_municipio_longo
*adicionando variável de pib por município na base
*renomeando a variável de ano para fazer o merge

merge m:1 cod_munic ano using "$folderservidor\\pib_municipio\pib_capita_municipio_2003_2015_final_14.dta"
drop if _merge==2
rename pib_capita_mil_reals pib_capita_mil_reais
drop _merge pib_capita_mil_reais ipca_acumulado_2015 ipca_acumulado_base2003 ipca_acumulado_ano 
merge m:1 cod_munic  using "$folderservidor\\pib_municipio\codigo_uf_cod_munic.dta"
drop if _merge==2
drop _merge

sort ano codigo_escola

merge m:1 codigo_escola using "$folderservidor\base_final_ice_2_14.dta"
drop if _merge==2
drop _merge
sort  codigo_escola ano
format codigo_escola %10.0g
format codigo_municipio_longo %20.0g
replace ice =0 if ice ==.


*precisamos atribuir zero para as dummies
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


**** Rigor do ICE ****
* ajustando a variável ice_rigor e criando dummies de rigor
replace ice_rigor="Sem Apoio" if ice_rigor==""&ice==1

tab ice_rigor if ice==1, gen(d_rigor)

*gerando dummy de segmento
tab ice_segmento, gen(d_segmento)
/*
d_segmento1 ice_segmento == EF FINAIS 
d_segmento2 ice_segmento == EF FINAIS + EM
d_segmento3 ice_segmento == EFII
d_segmento4 ice_segmento == EM 
d_segmento5 ice_segmento == EM Profissionalizante


*/
* note que existem escolars que tem ensino médio, mas só receberam o programa no ensino fundamental
* então, para avaliar o impacto do programa na nota do enem, precisamos atribuir zero para as
* as escolas que tem somente EF
replace ice = 0 if d_segmento1==1 | d_segmento3==1
replace d_ice_fluxo = 0 if d_segmento1==1 | d_segmento3==1 
replace d_ice_nota = 0 if d_segmento1==1 | d_segmento3==1

forvalues x=2004(1)2015{
replace ice_fluxo_`x'=0 if d_segmento1==1 | d_segmento3==1 
replace ice_nota_`x'=0 if d_segmento1==1 | d_segmento3==1 
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

/*lembrando d_ice é a dummy de ano de entrada do ICE*/

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

/*colocando zero nos missings nas dummies de alavancas*/
foreach x in "al_engaj_gov" "al_engaj_sec" "al_time_seduc" "al_marcos_lei" "al_todos_marcos" "al_sel_dir" "al_sel_prof" "al_proj_vida" {
replace `x'=0 if `x'==.
}

/*gerando as interações en a dummy ice e dummies de alavanca*/
gen al_outros=0
replace al_outros=1 if (al_engaj_gov==1|al_time_seduc==1|al_marcos_lei==1|al_proj_vida==1)

*variável que indica se escola, quando entrou no programa: 

*alavanca 1 - teve bom engajamento do governador
gen d_ice_nota_al1=d_ice_nota*al_engaj_gov
gen d_ice_fluxo_al1=d_ice_fluxo*al_engaj_gov

*alavanca 2 - teve bom engajamento do secretário de educação
gen d_ice_nota_al2=d_ice_nota*al_engaj_sec
gen d_ice_fluxo_al2=d_ice_fluxo*al_engaj_sec

*alavanca 3 - tinha time da SEDUC deducado para a implantação do programa
gen d_ice_nota_al3=d_ice_nota*al_time_seduc
gen d_ice_fluxo_al3=d_ice_fluxo*al_time_seduc

*alavanca 4 - teve implantação dos marcos legais na forma da Lei?
gen d_ice_nota_al4=d_ice_nota*al_marcos_lei
gen d_ice_fluxo_al4=d_ice_fluxo*al_marcos_lei

*alavanca 5 - teve Implantação de todos os marcos legais previstos no cronograma estipulado?
gen d_ice_nota_al5=d_ice_nota*al_todos_marcos
gen d_ice_fluxo_al5=d_ice_fluxo*al_todos_marcos


*alavanca 6 - teve Implantação do processo de seleção e remoção de diretores?
gen d_ice_nota_al6=d_ice_nota*al_sel_dir
gen d_ice_fluxo_al6=d_ice_fluxo*al_sel_dir

*alavanca 7 - teve Implantação do processo de seleção e remoção de professores?
gen d_ice_nota_al7=d_ice_nota*al_sel_prof
gen d_ice_fluxo_al7=d_ice_fluxo*al_sel_prof

*alavanca 8 - teve Implantação do projeto de vida na Matriz Curricular?
gen d_ice_nota_al8=d_ice_nota*al_proj_vida
gen d_ice_fluxo_al8=d_ice_fluxo*al_proj_vida

gen d_ice_nota_al9=d_ice_nota*al_outros
gen d_ice_fluxo_al9=d_ice_fluxo*al_outros





*merge m:1 codigo_escola	 "$folderservidor\\base_final_ice_nota_v3_14.dta"

*mais educação
merge m:1 codigo_escola using "$folderservidor\\mais_educacao_todos.dta"
drop if _merge ==2
sort ano codigo_escola
gen mais_educ=0

foreach x of varlist mais_educacao_fund_2010 - mais_educacao_x_2009 n_turmas_mais_educ_em_1 - n_turmas_mais_educ_em_3 n_turmas_mais_educ_fund_5_8anos- n_turmas_mais_educ_fund_9_9anos n_turmas_mais_educ_em_inte_1- n_turmas_mais_educ_em_inte_ns{
replace mais_educ=1 if `x'>0&`x'!=.
}
drop mais_educacao_fund_2010 - mais_educacao_x_2009
drop _merge
drop uf


*gerando dummies
*gerando dummies de dependência administrativa
tab dep, gen(d_dep)
*gerando dummies de estado
tab codigo_uf, gen(d_uf)
*gerando dummies de ano
tab ano, gen(d_ano)



forvalues x=8(1)9{
forvalues i=5(1)9{
capture replace n_alunos_fund_`x'_`i'anos=0 if n_alunos_fund_`x'_`i'anos==.
capture replace n_mulheres_fund_`x'=0 if n_mulheres_fund_`x'==.
capture replace n_brancos_fund_`x'=0 if n_brancos_fund_`x'==.
}
}

gen n_alunos_ef=n_alunos_fund_5_8anos+ n_alunos_fund_6_8anos +n_alunos_fund_7_8anos +n_alunos_fund_8_8anos +n_alunos_fund_6_9anos +n_alunos_fund_7_9anos +n_alunos_fund_8_9anos +n_alunos_fund_9_9anos
replace n_alunos_ef=0 if n_alunos_ef==.
gen n_mulheres_ef=n_mulheres_fund_5_8anos+ n_mulheres_fund_6_8anos +n_mulheres_fund_7_8anos +n_mulheres_fund_8_8anos +n_mulheres_fund_6_9anos +n_mulheres_fund_7_9anos +n_mulheres_fund_8_9anos +n_mulheres_fund_9_9anos
replace n_mulheres_ef=0 if n_mulheres_ef==.
gen n_brancos_ef=n_brancos_fund_5_8anos+ n_brancos_fund_6_8anos +n_brancos_fund_7_8anos +n_brancos_fund_8_8anos +n_brancos_fund_6_9anos +n_brancos_fund_7_9anos +n_brancos_fund_8_9anos +n_brancos_fund_9_9anos
replace n_brancos_ef=0 if n_brancos_ef==.

replace pb_n_partic_9=0 if pb_n_partic_9==.
replace pb_tx_partic_9=pb_tx_partic_9/100 if ano==2011
rename pb_tx_partic_9 taxa_participacao_pb_9
gen taxa_participacao_pb_aux_9=pb_n_partic_9/(n_alunos_fund_8_8anos+n_alunos_fund_9_9anos) if ano==2009
replace taxa_participacao_pb_9=taxa_participacao_pb_aux_9 if ano==2009

drop n_turmas_mais_educ_em_1 n_turmas_mais_educ_em_2 n_turmas_mais_educ_em_3 n_turmas_mais_educ_em_inte_1 n_turmas_mais_educ_em_inte_2 n_turmas_mais_educ_em_inte_3 n_turmas_mais_educ_em_inte_4 n_turmas_mais_educ_em_inte_ns n_turmas_mais_educ_fund_5_8anos n_turmas_mais_educ_fund_6_8anos n_turmas_mais_educ_fund_7_8anos n_turmas_mais_educ_fund_8_8anos n_turmas_mais_educ_fund_6_9anos n_turmas_mais_educ_fund_7_9anos n_turmas_mais_educ_fund_8_9anos n_turmas_mais_educ_fund_9_9anos

save "$folderservidor\ef_com_censo_escolar_14.dta", replace
save "\\tsclient\C\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\\Bases\ef_com_censo_escolar_14.dta", replace
log close
