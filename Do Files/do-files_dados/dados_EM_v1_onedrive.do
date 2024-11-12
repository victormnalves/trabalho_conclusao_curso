/*****************************************************************************
******************************************************************************

DADOS - Ensino médio

******************************************************************************
******************************************************************************/

**04/10/2018

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
*sysdir set PLUS \\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\ado
sysdir set PLUS \\fs-eesp-01\EESP\Usuarios\bruna.mirelle\makoto\ado
capture log close
clear all
set more off, permanently
*global folderservidor "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"
global folderservidor "\\fs-eesp-01\EESP\Usuarios\bruna.mirelle\makoto\"
log using "$folderservidor\\logfiles/dados_EM_v1.log", replace


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

/*
***********************************************************************
Municípios
arrumando código dos municípios, mergeando com dados
de pib pib per capita população
***********************************************************************
*/
* os primeiros dois digitos e os ultimos cinco dão o codigo
* do município

tostring codigo_municipio, gen(codigo_municipios) format(%20.0g) 
gen cod_aux1=substr(codigo_municipios,1,2) 
gen cod_aux2=substr(codigo_municipios,strlen(codigo_municipios) - 4,5)
gen cod_munic = cod_aux1 +cod_aux2

destring cod_munic, replace
order cod_munic, after (codigo_municipios)

drop codigo_municipios cod_aux1 cod_aux2 
sort cod_munic
rename codigo_municipio codigo_municipio_longo

gen ano = ano_enem
merge m:1 cod_munic ano using "$folderservidor\\pib_municipio\pib_capita_municipio_2003_2015_final_14.dta"

/*

    Result                           # of obs.
    -----------------------------------------
    not matched                         1,822
        from master                        63  (_merge==1)
        from using                      1,759  (_merge==2)

    matched                           353,603  (_merge==3)
    -----------------------------------------


*/

drop if _merge==2
rename pib_capita_mil_reals pib_capita_mil_reais

drop _merge pib_capita_mil_reais ipca_acumulado_2015 ipca_acumulado_base2003 ipca_acumulado_ano 
merge m:1 cod_munic  using "$folderservidor\\pib_municipio\codigo_uf_cod_munic.dta"

/*
    Result                           # of obs.
    -----------------------------------------
    not matched                            67
        from master                        63  (_merge==1)
        from using                          4  (_merge==2)

    matched                           353,603  (_merge==3)
    -----------------------------------------
*/
drop _merge

*vamos reordernar as variáveis na tabela para faciliar a manipulação das notas

order codigo_escola
order ano, after(codigo_escola)
order ano_enem, after(ano)
order cod_munic, after(ano_enem)
order cod_meso, after(cod_munic)
order nome_municipio pib pop pib_capita_reias pib_capita_reais_real_2003 pib_capita_reais_real_2015, after (cod_meso)
order codigo_uf estado, after (nome_municipio)
order enem_nota_objetiva, before (enem_nota_matematica)
order enem_nota_redacao, after (enem_nota_ciencias)
order codigo_municipio_longo, after(cod_munic)

sort ano codigo_escola
drop if codigo_escola ==.
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
foreach x in "enem_nota_objetiva_std" "enem_nota_objetivab_std" "enem_nota_redacao_std" "enem_nota_matematica_std" "enem_nota_ciencias_std" "enem_nota_humanas_std" "enem_nota_linguagens_std"  "apr_em_std"  "rep_em_std"  "aba_em_std"  "dist_em_std" {
sum `x' if ano ==2009
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
*mantendo somente observações que tem características no CENSO, e que tem nota ou indicadores de fluxo
drop if _merge == 2 
*(914,535 observations deleted)
drop if _merge == 1
*(198,582 observations deleted)
drop _merge

sort ano codigo_escola
drop mascara codigo_municipio UF sigla 



* vamos descartar as variáveis sobre ensino fundamental, pois estamos
* em uma análise do EM (com exceçao dos outcomes do ef, que serão
* usados para placebo
drop n_turmas_fund_5_8anos - n_turmas_fund_9_9anos n_alunos_fund_5_8anos - n_alunos_fund_9_9anos n_mulheres_fund_5_8anos - n_mulheres_fund_9_9anos n_brancos_fund_5_8anos - n_brancos_fund_9_9anos n_transp_pub_fund_5_8anos - n_transp_pub_fund_9_9anos m_idade_fund_5_8anos - m_idade_fund_9_9anos p_mulheres_fund_5_8anos - p_mulheres_fund_9_9anos p_brancos_fund_5_8anos - p_brancos_fund_9_9anos p_transp_pub_fund_5_8anos - p_transp_pub_fund_9_9anos n_profs_fund_5_8anos - p_profs_sup_fund_9_9anos n_turmas_mais_educ_fund_5_8anos - n_turmas_mais_educ_fund_9_9anos
mdesc codigo_escola - n_turmas_mais_educ_em_inte_ns
/*

    Variable    |     Missing          Total     Percent Missing
----------------+-----------------------------------------------
   codigo_esc~a |           0        161,079           0.00
            ano |           0        161,079           0.00
       ano_enem |       6,006        161,079           3.73
      cod_munic |       6,006        161,079           3.73
   codigo_mu~go |       6,006        161,079           3.73
       cod_meso |       6,006        161,079           3.73
   nome_munic~o |       6,006        161,079           3.73
      codigo_uf |       6,006        161,079           3.73
         estado |       6,006        161,079           3.73
            pib |       6,006        161,079           3.73
            pop |       6,006        161,079           3.73
   pib_capita~s |       6,006        161,079           3.73
   pib_cap~2003 |       6,006        161,079           3.73
   pib_cap~2015 |       6,006        161,079           3.73
   concluir_e~m |       6,006        161,079           3.73
   e_mora_mai~s |       8,365        161,079           5.19
   e_escol_su~i |       9,193        161,079           5.71
   e_escol_su~e |       8,686        161,079           5.39
   e_renda_fa~s |       8,386        161,079           5.21
   e_trabalho~u |       9,420        161,079           5.85
   enem_nota~va |     100,414        161,079          62.34
   enem_nota~ca |      69,724        161,079          43.29
   enem_nota~ns |      69,724        161,079          43.29
   enem_not~nas |      69,485        161,079          43.14
   enem_not~ias |      69,485        161,079          43.14
   enem_nota_~o |       6,378        161,079           3.96
         apr_ef |      82,467        161,079          51.20
         apr_em |      58,498        161,079          36.32
         rep_ef |      77,430        161,079          48.07
         rep_em |      58,498        161,079          36.32
         aba_ef |      77,430        161,079          48.07
         aba_em |      58,498        161,079          36.32
        dist_ef |      77,814        161,079          48.31
        dist_em |      60,525        161,079          37.57
       em_fluxo |      56,950        161,079          35.36
   enem_nota_~b |       9,096        161,079           5.65
   enem_~va_std |     100,414        161,079          62.34
   enem_n~b_std |       9,096        161,079           5.65
   enem_n~o_std |       6,378        161,079           3.96
   enem_~ca_std |      69,724        161,079          43.29
   enem~ias_std |      69,485        161,079          43.14
   enem~nas_std |      69,485        161,079          43.14
   enem_~ns_std |      69,724        161,079          43.29
     apr_em_std |      58,498        161,079          36.32
     rep_em_std |      58,498        161,079          36.32
     aba_em_std |      58,498        161,079          36.32
    dist_em_std |      60,525        161,079          37.57
   dependenci~a |           0        161,079           0.00
   n_copiadoras |     122,129        161,079          75.82
      n_arsalas |     122,129        161,079          75.82
   n_impresso~s |     122,129        161,079          75.82
   n_salas_perm |     122,129        161,079          75.82
   n_salas_prov |     122,129        161,079          75.82
    n_sala_util |     122,129        161,079          75.82
   n_sala_uti~a |     122,129        161,079          75.82
     n_profs_em |     122,129        161,079          75.82
   n_profs_em~a |     122,129        161,079          75.82
   n_profs_em~o |     122,129        161,079          75.82
   n_profs_em~g |     122,129        161,079          75.82
   n_turmas_d~1 |     127,627        161,079          79.23
   n_turmas_d~2 |     127,627        161,079          79.23
   n_turmas_d~3 |     127,627        161,079          79.23
   n_turmas_d~4 |     127,627        161,079          79.23
   n_turmas_d~s |     127,627        161,079          79.23
   n_alunos_d~1 |     127,627        161,079          79.23
   n_alunos_d~2 |     127,627        161,079          79.23
   n_alunos_d~3 |     127,627        161,079          79.23
   n_alunos_d~4 |     127,627        161,079          79.23
   n_alunos_d~s |     127,627        161,079          79.23
   n_turmas_n~1 |     137,735        161,079          85.51
   n_turmas_n~2 |     137,735        161,079          85.51
   n_turmas_n~3 |     137,735        161,079          85.51
   n_turmas_n~4 |     137,735        161,079          85.51
   n_turmas_n~s |     137,735        161,079          85.51
   n_alunos_n~1 |     137,735        161,079          85.51
   n_alunos_n~2 |     137,735        161,079          85.51
   n_alunos_n~3 |     137,735        161,079          85.51
   n_alunos_n~4 |     137,735        161,079          85.51
   n_alunos_n~s |     137,735        161,079          85.51
   n_mul~s_em_1 |       5,439        161,079           3.38
   n_mul~s_em_2 |       5,439        161,079           3.38
   n_mul~s_em_3 |       5,439        161,079           3.38
   n_mul~s_em_4 |     152,527        161,079          94.69
   n_mu~s_em_ns |     152,527        161,079          94.69
          rural |           0        161,079           0.00
          ativa |           0        161,079           0.00
             em |      16,820        161,079          10.44
        em_prof |      46,472        161,079          28.85
         predio |         720        161,079           0.45
      diretoria |         469        161,079           0.29
   sala_profe~s |         470        161,079           0.29
     biblioteca |         470        161,079           0.29
   sala_leitura |      24,000        161,079          14.90
     refeitorio |      66,278        161,079          41.15
       lab_info |         472        161,079           0.29
   lab_ciencias |         472        161,079           0.29
   quadra_esp~s |         472        161,079           0.29
       internet |       4,446        161,079           2.76
    lixo_coleta |       2,994        161,079           1.86
   eletricidade |       2,994        161,079           1.86
           agua |       2,994        161,079           1.86
         esgoto |       2,995        161,079           1.86
   n_salas_ut~s |       2,994        161,079           1.86
   p_profs_em~n |     124,574        161,079          77.34
   p_profs_em~s |     124,574        161,079          77.34
   p_profs_em~g |     124,574        161,079          77.34
   n_alunos~u_1 |     128,031        161,079          79.48
   n_alunos~u_2 |     129,654        161,079          80.49
   n_alunos~u_3 |     131,652        161,079          81.73
   n_alunos~t_1 |     139,613        161,079          86.67
   n_alunos~t_2 |     138,779        161,079          86.16
   n_alunos~t_3 |     138,325        161,079          85.87
   n_alu~s_em_1 |       5,439        161,079           3.38
   n_alu~s_em_2 |       5,439        161,079           3.38
   n_alu~s_em_3 |       5,439        161,079           3.38
   p_mul~s_em_1 |      25,181        161,079          15.63
   p_mul~s_em_2 |      27,409        161,079          17.02
   p_mul~s_em_3 |      29,708        161,079          18.44
   n_mul~u_em_1 |     133,126        161,079          82.65
   n_mul~u_em_2 |     133,126        161,079          82.65
   n_mul~u_em_3 |     133,126        161,079          82.65
   n_mul~u_em_4 |     133,126        161,079          82.65
   n_mu~u_em_ns |     133,126        161,079          82.65
   n_mul~t_em_1 |     133,126        161,079          82.65
   n_mul~t_em_2 |     133,126        161,079          82.65
   n_mul~t_em_3 |     133,126        161,079          82.65
   n_mul~t_em_4 |     133,126        161,079          82.65
   n_mu~t_em_ns |     133,126        161,079          82.65
   dir_sup_se~n |     151,916        161,079          94.31
   dir_sup_co~n |     151,916        161,079          94.31
        dir_pos |     151,916        161,079          94.31
   dir_concurso |     151,916        161,079          94.31
   dir_indicado |     151,916        161,079          94.31
     dir_eleito |     151,916        161,079          94.31
   org_se~l_diu |     152,133        161,079          94.45
   org_se~l_not |     152,133        161,079          94.45
   org_se~s_diu |     152,133        161,079          94.45
   org_se~s_not |     161,079        161,079         100.00
   org_ci~l_diu |     152,133        161,079          94.45
   org_ci~l_not |     152,133        161,079          94.45
   org_ci~s_diu |     152,133        161,079          94.45
   org_ci~s_not |     152,133        161,079          94.45
   p_mul~u_em_1 |     135,766        161,079          84.29
   p_mul~u_em_2 |     136,957        161,079          85.02
   p_mul~u_em_3 |     138,388        161,079          85.91
    em_int_prof |     140,609        161,079          87.29
   n_bra~u_em_1 |     142,072        161,079          88.20
   n_bra~u_em_2 |     142,072        161,079          88.20
   n_bra~u_em_3 |     142,072        161,079          88.20
   n_bra~u_em_4 |     142,072        161,079          88.20
   n_br~u_em_ns |     142,072        161,079          88.20
   n_bra~t_em_1 |     142,072        161,079          88.20
   n_bra~t_em_2 |     142,072        161,079          88.20
   n_bra~t_em_3 |     142,072        161,079          88.20
   n_bra~t_em_4 |     142,072        161,079          88.20
   n_br~t_em_ns |     142,072        161,079          88.20
   n_bra~s_em_1 |      22,937        161,079          14.24
   n_bra~s_em_2 |      22,937        161,079          14.24
   n_bra~s_em_3 |      22,937        161,079          14.24
   p_branco~m_1 |      45,477        161,079          28.23
   p_branco~m_2 |      49,365        161,079          30.65
   p_branco~m_3 |      52,779        161,079          32.77
    nome_escola |      39,040        161,079          24.24
   codigo_mu~vo |      39,040        161,079          24.24
   ID_LOCALIZ~O |     149,583        161,079          92.86
   n_salas_exis |      42,074        161,079          26.12
        regular |      55,860        161,079          34.68
   em_integrado |      55,860        161,079          34.68
      em_normal |      55,860        161,079          34.68
   n_tur~s_em_1 |      41,944        161,079          26.04
   n_tur~s_em_2 |      41,944        161,079          26.04
   n_tur~s_em_3 |      41,944        161,079          26.04
   n_turmas_e.. |      41,944        161,079          26.04
   n_turmas_e~4 |      41,944        161,079          26.04
   n_turmas_e~s |      41,944        161,079          26.04
   n_alu_tr~m_1 |      41,944        161,079          26.04
   n_alu_tr~m_2 |      41,944        161,079          26.04
   n_alu_tr~m_3 |      41,944        161,079          26.04
   m_idade_em_1 |      61,234        161,079          38.01
   m_idade_em_2 |      63,323        161,079          39.31
   m_idade_em_3 |      65,555        161,079          40.70
   p_alu_tr~m_1 |      61,234        161,079          38.01
   p_alu_tr~m_2 |      63,323        161,079          39.31
   p_alu_tr~m_3 |      65,555        161,079          40.70
   n_alunos~e_1 |      41,944        161,079          26.04
   n_alunos~e_2 |      41,944        161,079          26.04
   n_alunos~e_3 |      41,944        161,079          26.04
   n_alunos_e~4 |      41,944        161,079          26.04
   n_alunos_e~s |      41,944        161,079          26.04
   n_mulher~e_1 |      41,944        161,079          26.04
   n_mulher~e_2 |      41,944        161,079          26.04
   n_mulher~e_3 |      41,944        161,079          26.04
   n_mulher~e_4 |      41,944        161,079          26.04
   n_mulhe~e_ns |      41,944        161,079          26.04
   n_branco~e_1 |      41,944        161,079          26.04
   n_branco~e_2 |      41,944        161,079          26.04
   n_branco~e_3 |      41,944        161,079          26.04
   n_branco~e_4 |      41,944        161,079          26.04
   n_branc~e_ns |      41,944        161,079          26.04
   n_alu_tr~e_1 |      41,944        161,079          26.04
   n_alu_tr~e_2 |      41,944        161,079          26.04
   n_alu_tr~e_3 |      41,944        161,079          26.04
   n_alu_tran~4 |      41,944        161,079          26.04
   n_alu_tran~s |      41,944        161,079          26.04
   m_idade_~e_1 |     157,778        161,079          97.95
   m_idade_~e_2 |     158,258        161,079          98.25
   m_idade_~e_3 |     158,748        161,079          98.55
   m_idade_em~4 |     160,765        161,079          99.81
   m_idade_em~s |     160,875        161,079          99.87
   p_mulher~e_1 |     157,778        161,079          97.95
   p_mulher~e_2 |     158,258        161,079          98.25
   p_mulher~e_3 |     158,748        161,079          98.55
   p_mulheres~4 |     160,765        161,079          99.81
   p_mulheres~s |     160,875        161,079          99.87
   p_branco~e_1 |     157,802        161,079          97.97
   p_branco~e_2 |     158,321        161,079          98.29
   p_branco~e_3 |     158,848        161,079          98.61
   p_brancos_~4 |     160,775        161,079          99.81
   p_brancos_~s |     160,891        161,079          99.88
   p_alu_tr~e_1 |     157,778        161,079          97.95
   p_alu_tr~e_2 |     158,258        161,079          98.25
   p_alu_tr~e_3 |     158,748        161,079          98.55
   p_alu_tran~4 |     160,765        161,079          99.81
   p_alu_tran~s |     160,875        161,079          99.87
   n_profs_em_1 |      42,130        161,079          26.15
   n_profs_em_2 |      42,130        161,079          26.15
   n_profs_em_3 |      42,130        161,079          26.15
   n_pro~p_em_1 |      42,130        161,079          26.15
   n_pro~p_em_2 |      42,130        161,079          26.15
   n_pro~p_em_3 |      42,130        161,079          26.15
   p_profs_~m_1 |      61,378        161,079          38.10
   p_profs_~m_2 |      63,458        161,079          39.40
   p_profs_~m_3 |      65,684        161,079          40.78
   n_profs_em.. |      42,130        161,079          26.15
   n_profs_em.. |      42,130        161,079          26.15
   n_profs_em.. |      42,130        161,079          26.15
   n_profs_em~4 |      42,130        161,079          26.15
   n_profs_em~s |      42,130        161,079          26.15
   n_profs_su.. |      42,130        161,079          26.15
   n_profs_su.. |      42,130        161,079          26.15
   n_profs_su.. |      42,130        161,079          26.15
   n_profs_su~4 |      42,130        161,079          26.15
   n_profs_su~s |      42,130        161,079          26.15
   p_profs_~e_1 |     157,782        161,079          97.95
   p_profs_~e_2 |     158,265        161,079          98.25
   p_profs_~e_3 |     158,754        161,079          98.56
   p_profs_su~4 |     160,766        161,079          99.81
   p_profs_su~s |     160,877        161,079          99.87
    fund_8_anos |      92,810        161,079          57.62
    fund_9_anos |      92,810        161,079          57.62
   distrito_e~o |      91,059        161,079          56.53
          SIGLA |     132,776        161,079          82.43
     in_regular |     147,335        161,079          91.47
   n_tur~c_em_1 |     147,335        161,079          91.47
   n_tur~c_em_2 |     147,335        161,079          91.47
   n_tur~c_em_3 |     147,335        161,079          91.47
   n_turmas_e.. |     147,335        161,079          91.47
   n_turmas_e.. |     147,335        161,079          91.47
   ~c_em_inte_1 |     147,335        161,079          91.47
   ~c_em_inte_2 |     147,335        161,079          91.47
   ~c_em_inte_3 |     147,335        161,079          91.47
   n_turmas_m~4 |     147,335        161,079          91.47
   n_turmas_m~s |     147,335        161,079          91.47
----------------+-----------------------------------------------


*/

* dropando variáveis com um número excessivo de missings, acima de 70%
drop n_copiadoras n_arsalas n_impressoras n_salas_perm n_salas_prov n_sala_util n_sala_util_fora n_profs_em n_profs_em_licenciatura n_profs_em_magisterio n_turmas_diu_em_1 n_turmas_diu_em_2 n_turmas_diu_em_3 n_turmas_diu_em_4 n_turmas_diu_em_ns n_alunos_diu_em_1 n_alunos_diu_em_2 n_alunos_diu_em_3 n_alunos_diu_em_4 n_alunos_diu_em_ns n_turmas_not_em_1 n_turmas_not_em_2 n_turmas_not_em_3 n_turmas_not_em_4 n_turmas_not_em_ns n_alunos_not_em_1 n_alunos_not_em_2 n_alunos_not_em_3 n_alunos_not_em_4 n_alunos_not_em_ns
drop n_salas_utilizadas - n_alunos_turma_not_3
drop n_mulheres_diu_em_1 - n_brancos_not_em_ns
drop ID_LOCALIZACAO m_idade_em_inte_1 - p_alu_transp_publico_em_inte_ns p_profs_sup_em_inte_1- p_profs_sup_em_inte_ns SIGLA 
drop n_profs_em_sup_sem_lic_e_mag
replace regular = in_regular if ano == 2015

mdesc codigo_escola - n_turmas_mais_educ_em_inte_ns
/*
   Variable    |     Missing          Total     Percent Missing
----------------+-----------------------------------------------
   codigo_esc~a |           0        161,079           0.00
            ano |           0        161,079           0.00
       ano_enem |       6,006        161,079           3.73
      cod_munic |       6,006        161,079           3.73
   codigo_mu~go |       6,006        161,079           3.73
       cod_meso |       6,006        161,079           3.73
   nome_munic~o |       6,006        161,079           3.73
      codigo_uf |       6,006        161,079           3.73
         estado |       6,006        161,079           3.73
            pib |       6,006        161,079           3.73
            pop |       6,006        161,079           3.73
   pib_capita~s |       6,006        161,079           3.73
   pib_cap~2003 |       6,006        161,079           3.73
   pib_cap~2015 |       6,006        161,079           3.73
   concluir_e~m |       6,006        161,079           3.73
   e_mora_mai~s |       8,365        161,079           5.19
   e_escol_su~i |       9,193        161,079           5.71
   e_escol_su~e |       8,686        161,079           5.39
   e_renda_fa~s |       8,386        161,079           5.21
   e_trabalho~u |       9,420        161,079           5.85
   enem_nota~va |     100,414        161,079          62.34
   enem_nota~ca |      69,724        161,079          43.29
   enem_nota~ns |      69,724        161,079          43.29
   enem_not~nas |      69,485        161,079          43.14
   enem_not~ias |      69,485        161,079          43.14
   enem_nota_~o |       6,378        161,079           3.96
         apr_ef |      82,467        161,079          51.20
         apr_em |      58,498        161,079          36.32
         rep_ef |      77,430        161,079          48.07
         rep_em |      58,498        161,079          36.32
         aba_ef |      77,430        161,079          48.07
         aba_em |      58,498        161,079          36.32
        dist_ef |      77,814        161,079          48.31
        dist_em |      60,525        161,079          37.57
       em_fluxo |      56,950        161,079          35.36
   enem_nota_~b |       9,096        161,079           5.65
   enem_~va_std |     100,414        161,079          62.34
   enem_n~b_std |       9,096        161,079           5.65
   enem_n~o_std |       6,378        161,079           3.96
   enem_~ca_std |      69,724        161,079          43.29
   enem~ias_std |      69,485        161,079          43.14
   enem~nas_std |      69,485        161,079          43.14
   enem_~ns_std |      69,724        161,079          43.29
     apr_em_std |      58,498        161,079          36.32
     rep_em_std |      58,498        161,079          36.32
     aba_em_std |      58,498        161,079          36.32
    dist_em_std |      60,525        161,079          37.57
   dependenci~a |           0        161,079           0.00
   n_profs_em~g |     122,129        161,079          75.82
   n_mulher~m_1 |       5,439        161,079           3.38
   n_mulher~m_2 |       5,439        161,079           3.38
   n_mulher~m_3 |       5,439        161,079           3.38
   n_mulher~m_4 |     152,527        161,079          94.69
   n_mulhe~m_ns |     152,527        161,079          94.69
          rural |           0        161,079           0.00
          ativa |           0        161,079           0.00
             em |      16,820        161,079          10.44
        em_prof |      46,472        161,079          28.85
         predio |         720        161,079           0.45
      diretoria |         469        161,079           0.29
   sala_profe~s |         470        161,079           0.29
     biblioteca |         470        161,079           0.29
   sala_leitura |      24,000        161,079          14.90
     refeitorio |      66,278        161,079          41.15
       lab_info |         472        161,079           0.29
   lab_ciencias |         472        161,079           0.29
   quadra_esp~s |         472        161,079           0.29
       internet |       4,446        161,079           2.76
    lixo_coleta |       2,994        161,079           1.86
   eletricidade |       2,994        161,079           1.86
           agua |       2,994        161,079           1.86
         esgoto |       2,995        161,079           1.86
   n_alunos~m_1 |       5,439        161,079           3.38
   n_alunos~m_2 |       5,439        161,079           3.38
   n_alunos~m_3 |       5,439        161,079           3.38
   p_mulheres~1 |      25,181        161,079          15.63
   p_mulheres~2 |      27,409        161,079          17.02
   p_mulheres~3 |      29,708        161,079          18.44
   n_branco~m_1 |      22,937        161,079          14.24
   n_branco~m_2 |      22,937        161,079          14.24
   n_branco~m_3 |      22,937        161,079          14.24
   p_brancos_~1 |      45,477        161,079          28.23
   p_brancos_~2 |      49,365        161,079          30.65
   p_brancos_~3 |      52,779        161,079          32.77
    nome_escola |      39,040        161,079          24.24
   codigo_mu~vo |      39,040        161,079          24.24
   n_salas_exis |      42,074        161,079          26.12
        regular |      42,116        161,079          26.15
   em_integrado |      55,860        161,079          34.68
      em_normal |      55,860        161,079          34.68
   n_tur~s_em_1 |      41,944        161,079          26.04
   n_tur~s_em_2 |      41,944        161,079          26.04
   n_tur~s_em_3 |      41,944        161,079          26.04
   n_turmas_e.. |      41,944        161,079          26.04
   n_turmas_e~4 |      41,944        161,079          26.04
   n_turmas_e~s |      41,944        161,079          26.04
   n_alu_tr~m_1 |      41,944        161,079          26.04
   n_alu_tr~m_2 |      41,944        161,079          26.04
   n_alu_tr~m_3 |      41,944        161,079          26.04
   m_idade_em_1 |      61,234        161,079          38.01
   m_idade_em_2 |      63,323        161,079          39.31
   m_idade_em_3 |      65,555        161,079          40.70
   p_alu_tran~1 |      61,234        161,079          38.01
   p_alu_tran~2 |      63,323        161,079          39.31
   p_alu_tran~3 |      65,555        161,079          40.70
   n_alunos~e_1 |      41,944        161,079          26.04
   n_alunos~e_2 |      41,944        161,079          26.04
   n_alunos~e_3 |      41,944        161,079          26.04
   n_alunos_e~4 |      41,944        161,079          26.04
   n_alunos_e~s |      41,944        161,079          26.04
   n_mulher~e_1 |      41,944        161,079          26.04
   n_mulher~e_2 |      41,944        161,079          26.04
   n_mulher~e_3 |      41,944        161,079          26.04
   n_mulher~e_4 |      41,944        161,079          26.04
   n_mulhe~e_ns |      41,944        161,079          26.04
   n_branco~e_1 |      41,944        161,079          26.04
   n_branco~e_2 |      41,944        161,079          26.04
   n_branco~e_3 |      41,944        161,079          26.04
   n_brancos_~4 |      41,944        161,079          26.04
   n_brancos_~s |      41,944        161,079          26.04
   n_alu_tr~e_1 |      41,944        161,079          26.04
   n_alu_tr~e_2 |      41,944        161,079          26.04
   n_alu_tr~e_3 |      41,944        161,079          26.04
   n_alu_tran~4 |      41,944        161,079          26.04
   n_alu_tran~s |      41,944        161,079          26.04
   n_profs_em_1 |      42,130        161,079          26.15
   n_profs_em_2 |      42,130        161,079          26.15
   n_profs_em_3 |      42,130        161,079          26.15
   n_pro~p_em_1 |      42,130        161,079          26.15
   n_pro~p_em_2 |      42,130        161,079          26.15
   n_pro~p_em_3 |      42,130        161,079          26.15
   p_profs_su~1 |      61,378        161,079          38.10
   p_profs_su~2 |      63,458        161,079          39.40
   p_profs_su~3 |      65,684        161,079          40.78
   n_profs_em.. |      42,130        161,079          26.15
   n_profs_em.. |      42,130        161,079          26.15
   n_profs_em.. |      42,130        161,079          26.15
   n_profs_em~4 |      42,130        161,079          26.15
   n_profs_em~s |      42,130        161,079          26.15
   ~p_em_inte_1 |      42,130        161,079          26.15
   ~p_em_inte_2 |      42,130        161,079          26.15
   ~p_em_inte_3 |      42,130        161,079          26.15
   n_profs_su~4 |      42,130        161,079          26.15
   n_profs_su~s |      42,130        161,079          26.15
    fund_8_anos |      92,810        161,079          57.62
    fund_9_anos |      92,810        161,079          57.62
   distrito_e~o |      91,059        161,079          56.53
     in_regular |     147,335        161,079          91.47
   n_tur~c_em_1 |     147,335        161,079          91.47
   n_tur~c_em_2 |     147,335        161,079          91.47
   n_tur~c_em_3 |     147,335        161,079          91.47
   n_turmas_e.. |     147,335        161,079          91.47
   n_turmas_e.. |     147,335        161,079          91.47
   ~c_em_inte_1 |     147,335        161,079          91.47
   ~c_em_inte_2 |     147,335        161,079          91.47
   ~c_em_inte_3 |     147,335        161,079          91.47
   n_turmas_m~4 |     147,335        161,079          91.47
   n_turmas_m~s |     147,335        161,079          91.47
----------------+-----------------------------------------------

*/
drop in_regular

* analisando os missings da variável n_mulheres_em
tab ano if n_mulheres_em_1 != .
tab ano if n_mulheres_em_1 ==.

/*
tab ano if n_mulheres_em_1 != .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      8,552        5.49        5.49
       2004 |      8,946        5.75       11.24
       2005 |      9,598        6.17       17.41
       2006 |      9,409        6.05       23.45
       2007 |     11,475        7.37       30.83
       2008 |     11,867        7.62       38.45
       2009 |     13,608        8.74       47.20
       2010 |     13,872        8.91       56.11
       2011 |     13,501        8.67       64.78
       2012 |     13,563        8.71       73.50
       2013 |     13,727        8.82       82.32
       2014 |     13,778        8.85       91.17
       2015 |     13,744        8.83      100.00
------------+-----------------------------------
      Total |    155,640      100.00

. tab ano if n_mulheres_em_1 ==.

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |        836       15.37       15.37
       2004 |        236        4.34       19.71
       2005 |        800       14.71       34.42
       2006 |        663       12.19       46.61
       2007 |         21        0.39       46.99
       2008 |        166        3.05       50.05
       2009 |        530        9.74       59.79
       2010 |        480        8.83       68.62
       2011 |        287        5.28       73.89
       2012 |        282        5.18       79.08
       2013 |        357        6.56       85.64
       2014 |        402        7.39       93.03
       2015 |        379        6.97      100.00
------------+-----------------------------------
      Total |      5,439      100.00


*/
tab ano if n_mulheres_em_4 != .
tab ano if n_mulheres_em_4 ==.
 /*
 tab ano if n_mulheres_em_4 != .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      8,552      100.00      100.00
------------+-----------------------------------
      Total |      8,552      100.00

. tab ano if n_mulheres_em_4 ==.

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |        836        0.55        0.55
       2004 |      9,182        6.02        6.57
       2005 |     10,398        6.82       13.39
       2006 |     10,072        6.60       19.99
       2007 |     11,496        7.54       27.53
       2008 |     12,033        7.89       35.41
       2009 |     14,138        9.27       44.68
       2010 |     14,352        9.41       54.09
       2011 |     13,788        9.04       63.13
       2012 |     13,845        9.08       72.21
       2013 |     14,084        9.23       81.44
       2014 |     14,180        9.30       90.74
       2015 |     14,123        9.26      100.00
------------+-----------------------------------
      Total |    152,527      100.00
*/
tab ano if n_mulheres_em_ns != .
tab ano if n_mulheres_em_ns ==.
/*
tab ano if n_mulheres_em_ns != .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      8,552      100.00      100.00
------------+-----------------------------------
      Total |      8,552      100.00

. tab ano if n_mulheres_em_ns ==.

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |        836        0.55        0.55
       2004 |      9,182        6.02        6.57
       2005 |     10,398        6.82       13.39
       2006 |     10,072        6.60       19.99
       2007 |     11,496        7.54       27.53
       2008 |     12,033        7.89       35.41
       2009 |     14,138        9.27       44.68
       2010 |     14,352        9.41       54.09
       2011 |     13,788        9.04       63.13
       2012 |     13,845        9.08       72.21
       2013 |     14,084        9.23       81.44
       2014 |     14,180        9.30       90.74
       2015 |     14,123        9.26      100.00
------------+-----------------------------------
      Total |    152,527      100.00

*/
drop n_mulheres_em_4 n_mulheres_em_ns





* analisando os missings da sala_leitura

tab ano if sala_leitura != .
tab ano if sala_leitura == .
/*
* sala de leitura não está presente nos anos de 2007 e 2008

. tab ano if sala_leitura != .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      9,360        6.83        6.83
       2004 |      9,161        6.68       13.51
       2005 |     10,371        7.57       21.08
       2006 |     10,056        7.34       28.41
       2009 |     14,138       10.31       38.73
       2010 |     14,352       10.47       49.20
       2011 |     13,788       10.06       59.25
       2012 |     13,845       10.10       69.35
       2013 |     14,084       10.27       79.63
       2014 |     14,180       10.34       89.97
       2015 |     13,744       10.03      100.00
------------+-----------------------------------
      Total |    137,079      100.00

. tab ano if sala_leitura == .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |         28        0.12        0.12
       2004 |         21        0.09        0.20
       2005 |         27        0.11        0.32
       2006 |         16        0.07        0.38
       2007 |     11,496       47.90       48.28
       2008 |     12,033       50.14       98.42
       2015 |        379        1.58      100.00
------------+-----------------------------------
      Total |     24,000      100.00

*/
tab ano if refeitorio != . 
tab ano if refeitorio == . 
/*
* refeitório não está presente nos anos de 2007 a 2011


. tab ano if refeitorio != . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      9,360        9.87        9.87
       2004 |      9,161        9.66       19.54
       2005 |     10,371       10.94       30.48
       2006 |     10,056       10.61       41.08
       2012 |     13,845       14.60       55.69
       2013 |     14,084       14.86       70.54
       2014 |     14,180       14.96       85.50
       2015 |     13,744       14.50      100.00
------------+-----------------------------------
      Total |     94,801      100.00

. tab ano if refeitorio == . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |         28        0.04        0.04
       2004 |         21        0.03        0.07
       2005 |         27        0.04        0.11
       2006 |         16        0.02        0.14
       2007 |     11,496       17.35       17.48
       2008 |     12,033       18.16       35.64
       2009 |     14,138       21.33       56.97
       2010 |     14,352       21.65       78.62
       2011 |     13,788       20.80       99.43
       2015 |        379        0.57      100.00
------------+-----------------------------------
      Total |     66,278      100.00

*/

tab ano if internet != .
tab ano if internet ==.
/*



. tab ano if internet != .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      9,023        5.76        5.76
       2004 |      8,950        5.71       11.47
       2005 |     10,371        6.62       18.10
       2006 |     10,056        6.42       24.52
       2007 |     11,218        7.16       31.68
       2008 |     11,867        7.58       39.25
       2009 |     13,608        8.69       47.94
       2010 |     13,872        8.86       56.80
       2011 |     13,379        8.54       65.34
       2012 |     13,309        8.50       73.84
       2013 |     13,589        8.68       82.51
       2014 |     13,647        8.71       91.23
       2015 |     13,744        8.77      100.00
------------+-----------------------------------
      Total |    156,633      100.00

. tab ano if internet ==.

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |        365        8.21        8.21
       2004 |        232        5.22       13.43
       2005 |         27        0.61       14.04
       2006 |         16        0.36       14.39
       2007 |        278        6.25       20.65
       2008 |        166        3.73       24.38
       2009 |        530       11.92       36.30
       2010 |        480       10.80       47.10
       2011 |        409        9.20       56.30
       2012 |        536       12.06       68.35
       2013 |        495       11.13       79.49
       2014 |        533       11.99       91.48
       2015 |        379        8.52      100.00
------------+-----------------------------------
      Total |      4,446      100.00

*/
tab ano if lixo_coleta != .
tab ano if lixo_coleta ==.

/*


. tab ano if lixo_coleta != .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      9,360        5.92        5.92
       2004 |      9,163        5.80       11.72
       2005 |     10,371        6.56       18.28
       2006 |     10,056        6.36       24.64
       2007 |     11,475        7.26       31.90
       2008 |     11,867        7.51       39.40
       2009 |     13,608        8.61       48.01
       2010 |     13,872        8.78       56.79
       2011 |     13,501        8.54       65.33
       2012 |     13,563        8.58       73.91
       2013 |     13,727        8.68       82.59
       2014 |     13,778        8.72       91.31
       2015 |     13,744        8.69      100.00
------------+-----------------------------------
      Total |    158,085      100.00

. tab ano if lixo_coleta ==.

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |         28        0.94        0.94
       2004 |         19        0.63        1.57
       2005 |         27        0.90        2.47
       2006 |         16        0.53        3.01
       2007 |         21        0.70        3.71
       2008 |        166        5.54        9.25
       2009 |        530       17.70       26.95
       2010 |        480       16.03       42.99
       2011 |        287        9.59       52.57
       2012 |        282        9.42       61.99
       2013 |        357       11.92       73.91
       2014 |        402       13.43       87.34
       2015 |        379       12.66      100.00
------------+-----------------------------------
      Total |      2,994      100.00

*/
tab ano if eletricidade != .
tab ano if eletricidade ==.




/*. tab ano if eletricidade != .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      9,360        5.92        5.92
       2004 |      9,163        5.80       11.72
       2005 |     10,371        6.56       18.28
       2006 |     10,056        6.36       24.64
       2007 |     11,475        7.26       31.90
       2008 |     11,867        7.51       39.40
       2009 |     13,608        8.61       48.01
       2010 |     13,872        8.78       56.79
       2011 |     13,501        8.54       65.33
       2012 |     13,563        8.58       73.91
       2013 |     13,727        8.68       82.59
       2014 |     13,778        8.72       91.31
       2015 |     13,744        8.69      100.00
------------+-----------------------------------
      Total |    158,085      100.00

. tab ano if eletricidade ==.

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |         28        0.94        0.94
       2004 |         19        0.63        1.57
       2005 |         27        0.90        2.47
       2006 |         16        0.53        3.01
       2007 |         21        0.70        3.71
       2008 |        166        5.54        9.25
       2009 |        530       17.70       26.95
       2010 |        480       16.03       42.99
       2011 |        287        9.59       52.57
       2012 |        282        9.42       61.99
       2013 |        357       11.92       73.91
       2014 |        402       13.43       87.34
       2015 |        379       12.66      100.00
------------+-----------------------------------
      Total |      2,994      100.00
*/
tab ano if agua != .
tab ano if agua ==.



/*
 tab ano if agua != .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      9,360        5.92        5.92
       2004 |      9,163        5.80       11.72
       2005 |     10,371        6.56       18.28
       2006 |     10,056        6.36       24.64
       2007 |     11,475        7.26       31.90
       2008 |     11,867        7.51       39.40
       2009 |     13,608        8.61       48.01
       2010 |     13,872        8.78       56.79
       2011 |     13,501        8.54       65.33
       2012 |     13,563        8.58       73.91
       2013 |     13,727        8.68       82.59
       2014 |     13,778        8.72       91.31
       2015 |     13,744        8.69      100.00
------------+-----------------------------------
      Total |    158,085      100.00

. tab ano if agua ==.

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |         28        0.94        0.94
       2004 |         19        0.63        1.57
       2005 |         27        0.90        2.47
       2006 |         16        0.53        3.01
       2007 |         21        0.70        3.71
       2008 |        166        5.54        9.25
       2009 |        530       17.70       26.95
       2010 |        480       16.03       42.99
       2011 |        287        9.59       52.57
       2012 |        282        9.42       61.99
       2013 |        357       11.92       73.91
       2014 |        402       13.43       87.34
       2015 |        379       12.66      100.00
------------+-----------------------------------
      Total |      2,994      100.00
*/
tab ano if esgoto != .
tab ano if esgoto ==.  



/*tab ano if esgoto != .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      9,360        5.92        5.92
       2004 |      9,162        5.80       11.72
       2005 |     10,371        6.56       18.28
       2006 |     10,056        6.36       24.64
       2007 |     11,475        7.26       31.90
       2008 |     11,867        7.51       39.40
       2009 |     13,608        8.61       48.01
       2010 |     13,872        8.78       56.79
       2011 |     13,501        8.54       65.33
       2012 |     13,563        8.58       73.91
       2013 |     13,727        8.68       82.59
       2014 |     13,778        8.72       91.31
       2015 |     13,744        8.69      100.00
------------+-----------------------------------
      Total |    158,084      100.00

. tab ano if esgoto ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |         28        0.93        0.93
       2004 |         20        0.67        1.60
       2005 |         27        0.90        2.50
       2006 |         16        0.53        3.04
       2007 |         21        0.70        3.74
       2008 |        166        5.54        9.28
       2009 |        530       17.70       26.98
       2010 |        480       16.03       43.01
       2011 |        287        9.58       52.59
       2012 |        282        9.42       62.00
       2013 |        357       11.92       73.92
       2014 |        402       13.42       87.35
       2015 |        379       12.65      100.00
------------+-----------------------------------
      Total |      2,995      100.00

*/

tab ano if n_alunos_em_1 != . 
tab ano if n_alunos_em_1 ==. 


/*

. tab ano if n_alunos_em_1 != . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      8,552        5.49        5.49
       2004 |      8,946        5.75       11.24
       2005 |      9,598        6.17       17.41
       2006 |      9,409        6.05       23.45
       2007 |     11,475        7.37       30.83
       2008 |     11,867        7.62       38.45
       2009 |     13,608        8.74       47.20
       2010 |     13,872        8.91       56.11
       2011 |     13,501        8.67       64.78
       2012 |     13,563        8.71       73.50
       2013 |     13,727        8.82       82.32
       2014 |     13,778        8.85       91.17
       2015 |     13,744        8.83      100.00
------------+-----------------------------------
      Total |    155,640      100.00

. tab ano if n_alunos_em_1 ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |        836       15.37       15.37
       2004 |        236        4.34       19.71
       2005 |        800       14.71       34.42
       2006 |        663       12.19       46.61
       2007 |         21        0.39       46.99
       2008 |        166        3.05       50.05
       2009 |        530        9.74       59.79
       2010 |        480        8.83       68.62
       2011 |        287        5.28       73.89
       2012 |        282        5.18       79.08
       2013 |        357        6.56       85.64
       2014 |        402        7.39       93.03
       2015 |        379        6.97      100.00
------------+-----------------------------------
      Total |      5,439      100.00

*/
tab ano if p_mulheres_em_1 != . 
tab ano if p_mulheres_em_1 ==. 

/*
. tab ano if p_mulheres_em_1 != . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      8,454        6.22        6.22
       2004 |      8,818        6.49       12.71
       2005 |      9,460        6.96       19.67
       2006 |      9,321        6.86       26.53
       2007 |     10,349        7.62       34.14
       2008 |     10,694        7.87       42.01
       2009 |     10,845        7.98       49.99
       2010 |     11,051        8.13       58.13
       2011 |     11,256        8.28       66.41
       2012 |     11,403        8.39       74.80
       2013 |     11,390        8.38       83.18
       2014 |     11,423        8.41       91.59
       2015 |     11,434        8.41      100.00
------------+-----------------------------------
      Total |    135,898      100.00

. tab ano if p_mulheres_em_1 ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |        934        3.71        3.71
       2004 |        364        1.45        5.15
       2005 |        938        3.73        8.88
       2006 |        751        2.98       11.86
       2007 |      1,147        4.56       16.42
       2008 |      1,339        5.32       21.73
       2009 |      3,293       13.08       34.81
       2010 |      3,301       13.11       47.92
       2011 |      2,532       10.06       57.98
       2012 |      2,442        9.70       67.67
       2013 |      2,694       10.70       78.37
       2014 |      2,757       10.95       89.32
       2015 |      2,689       10.68      100.00
------------+-----------------------------------
      Total |     25,181      100.00

*/
tab ano if n_brancos_em_1 != . 
tab ano if n_brancos_em_1 ==.  
* essa variável não está presente nos anos de 2003 e 2004



/*

. tab ano if n_brancos_em_1 != . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2005 |      9,598        6.95        6.95
       2006 |      9,409        6.81       13.76
       2007 |     11,475        8.31       22.07
       2008 |     11,867        8.59       30.66
       2009 |     13,608        9.85       40.51
       2010 |     13,872       10.04       50.55
       2011 |     13,501        9.77       60.32
       2012 |     13,563        9.82       70.14
       2013 |     13,727        9.94       80.08
       2014 |     13,778        9.97       90.05
       2015 |     13,744        9.95      100.00
------------+-----------------------------------
      Total |    138,142      100.00

. tab ano if n_brancos_em_1 ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      9,388       40.93       40.93
       2004 |      9,182       40.03       80.96
       2005 |        800        3.49       84.45
       2006 |        663        2.89       87.34
       2007 |         21        0.09       87.43
       2008 |        166        0.72       88.15
       2009 |        530        2.31       90.47
       2010 |        480        2.09       92.56
       2011 |        287        1.25       93.81
       2012 |        282        1.23       95.04
       2013 |        357        1.56       96.60
       2014 |        402        1.75       98.35
       2015 |        379        1.65      100.00
------------+-----------------------------------
      Total |     22,937      100.00

*/
tab ano if p_brancos_em_1 != . 
tab ano if p_brancos_em_1 ==.  

* esta variável não está presente nos anos de 2003 e 2004

/*

. tab ano if p_brancos_em_1 != . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2005 |      9,460        8.18        8.18
       2006 |      9,321        8.06       16.25
       2007 |      9,397        8.13       24.38
       2008 |     10,436        9.03       33.40
       2009 |     10,698        9.25       42.66
       2010 |     10,927        9.45       52.11
       2011 |     10,954        9.48       61.58
       2012 |     11,037        9.55       71.13
       2013 |     11,069        9.58       80.71
       2014 |     11,058        9.57       90.27
       2015 |     11,245        9.73      100.00
------------+-----------------------------------
      Total |    115,602      100.00

. tab ano if p_brancos_em_1 ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      9,388       20.64       20.64
       2004 |      9,182       20.19       40.83
       2005 |        938        2.06       42.90
       2006 |        751        1.65       44.55
       2007 |      2,099        4.62       49.16
       2008 |      1,597        3.51       52.67
       2009 |      3,440        7.56       60.24
       2010 |      3,425        7.53       67.77
       2011 |      2,834        6.23       74.00
       2012 |      2,808        6.17       80.18
       2013 |      3,015        6.63       86.81
       2014 |      3,122        6.87       93.67
       2015 |      2,878        6.33      100.00
------------+-----------------------------------
      Total |     45,477      100.00

*/
tab ano if n_salas_exis != . 
tab ano if n_salas_exis ==.  
* esta variável não está presente nos anos de 2003 a 2006



/*

. tab ano if n_salas_exis != . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     11,475        9.64        9.64
       2008 |     11,867        9.97       19.61
       2009 |     13,608       11.43       31.05
       2010 |     13,872       11.66       42.71
       2011 |     13,501       11.34       54.05
       2012 |     13,563       11.40       65.45
       2013 |     13,727       11.53       76.98
       2014 |     13,777       11.58       88.56
       2015 |     13,615       11.44      100.00
------------+-----------------------------------
      Total |    119,005      100.00

. 
. tab ano if n_salas_exis ==.

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      9,388       22.31       22.31
       2004 |      9,182       21.82       44.14
       2005 |     10,398       24.71       68.85
       2006 |     10,072       23.94       92.79
       2007 |         21        0.05       92.84
       2008 |        166        0.39       93.23
       2009 |        530        1.26       94.49
       2010 |        480        1.14       95.63
       2011 |        287        0.68       96.32
       2012 |        282        0.67       96.99
       2013 |        357        0.85       97.83
       2014 |        403        0.96       98.79
       2015 |        508        1.21      100.00
------------+-----------------------------------
      Total |     42,074      100.00

*/
tab ano if regular != . 
tab ano if regular ==.  
* esta variável não está presetne nos anos de 2003 a 2006


/*

. tab ano if regular != . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     11,475        9.65        9.65
       2008 |     11,867        9.98       19.62
       2009 |     13,608       11.44       31.06
       2010 |     13,872       11.66       42.72
       2011 |     13,436       11.29       54.02
       2012 |     13,563       11.40       65.42
       2013 |     13,620       11.45       76.87
       2014 |     13,778       11.58       88.45
       2015 |     13,744       11.55      100.00
------------+-----------------------------------
      Total |    118,963      100.00

. tab ano if regular ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      9,388       22.29       22.29
       2004 |      9,182       21.80       44.09
       2005 |     10,398       24.69       68.78
       2006 |     10,072       23.91       92.70
       2007 |         21        0.05       92.75
       2008 |        166        0.39       93.14
       2009 |        530        1.26       94.40
       2010 |        480        1.14       95.54
       2011 |        352        0.84       96.37
       2012 |        282        0.67       97.04
       2013 |        464        1.10       98.15
       2014 |        402        0.95       99.10
       2015 |        379        0.90      100.00
------------+-----------------------------------
      Total |     42,116      100.00

*/
tab ano if em_integrado != . 
tab ano if em_integrado ==.  
* esta variável não está presente nos anos de 2003 a 2006


/*


. tab ano if em_integrado != . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     11,475       10.91       10.91
       2008 |     11,867       11.28       22.18
       2009 |     13,608       12.93       35.12
       2010 |     13,872       13.18       48.30
       2011 |     13,436       12.77       61.07
       2012 |     13,563       12.89       73.96
       2013 |     13,620       12.94       86.91
       2014 |     13,778       13.09      100.00
------------+-----------------------------------
      Total |    105,219      100.00

. tab ano if em_integrado ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      9,388       16.81       16.81
       2004 |      9,182       16.44       33.24
       2005 |     10,398       18.61       51.86
       2006 |     10,072       18.03       69.89
       2007 |         21        0.04       69.93
       2008 |        166        0.30       70.22
       2009 |        530        0.95       71.17
       2010 |        480        0.86       72.03
       2011 |        352        0.63       72.66
       2012 |        282        0.50       73.17
       2013 |        464        0.83       74.00
       2014 |        402        0.72       74.72
       2015 |     14,123       25.28      100.00
------------+-----------------------------------
      Total |     55,860      100.00
*/
tab ano if em_normal != . 
tab ano if em_normal ==.  

* variável não está presente nos anos de 2003 a 2006


/*
. tab ano if em_normal != . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     11,475       10.91       10.91
       2008 |     11,867       11.28       22.18
       2009 |     13,608       12.93       35.12
       2010 |     13,872       13.18       48.30
       2011 |     13,436       12.77       61.07
       2012 |     13,563       12.89       73.96
       2013 |     13,620       12.94       86.91
       2014 |     13,778       13.09      100.00
------------+-----------------------------------
      Total |    105,219      100.00

. tab ano if em_normal ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      9,388       16.81       16.81
       2004 |      9,182       16.44       33.24
       2005 |     10,398       18.61       51.86
       2006 |     10,072       18.03       69.89
       2007 |         21        0.04       69.93
       2008 |        166        0.30       70.22
       2009 |        530        0.95       71.17
       2010 |        480        0.86       72.03
       2011 |        352        0.63       72.66
       2012 |        282        0.50       73.17
       2013 |        464        0.83       74.00
       2014 |        402        0.72       74.72
       2015 |     14,123       25.28      100.00
------------+-----------------------------------
      Total |     55,860      100.00

*/
tab ano if n_turmas_em_1 != . 
tab ano if n_turmas_em_1 ==.  


/*
esta variável não esta presente nos anos de 2003 a 2006


. tab ano if n_turmas_em_1 != . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     11,475        9.63        9.63
       2008 |     11,867        9.96       19.59
       2009 |     13,608       11.42       31.02
       2010 |     13,872       11.64       42.66
       2011 |     13,501       11.33       53.99
       2012 |     13,563       11.38       65.38
       2013 |     13,727       11.52       76.90
       2014 |     13,778       11.57       88.46
       2015 |     13,744       11.54      100.00
------------+-----------------------------------
      Total |    119,135      100.00

. tab ano if n_turmas_em_1 ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      9,388       22.38       22.38
       2004 |      9,182       21.89       44.27
       2005 |     10,398       24.79       69.06
       2006 |     10,072       24.01       93.08
       2007 |         21        0.05       93.13
       2008 |        166        0.40       93.52
       2009 |        530        1.26       94.79
       2010 |        480        1.14       95.93
       2011 |        287        0.68       96.61
       2012 |        282        0.67       97.29
       2013 |        357        0.85       98.14
       2014 |        402        0.96       99.10
       2015 |        379        0.90      100.00
------------+-----------------------------------
      Total |     41,944      100.00


*/
tab ano if n_alu_transporte_publico_em_1 != . 
tab ano if n_alu_transporte_publico_em_1 ==.  
/*




esta variável não está presente nos anos de 2003 a 2006
. tab ano if n_alu_transporte_publico_em_1 != . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     11,475        9.63        9.63
       2008 |     11,867        9.96       19.59
       2009 |     13,608       11.42       31.02
       2010 |     13,872       11.64       42.66
       2011 |     13,501       11.33       53.99
       2012 |     13,563       11.38       65.38
       2013 |     13,727       11.52       76.90
       2014 |     13,778       11.57       88.46
       2015 |     13,744       11.54      100.00
------------+-----------------------------------
      Total |    119,135      100.00

. tab ano if n_alu_transporte_publico_em_1 ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      9,388       22.38       22.38
       2004 |      9,182       21.89       44.27
       2005 |     10,398       24.79       69.06
       2006 |     10,072       24.01       93.08
       2007 |         21        0.05       93.13
       2008 |        166        0.40       93.52
       2009 |        530        1.26       94.79
       2010 |        480        1.14       95.93
       2011 |        287        0.68       96.61
       2012 |        282        0.67       97.29
       2013 |        357        0.85       98.14
       2014 |        402        0.96       99.10
       2015 |        379        0.90      100.00
------------+-----------------------------------
      Total |     41,944      100.00


*/
tab ano if m_idade_em_1 != . 
tab ano if m_idade_em_1 ==.  


/*
esta variável não está presente dos nos de 2003 a 2006
        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     10,349       10.37       10.37
       2008 |     10,694       10.71       21.08
       2009 |     10,845       10.86       31.94
       2010 |     11,051       11.07       43.01
       2011 |     11,256       11.27       54.28
       2012 |     11,403       11.42       65.70
       2013 |     11,390       11.41       77.11
       2014 |     11,423       11.44       88.55
       2015 |     11,434       11.45      100.00
------------+-----------------------------------
      Total |     99,845      100.00

. tab ano if m_idade_em_1 ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      9,388       15.33       15.33
       2004 |      9,182       14.99       30.33
       2005 |     10,398       16.98       47.31
       2006 |     10,072       16.45       63.76
       2007 |      1,147        1.87       65.63
       2008 |      1,339        2.19       67.82
       2009 |      3,293        5.38       73.19
       2010 |      3,301        5.39       78.58
       2011 |      2,532        4.13       82.72
       2012 |      2,442        3.99       86.71
       2013 |      2,694        4.40       91.11
       2014 |      2,757        4.50       95.61
       2015 |      2,689        4.39      100.00
------------+-----------------------------------
      Total |     61,234      100.00

*/


tab ano if p_alu_transporte_publico_em_1 != . 
tab ano if p_alu_transporte_publico_em_1 ==.  

/*
esta variável não está presente nos anos de 2003 a 2006
. tab ano if p_alu_transporte_publico_em_1 != . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     10,349       10.37       10.37
       2008 |     10,694       10.71       21.08
       2009 |     10,845       10.86       31.94
       2010 |     11,051       11.07       43.01
       2011 |     11,256       11.27       54.28
       2012 |     11,403       11.42       65.70
       2013 |     11,390       11.41       77.11
       2014 |     11,423       11.44       88.55
       2015 |     11,434       11.45      100.00
------------+-----------------------------------
      Total |     99,845      100.00

. tab ano if p_alu_transporte_publico_em_1 ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      9,388       15.33       15.33
       2004 |      9,182       14.99       30.33
       2005 |     10,398       16.98       47.31
       2006 |     10,072       16.45       63.76
       2007 |      1,147        1.87       65.63
       2008 |      1,339        2.19       67.82
       2009 |      3,293        5.38       73.19
       2010 |      3,301        5.39       78.58
       2011 |      2,532        4.13       82.72
       2012 |      2,442        3.99       86.71
       2013 |      2,694        4.40       91.11
       2014 |      2,757        4.50       95.61
       2015 |      2,689        4.39      100.00
------------+-----------------------------------
      Total |     61,234      100.00

*/
tab ano if n_alunos_em_inte_1 != . 
tab ano if n_alunos_em_inte_1 ==.  
/*


estas variáveis não estavam presentes nos anos de 2003 a 2006


. tab ano if n_alunos_em_inte_1 != . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     11,475        9.63        9.63
       2008 |     11,867        9.96       19.59
       2009 |     13,608       11.42       31.02
       2010 |     13,872       11.64       42.66
       2011 |     13,501       11.33       53.99
       2012 |     13,563       11.38       65.38
       2013 |     13,727       11.52       76.90
       2014 |     13,778       11.57       88.46
       2015 |     13,744       11.54      100.00
------------+-----------------------------------
      Total |    119,135      100.00

. tab ano if n_alunos_em_inte_1 ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      9,388       22.38       22.38
       2004 |      9,182       21.89       44.27
       2005 |     10,398       24.79       69.06
       2006 |     10,072       24.01       93.08
       2007 |         21        0.05       93.13
       2008 |        166        0.40       93.52
       2009 |        530        1.26       94.79
       2010 |        480        1.14       95.93
       2011 |        287        0.68       96.61
       2012 |        282        0.67       97.29
       2013 |        357        0.85       98.14
       2014 |        402        0.96       99.10
       2015 |        379        0.90      100.00
------------+-----------------------------------
      Total |     41,944      100.00

*/
tab ano if n_mulheres_em_inte_1 != . 
tab ano if n_mulheres_em_inte_1 ==.  



/*
estas variáves não estavam presentes nos anos de 2003 a 2006
 tab ano if n_mulheres_em_inte_1 != . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     11,475        9.63        9.63
       2008 |     11,867        9.96       19.59
       2009 |     13,608       11.42       31.02
       2010 |     13,872       11.64       42.66
       2011 |     13,501       11.33       53.99
       2012 |     13,563       11.38       65.38
       2013 |     13,727       11.52       76.90
       2014 |     13,778       11.57       88.46
       2015 |     13,744       11.54      100.00
------------+-----------------------------------
      Total |    119,135      100.00

. tab ano if n_mulheres_em_inte_1 ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      9,388       22.38       22.38
       2004 |      9,182       21.89       44.27
       2005 |     10,398       24.79       69.06
       2006 |     10,072       24.01       93.08
       2007 |         21        0.05       93.13
       2008 |        166        0.40       93.52
       2009 |        530        1.26       94.79
       2010 |        480        1.14       95.93
       2011 |        287        0.68       96.61
       2012 |        282        0.67       97.29
       2013 |        357        0.85       98.14
       2014 |        402        0.96       99.10
       2015 |        379        0.90      100.00
------------+-----------------------------------
      Total |     41,944      100.00


*/
tab ano if n_brancos_em_inte_1 != . 
tab ano if n_brancos_em_inte_1 ==.  


/*
estas variáveis não estavam presentes nos anos de 2003 a 2006
. tab ano if n_brancos_em_inte_1 != . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     11,475        9.63        9.63
       2008 |     11,867        9.96       19.59
       2009 |     13,608       11.42       31.02
       2010 |     13,872       11.64       42.66
       2011 |     13,501       11.33       53.99
       2012 |     13,563       11.38       65.38
       2013 |     13,727       11.52       76.90
       2014 |     13,778       11.57       88.46
       2015 |     13,744       11.54      100.00
------------+-----------------------------------
      Total |    119,135      100.00

. tab ano if n_brancos_em_inte_1 ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      9,388       22.38       22.38
       2004 |      9,182       21.89       44.27
       2005 |     10,398       24.79       69.06
       2006 |     10,072       24.01       93.08
       2007 |         21        0.05       93.13
       2008 |        166        0.40       93.52
       2009 |        530        1.26       94.79
       2010 |        480        1.14       95.93
       2011 |        287        0.68       96.61
       2012 |        282        0.67       97.29
       2013 |        357        0.85       98.14
       2014 |        402        0.96       99.10
       2015 |        379        0.90      100.00
------------+-----------------------------------
      Total |     41,944      100.00


*/
tab ano if n_profs_em_1 != . 
tab ano if n_profs_em_1 ==.  

/*
estas variáveis não estavam presentes nos anos de 2003 a 2006

. tab ano if n_profs_em_1 != . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     11,397        9.58        9.58
       2008 |     11,828        9.94       19.53
       2009 |     13,573       11.41       30.94
       2010 |     13,838       11.63       42.57
       2011 |     13,501       11.35       53.92
       2012 |     13,563       11.40       65.32
       2013 |     13,727       11.54       76.86
       2014 |     13,778       11.58       88.45
       2015 |     13,744       11.55      100.00
------------+-----------------------------------
      Total |    118,949      100.00

. tab ano if n_profs_em_1 ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      9,388       22.28       22.28
       2004 |      9,182       21.79       44.08
       2005 |     10,398       24.68       68.76
       2006 |     10,072       23.91       92.67
       2007 |         99        0.23       92.90
       2008 |        205        0.49       93.39
       2009 |        565        1.34       94.73
       2010 |        514        1.22       95.95
       2011 |        287        0.68       96.63
       2012 |        282        0.67       97.30
       2013 |        357        0.85       98.15
       2014 |        402        0.95       99.10
       2015 |        379        0.90      100.00
------------+-----------------------------------
      Total |     42,130      100.00
*/

tab ano if n_profs_sup_em_1 != . 
tab ano if n_profs_sup_em_1 ==.  
/*
estas variáveis não estavam presentes nos anos de 2003 a 2006




. tab ano if n_profs_sup_em_1 != . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     11,397        9.58        9.58
       2008 |     11,828        9.94       19.53
       2009 |     13,573       11.41       30.94
       2010 |     13,838       11.63       42.57
       2011 |     13,501       11.35       53.92
       2012 |     13,563       11.40       65.32
       2013 |     13,727       11.54       76.86
       2014 |     13,778       11.58       88.45
       2015 |     13,744       11.55      100.00
------------+-----------------------------------
      Total |    118,949      100.00

. tab ano if n_profs_sup_em_1 ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      9,388       22.28       22.28
       2004 |      9,182       21.79       44.08
       2005 |     10,398       24.68       68.76
       2006 |     10,072       23.91       92.67
       2007 |         99        0.23       92.90
       2008 |        205        0.49       93.39
       2009 |        565        1.34       94.73
       2010 |        514        1.22       95.95
       2011 |        287        0.68       96.63
       2012 |        282        0.67       97.30
       2013 |        357        0.85       98.15
       2014 |        402        0.95       99.10
       2015 |        379        0.90      100.00
------------+-----------------------------------
      Total |     42,130      100.00

. 

*/

tab ano if p_profs_sup_em_1 != . 
tab ano if p_profs_sup_em_1 ==.  



* estas variáveis não estavam presentes nos anos de 2003 a 2006
/*
        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     10,290       10.32       10.32
       2008 |     10,669       10.70       21.02
       2009 |     10,823       10.86       31.88
       2010 |     11,028       11.06       42.94
       2011 |     11,256       11.29       54.23
       2012 |     11,403       11.44       65.67
       2013 |     11,390       11.42       77.09
       2014 |     11,416       11.45       88.54
       2015 |     11,426       11.46      100.00
------------+-----------------------------------
      Total |     99,701      100.00

. tab ano if p_profs_sup_em_1 ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      9,388       15.30       15.30
       2004 |      9,182       14.96       30.26
       2005 |     10,398       16.94       47.20
       2006 |     10,072       16.41       63.61
       2007 |      1,206        1.96       65.57
       2008 |      1,364        2.22       67.79
       2009 |      3,315        5.40       73.19
       2010 |      3,324        5.42       78.61
       2011 |      2,532        4.13       82.73
       2012 |      2,442        3.98       86.71
       2013 |      2,694        4.39       91.10
       2014 |      2,764        4.50       95.61
       2015 |      2,697        4.39      100.00
------------+-----------------------------------
      Total |     61,378      100.00

*/

tab ano if n_profs_em_inte_1 != . 
tab ano if n_profs_em_inte_1 ==. 



/*
* estas variáveis não estavam presetnes nos anos de 2003 a 2006
. tab ano if n_profs_em_inte_1 != . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     11,397        9.58        9.58
       2008 |     11,828        9.94       19.53
       2009 |     13,573       11.41       30.94
       2010 |     13,838       11.63       42.57
       2011 |     13,501       11.35       53.92
       2012 |     13,563       11.40       65.32
       2013 |     13,727       11.54       76.86
       2014 |     13,778       11.58       88.45
       2015 |     13,744       11.55      100.00
------------+-----------------------------------
      Total |    118,949      100.00

. tab ano if n_profs_em_inte_1 ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      9,388       22.28       22.28
       2004 |      9,182       21.79       44.08
       2005 |     10,398       24.68       68.76
       2006 |     10,072       23.91       92.67
       2007 |         99        0.23       92.90
       2008 |        205        0.49       93.39
       2009 |        565        1.34       94.73
       2010 |        514        1.22       95.95
       2011 |        287        0.68       96.63
       2012 |        282        0.67       97.30
       2013 |        357        0.85       98.15
       2014 |        402        0.95       99.10
       2015 |        379        0.90      100.00
------------+-----------------------------------
      Total |     42,130      100.00


*/
tab ano if n_profs_sup_em_inte_1 != . 
tab ano if n_profs_sup_em_inte_1 ==.  
            

/*
estas variáveis não estavam presentes nos anos de 2003 a 2006
. tab ano if n_profs_sup_em_inte_1 != . 

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2007 |     11,397        9.58        9.58
       2008 |     11,828        9.94       19.53
       2009 |     13,573       11.41       30.94
       2010 |     13,838       11.63       42.57
       2011 |     13,501       11.35       53.92
       2012 |     13,563       11.40       65.32
       2013 |     13,727       11.54       76.86
       2014 |     13,778       11.58       88.45
       2015 |     13,744       11.55      100.00
------------+-----------------------------------
      Total |    118,949      100.00

. tab ano if n_profs_sup_em_inte_1 ==.  

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      9,388       22.28       22.28
       2004 |      9,182       21.79       44.08
       2005 |     10,398       24.68       68.76
       2006 |     10,072       23.91       92.67
       2007 |         99        0.23       92.90
       2008 |        205        0.49       93.39
       2009 |        565        1.34       94.73
       2010 |        514        1.22       95.95
       2011 |        287        0.68       96.63
       2012 |        282        0.67       97.30
       2013 |        357        0.85       98.15
       2014 |        402        0.95       99.10
       2015 |        379        0.90      100.00
------------+-----------------------------------
      Total |     42,130      100.00

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

tab integral ice_jornada
tab ice_segmento
*ensino_medio indica se escola tem segmento ensino integral
gen ensino_medio=1 
replace ensino_medio = 0 if ice_segmento == "EFII" | ice_segmento == "EF FINAIS " 
tab ice_segmento ensino_medio

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


*dropando escolas somente com informações de alavanca, 
* mas sem informação de data de entrada no programa
drop if ano_ice ==.
*(9obs deleted)
*dropando escolas que entraram somente em 2016
drop if ano_ice ==2016
*(9 observations deleted)
replace ice=1
drop _merge
save "$folderservidor\base_final_ice_2_14.dta", replace

use "$folderservidor\enem_censo_escolar_14_v1.dta", clear
merge m:1 codigo_escola using "$folderservidor\base_final_ice_2_14.dta"
/*

    Result                           # of obs.
    -----------------------------------------
    not matched                       153,957
        from master                   153,905  (_merge==1)
        from using                         52  (_merge==2)

    matched                             7,174  (_merge==3)
    -----------------------------------------

*/
*dropando observações que só estavam na base ICE
drop if _merge == 2
*(52 observations deleted)
drop _merge

sort  codigo_escola ano
format codigo_escola %10.0g
format codigo_municipio_longo %20.0g
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
replace ice = 0 if d_segmento1==1 | d_segmento3==1
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
(5,439 real changes made)
(5,439 real changes made)
(22,937 real changes made)
(5,439 real changes made)
(5,439 real changes made)
(22,937 real changes made)
(5,439 real changes made)
(5,439 real changes made)
(22,937 real changes made)

*/
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
* (2,904 real changes made)
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
*(161,079 missing values generated)
replace n_brancos_em = n_brancos_em_1+n_brancos_em_2 + n_brancos_em_3 if ano>2006
*(122,039 real changes made)


*replace n_brancos_em=0 if n_brancos_em==.

mdesc n_alunos_em n_mulheres_em n_brancos_em
/*


    Variable    |     Missing          Total     Percent Missing
----------------+-----------------------------------------------
    n_alunos_em |           0        161,079           0.00
   n_mulheres~m |           0        161,079           0.00
   n_brancos_em |      39,040        161,079          24.24
----------------+-----------------------------------------------



*/
* agregando os números de alunos, mulheres e brancos por série
* em uma variável unica para a modalidade de ensino médio integrado
gen n_alunos_ep= .
*(161,079 missing values generated)
replace n_alunos_ep = n_alunos_em_inte_1+ n_alunos_em_inte_2+ n_alunos_em_inte_3 +n_alunos_em_inte_4 +n_alunos_em_inte_ns if ano >2006
*(122,039 real changes made)

*replace n_alunos_ep=0 if n_alunos_ep==.
gen n_mulheres_ep = .
*(161,079 missing values generated)
replace n_mulheres_ep=n_mulheres_em_inte_1+ n_mulheres_em_inte_2+ n_mulheres_em_inte_3 +n_mulheres_em_inte_4 +n_mulheres_em_inte_ns if ano>2006
*(122,039 real changes made)

*replace n_mulheres_ep=0 if n_mulheres_ep==.

gen n_brancos_ep=.
*(161,079 missing values generated)
replace n_brancos_ep = n_brancos_em_inte_1+ n_brancos_em_inte_2+ n_brancos_em_inte_3 +n_brancos_em_inte_4 +n_brancos_em_inte_ns if ano>2006
*(122,039 real changes made)
*replace n_brancos_ep=0 if n_brancos_ep==.

mdesc n_alunos_ep n_mulheres_ep n_brancos_ep
/*

    Variable    |     Missing          Total     Percent Missing
----------------+-----------------------------------------------
    n_alunos_ep |      39,040        161,079          24.24
   n_mulheres~p |      39,040        161,079          24.24
   n_brancos_ep |      39,040        161,079          24.24
----------------+-----------------------------------------------

*/

* gerando uma variável única para número de alunos de ensino medio
* sejam eles do ensino médio comum ou do profissionalizante
* para os anos anteriores de 2007, como só temos variáveis de ensino médio normal
* e somente variáveis de mulheres e alunos, vamos consider essas variáveis já abarcam
* o número total de alunos de em normal e profissionalizante
gen n_alunos_em_ep =.
* (161,079 missing values generated)
replace n_alunos_em_ep = n_alunos_em if ano <2007
* (39,040 real changes made)
replace n_alunos_em_ep = n_alunos_em  + n_alunos_ep if ano>2006
* (122,039 real changes made)



gen n_mulheres_em_ep = .
*(161,079 missing values generated)
replace n_mulheres_em_ep = n_mulheres_em if ano<2007
* (39,040 real changes made)
replace n_mulheres_em_ep = n_mulheres_em + n_mulheres_ep if ano>2006
*  (122,039 real changes made)

gen n_brancos_em_ep = n_brancos_em + n_brancos_ep
*(39,040 missing values generated)
*analisando os missings
mdesc n_alunos_em_ep n_mulheres_em_ep n_brancos_em_ep
/*

    Variable    |     Missing          Total     Percent Missing
----------------+-----------------------------------------------
   n_aluno~m_ep |           0        161,079           0.00
   n_mulhe~m_ep |           0        161,079           0.00
   n_branc~m_ep |      39,040        161,079          24.24
----------------+-----------------------------------------------



*/


*analisando os missings e os zeros por ano
tab ano if n_alunos_em_ep ==.
tab ano if n_alunos_em_ep !=.
/*

. tab ano if n_alunos_em_ep ==.


no observations


. tab ano if n_alunos_em_ep !=.

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      9,388        5.83        5.83
       2004 |      9,182        5.70       11.53
       2005 |     10,398        6.46       17.98
       2006 |     10,072        6.25       24.24
       2007 |     11,496        7.14       31.37
       2008 |     12,033        7.47       38.84
       2009 |     14,138        8.78       47.62
       2010 |     14,352        8.91       56.53
       2011 |     13,788        8.56       65.09
       2012 |     13,845        8.60       73.69
       2013 |     14,084        8.74       82.43
       2014 |     14,180        8.80       91.23
       2015 |     14,123        8.77      100.00
------------+-----------------------------------
      Total |    161,079      100.00





	  */
tab ano if n_alunos_em_ep ==0
tab ano if n_alunos_em_ep !=0
/*

. tab ano if n_alunos_em_ep ==0


        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |        847        3.95        3.95
       2004 |        243        1.13        5.08
       2005 |        847        3.95        9.03
       2006 |        674        3.14       12.18
       2007 |        975        4.55       16.72
       2008 |      1,103        5.14       21.87
       2009 |      2,992       13.95       35.82
       2010 |      2,974       13.87       49.69
       2011 |      2,155       10.05       59.74
       2012 |      2,034        9.49       69.22
       2013 |      2,232       10.41       79.63
       2014 |      2,243       10.46       90.09
       2015 |      2,125        9.91      100.00
------------+-----------------------------------
      Total |     21,444      100.00

. tab ano if n_alunos_em_ep !=0

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      8,541        6.12        6.12
       2004 |      8,939        6.40       12.52
       2005 |      9,551        6.84       19.36
       2006 |      9,398        6.73       26.09
       2007 |     10,521        7.53       33.62
       2008 |     10,930        7.83       41.45
       2009 |     11,146        7.98       49.43
       2010 |     11,378        8.15       57.58
       2011 |     11,633        8.33       65.91
       2012 |     11,811        8.46       74.37
       2013 |     11,852        8.49       82.86
       2014 |     11,937        8.55       91.41
       2015 |     11,998        8.59      100.00
------------+-----------------------------------
      Total |    139,635      100.00


*/
tab ano if n_mulheres_em_ep ==.
tab ano if n_mulheres_em_ep !=.

/*
 tab ano if n_mulheres_em_ep ==.

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |        836       32.98       32.98
       2004 |        236        9.31       42.29
       2005 |        800       31.56       73.85
       2006 |        663       26.15      100.00
------------+-----------------------------------
      Total |      2,535      100.00

. tab ano if n_mulheres_em_ep !=.

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      8,552        5.39        5.39
       2004 |      8,946        5.64       11.04
       2005 |      9,598        6.05       17.09
       2006 |      9,409        5.93       23.03
       2007 |     11,496        7.25       30.28
       2008 |     12,033        7.59       37.87
       2009 |     14,138        8.92       46.78
       2010 |     14,352        9.05       55.84
       2011 |     13,788        8.70       64.53
       2012 |     13,845        8.73       73.26
       2013 |     14,084        8.88       82.15
       2014 |     14,180        8.94       91.09
       2015 |     14,123        8.91      100.00
------------+-----------------------------------
      Total |    158,544      100.00


*/
tab ano if n_mulheres_em_ep ==0
tab ano if n_mulheres_em_ep !=0
/*
 
. 
. tab ano if n_mulheres_em_ep ==0

 no observations
. tab ano if n_mulheres_em_ep !=0


------------+-----------------------------------
       2003 |      9,388        5.83        5.83
       2004 |      9,182        5.70       11.53
       2005 |     10,398        6.46       17.98
       2006 |     10,072        6.25       24.24
       2007 |     11,496        7.14       31.37
       2008 |     12,033        7.47       38.84
       2009 |     14,138        8.78       47.62
       2010 |     14,352        8.91       56.53
       2011 |     13,788        8.56       65.09
       2012 |     13,845        8.60       73.69
       2013 |     14,084        8.74       82.43
       2014 |     14,180        8.80       91.23
       2015 |     14,123        8.77      100.00
------------+-----------------------------------
      Total |    161,079      100.00



*/
* se o número total de alunos no ensino médio, seja ele normal ou profissionalizante
* for igual a zero, há algo de errado. vamos atribuir missings
replace n_alunos_em_ep =.  if n_alunos_em_ep ==0
replace n_mulheres_em_ep =.  if n_mulheres_em_ep ==0
mdesc n_alunos_em_ep n_mulheres_em_ep
/*
    Variable    |     Missing          Total     Percent Missing
----------------+-----------------------------------------------
   n_aluno~m_ep |      21,444        161,079          13.31
   n_mulhe~m_ep |      21,866        161,079          13.57
----------------+-----------------------------------------------

. 

*/
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
eplace taxa_participacao_enem_aux = 0 if concluir_em_ano_enem ==0 & n_alunos_em_3 == 0 & n_alunos_em_inte_3 == 0 & ano> 2006
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
/*

. tab ano if taxa_participacao_enem != .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      8,346        6.33        6.33
       2004 |      8,898        6.75       13.08
       2005 |      9,348        7.09       20.18
       2006 |      9,255        7.02       27.20
       2007 |      9,677        7.34       34.54
       2008 |     10,154        7.70       42.24
       2009 |     10,312        7.82       50.07
       2010 |     10,502        7.97       58.04
       2011 |     10,763        8.17       66.20
       2012 |     10,929        8.29       74.49
       2013 |     11,117        8.43       82.93
       2014 |     11,219        8.51       91.44
       2015 |     11,281        8.56      100.00
------------+-----------------------------------
      Total |    131,801      100.00

. tab ano if taxa_participacao_enem == .

        ano |      Freq.     Percent        Cum.
------------+-----------------------------------
       2003 |      1,042        3.56        3.56
       2004 |        284        0.97        4.53
       2005 |      1,050        3.59        8.12
       2006 |        817        2.79       10.91
       2007 |      1,819        6.21       17.12
       2008 |      1,879        6.42       23.54
       2009 |      3,826       13.07       36.60
       2010 |      3,850       13.15       49.75
       2011 |      3,025       10.33       60.09
       2012 |      2,916        9.96       70.05
       2013 |      2,967       10.13       80.18
       2014 |      2,961       10.11       90.29
       2015 |      2,842        9.71      100.00
------------+-----------------------------------
      Total |     29,278      100.00


*/

drop n_turmas_mais_educ_em_1 n_turmas_mais_educ_em_2 n_turmas_mais_educ_em_3 n_turmas_mais_educ_em_inte_1 n_turmas_mais_educ_em_inte_2 n_turmas_mais_educ_em_inte_3 n_turmas_mais_educ_em_inte_4 n_turmas_mais_educ_em_inte_ns 
* lidando com informações do ice que não estão presentes no resto da base
drop ice_jornada ice_segmento ano_ice ice_rigor


foreach variable of varlist  ice_2004 - ice_2015 d_rigor1 - d_segmento5{
replace `variable' = 0 if `variable' == .

}

mdesc  codigo_escola - taxa_participacao_enem
/*
    Variable    |     Missing          Total     Percent Missing
----------------+-----------------------------------------------
   codigo_esc~a |           0        161,079           0.00
            ano |           0        161,079           0.00
       ano_enem |       6,006        161,079           3.73
      cod_munic |       6,006        161,079           3.73
   codigo_mu~go |       6,006        161,079           3.73
       cod_meso |       6,006        161,079           3.73
   nome_munic~o |       6,006        161,079           3.73
      codigo_uf |       6,006        161,079           3.73
         estado |       6,006        161,079           3.73
            pib |       6,006        161,079           3.73
            pop |       6,006        161,079           3.73
   pib_capita~s |       6,006        161,079           3.73
   pib_cap~2003 |       6,006        161,079           3.73
   pib_cap~2015 |       6,006        161,079           3.73
   concluir_e~m |           0        161,079           0.00
   e_mora_mai~s |       8,365        161,079           5.19
   e_escol_su~i |       9,193        161,079           5.71
   e_escol_su~e |       8,686        161,079           5.39
   e_renda_fa~s |       8,386        161,079           5.21
   e_trabalho~u |       9,420        161,079           5.85
   enem_nota~va |     100,414        161,079          62.34
   enem_nota~ca |      69,724        161,079          43.29
   enem_nota~ns |      69,724        161,079          43.29
   enem_not~nas |      69,485        161,079          43.14
   enem_not~ias |      69,485        161,079          43.14
   enem_nota_~o |       6,378        161,079           3.96
         apr_ef |      82,467        161,079          51.20
         apr_em |      58,498        161,079          36.32
         rep_ef |      77,430        161,079          48.07
         rep_em |      58,498        161,079          36.32
         aba_ef |      77,430        161,079          48.07
         aba_em |      58,498        161,079          36.32
        dist_ef |      77,814        161,079          48.31
        dist_em |      60,525        161,079          37.57
       em_fluxo |      56,950        161,079          35.36
   enem_nota_~b |       9,096        161,079           5.65
   enem_~va_std |     100,414        161,079          62.34
   enem_n~b_std |       9,096        161,079           5.65
   enem_n~o_std |       6,378        161,079           3.96
   enem_~ca_std |      69,724        161,079          43.29
   enem~ias_std |      69,485        161,079          43.14
   enem~nas_std |      69,485        161,079          43.14
   enem_~ns_std |      69,724        161,079          43.29
     apr_em_std |      58,498        161,079          36.32
     rep_em_std |      58,498        161,079          36.32
     aba_em_std |      58,498        161,079          36.32
    dist_em_std |      60,525        161,079          37.57
   dependenci~a |           0        161,079           0.00
   n_profs_em~g |     122,129        161,079          75.82
   n_mulher~m_1 |       5,439        161,079           3.38
   n_mulher~m_2 |       5,439        161,079           3.38
   n_mulher~m_3 |       5,439        161,079           3.38
   n_mulher~m_4 |     152,527        161,079          94.69
   n_mulhe~m_ns |     152,527        161,079          94.69
          rural |           0        161,079           0.00
          ativa |           0        161,079           0.00
             em |      16,820        161,079          10.44
        em_prof |      46,472        161,079          28.85
         predio |         720        161,079           0.45
      diretoria |         469        161,079           0.29
   sala_profe~s |         470        161,079           0.29
     biblioteca |         470        161,079           0.29
   sala_leitura |      24,000        161,079          14.90
     refeitorio |      66,278        161,079          41.15
       lab_info |         472        161,079           0.29
   lab_ciencias |         472        161,079           0.29
   quadra_esp~s |         472        161,079           0.29
       internet |       4,446        161,079           2.76
    lixo_coleta |       2,994        161,079           1.86
   eletricidade |       2,994        161,079           1.86
           agua |       2,994        161,079           1.86
         esgoto |       2,995        161,079           1.86
   n_alunos~m_1 |       5,439        161,079           3.38
   n_alunos~m_2 |       5,439        161,079           3.38
   n_alunos~m_3 |       5,439        161,079           3.38
   p_mulheres~1 |      25,181        161,079          15.63
   p_mulheres~2 |      27,409        161,079          17.02
   p_mulheres~3 |      29,708        161,079          18.44
   n_branco~m_1 |      22,937        161,079          14.24
   n_branco~m_2 |      22,937        161,079          14.24
   n_branco~m_3 |      22,937        161,079          14.24
   p_brancos_~1 |      45,477        161,079          28.23
   p_brancos_~2 |      49,365        161,079          30.65
   p_brancos_~3 |      52,779        161,079          32.77
    nome_escola |      39,040        161,079          24.24
   codigo_mu~vo |      39,040        161,079          24.24
   n_salas_exis |      42,074        161,079          26.12
        regular |      42,116        161,079          26.15
   em_integrado |      55,860        161,079          34.68
      em_normal |      55,860        161,079          34.68
   n_turmas~m_1 |      41,944        161,079          26.04
   n_turmas~m_2 |      41,944        161,079          26.04
   n_turmas~m_3 |      41,944        161,079          26.04
   n_turmas~e_3 |      41,944        161,079          26.04
   n_turmas_e~4 |      41,944        161,079          26.04
   n_turmas_e~s |      41,944        161,079          26.04
   n_alu_tr~m_1 |      41,944        161,079          26.04
   n_alu_tr~m_2 |      41,944        161,079          26.04
   n_alu_tr~m_3 |      41,944        161,079          26.04
   m_idade_em_1 |      61,234        161,079          38.01
   m_idade_em_2 |      63,323        161,079          39.31
   m_idade_em_3 |      65,555        161,079          40.70
   p_alu_tran~1 |      61,234        161,079          38.01
   p_alu_tran~2 |      63,323        161,079          39.31
   p_alu_tran~3 |      65,555        161,079          40.70
   n_alunos~e_1 |      41,944        161,079          26.04
   n_alunos~e_2 |      41,944        161,079          26.04
   n_alunos~e_3 |      41,944        161,079          26.04
   n_alunos_e~4 |      41,944        161,079          26.04
   n_alunos_e~s |      41,944        161,079          26.04
   n_mulher~e_1 |      41,944        161,079          26.04
   n_mulher~e_2 |      41,944        161,079          26.04
   n_mulher~e_3 |      41,944        161,079          26.04
   n_mulher~e_4 |      41,944        161,079          26.04
   n_mulhe~e_ns |      41,944        161,079          26.04
   n_branco~e_1 |      41,944        161,079          26.04
   n_branco~e_2 |      41,944        161,079          26.04
   n_branco~e_3 |      41,944        161,079          26.04
   n_brancos_~4 |      41,944        161,079          26.04
   n_brancos_~s |      41,944        161,079          26.04
   n_alu_tr~e_1 |      41,944        161,079          26.04
   n_alu_tr~e_2 |      41,944        161,079          26.04
   n_alu_tr~e_3 |      41,944        161,079          26.04
   n_alu_tran~4 |      41,944        161,079          26.04
   n_alu_tran~s |      41,944        161,079          26.04
   n_profs_em_1 |      42,130        161,079          26.15
   n_profs_em_2 |      42,130        161,079          26.15
   n_profs_em_3 |      42,130        161,079          26.15
   n_pro~p_em_1 |      42,130        161,079          26.15
   n_pro~p_em_2 |      42,130        161,079          26.15
   n_pro~p_em_3 |      42,130        161,079          26.15
   p_profs_su~1 |      61,378        161,079          38.10
   p_profs_su~2 |      63,458        161,079          39.40
   p_profs_su~3 |      65,684        161,079          40.78
   n_profs_em.. |      42,130        161,079          26.15
   n_profs_em.. |      42,130        161,079          26.15
   n_profs_em.. |      42,130        161,079          26.15
   n_profs_em~4 |      42,130        161,079          26.15
   n_profs_em~s |      42,130        161,079          26.15
   ~p_em_inte_1 |      42,130        161,079          26.15
   ~p_em_inte_2 |      42,130        161,079          26.15
   ~p_em_inte_3 |      42,130        161,079          26.15
   n_profs_su~4 |      42,130        161,079          26.15
   n_profs_su~s |      42,130        161,079          26.15
    fund_8_anos |      92,810        161,079          57.62
    fund_9_anos |      92,810        161,079          57.62
   distrito_e~o |      91,059        161,079          56.53
   n_turmas~e_1 |     147,335        161,079          91.47
   n_turmas~e_2 |     147,335        161,079          91.47
   al_engaj_gov |           0        161,079           0.00
   al_engaj_sec |           0        161,079           0.00
   al_time_se~c |           0        161,079           0.00
   al_marcos_~i |           0        161,079           0.00
   al_todos_m~s |           0        161,079           0.00
     al_sel_dir |           0        161,079           0.00
    al_sel_prof |           0        161,079           0.00
   al_proj_vida |           0        161,079           0.00
   ensino_fun~l |     153,905        161,079          95.55
            ice |           0        161,079           0.00
       ice_2004 |           0        161,079           0.00
       ice_2005 |           0        161,079           0.00
       ice_2006 |           0        161,079           0.00
       ice_2007 |           0        161,079           0.00
       ice_2008 |           0        161,079           0.00
       ice_2009 |           0        161,079           0.00
       ice_2010 |           0        161,079           0.00
       ice_2011 |           0        161,079           0.00
       ice_2012 |           0        161,079           0.00
       ice_2013 |           0        161,079           0.00
       ice_2014 |           0        161,079           0.00
       ice_2015 |           0        161,079           0.00
       integral |     153,905        161,079          95.55
   ensino_medio |     153,905        161,079          95.55
   comp_polit~o |           0        161,079           0.00
   comp_selec~o |           0        161,079           0.00
   comp_eng_e~o |           0        161,079           0.00
   comp_proj_~o |           0        161,079           0.00
   ice_not~2004 |           0        161,079           0.00
   ice_not~2005 |           0        161,079           0.00
   ice_not~2006 |           0        161,079           0.00
   ice_not~2007 |           0        161,079           0.00
   ice_not~2008 |           0        161,079           0.00
   ice_not~2009 |           0        161,079           0.00
   ice_not~2010 |           0        161,079           0.00
   ice_not~2011 |           0        161,079           0.00
   ice_not~2012 |           0        161,079           0.00
   ice_not~2013 |           0        161,079           0.00
   ice_not~2014 |           0        161,079           0.00
   ice_not~2015 |           0        161,079           0.00
   ice_flu~2004 |           0        161,079           0.00
   ice_flu~2005 |           0        161,079           0.00
   ice_flu~2006 |           0        161,079           0.00
   ice_flu~2007 |           0        161,079           0.00
   ice_flu~2008 |           0        161,079           0.00
   ice_flu~2009 |           0        161,079           0.00
   ice_flu~2010 |           0        161,079           0.00
   ice_flu~2011 |           0        161,079           0.00
   ice_flu~2012 |           0        161,079           0.00
   ice_flu~2013 |           0        161,079           0.00
   ice_flu~2014 |           0        161,079           0.00
   ice_flu~2015 |           0        161,079           0.00
    d_ice_fluxo |           0        161,079           0.00
     d_ice_nota |           0        161,079           0.00
       d_rigor1 |           0        161,079           0.00
       d_rigor2 |           0        161,079           0.00
       d_rigor3 |           0        161,079           0.00
       d_rigor4 |           0        161,079           0.00
    d_segmento1 |           0        161,079           0.00
    d_segmento2 |           0        161,079           0.00
    d_segmento3 |           0        161,079           0.00
    d_segmento4 |           0        161,079           0.00
    d_segmento5 |           0        161,079           0.00
       ice_inte |           0        161,079           0.00
   ice_semi_i~e |           0        161,079           0.00
   d_ice~o_inte |           0        161,079           0.00
   d_ice~a_inte |           0        161,079           0.00
   ~o_semi_inte |           0        161,079           0.00
   ~a_semi_inte |           0        161,079           0.00
      al_outros |           0        161,079           0.00
   d_ice_not~l1 |           0        161,079           0.00
   d_ice_flu~l1 |           0        161,079           0.00
   d_ice_not~l2 |           0        161,079           0.00
   d_ice_flu~l2 |           0        161,079           0.00
   d_ice_not~l3 |           0        161,079           0.00
   d_ice_flu~l3 |           0        161,079           0.00
   d_ice_not~l4 |           0        161,079           0.00
   d_ice_flu~l4 |           0        161,079           0.00
   d_ice_nota~5 |           0        161,079           0.00
   d_ice_flux~5 |           0        161,079           0.00
   d_ice_nota~6 |           0        161,079           0.00
   d_ice_flux~6 |           0        161,079           0.00
   d_ice_nota~7 |           0        161,079           0.00
   d_ice_flux~7 |           0        161,079           0.00
   d_ice_nota~8 |           0        161,079           0.00
   d_ice_flux~8 |           0        161,079           0.00
   d_ice_nota~9 |           0        161,079           0.00
   d_ice_flux~9 |           0        161,079           0.00
   d_ice_not~p1 |           0        161,079           0.00
   d_ice_flu~p1 |           0        161,079           0.00
   d_ice_not~p2 |           0        161,079           0.00
   d_ice_flu~p2 |           0        161,079           0.00
   d_ice_not~p3 |           0        161,079           0.00
   d_ice_flu~p3 |           0        161,079           0.00
   d_ice_not~p4 |           0        161,079           0.00
   d_ice_flu~p4 |           0        161,079           0.00
      mais_educ |           0        161,079           0.00
         d_dep1 |           0        161,079           0.00
         d_dep2 |           0        161,079           0.00
         d_dep3 |           0        161,079           0.00
         d_dep4 |           0        161,079           0.00
          d_uf1 |       6,006        161,079           3.73
          d_uf2 |       6,006        161,079           3.73
          d_uf3 |       6,006        161,079           3.73
          d_uf4 |       6,006        161,079           3.73
          d_uf5 |       6,006        161,079           3.73
          d_uf6 |       6,006        161,079           3.73
         d_ano1 |           0        161,079           0.00
         d_ano2 |           0        161,079           0.00
         d_ano3 |           0        161,079           0.00
         d_ano4 |           0        161,079           0.00
         d_ano5 |           0        161,079           0.00
         d_ano6 |           0        161,079           0.00
         d_ano7 |           0        161,079           0.00
         d_ano8 |           0        161,079           0.00
         d_ano9 |           0        161,079           0.00
        d_ano10 |           0        161,079           0.00
        d_ano11 |           0        161,079           0.00
        d_ano12 |           0        161,079           0.00
        d_ano13 |           0        161,079           0.00
    n_alunos_em |       5,439        161,079           3.38
   n_mulheres~m |       5,439        161,079           3.38
   n_brancos_em |      22,937        161,079          14.24
    n_alunos_ep |      41,944        161,079          26.04
   n_mulhe~s_ep |      41,944        161,079          26.04
   n_brancos_ep |      41,944        161,079          26.04
   n_aluno~m_ep |      41,944        161,079          26.04
   n_mulhe~m_ep |      41,944        161,079          26.04
   n_branc~m_ep |      41,944        161,079          26.04
   taxa_parti~x |      29,708        161,079          18.44
   taxa_parti~2 |     153,986        161,079          95.60
   taxa_parti~m |      29,278        161,079          18.18
----------------+-----------------------------------------------


*/
ds
/*
codigo_esc~a  enem_~va_std  n_alunos~m_1  n_alunos_e~4  fund_8_anos   ice_not~2007  ~o_semi_inte  d_uf3
ano           enem_n~b_std  n_alunos~m_2  n_alunos_e~s  fund_9_anos   ice_not~2008  ~a_semi_inte  d_uf4
ano_enem      enem_n~o_std  n_alunos~m_3  n_mulher~e_1  distrito_e~o  ice_not~2009  al_outros     d_uf5
cod_munic     enem_~ca_std  p_mulheres~1  n_mulher~e_2  n_turmas~e_1  ice_not~2010  d_ice_not~l1  d_uf6
codigo_mu~go  enem~ias_std  p_mulheres~2  n_mulher~e_3  n_turmas~e_2  ice_not~2011  d_ice_flu~l1  d_ano1
cod_meso      enem~nas_std  p_mulheres~3  n_mulher~e_4  al_engaj_gov  ice_not~2012  d_ice_not~l2  d_ano2
nome_munic~o  enem_~ns_std  n_branco~m_1  n_mulhe~e_ns  al_engaj_sec  ice_not~2013  d_ice_flu~l2  d_ano3
codigo_uf     apr_em_std    n_branco~m_2  n_branco~e_1  al_time_se~c  ice_not~2014  d_ice_not~l3  d_ano4
estado        rep_em_std    n_branco~m_3  n_branco~e_2  al_marcos_~i  ice_not~2015  d_ice_flu~l3  d_ano5
pib           aba_em_std    p_brancos_~1  n_branco~e_3  al_todos_m~s  ice_flu~2004  d_ice_not~l4  d_ano6
pop           dist_em_std   p_brancos_~2  n_brancos_~4  al_sel_dir    ice_flu~2005  d_ice_flu~l4  d_ano7
pib_capita~s  dependenci~a  p_brancos_~3  n_brancos_~s  al_sel_prof   ice_flu~2006  d_ice_nota~5  d_ano8
pib_cap~2003  n_profs_em~g  nome_escola   n_alu_tr~e_1  al_proj_vida  ice_flu~2007  d_ice_flux~5  d_ano9
pib_cap~2015  n_mulher~m_1  codigo_mu~vo  n_alu_tr~e_2  ensino_fun~l  ice_flu~2008  d_ice_nota~6  d_ano10
concluir_e~m  n_mulher~m_2  n_salas_exis  n_alu_tr~e_3  ice           ice_flu~2009  d_ice_flux~6  d_ano11
e_mora_mai~s  n_mulher~m_3  regular       n_alu_tran~4  ice_2004      ice_flu~2010  d_ice_nota~7  d_ano12
e_escol_su~i  n_mulher~m_4  em_integrado  n_alu_tran~s  ice_2005      ice_flu~2011  d_ice_flux~7  d_ano13
e_escol_su~e  n_mulhe~m_ns  em_normal     n_profs_em_1  ice_2006      ice_flu~2012  d_ice_nota~8  n_alunos_em
e_renda_fa~s  rural         n_turmas~m_1  n_profs_em_2  ice_2007      ice_flu~2013  d_ice_flux~8  n_mulheres~m
e_trabalho~u  ativa         n_turmas~m_2  n_profs_em_3  ice_2008      ice_flu~2014  d_ice_nota~9  n_brancos_em
enem_nota~va  em            n_turmas~m_3  n_pro~p_em_1  ice_2009      ice_flu~2015  d_ice_flux~9  n_alunos_ep
enem_nota~ca  em_prof       n_turmas~e_3  n_pro~p_em_2  ice_2010      d_ice_fluxo   d_ice_not~p1  n_mulhe~s_ep
enem_nota~ns  predio        n_turmas_e~4  n_pro~p_em_3  ice_2011      d_ice_nota    d_ice_flu~p1  n_brancos_ep
enem_not~nas  diretoria     n_turmas_e~s  p_profs_su~1  ice_2012      d_rigor1      d_ice_not~p2  n_aluno~m_ep
enem_not~ias  sala_profe~s  n_alu_tr~m_1  p_profs_su~2  ice_2013      d_rigor2      d_ice_flu~p2  n_mulhe~m_ep
enem_nota_~o  biblioteca    n_alu_tr~m_2  p_profs_su~3  ice_2014      d_rigor3      d_ice_not~p3  n_branc~m_ep
apr_ef        sala_leitura  n_alu_tr~m_3  n_profs_em..  ice_2015      d_rigor4      d_ice_flu~p3  taxa_parti~x
apr_em        refeitorio    m_idade_em_1  n_profs_em..  integral      d_segmento1   d_ice_not~p4  taxa_parti~2
rep_ef        lab_info      m_idade_em_2  n_profs_em..  ensino_medio  d_segmento2   d_ice_flu~p4  taxa_parti~m
rep_em        lab_ciencias  m_idade_em_3  n_profs_em~4  comp_polit~o  d_segmento3   mais_educ
aba_ef        quadra_esp~s  p_alu_tran~1  n_profs_em~s  comp_selec~o  d_segmento4   d_dep1
aba_em        internet      p_alu_tran~2  ~p_em_inte_1  comp_eng_e~o  d_segmento5   d_dep2
dist_ef       lixo_coleta   p_alu_tran~3  ~p_em_inte_2  comp_proj_~o  ice_inte      d_dep3
dist_em       eletricidade  n_alunos~e_1  ~p_em_inte_3  ice_not~2004  ice_semi_i~e  d_dep4
em_fluxo      agua          n_alunos~e_2  n_profs_su~4  ice_not~2005  d_ice~o_inte  d_uf1
enem_nota_~b  esgoto        n_alunos~e_3  n_profs_su~s  ice_not~2006  d_ice~a_inte  d_uf2
*/


save "$folderservidor\dados_EM_14_v1.dta", replace
save "\\tsclient\C\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\\Bases\dados_EM_14_v1.dta", replace
log close
