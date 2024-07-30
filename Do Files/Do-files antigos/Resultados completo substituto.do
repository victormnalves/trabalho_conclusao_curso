
************************************************************************************************
******************************** RESULTADOS PAINEL PSCORE***************************************
************************************************************************************************

use "E:\CMICRO\_CHV\ICE\Dados ICE\ice_clean.dta", clear

******************************* EM *****************************************************
keep if n_alunos_em_ep>0
drop if codigo_uf==33

* Painel
iis codigo_escola
tis ano


* Gerar pscores

set matsize 10000


pscore ice n_alunos_em taxa_participacao_enem  if ano==2003&codigo_uf==26&dep!=4, pscore(pscores_pe)

pscore ice n_alunos_em_ep taxa_participacao_enem  if ano==2007&codigo_uf==23&dep!=4, pscore(pscores_ce)

*pscore ice n_alunos_ef  if ano==2010&codigo_uf==33&dep!=4, pscore(pscores_rj)

pscore ice n_alunos_em taxa_participacao_enem   if ano==2011&codigo_uf==35&dep!=4, pscore(pscores_sp)

pscore ice n_alunos_em taxa_participacao_enem if ano==2012&codigo_uf==52&dep!=4, pscore(pscores_go)



gen pscore_total=.
replace pscore_total=1 if ice==1

replace pscore_total=1/(1-pscores_pe) if codigo_uf==26&dep!=4&ice==0

replace pscore_total=1/(1-pscores_ce) if codigo_uf==23&dep!=4&ice==0

*replace pscore_total=1/(1-pscores_rj) if codigo_uf==33&dep!=4&ice==0

replace pscore_total=1/(1-pscores_sp) if codigo_uf==35&dep!=4&ice==0

replace pscore_total=1/(1-pscores_go) if codigo_uf==52&dep!=4&ice==0

bysort codigo_escola: egen pscore_total_aux=max(pscore_total)
replace pscore_total=pscore_total_aux

* Interações de turno e alavancas

gen ice_inte=0
replace ice_inte=1 if integral==1 

gen ice_semi_inte=0
replace ice_semi_inte=1 if ice_jornada=="Semi-integral"

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

********** Resultados

*foreach x in  "enem_nota_matematica_std" "enem_nota_ciencias_std" "enem_nota_humanas_std" "enem_nota_linguagens_std" "enem_nota_redacao_std" "enem_nota_objetivab_std" "apr_em_std" "rep_em_std" "aba_em_std" "dist_em_std" {
foreach x in   "enem_nota_objetivab_std" "rep_em_std" "aba_em_std" "dist_em_std" {

***Controlando por carateristicas dos alunos e da escola 

*xtreg `x' d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca  internet [pw=pscore_total] if dep!=4  , fe cluster(codigo_uf)
*outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_em.xls", excel append label ctitle(`x', controle pub) 

xtreg `x' d_ice d_ice_inte d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4 , fe cluster(codigo_uf)
*outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_em.xls", excel append label ctitle(`x', controle pub) 

lincom d_ice + d_ice_inte 




}


************************************************************************************************
******************************** RESULTADOS PAINEL PSCORE***************************************
************************************************************************************************

use "E:\CMICRO\_CHV\ICE\Dados ICE\ice_clean.dta", clear

******************************* EF *****************************************************
keep if n_alunos_ef>0
keep if codigo_uf==33|codigo_uf==35

* Painel
iis codigo_escola
tis ano


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

* Interações de turno e alavancas

gen ice_inte=0
replace ice_inte=1 if integral==1 

gen ice_semi_inte=0
replace ice_semi_inte=1 if ice_jornada=="Semi-integral"

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

********** Resultados

foreach x in  "media_pb_9_std" {
***Controlando por carateristicas dos alunos e da escola 

*Gerais


xtreg `x' d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(integral==1|ice==0) , fe cluster(codigo_uf)
*outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_ef.xls", excel append label ctitle(`x', controle pub) 

}


*Por nível de apoio

xtreg `x' d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(d_rigor1==1|ice==0)&(integral==1|ice==0), fe cluster(codigo_uf)
*outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_ef.xls", excel append label ctitle(`x', apoio forte)

xtreg `x' d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(d_rigor3==1|ice==0)&(integral==1|ice==0), fe cluster(codigo_uf)
*outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_ef.xls", excel append label ctitle(`x', apoio medio)

xtreg `x' d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(d_rigor2==1|ice==0)&(integral==1|ice==0), fe cluster(codigo_uf)
*outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_ef.xls", excel append label ctitle(`x', apoio fraco)

xtreg `x' d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(d_rigor4==1|ice==0)&(integral==1|ice==0), fe cluster(codigo_uf)
*outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_ef.xls", excel append label ctitle(`x', sem apoio)

xtreg `x' d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(d_rigor4==0|ice==0)&(integral==1|ice==0) , fe cluster(codigo_uf)
*outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_ef.xls", excel append label ctitle(`x', com algum apoio)

* Alavancas (só as últimas têm variabilidade)

xtreg `x' d_ice d_ice_al1 d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(integral==1|ice==0), fe cluster(codigo_uf)
*outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_ef.xls", excel append label ctitle(`x', engaj gov)
lincom d_ice +  d_ice_al1
xtreg `x' d_ice d_ice_al2 d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(integral==1|ice==0), fe cluster(codigo_uf)
*outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_ef.xls", excel append label ctitle(`x', engaj secret)
lincom d_ice +  d_ice_al2
xtreg `x' d_ice d_ice_al3 d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(integral==1|ice==0), fe cluster(codigo_uf)
*outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_ef.xls", excel append label ctitle(`x', time seduc)
lincom d_ice +  d_ice_al3
xtreg `x' d_ice d_ice_al4 d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(integral==1|ice==0), fe cluster(codigo_uf)
*outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_ef.xls", excel append label ctitle(`x', marcos lei)
lincom d_ice +  d_ice_al4
xtreg `x' d_ice d_ice_al5 d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(integral==1|ice==0), fe cluster(codigo_uf)
*outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_ef.xls", excel append label ctitle(`x', todos marcos)
lincom d_ice +  d_ice_al5
xtreg `x' d_ice d_ice_al6 d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(integral==1|ice==0), fe cluster(codigo_uf)
*outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_ef.xls", excel append label ctitle(`x', sel diretores)
lincom d_ice +  d_ice_al6
xtreg `x' d_ice d_ice_al7 d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(integral==1|ice==0), fe cluster(codigo_uf)
*outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_ef.xls", excel append label ctitle(`x', sel profes)
lincom d_ice +  d_ice_al7
xtreg `x' d_ice d_ice_al8 d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(integral==1|ice==0), fe cluster(codigo_uf)
*outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_ef.xls", excel append label ctitle(`x', projeto de vida)
lincom d_ice +  d_ice_al8
xtreg `x' d_ice d_ice_al9 d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(integral==1|ice==0), fe cluster(codigo_uf)
*outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_ef.xls", excel append label ctitle(`x', outros alavancas)
lincom d_ice +  d_ice_al9
}



************************************************************************************************
********************************** RESULTADOS CUMULATIVOS **************************************
************************************************************************************************

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




foreach x in  "media_pb_9_std" {


***Controlando por demais carateristicas da escola 
xtreg `x' d_ice1 d_ice2 d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2)&(integral==1|ice==0) , fe cluster(codigo_uf)
**outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_cum_ef.xls", excel append label ctitle(`x', 2 anos) 

xtreg `x' d_ice1 d_ice2 d_ice3 d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2| tempo==3)&(integral==1|ice==0) , fe cluster(codigo_uf)
**outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_cum_ef.xls", excel append label ctitle(`x', 3 anos) 

xtreg `x' d_ice1 d_ice2 d_ice3 d_ice4 d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2| tempo==3 | tempo==4)&(integral==1|ice==0) , fe cluster(codigo_uf)
**outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_cum_ef.xls", excel append label ctitle(`x', 4 anos) 

}

************************************************************************************************
************************************* POR ESTADO (EM) ******************************************
************************************************************************************************

use "E:\CMICRO\_CHV\ICE\Dados ICE\ice_clean.dta", clear

* Painel
iis codigo_escola
tis ano

*Dropar RJ
drop if codigo_uf==33

* Gerar pscores

set matsize 10000


pscore ice n_alunos_em taxa_participacao_enem if ano==2003&codigo_uf==26&dep!=4, pscore(pscores_pe)

pscore ice n_alunos_em_ep taxa_participacao_enem if ano==2007&codigo_uf==23&dep!=4, pscore(pscores_ce)

pscore ice n_alunos_em taxa_participacao_enem if ano==2011&codigo_uf==35&dep!=4, pscore(pscores_sp)

pscore ice n_alunos_em taxa_participacao_enem if ano==2012&codigo_uf==52&dep!=4, pscore(pscores_go)


gen pscore_total=.
replace pscore_total=1 if ice==1

replace pscore_total=1/(1-pscores_pe) if codigo_uf==26&dep!=4&ice==0

replace pscore_total=1/(1-pscores_ce) if codigo_uf==23&dep!=4&ice==0

replace pscore_total=1/(1-pscores_sp) if codigo_uf==35&dep!=4&ice==0

replace pscore_total=1/(1-pscores_go) if codigo_uf==52&dep!=4&ice==0

bysort codigo_escola: egen pscore_total_aux=max(pscore_total)
replace pscore_total=pscore_total_aux

* Interações de turno e alavancas

gen ice_inte=0
replace ice_inte=1 if integral==1 

gen ice_semi_inte=0
replace ice_semi_inte=1 if ice_jornada=="Semi-integral"

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


foreach x in  "aba_em"{
foreach xx in 26  {

xtreg `x'`xx'_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4  & codigo_uf==`xx' , fe 
**outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_em_`xx'.xls", excel append label ctitle(`x', controle pub) 
}
}

/*
* Todos os estados (por rigor)
foreach x in  "enem_nota_matematica" "enem_nota_ciencias" "enem_nota_humanas" "enem_nota_linguagens" "enem_nota_redacao" "enem_nota_objetivab" "apr_em"  "rep_em"  "aba_em" "dist_em"{
foreach xx in 26 23 35 52 {
foreach z in "d_rigor1" "d_rigor3" "d_rigor2" "d_rigor4" {

xtreg `x'`xx'_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4  & codigo_uf==`xx' &(`z'==1|ice==0), fe 
*outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_`xx'_pond.xls", excel append label ctitle(`x', controle pub, `z') 

}
}
}

* Todos os estados (por alavanca)
foreach x in  "enem_nota_matematica" "enem_nota_ciencias" "enem_nota_humanas" "enem_nota_linguagens" "enem_nota_redacao" "enem_nota_objetivab" "apr_em"  "rep_em"  "aba_em" "dist_em"{
foreach xx in 26 23 35 52 {
foreach z in "d_ice_al1" "d_ice_al2" "d_ice_al3" "d_ice_al4" "d_ice_al5" "d_ice_al6" "d_ice_al7" "d_ice_al8" "d_ice_al9"{

capture xtreg `x'`xx'_std d_ice `z' d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4  & codigo_uf==`xx', fe 
capture *outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_`xx'_pond.xls", excel append label ctitle(`x', controle pub, `z') 

}
}
}
*/
************************************************************************************************
************************************* POR ESTADO (EF) ******************************************
************************************************************************************************

use "E:\CMICRO\_CHV\ICE\Dados ICE\ice_clean.dta", clear

* Painel
iis codigo_escola
tis ano

keep if codigo_uf==33|codigo_uf==35|codigo_uf==23|codigo_uf==26

drop if ice_seg=="EM"

pscore ice n_alunos_ef taxa_participacao_pb if ano==2009&codigo_uf==33&dep!=4, pscore(pscores_rj)
pscore ice n_alunos_ef taxa_participacao_pb if ano==2011&codigo_uf==35&dep!=4, pscore(pscores_sp)
pscore ice n_alunos_ef taxa_participacao_pb if ano==2013&codigo_uf==26&dep!=4, pscore(pscores_pe)
pscore ice n_alunos_ef taxa_participacao_pb if ano==2013&codigo_uf==23&dep!=4, pscore(pscores_ce)


gen pscore_total=.
replace pscore_total=1 if ice==1

replace pscore_total=1/(1-pscores_rj) if codigo_uf==33&dep!=4&ice==0
replace pscore_total=1/(1-pscores_sp) if codigo_uf==35&dep!=4&ice==0
replace pscore_total=1/(1-pscores_pe) if codigo_uf==26&dep!=4&ice==0
replace pscore_total=1/(1-pscores_ce) if codigo_uf==23&dep!=4&ice==0

bysort codigo_escola: egen pscore_total_aux=max(pscore_total)
replace pscore_total=pscore_total_aux

keep if ano==2009|ano==2011|ano==2013

* Interações de turno e alavancas

gen ice_inte=0
replace ice_inte=1 if integral==1 

gen ice_semi_inte=0
replace ice_semi_inte=1 if ice_jornada=="Semi-integral"

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


* Todos os estados (ambas as jornadas)
foreach x in  "media_lp_prova_brasil_9" "media_mt_prova_brasil_9" "media_pb_9" "apr_ef"  "rep_ef"  "aba_ef" "dist_ef" {
foreach xx in 33 35 {

xtreg `x'`xx'_std d_ice d_ano* pb_esc_sup_mae pb_esc_sup_pai nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4  & codigo_uf==`xx', fe 
*outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_ef_`xx'.xls", excel append label ctitle(`x', controle pub) 
}
}

/*
* Todos os estados (por rigor)
foreach x in  "media_lp_prova_brasil_9" "media_mt_prova_brasil_9" "apr_ef"  "rep_ef"  "aba_ef" "dist_ef" {
foreach xx in 33 35 26 23 {
foreach z in "d_rigor1" "d_rigor3" "d_rigor2" "d_rigor4" {

xtreg `x'`xx'_std d_ice d_ano* pb_esc_sup_mae pb_esc_sup_pai nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4  & codigo_uf==`xx' &(`z'==1|ice==0), fe 
*outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_`xx'_pond.xls", excel append label ctitle(`x', controle pub, `z') 

}
}
}

* Todos os estados (por alavanca)
foreach x in  "media_lp_prova_brasil_9" "media_mt_prova_brasil_9" "apr_ef"  "rep_ef"  "aba_ef" "dist_ef" {
foreach xx in 33 35 26 23 {
foreach z in "d_ice_al1" "d_ice_al2" "d_ice_al3" "d_ice_al4" "d_ice_al5" "d_ice_al6" "d_ice_al7" "d_ice_al8" "d_ice_al9"{

xtreg `x'`xx'_std d_ice `z' d_ano* pb_esc_sup_mae pb_esc_sup_pai nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4  & codigo_uf==`xx', fe 
*outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_`xx'_pond.xls", excel append label ctitle(`x', controle pub, `z') 

}
}
}
*/
