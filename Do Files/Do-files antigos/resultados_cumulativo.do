
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

gen tempo=.
replace tempo=1 if ano==ano_ice
replace tempo=0 if ano==ano_ice-1
replace tempo=2 if ano==ano_ice+1
replace tempo=3 if ano==ano_ice+2 
replace tempo=4 if ano==ano_ice+3
replace tempo=5 if ano==ano_ice+4

iis codigo_escol
tis tempo

tab tempo, gen(d_tempo)

gen d_ice1=d_ice*d_tempo2
gen d_ice2=d_ice*d_tempo3
gen d_ice3=d_ice*d_tempo4
gen d_ice4=d_ice*d_tempo5


foreach x in "enem_nota_matematica" "enem_nota_ciencias" "enem_nota_humanas" "enem_nota_linguagens" "enem_nota_redacao" "enem_nota_objetivab" {


***Dois anos

capture egen `x'_std=std(`x')

*** Sem controles

xtreg `x'_std d_ice1 d_ice2 d_ano* [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2)  , fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ac2.xls", excel append label ctitle(`x', sem controle, todas as escolas)

*** Controlando por caracteristicas do aluno
xtreg `x'_std d_ice1 d_ice2 d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2) , fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ac2.xls", excel append label ctitle(`x', aluno, controle pub)

***Controlando por carateristicas da escola que independem da escola
xtreg `x'_std d_ice1 d_ice2 d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2) , fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ac2.xls", excel append label ctitle(`x', escola1, controle pub) 

***Controlando por demais carateristicas da escola 
xtreg `x'_std d_ice1 d_ice2 d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2) , fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ac2.xls", excel append label ctitle(`x', escola2, controle pub) 


***Tr s anos

*** Sem controles

xtreg `x'_std d_ice1 d_ice2 d_ice3 d_ano* [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2)  , fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ac3.xls", excel append label ctitle(`x', sem controle, todas as escolas)

*** Controlando por caracteristicas do aluno
xtreg `x'_std d_ice1 d_ice2 d_ice3 d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2) , fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ac3.xls", excel append label ctitle(`x', aluno, controle pub)

***Controlando por carateristicas da escola que independem da escola
xtreg `x'_std d_ice1 d_ice2 d_ice3 d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2) , fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ac3.xls", excel append label ctitle(`x', escola1, controle pub) 

***Controlando por demais carateristicas da escola 
xtreg `x'_std d_ice1 d_ice2 d_ice3 d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(tempo==0|tempo==1|tempo==2) , fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ac3.xls", excel append label ctitle(`x', escola2, controle pub) 

}
