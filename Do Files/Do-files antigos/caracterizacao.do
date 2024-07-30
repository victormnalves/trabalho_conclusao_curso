*******************************************************
******************** Escolas do ICE *******************
*******************************************************
/*
use "E:\CMICRO\_CHV\ICE\Dados ICE\base original ice.dta", clear

tab ice_segmento uf,m
tab ano_ice uf,m
tab ice_rigor uf, m

tab integral if d_ice==1 & (ice_segmento=="EF FINAIS + EM" | ice_segmento=="EM" | ice_segmento=="EM Profissionalizante")

foreach x of varlist al_engaj_sec  al_todos_marcos al_sel_dir al_sel_prof {
tab `x' uf if d_ice==1 & (ice_segmento=="EF FINAIS + EM" | ice_segmento=="EM" | ice_segmento=="EM Profissionalizante"), col
}
*/
*******************************************************
******************** Todas as escolas *****************
*******************************************************
use "E:\CMICRO\_CHV\ICE\Dados ICE\ice_clean.dta", clear

* EM *
keep if n_alunos_em_ep>0
drop if codigo_uf==33
sum n_alunos_em

replace enem_nota_objetivab=enem_nota_objetiva if ano<2009

gen n_mulheres_em_ep=n_mulheres_em+n_mulheres_ep
gen n_brancos_em_ep=n_brancos_em+n_brancos_ep



collapse rural agua eletricidade esgoto lixo_coleta sala_professores lab_info ///
lab_ciencias quadra_esportes biblioteca internet n_salas_utilizadas n_alunos_em_ep n_mulheres_em_ep n_brancos_em_ep ///
e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria ///
taxa_participacao_enem enem_nota_matematica enem_nota_ciencias enem_nota_humanas enem_nota_linguagens enem_nota_redacao enem_nota_objetivab rep_em aba_em dist_em ///
s_metodo_esc_dir_selecao s_metodo_esc_dir_eleicao s_metodo_esc_dir_sel_ele s_metodo_esc_dir_indic s_metodo_esc_dir_concurso s_metodo_esc_dir_sel_indic if dep!=4, by(codigo_uf ano d_ice)

****EF******

use "E:\CMICRO\_CHV\ICE\Dados ICE\ice_clean.dta", clear

keep if n_alunos_ef>0
keep if codigo_uf==33|codigo_uf==35

collapse rural agua eletricidade esgoto lixo_coleta sala_professores lab_info ///
lab_ciencias quadra_esportes biblioteca internet n_salas_utilizadas n_alunos_ef n_mulheres_ef n_brancos_ef ///
pb_esc_sup_pai pb_esc_sup_mae ///
taxa_participacao_pb media_lp_prova_brasil_9 media_mt_prova_brasil_9 media_pb_9 rep_ef aba_ef dist_ef  ///
s_metodo_esc_dir_selecao s_metodo_esc_dir_eleicao s_metodo_esc_dir_sel_ele s_metodo_esc_dir_indic s_metodo_esc_dir_concurso s_metodo_esc_dir_sel_indic if dep!=4, by(codigo_uf ano d_ice)




* EF *
use "E:\CMICRO\_CHV\ICE\Dados ICE\ice_clean.dta", clear

keep if n_alunos_ef>0
keep if codigo_uf==33|codigo_uf==35

forvalues x=2010(1)2014 {

cap estpost  sum d_ice dependencia_administrativa rural agua eletricidade esgoto lixo_coleta sala_professores lab_info ///
lab_ciencias quadra_esportes biblioteca internet n_salas_utilizadas n_alunos_ef n_mulheres_ef_em_ep n_brancos_ef_em_ep ///
pb_esc_sup_pai pb_esc_sup_mae ///
taxa_participacao_pb media_lp_prova_brasil_9 media_mt_prova_brasil_9 media_pb_9 rep_ef aba_ef dist_ef  ///
s_metodo_esc_dir_selecao s_metodo_esc_dir_eleicao s_metodo_esc_dir_sel_ele s_metodo_esc_dir_indic s_metodo_esc_dir_concurso s_metodo_esc_dir_sel_indic if d_ice==1 & ano==`x'
cap estout using "E:\CMICRO\_CHV\ICE\Dados ICE\Medias\ef_ge_`x'.xls",append cells("count mean sd")  

estpost  sum d_ice dependencia_administrativa rural agua eletricidade esgoto lixo_coleta sala_professores lab_info ///
lab_ciencias quadra_esportes biblioteca internet n_salas_utilizadas n_alunos_ef n_mulheres_ef_em_ep n_brancos_ef_em_ep ///
pb_esc_sup_pai pb_esc_sup_mae ///
taxa_participacao_pb media_lp_prova_brasil_9 media_mt_prova_brasil_9 media_pb_9 rep_ef aba_ef dist_ef ///
s_metodo_esc_dir_selecao s_metodo_esc_dir_eleicao s_metodo_esc_dir_sel_ele s_metodo_esc_dir_indic s_metodo_esc_dir_concurso s_metodo_esc_dir_sel_indic if dep!=4 & d_ice!=1 & ano==`x'
estout using "E:\CMICRO\_CHV\ICE\Dados ICE\Medias\ef_ge_`x'.xls",append cells("count mean sd")  

estpost  sum d_ice dependencia_administrativa rural agua eletricidade esgoto lixo_coleta sala_professores lab_info ///
lab_ciencias quadra_esportes biblioteca internet n_salas_utilizadas n_alunos_ef n_mulheres_ef_em_ep n_brancos_ef_em_ep ///
pb_esc_sup_pai pb_esc_sup_mae ///
taxa_participacao_pb media_lp_prova_brasil_9 media_mt_prova_brasil_9 media_pb_9 rep_ef aba_ef dist_ef ///
s_metodo_esc_dir_selecao s_metodo_esc_dir_eleicao s_metodo_esc_dir_sel_ele s_metodo_esc_dir_indic s_metodo_esc_dir_concurso s_metodo_esc_dir_sel_indic if dep==2 & d_ice!=1 & ano==`x'
estout using "E:\CMICRO\_CHV\ICE\Dados ICE\Medias\ef_ge_`x'.xls",append cells("count mean sd")  

estpost  sum d_ice dependencia_administrativa rural agua eletricidade esgoto lixo_coleta sala_professores lab_info ///
lab_ciencias quadra_esportes biblioteca internet n_salas_utilizadas n_alunos_ef n_mulheres_ef_em_ep n_brancos_ef_em_ep ///
pb_esc_sup_pai pb_esc_sup_mae ///
taxa_participacao_pb media_lp_prova_brasil_9 media_mt_prova_brasil_9 media_pb_9 rep_ef aba_ef dist_ef ///
s_metodo_esc_dir_selecao s_metodo_esc_dir_eleicao s_metodo_esc_dir_sel_ele s_metodo_esc_dir_indic s_metodo_esc_dir_concurso s_metodo_esc_dir_sel_indic if dep==3 & d_ice!=1 & ano==`x'
estout using "E:\CMICRO\_CHV\ICE\Dados ICE\Medias\ef_ge_`x'.xls",append cells("count mean sd")  

estpost sum d_ice dependencia_administrativa rural agua eletricidade esgoto lixo_coleta sala_professores lab_info ///
lab_ciencias quadra_esportes biblioteca internet n_salas_utilizadas n_alunos_ef n_mulheres_ef_em_ep n_brancos_ef_em_ep ///
pb_esc_sup_pai pb_esc_sup_mae ///
taxa_participacao_pb media_lp_prova_brasil_9 media_mt_prova_brasil_9 media_pb_9 rep_ef aba_ef dist_ef ///
s_metodo_esc_dir_selecao s_metodo_esc_dir_eleicao s_metodo_esc_dir_sel_ele s_metodo_esc_dir_indic s_metodo_esc_dir_concurso s_metodo_esc_dir_sel_indic if dep==4 & d_ice!=1 & ano==`x'
estout using "E:\CMICRO\_CHV\ICE\Dados ICE\Medias\ef_ge_`x'.xls",append cells("count mean sd")  

}
***********************
****** Por UF *********
***********************
use "E:\CMICRO\_CHV\ICE\Dados ICE\ice_clean.dta", clear

* EM *
keep if n_alunos_em_ep>0
drop if codigo_uf==33

replace enem_nota_objetivab=enem_nota_objetiva if ano<2009

forvalues x=2003(1)2014 {
foreach xx in 26 23 35 52 {
cap estpost sum d_ice dependencia_administrativa rural agua eletricidade esgoto lixo_coleta sala_professores lab_info ///
lab_ciencias quadra_esportes biblioteca internet n_salas_utilizadas n_alunos_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep ///
e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria ///
taxa_participacao_enem enem_nota_matematica enem_nota_ciencias enem_nota_humanas enem_nota_linguagens enem_nota_redacao enem_nota_objetivab rep_em aba_em dist_em ///
s_metodo_esc_dir_selecao s_metodo_esc_dir_eleicao s_metodo_esc_dir_sel_ele s_metodo_esc_dir_indic s_metodo_esc_dir_concurso s_metodo_esc_dir_sel_indic if d_ice==1 & codigo_uf==`xx' & ano==`x'
cap estout using "E:\CMICRO\_CHV\ICE\Dados ICE\Medias\em_`xx'_`x'.xls",append cells("count mean sd")  

cap estpost sum d_ice dependencia_administrativa rural agua eletricidade esgoto lixo_coleta sala_professores lab_info ///
lab_ciencias quadra_esportes biblioteca internet n_salas_utilizadas n_alunos_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep ///
e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria ///
taxa_participacao_enem enem_nota_matematica enem_nota_ciencias enem_nota_humanas enem_nota_linguagens enem_nota_redacao enem_nota_objetivab rep_em aba_em dist_em ///
s_metodo_esc_dir_selecao s_metodo_esc_dir_eleicao s_metodo_esc_dir_sel_ele s_metodo_esc_dir_indic s_metodo_esc_dir_concurso s_metodo_esc_dir_sel_indic if dep!=4 & d_ice!=1 & codigo_uf==`xx' & ano==`x'
cap estout using "E:\CMICRO\_CHV\ICE\Dados ICE\Medias\em_`xx'_`x'.xls",append cells("count mean sd")  

cap estpost sum d_ice dependencia_administrativa rural agua eletricidade esgoto lixo_coleta sala_professores lab_info ///
lab_ciencias quadra_esportes biblioteca internet n_salas_utilizadas n_alunos_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep ///
e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria ///
taxa_participacao_enem enem_nota_matematica enem_nota_ciencias enem_nota_humanas enem_nota_linguagens enem_nota_redacao enem_nota_objetivab rep_em aba_em dist_em ///
s_metodo_esc_dir_selecao s_metodo_esc_dir_eleicao s_metodo_esc_dir_sel_ele s_metodo_esc_dir_indic s_metodo_esc_dir_concurso s_metodo_esc_dir_sel_indic if dep==2 & d_ice!=1 & codigo_uf==`xx' & ano==`x'
cap estout using "E:\CMICRO\_CHV\ICE\Dados ICE\Medias\em_`xx'_`x'.xls",append cells("count mean sd")  

cap estpost sum d_ice dependencia_administrativa rural agua eletricidade esgoto lixo_coleta sala_professores lab_info ///
lab_ciencias quadra_esportes biblioteca internet n_salas_utilizadas n_alunos_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep ///
e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria ///
taxa_participacao_enem enem_nota_matematica enem_nota_ciencias enem_nota_humanas enem_nota_linguagens enem_nota_redacao enem_nota_objetivab rep_em aba_em dist_em ///
s_metodo_esc_dir_selecao s_metodo_esc_dir_eleicao s_metodo_esc_dir_sel_ele s_metodo_esc_dir_indic s_metodo_esc_dir_concurso s_metodo_esc_dir_sel_indic if dep==4 & d_ice!=1 & codigo_uf==`xx' & ano==`x'
cap estout using "E:\CMICRO\_CHV\ICE\Dados ICE\Medias\em_`xx'_`x'.xls",append cells("count mean sd")  

}
}

* EF *
use "E:\CMICRO\_CHV\ICE\Dados ICE\ice_clean.dta", clear
keep if n_alunos_ef>0
keep if codigo_uf==33|codigo_uf==35

forvalues x=2010(1)2014 {
foreach xx in 35 33 {

cap estpost sum d_ice dependencia_administrativa rural agua eletricidade esgoto lixo_coleta sala_professores lab_info ///
lab_ciencias quadra_esportes biblioteca internet n_salas_utilizadas n_alunos_ef n_mulheres_ef_em_ep n_brancos_ef_em_ep ///
pb_esc_sup_pai pb_esc_sup_mae ///
taxa_participacao_pb media_lp_prova_brasil_9 media_mt_prova_brasil_9 media_pb_9 rep_ef aba_ef dist_ef ///
s_metodo_esc_dir_selecao s_metodo_esc_dir_eleicao s_metodo_esc_dir_sel_ele s_metodo_esc_dir_indic s_metodo_esc_dir_concurso s_metodo_esc_dir_sel_indic if d_ice==1 & codigo_uf==`xx' & ano==`x'
cap estout using "E:\CMICRO\_CHV\ICE\Dados ICE\Medias\ef_`xx'_`x'.xls",append cells("count mean sd")  

cap estpost sum d_ice dependencia_administrativa rural agua eletricidade esgoto lixo_coleta sala_professores lab_info ///
lab_ciencias quadra_esportes biblioteca internet n_salas_utilizadas n_alunos_ef n_mulheres_ef_em_ep n_brancos_ef_em_ep ///
pb_esc_sup_pai pb_esc_sup_mae ///
taxa_participacao_pb media_lp_prova_brasil_9 media_mt_prova_brasil_9 media_pb_9 rep_ef aba_ef dist_ef ///
s_metodo_esc_dir_selecao s_metodo_esc_dir_eleicao s_metodo_esc_dir_sel_ele s_metodo_esc_dir_indic s_metodo_esc_dir_concurso s_metodo_esc_dir_sel_indic if dep!=4 & d_ice!=1 & codigo_uf==`xx' & ano==`x'
cap estout using "E:\CMICRO\_CHV\ICE\Dados ICE\Medias\ef_`xx'_`x'.xls",append cells("count mean sd")  

cap estpost sum d_ice dependencia_administrativa rural agua eletricidade esgoto lixo_coleta sala_professores lab_info ///
lab_ciencias quadra_esportes biblioteca internet n_salas_utilizadas n_alunos_ef n_mulheres_ef_em_ep n_brancos_ef_em_ep ///
pb_esc_sup_pai pb_esc_sup_mae ///
taxa_participacao_pb media_lp_prova_brasil_9 media_mt_prova_brasil_9 media_pb_9 rep_ef aba_ef dist_ef ///
s_metodo_esc_dir_selecao s_metodo_esc_dir_eleicao s_metodo_esc_dir_sel_ele s_metodo_esc_dir_indic s_metodo_esc_dir_concurso s_metodo_esc_dir_sel_indic if dep==2 & d_ice!=1 & codigo_uf==`xx' & ano==`x'
cap estout using "E:\CMICRO\_CHV\ICE\Dados ICE\Medias\ef_`xx'_`x'.xls",append cells("count mean sd")  

cap estpost sum d_ice dependencia_administrativa rural agua eletricidade esgoto lixo_coleta sala_professores lab_info ///
lab_ciencias quadra_esportes biblioteca internet n_salas_utilizadas n_alunos_ef n_mulheres_ef_em_ep n_brancos_ef_em_ep ///
pb_esc_sup_pai pb_esc_sup_mae ///
taxa_participacao_pb media_lp_prova_brasil_9 media_mt_prova_brasil_9 media_pb_9 rep_ef aba_ef dist_ef ///
s_metodo_esc_dir_selecao s_metodo_esc_dir_eleicao s_metodo_esc_dir_sel_ele s_metodo_esc_dir_indic s_metodo_esc_dir_concurso s_metodo_esc_dir_sel_indic if dep==3 & d_ice!=1 & codigo_uf==`xx' & ano==`x'
cap estout using "E:\CMICRO\_CHV\ICE\Dados ICE\Medias\ef_`xx'_`x'.xls",append cells("count mean sd")  

cap estpost sum d_ice dependencia_administrativa rural agua eletricidade esgoto lixo_coleta sala_professores lab_info ///
lab_ciencias quadra_esportes biblioteca internet n_salas_utilizadas n_alunos_ef n_mulheres_ef_em_ep n_brancos_ef_em_ep ///
pb_esc_sup_pai pb_esc_sup_mae ///
taxa_participacao_pb media_lp_prova_brasil_9 media_mt_prova_brasil_9 media_pb_9 rep_ef aba_ef dist_ef ///
s_metodo_esc_dir_selecao s_metodo_esc_dir_eleicao s_metodo_esc_dir_sel_ele s_metodo_esc_dir_indic s_metodo_esc_dir_concurso s_metodo_esc_dir_sel_indic if dep==4 & d_ice!=1 & codigo_uf==`xx' & ano==`x'
cap estout using "E:\CMICRO\_CHV\ICE\Dados ICE\Medias\ef_`xx'_`x'.xls",append cells("count mean sd")  

}
}

/*
*********************** Integrais x Semi-integrais ***************************

use "E:\CMICRO\_CHV\ICE\Dados ICE\ice_clean.dta", clear

keep if n_alunos_em_ep>0
drop if codigo_uf==33

sum dependencia_administrativa rural agua eletricidade esgoto lixo_coleta sala_professores lab_info ///
lab_ciencias quadra_esportes biblioteca internet n_salas_utilizadas n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep ///
e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria ///
taxa_participacao_enem enem_nota_matematica enem_nota_ciencias enem_nota_humanas enem_nota_linguagens enem_nota_redacao enem_nota_objetivab rep_em aba_em dist_em ///
s_metodo_esc_dir_selecao s_metodo_esc_dir_eleicao s_metodo_esc_dir_sel_ele s_metodo_esc_dir_indic s_metodo_esc_dir_concurso s_metodo_esc_dir_sel_indic if d_ice==1 & integral==1

sum dependencia_administrativa rural agua eletricidade esgoto lixo_coleta sala_professores lab_info ///
lab_ciencias quadra_esportes biblioteca internet n_salas_utilizadas n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep ///
e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria ///
taxa_participacao_enem enem_nota_matematica enem_nota_ciencias enem_nota_humanas enem_nota_linguagens enem_nota_redacao enem_nota_objetivab rep_em aba_em dist_em ///
s_metodo_esc_dir_selecao s_metodo_esc_dir_eleicao s_metodo_esc_dir_sel_ele s_metodo_esc_dir_indic s_metodo_esc_dir_concurso s_metodo_esc_dir_sel_indic if d_ice==1 & integral==1 & codigo_uf==26

sum dependencia_administrativa rural agua eletricidade esgoto lixo_coleta sala_professores lab_info ///
lab_ciencias quadra_esportes biblioteca internet n_salas_utilizadas n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep ///
e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria ///
taxa_participacao_enem enem_nota_matematica enem_nota_ciencias enem_nota_humanas enem_nota_linguagens enem_nota_redacao enem_nota_objetivab rep_em aba_em dist_em ///
s_metodo_esc_dir_selecao s_metodo_esc_dir_eleicao s_metodo_esc_dir_sel_ele s_metodo_esc_dir_indic s_metodo_esc_dir_concurso s_metodo_esc_dir_sel_indic if d_ice==1 & integral==0


