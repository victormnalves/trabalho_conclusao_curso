/*ensino médio 
mergeando :

enem
pib por cidade
indicadores inep
censo escolar
ice
mais educação



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
log using "$folderservidor\\logfiles/em_final.log", replace



use "$folderservidor\enem\enem_todos_limpo.dta", clear
merge 1:1 codigo_escola ano using "$folderservidor\censo_escolar\censo_escolar_todos.dta"
*dropando valores do censo que não tem nem nota nem indicadores de fluxo
drop if _merge == 2

*dropando valores do censo que não tem características no censo

drop if _merge == 1
drop _merge

sort ano codigo_escola
drop mascara codigo_municipio UF sigla 


save "$folderservidor\enem_censo_escolar_14_v3.dta",replace

use "$folderservidor\base_final_ice_14.dta", clear

tab integral ice_jornada
tab ice_segmento
*ensino_medio indica se escola tem segmento ensino integral
gen ensino_medio=1 
replace ensino_medio = 0 if ice_segmento == "EFII" | ice_segmento == "EF FINAIS " 
tab ice_segmento ensino_medio
*verificando a matriz de correlação entre alavancas

corr al_engaj_gov - al_proj if ensino_medio ==1

local alavancas al_engaj_gov al_engaj_sec al_time_seduc al_marcos_lei al_todos_marcos al_sel_dir al_sel_prof al_proj_vida
foreach x in `alavancas'{
tab `x'
}
/*

al_engaj_go |
          v |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |         63        9.81        9.81
          1 |        579       90.19      100.00
------------+-----------------------------------
      Total |        642      100.00

al_engaj_se |
          c |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |         55        8.57        8.57
          1 |        587       91.43      100.00
------------+-----------------------------------
      Total |        642      100.00

al_time_sed |
         uc |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |         51        7.94        7.94
          1 |        591       92.06      100.00
------------+-----------------------------------
      Total |        642      100.00

al_marcos_l |
         ei |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |          3        0.47        0.47
          1 |        639       99.53      100.00
------------+-----------------------------------
      Total |        642      100.00

al_todos_ma |
       rcos |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |         39        6.07        6.07
          1 |        603       93.93      100.00
------------+-----------------------------------
      Total |        642      100.00

 al_sel_dir |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        288       44.86       44.86
          1 |        354       55.14      100.00
------------+-----------------------------------
      Total |        642      100.00

al_sel_prof |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        304       47.35       47.35
          1 |        338       52.65      100.00
------------+-----------------------------------
      Total |        642      100.00

al_proj_vid |
          a |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        341       53.12       53.12
          1 |        301       46.88      100.00
------------+-----------------------------------
      Total |        642      100.00

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
* temos que o comp 1 tem  4 valores positivos mais altos, alavanca 1 - teve bom engajamento do governador
* alavanca 2 - teve bom engajamento do secretário de educação
* alavanca 3 - tinha time da SEDUC deducado para a implantação do programa
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
*criando dummy do programa para fluxo e outro para nota
*isso por que nas escolas da restrição abaixo, o programa foi implementado somente no primeiro ano do ensino médio
*então há um lag para efeito na nota do enem de dois anos

forvalues a=2004(1)2015{
gen ice_nota_`a' = ice_`a'
replace ice_nota_`a'=0 if (ano>`a'-2&ano<=`a')&(uf=="PE"|uf=="CE")&ensino_fundamental==0 


}

forvalues a=2004(1)2015{
gen ice_fluxo_`a' = ice_`a'
}
replace ice=1
save "$folderservidor\base_final_ice_2_14.dta", replace



* vamos merger com a base ice
use "$folderservidor\enem_censo_escolar_14_v3.dta", clear

merge m:1 codigo_escola using "$folderservidor\base_final_ice_2_14.dta"
*dropando observações que só estavam na base ICE
drop if _merge == 2
drop _merge
sort  codigo_escola ano
format codigo_escola %10.0g
format codigo_municipio_longo %20.0g
replace ice =0 if ice ==.
/*
*dropando escolas somente com informações de alavanca, mas sem informação de data de entrada no programa
drop if ice ==.
*(9obs deleted)
*dropando escolas que entraram somente em 2016
drop if ano_ice ==2016
*(9 observations deleted)
*/

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



*componentes principais das alavancas
local componentes_alavancas comp_politico_positivo comp_selecao_remocao_negativo comp_eng_executivo_negativo comp_proj_vida_positvo
foreach x in `componentes_alavancas' {
replace `x'=0 if `x'==.
}





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

forvalues x=1(1)3{
replace n_alunos_em_`x'=0 if n_alunos_em_`x'==.
replace n_mulheres_em_`x'=0 if n_mulheres_em_`x'==.
replace n_brancos_em_`x'=0 if n_brancos_em_`x'==.
}

gen n_alunos_em=n_alunos_em_1+n_alunos_em_2 +n_alunos_em_3
replace n_alunos_em=0 if n_alunos_em==.
gen n_mulheres_em=n_mulheres_em_1+n_mulheres_em_2 +n_mulheres_em_3
replace n_mulheres_em=0 if n_mulheres_em==.
gen n_brancos_em=n_brancos_em_1+n_brancos_em_2 +n_brancos_em_3
replace n_brancos_em=0 if n_brancos_em==.

foreach x in "1" "2" "3" "4" "ns"{
replace n_alunos_em_inte_`x'=0 if n_alunos_em_inte_`x'==.
replace n_mulheres_em_inte_`x'=0 if n_mulheres_em_inte_`x'==.
replace n_brancos_em_inte_`x'=0 if n_brancos_em_inte_`x'==.

}

gen n_alunos_ep=n_alunos_em_inte_1+ n_alunos_em_inte_2+ n_alunos_em_inte_3 +n_alunos_em_inte_4 +n_alunos_em_inte_ns
replace n_alunos_ep=0 if n_alunos_ep==.
gen n_mulheres_ep=n_mulheres_em_inte_1+ n_mulheres_em_inte_2+ n_mulheres_em_inte_3 +n_mulheres_em_inte_4 +n_mulheres_em_inte_ns
replace n_mulheres_ep=0 if n_mulheres_ep==.
gen n_brancos_ep=n_brancos_em_inte_1+ n_brancos_em_inte_2+ n_brancos_em_inte_3 +n_brancos_em_inte_4 +n_brancos_em_inte_ns
replace n_brancos_ep=0 if n_brancos_ep==.


gen n_alunos_em_ep=n_alunos_em+n_alunos_ep
gen n_mulheres_em_ep = n_mulheres_em+n_mulheres_ep
gen n_brancos_em_ep = n_brancos_em+n_brancos_ep

******* Taxas de Participacao no ENEM e na Prova Brasil **********

**** ENEM ****
replace concluir_em_ano_enem=0 if concluir_em_ano_enem==.
*gen taxa_participacao_enem=taxa_participacao_enem/100
gen taxa_participacao_enem_aux=concluir_em_ano_enem/n_alunos_em_3
gen taxa_participacao_enem_aux2=concluir_em_ano_enem/(n_alunos_em_inte_3+n_alunos_em_3) if codigo_uf==23

gen taxa_participacao_enem=taxa_participacao_enem_aux
replace taxa_participacao_enem=taxa_participacao_enem_aux2 if codigo_uf==23


drop n_turmas_mais_educ_em_1 n_turmas_mais_educ_em_2 n_turmas_mais_educ_em_3 n_turmas_mais_educ_em_inte_1 n_turmas_mais_educ_em_inte_2 n_turmas_mais_educ_em_inte_3 n_turmas_mais_educ_em_inte_4 n_turmas_mais_educ_em_inte_ns n_turmas_mais_educ_fund_5_8anos n_turmas_mais_educ_fund_6_8anos n_turmas_mais_educ_fund_7_8anos n_turmas_mais_educ_fund_8_8anos n_turmas_mais_educ_fund_6_9anos n_turmas_mais_educ_fund_7_9anos n_turmas_mais_educ_fund_8_9anos n_turmas_mais_educ_fund_9_9anos

save "$folderservidor\em_com_censo_escolar_14.dta", replace
*&save "\\tsclient\C\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\\Bases\em_com_censo_escolar_14.dta", replace
log close
