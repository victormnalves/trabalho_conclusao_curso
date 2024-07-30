

*******************************************************
*************RETIRANDO EF******************************
******************************************************

drop if ice_seg=="EFII"|ice_seg=="EF FINAIS" 

*******************************************
******* RESULTADOS PAINEL PSCORE************
********************************************

use "E:\CMICRO\_CHV\ICE\Dados ICE\ice_clean.dta", clear

* Em 2010, a pergunta no enem sobre renda familiar foi diferente dos outros anos. Consertar
replace e_renda_familia_5_salarios=e_renda_familia_6_salarios if ano==2010

* Painel
iis codigo_escola
tis ano

*Gerar variável de ano de entrana da escola no programa

gen d_ice=0

tab ano, gen(d_ano)

forvalues x=2004(1)2015{
replace d_ice=1 if ice_`x'==1 &ano==`x' 
}


* Calcular número de alunos por ciclo de ensino contemplado pelo programa

forvalues x=1(1)3{
replace n_alunos_em_`x'=0 if n_alunos_em_`x'==.
}

gen n_alunos_em=n_alunos_em_1+n_alunos_em_2 +n_alunos_em_3
replace n_alunos_em=0 if n_alunos_em==.

forvalues x=8(1)9{
forvalues i=5(1)9{
capture replace n_alunos_fund_`x'_`i'anos=0 if n_alunos_fund_`x'_`i'anos==.
}
}


gen n_alunos_ef=n_alunos_fund_5_8anos+ n_alunos_fund_6_8anos +n_alunos_fund_7_8anos +n_alunos_fund_8_8anos +n_alunos_fund_6_9anos +n_alunos_fund_7_9anos +n_alunos_fund_8_9anos +n_alunos_fund_9_9anos
replace n_alunos_ef=0 if n_alunos_ef==.

foreach x in "1" "2" "3" "4" "ns"{
replace n_alunos_em_inte_`x'=0 if n_alunos_em_inte_`x'==.
}

gen n_alunos_ep=n_alunos_em_inte_1+ n_alunos_em_inte_2+ n_alunos_em_inte_3 +n_alunos_em_inte_4 +n_alunos_em_inte_ns
replace n_alunos_ep=0 if n_alunos_ep==.

gen n_alunos_ef_em=n_alunos_ef+n_alunos_ep

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



*******************************************************
*************RETIRANDO EF******************************
******************************************************

drop if ice_seg=="EFII"|ice_seg=="EF FINAIS" 


foreach x in "enem_nota_matematica" "enem_nota_ciencias" "enem_nota_humanas" "enem_nota_linguagens" "enem_nota_redacao" "enem_nota_objetivab"{

capture egen `x'_std=std(`x')

*** Sem controles

xtreg `x'_std d_ice d_ano* [pw=pscore_total] if dep!=4  , fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ps_em.xls", excel append label ctitle(`x', sem controle, todas as escolas)

xtreg `x'_std d_ice d_ano* [pw=pscore_total] if dep!=4&(d_rigor1==1|ice==0)  , fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ps_em.xls", excel append label ctitle(`x', sem controle, apoio forte)

xtreg `x'_std d_ice d_ano* [pw=pscore_total] if dep!=4&(d_rigor4==0|ice==0)  , fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ps_em.xls", excel append label ctitle(`x', sem controle, com apoio)

*** Controlando por caracteristicas do aluno
xtreg `x'_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios p_mulheres_em_3 p_brancos_em_3 m_idade_em_3 [pw=pscore_total] if dep!=4 , fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ps_em.xls", excel append label ctitle(`x', aluno, controle pub)

xtreg `x'_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios p_mulheres_em_3 p_brancos_em_3 m_idade_em_3 [pw=pscore_total] if dep!=4&(d_rigor1==1|ice==0), fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ps_em.xls", excel append label ctitle(`x', aluno, apoio forte)

xtreg `x'_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios p_mulheres_em_3 p_brancos_em_3 m_idade_em_3 [pw=pscore_total] if dep!=4&(d_rigor4==0|ice==0) , fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ps_em.xls", excel append label ctitle(`x', aluno, com apoio)

***Controlando por carateristicas da escola que independem da escola
xtreg `x'_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios p_mulheres_em_3 p_brancos_em_3 m_idade_em_3/*
*/ rural agua eletricidade esgoto lixo_coleta [pw=pscore_total] if dep!=4 , fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ps_em.xls", excel append label ctitle(`x', escola1, controle pub) 

xtreg `x'_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios p_mulheres_em_3 p_brancos_em_3 m_idade_em_3/*
*/ rural agua eletricidade esgoto lixo_coleta [pw=pscore_total] if dep!=4&(d_rigor1==1|ice==0) , fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ps_em.xls", excel append label ctitle(`x', escola1, apoio forte)

xtreg `x'_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios p_mulheres_em_3 p_brancos_em_3 m_idade_em_3/*
*/ rural agua eletricidade esgoto lixo_coleta [pw=pscore_total] if dep!=4&(d_rigor4==0|ice==0) , fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ps_em.xls", excel append label ctitle(`x', escola1, com apoio)

***Controlando por demais carateristicas da escola 
xtreg `x'_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios p_mulheres_em_3 p_brancos_em_3 m_idade_em_3/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca sala_leitura refeitorio internet [pw=pscore_total] if dep!=4 , fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ps_em.xls", excel append label ctitle(`x', escola2, controle pub) 

xtreg `x'_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios p_mulheres_em_3 p_brancos_em_3 m_idade_em_3/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca sala_leitura refeitorio internet [pw=pscore_total] if dep!=4&(d_rigor1==1|ice==0), fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ps_em.xls", excel append label ctitle(`x', escola2, apoio forte)

xtreg `x'_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios p_mulheres_em_3 p_brancos_em_3 m_idade_em_3/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca sala_leitura refeitorio internet [pw=pscore_total] if dep!=4&(d_rigor4==0|ice==0) , fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ps_em.xls", excel append label ctitle(`x', escola2, com apoio)

}


