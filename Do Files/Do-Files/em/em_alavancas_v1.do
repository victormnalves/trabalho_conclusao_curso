*******************************************************************************
/*						ENSINO MÉDIO ALAVANCAS								*/	
*******************************************************************************
/*
Dado que observamos impactos positivos do programa nos outcomes,
queremos ver o impacto das alavancas nos outcomes
para entender se há algum tipo de canal de transmição 
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

log using "$Logfolder/em_alavancas_v1.log", replace
use "$folderservidor\dados_EM_14_enem_only.dta", clear

global alavancas_dummies al_engaj_gov - al_proj al_outros

/*
analizando as covariancias cruzadas e variancais das alavancas
*/

corr al_engaj_gov - al_proj al_outros if ensino_medio ==1
/*


             | al_eng~v al_eng~c al_tim~c al_mar~i al_tod~s al_sel~r al_sel~f al_pro~a al_out~s
-------------+---------------------------------------------------------------------------------
al_engaj_gov |   1.0000
al_engaj_sec |   0.9931   1.0000
al_time_se~c |   0.8867   0.8952   1.0000
al_marcos_~i |   0.6513   0.6468   0.7320   1.0000
al_todos_m~s |   0.8942   0.8880   0.9922   0.7377   1.0000
  al_sel_dir |   0.3895   0.3832   0.4703   0.3460   0.4778   1.0000
 al_sel_prof |   0.5064   0.5100   0.4523   0.3245   0.4486   0.9402   1.0000
al_proj_vida |  -0.1339  -0.1403  -0.0432   0.2433  -0.0361  -0.7599  -0.8340   1.0000
   al_outros |   0.6624   0.6578   0.7220   0.9864   0.7277   0.3568   0.3354   0.2400   1.0000



*/

/*
matrix accum A = $alavancas_dummies, deviations noconstant 
matrix A = A/(r(N)-1)
mat list A
*/

local alavancas al_engaj_gov al_engaj_sec al_time_seduc al_marcos_lei al_todos_marcos al_sel_dir al_sel_prof al_proj_vida
foreach x in `alavancas'{
tab `x' if ensino_medio ==1
}



{
  /*
al_engaj_go |
          v |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |      1,137       18.04       18.04
          1 |      5,167       81.96      100.00
------------+-----------------------------------
      Total |      6,304      100.00

al_engaj_se |
          c |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |      1,150       18.24       18.24
          1 |      5,154       81.76      100.00
------------+-----------------------------------
      Total |      6,304      100.00

al_time_sed |
         uc |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        985       15.63       15.63
          1 |      5,319       84.38      100.00
------------+-----------------------------------
      Total |      6,304      100.00

al_marcos_l |
         ei |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        569        9.03        9.03
          1 |      5,735       90.97      100.00
------------+-----------------------------------
      Total |      6,304      100.00

al_todos_ma |
       rcos |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        972       15.42       15.42
          1 |      5,332       84.58      100.00
------------+-----------------------------------
      Total |      6,304      100.00

 al_sel_dir |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |      2,719       43.13       43.13
          1 |      3,585       56.87      100.00
------------+-----------------------------------
      Total |      6,304      100.00

al_sel_prof |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |      2,911       46.18       46.18
          1 |      3,393       53.82      100.00
------------+-----------------------------------
      Total |      6,304      100.00

al_proj_vid |
          a |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |      3,948       62.63       62.63
          1 |      2,356       37.37      100.00
------------+-----------------------------------
      Total |      6,304      100.00

. 

*/
}
local alavancas al_engaj_gov al_engaj_sec al_time_seduc al_marcos_lei al_todos_marcos al_sel_dir al_sel_prof al_proj_vida
foreach x in `alavancas'{
tab `x' if ensino_medio ==1 &ano==2004
}
{
/*
al_engaj_go |
          v |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |         83       19.58       19.58
          1 |        341       80.42      100.00
------------+-----------------------------------
      Total |        424      100.00

al_engaj_se |
          c |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |         84       19.81       19.81
          1 |        340       80.19      100.00
------------+-----------------------------------
      Total |        424      100.00

al_time_sed |
         uc |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |         71       16.75       16.75
          1 |        353       83.25      100.00
------------+-----------------------------------
      Total |        424      100.00

al_marcos_l |
         ei |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |         39        9.20        9.20
          1 |        385       90.80      100.00
------------+-----------------------------------
      Total |        424      100.00

al_todos_ma |
       rcos |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |         70       16.51       16.51
          1 |        354       83.49      100.00
------------+-----------------------------------
      Total |        424      100.00

 al_sel_dir |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        191       45.05       45.05
          1 |        233       54.95      100.00
------------+-----------------------------------
      Total |        424      100.00

al_sel_prof |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        206       48.58       48.58
          1 |        218       51.42      100.00
------------+-----------------------------------
      Total |        424      100.00

al_proj_vid |
          a |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        256       60.38       60.38
          1 |        168       39.62      100.00
------------+-----------------------------------
      Total |        424      100.00

*/
}
local alavancas al_engaj_gov al_engaj_sec al_time_seduc al_marcos_lei al_todos_marcos al_sel_dir al_sel_prof al_proj_vida
foreach x in `alavancas'{
tab `x' if ensino_medio ==1 &ano==2015
}

{
/*

al_engaj_go |
          v |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |         89       16.18       16.18
          1 |        461       83.82      100.00
------------+-----------------------------------
      Total |        550      100.00

al_engaj_se |
          c |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |         90       16.36       16.36
          1 |        460       83.64      100.00
------------+-----------------------------------
      Total |        550      100.00

al_time_sed |
         uc |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |         79       14.36       14.36
          1 |        471       85.64      100.00
------------+-----------------------------------
      Total |        550      100.00

al_marcos_l |
         ei |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |         47        8.55        8.55
          1 |        503       91.45      100.00
------------+-----------------------------------
      Total |        550      100.00

al_todos_ma |
       rcos |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |         78       14.18       14.18
          1 |        472       85.82      100.00
------------+-----------------------------------
      Total |        550      100.00

 al_sel_dir |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        215       39.09       39.09
          1 |        335       60.91      100.00
------------+-----------------------------------
      Total |        550      100.00

al_sel_prof |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        229       41.64       41.64
          1 |        321       58.36      100.00
------------+-----------------------------------
      Total |        550      100.00

al_proj_vid |
          a |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        366       66.55       66.55
          1 |        184       33.45      100.00
------------+-----------------------------------
      Total |        550      100.00


*/}



/*
existe um problema de analisar as alavancas dessa maneira:
elas indicam se uma determinada escola tratada recebeu essa alavanca ou não
no entanto, ela ignora o timing. na base, se uma escola foi o será tratada, 
ela tera todas as alavancas.
precisamos levar em conta o timing
*/


/*
as variáveis d_ice_nota_al1 a d_ice_fluxo_al9 já levam em conta esse timinig
essas variáveis são a interação entre a dummy de ter o programa em determinado
ano e das dummies de alavanca

alavanca 1 - teve bom engajamento do governador
alavanca 2 - teve bom engajamento do secretário de educação
alavanca 3 - tinha time da SEDUC dedicado para a implantação do programa
alavanca 4 - teve implantação dos marcos legais na forma da Lei?
alavanca 5 - teve Implantação de todos os marcos legais previstos no cronograma estipulado?
alavanca 6 - teve Implantação do processo de seleção e remoção de diretores?
alavanca 7 - teve Implantação do processo de seleção e remoção de professores?
alavanca 8 - teve Implantação do projeto de vida na Matriz Curricular?
alavanca 9 - Outros

gen al_outros=0
replace al_outros=1 if (al_engaj_gov==1|al_time_seduc==1|al_marcos_lei==1|al_proj_vida==1)

*/

global interacoes_alavancas_nota d_ice_nota_al* 
global interacoes_alavancas_fluxo d_ice_fluxo_al*
corr $interacoes_alavancas_nota if ensino_medio ==1 & ano==2004
/*
             | d_~a_al1 d_~a_al2 d_~a_al3 d_~a_al4 d_~a_al5 d_~a_al6 d_~a_al7 d_~a_al8 d_~a_al9
-------------+---------------------------------------------------------------------------------
d_ice_not~l1 |        .
d_ice_not~l2 |        .        .
d_ice_not~l3 |        .        .        .
d_ice_not~l4 |        .        .        .        .
d_ice_nota~5 |        .        .        .        .        .
d_ice_nota~6 |        .        .        .        .        .        .
d_ice_nota~7 |        .        .        .        .        .        .        .
d_ice_nota~8 |        .        .        .        .        .        .        .        .
d_ice_nota~9 |        .        .        .        .        .        .        .        .        .
*/
corr $interacoes_alavancas_nota if ensino_medio ==1 & ano==2005
/*
             | d_~a_al1 d_~a_al2 d_~a_al3 d_~a_al4 d_~a_al5 d_~a_al6 d_~a_al7 d_~a_al8 d_~a_al9
-------------+---------------------------------------------------------------------------------
d_ice_not~l1 |        .
d_ice_not~l2 |        .        .
d_ice_not~l3 |        .        .        .
d_ice_not~l4 |        .        .        .        .
d_ice_nota~5 |        .        .        .        .        .
d_ice_nota~6 |        .        .        .        .        .        .
d_ice_nota~7 |        .        .        .        .        .        .        .
d_ice_nota~8 |        .        .        .        .        .        .        .        .
d_ice_nota~9 |        .        .        .        .        .        .        .        .        .

*/
corr $interacoes_alavancas_nota if ensino_medio ==1 & ano==2006 & ice==1

/*

             | d_~a_al1 d_~a_al2 d_~a_al3 d_~a_al4 d_~a_al5 d_~a_al6 d_~a_al7 d_~a_al8 d_~a_al9
-------------+---------------------------------------------------------------------------------
d_ice_not~l1 |   1.0000
d_ice_not~l2 |   1.0000   1.0000
d_ice_not~l3 |   1.0000   1.0000   1.0000
d_ice_not~l4 |   1.0000   1.0000   1.0000   1.0000
d_ice_nota~5 |   1.0000   1.0000   1.0000   1.0000   1.0000
d_ice_nota~6 |   1.0000   1.0000   1.0000   1.0000   1.0000   1.0000
d_ice_nota~7 |   1.0000   1.0000   1.0000   1.0000   1.0000   1.0000   1.0000
d_ice_nota~8 |        .        .        .        .        .        .        .        .
d_ice_nota~9 |   1.0000   1.0000   1.0000   1.0000   1.0000   1.0000   1.0000        .   1.0000


*/


corr $interacoes_alavancas_nota if ensino_medio ==1 & ano==2007 & ice==1
/*

             | d_~a_al1 d_~a_al2 d_~a_al3 d_~a_al4 d_~a_al5 d_~a_al6 d_~a_al7 d_~a_al8 d_~a_al9
-------------+---------------------------------------------------------------------------------
d_ice_not~l1 |   1.0000
d_ice_not~l2 |   1.0000   1.0000
d_ice_not~l3 |   1.0000   1.0000   1.0000
d_ice_not~l4 |   1.0000   1.0000   1.0000   1.0000
d_ice_nota~5 |   1.0000   1.0000   1.0000   1.0000   1.0000
d_ice_nota~6 |   1.0000   1.0000   1.0000   1.0000   1.0000   1.0000
d_ice_nota~7 |   1.0000   1.0000   1.0000   1.0000   1.0000   1.0000   1.0000
d_ice_nota~8 |        .        .        .        .        .        .        .        .
d_ice_nota~9 |   1.0000   1.0000   1.0000   1.0000   1.0000   1.0000   1.0000        .   1.0000



*/
corr $interacoes_alavancas_nota if ensino_medio ==1 & ano==2008 & ice==1
/*

             | d_~a_al1 d_~a_al2 d_~a_al3 d_~a_al4 d_~a_al5 d_~a_al6 d_~a_al7 d_~a_al8 d_~a_al9
-------------+---------------------------------------------------------------------------------
d_ice_not~l1 |   1.0000
d_ice_not~l2 |   1.0000   1.0000
d_ice_not~l3 |   1.0000   1.0000   1.0000
d_ice_not~l4 |   1.0000   1.0000   1.0000   1.0000
d_ice_nota~5 |   1.0000   1.0000   1.0000   1.0000   1.0000
d_ice_nota~6 |   1.0000   1.0000   1.0000   1.0000   1.0000   1.0000
d_ice_nota~7 |   1.0000   1.0000   1.0000   1.0000   1.0000   1.0000   1.0000
d_ice_nota~8 |        .        .        .        .        .        .        .        .
d_ice_nota~9 |   1.0000   1.0000   1.0000   1.0000   1.0000   1.0000   1.0000        .   1.0000



*/
corr $interacoes_alavancas_nota if ensino_medio ==1 & ano==2009 & ice==1
/*

             | d_~a_al1 d_~a_al2 d_~a_al3 d_~a_al4 d_~a_al5 d_~a_al6 d_~a_al7 d_~a_al8 d_~a_al9
-------------+---------------------------------------------------------------------------------
d_ice_not~l1 |   1.0000
d_ice_not~l2 |   1.0000   1.0000
d_ice_not~l3 |   1.0000   1.0000   1.0000
d_ice_not~l4 |   1.0000   1.0000   1.0000   1.0000
d_ice_nota~5 |   1.0000   1.0000   1.0000   1.0000   1.0000
d_ice_nota~6 |   1.0000   1.0000   1.0000   1.0000   1.0000   1.0000
d_ice_nota~7 |   1.0000   1.0000   1.0000   1.0000   1.0000   1.0000   1.0000
d_ice_nota~8 |        .        .        .        .        .        .        .        .
d_ice_nota~9 |   1.0000   1.0000   1.0000   1.0000   1.0000   1.0000   1.0000        .   1.0000



*/
corr $interacoes_alavancas_nota if ensino_medio ==1 & ano==2010 & ice==1
/*

             | d_~a_al1 d_~a_al2 d_~a_al3 d_~a_al4 d_~a_al5 d_~a_al6 d_~a_al7 d_~a_al8 d_~a_al9
-------------+---------------------------------------------------------------------------------
d_ice_not~l1 |   1.0000
d_ice_not~l2 |   1.0000   1.0000
d_ice_not~l3 |   0.9919   0.9919   1.0000
d_ice_not~l4 |   0.9919   0.9919   1.0000   1.0000
d_ice_nota~5 |   0.9919   0.9919   1.0000   1.0000   1.0000
d_ice_nota~6 |   1.0000   1.0000   0.9919   0.9919   0.9919   1.0000
d_ice_nota~7 |   1.0000   1.0000   0.9919   0.9919   0.9919   1.0000   1.0000
d_ice_nota~8 |        .        .        .        .        .        .        .        .
d_ice_nota~9 |   1.0000   1.0000   0.9919   0.9919   0.9919   1.0000   1.0000        .   1.0000


*/
corr $interacoes_alavancas_nota if ensino_medio ==1 & ano==2011 & ice==1
/*

             | d_~a_al1 d_~a_al2 d_~a_al3 d_~a_al4 d_~a_al5 d_~a_al6 d_~a_al7 d_~a_al8 d_~a_al9
-------------+---------------------------------------------------------------------------------
d_ice_not~l1 |   1.0000
d_ice_not~l2 |   1.0000   1.0000
d_ice_not~l3 |   0.9952   0.9952   1.0000
d_ice_not~l4 |   0.9761   0.9761   0.9809   1.0000
d_ice_nota~5 |   0.9952   0.9952   1.0000   0.9809   1.0000
d_ice_nota~6 |   1.0000   1.0000   0.9952   0.9761   0.9952   1.0000
d_ice_nota~7 |   1.0000   1.0000   0.9952   0.9761   0.9952   1.0000   1.0000
d_ice_nota~8 |  -0.0566  -0.0566  -0.0563   0.1388  -0.0563  -0.0566  -0.0566   1.0000
d_ice_nota~9 |   0.9810   0.9810   0.9763   0.9952   0.9763   0.9810   0.9810   0.1382   1.0000



*/
corr $interacoes_alavancas_nota if ensino_medio ==1 & ano==2012 & ice==1
/*
             | d_~a_al1 d_~a_al2 d_~a_al3 d_~a_al4 d_~a_al5 d_~a_al6 d_~a_al7 d_~a_al8 d_~a_al9
-------------+---------------------------------------------------------------------------------
d_ice_not~l1 |   1.0000
d_ice_not~l2 |   0.9960   1.0000
d_ice_not~l3 |   0.9920   0.9960   1.0000
d_ice_not~l4 |   0.9122   0.9085   0.9127   1.0000
d_ice_nota~5 |   0.9960   0.9919   0.9960   0.9164   1.0000
d_ice_nota~6 |   0.9445   0.9402   0.9358   0.8610   0.9402   1.0000
d_ice_nota~7 |   0.9406   0.9444   0.9401   0.8574   0.9363   0.9959   1.0000
d_ice_nota~8 |   0.0048  -0.0094  -0.0083   0.3142   0.0059  -0.1968  -0.2114   1.0000
d_ice_nota~9 |   0.9165   0.9128   0.9092   0.9961   0.9128   0.8657   0.8621   0.3130   1.0000


*/
corr $interacoes_alavancas_nota if ensino_medio ==1 & ano==2013 & ice==1
/*
             | d_~a_al1 d_~a_al2 d_~a_al3 d_~a_al4 d_~a_al5 d_~a_al6 d_~a_al7 d_~a_al8 d_~a_al9
-------------+---------------------------------------------------------------------------------
d_ice_not~l1 |   1.0000
d_ice_not~l2 |   0.9963   1.0000
d_ice_not~l3 |   0.9414   0.9453   1.0000
d_ice_not~l4 |   0.8696   0.8664   0.9173   1.0000
d_ice_nota~5 |   0.9452   0.9417   0.9963   0.9207   1.0000
d_ice_nota~6 |   0.7889   0.7847   0.8397   0.7765   0.8441   1.0000
d_ice_nota~7 |   0.8443   0.8474   0.7998   0.7330   0.7968   0.9446   1.0000
d_ice_nota~8 |   0.0476   0.0388   0.1642   0.3704   0.1731  -0.2189  -0.3552   1.0000
d_ice_nota~9 |   0.8738   0.8706   0.9138   0.9962   0.9172   0.7811   0.7378   0.3690   1.0000

*/
corr $interacoes_alavancas_nota if ensino_medio ==1 & ano==2014 & ice==1
/*

             | d_~a_al1 d_~a_al2 d_~a_al3 d_~a_al4 d_~a_al5 d_~a_al6 d_~a_al7 d_~a_al8 d_~a_al9
-------------+---------------------------------------------------------------------------------
d_ice_not~l1 |   1.0000
d_ice_not~l2 |   0.9956   1.0000
d_ice_not~l3 |   0.9247   0.9296   1.0000
d_ice_not~l4 |   0.8144   0.8108   0.8759   1.0000
d_ice_nota~5 |   0.9293   0.9252   0.9954   0.8800   1.0000
d_ice_nota~6 |   0.5695   0.5647   0.6242   0.5508   0.6294   1.0000
d_ice_nota~7 |   0.6455   0.6484   0.5980   0.5207   0.5952   0.9469   1.0000
d_ice_nota~8 |   0.0395   0.0330   0.1311   0.3306   0.1380  -0.5389  -0.6257   1.0000
d_ice_nota~9 |   0.8249   0.8212   0.8667   0.9895   0.8707   0.5623   0.5325   0.3272   1.0000



*/
corr $interacoes_alavancas_nota if ensino_medio ==1 & ano==2015 & ice==1

/*

             | d_~a_al1 d_~a_al2 d_~a_al3 d_~a_al4 d_~a_al5 d_~a_al6 d_~a_al7 d_~a_al8 d_~a_al9
-------------+---------------------------------------------------------------------------------
d_ice_not~l1 |   1.0000
d_ice_not~l2 |   0.9933   1.0000
d_ice_not~l3 |   0.8899   0.8979   1.0000
d_ice_not~l4 |   0.6604   0.6559   0.7464   1.0000
d_ice_nota~5 |   0.8969   0.8909   0.9926   0.7519   1.0000
d_ice_nota~6 |   0.4169   0.4111   0.4793   0.3549   0.4861   1.0000
d_ice_nota~7 |   0.5202   0.5237   0.4639   0.3355   0.4601   0.9485   1.0000
d_ice_nota~8 |  -0.1488  -0.1551  -0.0612   0.2167  -0.0542  -0.7745  -0.8395   1.0000
d_ice_nota~9 |   0.6794   0.6749   0.7289   0.9766   0.7343   0.3726   0.3534   0.2117   1.0000


*/
local interacoes d_ice_nota_al1 d_ice_nota_al2 d_ice_nota_al3 d_ice_nota_al4 d_ice_nota_al5 d_ice_nota_al6 d_ice_nota_al7 d_ice_nota_al8 d_ice_nota_al9
foreach x in `interacoes'{
tab `x' if ensino_medio ==1 &ano==2004
}
{
/*
d_ice_nota_ |
        al1 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        424      100.00      100.00
------------+-----------------------------------
      Total |        424      100.00

d_ice_nota_ |
        al2 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        424      100.00      100.00
------------+-----------------------------------
      Total |        424      100.00

d_ice_nota_ |
        al3 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        424      100.00      100.00
------------+-----------------------------------
      Total |        424      100.00

d_ice_nota_ |
        al4 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        424      100.00      100.00
------------+-----------------------------------
      Total |        424      100.00

d_ice_nota_ |
        al5 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        424      100.00      100.00
------------+-----------------------------------
      Total |        424      100.00

d_ice_nota_ |
        al6 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        424      100.00      100.00
------------+-----------------------------------
      Total |        424      100.00

d_ice_nota_ |
        al7 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        424      100.00      100.00
------------+-----------------------------------
      Total |        424      100.00

d_ice_nota_ |
        al8 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        424      100.00      100.00
------------+-----------------------------------
      Total |        424      100.00

d_ice_nota_ |
        al9 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        424      100.00      100.00
------------+-----------------------------------
      Total |        424      100.00

*/

}
local interacoes d_ice_nota_al1 d_ice_nota_al2 d_ice_nota_al3 d_ice_nota_al4 d_ice_nota_al5 d_ice_nota_al6 d_ice_nota_al7 d_ice_nota_al8 d_ice_nota_al9

foreach x in `interacoes'{
tab `x' if ensino_medio ==1 &ano==2005
}
{
/*
d_ice_nota_ |
        al1 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        449      100.00      100.00
------------+-----------------------------------
      Total |        449      100.00

d_ice_nota_ |
        al2 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        449      100.00      100.00
------------+-----------------------------------
      Total |        449      100.00

d_ice_nota_ |
        al3 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        449      100.00      100.00
------------+-----------------------------------
      Total |        449      100.00

d_ice_nota_ |
        al4 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        449      100.00      100.00
------------+-----------------------------------
      Total |        449      100.00

d_ice_nota_ |
        al5 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        449      100.00      100.00
------------+-----------------------------------
      Total |        449      100.00

d_ice_nota_ |
        al6 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        449      100.00      100.00
------------+-----------------------------------
      Total |        449      100.00

d_ice_nota_ |
        al7 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        449      100.00      100.00
------------+-----------------------------------
      Total |        449      100.00

d_ice_nota_ |
        al8 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        449      100.00      100.00
------------+-----------------------------------
      Total |        449      100.00

d_ice_nota_ |
        al9 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        449      100.00      100.00
------------+-----------------------------------
      Total |        449      100.00

. 
*/
}
local interacoes d_ice_nota_al1 d_ice_nota_al2 d_ice_nota_al3 d_ice_nota_al4 d_ice_nota_al5 d_ice_nota_al6 d_ice_nota_al7 d_ice_nota_al8 d_ice_nota_al9

foreach x in `interacoes'{
tab `x' if ensino_medio ==1 &ano==2014
}

{
/*

d_ice_nota_ |
        al1 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        160       29.04       29.04
          1 |        391       70.96      100.00
------------+-----------------------------------
      Total |        551      100.00

d_ice_nota_ |
        al2 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        161       29.22       29.22
          1 |        390       70.78      100.00
------------+-----------------------------------
      Total |        551      100.00

d_ice_nota_ |
        al3 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        149       27.04       27.04
          1 |        402       72.96      100.00
------------+-----------------------------------
      Total |        551      100.00

d_ice_nota_ |
        al4 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        122       22.14       22.14
          1 |        429       77.86      100.00
------------+-----------------------------------
      Total |        551      100.00

d_ice_nota_ |
        al5 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        148       26.86       26.86
          1 |        403       73.14      100.00
------------+-----------------------------------
      Total |        551      100.00

d_ice_nota_ |
        al6 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        258       46.82       46.82
          1 |        293       53.18      100.00
------------+-----------------------------------
      Total |        551      100.00

d_ice_nota_ |
        al7 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        273       49.55       49.55
          1 |        278       50.45      100.00
------------+-----------------------------------
      Total |        551      100.00

d_ice_nota_ |
        al8 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        398       72.23       72.23
          1 |        153       27.77      100.00
------------+-----------------------------------
      Total |        551      100.00

d_ice_nota_ |
        al9 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        120       21.78       21.78
          1 |        431       78.22      100.00
------------+-----------------------------------
      Total |        551      100.00

*/
}

local interacoes d_ice_nota_al1 d_ice_nota_al2 d_ice_nota_al3 d_ice_nota_al4 d_ice_nota_al5 d_ice_nota_al6 d_ice_nota_al7 d_ice_nota_al8 d_ice_nota_al9

foreach x in `interacoes'{
tab `x' if ensino_medio ==1 &ano==2015
}
{
/*
d_ice_nota_ |
        al1 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |         89       16.18       16.18
          1 |        461       83.82      100.00
------------+-----------------------------------
      Total |        550      100.00

d_ice_nota_ |
        al2 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |         90       16.36       16.36
          1 |        460       83.64      100.00
------------+-----------------------------------
      Total |        550      100.00

d_ice_nota_ |
        al3 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |         79       14.36       14.36
          1 |        471       85.64      100.00
------------+-----------------------------------
      Total |        550      100.00

d_ice_nota_ |
        al4 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |         47        8.55        8.55
          1 |        503       91.45      100.00
------------+-----------------------------------
      Total |        550      100.00

d_ice_nota_ |
        al5 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |         78       14.18       14.18
          1 |        472       85.82      100.00
------------+-----------------------------------
      Total |        550      100.00

d_ice_nota_ |
        al6 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        215       39.09       39.09
          1 |        335       60.91      100.00
------------+-----------------------------------
      Total |        550      100.00

d_ice_nota_ |
        al7 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        229       41.64       41.64
          1 |        321       58.36      100.00
------------+-----------------------------------
      Total |        550      100.00

d_ice_nota_ |
        al8 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        366       66.55       66.55
          1 |        184       33.45      100.00
------------+-----------------------------------
      Total |        550      100.00

d_ice_nota_ |
        al9 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |         45        8.18        8.18
          1 |        505       91.82      100.00
------------+-----------------------------------
      Total |        550      100.00

. 
*/
}

/*
como podemos ver nessas matrizes de correlação
existe uma alta correlação entre as alavancas, e pouca variancia 
vamos tentar juntar as dummies em blocos
*/
/*
alavanca 1 - teve bom engajamento do governador
alavanca 2 - teve bom engajamento do secretário de educação
alavanca 3 - tinha time da SEDUC dedicado para a implantação do programa
alavanca 4 - teve implantação dos marcos legais na forma da Lei?
alavanca 5 - teve Implantação de todos os marcos legais previstos no cronograma estipulado?
alavanca 6 - teve Implantação do processo de seleção e remoção de diretores?
alavanca 7 - teve Implantação do processo de seleção e remoção de professores?
alavanca 8 - teve Implantação do projeto de vida na Matriz Curricular?
alavanca 9 - Outros

*/
/*
teve bom engajamento do gov E 
teve bom engajamento do sec educ E
tinha time da SEDUC dedicado para a implantação do programa
*/
gen d_ice_nota_politico_todas = 0
replace d_ice_nota_politico_todas = 1 if d_ice_nota_al1 ==1 ///
	& d_ice_nota_al2==1  ///
	& d_ice_nota_al3 == 1 
	
gen d_ice_fluxo_politico_todas = 0
replace d_ice_fluxo_politico_todas = 1 if d_ice_fluxo_al1 ==1 ///
	& d_ice_fluxo_al2==1  ///
	& d_ice_fluxo_al3 == 1 
/*
teve bom engajamento do gov OU 
teve bom engajamento do sec educ OU
tinha time da SEDUC dedicado para a implantação do programa
*/
gen d_ice_nota_politico_algum = 0
replace d_ice_nota_politico_algum = 1 if d_ice_nota_al1 ==1 ///
	| d_ice_nota_al2==1  ///
	| d_ice_nota_al3 == 1 
	
gen d_ice_fluxo_politico_algum = 0
replace d_ice_fluxo_politico_algum = 1 if d_ice_fluxo_al1 ==1 ///
	| d_ice_fluxo_al2==1  ///
	| d_ice_fluxo_al3 == 1 	
/*
teve implantação dos marcos legais na forma da lei
E
teve implantação de todos os marcos legais previstos no cronograma estipulado?
*/	
gen d_ice_nota_marcos_todas = 0
replace d_ice_nota_marcos_todas=1 if d_ice_nota_al4 ==1 & d_ice_nota_al5==1

gen d_ice_fluxo_marcos_todas = 0
replace d_ice_fluxo_marcos_todas=1 if d_ice_fluxo_al4 ==1 & d_ice_fluxo_al5==1
		
/*
teve implantação dos marcos legais na forma da lei
OU
teve implantação de todos os marcos legais previstos no cronograma estipulado?
*/

gen d_ice_nota_marcos_algum = 0
replace d_ice_nota_marcos_todas=1 if d_ice_nota_al4 ==1 | d_ice_nota_al5==1

gen d_ice_fluxo_marcos_algum = 0
replace d_ice_fluxo_marcos_todas=1 if d_ice_fluxo_al4 ==1 | d_ice_fluxo_al5==1


/*teve Implantação do processo de seleção e remoção de diretores?
E
teve Implantação do processo de seleção e remoção de professores?*/
gen d_ice_nota_selecao_todas = 0
replace d_ice_nota_selecao_todas =1 if d_ice_nota_al6 == 1 & d_ice_nota_al7 ==1

gen d_ice_fluxo_selecao_todas = 0
replace d_ice_fluxo_selecao_todas =1 if d_ice_fluxo_al6 == 1 & d_ice_fluxo_al7 ==1


/*teve Implantação do processo de seleção e remoção de diretores?
OU
teve Implantação do processo de seleção e remoção de professores?*/

gen d_ice_nota_selecao_algum = 0
replace d_ice_nota_selecao_algum = 1 if d_ice_nota_al6 ==1 | d_ice_nota_al7 ==1
gen d_ice_fluxo_selecao_algum = 0
replace d_ice_fluxo_selecao_algum = 1 if d_ice_fluxo_al6 ==1 | d_ice_fluxo_al7 ==1
egen double_cluster=group(codigo_uf ano)

global alavancas_fluxo d_ice_fluxo_al1 ///
	d_ice_fluxo_al2 d_ice_fluxo_al3		///
	d_ice_fluxo_al4 d_ice_fluxo_al5 	///
	d_ice_fluxo_al6 d_ice_fluxo_al7 	///
	d_ice_fluxo_al8 
global alavancas_fluxo_todas 		///
	d_ice_fluxo_al1 d_ice_fluxo_al2	///
	d_ice_fluxo_al3 d_ice_fluxo_al4 ///
	d_ice_fluxo_al5 d_ice_fluxo_al6 ///
	d_ice_fluxo_al7 d_ice_fluxo_al8 ///
	d_ice_fluxo_al9
global alavancas_nota d_ice_nota_al1	///
	d_ice_nota_al2 d_ice_nota_al3 		///
	d_ice_nota_al4 d_ice_nota_al5 		///
	d_ice_nota_al6 d_ice_nota_al7 		///
	d_ice_nota_al8 
global alavancas_nota_todas				///
	d_ice_nota_al1 d_ice_nota_al2 		///
	d_ice_nota_al3 d_ice_nota_al4 		///
	d_ice_nota_al5 d_ice_nota_al6 		///
	d_ice_nota_al7 d_ice_nota_al8 		///
	d_ice_nota_al9

global al_notas_agregadas_todas ///
	d_ice_nota_politico_todas ///
	d_ice_nota_marcos_todas ///
	d_ice_nota_selecao_todas ///
	d_ice_nota_al8 ///
	 
global al_notas_agregadas_algum ///
	d_ice_nota_politico_algum	///
	d_ice_nota_marcos_algum		///
	d_ice_nota_selecao_algum 	///
	d_ice_nota_al8
	

global al_fluxo_agregadas_todas ///
	d_ice_fluxo_politico_todas ///
	d_ice_fluxo_marcos_todas ///
	d_ice_fluxo_selecao_todas ///
	d_ice_fluxo_al8 ///
	 
global al_fluxo_agregadas_algum ///
	d_ice_fluxo_politico_algum	///
	d_ice_fluxo_marcos_algum		///
	d_ice_fluxo_selecao_algum 	///
	d_ice_fluxo_al8	
/*regressões com dummies de alavancas ocm interação*/
	xtreg enem_nota_objetivab_std d_ice_nota $alavancas_nota d_ano* $controles $estado if (d_dep4 == 0 | ice == 1), fe 
	outreg2 using "$output/em_diff_in_diff_al_notas_v2.xls", excel replace label ctitle(enem objetiva,  fe)

	*cluster codigo_uf
	xtreg enem_nota_objetivab_std d_ice_nota d_ano* $alavancas_nota $controles $estado if (d_dep4 == 0 | ice == 1), fe cluster(codigo_uf)
	outreg2 using "$output/em_diff_in_diff_al_notas_v2.xls", excel append label ctitle(enem objetiva,  cluster estado)

	*cluster cod_meso
	xtreg enem_nota_objetivab_std d_ice_nota d_ano* $alavancas_nota $controles $estado if (d_dep4 == 0 | ice == 1), fe cluster(cod_meso)
	outreg2 using "$output/em_diff_in_diff_al_notas_v2.xls", excel append label ctitle(enem objetiva,  cluster meso)


	*cluster uf ano
	xtreg enem_nota_objetivab_std d_ice_nota d_ano* $alavancas_nota $controles $estado if (d_dep4 == 0 | ice == 1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/em_diff_in_diff_al_notas_v2.xls", excel append label ctitle(enem objetiva,  cluster uf ano)
	

foreach x in "enem_nota_redacao_std"  {	

	*fe
	xtreg `x' d_ice_nota $alavancas_nota d_ano* $controles $estado ///
		if (d_dep4 == 0 | ice == 1), fe 
	outreg2 using "$output/em_diff_in_diff_al_notas_v2.xls", excel append label ctitle(`x',  fe)
	
	*cluster codigo_uf
	xtreg `x' d_ice_nota $alavancas_nota  d_ano*  $controles $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(codigo_uf)
	outreg2 using "$output/em_diff_in_diff_al_notas_v2.xls", excel append label ctitle(`x',  cluster estado)

	*cluster cod_meso
	xtreg `x' d_ice_nota $alavancas_nota d_ano*  $controles $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(cod_meso)	
	outreg2 using "$output/em_diff_in_diff_al_notas_v2.xls", excel append label ctitle(`x',  cluster meso)

	*cluster uf ano
	xtreg `x' d_ice_nota $alavancas_nota d_ano* $controles $estado ///
		if (d_dep4 == 0 | ice == 1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/em_diff_in_diff_al_notas_v2.xls", excel append label ctitle(`x',  cluster uf ano)


}


foreach x in "apr_em_std" "rep_em_std" "aba_em_std" "dist_em_std"  {	

	*fe
	xtreg `x' d_ice_fluxo $alavancas_fluxo d_ano* $controles $estado ///
	if (d_dep4 == 0 | ice == 1), fe 
	outreg2 using "$output/em_diff_in_diff_al_fluxo_v2.xls", excel append label ctitle(`x',  fe)
	
	*cluster codigo_uf
	xtreg `x' d_ice_fluxo $alavancas_fluxo d_ano*  $controles $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(codigo_uf)
	outreg2 using "$output/em_diff_in_diff_al_fluxo_v2.xls", excel append label ctitle(`x',  cluster estado)

	*cluster cod_meso
	xtreg `x' d_ice_fluxo $alavancas_fluxo d_ano*  $controles $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(cod_meso)	
	outreg2 using "$output/em_diff_in_diff_al_fluxo_v2.xls", excel append label ctitle(`x',  cluster meso)

	*cluster uf ano
	xtreg `x' d_ice_fluxo $alavancas_fluxo d_ano* $controles $estado ///
	if (d_dep4 == 0 | ice == 1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/em_diff_in_diff_al_fluxo_v2.xls", excel append label ctitle(`x',  cluster uf ano)

	

	
	
	}

/*regressões com dummies agregadas*/


*enem_nota_objetivo_std
	*notas alavancas agregadas todas
	*fe
	xtreg enem_nota_objetivab_std d_ice_nota $al_notas_agregadas_todas d_ano* $controles $estado if (d_dep4 == 0 | ice == 1), fe 
	outreg2 using "$output/em_diff_in_diff_al_notas_v1.xls", excel replace label ctitle(enem objetiva,  fe)

	*cluster codigo_uf
	xtreg enem_nota_objetivab_std d_ice_nota d_ano* $al_notas_agregadas_todas $controles $estado if (d_dep4 == 0 | ice == 1), fe cluster(codigo_uf)
	outreg2 using "$output/em_diff_in_diff_al_notas_v1.xls", excel append label ctitle(enem objetiva,  cluster estado)

	*cluster cod_meso
	xtreg enem_nota_objetivab_std d_ice_nota d_ano* $al_notas_agregadas_todas $controles $estado if (d_dep4 == 0 | ice == 1), fe cluster(cod_meso)
	outreg2 using "$output/em_diff_in_diff_al_notas_v1.xls", excel append label ctitle(enem objetiva,  cluster meso)


	*cluster uf ano
	xtreg enem_nota_objetivab_std d_ice_nota d_ano* $al_notas_agregadas_todas $controles $estado if (d_dep4 == 0 | ice == 1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/em_diff_in_diff_al_notas_v1.xls", excel append label ctitle(enem objetiva,  cluster uf ano)
	
	
	*notas alavancas agregadas alguns
	*fe
	xtreg enem_nota_objetivab_std d_ice_nota $al_notas_agregadas_algum d_ano* $controles $estado if (d_dep4 == 0 | ice == 1), fe 
	outreg2 using "$output/em_diff_in_diff_al_notas_v1.xls", excel append label ctitle(enem objetiva,  fe)

	*cluster codigo_uf
	xtreg enem_nota_objetivab_std d_ice_nota d_ano* $al_notas_agregadas_algum $controles $estado if (d_dep4 == 0 | ice == 1), fe cluster(codigo_uf)
	outreg2 using "$output/em_diff_in_diff_al_notas_v1.xls", excel append label ctitle(enem objetiva,  cluster estado)

	*cluster cod_meso
	xtreg enem_nota_objetivab_std d_ice_nota d_ano* $al_notas_agregadas_algum $controles $estado if (d_dep4 == 0 | ice == 1), fe cluster(cod_meso)
	outreg2 using "$output/em_diff_in_diff_al_notas_v1.xls", excel append label ctitle(enem objetiva,  cluster meso)


	*cluster uf ano
	xtreg enem_nota_objetivab_std d_ice_nota d_ano* $al_notas_agregadas_algum $controles $estado if (d_dep4 == 0 | ice == 1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/em_diff_in_diff_al_notas_v1.xls", excel append label ctitle(enem objetiva,  cluster uf ano)


foreach x in "enem_nota_redacao_std"  {	

	*fe
	xtreg `x' d_ice_nota $al_notas_agregadas_todas d_ano* $controles $estado ///
		if (d_dep4 == 0 | ice == 1), fe 
	outreg2 using "$output/em_diff_in_diff_al_notas_v1.xls", excel append label ctitle(`x',  fe)
	
	*cluster codigo_uf
	xtreg `x' d_ice_nota $al_notas_agregadas_todas  d_ano*  $controles $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(codigo_uf)
	outreg2 using "$output/em_diff_in_diff_al_notas_v1.xls", excel append label ctitle(`x',  cluster estado)

	*cluster cod_meso
	xtreg `x' d_ice_nota $al_notas_agregadas_todas d_ano*  $controles $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(cod_meso)	
	outreg2 using "$output/em_diff_in_diff_al_notas_v1.xls", excel append label ctitle(`x',  cluster meso)

	*cluster uf ano
	xtreg `x' d_ice_nota $al_notas_agregadas_todas d_ano* $controles $estado ///
		if (d_dep4 == 0 | ice == 1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/em_diff_in_diff_al_notas_v1.xls", excel append label ctitle(`x',  cluster uf ano)


	*fe
	xtreg `x' d_ice_nota $al_notas_agregadas_algum d_ano* $controles $estado ///
		if (d_dep4 == 0 | ice == 1), fe 
	outreg2 using "$output/em_diff_in_diff_al_notas_v1.xls", excel append label ctitle(`x',  fe)
	
	*cluster codigo_uf
	xtreg `x' d_ice_nota $al_notas_agregadas_algum  d_ano*  $controles $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(codigo_uf)
	outreg2 using "$output/em_diff_in_diff_al_notas_v1.xls", excel append label ctitle(`x',  cluster estado)

	*cluster cod_meso
	xtreg `x' d_ice_nota $al_notas_agregadas_algum d_ano*  $controles $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(cod_meso)	
	outreg2 using "$output/em_diff_in_diff_al_notas_v1.xls", excel append label ctitle(`x',  cluster meso)

	*cluster uf ano
	xtreg `x' d_ice_nota $al_notas_agregadas_algum d_ano* $controles $estado ///
		if (d_dep4 == 0 | ice == 1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/em_diff_in_diff_al_notas_v1.xls", excel append label ctitle(`x',  cluster uf ano)

		
	
	
}












foreach x in "apr_em_std" "rep_em_std" "aba_em_std" "dist_em_std"  {	

	*fe
	xtreg `x' d_ice_fluxo $al_fluxo_agregadas_todas d_ano* $controles $estado ///
	if (d_dep4 == 0 | ice == 1), fe 
	outreg2 using "$output/em_diff_in_diff_al_fluxo_v1.xls", excel append label ctitle(`x',  fe)
	
	*cluster codigo_uf
	xtreg `x' d_ice_fluxo $al_fluxo_agregadas_todas d_ano*  $controles $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(codigo_uf)
	outreg2 using "$output/em_diff_in_diff_al_fluxo_v1.xls", excel append label ctitle(`x',  cluster estado)

	*cluster cod_meso
	xtreg `x' d_ice_fluxo $al_fluxo_agregadas_todas d_ano*  $controles $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(cod_meso)	
	outreg2 using "$output/em_diff_in_diff_al_fluxo_v1.xls", excel append label ctitle(`x',  cluster meso)

	*cluster uf ano
	xtreg `x' d_ice_fluxo $al_fluxo_agregadas_todas d_ano* $controles $estado ///
	if (d_dep4 == 0 | ice == 1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/em_diff_in_diff_al_fluxo_v1.xls", excel append label ctitle(`x',  cluster uf ano)

	
	*fe
	xtreg `x' d_ice_fluxo $al_fluxo_agregadas_algum d_ano* $controles $estado ///
	if (d_dep4 == 0 | ice == 1), fe 
	outreg2 using "$output/em_diff_in_diff_al_fluxo_v1.xls", excel append label ctitle(`x',  fe)
	
	*cluster codigo_uf
	xtreg `x' d_ice_fluxo $al_fluxo_agregadas_algum d_ano*  $controles $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(codigo_uf)
	outreg2 using "$output/em_diff_in_diff_al_fluxo_v1.xls", excel append label ctitle(`x',  cluster estado)

	*cluster cod_meso
	xtreg `x' d_ice_fluxo $al_fluxo_agregadas_algum d_ano*  $controles $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(cod_meso)	
	outreg2 using "$output/em_diff_in_diff_al_fluxo_v1.xls", excel append label ctitle(`x',  cluster meso)

	*cluster uf ano
	xtreg `x' d_ice_fluxo $al_fluxo_agregadas_algum d_ano* $controles $estado ///
	if (d_dep4 == 0 | ice == 1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/em_diff_in_diff_al_fluxo_v1.xls", excel append label ctitle(`x',  cluster uf ano)

	
	
	}
/*existe um problema claro de multicolinearidade
ainda, os valores obtidos nas estimações anterioes 
claramente apresentam algum problema
assim, vamos tentar uma metodologia alternativa:
principal component analysis
já calculamos os fatore relevantes anteriormente. 
vamos gerar as interações
*/
/*
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
*/
global componentes_interacao_nota d_ice_nota_comp1 d_ice_nota_comp2 d_ice_nota_comp3 d_ice_nota_comp4
global componentes_interecao_fluxo d_ice_fluxo_comp1 d_ice_fluxo_comp2 d_ice_fluxo_comp3 d_ice_fluxo_comp4


/*regressões com componentes das alavancas*/
	xtreg enem_nota_objetivab_std d_ice_nota $componentes_interacao_nota d_ano* $controles $estado if (d_dep4 == 0 | ice == 1), fe 
	outreg2 using "$output/em_diff_in_diff_comp_al_notas_v1.xls", excel replace label ctitle(enem objetiva,  fe)

	*cluster codigo_uf
	xtreg enem_nota_objetivab_std d_ice_nota d_ano* $componentes_interacao_nota $controles $estado if (d_dep4 == 0 | ice == 1), fe cluster(codigo_uf)
	outreg2 using "$output/em_diff_in_diff_comp_al_notas_v1.xls", excel append label ctitle(enem objetiva,  cluster estado)

	*cluster cod_meso
	xtreg enem_nota_objetivab_std d_ice_nota d_ano* $componentes_interacao_nota $controles $estado if (d_dep4 == 0 | ice == 1), fe cluster(cod_meso)
	outreg2 using "$output/em_diff_in_diff_comp_al_notas_v1.xls", excel append label ctitle(enem objetiva,  cluster meso)


	*cluster uf ano
	xtreg enem_nota_objetivab_std d_ice_nota d_ano* $componentes_interacao_nota $controles $estado if (d_dep4 == 0 | ice == 1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/em_diff_in_diff_comp_al_notas_v1.xls", excel append label ctitle(enem objetiva,  cluster uf ano)
	

foreach x in "enem_nota_redacao_std"  {	

	*fe
	xtreg `x' d_ice_nota $componentes_interacao_nota d_ano* $controles $estado ///
		if (d_dep4 == 0 | ice == 1), fe 
	outreg2 using "$output/em_diff_in_diff_comp_al_notas_v1.xls", excel append label ctitle(`x',  fe)
	
	*cluster codigo_uf
	xtreg `x' d_ice_nota $componentes_interacao_nota  d_ano*  $controles $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(codigo_uf)
	outreg2 using "$output/em_diff_in_diff_comp_al_notas_v1.xls", excel append label ctitle(`x',  cluster estado)

	*cluster cod_meso
	xtreg `x' d_ice_nota $componentes_interacao_nota d_ano*  $controles $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(cod_meso)	
	outreg2 using "$output/em_diff_in_diff_comp_al_notas_v1.xls", excel append label ctitle(`x',  cluster meso)

	*cluster uf ano
	xtreg `x' d_ice_nota $componentes_interacao_nota d_ano* $controles $estado ///
		if (d_dep4 == 0 | ice == 1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/em_diff_in_diff_comp_al_notas_v1.xls", excel append label ctitle(`x',  cluster uf ano)


}


foreach x in "apr_em_std" "rep_em_std" "aba_em_std" "dist_em_std"  {	

	*fe
	xtreg `x' d_ice_fluxo $componentes_interecao_fluxo d_ano* $controles $estado ///
	if (d_dep4 == 0 | ice == 1), fe 
	outreg2 using "$output/em_diff_in_diff_comp_al_fluxo_v1.xls", excel append label ctitle(`x',  fe)
	
	*cluster codigo_uf
	xtreg `x' d_ice_fluxo $componentes_interecao_fluxo d_ano*  $controles $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(codigo_uf)
	outreg2 using "$output/em_diff_in_diff_comp_al_fluxo_v1.xls", excel append label ctitle(`x',  cluster estado)

	*cluster cod_meso
	xtreg `x' d_ice_fluxo $componentes_interecao_fluxo d_ano*  $controles $estado ///
		if (d_dep4 == 0 | ice == 1), fe cluster(cod_meso)	
	outreg2 using "$output/em_diff_in_diff_comp_al_fluxo_v1.xls", excel append label ctitle(`x',  cluster meso)

	*cluster uf ano
	xtreg `x' d_ice_fluxo $componentes_interecao_fluxo d_ano* $controles $estado ///
	if (d_dep4 == 0 | ice == 1), fe vce(cluster double_cluster) nonest
	outreg2 using "$output/em_diff_in_diff_comp_al_fluxo_v1.xls", excel append label ctitle(`x',  cluster uf ano)

	

	
	
	}


