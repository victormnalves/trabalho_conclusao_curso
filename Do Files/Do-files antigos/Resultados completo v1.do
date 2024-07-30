
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

pscore ice n_alunos_ep if ano==2007&codigo_uf==23&dep!=4, pscore(pscores_ce)

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
*Resultados

foreach x in  "enem_nota_matematica_std" "enem_nota_ciencias_std" "enem_nota_humanas_std" "enem_nota_linguagens_std" "enem_nota_redacao_std" "enem_nota_objetivab_std" "media_lp_prova_brasil_9_std" "media_mt_prova_brasil_9_std" "apr_ef_std" "apr_em_std" "rep_ef_std" "rep_em_std" "aba_ef_std" "aba_em_std" "dist_ef_std" "dist_em_std" {

***Controlando por carateristicas dos alunos e da escola 

*Separando por jornada (veio para primeiro para definir se vamos deixar ou não a jornada semi-integral)
xtreg `x' d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4 &(integral==1|ice==0), fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_geral.xls", excel append label ctitle(`x', controle pub, integral) 

xtreg `x' d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4 &(integral==0|ice==0), fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_geral.xls", excel append label ctitle(`x', controle pub, semi-integral) 


*Gerais

xtreg `x' d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] , fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_geral.xls", excel append label ctitle(`x', pub e priv) 

xtreg `x' d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if (dep==4|ice==1), fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_geral.xls", excel append label ctitle(`x', controle priv) 

xtreg `x' d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4 , fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_geral.xls", excel append label ctitle(`x', controle pub) 

xtreg `x' d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca internet mais_educ [pw=pscore_total] if dep!=4, fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_geral.xls", excel append label ctitle(`x', pub mais educ) 


*Por nível de apoio

xtreg `x' d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(d_rigor1==1|ice==0), fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_geral.xls", excel append label ctitle(`x', apoio forte)

xtreg `x' d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(d_rigor3==1|ice==0), fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_geral.xls", excel append label ctitle(`x', apoio medio)

xtreg `x' d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(d_rigor2==1|ice==0), fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_geral.xls", excel append label ctitle(`x', apoio fraco)

xtreg `x' d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(d_rigor4==1|ice==0), fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_geral.xls", excel append label ctitle(`x', sem apoio)

xtreg `x' d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(d_rigor4==0|ice==0) , fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_geral.xls", excel append label ctitle(`x', com algum apoio)

* Alavancas (só as últimas têm variabilidade)

xtreg `x' d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(al_engaj_gov==1|ice==0), fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_geral.xls", excel append label ctitle(`x', engaj gov)

xtreg `x' d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(al_engaj_sec==1|ice==0), fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_geral.xls", excel append label ctitle(`x', engaj secret)

xtreg `x' d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(al_time_seduc==1|ice==0), fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_geral.xls", excel append label ctitle(`x', time seduc)

xtreg `x' d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(al_marcos_lei==1|ice==0), fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_geral.xls", excel append label ctitle(`x', marcos lei)

xtreg `x' d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(al_todos_marcos==1|ice==0) , fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_geral.xls", excel append label ctitle(`x', todos marcos)

xtreg `x' d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(al_sel_dir==1|ice==0), fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_geral.xls", excel append label ctitle(`x', sel diretores)

xtreg `x' d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(al_sel_prof==1|ice==0), fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_geral.xls", excel append label ctitle(`x', sel profes)

xtreg `x' d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(al_proj_vida==1|ice==0) , fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_geral.xls", excel append label ctitle(`x', projeto de vida)
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
gen d_ice5=d_ice*d_tempo6
gen d_ice6=d_ice*d_tempo7
gen d_ice7=d_ice*d_tempo8
gen d_ice8=d_ice*d_tempo9
gen d_ice9=d_ice*d_tempo10
gen d_ice10=d_ice*d_tempo11


foreach x in  "enem_nota_matematica_std" "enem_nota_ciencias_std" "enem_nota_humanas_std" "enem_nota_linguagens_std" "enem_nota_redacao_std" "enem_nota_objetivab_std" "apr_ef_std" "apr_em_std" "rep_ef_std" "rep_em_std" "aba_ef_std" "aba_em_std" "dist_ef_std" "dist_em_std" {


***Controlando por demais carateristicas da escola 
xtreg `x' d_ice1 d_ice2 d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2) , fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_cum_geral.xls", excel append label ctitle(`x', 2 anos) 

xtreg `x' d_ice1 d_ice2 d_ice3 d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2| tempo==3) , fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_cum_geral.xls", excel append label ctitle(`x', 3 anos) 

xtreg `x' d_ice1 d_ice2 d_ice3 d_ice4 d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2| tempo==3 | tempo==4) , fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_cum_geral.xls", excel append label ctitle(`x', 4 anos) 

xtreg `x' d_ice1 d_ice2 d_ice3 d_ice4 d_ice5 d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2| tempo==3 | tempo==4 | tempo==5) , fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_cum_geral.xls", excel append label ctitle(`x', 5 anos) 

capture xtreg `x' d_ice1 d_ice2 d_ice3 d_ice4 d_ice5 d_ice6 d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2| tempo==3| tempo==4 | tempo==5 | tempo==6) , fe cluster(codigo_uf)
capture outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_cum_geral.xls", excel append label ctitle(`x', 6 anos) 

capture xtreg `x' d_ice1 d_ice2 d_ice3 d_ice4 d_ice5 d_ice6 d_ice7 d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2| tempo==3| tempo==4 | tempo==5 | tempo==6| tempo==7) , fe cluster(codigo_uf)
capture outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_cum_geral.xls", excel append label ctitle(`x', 7 anos) 

capture xtreg `x' d_ice1 d_ice2 d_ice3 d_ice4 d_ice5 d_ice6 d_ice7 d_ice8 d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2| tempo==3| tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8) , fe cluster(codigo_uf)
capture outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_cum_geral.xls", excel append label ctitle(`x', 8 anos) 

capture xtreg `x' d_ice1 d_ice2 d_ice3 d_ice4 d_ice5 d_ice6 d_ice7 d_ice8 d_ice9 d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2| tempo==3| tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9) , fe cluster(codigo_uf)
capture outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_cum_geral.xls", excel append label ctitle(`x', 9 anos) 

capture xtreg `x' d_ice1 d_ice2 d_ice3 d_ice4 d_ice5 d_ice6 d_ice7 d_ice8 d_ice9 d_ice10 d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2| tempo==3| tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9| tempo==10) , fe cluster(codigo_uf)
capture outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_cum_geral.xls", excel append label ctitle(`x', 10 anos) 

}
************************************************************************************************
****************************** RESULTADOS CUMULATIVOS POR RIGOR*********************************
************************************************************************************************

* com fraco não dá - poucas observações
foreach x in  "enem_nota_matematica_std" "enem_nota_ciencias_std" "enem_nota_humanas_std" "enem_nota_linguagens_std" "enem_nota_redacao_std" "enem_nota_objetivab_std" "apr_ef_std" "apr_em_std" "rep_ef_std" "rep_em_std" "aba_ef_std" "aba_em_std" "dist_ef_std" "dist_em_std" {
foreach z in "d_rigor1" "d_rigor3" "d_rigor4" {

***Controlando por demais carateristicas da escola 
xtreg `x' d_ice1 d_ice2 d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2)&(`z'==1|ice==0) , fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_cum_rig.xls", excel append label ctitle(`x', 2 anos,`z') 

xtreg `x' d_ice1 d_ice2 d_ice3 d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2| tempo==3)&(`z'==1|ice==0) , fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_cum_rig.xls", excel append label ctitle(`x', 3 anos,`z') 

xtreg `x' d_ice1 d_ice2 d_ice3 d_ice4 d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2| tempo==3 | tempo==4)&(`z'==1|ice==0) , fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_cum_rig.xls", excel append label ctitle(`x', 4 anos,`z') 

capture xtreg `x' d_ice1 d_ice2 d_ice3 d_ice4 d_ice5 d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2| tempo==3 | tempo==4 | tempo==5)&(`z'==1|ice==0) , fe cluster(codigo_uf)
capture outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_cum_rig.xls", excel append label ctitle(`x', 5 anos,`z') 

capture xtreg `x' d_ice1 d_ice2 d_ice3 d_ice4 d_ice5 d_ice6 d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2| tempo==3| tempo==4 | tempo==5 | tempo==6)&(`z'==1|ice==0) , fe cluster(codigo_uf)
capture outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_cum_rig.xls", excel append label ctitle(`x', 6 anos,`z') 

capture xtreg `x' d_ice1 d_ice2 d_ice3 d_ice4 d_ice5 d_ice6 d_ice7 d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2| tempo==3| tempo==4 | tempo==5 | tempo==6| tempo==7)&(`z'==1|ice==0) , fe cluster(codigo_uf)
capture outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_cum_rig.xls", excel append label ctitle(`x', 7 anos,`z') 

capture xtreg `x' d_ice1 d_ice2 d_ice3 d_ice4 d_ice5 d_ice6 d_ice7 d_ice8 d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2| tempo==3| tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8)&(`z'==1|ice==0) , fe cluster(codigo_uf)
capture outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_cum_rig.xls", excel append label ctitle(`x', 8 anos,`z') 

capture xtreg `x' d_ice1 d_ice2 d_ice3 d_ice4 d_ice5 d_ice6 d_ice7 d_ice8 d_ice9 d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2| tempo==3| tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9)&(`z'==1|ice==0) , fe cluster(codigo_uf)
capture outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_cum_rig.xls", excel append label ctitle(`x', 9 anos,`z') 

capture xtreg `x' d_ice1 d_ice2 d_ice3 d_ice4 d_ice5 d_ice6 d_ice7 d_ice8 d_ice9 d_ice10 d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2| tempo==3| tempo==4 | tempo==5 | tempo==6| tempo==7 | tempo==8 | tempo==9| tempo==10)&(`z'==1|ice==0) , fe cluster(codigo_uf)
capture outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_cum_rig.xls", excel append label ctitle(`x', 10 anos,`z') 

}
}



************************************************************************************************
************************************* POR ESTADO (EM) ******************************************
************************************************************************************************

use "E:\CMICRO\_CHV\ICE\Dados ICE\ice_clean.dta", clear

* Painel
iis codigo_escola
tis ano

* Gerar pscores

set matsize 10000


pscore ice n_alunos_em if ano==2003&codigo_uf==26&dep!=4, pscore(pscores_pe)

pscore ice n_alunos_ep if ano==2007&codigo_uf==23&dep!=4, pscore(pscores_ce)

pscore ice n_alunos_ef if ano==2010&codigo_uf==33&dep!=4, pscore(pscores_rj)

pscore ice n_alunos_em if ano==2011&codigo_uf==35&dep!=4, pscore(pscores_sp)

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
*Em Pernambuco, separando pela jornada
foreach x in  "enem_nota_matematica" "enem_nota_ciencias" "enem_nota_humanas" "enem_nota_linguagens" "enem_nota_redacao" "enem_nota_objetivab" "apr_em"  "rep_em"  "aba_em" "dist_em"{

xtreg `x'26_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4 & (integral==1|ice==0) & codigo_uf==26, fe 
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_26.xls", excel append label ctitle(`x', controle pub, integral) 

xtreg `x'26_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4 & (integral==0|ice==0) & codigo_uf==26, fe 
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_26.xls", excel append label ctitle(`x', controle pub, semi-integral)
}

* Todos os estados (ambas as jornadas)
foreach x in  "enem_nota_matematica" "enem_nota_ciencias" "enem_nota_humanas" "enem_nota_linguagens" "enem_nota_redacao" "enem_nota_objetivab" "apr_em"  "rep_em"  "aba_em" "dist_em"{
foreach xx in 26 23 35 52 {

xtreg `x'`xx'_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4  & codigo_uf==`xx', fe 
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_`xx'.xls", excel append label ctitle(`x', controle pub) 
}
}


* Todos os estados (por rigor)
foreach x in  "enem_nota_matematica" "enem_nota_ciencias" "enem_nota_humanas" "enem_nota_linguagens" "enem_nota_redacao" "enem_nota_objetivab" "apr_em"  "rep_em"  "aba_em" "dist_em"{
foreach xx in 26 23 35 52 {
foreach z in "d_rigor1" "d_rigor4" {

xtreg `x'`xx'_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4  & codigo_uf==`xx' &(`z'==1|ice==0), fe 
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_`xx'.xls", excel append label ctitle(`x', controle pub, `z') 

}
}
}

* Todos os estados (por alavanca)
foreach x in  "enem_nota_matematica" "enem_nota_ciencias" "enem_nota_humanas" "enem_nota_linguagens" "enem_nota_redacao" "enem_nota_objetivab" "apr_em"  "rep_em"  "aba_em" "dist_em"{
foreach xx in 26 23 35 52 {
foreach z in "al_engaj_gov" "al_engaj_sec" "al_time_seduc" "al_marcos_lei" "al_todos_marcos" "al_sel_dir" "al_sel_prof" {

xtreg `x'`xx'_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4  & codigo_uf==`xx' &(`z'==1|ice==0), fe 
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_`xx'.xls", excel append label ctitle(`x', controle pub, `z') 

}
}
}

************************************************************************************************
************************************* POR ESTADO (EF) ******************************************
************************************************************************************************

use "E:\CMICRO\_CHV\ICE\Dados ICE\ice_clean.dta", clear

* Painel
iis codigo_escola
tis ano

keep if codigo_uf==33|codigo_uf==35

drop if ice_seg=="EM"

pscore ice n_alunos_ef if ano==2010&codigo_uf==33&dep!=4, pscore(pscores_rj)
pscore ice n_alunos_ef if ano==2011&codigo_uf==35&dep!=4, pscore(pscores_sp)

gen pscore_total=.
replace pscore_total=1 if ice==1

replace pscore_total=1/(1-pscores_rj) if codigo_uf==33&dep!=4&ice==0
replace pscore_total=1/(1-pscores_sp) if codigo_uf==35&dep!=4&ice==0

bysort codigo_escola: egen pscore_total_aux=max(pscore_total)
replace pscore_total=pscore_total_aux

keep if ano==2009|ano==2011|ano==2013


* Todos os estados (ambas as jornadas)
foreach x in  "media_lp_prova_brasil_9" "media_mt_prova_brasil_9" "apr_ef"  "rep_ef"  "aba_ef" "dist_ef" {
foreach xx in 33 35 {

xtreg `x'`xx'_std d_ice d_ano* pb_esc_sup_mae pb_esc_sup_pai nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4  & codigo_uf==`xx', fe 
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_`xx'.xls", excel append label ctitle(`x', controle pub) 
}
}


* Todos os estados (por rigor)
foreach x in  "media_lp_prova_brasil_9" "media_mt_prova_brasil_9" "apr_ef"  "rep_ef"  "aba_ef" "dist_ef" {
foreach xx in 33 35 {
foreach z in "d_rigor1" "d_rigor3" "d_rigor2" "d_rigor4" {

xtreg `x'`xx'_std d_ice d_ano* pb_esc_sup_mae pb_esc_sup_pai nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4  & codigo_uf==`xx' &(`z'==1|ice==0), fe 
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_`xx'.xls", excel append label ctitle(`x', controle pub, `z') 

}
}
}

* Todos os estados (por alavanca)
foreach x in  "media_lp_prova_brasil_9" "media_mt_prova_brasil_9" "apr_ef"  "rep_ef"  "aba_ef" "dist_ef" {
foreach xx in 33 35 {
foreach z in "al_engaj_gov" "al_engaj_sec" "al_time_seduc" "al_marcos_lei" "al_todos_marcos" "al_sel_dir" "al_sel_prof" {

xtreg `x'`xx'_std d_ice d_ano* pb_esc_sup_mae pb_esc_sup_pai nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4  & codigo_uf==`xx' &(`z'==1|ice==0), fe 
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_ps_`xx'.xls", excel append label ctitle(`x', controle pub, `z') 

}
}
}
