********************************************
************* RESULTADOS OLS****************
********************************************

use "E:\CMICRO\_CHV\ICE\Dados ICE\ice_clean.dta", clear



***Regress�es OLS****
***PE e GO***

use "E:\CMICRO\_CHV\ICE\Dados ICE\ice_clean.dta", clear
foreach x in "enem_nota_matematica" "enem_nota_ciencias" "enem_nota_humanas" "enem_nota_linguagens" "enem_nota_redacao"{
foreach xx in 26 52 33 35 23 {

capture egen `x'`xx'_std=std(`x') if codigo_uf==`xx' 
*** Sem controles

reg `x'`xx'_std ice d_uf* d_dep* d_ano* if codigo_uf==`xx'
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares`xx'.xls", excel append label ctitle(`x') 

*** Controlando por caracteristicas do aluno
reg `x'`xx'_std ice d_uf* d_dep* d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria nalunos nbrancos nmulheres if codigo_uf==`xx'
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares`xx'.xls", excel append label ctitle(`x', aluno)  

***Controlando por carateristicas da escola que independem da escola
reg `x'`xx'_std ice d_uf* d_dep*d_ano*  e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta  if codigo_uf==`xx'
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares`xx'.xls", excel append label ctitle(`x', escola1) 

***Controlando por demais carateristicas da escola 
reg `x'`xx'_std ice d_uf* d_dep* d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet if codigo_uf==`xx'
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares`xx'.xls", excel append label ctitle(`x', escola2) 

***Controlando pelo Mais educa��o

reg `x'`xx'_std ice d_uf* d_dep* d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet mais_educ if codigo_uf==`xx'
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares`xx'.xls", excel append label ctitle(`x', Mais Educa) 

forvalues j = 1(1)4{

***Controlando pelo Mais educa��o por rigor

reg `x'`xx'_std ice d_uf* d_dep* d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet mais_educ if (ice==0|d_rigor`j'==1) & codigo_uf==`xx' 
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares`xx'.xls", excel append label ctitle(`x', Mais Educa, `j' ) 


}

reg `x'`xx'_std ice d_uf* d_dep* d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet mais_educ if (ice==0|d_rigor4==0) & codigo_uf==`xx' 
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares`xx'.xls" , excel append label ctitle(`x', Mais Educa, com apoio) 
}
}

********************************************
********** RESULTADOS PAINEL FE*************
********************************************


**Amostra total

iis codigo_escola
tis ano

foreach x in "enem_nota_matematica" "enem_nota_ciencias" "enem_nota_humanas" "enem_nota_linguagens" "enem_nota_redacao" "enem_nota_objetivab"{
foreach xx in 26 52 33 35 23 {

capture egen `x'`xx'_std=std(`x') if codigo_uf==`xx' 

*** Sem controles

xtreg `x'`xx'_std d_ice d_ano* if codigo_uf==`xx',fe  
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel`xx'.xls", excel append label ctitle(`x') 
xtreg `x'`xx'_std d_ice d_ano* if dep!=4 & codigo_uf==`xx',fe  
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel`xx'.xls", excel append label ctitle(`x', controle pub)
xtreg `x'`xx'_std d_ice d_ano* if (dep==4|ice==1) & codigo_uf==`xx',fe  
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel`xx'.xls", excel append label ctitle(`x', controle priv)

*** Controlando por caracteristicas do aluno
xtreg `x'`xx'_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria nalunos nbrancos nmulheres if codigo_uf==`xx' , fe 
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel`xx'.xls", excel append label ctitle(`x', aluno)  
xtreg `x'`xx'_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria nalunos nbrancos nmulheres if dep!=4 & codigo_uf==`xx', fe 
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel`xx'.xls", excel append label ctitle(`x', aluno, controle pub)
xtreg `x'`xx'_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria nalunos nbrancos nmulheres if (dep==4|ice==1) & codigo_uf==`xx', fe 
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel`xx'.xls", excel append label ctitle(`x', aluno, controle priv)

***Controlando por carateristicas da escola que independem da escola
xtreg `x'`xx'_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta if codigo_uf==`xx', fe 
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel`xx'.xls", excel append label ctitle(`x', escola1) 
xtreg `x'`xx'_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta if dep!=4 & codigo_uf==`xx', fe 
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel`xx'.xls", excel append label ctitle(`x', escola1, controle pub) 
xtreg `x'`xx'_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta if (dep==4|ice==1) &  codigo_uf==`xx', fe 
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel`xx'.xls", excel append label ctitle(`x', escola1, controle priv) 

***Controlando por demais carateristicas da escola 
xtreg `x'`xx'_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet if codigo_uf==`xx', fe 
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel`xx'.xls", excel append label ctitle(`x', escola2) 
xtreg `x'`xx'_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet if dep!=4 & codigo_uf==`xx', fe 
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel`xx'.xls", excel append label ctitle(`x', escola2, controle pub) 
xtreg `x'`xx'_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet if (dep==4|ice==1) & codigo_uf==`xx', fe 
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel`xx'.xls", excel append label ctitle(`x', escola2, controle priv) 
}
}
********************************************
******* RESULTADOS PAINEL PSCORE************
********************************************

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

foreach x in "enem_nota_matematica" "enem_nota_ciencias" "enem_nota_humanas" "enem_nota_linguagens" "enem_nota_redacao" "enem_nota_objetivab"{
foreach xx in 26 52 35 23 {

capture egen `x'`xx'_std=std(`x') if codigo_uf==`xx' 

*** Sem controles

xtreg `x'`xx'_std d_ice d_ano* [pw=pscore_total] if dep!=4 & codigo_uf==`xx' , fe 
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ps`xx'.xls", excel append label ctitle(`x', sem controle, todas as escolas)

xtreg `x'`xx'_std d_ice d_ano* [pw=pscore_total] if dep!=4&(d_rigor1==1|ice==0)  & codigo_uf  , fe 
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ps`xx'.xls", excel append label ctitle(`x', sem controle, apoio forte)

xtreg `x'`xx'_std d_ice d_ano* [pw=pscore_total] if dep!=4&(d_rigor4==0|ice==0)  & codigo_uf , fe 
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ps`xx'.xls", excel append label ctitle(`x', sem controle, com apoio)

*** Controlando por caracteristicas do aluno
xtreg `x'`xx'_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria nalunos nbrancos nmulheres [pw=pscore_total] if dep!=4  & codigo_uf , fe 
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ps`xx'.xls", excel append label ctitle(`x', aluno, controle pub)

xtreg `x'`xx'_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria nalunos nbrancos nmulheres [pw=pscore_total] if dep!=4&(d_rigor1==1|ice==0)  & codigo_uf, fe 
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ps`xx'.xls", excel append label ctitle(`x', aluno, apoio forte)

xtreg `x'`xx'_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria nalunos nbrancos nmulheres [pw=pscore_total] if dep!=4&(d_rigor4==0|ice==0)  & codigo_uf, fe 
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ps`xx'.xls", excel append label ctitle(`x', aluno, com apoio)

***Controlando por carateristicas da escola que independem da escola
xtreg `x'`xx'_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta [pw=pscore_total] if dep!=4  & codigo_uf, fe 
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ps`xx'.xls", excel append label ctitle(`x', escola1, controle pub) 

xtreg `x'`xx'_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta [pw=pscore_total] if dep!=4&(d_rigor1==1|ice==0)  & codigo_uf, fe 
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ps`xx'.xls", excel append label ctitle(`x', escola1, apoio forte)

xtreg `x'`xx'_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta [pw=pscore_total] if dep!=4&(d_rigor4==0|ice==0)  & codigo_uf , fe 
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ps`xx'.xls", excel append label ctitle(`x', escola1, com apoio)

***Controlando por demais carateristicas da escola 
xtreg `x'`xx'_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4  & codigo_uf, fe 
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ps`xx'.xls", excel append label ctitle(`x', escola2, controle pub) 

xtreg `x'`xx'_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(d_rigor1==1|ice==0) & codigo_uf, fe 
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ps`xx'.xls", excel append label ctitle(`x', escola2, apoio forte)

xtreg `x'`xx'_std d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria nalunos nbrancos nmulheres/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(d_rigor4==0|ice==0) & codigo_uf , fe 
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ps`xx'.xls", excel append label ctitle(`x', escola2, com apoio)

}
}













