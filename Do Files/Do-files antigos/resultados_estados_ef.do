
use "E:\CMICRO\_CHV\ICE\Dados ICE\ice_clean.dta", clear

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

keep if ano==2011|ano==2013


*******************************************
************* RESULTADOS OLS****************
********************************************

gen int_ice_2013= ice*d_ano11

***Regressões OLS****
foreach x in "media_lp_prova_brasil_9" "media_mt_prova_brasil_9"{
foreach xx in 33 35{

capture egen `x'`xx'_std=std(`x') if codigo_uf==`xx' 
*** Sem controles

reg `x'`xx'_std ice d_uf* d_dep* d_ano* [pw=pscore_total] if codigo_uf==`xx'
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_pb`xx'.xls", excel append label ctitle(`x') 

*** Controlando por caracteristicas do aluno
reg `x'`xx'_std ice d_uf* d_dep* d_ano* pb_esc_sup_mae pb_esc_sup_pai nalunos nbrancos nmulheres [pw=pscore_total] if codigo_uf==`xx'
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_pb`xx'.xls", excel append label ctitle(`x', aluno)  

***Controlando por carateristicas da escola que independem da escola
reg `x'`xx'_std ice d_uf* d_dep* d_ano* pb_esc_sup_mae pb_esc_sup_pai  nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta [pw=pscore_total]  if codigo_uf==`xx'
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_pb`xx'.xls", excel append label ctitle(`x', escola1) 

***Controlando por demais carateristicas da escola 
reg `x'`xx'_std ice d_uf* d_dep* d_ano* pb_esc_sup_mae pb_esc_sup_pai  nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca internet [pw=pscore_total] if codigo_uf==`xx'
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_pb`xx'.xls", excel append label ctitle(`x', escola2) 

***Controlando pelo Mais educação

reg `x'`xx'_std ice d_uf* d_dep* d_ano* pb_esc_sup_mae pb_esc_sup_pai  nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca internet mais_educ [pw=pscore_total] if codigo_uf==`xx'
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_pb`xx'.xls", excel append label ctitle(`x', Mais Educa) 

}
}


***Regressões OLS CUMULATIVO****
foreach x in "media_lp_prova_brasil_9" "media_mt_prova_brasil_9"{
foreach xx in 33 {

capture egen `x'`xx'_std=std(`x') if codigo_uf==`xx' 
*** Sem controles

reg `x'`xx'_std ice int_ice_2013 d_uf* d_dep* d_ano* [pw=pscore_total] if codigo_uf==`xx'
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_pb.xls", excel append label ctitle(`x', cumul) 

*** Controlando por caracteristicas do aluno
reg `x'`xx'_std ice int_ice_2013 d_uf* d_dep* d_ano* pb_esc_sup_mae pb_esc_sup_pai nalunos nbrancos nmulheres [pw=pscore_total] if codigo_uf==`xx'
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_pb.xls", excel append label ctitle(`x', aluno, cumul)  

***Controlando por carateristicas da escola que independem da escola
reg `x'`xx'_std ice int_ice_2013 d_uf* d_dep* d_ano* pb_esc_sup_mae pb_esc_sup_pai pb_esc_sup_mae pb_esc_sup_pai nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta [pw=pscore_total]  if codigo_uf==`xx'
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_pb.xls", excel append label ctitle(`x', escola1, cumul) 

***Controlando por demais carateristicas da escola 
reg `x'`xx'_std ice int_ice_2013 d_uf* d_dep* d_ano* pb_esc_sup_mae pb_esc_sup_pai nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca internet [pw=pscore_total] if codigo_uf==`xx'
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_pb.xls", excel append label ctitle(`x', escola2, cumul) 

***Controlando pelo Mais educação

reg `x'`xx'_std ice int_ice_2013 d_uf* d_dep* d_ano* pb_esc_sup_mae pb_esc_sup_pai nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca internet mais_educ [pw=pscore_total] if codigo_uf==`xx'
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_pb.xls", excel append label ctitle(`x', Mais Educa, cumul) 

}
}


*******Não fazemos painel pois todas as escolas ICE foram criadas em 2011












