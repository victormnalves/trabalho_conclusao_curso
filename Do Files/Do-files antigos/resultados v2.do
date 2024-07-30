
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

foreach x in  "enem_nota_linguagens_std" "enem_nota_redacao_std" "enem_nota_objetivab_std" {


***Controlando por demais carateristicas da escola 
xtreg `x' d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4 , fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ps3.xls", excel append label ctitle(`x', escola2, controle pub) 

xtreg `x' d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(d_rigor1==1|ice==0), fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ps3.xls", excel append label ctitle(`x', escola2, apoio forte)

xtreg `x' d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if dep!=4&(d_rigor4==0|ice==0) , fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ps3.xls", excel append label ctitle(`x', escola2, com apoio)

}


* Adicionais para construção do relatório


foreach x in "enem_nota_linguagens_std" "enem_nota_redacao_std" "enem_nota_objetivab_std" {


***Controlando por demais carateristicas da escola 
xtreg `x' d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] , fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ps_adic3.xls", excel append label ctitle(`x', escola2, geral pub e priv) 

xtreg `x' d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total] if (dep==4|ice==1), fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ps_adic3.xls", excel append label ctitle(`x', escola2, controle priv) 

xtreg `x' d_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca internet mais_educ [pw=pscore_total] if dep!=4, fe cluster(codigo_uf)
outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_preliminares_painel_ps_adic3.xls", excel append label ctitle(`x', escola2, pub mais educ) 


}





