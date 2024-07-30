
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

foreach x in  "enem_nota_matematica_std" "enem_nota_ciencias_std" "enem_nota_humanas_std" "enem_nota_linguagens_std" "enem_nota_redacao_std" "enem_nota_objetivab_std" "apr_em_std" "rep_em_std" "aba_em_std" "dist_em_std" {
***Controlando por carateristicas dos alunos e da escola 

*Gerais

xtreg `x' d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4  , fe cluster(codigo_uf)
*outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_em.xls", excel append label ctitle(`x', controle pub, tudo) 


****Integral vs Semi-Integral
xtreg `x' d_ice d_ice_inte d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4 , fe cluster(codigo_uf)
*outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_em.xls", excel append label ctitle(`x', controle pub) 

lincom d_ice + d_ice_inte 
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


foreach x in   "enem_nota_objetivab"  "rep_em"  "aba_em" "dist_em"{
foreach xx in 26 {

xtreg `x'`xx'_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4  & codigo_uf==`xx' , fe

xtreg `x'_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4  & codigo_uf==`xx' , fe  
*outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_em_`xx'.xls", excel append label ctitle(`x', controle pub) 
}
}
