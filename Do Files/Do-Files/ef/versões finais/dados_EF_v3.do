/*****************************************************************************
******************************************************************************

DADOS - Ensino Fundamental

******************************************************************************
******************************************************************************/

**12/11/2018
**02/04/2019
**diferença para a versão 2: inclusão de informações sobre professores
/*
mergeando as seguintes bases:
saeb
	limpando a base e mantendo somente variáveis úteis
		analisando os missings
prova brasil

pib per capita por cidade 
indicadores do inep
*/
sysdir set PLUS \\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\ado
*sysdir set PLUS \\fs-eesp-01\EESP\Usuarios\bruna.mirelle\makoto\ado
clear all
set more off, permanently

capture log close

global folderservidor "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"
log using "$folderservidor\logfiles/dados_EF_v3.log", replace


/*
***********************************************************************
SAEB - 
limpando a base, dropando variáveis com muitos missings
***********************************************************************
*/
use "$folderservidor\saeb_prova_brasil\saeb_todos.dta", clear
gen ano = ano_saeb 
gen saeb = 1
drop _m
drop if codigo_escola==.

/*
. drop if codigo_escola==.
(7,913 observations deleted)
179.823 observations
*/
tab ano
/*

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
mdesc profic_m_saeb_3 - s_exp_prof_escola_mais_3_3inte


*/
*as variáveis que estão presentes em todos os anos são relacionadas 
*ao método de seleção
*do diretor
*especialmente seleção, eleição, indicação
*ainda, todas as outras variáveis tem uma porcentagem alta de missings
*note que s_metodo_esc_dir_concurso s_metodo_esc_dir_sel_indic 
*só estão presentes em 2013 e 2015
 
# delimit ;

keep 
saeb
ano_saeb 
ano 
s_metodo_esc_dir_selecao 
s_metodo_esc_dir_eleicao 
s_metodo_esc_dir_sel_ele 
s_metodo_esc_dir_indic 
s_metodo_esc_dir_concurso 
s_metodo_esc_dir_sel_indic 
codigo_escola
;
# delimit cr
*179,283 Observations
/*
***********************************************************************
SAEB PROVA BRASIL - 
merge saeb com pb, limpando a base, dropando variáveis com 
muitos missings
***********************************************************************
*/

merge 1:1 codigo_escola ano using "$folderservidor\saeb_prova_brasil\provabrasil_todos.dta"
tab ano_prova_brasil
/*

     (mean) |
ano_prova_b |
      rasil |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     48,871       17.58       17.58
       2009 |     58,374       21.00       38.58
       2011 |     56,222       20.23       58.81
       2013 |     57,751       20.78       79.58
       2015 |     56,760       20.42      100.00
------------+-----------------------------------
      Total |    277,978      100.00



*/

tab _me
/*
. tab _me

                 _merge |      Freq.     Percent        Cum.
------------------------+-----------------------------------
        master only (1) |     11,927        4.11        4.11
         using only (2) |    110,083       37.97       42.09
            matched (3) |    167,896       57.91      100.00
------------------------+-----------------------------------
                  Total |    289,906      100.00
*/

*Note que 11,927 observações só estão na base do saeb, 
*110,083 observações só estão na base da prova brasil
*167,896 foram pareadas
*289,906  Observations


*vamos dropar as observações que só tem informações da saeb


drop if _merge == 1
drop _m
/*
(11,927 observations deleted)
277,979
*/

*mantendo somente as escolas com notas da prova brasil no ano de interesse
keep if media_lp_prova_brasil_9!=. | media_mt_prova_brasil_9!=.
/*
(126,119 observations deleted)
151,860 Observations
*/

tab ano_prova_brasil
/*

     (mean) |
ano_prova_b |
      rasil |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     27,302       17.98       17.98
       2009 |     32,003       21.07       39.05
       2011 |     30,854       20.32       59.37
       2013 |     31,539       20.77       80.14
       2015 |     30,161       19.86      100.00
------------+-----------------------------------
      Total |    151,859      100.00


*/
*analisando os missings da prova brasil
mdesc media_lp_prova_brasil_5 - pb_tx_partic5

/*

 

    Variable    |     Missing          Total     Percent Missing
----------------+-----------------------------------------------
   media_lp_p~5 |      72,255        151,860          47.58
   media_mt_p~5 |      72,256        151,860          47.58
   pb_n_parti~5 |     118,148        151,860          77.80
   pb_esc_s~e_5 |      72,481        151,860          47.73
   pb_esc_s~i_5 |      72,488        151,860          47.73
   pb_meto~ecao |      68,844        151,860          45.33
   pb_meto~icao |      68,844        151,860          45.33
   pb_metodo_~e |      68,844        151,860          45.33
   pb_metodo_~c |      68,844        151,860          45.33
   p~f_mais_3_5 |     121,055        151,860          79.71
   p~a_mais_3_5 |     121,029        151,860          79.70
   media_lp_p~9 |           1        151,860           0.00
   media_mt_p~9 |           0        151,860           0.00
   pb_n_parti~9 |      92,554        151,860          60.95
   pb_esc_s~e_9 |         657        151,860           0.43
   pb_esc_s~i_9 |         691        151,860           0.46
   p~f_mais_3_9 |      96,847        151,860          63.77
   p~a_mais_3_9 |      96,831        151,860          63.76
   pb_tx_par~_5 |     120,295        151,860          79.21
   pb_comp_in~5 |     135,722        151,860          89.37
   pb_empre~a_5 |     135,722        151,860          89.37
   p~f_mais_2_5 |     136,098        151,860          89.62
   p~a_mais_2_5 |     136,101        151,860          89.62
   pb_tx_par~_9 |      89,467        151,860          58.91
   pb_comp_in~9 |     121,007        151,860          79.68
   pb_empre~a_9 |     121,007        151,860          79.68
   p~f_mais_2_9 |     121,659        151,860          80.11
   p~a_mais_2_9 |     121,657        151,860          80.11
   pb_empre~z_5 |     122,321        151,860          80.55
   pb_empre~z_9 |      90,870        151,860          59.84
   pb_tx_par~c9 |     121,699        151,860          80.14
   pb_tx_par~c5 |     137,390        151,860          90.47
----------------+-----------------------------------------------



*/
*dropando observações que não possuem informação de ano
drop if ano==.
*(1 observation deleted)


	*variáveis que seguem não apresentam missings sistemáticos são 
*media_lp_prova_brasil_9 media_mt_prova_brasil_9 pb_esc_sup_mae_9 pb_esc_sup_pai_9
# delimit ;

keep  
saeb
ano_saeb 
ano 
ano_prova_brasil
codigo_escola 
media_lp_prova_brasil_9 
media_mt_prova_brasil_9 
pb_esc_sup_mae_9 
pb_esc_sup_pai_9 
pb_n_partic_9 
pb_tx_partic_9

media_lp_prova_brasil_5 
media_mt_prova_brasil_5 
pb_esc_sup_mae_5
pb_esc_sup_pai_5 
pb_n_partic_5 
pb_tx_partic_5
;
# delimit cr
*151,859 observations

*analisando os missings com as variáveis finais
mdesc ano_saeb - pb_tx_partic_9

/*

    Variable    |     Missing          Total     Percent Missing
----------------+-----------------------------------------------
       ano_saeb |      59,372        151,859          39.10
   codigo_esc~a |           0        151,859           0.00
            ano |           1        151,859           0.00
   media_lp_p~5 |      72,255        151,859          47.58
   media_mt_p~5 |      72,256        151,859          47.58
   pb_n_parti~5 |     118,148        151,859          77.80
   pb_esc_s~e_5 |      72,481        151,859          47.73
   pb_esc_s~i_5 |      72,488        151,859          47.73
   media_lp_p~9 |           0        151,859           0.00
   media_mt_p~9 |           0        151,859           0.00
   pb_n_parti~9 |      92,554        151,859          60.95
   pb_esc_s~e_9 |         657        151,859           0.43
   pb_esc_s~i_9 |         691        151,859           0.46
   pb_tx_part~5 |     120,294        151,859          79.21
   pb_tx_part~9 |      89,466        151,859          58.91
----------------+-----------------------------------------------
*/




gen pb = .
replace pb = 1 if ano_prova_brasil ==.

mdesc ano_prova_brasil ano_saeb


/*
media_lp_prova_brasil_9 
media_mt_prova_brasil_9 
pb_esc_sup_mae_9 
pb_esc_sup_pai_9 
pb_n_partic_9 
pb_tx_partic_9
*/

tab ano if media_lp_prova_brasil_9 !=.
/*
        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     27,302       17.98       17.98
       2009 |     32,002       21.07       39.05
       2011 |     30,854       20.32       59.37
       2013 |     31,539       20.77       80.14
       2015 |     30,161       19.86      100.00
------------+-----------------------------------
      Total |    151,858      100.00
*/

tab ano if media_lp_prova_brasil_9 ==.
/*

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2009 |          1      100.00      100.00
------------+-----------------------------------
      Total |          1      100.00

*/

tab ano if media_mt_prova_brasil_9 !=.
/*
        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     27,302       17.98       17.98
       2009 |     32,003       21.07       39.05
       2011 |     30,854       20.32       59.37
       2013 |     31,539       20.77       80.14
       2015 |     30,161       19.86      100.00
------------+-----------------------------------
      Total |    151,859      100.00
*/

tab ano if media_mt_prova_brasil_9 ==.
*no observations

tab ano if pb_esc_sup_mae_9 !=.
/*
        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     27,295       18.05       18.05
       2009 |     31,944       21.13       39.18
       2011 |     30,852       20.40       59.58
       2013 |     31,238       20.66       80.24
       2015 |     29,873       19.76      100.00
------------+-----------------------------------
      Total |    151,202      100.00

*/

tab ano if pb_esc_sup_mae_9 ==.
/*

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |          7        1.07        1.07
       2009 |         59        8.98       10.05
       2011 |          2        0.30       10.35
       2013 |        301       45.81       56.16
       2015 |        288       43.84      100.00
------------+-----------------------------------
      Total |        657      100.00

*/
tab ano if pb_esc_sup_pai_9 !=.
/*
        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     27,295       18.06       18.06
       2009 |     31,915       21.11       39.17
       2011 |     30,852       20.41       59.58
       2013 |     31,235       20.66       80.24
       2015 |     29,871       19.76      100.00
------------+-----------------------------------
      Total |    151,168      100.00

*/
tab ano if pb_esc_sup_pai_9 ==.
/*
       ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |          7        1.01        1.01
       2009 |         88       12.74       13.75
       2011 |          2        0.29       14.04
       2013 |        304       43.99       58.03
       2015 |        290       41.97      100.00
------------+-----------------------------------
      Total |        691      100.00

*/

tab ano if pb_n_partic_9 !=.

tab ano if pb_n_partic_9 ==.
/*
. tab ano if pb_n_partic_9 !=.

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     27,302       46.04       46.04
       2009 |     32,003       53.96      100.00
------------+-----------------------------------
      Total |     59,305      100.00

. tab ano if pb_n_partic_9 ==.

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2011 |     30,854       33.34       33.34
       2013 |     31,539       34.08       67.41
       2015 |     30,161       32.59      100.00
------------+-----------------------------------
      Total |     92,554      100.00
*/

tab ano if pb_tx_partic_9 !=.
tab ano if pb_tx_partic_9 ==.
/*
. tab ano if pb_tx_partic_9 !=.

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2011 |     30,854       49.45       49.45
       2013 |     31,539       50.55      100.00
------------+-----------------------------------
      Total |     62,393      100.00

. tab ano if pb_tx_partic_9 ==.

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     27,302       30.52       30.52
       2009 |     32,003       35.77       66.29
       2015 |     30,161       33.71      100.00
------------+-----------------------------------
      Total |     89,466      100.00
*/

drop pb_tx_partic_5 pb_tx_partic_9 pb_n_partic_5 pb_n_partic_9
tab ano_prova_brasil
save "$folderservidor\saeb_prova_brasil\pb_saeb_limpo_v1.dta", replace 

use "$folderservidor\saeb_prova_brasil\pb_saeb_limpo_v1.dta", clear
sort ano_prova_brasil

/*
***********************************************************************
INDICADORES DE FLUXO
distorção, abandono, reprovação e aprovação
***********************************************************************
*/
use "$folderservidor\indicadores_inep\fluxo_2007a2015.dta", clear
* 571,589 Observations
keep if dist_ef!=. | aba_ef!= . | rep_ef!= .  | apr_ef != .
* (353,466 observations deleted)
*  218,123

*drop dist_em aba_em rep_em apr_em 
*não dropar para usar eventualmente em um teste placebo
gen ef_fluxo = 1
save "$folderservidor\indicadores_inep\fluxo_2007a2015_ef.dta", replace

/*
***********************************************************************
SAEB, PB, INDICADORES DE FLUXO, CENSO ESCOLAR
merge da base saeb pb com indicadores do inep
padronização das notas
merge com censo escolar
***********************************************************************
*/

use "$folderservidor\censo_escolar\censo_escolar_todos.dta", clear
capture gen censo_escolar = 1
capture gen ano_censo_escolar = ano
order censo_escolar
merge m:1 codigo_escola using "$folderservidor\censo_escolar\cod_munic_cod_escola.dta"
/*

. merge m:1 codigo_escola using "$folderservidor\censo_escolar\cod_munic_cod_escola.dta"

    Result                           # of obs.
    -----------------------------------------
    not matched                       204,532
        from master                    18,569  (_merge==1)
        from using                    185,963  (_merge==2)

    matched                         1,057,045  (_merge==3)
    -----------------------------------------


*/
drop if _m==2
drop _m

order codigo_municipio_censo,after(codigo_municipio)

tostring codigo_municipio_censo, gen(codigo_municipios) format(%20.0g) 
gen cod_aux1=substr(codigo_municipios,1,2) 
gen cod_aux2=substr(codigo_municipios,strlen(codigo_municipios) - 4,5)
gen cod_munic = cod_aux1 +cod_aux2

destring cod_munic, replace
replace codigo_municipio = cod_munic if codigo_municipio ==.
mdesc codigo_municipio


drop codigo_municipios cod_aux1 cod_aux2 cod_munic
rename codigo_municipio codigo_municipio_censo_escolar
order nome_escola, after(no_entidade)
rename nome_escola nome_escola_censo
rename no_entidade nome_escola_censo_escolar
* dropando variáveis incompletas ou desnecessárias
drop UF SIGLA nome_municipio sigla
drop mascara
save "$folderservidor\censo_escolar\censo_escolar_munic.dta", replace
*/

use "$folderservidor\saeb_prova_brasil\pb_saeb_limpo_v1.dta", clear
merge 1:1 codigo_escola ano using "$folderservidor\indicadores_inep\fluxo_2007a2015_ef.dta"
/*

    Result                           # of obs.
    -----------------------------------------
    not matched                       257,094
        from master                    95,415  (_merge==1)
        from using                    161,679  (_merge==2)

    matched                            56,444  (_merge==3)
    -----------------------------------------

*/

drop _m


sort ano codigo_escola

gen media_pb_9=(media_lp_prova_brasil_9+ media_mt_prova_brasil_9)/2
gen media_pb_5=(media_lp_prova_brasil_5+ media_mt_prova_brasil_5)/2




******* Padronizacao das notas *****
*padronizando dentro dos anos

foreach x in "media_lp_prova_brasil_5" "media_mt_prova_brasil_5" "media_pb_5"  "media_lp_prova_brasil_9" "media_mt_prova_brasil_9" "media_pb_9" "apr_ef"  "rep_ef"  "aba_ef"  "dist_ef" "apr_em"  "rep_em"  "aba_em"  "dist_em" {
	gen `x'_std = .
	foreach a in 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015{
		egen `x'_std_`a' = std(`x') if ano == `a'
		replace `x'_std = `x'_std_`a' if ano == `a'
		drop `x'_std_`a'
}
}

foreach x in "media_lp_prova_brasil_5" "media_mt_prova_brasil_5" "media_pb_5"  "media_lp_prova_brasil_9" "media_mt_prova_brasil_9" "media_pb_9" "apr_ef"  "rep_ef"  "aba_ef"  "dist_ef" "apr_em"  "rep_em"  "aba_em"  "dist_em" {
sum `x' 
}
foreach x in "media_lp_prova_brasil_5" "media_mt_prova_brasil_5" "media_pb_5"  "media_lp_prova_brasil_9" "media_mt_prova_brasil_9" "media_pb_9" "apr_ef"  "rep_ef"  "aba_ef"  "dist_ef" "apr_em"  "rep_em"  "aba_em"  "dist_em" {
sum `x' if ano ==2009
}
foreach x in "media_lp_prova_brasil_5_std" "media_mt_prova_brasil_5_std" "media_pb_5_std"  "media_lp_prova_brasil_9_std" "media_mt_prova_brasil_9_std" "media_pb_9_std" "apr_ef_std"  "rep_ef_std"  "aba_ef_std"  "dist_ef_std" "apr_em_std"  "rep_em_std"  "aba_em_std"  "dist_em_std" {
sum `x'
}
foreach x in "media_lp_prova_brasil_5_std" "media_mt_prova_brasil_5_std" "media_pb_5_std"  "media_lp_prova_brasil_9_std" "media_mt_prova_brasil_9_std" "media_pb_9_std" "apr_ef_std"  "rep_ef_std"  "aba_ef_std"  "dist_ef_std" "apr_em_std"  "rep_em_std"  "aba_em_std"  "dist_em_std" {
sum `x' if ano ==2009
}
gen ef_outcome = 1 if media_lp_prova_brasil_5_std!=. & media_mt_prova_brasil_5_std!=. & media_pb_5_std!=. & media_lp_prova_brasil_9_std !=. & media_mt_prova_brasil_9_std !=. & media_pb_9_std !=. & apr_ef_std !=. & rep_ef_std !=. & aba_ef_std !=. & dist_ef_std !=. & apr_em_std !=. & rep_em_std !=. & aba_em_std !=. & dist_em_std!=.  
gen ef_outcome_any = 1 if media_lp_prova_brasil_5_std!=. | media_mt_prova_brasil_5_std!=. | media_pb_5_std!=. | media_lp_prova_brasil_9_std !=. | media_mt_prova_brasil_9_std !=. | media_pb_9_std !=. | apr_ef_std !=. | rep_ef_std !=. | aba_ef_std !=. | dist_ef_std !=. | apr_em_std !=. | rep_em_std !=. | aba_em_std !=. | dist_em_std!=.  
mdesc apr_ef - ef_outcome_any
{
/*

    Variable    |     Missing          Total     Percent Missing
----------------+-----------------------------------------------
         apr_ef |     105,903        313,538          33.78
         apr_em |     229,882        313,538          73.32
         rep_ef |     118,575        313,538          37.82
         rep_em |     229,882        313,538          73.32
         aba_ef |     118,575        313,538          37.82
         aba_em |     229,882        313,538          73.32
        dist_ef |     121,466        313,538          38.74
        dist_em |     231,458        313,538          73.82
       ef_fluxo |      95,415        313,538          30.43
     media_pb_9 |     161,680        313,538          51.57
     media_pb_5 |     233,934        313,538          74.61
   media_lp_p.. |     233,933        313,538          74.61
   media_mt_p.. |     233,934        313,538          74.61
   media_pb_5~d |     233,934        313,538          74.61
   media_lp_p.. |     161,680        313,538          51.57
   media_mt_p.. |     161,679        313,538          51.57
   media_pb_9~d |     161,680        313,538          51.57
     apr_ef_std |     105,903        313,538          33.78
     rep_ef_std |     118,575        313,538          37.82
     aba_ef_std |     118,575        313,538          37.82
    dist_ef_std |     121,466        313,538          38.74
     apr_em_std |     229,882        313,538          73.32
     rep_em_std |     229,882        313,538          73.32
     aba_em_std |     229,882        313,538          73.32
    dist_em_std |     231,458        313,538          73.82
     ef_outcome |     308,186        313,538          98.29
   ef_outcome~y |           0        313,538           0.00
----------------+-----------------------------------------------


*/
}
save "$folderservidor\pb_saeb_inep_v1.dta", replace

use "$folderservidor\pb_saeb_inep_v1.dta", clear
merge 1:1 codigo_escola ano using "$folderservidor\censo_escolar\censo_escolar_todos.dta"
/*

    Result                           # of obs.
    -----------------------------------------
    not matched                       952,836
        from master                    95,380  (_merge==1)
        from using                    857,456  (_merge==2)

    matched                           218,158  (_merge==3)
    -----------------------------------------


1,170,994 Observations
*/
mdesc ano_saeb - n_turmas_mais_educ_fund_9_9anos


*dropando valores do censo que não tem nem nota nem indicadores de fluxo
drop if _merge == 2
*(857,456 observations deleted)

mdesc ano_saeb - n_turmas_mais_educ_fund_9_9anos

*dropando valores do censo que não tem características no censo
drop if _merge == 1
*(95,380 observations deleted)
*218,158
mdesc ano_saeb - n_turmas_mais_educ_fund_9_9anos

drop _merge

/*
***********************************************************************
SAEB, PB, INDICADORES DE FLUXO, CENSO ESCOLAR, pib per capita
merge com base de pib per capita
***********************************************************************
*/
mdesc codigo_municipio_censo_escolar

/*
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
*/



rename codigo_municipio_censo_escolar cod_munic
merge m:1 cod_munic ano using "$folderservidor\\pib_municipio\pib_capita_municipio_2003_2015_final_14.dta"
/*

    Result                           # of obs.
    -----------------------------------------
    not matched                        59,540
        from master                         0  (_merge==1)
        from using                     59,540  (_merge==2)

    matched                           218,158  (_merge==3)
    -----------------------------------------


*/

drop if _merge==2
*(59,540 observations deleted)

* 218,158 Observations

drop _merge ipca_acumulado_2017 ipca_acumulado_base2003 ipca_acumulado_ano deflator_pib_base2015 deflator_pib_base2003 pib_capita_mil_reais 


merge m:1 cod_munic  using "$folderservidor\\pib_municipio\codigo_uf_cod_munic.dta"

/*

    Result                           # of obs.
    -----------------------------------------
    not matched                         4,140
        from master                         0  (_merge==1)
        from using                      4,140  (_merge==2)

    matched                           218,158  (_merge==3)
    -----------------------------------------


*/

drop if _merge==2
*(4,140 observations deleted)
* 218,158 observations 

drop _merge

sort ano codigo_escola
*analisando os missings das variáveis

mdesc ano_saeb - estado


*n_copiadoras- n_alunos_not_em_ns n_mulheres_em_4 n_mulheres_em_ns são variáveis que tem 100& de missings
drop n_copiadoras- n_alunos_not_em_ns n_mulheres_em_4 n_mulheres_em_ns
*p_profs_em_licen - n_alunos_turma_not_3 são variáveis que tem 100% de missings
drop p_profs_em_licen - n_alunos_turma_not_3
* n_mulheres_diu_em_1 n_brancos_not_em_ns são variáveis que tem 100% de missings
drop n_mulheres_diu_em_1 - n_brancos_not_em_ns 
* m_idade_em_inte_1 - p_alu_transp_publico_em_inte_ns  p_profs_sup_em_inte_1 -p_profs_sup_em_inte_ns 
* são variáveis que tem quase 100% de missings

drop m_idade_em_inte_1 - p_alu_transp_publico_em_inte_ns 
mdesc ano_saeb - estado



tab ano

* dropando variáveis de ensino médio

drop n_turmas_em_1 -  n_turmas_em_inte_ns
drop n_alu_transporte_publico_em_1 - n_alu_transp_publico_em_inte_ns
drop n_profs_em_1 - n_profs_sup_em_inte_ns
drop n_turmas_mais_educ_em_1- n_turmas_mais_educ_em_inte_ns
drop n_mulheres_em_1 - n_mulheres_em_3
drop n_alunos_em_1- p_brancos_em_3
drop p_profs_sup_em_inte_1 - p_profs_sup_em_inte_ns


*analisando a distribuição ao longo dos anos das variáveis de números 

* temos dois tipos de ensino fundamental final: 
* um em que os anos estão separados em anos
* um em que os anos estão separados em série
tab ano if n_turmas_fund_5_8anos != .
tab ano if n_turmas_fund_5_8anos == .

tab ano if n_turmas_fund_6_9anos != .
tab ano if n_turmas_fund_6_9anos == .


* como eles estão separados em quatro anos, vamos agregar em um único tipo

foreach var of varlist n_turmas_fund_5_8anos-n_turmas_fund_9_9anos{ 
	replace `var' = 0 if `var'==.
}

gen n_turmas_fund_5_6 = n_turmas_fund_5_8anos + n_turmas_fund_6_9anos
gen n_turmas_fund_6_7 = n_turmas_fund_6_8anos + n_turmas_fund_7_9anos
gen n_turmas_fund_7_8 = n_turmas_fund_7_8anos + n_turmas_fund_8_9anos
gen n_turmas_fund_8_9 = n_turmas_fund_8_8anos + n_turmas_fund_9_9anos
drop n_turmas_fund_5_8anos - n_turmas_fund_9_9anos


tab ano if n_alunos_fund_5_8anos != .
tab ano if n_alunos_fund_5_8anos == .

tab ano if n_alunos_fund_9_9anos != .
tab ano if n_alunos_fund_9_9anos == .
/*

. tab ano if n_alunos_fund_5_8anos != .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     21,300        9.76        9.76
       2008 |     21,890       10.03       19.80
       2009 |     21,977       10.07       29.87
       2010 |     22,117       10.14       40.01
       2011 |     22,152       10.15       50.16
       2012 |     22,338       10.24       60.40
       2013 |     22,401       10.27       70.67
       2014 |     22,162       10.16       80.83
       2015 |     41,816       19.17      100.00
------------+-----------------------------------
      Total |    218,153      100.00

. tab ano if n_alunos_fund_5_8anos == .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |          5      100.00      100.00
------------+-----------------------------------
      Total |          5      100.00

. 
. tab ano if n_alunos_fund_9_9anos != .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     21,300        9.76        9.76
       2008 |     21,890       10.03       19.80
       2009 |     21,977       10.07       29.87
       2010 |     22,117       10.14       40.01
       2011 |     22,152       10.15       50.16
       2012 |     22,338       10.24       60.40
       2013 |     22,401       10.27       70.67
       2014 |     22,162       10.16       80.83
       2015 |     41,816       19.17      100.00
------------+-----------------------------------
      Total |    218,153      100.00

. tab ano if n_alunos_fund_9_9anos == .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |          5      100.00      100.00
------------+-----------------------------------
      Total |          5      100.00

*/

foreach var of varlist n_alunos_fund_5_8anos-n_alunos_fund_9_9anos {
replace `var' = 0 if `var'==.
}
gen n_alunos_fund_5_6 = n_alunos_fund_5_8anos + n_alunos_fund_6_9anos
gen n_alunos_fund_6_7 = n_alunos_fund_6_8anos + n_alunos_fund_7_9anos
gen n_alunos_fund_7_8 = n_alunos_fund_7_8anos + n_alunos_fund_8_9anos
gen n_alunos_fund_8_9 = n_alunos_fund_8_8anos + n_alunos_fund_9_9anos
drop n_alunos_fund_5_8anos - n_alunos_fund_9_9anos


tab ano if n_mulheres_fund_5_8anos != .
tab ano if n_mulheres_fund_5_8anos == .

tab ano if n_mulheres_fund_6_9anos != .
tab ano if n_mulheres_fund_6_9anos == .

/*

. tab ano if n_mulheres_fund_5_8anos != .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     21,300        9.76        9.76
       2008 |     21,890       10.03       19.80
       2009 |     21,977       10.07       29.87
       2010 |     22,117       10.14       40.01
       2011 |     22,152       10.15       50.16
       2012 |     22,338       10.24       60.40
       2013 |     22,401       10.27       70.67
       2014 |     22,162       10.16       80.83
       2015 |     41,816       19.17      100.00
------------+-----------------------------------
      Total |    218,153      100.00

. tab ano if n_mulheres_fund_5_8anos == .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |          5      100.00      100.00
------------+-----------------------------------
      Total |          5      100.00

. 
. tab ano if n_mulheres_fund_6_9anos != .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     21,300        9.76        9.76
       2008 |     21,890       10.03       19.80
       2009 |     21,977       10.07       29.87
       2010 |     22,117       10.14       40.01
       2011 |     22,152       10.15       50.16
       2012 |     22,338       10.24       60.40
       2013 |     22,401       10.27       70.67
       2014 |     22,162       10.16       80.83
       2015 |     41,816       19.17      100.00
------------+-----------------------------------
      Total |    218,153      100.00

. tab ano if n_mulheres_fund_6_9anos == .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |          5      100.00      100.00
------------+-----------------------------------
      Total |          5      100.00


*/

foreach var of varlist n_mulheres_fund_5_8anos-n_mulheres_fund_9_9anos {
replace `var' = 0 if `var'==.
}
gen n_mulheres_fund_5_6 = n_mulheres_fund_5_8anos+ n_mulheres_fund_6_9anos 
gen n_mulheres_fund_6_7 = n_mulheres_fund_6_8anos + n_mulheres_fund_7_9anos 
gen n_mulheres_fund_7_8 = n_mulheres_fund_7_8anos + n_mulheres_fund_8_9anos 
gen n_mulheres_fund_8_9 = n_mulheres_fund_8_8anos + n_mulheres_fund_9_9anos
drop n_mulheres_fund_5_8anos - n_mulheres_fund_9_9anos


tab ano if n_brancos_fund_5_8anos != .
tab ano if n_brancos_fund_5_8anos == .

tab ano if n_brancos_fund_9_9anos != .
tab ano if n_brancos_fund_9_9anos == .

/*

. tab ano if n_brancos_fund_5_8anos != .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     21,300        9.76        9.76
       2008 |     21,890       10.03       19.80
       2009 |     21,977       10.07       29.87
       2010 |     22,117       10.14       40.01
       2011 |     22,152       10.15       50.16
       2012 |     22,338       10.24       60.40
       2013 |     22,401       10.27       70.67
       2014 |     22,162       10.16       80.83
       2015 |     41,816       19.17      100.00
------------+-----------------------------------
      Total |    218,153      100.00

. tab ano if n_brancos_fund_5_8anos == .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |          5      100.00      100.00
------------+-----------------------------------
      Total |          5      100.00

. 
. tab ano if n_brancos_fund_9_9anos != .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     21,300        9.76        9.76
       2008 |     21,890       10.03       19.80
       2009 |     21,977       10.07       29.87
       2010 |     22,117       10.14       40.01
       2011 |     22,152       10.15       50.16
       2012 |     22,338       10.24       60.40
       2013 |     22,401       10.27       70.67
       2014 |     22,162       10.16       80.83
       2015 |     41,816       19.17      100.00
------------+-----------------------------------
      Total |    218,153      100.00

. tab ano if n_brancos_fund_9_9anos == .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |          5      100.00      100.00
------------+-----------------------------------
      Total |          5      100.00

*/


foreach var of varlist n_brancos_fund_5_8anos-n_brancos_fund_9_9anos {
replace `var' = 0 if `var'==.
}
gen n_brancos_fund_5_6 = n_brancos_fund_5_8anos + n_brancos_fund_6_9anos 
gen n_brancos_fund_6_7 = n_brancos_fund_6_8anos + n_brancos_fund_7_9anos 
gen n_brancos_fund_7_8 = n_brancos_fund_7_8anos + n_brancos_fund_8_9anos 
gen n_brancos_fund_8_9 = n_brancos_fund_8_8anos + n_brancos_fund_9_9anos

drop n_brancos_fund_5_8anos - n_brancos_fund_9_9anos
tab ano if n_transp_pub_fund_5_8anos != .
tab ano if n_transp_pub_fund_5_8anos == .

tab ano if n_transp_pub_fund_6_9anos != .
tab ano if n_transp_pub_fund_6_9anos == .

/*

. tab ano if n_transp_pub_fund_5_8anos != .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     21,300        9.76        9.76
       2008 |     21,890       10.03       19.80
       2009 |     21,977       10.07       29.87
       2010 |     22,117       10.14       40.01
       2011 |     22,152       10.15       50.16
       2012 |     22,338       10.24       60.40
       2013 |     22,401       10.27       70.67
       2014 |     22,162       10.16       80.83
       2015 |     41,816       19.17      100.00
------------+-----------------------------------
      Total |    218,153      100.00

. tab ano if n_transp_pub_fund_5_8anos == .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |          5      100.00      100.00
------------+-----------------------------------
      Total |          5      100.00

. 
. tab ano if n_transp_pub_fund_6_9anos != .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     21,300        9.76        9.76
       2008 |     21,890       10.03       19.80
       2009 |     21,977       10.07       29.87
       2010 |     22,117       10.14       40.01
       2011 |     22,152       10.15       50.16
       2012 |     22,338       10.24       60.40
       2013 |     22,401       10.27       70.67
       2014 |     22,162       10.16       80.83
       2015 |     41,816       19.17      100.00
------------+-----------------------------------
      Total |    218,153      100.00

. tab ano if n_transp_pub_fund_6_9anos == .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |          5      100.00      100.00
------------+-----------------------------------
      Total |          5      100.00



*/

foreach var of varlist n_transp_pub_fund_5_8anos-n_transp_pub_fund_9_9anos {
replace `var' = 0 if `var'==.
}
gen n_transp_pub_fund_5_6 = n_transp_pub_fund_5_8anos + n_transp_pub_fund_6_9anos 
gen n_transp_pub_fund_6_7 = n_transp_pub_fund_6_8anos + n_transp_pub_fund_7_9anos 
gen n_transp_pub_fund_7_8 = n_transp_pub_fund_7_8anos + n_transp_pub_fund_8_9anos 
gen n_transp_pub_fund_8_9 = n_transp_pub_fund_8_8anos + n_transp_pub_fund_9_9anos

drop n_transp_pub_fund_5_8anos - n_transp_pub_fund_9_9anos

*manter o número de professores com missing, mesmo apesar do grande número
tab ano if n_profs_fund_5_8anos != .
tab ano if n_profs_fund_5_8anos == .

tab ano if n_profs_fund_6_9anos != .
tab ano if n_profs_fund_6_9anos == .


/*

. tab ano if n_profs_fund_5_8anos != .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     21,157        9.71        9.71
       2008 |     21,831       10.02       19.73
       2009 |     21,923       10.06       29.80
       2010 |     22,051       10.12       39.92
       2011 |     22,152       10.17       50.09
       2012 |     22,338       10.25       60.35
       2013 |     22,401       10.28       70.63
       2014 |     22,162       10.17       80.80
       2015 |     41,816       19.20      100.00
------------+-----------------------------------
      Total |    217,831      100.00

. tab ano if n_profs_fund_5_8anos == .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |        148       45.26       45.26
       2008 |         59       18.04       63.30
       2009 |         54       16.51       79.82
       2010 |         66       20.18      100.00
------------+-----------------------------------
      Total |        327      100.00

. 
. tab ano if n_profs_fund_6_9anos != .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     21,157        9.71        9.71
       2008 |     21,831       10.02       19.73
       2009 |     21,923       10.06       29.80
       2010 |     22,051       10.12       39.92
       2011 |     22,152       10.17       50.09
       2012 |     22,338       10.25       60.35
       2013 |     22,401       10.28       70.63
       2014 |     22,162       10.17       80.80
       2015 |     41,816       19.20      100.00
------------+-----------------------------------
      Total |    217,831      100.00

. tab ano if n_profs_fund_6_9anos == .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |        148       45.26       45.26
       2008 |         59       18.04       63.30
       2009 |         54       16.51       79.82
       2010 |         66       20.18      100.00
------------+-----------------------------------
      Total |        327      100.00

*/

gen n_profs_fund_5_6 = n_profs_fund_5_8anos + n_profs_fund_6_9anos 
gen n_profs_fund_6_7 = n_profs_fund_6_8anos + n_profs_fund_7_9anos 
gen n_profs_fund_7_8 = n_profs_fund_7_8anos + n_profs_fund_8_9anos 
gen n_profs_fund_8_9 = n_profs_fund_8_8anos + n_profs_fund_9_9anos
drop n_profs_fund_5_8anos - n_profs_fund_9_9anos

tab ano if n_profs_sup_fund_5_8anos != .
tab ano if n_profs_sup_fund_5_8anos == .

tab ano if n_profs_sup_fund_6_9anos != .
tab ano if n_profs_sup_fund_6_9anos == .

/*

. tab ano if n_profs_sup_fund_5_8anos != .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     21,157        9.71        9.71
       2008 |     21,831       10.02       19.73
       2009 |     21,923       10.06       29.80
       2010 |     22,051       10.12       39.92
       2011 |     22,152       10.17       50.09
       2012 |     22,338       10.25       60.35
       2013 |     22,401       10.28       70.63
       2014 |     22,162       10.17       80.80
       2015 |     41,816       19.20      100.00
------------+-----------------------------------
      Total |    217,831      100.00

. tab ano if n_profs_sup_fund_5_8anos == .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |        148       45.26       45.26
       2008 |         59       18.04       63.30
       2009 |         54       16.51       79.82
       2010 |         66       20.18      100.00
------------+-----------------------------------
      Total |        327      100.00

. 
. tab ano if n_profs_sup_fund_6_9anos != .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     21,157        9.71        9.71
       2008 |     21,831       10.02       19.73
       2009 |     21,923       10.06       29.80
       2010 |     22,051       10.12       39.92
       2011 |     22,152       10.17       50.09
       2012 |     22,338       10.25       60.35
       2013 |     22,401       10.28       70.63
       2014 |     22,162       10.17       80.80
       2015 |     41,816       19.20      100.00
------------+-----------------------------------
      Total |    217,831      100.00

. tab ano if n_profs_sup_fund_6_9anos == .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |        148       45.26       45.26
       2008 |         59       18.04       63.30
       2009 |         54       16.51       79.82
       2010 |         66       20.18      100.00
------------+-----------------------------------
      Total |        327      100.00

*/

gen n_profs_sup_fund_5_6 = n_profs_sup_fund_5_8anos + n_profs_sup_fund_6_9anos 
gen n_profs_sup_fund_6_7 = n_profs_sup_fund_6_8anos + n_profs_sup_fund_7_9anos 
gen n_profs_sup_fund_7_8 = n_profs_sup_fund_7_8anos + n_profs_sup_fund_8_9anos 
gen n_profs_sup_fund_8_9 = n_profs_sup_fund_8_8anos + n_profs_sup_fund_9_9anos
drop n_profs_sup_fund_5_8anos - n_profs_sup_fund_9_9anos

tab ano if n_turmas_mais_educ_fund_5_8anos != .
tab ano if n_turmas_mais_educ_fund_5_8anos == .

tab ano if n_turmas_mais_educ_fund_6_9anos != .
tab ano if n_turmas_mais_educ_fund_6_9anos == .

/*

. tab ano if n_turmas_mais_educ_fund_5_8anos != .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2015 |     41,816      100.00      100.00
------------+-----------------------------------
      Total |     41,816      100.00

. tab ano if n_turmas_mais_educ_fund_5_8anos == .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     21,305       12.08       12.08
       2008 |     21,890       12.41       24.50
       2009 |     21,977       12.46       36.96
       2010 |     22,117       12.54       49.50
       2011 |     22,152       12.56       62.06
       2012 |     22,338       12.67       74.73
       2013 |     22,401       12.70       87.43
       2014 |     22,162       12.57      100.00
------------+-----------------------------------
      Total |    176,342      100.00

. 
. tab ano if n_turmas_mais_educ_fund_6_9anos != .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2015 |     41,816      100.00      100.00
------------+-----------------------------------
      Total |     41,816      100.00

. tab ano if n_turmas_mais_educ_fund_6_9anos == .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     21,305       12.08       12.08
       2008 |     21,890       12.41       24.50
       2009 |     21,977       12.46       36.96
       2010 |     22,117       12.54       49.50
       2011 |     22,152       12.56       62.06
       2012 |     22,338       12.67       74.73
       2013 |     22,401       12.70       87.43
       2014 |     22,162       12.57      100.00
------------+-----------------------------------
      Total |    176,342      100.00

*/


gen n_turmas_mais_educ_fund_5_6 = n_turmas_mais_educ_fund_5_8anos + n_turmas_mais_educ_fund_6_9anos 
gen n_turmas_mais_educ_fund_6_7 = n_turmas_mais_educ_fund_6_8anos + n_turmas_mais_educ_fund_7_9anos 
gen n_turmas_mais_educ_fund_7_8 = n_turmas_mais_educ_fund_7_8anos + n_turmas_mais_educ_fund_8_9anos 
gen n_turmas_mais_educ_fund_8_9 = n_turmas_mais_educ_fund_8_8anos + n_turmas_mais_educ_fund_9_9anos
drop n_turmas_mais_educ_fund_5_8anos - n_turmas_mais_educ_fund_9_9anos

foreach var of varlist m_idade_fund_5_8anos-m_idade_fund_9_9anos {
replace `var' = 0 if `var'==.
}

foreach var of varlist p_mulheres_fund_5_8anos-p_mulheres_fund_9_9anos {
replace `var' = 0 if `var'==.
}
foreach var of varlist p_brancos_fund_5_8anos-p_brancos_fund_9_9anos {
replace `var' = 0 if `var'==.
}
foreach var of varlist p_transp_pub_fund_5_8anos-p_transp_pub_fund_9_9anos {
replace `var' = 0 if `var'==.
}
foreach var of varlist p_profs_sup_fund_5_8anos-p_profs_sup_fund_9_9anos {
replace `var' = 0 if `var'==.
}

gen m_idade_fund_5_6 = (m_idade_fund_5_8anos + m_idade_fund_6_9anos)/2 
gen m_idade_fund_6_7 = (m_idade_fund_6_8anos + m_idade_fund_7_9anos)/2
gen m_idade_fund_7_8 = (m_idade_fund_7_8anos + m_idade_fund_8_9anos)/2
gen m_idade_fund_8_9 = (m_idade_fund_8_8anos + m_idade_fund_9_9anos)/2

drop m_idade_fund_5_8anos - m_idade_fund_9_9anos

gen p_mulheres_fund_5_6 = (p_mulheres_fund_5_8anos + p_mulheres_fund_6_9anos)/2 
gen p_mulheres_fund_6_7 = (p_mulheres_fund_6_8anos + p_mulheres_fund_7_9anos)/2 
gen p_mulheres_fund_7_8 = (p_mulheres_fund_7_8anos + p_mulheres_fund_8_9anos)/2
gen p_mulheres_fund_8_9 = (p_mulheres_fund_8_8anos + p_mulheres_fund_9_9anos)/2
drop p_mulheres_fund_5_8anos - p_mulheres_fund_9_9anos

gen p_brancos_fund_5_6 = (p_brancos_fund_5_8anos + p_brancos_fund_6_9anos)/2 
gen p_brancos_fund_6_7 = (p_brancos_fund_6_8anos + p_brancos_fund_7_9anos)/2
gen p_brancos_fund_7_8 = (p_brancos_fund_7_8anos + p_brancos_fund_8_9anos)/2 
gen p_brancos_fund_8_9 = (p_brancos_fund_8_8anos + p_brancos_fund_9_9anos)/2
drop p_brancos_fund_5_8anos - p_brancos_fund_9_9anos

gen p_transp_pub_fund_5_6 = (p_transp_pub_fund_5_8anos + p_transp_pub_fund_6_9anos)/2 
gen p_transp_pub_fund_6_7 = (p_transp_pub_fund_6_8anos + p_transp_pub_fund_7_9anos)/2 
gen p_transp_pub_fund_7_8 = (p_transp_pub_fund_7_8anos + p_transp_pub_fund_8_9anos)/2 
gen p_transp_pub_fund_8_9 = (p_transp_pub_fund_8_8anos + p_transp_pub_fund_9_9anos)/2
drop p_transp_pub_fund_5_8anos - p_transp_pub_fund_9_9anos

gen p_profs_sup_fund_5_6 = (p_profs_sup_fund_5_8anos + p_profs_sup_fund_6_9anos)/2 
gen p_profs_sup_fund_6_7 = (p_profs_sup_fund_6_8anos + p_profs_sup_fund_7_9anos)/2 
gen p_profs_sup_fund_7_8 = (p_profs_sup_fund_7_8anos + p_profs_sup_fund_8_9anos)/2 
gen p_profs_sup_fund_8_9 = (p_profs_sup_fund_8_8anos + p_profs_sup_fund_9_9anos)/2
drop p_profs_sup_fund_5_8anos - p_profs_sup_fund_9_9anos


mdesc ano_saeb - p_profs_sup_fund_8_9

save "$folderservidor\pb_saeb_inep_cidades_censo_escolar_14_v1.dta",replace
/*
**********************************************************
Base de informações do programa
fazendo ajustes da base do programa 
**********************************************************
*/


use "$folderservidor\base_final_ice_14.dta", clear
*dropando escolas somente com informações de alavanca, 
* mas sem informação de data de entrada no programa
drop if ano_ice ==.

tab integral ice_jornada
tab ice_segmento
*ensino_medio indica se escola tem segmento ensino integral
gen ensino_medio=1 
replace ensino_medio = 0 if ice_segmento == "EFII" | ice_segmento == "EF FINAIS" 
tab ice_segmento ensino_medio

order ensino_medio, after(ensino_fundamental)
tab ice_segmento ensino_fundamental

* note que no caso do ensino fundamental, não há o descompasso entre
* fluxo e nota, como havia no caso do ensino médio
* dropando escolas somente com informações de alacanca, mas sem informações
* de data de entrada no programa
	drop if ano_ice ==.

	drop if ano_ice ==2016

	replace ice=1
/*
**********************************************************
PCA
**********************************************************
*/



*verificando a matriz de correlação entre alavancas
corr al_engaj_gov - al_proj if ensino_fundamental ==1

local alavancas al_engaj_gov al_engaj_sec al_time_seduc al_marcos_lei al_todos_marcos al_sel_dir al_sel_prof al_proj_vida
	foreach x in `alavancas'{
	tab `x' if ensino_fundamental ==1
}
	/*

	al_engaj_go |
			  v |      Freq.     Percent        Cum.
	------------+-----------------------------------
			  0 |         18       10.17       10.17
			  1 |        159       89.83      100.00
	------------+-----------------------------------
		  Total |        177      100.00

	al_engaj_se |
			  c |      Freq.     Percent        Cum.
	------------+-----------------------------------
			  0 |          9        5.08        5.08
			  1 |        168       94.92      100.00
	------------+-----------------------------------
		  Total |        177      100.00

	al_time_sed |
			 uc |      Freq.     Percent        Cum.
	------------+-----------------------------------
			  0 |         16        9.04        9.04
			  1 |        161       90.96      100.00
	------------+-----------------------------------
		  Total |        177      100.00

	al_marcos_l |
			 ei |      Freq.     Percent        Cum.
	------------+-----------------------------------
			  1 |        177      100.00      100.00
	------------+-----------------------------------
		  Total |        177      100.00

	al_todos_ma |
		   rcos |      Freq.     Percent        Cum.
	------------+-----------------------------------
			  0 |          5        2.82        2.82
			  1 |        172       97.18      100.00
	------------+-----------------------------------
		  Total |        177      100.00

	 al_sel_dir |      Freq.     Percent        Cum.
	------------+-----------------------------------
			  0 |        176       99.44       99.44
			  1 |          1        0.56      100.00
	------------+-----------------------------------
		  Total |        177      100.00

	al_sel_prof |      Freq.     Percent        Cum.
	------------+-----------------------------------
			  0 |        177      100.00      100.00
	------------+-----------------------------------
		  Total |        177      100.00

	al_proj_vid |
			  a |      Freq.     Percent        Cum.
	------------+-----------------------------------
			  0 |         10        5.65        5.65
			  1 |        167       94.35      100.00
	------------+-----------------------------------
		  Total |        177      100.00

	*/

	* note que al_sel_prof não tem variância
	* note que al_marcos_da_lei não tem variância
	* em geral, é perceptivo a pouca variância nessas dummies de alavanca
	* 

pca al_engaj_gov al_engaj_sec al_time_seduc al_marcos_lei al_todos_marcos al_sel_dir al_sel_prof al_proj_vida if ensino_fundamental ==1

	/*

	. pca al_engaj_gov al_engaj_sec al_time_seduc  al_todos_marcos al_sel_dir al_sel_prof al_proj_vida if ensino_fundamen
	> tal ==1
	(al_sel_prof dropped because of zero variance)

	Principal components/correlation                 Number of obs    =        177
													 Number of comp.  =          4
													 Trace            =          6
		Rotation: (unrotated = principal)            Rho              =     1.0000

		--------------------------------------------------------------------------
		   Component |   Eigenvalue   Difference         Proportion   Cumulative
		-------------+------------------------------------------------------------
			   Comp1 |      3.16875      1.66514             0.5281       0.5281
			   Comp2 |      1.50361      .464427             0.2506       0.7787
			   Comp3 |      1.03918      .750715             0.1732       0.9519
			   Comp4 |      .288466      .288466             0.0481       1.0000
			   Comp5 |            0            0             0.0000       1.0000
			   Comp6 |            0            .             0.0000       1.0000
		--------------------------------------------------------------------------

	Principal components (eigenvectors) 

		--------------------------------------------------------------------
			Variable |    Comp1     Comp2     Comp3     Comp4 | Unexplained 
		-------------+----------------------------------------+-------------
		al_engaj_gov |   0.5292    0.1700    0.1280    0.4255 |           0 
		al_engaj_sec |   0.3981   -0.5213    0.0024    0.5558 |           0 
		al_time_se~c |   0.5303    0.1815   -0.1280   -0.3823 |           0 
		al_todos_m~s |   0.3838   -0.4418    0.3660   -0.5907 |           0 
		  al_sel_dir |  -0.1068    0.2713    0.9038    0.1217 |           0 
		al_proj_vida |   0.3486    0.6306   -0.1282   -0.0114 |           0 
		--------------------------------------------------------------------

	. 

	*/

	* fazendo a análise de componentes principais sem marcos da lei e sem al_sel_prog
pca al_engaj_gov al_engaj_sec al_time_seduc  al_todos_marcos al_sel_dir  al_proj_vida if ensino_fundamental ==1


	/*

	Principal components/correlation                 Number of obs    =        177
													 Number of comp.  =          4
													 Trace            =          6
		Rotation: (unrotated = principal)            Rho              =     1.0000

		--------------------------------------------------------------------------
		   Component |   Eigenvalue   Difference         Proportion   Cumulative
		-------------+------------------------------------------------------------
			   Comp1 |      3.16875      1.66514             0.5281       0.5281
			   Comp2 |      1.50361      .464427             0.2506       0.7787
			   Comp3 |      1.03918      .750715             0.1732       0.9519
			   Comp4 |      .288466      .288466             0.0481       1.0000
			   Comp5 |            0            0             0.0000       1.0000
			   Comp6 |            0            .             0.0000       1.0000
		--------------------------------------------------------------------------

	Principal components (eigenvectors) 

		--------------------------------------------------------------------
			Variable |    Comp1     Comp2     Comp3     Comp4 | Unexplained 
		-------------+----------------------------------------+-------------
		al_engaj_gov |   0.5292    0.1700    0.1280    0.4255 |           0 
		al_engaj_sec |   0.3981   -0.5213    0.0024    0.5558 |           0 
		al_time_se~c |   0.5303    0.1815   -0.1280   -0.3823 |           0 
		al_todos_m~s |   0.3838   -0.4418    0.3660   -0.5907 |           0 
		  al_sel_dir |  -0.1068    0.2713    0.9038    0.1217 |           0 
		al_proj_vida |   0.3486    0.6306   -0.1282   -0.0114 |           0 
		--------------------------------------------------------------------

	*/
screeplot
screeplot, yline(1) ci(het)
predict pc1 pc2 pc3, score
	* analisando os componentes:

	* temos que o componente 1 tem 2 valores positivos altos,
	* alavanca 1 - teve bom engajamento do governador
	* alavanca 2 - teve bom engajamento do secretario de educação
	* alavanca 3 - tinha time da SEDUC dedicado para a implementação do programa 
	* alavanca 4 - teve implantação dos marcos legais na forma da Lei? 
rename pc1 comp_politico

	* temos que o componente 2 tem 1 valor positivo alto, 
	* alavanca 8 - teve Implantação do projeto de vida na Matriz Curricular
rename pc2 comp_proj_vida

	* temps que o componente 3 tem 1 valor positivo alto,
	* alavanca 6 - teve Implantação do processo de seleção e remoção de diretores? 
rename pc3 comp_selecao_remocao_diretores
gen alavancas =.
replace alavancas = 1 if al_engaj_gov !=. & al_engaj_sec !=.
replace alavancas = 0 if al_engaj_gov ==. & al_engaj_sec ==.
gen base_ice = 1

save "$folderservidor\base_final_ice_ef_14.dta", replace


use "$folderservidor\pb_saeb_inep_cidades_censo_escolar_14_v1.dta", clear


merge 1:1 codigo_escola ano using "$folderservidor\censo_escolar\censo_escolar_doc_todos.dta"
/*
    Result                           # of obs.
    -----------------------------------------
    not matched                     2,077,999
        from master                       327  (_merge==1)
        from using                  2,077,672  (_merge==2)

    matched                           217,831  (_merge==3)
    -----------------------------------------

*/
drop if _merge == 2
drop if _merge == 1
drop _merge
merge m:1 codigo_escola using "$folderservidor\base_final_ice_ef_14.dta"
/*
    Result                           # of obs.
    -----------------------------------------
    not matched                       214,304
        from master                   214,166  (_merge==1)
        from using                        138  (_merge==2)

    matched                             3,665  (_merge==3)
    -----------------------------------------


*/
*dropando observações que só estavam na base ICE
drop if _merge == 2
*(138 observations deleted)
drop _merge


sort  codigo_escola ano
format codigo_escola %10.0g
format codigo_municipio_novo %20.0g

*como a base dos microdados não tinham informação sobre ice, temos que:
 
* atribuir o valor 0 para a variável que indica a participação do 
* programa

replace ice = 0 if ice == .

* atribuir o valor 0 para a variável que indica a participação do 
* programa em  um dado ano
forvalues a=2004(1)2015{

replace ice_`a' = 0 if ice_`a' == .
replace ice_`a' = 0 if ice_`a' == .
}

* criar variável que indica se um dado ano é o ano de entrada
* da escola no programa

gen d_ice=0

forvalues x=2004(1)2015{
	replace d_ice=1 if ice_`x'==1 &ano==`x' 
	
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

* note que existe a possibilidade de escolas com ensino fundamental só
* só terem recebido o programa no ensino médio
* assim, para avaliar o impacto do programa na nota do ensino fundamental,
* precisamos atribuir zero as escolas que tem ice somente no EM

replace ice = 0 if d_segmento4 == 1 | d_segmento5 == 1
replace d_ice = 0 if d_segmento4 == 1 | d_segmento5 ==1

forvalues x = 2004(1)2015 {
replace ice_`x' = 0 if d_segmento4 == 1 | d_segmento4 == 1
}


*********** dummy ice integral ************
* criando variável que indica se escola em um dado ano participou do
* ICE integral

gen ice_inte = 0
replace ice_inte = 1 if ice_jornada == "INTEGRAL"
replace ice_inte = 1 if ice_jornada == "Integral"



*********** dummy ice semi - integral ************
* variável que indica se escola em um dado ano participou do ICE 
* semi integral

gen ice_semi_inte = 0
replace ice_semi_inte = 1 if ice_jornada == "Semi-integral"
replace ice_semi_inte = 1 if ice_jornada == "SEMI-INTEGRAL"



*********** dummy interacão entrada no ice e integral ************

* variável que indica se escola em um dado ano entrou no programa
* cuja modalidade de ensino é integral
gen d_ice_inte = d_ice* ice_inte

*********** dummy interacão entrada no ice e semi - integral ************

* variável que indica se escola em um dado
gen d_ice_semi_inte = d_ice * ice_semi_inte


*********** interações programa e alavancas *************************
/*colocando zero nos missings nas dummies de alavancas*/
foreach x in "al_engaj_gov" "al_engaj_sec" "al_time_seduc" "al_marcos_lei" "al_todos_marcos" "al_sel_dir" "al_sel_prof" "al_proj_vida" {
replace `x'=0 if `x'==.
}

/* gerando as interações entre dummy ice e dummies d ealavanca*/

gen al_outros = 0
replace al_outros = 1 if (al_engaj_gov == 1 | al_time_seduc == 1 | al_proj_vida == 1)

* variável que indica se escola, quando entrou no programa:

* alavaanca 1 - teve bom engajamento do governador

gen d_ice_al1 = d_ice * al_engaj_gov

* alavanca 2 - teve bom engajamento do secretário de educação

gen d_ice_al2 = d_ice * al_engaj_sec

* alavanca 3 - tinha time da SEDUC dedicado para a implantação do programa

gen d_ice_al3 = d_ice * al_time_seduc

* alavanca 4 - teve implantação dos marcos legais na forma da Lei?

gen d_ice_al4 = d_ice * al_marcos_lei

* alavanca 5 - teve implantação de todos os marcos legais previstos no cronograma estipulado?

gen d_ice_al5 = d_ice * al_todos_marcos

* alavanca 6 - teve implantação de processo de seleção e remoção de diretores?

gen d_ice_al6 = d_ice * al_sel_dir

* alavanca 7 - teve implantação do processo de seleção e remoção de professores?

gen d_ice_al7 = d_ice * al_sel_prof

* alavanca 8 - teve implantação do projeto de vida na Matriz Curricular?

gen d_ice_al8 = d_ice * al_proj_vida

*********** interações programa e componente principais das alavancas *************************

* lembrando que são três os componentes principais
* componente 1  - componente político
gen d_ice_comp1 = d_ice * comp_politico
* componente 2 - componente projeto de vida
gen d_ice_comp2 = d_ice * comp_proj_vida
* componente 3 -  componente de seleção e remoção de diretores
gen d_ice_comp3 = d_ice * comp_selecao_remocao_diretores


********** interação com mais educação **********************

merge m:1 codigo_escola using "$folderservidor\mais_educacao_todos.dta"

drop if _merge==2
sort ano codigo_escola
gen mais_educ = 0

foreach x of varlist mais_educacao_fund_2010 - mais_educacao_x_2009 n_turmas_mais_educ_fund_5_6 - n_turmas_mais_educ_fund_8_9{
replace mais_educ = 1 if `x' > 0 & `x' != .
}
drop mais_educacao_fund_2010 - mais_educacao_x_2009 n_turmas_mais_educ_fund_5_6 - n_turmas_mais_educ_fund_8_9
drop _merge 
drop uf

/*
**********************************************************
Ajustes Finais na base
**********************************************************
*/

/*--------------------------------------------------------------------*/
* gerando dummies de dependência administrativa
tab dep, gen(d_dep)
/*
	d_dep1 indica se a escola é federal
	d_dep2 indica se a escola é estadual
	d_dep3 indica se a escola é municipal
	d_dep4 indica se a escola é privada
*/
* gerando dummies de estado
tab codigo_uf, gen(d_uf)
/*
codigo_uf |      Freq.     Percent        Cum.
------------+-----------------------------------
	 23 |     11,966        7.72        7.72
	 26 |     15,033        9.69       17.41
	 32 |      6,141        3.96       21.37
	 33 |     29,071       18.75       40.12
	 35 |     79,776       51.44       91.56
	 52 |     13,086        8.44      100.00
------------+-----------------------------------
  Total |    155,073      100.00


*/


* gerando dummies de ano
tab ano, gen(d_ano)

/*--------------------------------------------------------------------*/
* agregando variáveis de número de alunos, mulheres, brancos, e 
* transporte público para ensino fundamental
mdesc n_turmas_fund_5_6 - n_transp_pub_fund_8_9 n_profs_fund_5_6 - n_profs_sup_fund_8_9
gen n_turmas_ef = n_turmas_fund_5_6 + n_turmas_fund_6_7 + n_turmas_fund_7_8 +n_turmas_fund_8_9
gen n_alunos_ef = n_alunos_fund_5_6 + n_alunos_fund_6_7 + n_alunos_fund_7_8 + n_alunos_fund_8_9
gen n_mulheres_ef = n_mulheres_fund_5_6 + n_mulheres_fund_6_7 + n_mulheres_fund_7_8 + n_mulheres_fund_8_9
gen n_brancos_ef = n_brancos_fund_5_6 + n_brancos_fund_6_7 + n_brancos_fund_7_8 + n_brancos_fund_8_9
gen n_transp_pub_ef = n_transp_pub_fund_5_6 + n_transp_pub_fund_6_7 + n_transp_pub_fund_7_8 + n_transp_pub_fund_8_9

/*
/**** Prova Brasil ****/
replace pb_n_partic_5=0 if pb_n_partic_5==.
replace pb_n_partic_9=0 if pb_n_partic_9==.

replace pb_tx_partic_5=pb_tx_partic_5/100 if ano==2011
replace pb_tx_partic_9=pb_tx_partic_9/100 if ano==2011
rename pb_tx_partic_5 taxa_participacao_pb_5
rename pb_tx_partic_9 taxa_participacao_pb_9
gen taxa_participacao_pb_aux_5=pb_n_partic_5/(n_alunos_fund_5_6) if ano==2009
gen taxa_participacao_pb_aux_9=pb_n_partic_9/(n_alunos_fund_8_9) if ano==2009
replace taxa_participacao_pb_5 = taxa_participacao_pb_aux_5 if ano==2009
replace taxa_participacao_pb_9 = taxa_participacao_pb_aux_9 if ano==2009


tab ano if taxa_participacao_pb_9 != .
tab ano if taxa_participacao_pb_9 == .
*/
mdesc ano_saeb- n_transp_pub_ef
* lidando com informações do ice que não estão presentes no resto da base
*drop ice_jornada ice_segmento ano_ice ice_rigor
foreach variable of varlist  ensino_fundamental integral - comp_selecao_remocao_diretores d_rigor1- d_segmento5 d_ice_comp1 - d_ice_comp3{
replace `variable' = 0 if `variable' == .

}
* dropando variáveis com muitos missings
drop codigo_municipio_censo    nome_municipio  in_regular distrito_escola_novo
mdesc ano_saeb- n_transp_pub_ef

order ano_ice, after(ano_prova_brasil)
order nome_escola_censo, after(nome_escola_censo_escolar)
sort codigo_escola ano

*media_pb_9_std
by codigo_escola: gen media_pb_9_std_lag = media_pb_9_std[_n-1] if ano==ano[_n-1]+1
order media_pb_9_std_lag, after(media_pb_9_std)

by codigo_escola: gen media_pb_9_std_lag_lag = media_pb_9_std[_n-2] if ano==ano[_n-2]+2
order media_pb_9_std_lag_lag, after(media_pb_9_std_lag)
sort codigo_escola ano
by codigo_escola: gen rep_ef_std_lag = rep_ef_std[_n-1] if ano==ano[_n-1]+1 
order rep_ef_std_lag, after(rep_ef_std)

by codigo_escola: gen aba_ef_std_lag = aba_ef_std[_n-1] if ano==ano[_n-1]+1 
order aba_ef_std_lag, after(aba_ef_std)
by codigo_escola: gen rep_ef_std_lag_lag = rep_ef_std[_n-2] if ano==ano[_n-2]+2
order rep_ef_std_lag, after(rep_ef_std)

by codigo_escola: gen aba_ef_std_lag_lag = aba_ef_std[_n-2] if ano==ano[_n-2]+2 
order aba_ef_std_lag, after(aba_ef_std)

* precisamos de dummies para indicar a entrada no programa em determinado ano
gen d_entrada_2003 = 0
replace d_entrada_2003 = 1 if ano_ice==2003 & ano==2003


gen d_entrada_2004 = 0
replace d_entrada_2004 = 1 if ano_ice==2004 & ano==2004

gen d_entrada_2005 = 0
replace d_entrada_2005 = 1 if ano_ice==2005 & ano==2005

gen d_entrada_2006 = 0
replace d_entrada_2006 = 1 if ano_ice==2006 & ano==2006

gen d_entrada_2007 = 0
replace d_entrada_2007 = 1 if ano_ice==2007& ano==2007

gen d_entrada_2008 = 0
replace d_entrada_2008 = 1 if ano_ice==2008& ano==2008

gen d_entrada_2009 = 0
replace d_entrada_2009 = 1 if ano_ice==2009& ano==2009

gen d_entrada_2010 = 0
replace d_entrada_2010 = 1 if ano_ice==2010& ano==2010

gen d_entrada_2011 = 0
replace d_entrada_2011 = 1 if ano_ice==2011& ano==2011

gen d_entrada_2012 = 0
replace d_entrada_2012 = 1 if ano_ice==2012& ano==2012

gen d_entrada_2013 = 0
replace d_entrada_2013 = 1 if ano_ice==2013& ano==2013

gen d_entrada_2014 = 0
replace d_entrada_2014 = 1 if ano_ice==2014& ano==2014


gen d_entrada_2015 = 0
replace d_entrada_2015 = 1 if ano_ice==2015& ano==2015

/*
Algumas observações para o pareamento usando a métrica de mahalanobis:
vamos parear escolas tratadas no ano em que elas foram tratadas
assim, vamos para cada ano, vamos parear as escolas que entraram no
tratamento aquele ano, com alguma escola não tratada naquele ano

Ainda, em cada ano, as escolas que entraram no tratamento possuem especificidades
em relação aos dados disponíves
por exemplo, como o sistema educacenso só foi implementado em 2007, de 2004 a 2006
não há alguns dados no censo escolar, nem inidcadores de fluxo

Nas escolas quem entraram no programa de 2004 a 2007,
somente o primeiro ano recebeu o programa
( na prática, as escolas de 2004 a 2007, foram recriadas como novos 
centros, e só aceitaram turmas do primeiro ano, quando foi iniciado o
programa)

Assim, temos que parear as escolas ano a ano, levando em conta 
as especificidades daquela escola
*/

* note que não há opção if no mahapick
* assim, vamos criar uma nova variável de identificação para escola em um 
* dado ano
gen codigo_escola_2003 = .
replace codigo_escola_2003 = codigo_escola if ano== 2003

gen codigo_escola_2004 = .
replace codigo_escola_2004 = codigo_escola if ano== 2004

gen codigo_escola_2005 = .
replace codigo_escola_2005 = codigo_escola if ano == 2005

gen codigo_escola_2006 = .
replace codigo_escola_2006 = codigo_escola if ano == 2006

gen codigo_escola_2007 = .
replace codigo_escola_2007 = codigo_escola if ano == 2007

gen codigo_escola_2008 = . 
replace codigo_escola_2008 = codigo_escola if ano == 2008

gen codigo_escola_2009 = .
replace codigo_escola_2009 = codigo_escola if ano == 2009

gen codigo_escola_2010 = . 
replace codigo_escola_2010 = codigo_escola if ano == 2010

gen codigo_escola_2011 = .
replace codigo_escola_2011 = codigo_escola if ano == 2011

gen codigo_escola_2012 = . 
replace codigo_escola_2012 = codigo_escola if ano == 2012

gen codigo_escola_2013 = .
replace codigo_escola_2013 = codigo_escola if ano == 2013

gen codigo_escola_2014 = . 
replace codigo_escola_2014 = codigo_escola if ano == 2014

gen codigo_escola_2015 = .
replace codigo_escola_2015 = codigo_escola if ano == 2015

* gerando as variáveis que definem os matchs de cada ano
gen d_match_2003 = .

gen d_match_2004 = .
gen d_match_2005 = . 
gen d_match_2006 = .
gen d_match_2007 = .
gen d_match_2008 = .
gen d_match_2009 = .
gen d_match_2010 = .
gen d_match_2011 = .
gen d_match_2012 = .
gen d_match_2013 = .
gen d_match_2014 = .
gen d_match_2015 = .

* gerando dummy de primeiro ano de participação de enem
gen d_pb = .
replace d_pb = 1 if pb ==1
replace d_pb = 0 if pb ==.
order d_pb,after(pb)
*by codigo_escola (ano), sort: gen byte first = sum(d_enem) == 1

by codigo_escola (ano), sort: gen noccur = sum(d_pb)
by codigo_escola: gen byte first = noccur == 1  & noccur[_n - 1] != noccur

sort codigo_escola ano

order first, after(d_pb)
rename first d_entrada_pb

egen any_ice = max(ice), by(codigo_escola) 

gen escola_ice =0
replace escola_ice = 1 if ano_ice !=.
*escola_ice indica todas as escolas que receberam o programa, sejam elas 
*ensino médio ou ensino fundamental

gen escola_ice_em = 0 
replace escola_ice_em = 1 if ano_ice !=. & ensino_medio ==1

gen escola_ice_ef = 0 
replace escola_ice_ef = 1 if ano_ice !=. & ensino_fundamental==1


gen d_entrada_pb_2004 = 0
replace d_entrada_pb_2004 = 1 if d_entrada_pb==1 & ano==2004 & escola_ice_ef==1
gen d_entrada_pb_2005 = 0
replace d_entrada_pb_2005 = 1 if d_entrada_pb==1 & ano==2005 & escola_ice_ef==1
gen d_entrada_pb_2006 = 0
replace d_entrada_pb_2006 = 1 if d_entrada_pb==1 & ano==2006 & escola_ice_ef==1
gen d_entrada_pb_2007 = 0
replace d_entrada_pb_2007 = 1 if d_entrada_pb==1 & ano==2007 & escola_ice_ef==1
gen d_entrada_pb_2008 = 0
replace d_entrada_pb_2008 = 1 if d_entrada_pb==1 & ano==2008 & escola_ice_ef==1
gen d_entrada_pb_2009 = 0
replace d_entrada_pb_2009 = 1 if d_entrada_pb==1 & ano==2009 & escola_ice_ef==1
gen d_entrada_pb_2010 = 0
replace d_entrada_pb_2010 = 1 if d_entrada_pb==1 & ano==2010 & escola_ice_ef==1
gen d_entrada_pb_2011 = 0
replace d_entrada_pb_2011 = 1 if d_entrada_pb==1 & ano==2011 & escola_ice_ef==1
gen d_entrada_pb_2012 = 0
replace d_entrada_pb_2012 = 1 if d_entrada_pb==1 & ano==2012 & escola_ice_ef==1
gen d_entrada_pb_2013 = 0
replace d_entrada_pb_2013 = 1 if d_entrada_pb==1 & ano==2013 & escola_ice_ef==1
gen d_entrada_pb_2014 = 0
replace d_entrada_pb_2014 = 1 if d_entrada_pb==1 & ano==2014 & escola_ice_ef==1

gen d_entrada_pb_2015 = 0
replace d_entrada_pb_2015 = 1 if d_entrada_pb==1 & ano==2015 & escola_ice_ef==1



order ice censo_escolar pb saeb ef_fluxo ano ano_ice ano_prova_brasil ano_saeb
replace pb = 1 if ano_prova_brasil !=.	



gen ano_ice_impar =.

replace ano_ice_impar = ano_ice if mod(ano_ice,2)==1
*replace ano_ice_impar = ano_ice - 1 if mod(ano_ice,2)==0
replace ano_ice_impar = ano_ice + 1 if mod(ano_ice,2)==0

order ano_ice_impar, after(ano_ice)
xtset codigo_escola ano_prova_brasil

keep if pb==1
*DV indica quando a escola entrou na base
*como mantemos somente as escolas que participaram da prova brasil
* então DV indicará quando a escola apareceu pela primeira vez na 
* base da prova brasil
gen DV = 0
bysort codigo_escola (ano): replace DV = 1 if _n == 1
order DV, after(codigo_escola)
sort ano_ice codigo_escola ano  

gen n_prof_total_ef = n_prof_ef_todos_ef_incomp + n_prof_ef_todos_ef_comp + n_prof_ef_todos_em + n_prof_ef_todos_sup

*verificando se o numero total de professores do ensino fundamental é o mesmo nas duas variáveis
gen n_prof_ef_igual = 0
replace n_prof_ef_igual = 1 if  n_prof_total_ef == n_prof_ef
tab n_prof_ef_igual
/*

n_prof_ef_i |
       gual |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |     56,471      100.00      100.00
------------+-----------------------------------
      Total |     56,471      100.00



*/
gen p_ef_superior = .
replace p_ef_superior = n_prof_ef_todos_sup/n_prof_ef
order n_prof_total_ef p_ef_superior, after (n_prof_ef_todos_sup)

save "$folderservidor\dados_EF_14_v3.dta",replace
save "\\tsclient\C\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\dados_EF_14_v3.dta", replace
log close
