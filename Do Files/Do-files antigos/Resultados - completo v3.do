
************************************************************************************************
******************************** RESULTADOS PAINEL PSCORE***************************************
************************************************************************************************

use "E:\CMICRO\_CHV\ICE\Dados ICE\ice_clean.dta", clear

* Painel
iis codigo_escola
tis ano


* Gerar pscores

set matsize 10000


pscore ice n_alunos_em if ano==2003&codigo_uf==26&dep!=4, pscore(pscores_pe)

pscore ice n_alunos_em_ep if ano==2007&codigo_uf==23&dep!=4, pscore(pscores_ce)

pscore ice n_alunos_ef if ano==2010&codigo_uf==33&dep!=4, pscore(pscores_rj)

pscore ice n_alunos_ef_em if ano==2011&codigo_uf==35&dep!=4, pscore(pscores_sp)

pscore ice n_alunos_em if ano==2012&codigo_uf==52&dep!=4, pscore(pscores_go)



gen pscore_total=.
replace pscore_total=1 if ice==1

replace pscore_total=1/(1-pscores_pe) if codigo_uf==26&dep!=4&ice==0

replace pscore_total=1/(1-pscores_ce) if codigo_uf==23&dep!=4&ice==0

replace pscore_total=1/(1-pscores_rj) if codigo_uf==33&dep!=4&ice==0

replace pscore_total=1/(1-pscores_sp) if codigo_uf==35&dep!=4&ice==0

replace pscore_total=1/(1-pscores_go) if codigo_uf==52&dep!=4&ice==0

bysort codigo_escola: egen pscore_total_aux=max(pscore_total)
replace pscore_total=pscore_total_aux

* Intera��es de turno e alavancas

gen ice_inte=0
replace ice_inte=1 if integral==1 

gen ice_semi_inte=0
replace ice_semi_inte=1 if ice_jornada=="Semi-integral"

gen d_ice_inte=d_ice*ice_inte
gen d_ice_semi_inte=d_ice*ice_semi_inte

foreach x in "al_engaj_gov" "al_engaj_sec" "al_time_seduc" "al_marcos_lei" "al_todos_marcos" "al_sel_dir" "al_sel_prof" "al_proj_vida" {
replace `x'=0 if `x'==.
}

gen d_ice_al1=d_ice*al_engaj_gov
gen d_ice_al2=d_ice*al_engaj_sec
gen d_ice_al3=d_ice*al_time_seduc
gen d_ice_al4=d_ice*al_marcos_lei
gen d_ice_al5=d_ice*al_todos_marcos
gen d_ice_al6=d_ice*al_sel_dir
gen d_ice_al7=d_ice*al_sel_prof
gen d_ice_al8=d_ice*al_proj_vida


*Resultados

foreach x in  "enem_nota_matematica_std" "enem_nota_ciencias_std" "enem_nota_humanas_std" "enem_nota_linguagens_std" "enem_nota_redacao_std" "enem_nota_objetivab_std" "media_lp_prova_brasil_9_std" "media_mt_prova_brasil_9_std" "apr_ef_std" "apr_em_std" "rep_ef_std" "rep_em_std" "aba_ef_std" "aba_em_std" "dist_ef_std" "dist_em_std" {

*Controle p�blico com controles de turno e alavancas 

xtreg `x' d_ice d_ice_inte d_ice_semi_inte d_ice_al* d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4 , fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_geral_v2.xls", excel append label ctitle(`x', controle pub) 

}



