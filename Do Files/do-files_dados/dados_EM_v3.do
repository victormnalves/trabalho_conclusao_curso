/*****************************************************************************
******************************************************************************

DADOS - Ensino médio

******************************************************************************
******************************************************************************/

**02/04/2019
**diferença para a versão 2: inclusão de informações sobre professores

/*
mergeando as seguintes bases:
enem
pib per capita e população das cidades
variáveis de fluxo - indicadores do inep


criando os códigos de município
padronizando as notas 



merge da base resultado do processo anterior com 
censo escolar

mantendo somente observações que tem informações em ambas as bases

arrumando base com informações sobre o programa

	pca
	gerando dummies de participação por ano separando fluxo e nota
	
informações do mais educação
ajustes finais
	dummy dependência administrativa
	dummies estado
	dummies ano
	variáveis de número de alunos, mulheres, e brancos
	variável de taxa de participação

	


*/
sysdir set PLUS \\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\ado
capture log close
clear all
set more off, permanently

global folderservidor "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"
log using "$folderservidor\\logfiles/dados_EM_v3.log", replace


use "$folderservidor\enem\enem_todos.dta", clear

/*
***********************************************************************
ENEM - 
limpando a base, dropando variáveis com muitos missings
***********************************************************************
*/

/*
mantendo somente variáveis que não tem missings aparentemente sistemáticos
*/

# delimit ;
keep 
concluir_em_ano_enem 
codigo_municipio 
ano_enem 
e_mora_mais_de_6_pessoas 
e_mora_mais_de_7_pessoas 
e_escol_sup_pai 
e_escol_sup_mae 
e_renda_familia_5_salarios 
e_automovel 
e_casa_propria 
e_trabalhou_ou_procurou 
e_trabalhou 
codigo_escola 
enem_nota_objetiva 
enem_nota_redacao 
enem_nota_matematica 
enem_nota_linguagens 
enem_nota_humanas 
enem_nota_ciencias 
e_tem_filho 
e_renda_familia_6_salarios
;
# delimit cr

* variável e_trabalhou só de 2010 até 2015 e e_trabalhou_ou_procurou 
* só de 2003 até 2009
replace e_trabalhou_ou_procurou = e_trabalhou if ano > 2009
tab ano if e_trabalhou_ou_procurou !=.
tab ano if e_trabalhou !=.


* variável e_renda_familia_6_salarios só em 2010 e e_renda_familia_5_salarios 
* em todos os anos menos em 2010
replace e_renda_familia_5_salarios = e_renda_familia_6_salarios if ano ==2010

tab ano if e_renda_familia_5_salarios !=.
tab ano if e_renda_familia_6_salarios !=.


* variável e_mora_mais_de_6_pessoas não está em 2010. usar e_mora_mais_de_7_pessoas
replace e_mora_mais_de_6_pessoas = e_mora_mais_de_7_pessoas if ano ==2010

tab ano if e_mora_mais_de_6_pessoas !=.
tab ano if e_mora_mais_de_7_pessoas !=.


* e_mora_mais_de_7_pessoas e_renda_familia_6_salarios 
* e_trabalhou e_automovel e_tem_filho e_casa_propria
* tem missings sistemáticos
* análise dos missings feitas no arquivo enem_missings_14

# delimit ;
 
drop 
e_mora_mais_de_7_pessoas 
e_renda_familia_6_salarios 
e_trabalhou 
e_automovel 
e_tem_filho 
e_casa_propria
;
# delimit cr

* analisando missings
mdesc concluir_em_ano_enem - enem_nota_ciencias

/*

    Variable    |     Missing          Total     Percent Missing
----------------+-----------------------------------------------
   concluir_e~m |           0        353,666           0.00
   codigo_mun~o |          63        353,666           0.02
       ano_enem |           0        353,666           0.00
   enem_nota~va |     220,417        353,666          62.32
   enem_nota_~o |       1,127        353,666           0.32
   e_mora_mai~s |       7,083        353,666           2.00
   e_escol_su~i |       9,302        353,666           2.63
   e_escol_su~e |       8,064        353,666           2.28
   e_renda_fa~s |       7,134        353,666           2.02
   e_trabalho~u |      10,178        353,666           2.88
   codigo_esc~a |          11        353,666           0.00
   enem_nota~ca |     141,576        353,666          40.03
   enem_nota~ns |     141,576        353,666          40.03
   enem_not~nas |     140,913        353,666          39.84
   enem_not~ias |     140,913        353,666          39.84
----------------+-----------------------------------------------

*/


sort ano codigo_escola
drop if codigo_escola ==.
gen enem = 1
gen ano = ano_enem
save "$folderservidor\enem\enem_todos_limpo.dta", replace 

/*
***********************************************************************
Variáveis do INEP
mergeando com dados de indicadores de fluxo
***********************************************************************
*/

* até aqui, todas as variáveis do enem, com exceção das notas, 
* estão bem ajustadas
* vamos mergear as informações de fluxo, 
* presentes na base dos indicadores do INEP
* mas antes, vamos manter somente as escolas do ensino médio

use "$folderservidor\indicadores_inep\fluxo_2007a2015.dta", clear
keep if dist_em!=. | aba_em!= . | rep_em!= .  | apr_em != .
*(467,460 observations deleted)
*104,129 observations
gen em_fluxo =1
save "$folderservidor\indicadores_inep\fluxo_2007a2015_em.dta", replace
/*
***********************************************************************
ENEM, INDICADORES DE FLUXO, CENSO ESCOLAR
merge da base enem com indicadores do inep
padronização das notas
merge com censo escolar
***********************************************************************

*/
* colocando uma dummy que indica que a escola tem dados do censo escolar

use "$folderservidor\censo_escolar\censo_escolar_todos.dta", clear

capture gen censo_escolar = 1
capture gen ano_censo_escolar = ano
order censo_escolar

*atribuindo para cada escola um codigo de municipio
*rename codigo_municipio codigo_municipio_censo

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

. 
note que aqui só usamos no using dados do censo de 2007 até 2015.
portanto, as 18, 568 escolas no master são escolas que já possuem
codigo de municipio, pois na agregação essa informação foi 
passada

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
*rename codigo_municipio codigo_municipio_censo_escolar
order nome_escola, after(no_entidade)
rename nome_escola nome_escola_censo
rename no_entidade nome_escola_censo_escolar
* dropando variáveis incompletas ou desnecessárias
drop UF SIGLA nome_municipio sigla
drop mascara
save "$folderservidor\censo_escolar\censo_escolar_munic.dta", replace
*/

use "$folderservidor\enem\enem_todos_limpo.dta", clear 

drop if codigo_escola==.
*(0 observations deleted)
merge 1:1 codigo_escola ano using "$folderservidor\indicadores_inep\fluxo_2007a2015_em.dta"

/*

    Result                           # of obs.
    -----------------------------------------
    not matched                       261,538
        from master                   255,532  (_merge==1)
        from using                      6,006  (_merge==2)

    matched                            98,123  (_merge==3)
    -----------------------------------------


*/
drop _m
sort ano codigo_escola

*drop apr_ef rep_ef aba_ef dist_ef

/*
***********************************************************************
Padronizando Notas e variáveis de fluxo
***********************************************************************
*/

*aqui, vamos padronizar cada nota e variável de fluxo dentro de cada ano
*assim, cada ano terá média zero e dp 1

*gerando uma nota objetiva para os anos em que só há quatro provas

gen enem_nota_objetivab = (enem_nota_matematica + enem_nota_ciencias + enem_nota_humanas + enem_nota_linguagens)/4
replace enem_nota_objetivab = enem_nota_objetiva if ano < 2009


* padronizando dentro dos anos
foreach x in "enem_nota_objetiva" "enem_nota_objetivab" "enem_nota_redacao" "enem_nota_matematica" "enem_nota_ciencias" "enem_nota_humanas" "enem_nota_linguagens"   "apr_em"  "rep_em"  "aba_em"  "dist_em" {
	gen `x'_std = .
foreach a in 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 {
	egen `x'_std_`a' = std(`x') if ano == `a'
	replace `x'_std = `x'_std_`a' if ano == `a'
	drop `x'_std_`a'
}
}

foreach x in "enem_nota_objetiva_std" "enem_nota_objetivab_std" "enem_nota_redacao_std" "enem_nota_matematica_std" "enem_nota_ciencias_std" "enem_nota_humanas_std" "enem_nota_linguagens_std"  "apr_em_std"  "rep_em_std"  "aba_em_std"  "dist_em_std" {
sum `x'
}
forvalues a = 2003(1)2015{
foreach x in "enem_nota_objetiva_std" "enem_nota_objetivab_std" "enem_nota_redacao_std" "enem_nota_matematica_std" "enem_nota_ciencias_std" "enem_nota_humanas_std" "enem_nota_linguagens_std"  "apr_em_std"  "rep_em_std"  "aba_em_std"  "dist_em_std" {
sum `x' if ano ==`a'
}
}
*parece estar padronizado nos anos

mdesc codigo_escola - dist_em_std
/*
    Variable    |     Missing          Total     Percent Missing
----------------+-----------------------------------------------
   codigo_esc~a |           0        359,661           0.00
            ano |           0        359,661           0.00
       ano_enem |       6,006        359,661           1.67
      cod_munic |       6,058        359,661           1.68
   codigo_mun~o |       6,058        359,661           1.68
       cod_meso |       6,058        359,661           1.68
   nome_munic~o |       6,058        359,661           1.68
      codigo_uf |       6,058        359,661           1.68
         estado |       6,058        359,661           1.68
            pib |       6,058        359,661           1.68
            pop |       6,058        359,661           1.68
   pib_capita~s |       6,058        359,661           1.68
   pib_cap~2003 |       6,058        359,661           1.68
   pib_cap~2015 |       6,058        359,661           1.68
   concluir_e~m |       6,006        359,661           1.67
   e_mora_mai~s |      13,089        359,661           3.64
   e_escol_su~i |      15,308        359,661           4.26
   e_escol_su~e |      14,070        359,661           3.91
   e_renda_fa~s |      13,140        359,661           3.65
   e_trabalho~u |      16,184        359,661           4.50
   enem_nota~va |     226,418        359,661          62.95
   enem_nota~ca |     147,576        359,661          41.03
   enem_nota~ns |     147,576        359,661          41.03
   enem_not~nas |     146,913        359,661          40.85
   enem_not~ias |     146,913        359,661          40.85
   enem_nota_~o |       7,133        359,661           1.98
         apr_ef |     281,049        359,661          78.14
         apr_em |     257,080        359,661          71.48
         rep_ef |     276,012        359,661          76.74
         rep_em |     257,080        359,661          71.48
         aba_ef |     276,012        359,661          76.74
         aba_em |     257,080        359,661          71.48
        dist_ef |     276,396        359,661          76.85
        dist_em |     259,107        359,661          72.04
       em_fluxo |     255,532        359,661          71.05
   enem_nota_~b |      14,442        359,661           4.02
   enem_~va_std |     226,418        359,661          62.95
   enem_n~b_std |      14,442        359,661           4.02
   enem_n~o_std |       7,133        359,661           1.98
   enem_~ca_std |     147,576        359,661          41.03
   enem~ias_std |     146,913        359,661          40.85
   enem~nas_std |     146,913        359,661          40.85
   enem_~ns_std |     147,576        359,661          41.03
     apr_em_std |     257,080        359,661          71.48
     rep_em_std |     257,080        359,661          71.48
     aba_em_std |     257,080        359,661          71.48
    dist_em_std |     259,107        359,661          72.04
----------------+-----------------------------------------------

*/




/*
*************************************************************************
CENSO ESCOLAR
merge com o censo escolar
*************************************************************************
*/


*merge 1:1 codigo_escola ano using "$folderservidor\censo_escolar\censo_escolar_munic.dta"
merge 1:1 codigo_escola ano using "$folderservidor\censo_escolar\censo_escolar_todos.dta"

/*

    Result                           # of obs.
    -----------------------------------------
    not matched                     1,113,117
        from master                   198,582  (_merge==1)
        from using                    914,535  (_merge==2)

    matched                           161,079  (_merge==3)
    -----------------------------------------


*/

order enem censo_escolar em_fluxo
/*
*mantendo somente observações que tem características no CENSO, e que tem nota ou indicadores de fluxo
drop if _merge == 2 
*(914,535 observations deleted)
*/

* vamos manter escolas que tem informaçoes no censo
* informações sobre enem e fluxo são importantes, mas não serão determinantes para
* mater a escola na base

* isso porque escolas só tem informações de fluxo a partir de 2007 com o educacenso

* assim, ao drop if _merge==2, estaremos tirando todas as escolas pré 2007 sem enem
* dropando escolas que não tem informações no censo
drop if _merge == 1
*(198,582 observations deleted)
drop _merge

sort ano codigo_escola

mdesc codigo_municipio_censo_escolar
rename codigo_municipio codigo_municipio_enem
order codigo_municipio_enem, after(codigo_municipio_censo_escolar)

drop codigo_municipio_novo codigo_municipio_enem codigo_municipio_censo
rename codigo_municipio_censo_escolar cod_munic

rename codigo_uf codigo_uf_enem


/*
***********************************************************************
Municípios
arrumando código dos municípios, mergeando com dados
de pib pib per capita população
***********************************************************************
*/
* os primeiros dois digitos e os ultimos cinco dão o codigo
* do município


merge m:1 cod_munic ano using "$folderservidor\\pib_municipio\pib_capita_municipio_2003_2015_final_14.dta"

/*

    Result                           # of obs.
    -----------------------------------------
    not matched                        53,820
        from master                         0  (_merge==1)
        from using                     53,820  (_merge==2)

    matched                         1,075,614  (_merge==3)
    -----------------------------------------

. 

*/

drop if _merge==2
drop if _merge==1

/*

. drop if _merge==2
(53,820 observations deleted)

. drop if _merge==1
(0 observations deleted)




*/
drop _merge ipca_acumulado_2017 ipca_acumulado_base2003 ipca_acumulado_ano deflator_pib_base2015 deflator_pib_base2003 pib_capita_mil_reais 
merge m:1 cod_munic  using "$folderservidor\\pib_municipio\codigo_uf_cod_munic.dta"

/*

    Result                           # of obs.
    -----------------------------------------
    not matched                         4,140
        from master                         0  (_merge==1)
        from using                      4,140  (_merge==2)

    matched                         1,075,614  (_merge==3)
    -----------------------------------------


*/
drop if _merge ==2
drop _merge

*vamos reordernar as variáveis na tabela para faciliar a manipulação das notas


order enem censo_escolar em_fluxo  ano_enem ano codigo_escola nome_escola_censo_escolar cod_munic nome_municipio codigo_uf estado cod_meso pop pib pib_capita_reais pib_capita_reais_real_2003 pib_capita_reais_real_2015 enem_nota_objetiva_std enem_nota_objetivab_std enem_nota_redacao_std enem_nota_matematica_std enem_nota_ciencias_std enem_nota_humanas_std enem_nota_linguagens_std apr_em_std rep_em_std aba_em_std dist_em_std

*dropando variáveis não padronizadas
*drop enem_nota_objetiva enem_nota_redacao enem_nota_matematica enem_nota_linguagens enem_nota_humanas enem_nota_ciencias apr_ef apr_em rep_ef rep_em aba_ef aba_em dist_ef dist_em enem_nota_objetivab


sort codigo_escola ano




* vamos descartar as variáveis sobre ensino fundamental, pois estamos
* em uma análise do EM (com exceçao dos outcomes do ef, que serão
* usados para placebo
drop n_turmas_fund_5_8anos - n_turmas_fund_9_9anos n_alunos_fund_5_8anos - n_alunos_fund_9_9anos n_mulheres_fund_5_8anos - n_mulheres_fund_9_9anos n_brancos_fund_5_8anos - n_brancos_fund_9_9anos n_transp_pub_fund_5_8anos - n_transp_pub_fund_9_9anos m_idade_fund_5_8anos - m_idade_fund_9_9anos p_mulheres_fund_5_8anos - p_mulheres_fund_9_9anos p_brancos_fund_5_8anos - p_brancos_fund_9_9anos p_transp_pub_fund_5_8anos - p_transp_pub_fund_9_9anos n_profs_fund_5_8anos - p_profs_sup_fund_9_9anos n_turmas_mais_educ_fund_5_8anos - n_turmas_mais_educ_fund_9_9anos
mdesc codigo_escola - n_turmas_mais_educ_em_inte_ns

{/*

. mdesc codigo_escola - n_turmas_mais_educ_em_inte_ns

    Variable    |     Missing          Total     Percent Missing
----------------+-----------------------------------------------
   codigo_esc~a |           0      1,075,614           0.00
            ano |           0      1,075,614           0.00
       ano_enem |     920,541      1,075,614          85.58
      cod_munic |     920,541      1,075,614          85.58
   codigo_mu~go |     920,541      1,075,614          85.58
       cod_meso |     920,541      1,075,614          85.58
   nome_munic~o |     653,320      1,075,614          60.74
      codigo_uf |     273,227      1,075,614          25.40
         estado |     920,541      1,075,614          85.58
            pib |     920,541      1,075,614          85.58
            pop |     920,541      1,075,614          85.58
   pib_capita~s |     920,541      1,075,614          85.58
   pib_cap~2003 |     920,541      1,075,614          85.58
   pib_cap~2015 |     920,541      1,075,614          85.58
   concluir_e~m |     920,541      1,075,614          85.58
   e_mora_mai~s |     922,900      1,075,614          85.80
   e_escol_su~i |     923,728      1,075,614          85.88
   e_escol_su~e |     923,221      1,075,614          85.83
   e_renda_fa~s |     922,921      1,075,614          85.80
   e_trabalho~u |     923,955      1,075,614          85.90
   enem_nota~va |   1,014,949      1,075,614          94.36
   enem_nota~ca |     984,259      1,075,614          91.51
   enem_nota~ns |     984,259      1,075,614          91.51
   enem_not~nas |     984,020      1,075,614          91.48
   enem_not~ias |     984,020      1,075,614          91.48
   enem_nota_~o |     920,913      1,075,614          85.62
         apr_ef |     997,002      1,075,614          92.69
         apr_em |     973,033      1,075,614          90.46
         rep_ef |     991,965      1,075,614          92.22
         rep_em |     973,033      1,075,614          90.46
         aba_ef |     991,965      1,075,614          92.22
         aba_em |     973,033      1,075,614          90.46
        dist_ef |     992,349      1,075,614          92.26
        dist_em |     975,060      1,075,614          90.65
   enem_nota_~b |     923,631      1,075,614          85.87
   enem_~va_std |   1,014,949      1,075,614          94.36
   enem_n~b_std |     923,631      1,075,614          85.87
   enem_n~o_std |     920,913      1,075,614          85.62
   enem_~ca_std |     984,259      1,075,614          91.51
   enem~ias_std |     984,020      1,075,614          91.48
   enem~nas_std |     984,020      1,075,614          91.48
   enem_~ns_std |     984,259      1,075,614          91.51
     apr_em_std |     973,033      1,075,614          90.46
     rep_em_std |     973,033      1,075,614          90.46
     aba_em_std |     973,033      1,075,614          90.46
    dist_em_std |     975,060      1,075,614          90.65
   dependenci~a |           0      1,075,614           0.00
   n_copiadoras |     802,619      1,075,614          74.62
      n_arsalas |     802,619      1,075,614          74.62
   n_impresso~s |     802,619      1,075,614          74.62
   n_salas_perm |     802,603      1,075,614          74.62
   n_salas_prov |     802,603      1,075,614          74.62
    n_sala_util |     802,603      1,075,614          74.62
   n_sala_uti~a |     802,603      1,075,614          74.62
     n_profs_em |     802,603      1,075,614          74.62
   n_profs_em~a |     802,603      1,075,614          74.62
   n_profs_em~o |     802,603      1,075,614          74.62
   n_profs_em~g |     802,603      1,075,614          74.62
   n_turmas_d~1 |   1,038,021      1,075,614          96.50
   n_turmas_d~2 |   1,038,021      1,075,614          96.50
   n_turmas_d~3 |   1,038,021      1,075,614          96.50
   n_turmas_d~4 |   1,038,021      1,075,614          96.50
   n_turmas_d~s |   1,038,021      1,075,614          96.50
   n_alunos_d~1 |   1,038,021      1,075,614          96.50
   n_alunos_d~2 |   1,038,021      1,075,614          96.50
   n_alunos_d~3 |   1,038,021      1,075,614          96.50
   n_alunos_d~4 |   1,038,021      1,075,614          96.50
   n_alunos_d~s |   1,038,021      1,075,614          96.50
   n_turmas_n~1 |   1,050,330      1,075,614          97.65
   n_turmas_n~2 |   1,050,330      1,075,614          97.65
   n_turmas_n~3 |   1,050,330      1,075,614          97.65
   n_turmas_n~4 |   1,050,330      1,075,614          97.65
   n_turmas_n~s |   1,050,330      1,075,614          97.65
   n_alunos_n~1 |   1,050,330      1,075,614          97.65
   n_alunos_n~2 |   1,050,330      1,075,614          97.65
   n_alunos_n~3 |   1,050,330      1,075,614          97.65
   n_alunos_n~4 |   1,050,330      1,075,614          97.65
   n_alunos_n~s |   1,050,330      1,075,614          97.65
   n_mul~s_em_1 |     440,570      1,075,614          40.96
   n_mul~s_em_2 |     440,570      1,075,614          40.96
   n_mul~s_em_3 |     440,570      1,075,614          40.96
   n_mul~s_em_4 |   1,065,710      1,075,614          99.08
   n_mu~s_em_ns |   1,065,710      1,075,614          99.08
          rural |           0      1,075,614           0.00
          ativa |           0      1,075,614           0.00
             em |     242,177      1,075,614          22.52
        em_prof |     471,370      1,075,614          43.82
         predio |      62,169      1,075,614           5.78
      diretoria |      59,625      1,075,614           5.54
   sala_profe~s |      59,627      1,075,614           5.54
     biblioteca |      59,650      1,075,614           5.55
   sala_leitura |     216,234      1,075,614          20.10
     refeitorio |     469,543      1,075,614          43.65
       lab_info |      59,642      1,075,614           5.54
   lab_ciencias |      59,646      1,075,614           5.55
   quadra_esp~s |      59,632      1,075,614           5.54
       internet |     328,784      1,075,614          30.57
    lixo_coleta |     209,037      1,075,614          19.43
   eletricidade |     209,030      1,075,614          19.43
           agua |     209,036      1,075,614          19.43
         esgoto |     209,044      1,075,614          19.43
   n_salas_ut~s |     209,014      1,075,614          19.43
   p_profs_em~n |   1,034,107      1,075,614          96.14
   p_profs_em~s |   1,034,107      1,075,614          96.14
   p_profs_em~g |   1,034,107      1,075,614          96.14
   n_alunos~u_1 |   1,038,560      1,075,614          96.56
   n_alunos~u_2 |   1,041,481      1,075,614          96.83
   n_alunos~u_3 |   1,044,890      1,075,614          97.14
   n_alunos~t_1 |   1,052,359      1,075,614          97.84
   n_alunos~t_2 |   1,051,972      1,075,614          97.80
   n_alunos~t_3 |   1,052,171      1,075,614          97.82
   n_alu~s_em_1 |     440,571      1,075,614          40.96
   n_alu~s_em_2 |     440,571      1,075,614          40.96
   n_alu~s_em_3 |     440,571      1,075,614          40.96
   p_mul~s_em_1 |     934,745      1,075,614          86.90
   p_mul~s_em_2 |     938,391      1,075,614          87.24
   p_mul~s_em_3 |     942,475      1,075,614          87.62
   n_mul~u_em_1 |   1,044,010      1,075,614          97.06
   n_mul~u_em_2 |   1,044,010      1,075,614          97.06
   n_mul~u_em_3 |   1,044,010      1,075,614          97.06
   n_mul~u_em_4 |   1,044,010      1,075,614          97.06
   n_mu~u_em_ns |   1,044,010      1,075,614          97.06
   n_mul~t_em_1 |   1,044,010      1,075,614          97.06
   n_mul~t_em_2 |   1,044,010      1,075,614          97.06
   n_mul~t_em_3 |   1,044,010      1,075,614          97.06
   n_mul~t_em_4 |   1,044,010      1,075,614          97.06
   n_mu~t_em_ns |   1,044,010      1,075,614          97.06
   dir_sup_se~n |   1,006,799      1,075,614          93.60
   dir_sup_co~n |   1,006,799      1,075,614          93.60
        dir_pos |   1,006,799      1,075,614          93.60
   dir_concurso |   1,006,799      1,075,614          93.60
   dir_indicado |   1,006,799      1,075,614          93.60
     dir_eleito |   1,006,799      1,075,614          93.60
   org_se~l_diu |   1,065,291      1,075,614          99.04
   org_se~l_not |   1,065,291      1,075,614          99.04
   org_se~s_diu |   1,065,291      1,075,614          99.04
   org_se~s_not |   1,075,614      1,075,614         100.00
   org_ci~l_diu |   1,065,291      1,075,614          99.04
   org_ci~l_not |   1,065,291      1,075,614          99.04
   org_ci~s_diu |   1,065,291      1,075,614          99.04
   org_ci~s_not |   1,065,291      1,075,614          99.04
   p_mul~u_em_1 |   1,047,323      1,075,614          97.37
   p_mul~u_em_2 |   1,049,447      1,075,614          97.57
   p_mul~u_em_3 |   1,051,855      1,075,614          97.79
    em_int_prof |     922,993      1,075,614          85.81
   n_bra~u_em_1 |   1,054,329      1,075,614          98.02
   n_bra~u_em_2 |   1,054,329      1,075,614          98.02
   n_bra~u_em_3 |   1,054,329      1,075,614          98.02
   n_bra~u_em_4 |   1,054,329      1,075,614          98.02
   n_br~u_em_ns |   1,054,329      1,075,614          98.02
   n_bra~t_em_1 |   1,054,329      1,075,614          98.02
   n_bra~t_em_2 |   1,054,329      1,075,614          98.02
   n_bra~t_em_3 |   1,054,329      1,075,614          98.02
   n_bra~t_em_4 |   1,054,329      1,075,614          98.02
   n_br~t_em_ns |   1,054,329      1,075,614          98.02
   n_bra~s_em_1 |     460,793      1,075,614          42.84
   n_bra~s_em_2 |     460,793      1,075,614          42.84
   n_bra~s_em_3 |     460,793      1,075,614          42.84
   p_branco~m_1 |     957,702      1,075,614          89.04
   p_branco~m_2 |     962,206      1,075,614          89.46
   p_branco~m_3 |     966,321      1,075,614          89.84
    nome_escola |     306,261      1,075,614          28.47
   codigo_mu~vo |     306,261      1,075,614          28.47
   ID_LOCALIZ~O |   1,000,290      1,075,614          93.00
   n_salas_exis |     483,085      1,075,614          44.91
        regular |     548,440      1,075,614          50.99
   em_integrado |     548,438      1,075,614          50.99
      em_normal |     548,438      1,075,614          50.99
   n_tur~s_em_1 |     482,078      1,075,614          44.82
   n_tur~s_em_2 |     482,078      1,075,614          44.82
   n_tur~s_em_3 |     482,078      1,075,614          44.82
   n_turmas_e.. |     482,078      1,075,614          44.82
   n_turmas_e~4 |     482,078      1,075,614          44.82
   n_turmas_e~s |     482,078      1,075,614          44.82
   n_alu_tr~m_1 |     482,078      1,075,614          44.82
   n_alu_tr~m_2 |     482,078      1,075,614          44.82
   n_alu_tr~m_3 |     482,078      1,075,614          44.82
   m_idade_em_1 |     975,628      1,075,614          90.70
   m_idade_em_2 |     977,768      1,075,614          90.90
   m_idade_em_3 |     980,011      1,075,614          91.11
   p_alu_tr~m_1 |     975,628      1,075,614          90.70
   p_alu_tr~m_2 |     977,768      1,075,614          90.90
   p_alu_tr~m_3 |     980,011      1,075,614          91.11
   n_alunos~e_1 |     482,078      1,075,614          44.82
   n_alunos~e_2 |     482,078      1,075,614          44.82
   n_alunos~e_3 |     482,078      1,075,614          44.82
   n_alunos_e~4 |     482,078      1,075,614          44.82
   n_alunos_e~s |     482,078      1,075,614          44.82
   n_mulher~e_1 |     482,078      1,075,614          44.82
   n_mulher~e_2 |     482,078      1,075,614          44.82
   n_mulher~e_3 |     482,078      1,075,614          44.82
   n_mulher~e_4 |     482,078      1,075,614          44.82
   n_mulhe~e_ns |     482,078      1,075,614          44.82
   n_branco~e_1 |     482,078      1,075,614          44.82
   n_branco~e_2 |     482,078      1,075,614          44.82
   n_branco~e_3 |     482,078      1,075,614          44.82
   n_branco~e_4 |     482,078      1,075,614          44.82
   n_branc~e_ns |     482,078      1,075,614          44.82
   n_alu_tr~e_1 |     482,078      1,075,614          44.82
   n_alu_tr~e_2 |     482,078      1,075,614          44.82
   n_alu_tr~e_3 |     482,078      1,075,614          44.82
   n_alu_tran~4 |     482,078      1,075,614          44.82
   n_alu_tran~s |     482,078      1,075,614          44.82
   m_idade_~e_1 |   1,072,312      1,075,614          99.69
   m_idade_~e_2 |   1,072,792      1,075,614          99.74
   m_idade_~e_3 |   1,073,282      1,075,614          99.78
   m_idade_em~4 |   1,075,299      1,075,614          99.97
   m_idade_em~s |   1,075,407      1,075,614          99.98
   p_mulher~e_1 |   1,072,312      1,075,614          99.69
   p_mulher~e_2 |   1,072,792      1,075,614          99.74
   p_mulher~e_3 |   1,073,282      1,075,614          99.78
   p_mulheres~4 |   1,075,299      1,075,614          99.97
   p_mulheres~s |   1,075,407      1,075,614          99.98
   p_branco~e_1 |   1,072,336      1,075,614          99.70
   p_branco~e_2 |   1,072,855      1,075,614          99.74
   p_branco~e_3 |   1,073,382      1,075,614          99.79
   p_brancos_~4 |   1,075,309      1,075,614          99.97
   p_brancos_~s |   1,075,423      1,075,614          99.98
   p_alu_tr~e_1 |   1,072,312      1,075,614          99.69
   p_alu_tr~e_2 |   1,072,792      1,075,614          99.74
   p_alu_tr~e_3 |   1,073,282      1,075,614          99.78
   p_alu_tran~4 |   1,075,299      1,075,614          99.97
   p_alu_tran~s |   1,075,407      1,075,614          99.98
   n_profs_em_1 |     483,375      1,075,614          44.94
   n_profs_em_2 |     483,375      1,075,614          44.94
   n_profs_em_3 |     483,375      1,075,614          44.94
   n_pro~p_em_1 |     483,375      1,075,614          44.94
   n_pro~p_em_2 |     483,375      1,075,614          44.94
   n_pro~p_em_3 |     483,375      1,075,614          44.94
   p_profs_~m_1 |     975,783      1,075,614          90.72
   p_profs_~m_2 |     977,911      1,075,614          90.92
   p_profs_~m_3 |     980,143      1,075,614          91.12
   n_profs_em.. |     483,375      1,075,614          44.94
   n_profs_em.. |     483,375      1,075,614          44.94
   n_profs_em.. |     483,375      1,075,614          44.94
   n_profs_em~4 |     483,375      1,075,614          44.94
   n_profs_em~s |     483,375      1,075,614          44.94
   n_profs_su.. |     483,375      1,075,614          44.94
   n_profs_su.. |     483,375      1,075,614          44.94
   n_profs_su.. |     483,375      1,075,614          44.94
   n_profs_su~4 |     483,375      1,075,614          44.94
   n_profs_su~s |     483,375      1,075,614          44.94
   p_profs_~e_1 |   1,072,316      1,075,614          99.69
   p_profs_~e_2 |   1,072,799      1,075,614          99.74
   p_profs_~e_3 |   1,073,288      1,075,614          99.78
   p_profs_su~4 |   1,075,301      1,075,614          99.97
   p_profs_su~s |   1,075,409      1,075,614          99.98
    fund_8_anos |     746,342      1,075,614          69.39
    fund_9_anos |     746,342      1,075,614          69.39
   distrito_e~o |     631,398      1,075,614          58.70
          SIGLA |     892,185      1,075,614          82.95
     in_regular |   1,009,660      1,075,614          93.87
   n_tur~c_em_1 |   1,009,660      1,075,614          93.87
   n_tur~c_em_2 |   1,009,660      1,075,614          93.87
   n_tur~c_em_3 |   1,009,660      1,075,614          93.87
   n_turmas_e.. |   1,009,660      1,075,614          93.87
   n_turmas_e.. |   1,009,660      1,075,614          93.87
   ~c_em_inte_1 |   1,009,660      1,075,614          93.87
   ~c_em_inte_2 |   1,009,660      1,075,614          93.87
   ~c_em_inte_3 |   1,009,660      1,075,614          93.87
   n_turmas_m~4 |   1,009,660      1,075,614          93.87
   n_turmas_m~s |   1,009,660      1,075,614          93.87
----------------+-----------------------------------------------



*/
}
* dropando variáveis com um número excessivo de missings, acima de 70%
drop n_copiadoras n_arsalas n_impressoras n_salas_perm n_salas_prov n_sala_util n_sala_util_fora n_profs_em n_profs_em_licenciatura n_profs_em_magisterio n_turmas_diu_em_1 n_turmas_diu_em_2 n_turmas_diu_em_3 n_turmas_diu_em_4 n_turmas_diu_em_ns n_alunos_diu_em_1 n_alunos_diu_em_2 n_alunos_diu_em_3 n_alunos_diu_em_4 n_alunos_diu_em_ns n_turmas_not_em_1 n_turmas_not_em_2 n_turmas_not_em_3 n_turmas_not_em_4 n_turmas_not_em_ns n_alunos_not_em_1 n_alunos_not_em_2 n_alunos_not_em_3 n_alunos_not_em_4 n_alunos_not_em_ns
drop n_salas_utilizadas - n_alunos_turma_not_3
drop n_mulheres_diu_em_1 - n_brancos_not_em_ns
drop ID_LOCALIZACAO m_idade_em_inte_1 - p_alu_transp_publico_em_inte_ns p_profs_sup_em_inte_1- p_profs_sup_em_inte_ns  
drop n_profs_em_sup_sem_lic_e_mag
replace regular = in_regular if ano == 2015

mdesc codigo_escola - n_turmas_mais_educ_em_inte_ns
/*

    Variable    |     Missing          Total     Percent Missing
----------------+-----------------------------------------------
   codigo_esc~a |           0      1,075,614           0.00
            ano |           0      1,075,614           0.00
       ano_enem |     920,541      1,075,614          85.58
      cod_munic |     920,541      1,075,614          85.58
   codigo_mu~go |     920,541      1,075,614          85.58
       cod_meso |     920,541      1,075,614          85.58
   nome_munic~o |     653,320      1,075,614          60.74
      codigo_uf |     273,227      1,075,614          25.40
         estado |     920,541      1,075,614          85.58
            pib |     920,541      1,075,614          85.58
            pop |     920,541      1,075,614          85.58
   pib_capita~s |     920,541      1,075,614          85.58
   pib_cap~2003 |     920,541      1,075,614          85.58
   pib_cap~2015 |     920,541      1,075,614          85.58
   concluir_e~m |     920,541      1,075,614          85.58
   e_mora_mai~s |     922,900      1,075,614          85.80
   e_escol_su~i |     923,728      1,075,614          85.88
   e_escol_su~e |     923,221      1,075,614          85.83
   e_renda_fa~s |     922,921      1,075,614          85.80
   e_trabalho~u |     923,955      1,075,614          85.90
   enem_nota~va |   1,014,949      1,075,614          94.36
   enem_nota~ca |     984,259      1,075,614          91.51
   enem_nota~ns |     984,259      1,075,614          91.51
   enem_not~nas |     984,020      1,075,614          91.48
   enem_not~ias |     984,020      1,075,614          91.48
   enem_nota_~o |     920,913      1,075,614          85.62
         apr_ef |     997,002      1,075,614          92.69
         apr_em |     973,033      1,075,614          90.46
         rep_ef |     991,965      1,075,614          92.22
         rep_em |     973,033      1,075,614          90.46
         aba_ef |     991,965      1,075,614          92.22
         aba_em |     973,033      1,075,614          90.46
        dist_ef |     992,349      1,075,614          92.26
        dist_em |     975,060      1,075,614          90.65
   enem_nota_~b |     923,631      1,075,614          85.87
   enem_~va_std |   1,014,949      1,075,614          94.36
   enem_n~b_std |     923,631      1,075,614          85.87
   enem_n~o_std |     920,913      1,075,614          85.62
   enem_~ca_std |     984,259      1,075,614          91.51
   enem~ias_std |     984,020      1,075,614          91.48
   enem~nas_std |     984,020      1,075,614          91.48
   enem_~ns_std |     984,259      1,075,614          91.51
     apr_em_std |     973,033      1,075,614          90.46
     rep_em_std |     973,033      1,075,614          90.46
     aba_em_std |     973,033      1,075,614          90.46
    dist_em_std |     975,060      1,075,614          90.65
   dependenci~a |           0      1,075,614           0.00
   n_mulher~m_1 |     440,570      1,075,614          40.96
   n_mulher~m_2 |     440,570      1,075,614          40.96
   n_mulher~m_3 |     440,570      1,075,614          40.96
   n_mulher~m_4 |   1,065,710      1,075,614          99.08
   n_mulhe~m_ns |   1,065,710      1,075,614          99.08
          rural |           0      1,075,614           0.00
          ativa |           0      1,075,614           0.00
             em |     242,177      1,075,614          22.52
        em_prof |     471,370      1,075,614          43.82
         predio |      62,169      1,075,614           5.78
      diretoria |      59,625      1,075,614           5.54
   sala_profe~s |      59,627      1,075,614           5.54
     biblioteca |      59,650      1,075,614           5.55
   sala_leitura |     216,234      1,075,614          20.10
     refeitorio |     469,543      1,075,614          43.65
       lab_info |      59,642      1,075,614           5.54
   lab_ciencias |      59,646      1,075,614           5.55
   quadra_esp~s |      59,632      1,075,614           5.54
       internet |     328,784      1,075,614          30.57
    lixo_coleta |     209,037      1,075,614          19.43
   eletricidade |     209,030      1,075,614          19.43
           agua |     209,036      1,075,614          19.43
         esgoto |     209,044      1,075,614          19.43
   n_alunos~m_1 |     440,571      1,075,614          40.96
   n_alunos~m_2 |     440,571      1,075,614          40.96
   n_alunos~m_3 |     440,571      1,075,614          40.96
   p_mulheres~1 |     934,745      1,075,614          86.90
   p_mulheres~2 |     938,391      1,075,614          87.24
   p_mulheres~3 |     942,475      1,075,614          87.62
   n_branco~m_1 |     460,793      1,075,614          42.84
   n_branco~m_2 |     460,793      1,075,614          42.84
   n_branco~m_3 |     460,793      1,075,614          42.84
   p_brancos_~1 |     957,702      1,075,614          89.04
   p_brancos_~2 |     962,206      1,075,614          89.46
   p_brancos_~3 |     966,321      1,075,614          89.84
    nome_escola |     306,261      1,075,614          28.47
   codigo_mu~vo |     306,261      1,075,614          28.47
   n_salas_exis |     483,085      1,075,614          44.91
        regular |     482,486      1,075,614          44.86
   em_integrado |     548,438      1,075,614          50.99
      em_normal |     548,438      1,075,614          50.99
   n_tur~s_em_1 |     482,078      1,075,614          44.82
   n_tur~s_em_2 |     482,078      1,075,614          44.82
   n_tur~s_em_3 |     482,078      1,075,614          44.82
   n_turmas_e.. |     482,078      1,075,614          44.82
   n_turmas_e~4 |     482,078      1,075,614          44.82
   n_turmas_e~s |     482,078      1,075,614          44.82
   n_alu_tr~m_1 |     482,078      1,075,614          44.82
   n_alu_tr~m_2 |     482,078      1,075,614          44.82
   n_alu_tr~m_3 |     482,078      1,075,614          44.82
   m_idade_em_1 |     975,628      1,075,614          90.70
   m_idade_em_2 |     977,768      1,075,614          90.90
   m_idade_em_3 |     980,011      1,075,614          91.11
   p_alu_tran~1 |     975,628      1,075,614          90.70
   p_alu_tran~2 |     977,768      1,075,614          90.90
   p_alu_tran~3 |     980,011      1,075,614          91.11
   n_alunos~e_1 |     482,078      1,075,614          44.82
   n_alunos~e_2 |     482,078      1,075,614          44.82
   n_alunos~e_3 |     482,078      1,075,614          44.82
   n_alunos_e~4 |     482,078      1,075,614          44.82
   n_alunos_e~s |     482,078      1,075,614          44.82
   n_mulher~e_1 |     482,078      1,075,614          44.82
   n_mulher~e_2 |     482,078      1,075,614          44.82
   n_mulher~e_3 |     482,078      1,075,614          44.82
   n_mulher~e_4 |     482,078      1,075,614          44.82
   n_mulhe~e_ns |     482,078      1,075,614          44.82
   n_branco~e_1 |     482,078      1,075,614          44.82
   n_branco~e_2 |     482,078      1,075,614          44.82
   n_branco~e_3 |     482,078      1,075,614          44.82
   n_brancos_~4 |     482,078      1,075,614          44.82
   n_brancos_~s |     482,078      1,075,614          44.82
   n_alu_tr~e_1 |     482,078      1,075,614          44.82
   n_alu_tr~e_2 |     482,078      1,075,614          44.82
   n_alu_tr~e_3 |     482,078      1,075,614          44.82
   n_alu_tran~4 |     482,078      1,075,614          44.82
   n_alu_tran~s |     482,078      1,075,614          44.82
   n_profs_em_1 |     483,375      1,075,614          44.94
   n_profs_em_2 |     483,375      1,075,614          44.94
   n_profs_em_3 |     483,375      1,075,614          44.94
   n_pro~p_em_1 |     483,375      1,075,614          44.94
   n_pro~p_em_2 |     483,375      1,075,614          44.94
   n_pro~p_em_3 |     483,375      1,075,614          44.94
   p_profs_su~1 |     975,783      1,075,614          90.72
   p_profs_su~2 |     977,911      1,075,614          90.92
   p_profs_su~3 |     980,143      1,075,614          91.12
   n_profs_em.. |     483,375      1,075,614          44.94
   n_profs_em.. |     483,375      1,075,614          44.94
   n_profs_em.. |     483,375      1,075,614          44.94
   n_profs_em~4 |     483,375      1,075,614          44.94
   n_profs_em~s |     483,375      1,075,614          44.94
   ~p_em_inte_1 |     483,375      1,075,614          44.94
   ~p_em_inte_2 |     483,375      1,075,614          44.94
   ~p_em_inte_3 |     483,375      1,075,614          44.94
   n_profs_su~4 |     483,375      1,075,614          44.94
   n_profs_su~s |     483,375      1,075,614          44.94
    fund_8_anos |     746,342      1,075,614          69.39
    fund_9_anos |     746,342      1,075,614          69.39
   distrito_e~o |     631,398      1,075,614          58.70
     in_regular |   1,009,660      1,075,614          93.87
   n_tur~c_em_1 |   1,009,660      1,075,614          93.87
   n_tur~c_em_2 |   1,009,660      1,075,614          93.87
   n_tur~c_em_3 |   1,009,660      1,075,614          93.87
   n_turmas_e.. |   1,009,660      1,075,614          93.87
   n_turmas_e.. |   1,009,660      1,075,614          93.87
   ~c_em_inte_1 |   1,009,660      1,075,614          93.87
   ~c_em_inte_2 |   1,009,660      1,075,614          93.87
   ~c_em_inte_3 |   1,009,660      1,075,614          93.87
   n_turmas_m~4 |   1,009,660      1,075,614          93.87
   n_turmas_m~s |   1,009,660      1,075,614          93.87
----------------+-----------------------------------------------



*/
drop in_regular

* analisando os missings da variável n_mulheres_em
tab ano if n_mulheres_em_1 != .
tab ano if n_mulheres_em_1 ==.

/*
. tab ano if n_mulheres_em_1 != .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      9,904        1.56        1.56
       2004 |     10,319        1.62        3.18
       2005 |     10,580        1.67        4.85
       2006 |     10,705        1.69        6.54
       2007 |     65,168       10.26       16.80
       2008 |     66,614       10.49       27.29
       2009 |     66,067       10.40       37.69
       2010 |     65,659       10.34       48.03
       2011 |     65,614       10.33       58.36
       2012 |     66,079       10.41       68.77
       2013 |     66,391       10.45       79.22
       2014 |     65,990       10.39       89.61
       2015 |     65,954       10.39      100.00
------------+-----------------------------------
      Total |    635,044      100.00

. tab ano if n_mulheres_em_1 ==.

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |     67,164       15.24       15.24
       2004 |     66,253       15.04       30.28
       2005 |     65,882       14.95       45.24
       2006 |     65,454       14.86       60.09
       2007 |     10,156        2.31       62.40
       2008 |     14,662        3.33       65.73
       2009 |     17,325        3.93       69.66
       2010 |     19,486        4.42       74.08
       2011 |     19,149        4.35       78.43
       2012 |     20,579        4.67       83.10
       2013 |     22,975        5.21       88.31
       2014 |     25,141        5.71       94.02
       2015 |     26,344        5.98      100.00
------------+-----------------------------------
      Total |    440,570      100.00



*/
tab ano if n_mulheres_em_4 != .
tab ano if n_mulheres_em_4 ==.
 /*

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      9,904      100.00      100.00
------------+-----------------------------------
      Total |      9,904      100.00

. tab ano if n_mulheres_em_4 ==.

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |     67,164        6.30        6.30
       2004 |     76,572        7.19       13.49
       2005 |     76,462        7.17       20.66
       2006 |     76,159        7.15       27.81
       2007 |     75,324        7.07       34.88
       2008 |     81,276        7.63       42.50
       2009 |     83,392        7.83       50.33
       2010 |     85,145        7.99       58.32
       2011 |     84,763        7.95       66.27
       2012 |     86,658        8.13       74.40
       2013 |     89,366        8.39       82.79
       2014 |     91,131        8.55       91.34
       2015 |     92,298        8.66      100.00
------------+-----------------------------------
      Total |  1,065,710      100.00

*/
tab ano if n_mulheres_em_ns != .
tab ano if n_mulheres_em_ns ==.
/*
. tab ano if n_mulheres_em_ns != .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      9,904      100.00      100.00
------------+-----------------------------------
      Total |      9,904      100.00

. tab ano if n_mulheres_em_ns ==.

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |     67,164        6.30        6.30
       2004 |     76,572        7.19       13.49
       2005 |     76,462        7.17       20.66
       2006 |     76,159        7.15       27.81
       2007 |     75,324        7.07       34.88
       2008 |     81,276        7.63       42.50
       2009 |     83,392        7.83       50.33
       2010 |     85,145        7.99       58.32
       2011 |     84,763        7.95       66.27
       2012 |     86,658        8.13       74.40
       2013 |     89,366        8.39       82.79
       2014 |     91,131        8.55       91.34
       2015 |     92,298        8.66      100.00
------------+-----------------------------------
      Total |  1,065,710      100.00

*/
drop n_mulheres_em_4 n_mulheres_em_ns





* analisando os missings da sala_leitura

tab ano if sala_leitura != .
tab ano if sala_leitura == .
/*
* sala de leitura não está presente nos anos de 2007 e 2008

.
        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |     68,662        7.99        7.99
       2004 |     68,791        8.00       15.99
       2005 |     68,250        7.94       23.94
       2006 |     67,268        7.83       31.76
       2009 |     83,392        9.70       41.47
       2010 |     85,145        9.91       51.38
       2011 |     84,763        9.86       61.24
       2012 |     86,658       10.08       71.32
       2013 |     89,366       10.40       81.72
       2014 |     91,131       10.60       92.33
       2015 |     65,954        7.67      100.00
------------+-----------------------------------
      Total |    859,380      100.00

. tab ano if sala_leitura == .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      8,406        3.89        3.89
       2004 |      7,781        3.60        7.49
       2005 |      8,212        3.80       11.28
       2006 |      8,891        4.11       15.40
       2007 |     75,324       34.83       50.23
       2008 |     81,276       37.59       87.82
       2015 |     26,344       12.18      100.00
------------+-----------------------------------
      Total |    216,234      100.00

*/
tab ano if refeitorio != . 
tab ano if refeitorio == . 
/*
* refeitório não está presente nos anos de 2007 a 2011


. tab ano if refeitorio != . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |     68,662       11.33       11.33
       2004 |     68,782       11.35       22.68
       2005 |     68,250       11.26       33.94
       2006 |     67,268       11.10       45.04
       2012 |     86,658       14.30       59.34
       2013 |     89,366       14.75       74.08
       2014 |     91,131       15.04       89.12
       2015 |     65,954       10.88      100.00
------------+-----------------------------------
      Total |    606,071      100.00

. tab ano if refeitorio == . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      8,406        1.79        1.79
       2004 |      7,790        1.66        3.45
       2005 |      8,212        1.75        5.20
       2006 |      8,891        1.89        7.09
       2007 |     75,324       16.04       23.13
       2008 |     81,276       17.31       40.44
       2009 |     83,392       17.76       58.20
       2010 |     85,145       18.13       76.34
       2011 |     84,763       18.05       94.39
       2015 |     26,344        5.61      100.00
------------+-----------------------------------
      Total |    469,543      100.00


*/

tab ano if internet != .
tab ano if internet ==.
/*
. tab ano if internet != .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |     35,078        4.70        4.70
       2004 |     36,746        4.92        9.62
       2005 |     68,250        9.14       18.76
       2006 |     67,268        9.01       27.76
       2007 |     45,492        6.09       33.85
       2008 |     66,667        8.93       42.78
       2009 |     66,067        8.85       51.63
       2010 |     65,659        8.79       60.42
       2011 |     54,958        7.36       67.78
       2012 |     56,791        7.60       75.38
       2013 |     58,490        7.83       83.21
       2014 |     59,410        7.95       91.17
       2015 |     65,954        8.83      100.00
------------+-----------------------------------
      Total |    746,830      100.00

. tab ano if internet ==.

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |     41,990       12.77       12.77
       2004 |     39,826       12.11       24.88
       2005 |      8,212        2.50       27.38
       2006 |      8,891        2.70       30.09
       2007 |     29,832        9.07       39.16
       2008 |     14,609        4.44       43.60
       2009 |     17,325        5.27       48.87
       2010 |     19,486        5.93       54.80
       2011 |     29,805        9.07       63.86
       2012 |     29,867        9.08       72.95
       2013 |     30,876        9.39       82.34
       2014 |     31,721        9.65       91.99
       2015 |     26,344        8.01      100.00
------------+-----------------------------------
      Total |    328,784      100.00


*/
tab ano if lixo_coleta != .
tab ano if lixo_coleta ==.

/*

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |     68,662        7.92        7.92
       2004 |     68,808        7.94       15.86
       2005 |     68,250        7.88       23.74
       2006 |     67,268        7.76       31.50
       2007 |     65,168        7.52       39.02
       2008 |     66,667        7.69       46.72
       2009 |     66,067        7.62       54.34
       2010 |     65,659        7.58       61.92
       2011 |     65,614        7.57       69.49
       2012 |     66,079        7.63       77.11
       2013 |     66,391        7.66       84.77
       2014 |     65,990        7.62       92.39
       2015 |     65,954        7.61      100.00
------------+-----------------------------------
      Total |    866,577      100.00

. tab ano if lixo_coleta ==.

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      8,406        4.02        4.02
       2004 |      7,764        3.71        7.74
       2005 |      8,212        3.93       11.66
       2006 |      8,891        4.25       15.92
       2007 |     10,156        4.86       20.78
       2008 |     14,609        6.99       27.76
       2009 |     17,325        8.29       36.05
       2010 |     19,486        9.32       45.37
       2011 |     19,149        9.16       54.53
       2012 |     20,579        9.84       64.38
       2013 |     22,975       10.99       75.37
       2014 |     25,141       12.03       87.40
       2015 |     26,344       12.60      100.00
------------+-----------------------------------
      Total |    209,037      100.00


*/
tab ano if eletricidade != .
tab ano if eletricidade ==.
/*. tab ano if eletricidade != .
tab ano if eletricidade != .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |     68,662        7.92        7.92
       2004 |     68,815        7.94       15.86
       2005 |     68,250        7.88       23.74
       2006 |     67,268        7.76       31.50
       2007 |     65,168        7.52       39.02
       2008 |     66,667        7.69       46.72
       2009 |     66,067        7.62       54.34
       2010 |     65,659        7.58       61.92
       2011 |     65,614        7.57       69.49
       2012 |     66,079        7.63       77.11
       2013 |     66,391        7.66       84.77
       2014 |     65,990        7.61       92.39
       2015 |     65,954        7.61      100.00
------------+-----------------------------------
      Total |    866,584      100.00

. tab ano if eletricidade ==.

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      8,406        4.02        4.02
       2004 |      7,757        3.71        7.73
       2005 |      8,212        3.93       11.66
       2006 |      8,891        4.25       15.91
       2007 |     10,156        4.86       20.77
       2008 |     14,609        6.99       27.76
       2009 |     17,325        8.29       36.05
       2010 |     19,486        9.32       45.37
       2011 |     19,149        9.16       54.53
       2012 |     20,579        9.84       64.38
       2013 |     22,975       10.99       75.37
       2014 |     25,141       12.03       87.40
       2015 |     26,344       12.60      100.00
------------+-----------------------------------
      Total |    209,030      100.00

*/
tab ano if agua != .
tab ano if agua ==.

/*
   tab ano if agua != .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |     68,662        7.92        7.92
       2004 |     68,809        7.94       15.86
       2005 |     68,250        7.88       23.74
       2006 |     67,268        7.76       31.50
       2007 |     65,168        7.52       39.02
       2008 |     66,667        7.69       46.72
       2009 |     66,067        7.62       54.34
       2010 |     65,659        7.58       61.92
       2011 |     65,614        7.57       69.49
       2012 |     66,079        7.63       77.11
       2013 |     66,391        7.66       84.77
       2014 |     65,990        7.62       92.39
       2015 |     65,954        7.61      100.00
------------+-----------------------------------
      Total |    866,578      100.00

. tab ano if agua ==.

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      8,406        4.02        4.02
       2004 |      7,763        3.71        7.74
       2005 |      8,212        3.93       11.66
       2006 |      8,891        4.25       15.92
       2007 |     10,156        4.86       20.78
       2008 |     14,609        6.99       27.76
       2009 |     17,325        8.29       36.05
       2010 |     19,486        9.32       45.37
       2011 |     19,149        9.16       54.53
       2012 |     20,579        9.84       64.38
       2013 |     22,975       10.99       75.37
       2014 |     25,141       12.03       87.40
       2015 |     26,344       12.60      100.00
------------+-----------------------------------
      Total |    209,036      100.00


*/
tab ano if esgoto != .
tab ano if esgoto ==.  



/*. tab ano if esgoto != .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |     68,662        7.92        7.92
       2004 |     68,801        7.94       15.86
       2005 |     68,250        7.88       23.74
       2006 |     67,268        7.76       31.50
       2007 |     65,168        7.52       39.02
       2008 |     66,667        7.69       46.71
       2009 |     66,067        7.62       54.34
       2010 |     65,659        7.58       61.92
       2011 |     65,614        7.57       69.49
       2012 |     66,079        7.63       77.11
       2013 |     66,391        7.66       84.77
       2014 |     65,990        7.62       92.39
       2015 |     65,954        7.61      100.00
------------+-----------------------------------
      Total |    866,570      100.00

. tab ano if esgoto ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      8,406        4.02        4.02
       2004 |      7,771        3.72        7.74
       2005 |      8,212        3.93       11.67
       2006 |      8,891        4.25       15.92
       2007 |     10,156        4.86       20.78
       2008 |     14,609        6.99       27.77
       2009 |     17,325        8.29       36.05
       2010 |     19,486        9.32       45.38
       2011 |     19,149        9.16       54.54
       2012 |     20,579        9.84       64.38
       2013 |     22,975       10.99       75.37
       2014 |     25,141       12.03       87.40
       2015 |     26,344       12.60      100.00
------------+-----------------------------------
      Total |    209,044      100.00



*/

tab ano if n_alunos_em_1 != . 
tab ano if n_alunos_em_1 ==. 


/*

. tab ano if n_alunos_em_1 != . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      9,904        1.56        1.56
       2004 |     10,319        1.62        3.18
       2005 |     10,580        1.67        4.85
       2006 |     10,704        1.69        6.54
       2007 |     65,168       10.26       16.80
       2008 |     66,614       10.49       27.29
       2009 |     66,067       10.40       37.69
       2010 |     65,659       10.34       48.03
       2011 |     65,614       10.33       58.36
       2012 |     66,079       10.41       68.77
       2013 |     66,391       10.45       79.22
       2014 |     65,990       10.39       89.61
       2015 |     65,954       10.39      100.00
------------+-----------------------------------
      Total |    635,043      100.00

. tab ano if n_alunos_em_1 ==. 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |     67,164       15.24       15.24
       2004 |     66,253       15.04       30.28
       2005 |     65,882       14.95       45.24
       2006 |     65,455       14.86       60.09
       2007 |     10,156        2.31       62.40
       2008 |     14,662        3.33       65.73
       2009 |     17,325        3.93       69.66
       2010 |     19,486        4.42       74.08
       2011 |     19,149        4.35       78.43
       2012 |     20,579        4.67       83.10
       2013 |     22,975        5.21       88.31
       2014 |     25,141        5.71       94.02
       2015 |     26,344        5.98      100.00
------------+-----------------------------------
      Total |    440,571      100.00


*/
tab ano if p_mulheres_em_1 != . 
tab ano if p_mulheres_em_1 ==. 

/*
 tab ano if p_mulheres_em_1 != . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      9,761        6.93        6.93
       2004 |     10,151        7.21       14.14
       2005 |     10,390        7.38       21.51
       2006 |     10,581        7.51       29.02
       2007 |     10,376        7.37       36.39
       2008 |     10,723        7.61       44.00
       2009 |     10,864        7.71       51.71
       2010 |     11,066        7.86       59.57
       2011 |     11,268        8.00       67.57
       2012 |     11,412        8.10       75.67
       2013 |     11,401        8.09       83.76
       2014 |     11,434        8.12       91.88
       2015 |     11,442        8.12      100.00
------------+-----------------------------------
      Total |    140,869      100.00

. tab ano if p_mulheres_em_1 ==. 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |     67,307        7.20        7.20
       2004 |     66,421        7.11       14.31
       2005 |     66,072        7.07       21.37
       2006 |     65,578        7.02       28.39
       2007 |     64,948        6.95       35.34
       2008 |     70,553        7.55       42.89
       2009 |     72,528        7.76       50.65
       2010 |     74,079        7.93       58.57
       2011 |     73,495        7.86       66.43
       2012 |     75,246        8.05       74.48
       2013 |     77,965        8.34       82.82
       2014 |     79,697        8.53       91.35
       2015 |     80,856        8.65      100.00
------------+-----------------------------------
      Total |    934,745      100.00

      Total |     25,181      100.00

*/
tab ano if n_brancos_em_1 != . 
tab ano if n_brancos_em_1 ==.  
* essa variável não está presente nos anos de 2003 e 2004



/*

tab ano if n_brancos_em_1 != . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2005 |     10,580        1.72        1.72
       2006 |     10,705        1.74        3.46
       2007 |     65,168       10.60       14.06
       2008 |     66,614       10.83       24.90
       2009 |     66,067       10.75       35.64
       2010 |     65,659       10.68       46.32
       2011 |     65,614       10.67       56.99
       2012 |     66,079       10.75       67.74
       2013 |     66,391       10.80       78.54
       2014 |     65,990       10.73       89.27
       2015 |     65,954       10.73      100.00
------------+-----------------------------------
      Total |    614,821      100.00

. tab ano if n_brancos_em_1 ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |     77,068       16.73       16.73
       2004 |     76,572       16.62       33.34
       2005 |     65,882       14.30       47.64
       2006 |     65,454       14.20       61.84
       2007 |     10,156        2.20       64.05
       2008 |     14,662        3.18       67.23
       2009 |     17,325        3.76       70.99
       2010 |     19,486        4.23       75.22
       2011 |     19,149        4.16       79.37
       2012 |     20,579        4.47       83.84
       2013 |     22,975        4.99       88.83
       2014 |     25,141        5.46       94.28
       2015 |     26,344        5.72      100.00
------------+-----------------------------------
      Total |    460,793      100.00


*/
tab ano if p_brancos_em_1 != . 
tab ano if p_brancos_em_1 ==.  

* esta variável não está presente nos anos de 2003 e 2004

/*

 tab ano if p_brancos_em_1 != . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2005 |     10,390        8.81        8.81
       2006 |     10,581        8.97       17.79
       2007 |      9,414        7.98       25.77
       2008 |     10,463        8.87       34.64
       2009 |     10,715        9.09       43.73
       2010 |     10,940        9.28       53.01
       2011 |     10,965        9.30       62.31
       2012 |     11,046        9.37       71.68
       2013 |     11,079        9.40       81.07
       2014 |     11,067        9.39       90.46
       2015 |     11,252        9.54      100.00
------------+-----------------------------------
      Total |    117,912      100.00

. tab ano if p_brancos_em_1 ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |     77,068        8.05        8.05
       2004 |     76,572        8.00       16.04
       2005 |     66,072        6.90       22.94
       2006 |     65,578        6.85       29.79
       2007 |     65,910        6.88       36.67
       2008 |     70,813        7.39       44.07
       2009 |     72,677        7.59       51.65
       2010 |     74,205        7.75       59.40
       2011 |     73,798        7.71       67.11
       2012 |     75,612        7.90       75.00
       2013 |     78,287        8.17       83.18
       2014 |     80,064        8.36       91.54
       2015 |     81,046        8.46      100.00
------------+-----------------------------------
      Total |    957,702      100.00



*/
tab ano if n_salas_exis != . 
tab ano if n_salas_exis ==.  
* esta variável não está presente nos anos de 2003 a 2006
/*
        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     65,168       11.00       11.00
       2008 |     66,644       11.25       22.25
       2009 |     66,067       11.15       33.40
       2010 |     65,659       11.08       44.48
       2011 |     65,614       11.07       55.55
       2012 |     66,079       11.15       66.70
       2013 |     66,381       11.20       77.91
       2014 |     65,983       11.14       89.04
       2015 |     64,934       10.96      100.00
------------+-----------------------------------
      Total |    592,529      100.00

. tab ano if n_salas_exis ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |     77,068       15.95       15.95
       2004 |     76,572       15.85       31.80
       2005 |     76,462       15.83       47.63
       2006 |     76,159       15.77       63.40
       2007 |     10,156        2.10       65.50
       2008 |     14,632        3.03       68.53
       2009 |     17,325        3.59       72.11
       2010 |     19,486        4.03       76.15
       2011 |     19,149        3.96       80.11
       2012 |     20,579        4.26       84.37
       2013 |     22,985        4.76       89.13
       2014 |     25,148        5.21       94.34
       2015 |     27,364        5.66      100.00
------------+-----------------------------------
      Total |    483,085      100.00


*/
tab ano if regular != . 
tab ano if regular ==.  
* esta variável não está presetne nos anos de 2003 a 2006


/*
. tab ano if regular != . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     65,168       10.99       10.99
       2008 |     66,667       11.24       22.23
       2009 |     66,067       11.14       33.37
       2010 |     65,659       11.07       44.44
       2011 |     65,400       11.03       55.46
       2012 |     66,079       11.14       66.60
       2013 |     66,144       11.15       77.75
       2014 |     65,990       11.13       88.88
       2015 |     65,954       11.12      100.00
------------+-----------------------------------
      Total |    593,128      100.00

. tab ano if regular ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |     77,068       15.97       15.97
       2004 |     76,572       15.87       31.84
       2005 |     76,462       15.85       47.69
       2006 |     76,159       15.78       63.48
       2007 |     10,156        2.10       65.58
       2008 |     14,609        3.03       68.61
       2009 |     17,325        3.59       72.20
       2010 |     19,486        4.04       76.24
       2011 |     19,363        4.01       80.25
       2012 |     20,579        4.27       84.52
       2013 |     23,222        4.81       89.33
       2014 |     25,141        5.21       94.54
       2015 |     26,344        5.46      100.00
------------+-----------------------------------
      Total |    482,486      100.00


*/
tab ano if em_integrado != . 
tab ano if em_integrado ==.  
* esta variável não está presente nos anos de 2003 a 2006


/*

 tab ano if em_integrado != . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     65,170       12.36       12.36
       2008 |     66,667       12.65       25.01
       2009 |     66,067       12.53       37.54
       2010 |     65,659       12.45       50.00
       2011 |     65,400       12.41       62.40
       2012 |     66,079       12.53       74.94
       2013 |     66,144       12.55       87.48
       2014 |     65,990       12.52      100.00
------------+-----------------------------------
      Total |    527,176      100.00

. tab ano if em_integrado ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |     77,068       14.05       14.05
       2004 |     76,572       13.96       28.01
       2005 |     76,462       13.94       41.96
       2006 |     76,159       13.89       55.84
       2007 |     10,154        1.85       57.69
       2008 |     14,609        2.66       60.36
       2009 |     17,325        3.16       63.52
       2010 |     19,486        3.55       67.07
       2011 |     19,363        3.53       70.60
       2012 |     20,579        3.75       74.35
       2013 |     23,222        4.23       78.59
       2014 |     25,141        4.58       83.17
       2015 |     92,298       16.83      100.00
------------+-----------------------------------
      Total |    548,438      100.00


*/
tab ano if em_normal != . 
tab ano if em_normal ==.  

* variável não está presente nos anos de 2003 a 2006


/*
.. tab ano if em_normal != . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     65,170       12.36       12.36
       2008 |     66,667       12.65       25.01
       2009 |     66,067       12.53       37.54
       2010 |     65,659       12.45       50.00
       2011 |     65,400       12.41       62.40
       2012 |     66,079       12.53       74.94
       2013 |     66,144       12.55       87.48
       2014 |     65,990       12.52      100.00
------------+-----------------------------------
      Total |    527,176      100.00

. tab ano if em_normal ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |     77,068       14.05       14.05
       2004 |     76,572       13.96       28.01
       2005 |     76,462       13.94       41.96
       2006 |     76,159       13.89       55.84
       2007 |     10,154        1.85       57.69
       2008 |     14,609        2.66       60.36
       2009 |     17,325        3.16       63.52
       2010 |     19,486        3.55       67.07
       2011 |     19,363        3.53       70.60
       2012 |     20,579        3.75       74.35
       2013 |     23,222        4.23       78.59
       2014 |     25,141        4.58       83.17
       2015 |     92,298       16.83      100.00
------------+-----------------------------------
      Total |    548,438      100.00


*/
tab ano if n_turmas_em_1 != . 
tab ano if n_turmas_em_1 ==.  


/*
esta variável não esta presente nos anos de 2003 a 2006


. tab ano if n_turmas_em_1 != . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     65,168       10.98       10.98
       2008 |     66,614       11.22       22.20
       2009 |     66,067       11.13       33.33
       2010 |     65,659       11.06       44.40
       2011 |     65,614       11.05       55.45
       2012 |     66,079       11.13       66.58
       2013 |     66,391       11.19       77.77
       2014 |     65,990       11.12       88.89
       2015 |     65,954       11.11      100.00
------------+-----------------------------------
      Total |    593,536      100.00

. tab ano if n_turmas_em_1 ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |     77,068       15.99       15.99
       2004 |     76,572       15.88       31.87
       2005 |     76,462       15.86       47.73
       2006 |     76,159       15.80       63.53
       2007 |     10,156        2.11       65.64
       2008 |     14,662        3.04       68.68
       2009 |     17,325        3.59       72.27
       2010 |     19,486        4.04       76.31
       2011 |     19,149        3.97       80.29
       2012 |     20,579        4.27       84.55
       2013 |     22,975        4.77       89.32
       2014 |     25,141        5.22       94.54
       2015 |     26,344        5.46      100.00
------------+-----------------------------------
      Total |    482,078      100.00



*/
tab ano if n_alu_transporte_publico_em_1 != . 
tab ano if n_alu_transporte_publico_em_1 ==.  
/*




esta variável não está presente nos anos de 2003 a 2006
. tab ano if n_alu_transporte_publico_em_1 != . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     65,168       10.98       10.98
       2008 |     66,614       11.22       22.20
       2009 |     66,067       11.13       33.33
       2010 |     65,659       11.06       44.40
       2011 |     65,614       11.05       55.45
       2012 |     66,079       11.13       66.58
       2013 |     66,391       11.19       77.77
       2014 |     65,990       11.12       88.89
       2015 |     65,954       11.11      100.00
------------+-----------------------------------
      Total |    593,536      100.00

. tab ano if n_alu_transporte_publico_em_1 ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |     77,068       15.99       15.99
       2004 |     76,572       15.88       31.87
       2005 |     76,462       15.86       47.73
       2006 |     76,159       15.80       63.53
       2007 |     10,156        2.11       65.64
       2008 |     14,662        3.04       68.68
       2009 |     17,325        3.59       72.27
       2010 |     19,486        4.04       76.31
       2011 |     19,149        3.97       80.29
       2012 |     20,579        4.27       84.55
       2013 |     22,975        4.77       89.32
       2014 |     25,141        5.22       94.54
       2015 |     26,344        5.46      100.00
------------+-----------------------------------
      Total |    482,078      100.00




*/
tab ano if m_idade_em_1 != . 
tab ano if m_idade_em_1 ==.  


/*
esta variável não está presente dos nos de 2003 a 2006
 . tab ano if m_idade_em_1 != . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     10,376       10.38       10.38
       2008 |     10,723       10.72       21.10
       2009 |     10,864       10.87       31.97
       2010 |     11,066       11.07       43.04
       2011 |     11,268       11.27       54.30
       2012 |     11,412       11.41       65.72
       2013 |     11,401       11.40       77.12
       2014 |     11,434       11.44       88.56
       2015 |     11,442       11.44      100.00
------------+-----------------------------------
      Total |     99,986      100.00

. tab ano if m_idade_em_1 ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |     77,068        7.90        7.90
       2004 |     76,572        7.85       15.75
       2005 |     76,462        7.84       23.59
       2006 |     76,159        7.81       31.39
       2007 |     64,948        6.66       38.05
       2008 |     70,553        7.23       45.28
       2009 |     72,528        7.43       52.71
       2010 |     74,079        7.59       60.31
       2011 |     73,495        7.53       67.84
       2012 |     75,246        7.71       75.55
       2013 |     77,965        7.99       83.54
       2014 |     79,697        8.17       91.71
       2015 |     80,856        8.29      100.00
------------+-----------------------------------
      Total |    975,628      100.00



*/


tab ano if p_alu_transporte_publico_em_1 != . 
tab ano if p_alu_transporte_publico_em_1 ==.  

/*
esta variável não está presente nos anos de 2003 a 2006
. tab ano if p_alu_transporte_publico_em_1 != . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     10,376       10.38       10.38
       2008 |     10,723       10.72       21.10
       2009 |     10,864       10.87       31.97
       2010 |     11,066       11.07       43.04
       2011 |     11,268       11.27       54.30
       2012 |     11,412       11.41       65.72
       2013 |     11,401       11.40       77.12
       2014 |     11,434       11.44       88.56
       2015 |     11,442       11.44      100.00
------------+-----------------------------------
      Total |     99,986      100.00

. tab ano if p_alu_transporte_publico_em_1 ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |     77,068        7.90        7.90
       2004 |     76,572        7.85       15.75
       2005 |     76,462        7.84       23.59
       2006 |     76,159        7.81       31.39
       2007 |     64,948        6.66       38.05
       2008 |     70,553        7.23       45.28
       2009 |     72,528        7.43       52.71
       2010 |     74,079        7.59       60.31
       2011 |     73,495        7.53       67.84
       2012 |     75,246        7.71       75.55
       2013 |     77,965        7.99       83.54
       2014 |     79,697        8.17       91.71
       2015 |     80,856        8.29      100.00
------------+-----------------------------------
      Total |    975,628      100.00

*/
tab ano if n_alunos_em_inte_1 != . 
tab ano if n_alunos_em_inte_1 ==.  
/*


estas variáveis não estavam presentes nos anos de 2003 a 2006

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     65,168       10.98       10.98
       2008 |     66,614       11.22       22.20
       2009 |     66,067       11.13       33.33
       2010 |     65,659       11.06       44.40
       2011 |     65,614       11.05       55.45
       2012 |     66,079       11.13       66.58
       2013 |     66,391       11.19       77.77
       2014 |     65,990       11.12       88.89
       2015 |     65,954       11.11      100.00
------------+-----------------------------------
      Total |    593,536      100.00

. tab ano if n_alunos_em_inte_1 ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |     77,068       15.99       15.99
       2004 |     76,572       15.88       31.87
       2005 |     76,462       15.86       47.73
       2006 |     76,159       15.80       63.53
       2007 |     10,156        2.11       65.64
       2008 |     14,662        3.04       68.68
       2009 |     17,325        3.59       72.27
       2010 |     19,486        4.04       76.31
       2011 |     19,149        3.97       80.29
       2012 |     20,579        4.27       84.55
       2013 |     22,975        4.77       89.32
       2014 |     25,141        5.22       94.54
       2015 |     26,344        5.46      100.00
------------+-----------------------------------
      Total |    482,078      100.00



*/
tab ano if n_mulheres_em_inte_1 != . 
tab ano if n_mulheres_em_inte_1 ==.  



/*
estas variáves não estavam presentes nos anos de 2003 a 2006
 
        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     65,168       10.98       10.98
       2008 |     66,614       11.22       22.20
       2009 |     66,067       11.13       33.33
       2010 |     65,659       11.06       44.40
       2011 |     65,614       11.05       55.45
       2012 |     66,079       11.13       66.58
       2013 |     66,391       11.19       77.77
       2014 |     65,990       11.12       88.89
       2015 |     65,954       11.11      100.00
------------+-----------------------------------
      Total |    593,536      100.00

. tab ano if n_mulheres_em_inte_1 ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |     77,068       15.99       15.99
       2004 |     76,572       15.88       31.87
       2005 |     76,462       15.86       47.73
       2006 |     76,159       15.80       63.53
       2007 |     10,156        2.11       65.64
       2008 |     14,662        3.04       68.68
       2009 |     17,325        3.59       72.27
       2010 |     19,486        4.04       76.31
       2011 |     19,149        3.97       80.29
       2012 |     20,579        4.27       84.55
       2013 |     22,975        4.77       89.32
       2014 |     25,141        5.22       94.54
       2015 |     26,344        5.46      100.00
------------+-----------------------------------
      Total |    482,078      100.00



*/
tab ano if n_brancos_em_inte_1 != . 
tab ano if n_brancos_em_inte_1 ==.  


/*
estas variáveis não estavam presentes nos anos de 2003 a 2006

. tab ano if n_brancos_em_inte_1 != . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     65,168       10.98       10.98
       2008 |     66,614       11.22       22.20
       2009 |     66,067       11.13       33.33
       2010 |     65,659       11.06       44.40
       2011 |     65,614       11.05       55.45
       2012 |     66,079       11.13       66.58
       2013 |     66,391       11.19       77.77
       2014 |     65,990       11.12       88.89
       2015 |     65,954       11.11      100.00
------------+-----------------------------------
      Total |    593,536      100.00

. tab ano if n_brancos_em_inte_1 ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |     77,068       15.99       15.99
       2004 |     76,572       15.88       31.87
       2005 |     76,462       15.86       47.73
       2006 |     76,159       15.80       63.53
       2007 |     10,156        2.11       65.64
       2008 |     14,662        3.04       68.68
       2009 |     17,325        3.59       72.27
       2010 |     19,486        4.04       76.31
       2011 |     19,149        3.97       80.29
       2012 |     20,579        4.27       84.55
       2013 |     22,975        4.77       89.32
       2014 |     25,141        5.22       94.54
       2015 |     26,344        5.46      100.00
------------+-----------------------------------
      Total |    482,078      100.00



*/
tab ano if n_profs_em_1 != . 
tab ano if n_profs_em_1 ==.  

/*
estas variáveis não estavam presentes nos anos de 2003 a 2006

. tab ano if n_profs_em_1 != . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     64,536       10.90       10.90
       2008 |     66,353       11.20       22.10
       2009 |     65,879       11.12       33.22
       2010 |     65,443       11.05       44.27
       2011 |     65,614       11.08       55.35
       2012 |     66,079       11.16       66.51
       2013 |     66,391       11.21       77.72
       2014 |     65,990       11.14       88.86
       2015 |     65,954       11.14      100.00
------------+-----------------------------------
      Total |    592,239      100.00

. tab ano if n_profs_em_1 ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |     77,068       15.94       15.94
       2004 |     76,572       15.84       31.78
       2005 |     76,462       15.82       47.60
       2006 |     76,159       15.76       63.36
       2007 |     10,788        2.23       65.59
       2008 |     14,923        3.09       68.68
       2009 |     17,513        3.62       72.30
       2010 |     19,702        4.08       76.38
       2011 |     19,149        3.96       80.34
       2012 |     20,579        4.26       84.60
       2013 |     22,975        4.75       89.35
       2014 |     25,141        5.20       94.55
       2015 |     26,344        5.45      100.00
------------+-----------------------------------
      Total |    483,375      100.00

*/

tab ano if n_profs_sup_em_1 != . 
tab ano if n_profs_sup_em_1 ==.  
/*
estas variáveis não estavam presentes nos anos de 2003 a 2006



. tab ano if n_profs_sup_em_1 != . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     64,536       10.90       10.90
       2008 |     66,353       11.20       22.10
       2009 |     65,879       11.12       33.22
       2010 |     65,443       11.05       44.27
       2011 |     65,614       11.08       55.35
       2012 |     66,079       11.16       66.51
       2013 |     66,391       11.21       77.72
       2014 |     65,990       11.14       88.86
       2015 |     65,954       11.14      100.00
------------+-----------------------------------
      Total |    592,239      100.00

. tab ano if n_profs_sup_em_1 ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |     77,068       15.94       15.94
       2004 |     76,572       15.84       31.78
       2005 |     76,462       15.82       47.60
       2006 |     76,159       15.76       63.36
       2007 |     10,788        2.23       65.59
       2008 |     14,923        3.09       68.68
       2009 |     17,513        3.62       72.30
       2010 |     19,702        4.08       76.38
       2011 |     19,149        3.96       80.34
       2012 |     20,579        4.26       84.60
       2013 |     22,975        4.75       89.35
       2014 |     25,141        5.20       94.55
       2015 |     26,344        5.45      100.00
------------+-----------------------------------
      Total |    483,375      100.00

. 

*/

tab ano if p_profs_sup_em_1 != . 
tab ano if p_profs_sup_em_1 ==.  



* estas variáveis não estavam presentes nos anos de 2003 a 2006
/*
   tab ano if p_profs_sup_em_1 != . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     10,310       10.33       10.33
       2008 |     10,697       10.72       21.04
       2009 |     10,840       10.86       31.90
       2010 |     11,042       11.06       42.96
       2011 |     11,268       11.29       54.25
       2012 |     11,412       11.43       65.68
       2013 |     11,401       11.42       77.10
       2014 |     11,427       11.45       88.55
       2015 |     11,434       11.45      100.00
------------+-----------------------------------
      Total |     99,831      100.00

. tab ano if p_profs_sup_em_1 ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |     77,068        7.90        7.90
       2004 |     76,572        7.85       15.75
       2005 |     76,462        7.84       23.58
       2006 |     76,159        7.80       31.39
       2007 |     65,014        6.66       38.05
       2008 |     70,579        7.23       45.28
       2009 |     72,552        7.44       52.72
       2010 |     74,103        7.59       60.31
       2011 |     73,495        7.53       67.84
       2012 |     75,246        7.71       75.55
       2013 |     77,965        7.99       83.54
       2014 |     79,704        8.17       91.71
       2015 |     80,864        8.29      100.00
------------+-----------------------------------
      Total |    975,783      100.00

*/

tab ano if n_profs_em_inte_1 != . 
tab ano if n_profs_em_inte_1 ==. 



/*
* estas variáveis não estavam presetnes nos anos de 2003 a 2006
. tab ano if n_profs_em_inte_1 != . 


        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     64,536       10.90       10.90
       2008 |     66,353       11.20       22.10
       2009 |     65,879       11.12       33.22
       2010 |     65,443       11.05       44.27
       2011 |     65,614       11.08       55.35
       2012 |     66,079       11.16       66.51
       2013 |     66,391       11.21       77.72
       2014 |     65,990       11.14       88.86
       2015 |     65,954       11.14      100.00
------------+-----------------------------------
      Total |    592,239      100.00

. tab ano if n_profs_em_inte_1 ==. 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |     77,068       15.94       15.94
       2004 |     76,572       15.84       31.78
       2005 |     76,462       15.82       47.60
       2006 |     76,159       15.76       63.36
       2007 |     10,788        2.23       65.59
       2008 |     14,923        3.09       68.68
       2009 |     17,513        3.62       72.30
       2010 |     19,702        4.08       76.38
       2011 |     19,149        3.96       80.34
       2012 |     20,579        4.26       84.60
       2013 |     22,975        4.75       89.35
       2014 |     25,141        5.20       94.55
       2015 |     26,344        5.45      100.00
------------+-----------------------------------
      Total |    483,375      100.00


*/
tab ano if n_profs_sup_em_inte_1 != . 
tab ano if n_profs_sup_em_inte_1 ==.  
            

/*
estas variáveis não estavam presentes nos anos de 2003 a 2006

. tab ano if n_profs_sup_em_inte_1 != . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     64,536       10.90       10.90
       2008 |     66,353       11.20       22.10
       2009 |     65,879       11.12       33.22
       2010 |     65,443       11.05       44.27
       2011 |     65,614       11.08       55.35
       2012 |     66,079       11.16       66.51
       2013 |     66,391       11.21       77.72
       2014 |     65,990       11.14       88.86
       2015 |     65,954       11.14      100.00
------------+-----------------------------------
      Total |    592,239      100.00

. tab ano if n_profs_sup_em_inte_1 ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |     77,068       15.94       15.94
       2004 |     76,572       15.84       31.78
       2005 |     76,462       15.82       47.60
       2006 |     76,159       15.76       63.36
       2007 |     10,788        2.23       65.59
       2008 |     14,923        3.09       68.68
       2009 |     17,513        3.62       72.30
       2010 |     19,702        4.08       76.38
       2011 |     19,149        3.96       80.34
       2012 |     20,579        4.26       84.60
       2013 |     22,975        4.75       89.35
       2014 |     25,141        5.20       94.55
       2015 |     26,344        5.45      100.00
------------+-----------------------------------
      Total |    483,375      100.00


*/

save "$folderservidor\enem_censo_escolar_14_v1.dta",replace
* predio 
* diretoria 
* sala_professores 
* biblioteca 
* internet 
* lixo_coleta
* eletricidade 
* agua 
* esgoto
* n_alunos_em_1
* são variáveis presentes 
* em todos anos, com poucos missings

* p_mulheres_em_1
* são variáveis presentes, mas com uma taxa relativamente alta de
* missings

* sala de leitura 
* não está presente nos anos de 2007 e 2008

* refeitório 
* não está presente nos anos de 2007 a 2011

* n_brancos_em_1  
* p_brancos_em_1 
* não está presente nos anos de 2003 e 2004

* n_salas_exis  
* regular 
* em_integrado  
* em_normal
* n_turmas_em_1 
* n_alu_transporte_publico_em_1 
* m_idade_em_1*
* p_alu_transporte_publico_em_1 
* n_alunos_em_inte_1
* n_mulheres_em_inte_1 
* n_brancos_em_inte_1
* n_profs_em_1 
* n_profs_sup_em_1 
* p_profs_sup_em_1
* n_profs_em_inte_1 
* n_profs_sup_em_inte_1
* não está presente nos anos de 2003 a 2006 
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
*(9obs deleted)

tab integral ice_jornada
tab ice_segmento
*ensino_medio indica se escola tem segmento ensino integral
gen ensino_medio=1 
replace ensino_medio = 0 if ice_segmento == "EFII" | ice_segmento == "EF FINAIS" 
tab ice_segmento ensino_medio
order ensino_medio, after(ensino_fundamental)

/*
**********************************************************
PCA
**********************************************************
*/
*verificando a matriz de correlação entre alavancas
corr al_engaj_gov - al_proj if ensino_medio ==1

local alavancas al_engaj_gov al_engaj_sec al_time_seduc al_marcos_lei al_todos_marcos al_sel_dir al_sel_prof al_proj_vida
foreach x in `alavancas'{
tab `x' if ensino_medio ==1
}
/*

al_engaj_go |
          v |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |         45        7.22        7.22
          1 |        578       92.78      100.00
------------+-----------------------------------
      Total |        623      100.00

al_engaj_se |
          c |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |         46        7.38        7.38
          1 |        577       92.62      100.00
------------+-----------------------------------
      Total |        623      100.00

al_time_sed |
         uc |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |         35        5.62        5.62
          1 |        588       94.38      100.00
------------+-----------------------------------
      Total |        623      100.00

al_marcos_l |
         ei |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |          3        0.48        0.48
          1 |        620       99.52      100.00
------------+-----------------------------------
      Total |        623      100.00

al_todos_ma |
       rcos |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |         34        5.46        5.46
          1 |        589       94.54      100.00
------------+-----------------------------------
      Total |        623      100.00

 al_sel_dir |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        270       43.34       43.34
          1 |        353       56.66      100.00
------------+-----------------------------------
      Total |        623      100.00

al_sel_prof |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        285       45.75       45.75
          1 |        338       54.25      100.00
------------+-----------------------------------
      Total |        623      100.00

al_proj_vid |
          a |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        331       53.13       53.13
          1 |        292       46.87      100.00
------------+-----------------------------------
      Total |        623      100.00


*/
* note que marcos da lei foram implementadas em quase todas as escolas! (al_marcos_lei)
* somente em três escolas o programa não foi implantado de acordo com os marcos da lei
* assim, vamos desconsiderar da análise


pca al_engaj_gov al_engaj_sec al_time_seduc al_marcos_lei al_todos_marcos al_sel_dir al_sel_prof al_proj_vida if ensino_medio ==1
* fazendo a análise de componentes principais sem marcos da lei
pca al_engaj_gov al_engaj_sec al_time_seduc  al_todos_marcos al_sel_dir al_sel_prof al_proj_vida if ensino_medio ==1
screeplot

screeplot, yline(1) ci(het)

/*

pca al_engaj_gov al_engaj_sec al_time_seduc  al_todos_marcos al_sel_dir al_sel_prof al_proj_vida if ensino_medio ==1

Principal components/correlation                 Number of obs    =        623
                                                 Number of comp.  =          6
                                                 Trace            =          7
    Rotation: (unrotated = principal)            Rho              =     1.0000

    --------------------------------------------------------------------------
       Component |   Eigenvalue   Difference         Proportion   Cumulative
    -------------+------------------------------------------------------------
           Comp1 |      4.10544      1.76138             0.5865       0.5865
           Comp2 |      2.34407      1.86485             0.3349       0.9214
           Comp3 |      .479216      .438457             0.0685       0.9898
           Comp4 |     .0407585     .0151614             0.0058       0.9956
           Comp5 |     .0255971     .0206758             0.0037       0.9993
           Comp6 |    .00492121    .00492121             0.0007       1.0000
           Comp7 |            0            .             0.0000       1.0000
    --------------------------------------------------------------------------

Principal components (eigenvectors) 

    ----------------------------------------------------------------------------------------
        Variable |    Comp1     Comp2     Comp3     Comp4     Comp5     Comp6 | Unexplained 
    -------------+------------------------------------------------------------+-------------
    al_engaj_gov |   0.4152    0.2750   -0.4721    0.3415   -0.3644    0.0228 |           0 
    al_engaj_sec |   0.4161    0.2760   -0.4696   -0.1100    0.3964   -0.2757 |           0 
    al_time_se~c |   0.4084    0.2900    0.4762   -0.3445    0.4216   -0.0705 |           0 
    al_todos_m~s |   0.4082    0.2896    0.4853    0.1665   -0.4442    0.2720 |           0 
      al_sel_dir |   0.3028   -0.4968    0.2584    0.5288    0.0962   -0.5530 |           0 
     al_sel_prof |   0.3393   -0.4680   -0.1269    0.1143    0.3499    0.7171 |           0 
    al_proj_vida |  -0.3380    0.4630    0.1075    0.6574    0.4508    0.1563 |           0 
    ----------------------------------------------------------------------------------------


*/
predict pc1 pc2 pc3 pc4, score
* analisando os componentes, 
* temos que o comp 1 tem  4 valores positivos mais altos, 
* alavanca 1 - teve bom engajamento do governador
* alavanca 2 - teve bom engajamento do secretário de educação
* alavanca 3 - tinha time da SEDUC dedicado para a implantação do programa
* alavanca 4 - teve implantação dos marcos legais na forma da Lei?
* assim, esse componete será definido como o componente relacionado a questões políticas
rename pc1 comp_politico_positivo


* temos que o comp 2 tem 2 valores negativos altos
* alavanca 6 - teve Implantação do processo de seleção e remoção de diretores?
* alavanca 7 - teve Implantação do processo de seleção e remoção de professores?
* esse comoponete será definido como o componete da seleção e remoção de professores e funcionários
rename pc2 comp_selecao_remocao_negativo

* temos que o componente 3 tem 2 valores negativos altos alavanca 1 - teve bom engajamento do governador
* alavanca 2 - teve bom engajamento do secretário de educação
* e 2 valores positivos altos alavanca 3 - tinha time da SEDUC deducado para a implantação do programa
* alavanca 4 - teve implantação dos marcos legais na forma da Lei?
* esse comoponete será definido como o componente do engajamento do executivo
rename pc3 comp_eng_executivo_negativo

* temos que o componente 4 tem 1 valor postivo alto alavanca 8 - teve Implantação do projeto de vida na Matriz Curricular?
rename pc4 comp_proj_vida_positvo


corr al_engaj_gov - al_proj comp_politico - comp_proj_vida if ensino_medio ==1

* criando dummy do programa para fluxo e outro para nota
* essa distinção é necessária pois escolas do ensino médio 
* tanto de pernambuco quanto do ceara, tiveram o programa implementado
* inicialmente no primeiro ano. Assim, há um lag de 2 anos para o efeito em nota
* no entanto, o efeito em fluxo já deve se observado no primeiro ano

forvalues a=2004(1)2015{
gen ice_nota_`a' = ice_`a'
replace ice_nota_`a'=0 if (ano>`a'-2&ano<=`a')&(uf=="PE"|uf=="CE")&ensino_fundamental==0 


}

forvalues a=2004(1)2015{
gen ice_fluxo_`a' = ice_`a'
}



*dropando escolas que entraram somente em 2016
drop if ano_ice ==2016
*(9 observations deleted)
replace ice=1

save "$folderservidor\base_final_ice_2_14.dta", replace

use "$folderservidor\enem_censo_escolar_14_v1.dta", clear
/*aqui é onde difere da versão 2*/	
keep if enem == 1
*(920,541 observations deleted)

 
merge 1:1 codigo_escola ano using "$folderservidor\censo_escolar\censo_escolar_doc_todos.dta"


/*

    Result                           # of obs.
    -----------------------------------------
    not matched                     2,146,528
        from master                     3,049  (_merge==1)
        from using                  2,143,479  (_merge==2)

    matched                           152,024  (_merge==3)
    -----------------------------------------




*/
drop if _merge == 2
drop if _merge == 1
drop _merge
merge m:1 codigo_escola using "$folderservidor\base_final_ice_2_14.dta"
	/*
	   

    Result                           # of obs.
    -----------------------------------------
    not matched                       145,180
        from master                   145,116  (_merge==1)
        from using                         64  (_merge==2)

    matched                             6,908  (_merge==3)
    -----------------------------------------



	*/
*dropando observações que só estavam na base ICE
drop if _merge == 2
*(52 observations deleted)
drop _merge

sort  codigo_escola ano
format codigo_escola %10.0g

replace ice =0 if ice ==.

forvalues a=2004(1)2015{

replace ice_nota_`a'=0 if ice_nota_`a' ==.
replace ice_fluxo_`a'=0 if ice_fluxo_`a' ==.
}

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
* note que existem escolas que tem ensino médio, mas só receberam o programa no ensino fundamental
* então, para avaliar o impacto do programa na nota do enem, precisamos atribuir zero para as
* as escolas que tem somente EF
replace ice = 0 if ensino_medio ==0
replace d_ice_fluxo = 0 if d_segmento1==1 | d_segmento3==1 
replace d_ice_nota = 0 if d_segmento1==1 | d_segmento3==1

forvalues x=2004(1)2015{
replace ice_fluxo_`x'=0 if d_segmento1==1 | d_segmento3==1 
replace ice_nota_`x'=0 if d_segmento1==1 | d_segmento3==1 
}


/*dummy ice integral*/
*variávei que indica se escola participou do ICE integral
gen ice_inte=0
replace ice_inte=1 if ice_jornada=="INTEGRAL" 
replace ice_inte=1 if ice_jornada=="Integral" 

/*dummy ice semi-integral*/
*variávei que indica se escola participou do ICE semi-integral
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

*alavanca 3 - tinha time da SEDUC dedicado para a implantação do programa
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



*componentes principais das alavancas
local componentes_alavancas comp_politico_positivo comp_selecao_remocao_negativo comp_eng_executivo_negativo comp_proj_vida_positvo
foreach x in `componentes_alavancas' {
replace `x'=0 if `x'==.
}
*gerando variável de interaçõa entre componentes e ice
*componente 1 - componente político
gen d_ice_nota_comp1=d_ice_nota*comp_politico_positivo
gen d_ice_fluxo_comp1=d_ice_fluxo*comp_politico_positivo

*componente 2 - componente seleção
gen d_ice_nota_comp2=d_ice_nota*(-comp_selecao_remocao_negativo)
gen d_ice_fluxo_comp2=d_ice_fluxo*(-comp_selecao_remocao_negativo)

*componente 3 -  componente engajamento do executivo
gen d_ice_nota_comp3=d_ice_nota*(-comp_eng_executivo_negativo)
gen d_ice_fluxo_comp3=d_ice_fluxo*(-comp_eng_executivo_negativo)

*componente 4 - componente projeto de vida
gen d_ice_nota_comp4=d_ice_nota*comp_proj_vida_positvo
gen d_ice_fluxo_comp4=d_ice_fluxo*comp_proj_vida_positvo

/*
**********************************************************
Mais Educação
**********************************************************
*/

merge m:1 codigo_escola using "$folderservidor\\mais_educacao_todos.dta"
drop if _merge ==2
sort ano codigo_escola
gen mais_educ=0


foreach x of varlist mais_educacao_fund_2010 - mais_educacao_x_2009 n_turmas_mais_educ_em_1 - n_turmas_mais_educ_em_3 n_turmas_mais_educ_em_inte_1- n_turmas_mais_educ_em_inte_ns{
replace mais_educ=1 if `x'>0&`x'!=.
}
drop mais_educacao_fund_2010 - mais_educacao_x_2009
drop _merge
drop uf




/*
**********************************************************
Ajustes Finais na base
**********************************************************
*/



/*-------------------------------------------------------------------*/
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


* gerando dummies de ano
tab ano, gen(d_ano)
/*

*/


/*-------------------------------------------------------------------*/
* agregando variáveis de número de alunos, mulheres, e brancos 
* no ensino médio normal, no integrado e no profissionalizante

mdesc n_alunos_em_1 - n_alunos_em_3 n_mulheres_em_1 n_mulheres_em_3 n_brancos_em_1 n_brancos_em_3
* predio 
* diretoria 
* sala_professores 
* biblioteca 
* internet 
* lixo_coleta
* eletricidade 
* agua 
* esgoto
* n_alunos_em_1
* são variáveis presentes 
* em todos anos, com poucos missings

* p_mulheres_em_1
* são variáveis presentes, mas com uma taxa relativamente alta de
* missings

* sala de leitura 
* não está presente nos anos de 2007 e 2008

* refeitório 
* não está presente nos anos de 2007 a 2011

* n_brancos_em_1  
* p_brancos_em_1 
* não está presente nos anos de 2003 e 2004

* n_salas_exis  
* regular 
* em_integrado  
* em_normal
* n_turmas_em_1 
* n_alu_transporte_publico_em_1 
* m_idade_em_1*
* p_alu_transporte_publico_em_1 
* n_alunos_em_inte_1
* n_mulheres_em_inte_1 
* n_brancos_em_inte_1
* n_profs_em_1 
* n_profs_sup_em_1 
* p_profs_sup_em_1
* n_profs_em_inte_1 
* n_profs_sup_em_inte_1
* não está presente nos anos de 2003 a 2006 
* muitas das variáveis não estão presentes no pré 2007 pois em 2007 o INEP
* implementou o educacenso, um sistema onde as próprias escolas imputavam as 
* informações, permitindo a desagregação por aluno


/*
a partir de 2007, há informações se os alunos são do ensino médio normal
ou do ensino médio integrado. assim, a partir de 2007, se a informação é missing
no número de alunos, é por que provavelmente a escola tem a outra categoria de
alunos por exmeplo, se há missings em n_alunos_em_1, 
provavelmente n_alunos_ep_1 é  diferente de zero portanto, 
vamos substituir os missings 
*/
forvalues x=1(1)3{
replace n_alunos_em_`x'=0 if n_alunos_em_`x'==. 
replace n_mulheres_em_`x'=0 if n_mulheres_em_`x'==. 
replace n_brancos_em_`x'=0 if n_brancos_em_`x'==. 
}

/*
as variáveis de número de alunos, mulheres e brancos do ensino médio integrado
só apareceram a partir do ano de 2007, com o educacenso
assim, para tais anos, como no caso anterior, vamos substituir os missings
por zeros
*/

foreach x in "1" "2" "3" "4" "ns"{
replace n_alunos_em_inte_`x'=0 if n_alunos_em_inte_`x'==. & ano>2006
replace n_mulheres_em_inte_`x'=0 if n_mulheres_em_inte_`x'==. & ano>2006
replace n_brancos_em_inte_`x'=0 if n_brancos_em_inte_`x'==. & ano>2006
}

* agregando os números de alunos, mulheres e brancos por série
* em uma variável unica para a modalidade de ensino médio
* note novamente que nos ans anteriores somente as variáveis de núnmero de
* alunos e mulheres do ensino médio normal estavam presentes

gen n_alunos_em = n_alunos_em_1 + n_alunos_em_2 + n_alunos_em_3
*(2,535 missing values generated)
*replace n_alunos_em=0 if n_alunos_em==.

gen n_mulheres_em = n_mulheres_em_1+n_mulheres_em_2 + n_mulheres_em_3
*(2,535 missing values generated)
*replace n_mulheres_em=0 if n_mulheres_em==.

gen n_brancos_em = .
*(1,075,614 missing values generated)
replace n_brancos_em = n_brancos_em_1+n_brancos_em_2 + n_brancos_em_3 if ano>2006
*(769,353 real changes made)


*replace n_brancos_em=0 if n_brancos_em==.

mdesc n_alunos_em n_mulheres_em n_brancos_em

* agregando os números de alunos, mulheres e brancos por série
* em uma variável unica para a modalidade de ensino médio integrado
gen n_alunos_ep= .
*(1,075,614 missing values generated)
replace n_alunos_ep = n_alunos_em_inte_1+ n_alunos_em_inte_2+ n_alunos_em_inte_3 +n_alunos_em_inte_4 +n_alunos_em_inte_ns if ano >2006
*(769,353 real changes made)

*replace n_alunos_ep=0 if n_alunos_ep==.
gen n_mulheres_ep = .
*(1,075,614 missing values generated)
replace n_mulheres_ep=n_mulheres_em_inte_1+ n_mulheres_em_inte_2+ n_mulheres_em_inte_3 +n_mulheres_em_inte_4 +n_mulheres_em_inte_ns if ano>2006
*(769,353 real changes made)	

*replace n_mulheres_ep=0 if n_mulheres_ep==.

gen n_brancos_ep=.
*(161,079 missing values generated)
replace n_brancos_ep = n_brancos_em_inte_1+ n_brancos_em_inte_2+ n_brancos_em_inte_3 +n_brancos_em_inte_4 +n_brancos_em_inte_ns if ano>2006
*(122,039 real changes made)
*replace n_brancos_ep=0 if n_brancos_ep==.

mdesc n_alunos_ep n_mulheres_ep n_brancos_ep


* gerando uma variável única para número de alunos de ensino medio
* sejam eles do ensino médio comum ou do profissionalizante
* para os anos anteriores de 2007, como só temos variáveis de ensino médio normal
* e somente variáveis de mulheres e alunos, vamos consider essas variáveis já abarcam
* o número total de alunos de em normal e profissionalizante
gen n_alunos_em_ep =.
* (1,075,614 missing values generated)
replace n_alunos_em_ep = n_alunos_em if ano <2007
* (306,261 real changes made)
replace n_alunos_em_ep = n_alunos_em  + n_alunos_ep if ano>2006
* (769,353 real changes made)


gen n_mulheres_em_ep = .
*(1,075,614 missing values generated)
replace n_mulheres_em_ep = n_mulheres_em if ano<2007
* (306,261 real changes made)
replace n_mulheres_em_ep = n_mulheres_em + n_mulheres_ep if ano>2006
* (769,353 real changes made)

gen n_brancos_em_ep = n_brancos_em + n_brancos_ep
*(306,261 missing values generated)
*analisando os missings
mdesc n_alunos_em_ep n_mulheres_em_ep n_brancos_em_ep


*analisando os missings e os zeros por ano
tab ano if n_alunos_em_ep ==.
tab ano if n_alunos_em_ep !=.

tab ano if n_alunos_em_ep ==0
tab ano if n_alunos_em_ep !=0

tab ano if n_mulheres_em_ep ==.
tab ano if n_mulheres_em_ep !=.


tab ano if n_mulheres_em_ep ==0
tab ano if n_mulheres_em_ep !=0

* se o número total de alunos no ensino médio, seja ele normal ou profissionalizante
* for igual a zero, há algo de errado. vamos atribuir missings
replace n_alunos_em_ep =.  if n_alunos_em_ep ==0
replace n_mulheres_em_ep =.  if n_mulheres_em_ep ==0
mdesc n_alunos_em_ep n_mulheres_em_ep

/*-------------------------------------------------------------------*/
* Criando Taxas de Participacao no ENEM e na Prova Brasil 


**** ENEM ****
replace concluir_em_ano_enem=0 if concluir_em_ano_enem==.
*(6,006 real changes made)
*gen taxa_participacao_enem=taxa_participacao_enem/100
gen taxa_participacao_enem_aux=.
replace taxa_participacao_enem_aux = concluir_em_ano_enem/ n_alunos_em_3 if ano <2007
*(35,847 real changes made)
replace taxa_participacao_enem_aux = concluir_em_ano_enem/ (n_alunos_em_inte_3 + n_alunos_em_3) if ano>2006
*(96,941 real changes made)
replace taxa_participacao_enem_aux = 0 if concluir_em_ano_enem ==0 & n_alunos_em_3 == 0 & n_alunos_em_inte_3 == 0 & ano> 2006
replace taxa_participacao_enem_aux = 0 if concluir_em_ano_enem ==0 & n_alunos_em_3 == 0 & ano< 2007

mdesc taxa_participacao_enem_aux concluir_em_ano_enem n_alunos_em_3 n_alunos_em_inte_3 if  ano>2006
mdesc taxa_participacao_enem_aux concluir_em_ano_enem n_alunos_em_3  if  ano<2007

*no uf 23 pernambuco há escolas porifssionalizantes
*gen taxa_participacao_enem_aux2=concluir_em_ano_enem/(n_alunos_em_inte_3+n_alunos_em_3) if codigo_uf==23 & ano >2006 

gen taxa_participacao_enem=taxa_participacao_enem_aux
*replace taxa_participacao_enem=taxa_participacao_enem_aux2 if codigo_uf==23 & ano >2006 
*replace taxa_participacao_enem = taxa_participacao_enem_aux
mdesc taxa_participacao_enem
tab ano if taxa_participacao_enem != .
tab ano if taxa_participacao_enem == .

drop n_turmas_mais_educ_em_1 n_turmas_mais_educ_em_2 n_turmas_mais_educ_em_3 n_turmas_mais_educ_em_inte_1 n_turmas_mais_educ_em_inte_2 n_turmas_mais_educ_em_inte_3 n_turmas_mais_educ_em_inte_4 n_turmas_mais_educ_em_inte_ns 
* lidando com informações do ice que não estão presentes no resto da base
drop ice_jornada ice_segmento ice_rigor


foreach variable of varlist  ice_2004 - ice_2015 d_rigor1 - d_segmento5{
replace `variable' = 0 if `variable' == .

}
mdesc  codigo_escola - taxa_participacao_enem
ds


order ano_ice, after(ano_enem)
order nome_escola_censo, after(nome_escola_censo_escolar)
sort codigo_escola ano
sort codigo_escola ano

by codigo_escola: gen enem_nota_objetivab_std_lag = enem_nota_objetivab_std[_n-1] if ano==ano[_n-1]+1
order enem_nota_objetivab_std_lag, after(enem_nota_objetivab_std)

by codigo_escola: gen enem_nota_redacao_std_lag = enem_nota_redacao_std[_n-1] if ano==ano[_n-1]+1 
order enem_nota_redacao_std_lag, after(enem_nota_redacao_std)

by codigo_escola: gen rep_em_std_lag = rep_em_std[_n-1] if ano==ano[_n-1]+1 
order rep_em_std_lag, after(rep_em_std)

by codigo_escola: gen aba_em_std_lag = aba_em_std[_n-1] if ano==ano[_n-1]+1 
order aba_em_std_lag, after(aba_em_std)


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
gen d_enem = .
replace d_enem = 1 if enem ==1
replace d_enem = 0 if enem ==.
order d_enem,after(enem)
*by codigo_escola (ano), sort: gen byte first = sum(d_enem) == 1

by codigo_escola (ano), sort: gen noccur = sum(d_enem)
by codigo_escola: gen byte first = noccur == 1  & noccur[_n - 1] != noccur
order first, after(d_enem)
rename first d_entrada_enem

egen any_ice = max(ice), by(codigo_escola) 

gen escola_ice =0
replace escola_ice = 1 if ano_ice !=.
*escola_ice indica todas as escolas que receberam o programa, sejam elas 
*ensino médio ou ensino fundamental

gen escola_ice_em = 0 
replace escola_ice_em = 1 if ano_ice !=. & ensino_medio ==1



gen d_entrada_enem_2004 = 0
replace d_entrada_enem_2004 = 1 if d_entrada_enem==1 & ano==2004 & escola_ice_em==1
gen d_entrada_enem_2005 = 0
replace d_entrada_enem_2005 = 1 if d_entrada_enem==1 & ano==2005 & escola_ice_em==1
gen d_entrada_enem_2006 = 0
replace d_entrada_enem_2006 = 1 if d_entrada_enem==1 & ano==2006 & escola_ice_em==1
gen d_entrada_enem_2007 = 0
replace d_entrada_enem_2007 = 1 if d_entrada_enem==1 & ano==2007 & escola_ice_em==1
gen d_entrada_enem_2008 = 0
replace d_entrada_enem_2008 = 1 if d_entrada_enem==1 & ano==2008 & escola_ice_em==1
gen d_entrada_enem_2009 = 0
replace d_entrada_enem_2009 = 1 if d_entrada_enem==1 & ano==2009 & escola_ice_em==1
gen d_entrada_enem_2010 = 0
replace d_entrada_enem_2010 = 1 if d_entrada_enem==1 & ano==2010 & escola_ice_em==1
gen d_entrada_enem_2011 = 0
replace d_entrada_enem_2011 = 1 if d_entrada_enem==1 & ano==2011 & escola_ice_em==1
gen d_entrada_enem_2012 = 0
replace d_entrada_enem_2012 = 1 if d_entrada_enem==1 & ano==2012 & escola_ice_em==1
gen d_entrada_enem_2013 = 0
replace d_entrada_enem_2013 = 1 if d_entrada_enem==1 & ano==2013 & escola_ice_em==1
gen d_entrada_enem_2014 = 0
replace d_entrada_enem_2014 = 1 if d_entrada_enem==1 & ano==2014 & escola_ice_em==1

gen d_entrada_enem_2015 = 0
replace d_entrada_enem_2015 = 1 if d_entrada_enem==1 & ano==2015 & escola_ice_em==1


	xtset codigo_escola ano
	*

	gen DV = 0
	bysort codigo_escola (ano): replace DV = 1 if _n == 1
	order DV, after(codigo_escola)
	sort ano_ice codigo_escola ano 

	

	
	
	
gen n_total_em = n_prof_em_ef_incomp + n_prof_em_ef_comp + n_prof_em_em + n_prof_em_sup
gen p_em_superior = .
replace p_em_superior = n_prof_em_sup/n_total_em
order n_total_em p_em_superior, after (n_prof_em_sup)

sort codigo_escola ano

by codigo_escola: gen d_ice_nota_lag = d_ice_nota[_n-1] if ano==ano[_n-1]+1
order d_ice_nota_lag, after(d_ice_nota)

by codigo_escola: gen d_ice_fluxo_lag = d_ice_fluxo[_n-1] if ano==ano[_n-1]+1 
order d_ice_fluxo_lag, after(d_ice_fluxo)
	
by codigo_escola: gen dist_em_std_lag = dist_em_std[_n-1] if ano==ano[_n-1]+1
order dist_em_std_lag, after(dist_em_std)

by codigo_escola: gen apr_em_std_lag = apr_em_std[_n-1] if ano==ano[_n-1]+1 
order apr_em_std_lag, after(apr_em_std)


*gerando as variáveis defasadas dois anos
sort codigo_escola ano

by codigo_escola: gen d_ice_nota_lag_2 = d_ice_nota[_n-2] if ano==ano[_n-2]+2
order d_ice_nota_lag_2, after(d_ice_nota_lag)

by codigo_escola: gen d_ice_fluxo_lag_2 = d_ice_fluxo[_n-2] if ano==ano[_n-2]+2 
order d_ice_fluxo_lag_2, after(d_ice_fluxo_lag)

by codigo_escola: gen enem_nota_objetivab_std_lag_2 = enem_nota_objetivab_std[_n-2] if ano==ano[_n-2]+2
order enem_nota_objetivab_std_lag_2, after(enem_nota_objetivab_std_lag)

by codigo_escola: gen enem_nota_redacao_std_lag_2 = enem_nota_redacao_std[_n-2] if ano==ano[_n-2]+2 
order enem_nota_redacao_std_lag_2, after(enem_nota_redacao_std_lag)

by codigo_escola: gen dist_em_std_lag_2 = dist_em_std[_n-2] if ano==ano[_n-2]+2
order dist_em_std_lag_2, after(dist_em_std_lag)

by codigo_escola: gen apr_em_std_lag_2 = apr_em_std[_n-2] if ano==ano[_n-2]+2 
order apr_em_std_lag_2, after(apr_em_std_lag)


by codigo_escola: gen rep_em_std_lag_2 = rep_em_std[_n-2] if ano==ano[_n-2]+2 
order rep_em_std_lag_2, after(rep_em_std_lag)

by codigo_escola: gen aba_em_std_lag_2 = aba_em_std[_n-2] if ano==ano[_n-2]+2 
order aba_em_std_lag_2, after(aba_em_std_lag)
	

save "$folderservidor\dados_EM_14_v3.dta", replace
save "\\tsclient\C\Users\Leonardo.idea-PC\Dropbox\OneDrive\O\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\dados_EM_14_v3.dta", replace
log close