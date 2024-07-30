************************************************************************************************
************************************* RESULTADOS EM ********************************************
************************************************************************************************
*cap cd "\\fs-eesp-01\EESP\Usuarios\_CHV\ICE\Dados ICE\"
cap cd "C:\Users\vladimir.ponczek\Documents\ICE\Dados ICE"
global output "resultados_2014_2/"


************************************************************************************************
************************************* POR ESTADO (EM) ******************************************
************************************************************************************************

use ice_clean.dta, clear

* Painel
iis codigo_escola
tis ano

*Ficar SP
keep if codigo_uf==35

* Gerar pscores

set matsize 10000


forvalues x=2003/2015{
replace d_ice=0 if ano_ice==`x'&ano==`x'
replace d_ice=1 if ano_ice==`x'&ano==`x'+2
}

pscore ice n_alunos_em taxa_participacao_enem   if ano==2011&codigo_uf==35&dep!=4, pscore(pscores_sp)




gen pscore_total=.
replace pscore_total=1 if ice==1

replace pscore_total=1/(1-pscores_sp) if codigo_uf==35&dep!=4&ice==0



bysort codigo_escola: egen pscore_total_aux=max(pscore_total)
replace pscore_total=pscore_total_aux


foreach x in "al_engaj_gov" "al_engaj_sec" "al_time_seduc" "al_marcos_lei" "al_todos_marcos" "al_sel_dir" "al_sel_prof" "al_proj_vida" {
replace `x'=0 if `x'==.
}

gen al_outros=0
replace al_outros=1 if (al_engaj_gov==1|al_time_seduc==1|al_marcos_lei==1|al_proj_vida==1)
gen d_ice_al1=d_ice*al_engaj_gov
gen d_ice_al2=d_ice*al_engaj_sec
gen d_ice_al3=d_ice*al_time_seduc
gen d_ice_al4=d_ice*al_marcos_lei
gen d_ice_al5=d_ice*al_todos_marcos
gen d_ice_al6=d_ice*al_sel_dir
gen d_ice_al7=d_ice*al_sel_prof
gen d_ice_al8=d_ice*al_proj_vida
gen d_ice_al9=d_ice*al_outros



*"enem_nota_matematica" "enem_nota_ciencias" "enem_nota_humanas" "enem_nota_linguagens" "enem_nota_redacao" "apr_em"

foreach x in   "enem_nota_objetivab"  "rep_em"  "aba_em" "dist_em"{
foreach xx in 35 {

* Geral
xtreg `x'`xx'_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria nalunos nbrancos nmulheres/*
**/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4  & codigo_uf==`xx', fe 
outreg2 using "${output}ICE_resultados_ps_em_`xx'_new.xls", excel append label ctitle(`x') 

* Pernambuco - Integral
*xtreg `x'`xx'_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria nalunos nbrancos nmulheres/*
**/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4  & codigo_uf==26 & (integral==1|ice==0), fe 
outreg2 using "${output}ICE_resultados_ps_em_`xx'_newint.xls", excel append label ctitle(`x', integral) 

}
}


foreach x in   "enem_nota_objetivab"  "rep_em"  "aba_em" "dist_em"{

*Interegral vs Semi PE
 xtreg `x'26_std d_ice d_ice_inte d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep ///
n_mulheres_ef_em_ep n_brancos_ef_em_ep rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca  ///
internet [pw=pscore_total] if dep!=4&uf=="PE"&(ano_ice==2008|ano_ice==2009|ano_ice==2010) , fe
*outreg2 using "${output}ICE_resultados_ps_em_PE_semi_int.xls", excel append label ctitle(`x') 

*Interegral vs Semi CE
 xtreg `x'26_std d_ice d_ice_inte d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep ///
n_mulheres_ef_em_ep n_brancos_ef_em_ep rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca  ///
internet [pw=pscore_total] if dep!=4&uf=="PE" , fe
*outreg2 using "${output}ICE_resultados_ps_em_CE_semi_int.xls", excel append label ctitle(`x') 

}


foreach x in   "enem_nota_objetivab"  "rep_em"  "aba_em" "dist_em"{

*Interegral vs Semi PE
 xtreg `x'26_std d_ice d_ice_inte d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep ///
n_mulheres_ef_em_ep n_brancos_ef_em_ep rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca  ///
internet [pw=pscore_total] if dep!=4&uf=="PE"&(ano_ice==2008|ano_ice==2009|ano_ice==2010) , fe
outreg2 using "${output}ICE_resultados_ps_em_PE_semi_int.xls", excel append label ctitle(`x') 

*Interegral vs Semi CE
 xtreg `x'23_std d_ice d_ice_inte d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep ///
n_mulheres_ef_em_ep n_brancos_ef_em_ep rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca  ///
internet [pw=pscore_total] if dep!=4&uf=="PE"&(ano_ice==2008|ano_ice==2009|ano_ice==2010) , fe
outreg2 using "${output}ICE_resultados_ps_em_CE_semi_int.xls", excel append label ctitle(`x') 

}

foreach x in "enem_nota_matematica" "enem_nota_ciencias" "enem_nota_humanas" "enem_nota_linguagens" "media_lp_prova_brasil_9" "media_mt_prova_brasil_9" "media_pb_9" "apr_ef" "apr_em" "rep_ef" "rep_em" "aba_ef" "aba_em" "dist_ef" "dist_em" {
capture egen `x'23_26_std=std(`x') if codigo_uf==23|codigo_uf==26
capture egen `x'52_35_33_std=std(`x') if codigo_uf==52|codigo_uf==35|codigo_uf==33
}

 
 foreach x in   "enem_nota_objetivab"  "rep_em"  "aba_em" "dist_em"{

*Interegral vs Semi PE e CE
 xtreg `x'23_26_std d_ice d_ice_inte d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep ///
n_mulheres_ef_em_ep n_brancos_ef_em_ep rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca  ///
internet [pw=pscore_total] if dep!=4&uf=="PE"&(ano_ice==2008|ano_ice==2009|ano_ice==2010) , fe
outreg2 using "${output}ICE_resultados_ps_em_PE_CE_semi_int.xls", excel append label ctitle(`x') 

*Interegral vs Semi outras
 xtreg `x'52_35_33_std_std d_ice d_ice_inte d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep ///
n_mulheres_ef_em_ep n_brancos_ef_em_ep rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca  ///
internet [pw=pscore_total] if dep!=4&(uf=="SP"|uf=="RJ"|uf=="GO")&(ano_ice==2008|ano_ice==2009|ano_ice==2010) , fe
outreg2 using "${output}ICE_resultados_ps_em_outras_semi_int.xls", excel append label ctitle(`x') 

}

* Resultados cumulativos


gen tempo=.
replace tempo=1 if ano==ano_ice
replace tempo=0 if ano==ano_ice-1
replace tempo=2 if ano==ano_ice+1
replace tempo=3 if ano==ano_ice+2 
replace tempo=4 if ano==ano_ice+3
replace tempo=5 if ano==ano_ice+4
replace tempo=6 if ano==ano_ice+5
replace tempo=7 if ano==ano_ice+6 
replace tempo=8 if ano==ano_ice+7
replace tempo=9 if ano==ano_ice+8
replace tempo=10 if ano==ano_ice+9
replace tempo=11 if ano==ano_ice+10

iis codigo_escol
tis tempo

tab tempo, gen(d_tempo)

gen d_ice1=d_ice*d_tempo2
gen d_ice2=d_ice*d_tempo3
gen d_ice3=d_ice*d_tempo4
gen d_ice4=d_ice*d_tempo5
gen d_ice5=d_ice*d_tempo6
gen d_ice6=d_ice*d_tempo7
gen d_ice7=d_ice*d_tempo8
gen d_ice8=d_ice*d_tempo9
gen d_ice9=d_ice*d_tempo10
gen d_ice10=d_ice*d_tempo11


*SP
foreach x in   "enem_nota_objetivab"  "rep_em"  "aba_em" "dist_em"{

* Geral
xtreg `x'35_std  d_ice1 d_ice2 d_ice3 d_ice4 d_ice5 d_ice6 d_ice7 d_ice8 d_ice9 d_ice10 d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if uf=="SP"&dep!=4&(tempo==0|tempo==1|tempo==2| tempo==3| tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9 | tempo==10)&(integral==1|ice==0) , fe 
outreg2 using "${output}ICE_resultados_cum_em_new.xls", excel append label ctitle(`x', 9 anos) 


}

************************************************************************************************
************************************* RESULTADOS EF ********************************************
************************************************************************************************
use ice_clean.dta, clear

keep if n_alunos_ef>0
keep if codigo_uf==33|codigo_uf==35

* Painel
iis codigo_escola
tis ano

replace ice=0 if ensino_fundamental==0

* Gerar pscores

set matsize 10000


*pscore ice n_alunos_em taxa_participacao_enem  if ano==2003&codigo_uf==26&dep!=4, pscore(pscores_pe)

*pscore ice n_alunos_em_ep taxa_participacao_enem  if ano==2007&codigo_uf==23&dep!=4, pscore(pscores_ce)

pscore ice n_alunos_ef taxa_participacao_pb  if ano==2009&codigo_uf==33&dep!=4, pscore(pscores_rj)

pscore ice n_alunos_ef taxa_participacao_pb   if ano==2011&codigo_uf==35&dep!=4, pscore(pscores_sp)

*pscore ice n_alunos_em taxa_participacao_enem if ano==2012&codigo_uf==52&dep!=4, pscore(pscores_go)



gen pscore_total=.
replace pscore_total=1 if ice==1

*replace pscore_total=1/(1-pscores_pe) if codigo_uf==26&dep!=4&ice==0

*replace pscore_total=1/(1-pscores_ce) if codigo_uf==23&dep!=4&ice==0

replace pscore_total=1/(1-pscores_rj) if codigo_uf==33&dep!=4&ice==0

replace pscore_total=1/(1-pscores_sp) if codigo_uf==35&dep!=4&ice==0

*replace pscore_total=1/(1-pscores_go) if codigo_uf==52&dep!=4&ice==0

bysort codigo_escola: egen pscore_total_aux=max(pscore_total)
replace pscore_total=pscore_total_aux

* Interacoes de turno e alavancas

gen ice_inte=0
replace ice_inte=1 if ice_jornada=="INTEGRAL" 
replace ice_inte=1 if ice_jornada=="Integral" 

gen ice_semi_inte=0
replace ice_semi_inte=1 if ice_jornada=="Semi-integral"
replace ice_semi_inte=1 if ice_jornada=="SEMI-INTEGRAL"

gen d_ice_inte=d_ice*ice_inte
gen d_ice_semi_inte=d_ice*ice_semi_inte

foreach x in "al_engaj_gov" "al_engaj_sec" "al_time_seduc" "al_marcos_lei" "al_todos_marcos" "al_sel_dir" "al_sel_prof" "al_proj_vida" {
replace `x'=0 if `x'==.
}


gen al_outros=0
replace al_outros=1 if (al_engaj_gov==1|al_time_seduc==1|al_marcos_lei==1|al_proj_vida==1)
gen d_ice_al1=d_ice*al_engaj_gov
gen d_ice_al2=d_ice*al_engaj_sec
gen d_ice_al3=d_ice*al_time_seduc
gen d_ice_al4=d_ice*al_marcos_lei
gen d_ice_al5=d_ice*al_todos_marcos
gen d_ice_al6=d_ice*al_sel_dir
gen d_ice_al7=d_ice*al_sel_prof
gen d_ice_al8=d_ice*al_proj_vida
gen d_ice_al9=d_ice*al_outros

* Resultados

foreach x in "media_lp_prova_brasil_9_std" "media_mt_prova_brasil_9_std" "media_pb_9_std" "apr_ef_std" "rep_ef_std" "aba_ef_std" "dist_ef_std" {


*Geral

xtreg `x' d_ice d_ano* pb_esc_sup_mae pb_esc_sup_pai n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4 , fe cluster(codigo_uf)
outreg2 using "${output}ICE_resultados_ps_ef.xls", excel append label ctitle(`x', controle pub) 

*Por nnível de apoio

xtreg `x' d_ice d_ano* pb_esc_sup_mae pb_esc_sup_pai n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(d_rigor1==1|ice==0), fe cluster(codigo_uf)
outreg2 using "${output}ICE_resultados_ps_ef.xls", excel append label ctitle(`x', apoio forte)

xtreg `x' d_ice d_ano* pb_esc_sup_mae pb_esc_sup_pai n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(d_rigor3==1|ice==0), fe cluster(codigo_uf)
outreg2 using "${output}ICE_resultados_ps_ef.xls", excel append label ctitle(`x', apoio medio)

xtreg `x' d_ice d_ano* pb_esc_sup_mae pb_esc_sup_pai n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(d_rigor2==1|ice==0), fe cluster(codigo_uf)
outreg2 using "${output}ICE_resultados_ps_ef.xls", excel append label ctitle(`x', apoio fraco)

xtreg `x' d_ice d_ano* pb_esc_sup_mae pb_esc_sup_pai n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(d_rigor4==1|ice==0), fe cluster(codigo_uf)
outreg2 using "${output}ICE_resultados_ps_ef.xls", excel append label ctitle(`x', sem apoio)

xtreg `x' d_ice d_ano* pb_esc_sup_mae pb_esc_sup_pai n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(d_rigor4==0|ice==0) , fe cluster(codigo_uf)
outreg2 using "${output}ICE_resultados_ps_ef.xls", excel append label ctitle(`x', com algum apoio)

}


************************************************************************************************
************************************* POR ESTADO EF ********************************************
************************************************************************************************

use ice_clean.dta, clear

* Painel
iis codigo_escola
tis ano

keep if codigo_uf==33|codigo_uf==35|codigo_uf==23|codigo_uf==26

drop if ice_seg=="EM"
replace ice=0 if ensino_fundamental==0

pscore ice n_alunos_ef taxa_participacao_pb if ano==2009&codigo_uf==33&dep!=4, pscore(pscores_rj)
pscore ice n_alunos_ef taxa_participacao_pb if ano==2011&codigo_uf==35&dep!=4, pscore(pscores_sp)
*pscore ice n_alunos_ef taxa_participacao_pb if ano==2013&codigo_uf==26&dep!=4, pscore(pscores_pe)
*pscore ice n_alunos_ef taxa_participacao_pb if ano==2013&codigo_uf==23&dep!=4, pscore(pscores_ce)

gen pscore_total=.
replace pscore_total=1 if ice==1

replace pscore_total=1/(1-pscores_rj) if codigo_uf==33&dep!=4&ice==0
replace pscore_total=1/(1-pscores_sp) if codigo_uf==35&dep!=4&ice==0
*replace pscore_total=1/(1-pscores_pe) if codigo_uf==26&dep!=4&ice==0
*replace pscore_total=1/(1-pscores_ce) if codigo_uf==23&dep!=4&ice==0

bysort codigo_escola: egen pscore_total_aux=max(pscore_total)
replace pscore_total=pscore_total_aux

keep if ano==2009|ano==2011|ano==2013

* Interacoes de turno e alavancas

gen ice_inte=0
replace ice_inte=1 if ice_jornada=="INTEGRAL" 
replace ice_inte=1 if ice_jornada=="Integral" 

gen ice_semi_inte=0
replace ice_semi_inte=1 if ice_jornada=="Semi-integral"
replace ice_semi_inte=1 if ice_jornada=="SEMI-INTEGRAL"

gen d_ice_inte=d_ice*ice_inte
gen d_ice_semi_inte=d_ice*ice_semi_inte

foreach x in "al_engaj_gov" "al_engaj_sec" "al_time_seduc" "al_marcos_lei" "al_todos_marcos" "al_sel_dir" "al_sel_prof" "al_proj_vida" {
replace `x'=0 if `x'==.
}


gen al_outros=0
replace al_outros=1 if (al_engaj_gov==1|al_time_seduc==1|al_marcos_lei==1|al_proj_vida==1)
gen d_ice_al1=d_ice*al_engaj_gov
gen d_ice_al2=d_ice*al_engaj_sec
gen d_ice_al3=d_ice*al_time_seduc
gen d_ice_al4=d_ice*al_marcos_lei
gen d_ice_al5=d_ice*al_todos_marcos
gen d_ice_al6=d_ice*al_sel_dir
gen d_ice_al7=d_ice*al_sel_prof
gen d_ice_al8=d_ice*al_proj_vida
gen d_ice_al9=d_ice*al_outros

* Testar se roda para uf=23 e uf=26 com os dados de 2014

* Geral
foreach x in "media_lp_prova_brasil_9" "media_mt_prova_brasil_9"  "media_pb_9"  "apr_ef" "rep_ef"  "aba_ef" "dist_ef" {
foreach xx in 33 35  {

xtreg `x'`xx'_std d_ice d_ano* pb_esc_sup_mae pb_esc_sup_pai nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4  & codigo_uf==`xx', fe 
outreg2 using "${output}ICE_resultados_ps_ef_`xx'.xls", excel append label ctitle(`x', controle pub) 
}
}

