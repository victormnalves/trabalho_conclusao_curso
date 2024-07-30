***************************
******* SÓ PE E CE ********
***************************


************************************************************************************************
******************************** GERAL EM ******************************************************
************************************************************************************************
use "\\fs-eesp-01\EESP\Usuarios\_CHV\ICE\Dados ICE\ice_clean.dta", clear

keep if n_alunos_em_ep>0
drop if codigo_uf==33

gen ice_inte=0
replace ice_inte=1 if integral==1 

gen d_ice_inte=d_ice*ice_inte
gen ice_inte2=ice*ice_inte

bysort codigo_municipio_novo ano: egen n_com_ice=sum(d_ice_inte)
gen m_tem_ice=0
replace m_tem_ice=1 if n_com_ice>0

bysort codigo_municipio_novo: egen n_com_ice2=sum(ice_inte2)
gen m_teve_ice=0
replace m_teve_ice=1 if n_com_ice2>0
drop ice
rename m_teve_ice ice

gen n_alunos_ice_em=0
replace n_alunos_ice_em=n_alunos_em if d_ice==1
gen n_alunos_ice_em_ep=0
replace n_alunos_ice_em_ep=n_alunos_em_ep if d_ice==1


bysort codigo_municipio_novo ano: egen n_alunos_ice_em_total=total(n_alunos_ice_em)
bysort codigo_municipio_novo ano: egen n_alunos_ice_em_ep_total=total(n_alunos_ice_em_ep)

bysort codigo_municipio_novo ano: egen n_alunos_em_total=total(n_alunos_em)
bysort codigo_municipio_novo ano: egen n_alunos_em_ep_total=total(n_alunos_em_ep)

gen prop_alunos_ice_em=n_alunos_ice_em_t/n_alunos_em_t
gen prop_alunos_ice_em_ep=n_alunos_ice_em_ep_t/n_alunos_em_ep_t


drop if d_ice==1
drop if dep==4
collapse (mean) ice codigo_uf taxa_participacao_enem enem_nota_matematica enem_nota_ciencias enem_nota_humanas enem_nota_linguagens enem_nota_redacao enem_nota_objetiva m_tem_ice /*
*/d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca internet n_alunos_em n_alunos_ef n_alunos_ep /*
*/ n_alunos_ef_em n_alunos_em_ep apr_em rep_em aba_em dist_em prop_alunos_ice_em prop_alunos_ice_em_ep, by(codigo_municipio_novo ano)


iis codigo_municipio_novo
tis ano



* Gerar pscores

set matsize 10000


pscore ice n_alunos_em   taxa_participacao_enem if ano==2003&codigo_uf==26, pscore(pscores_pe)

pscore ice n_alunos_em_ep  taxa_participacao_enem if ano==2007&codigo_uf==23, pscore(pscores_ce)

*pscore ice n_alunos_ef if ano==2010&codigo_uf==33, pscore(pscores_rj)

pscore ice n_alunos_em taxa_participacao_enem if ano==2011&codigo_uf==35, pscore(pscores_sp)

pscore ice n_alunos_em  taxa_participacao_enem if ano==2012&codigo_uf==52, pscore(pscores_go)



gen pscore_total=.
replace pscore_total=1 if ice==1

replace pscore_total=1/(1-pscores_pe) if codigo_uf==26&ice==0

replace pscore_total=1/(1-pscores_ce) if codigo_uf==23&ice==0

*replace pscore_total=1/(1-pscores_rj) if codigo_uf==33&ice==0

replace pscore_total=1/(1-pscores_sp) if codigo_uf==35&ice==0

replace pscore_total=1/(1-pscores_go) if codigo_uf==52&ice==0

bysort codigo_municipio_novo: egen pscore_total_aux=max(pscore_total)
replace pscore_total=pscore_total_aux


foreach x in "enem_nota_matematica" "enem_nota_ciencias" "enem_nota_humanas" "enem_nota_linguagens" "apr_em" "rep_em" "aba_em" "dist_em" {
egen `x'_std=std(`x')
}

foreach a in 2003 2004 2005 2006 2007 2008 {
egen enem_nota_redacao_std_aux_`a'=std(enem_nota_redacao) if ano==`a'
}
egen enem_nota_redacao_std=std(enem_nota_redacao) if ano>=2009

foreach a in 2003 2004 2005 2006 2007 2008 {
replace enem_nota_redacao_std=enem_nota_redacao_std_aux_`a' if ano==`a'
}

foreach a in 2003 2004 2005 2006 2007 2008 {
egen enem_nota_objetiva_std_aux_`a'=std(enem_nota_objetiva) if ano==`a'
}

gen enem_nota_objetivab=(enem_nota_matematica +enem_nota_ciencias +enem_nota_humanas+enem_nota_linguagens)/4
egen enem_nota_objetivab_std=std(enem_nota_objetivab) if ano>=2009

foreach a in 2003 2004 2005 2006 2007 2008 {
replace enem_nota_objetivab_std=enem_nota_objetiva_std_aux_`a' if ano==`a'
}

foreach x in  "enem_nota_matematica_std" "enem_nota_ciencias_std" "enem_nota_humanas_std" "enem_nota_linguagens_std" "enem_nota_redacao_std" "enem_nota_objetivab_std" "apr_em_std" "rep_em_std" "aba_em_std" "dist_em_std" {


***Controlando por demais carateristicas da escola 
xtreg `x' prop_alunos_ice_em_ep d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total], fe cluster(codigo_uf)
outreg2 using "\\fs-eesp-01\EESP\Usuarios\_CHV\ICE\Dados ICE\ICE_spill_new.xls", excel append label ctitle(`x', escola2) 

}

************************************************************************************************
******************************** POR ESTADO EM ***************************************
************************************************************************************************
use "\\fs-eesp-01\EESP\Usuarios\_CHV\ICE\Dados ICE\ice_clean.dta", clear

keep if n_alunos_em_ep>0
drop if codigo_uf==33


gen ice_inte=0
replace ice_inte=1 if integral==1 

gen d_ice_inte=d_ice*ice_inte
gen ice_inte2=ice*ice_inte

bysort codigo_municipio_novo ano: egen n_com_ice=sum(d_ice_inte)
gen m_tem_ice=0
replace m_tem_ice=1 if n_com_ice>0

bysort codigo_municipio_novo: egen n_com_ice2=sum(ice_inte2)
gen m_teve_ice=0
replace m_teve_ice=1 if n_com_ice2>0
drop ice
rename m_teve_ice ice

gen n_alunos_ice_em=0
replace n_alunos_ice_em=n_alunos_em if d_ice==1
gen n_alunos_ice_em_ep=0
replace n_alunos_ice_em_ep=n_alunos_em_ep if d_ice==1


bysort codigo_municipio_novo ano: egen n_alunos_ice_em_total=total(n_alunos_ice_em)
bysort codigo_municipio_novo ano: egen n_alunos_ice_em_ep_total=total(n_alunos_ice_em_ep)

bysort codigo_municipio_novo ano: egen n_alunos_em_total=total(n_alunos_em)
bysort codigo_municipio_novo ano: egen n_alunos_em_ep_total=total(n_alunos_em_ep)

gen prop_alunos_ice_em=n_alunos_ice_em_t/n_alunos_em_t
gen prop_alunos_ice_em_ep=n_alunos_ice_em_ep_t/n_alunos_em_ep_t

drop if d_ice==1
drop if dep==4
collapse (mean) ice codigo_uf taxa_participacao_enem enem_nota_matematica enem_nota_ciencias enem_nota_humanas enem_nota_linguagens enem_nota_redacao enem_nota_objetiva m_tem_ice d_ano* e_escol_sup_pai e_escol_sup_mae /*
*/e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca /*
*/ internet n_alunos_em n_alunos_ef n_alunos_ep n_alunos_ef_em n_alunos_em_ep apr_em rep_em aba_em dist_em n_alunos_ice_em n_alunos_ice_em_ep prop_alunos_ice_em prop_alunos_ice_em_ep , by(codigo_municipio_novo ano)


iis codigo_municipio_novo
tis ano


* Gerar pscores

set matsize 10000


pscore ice n_alunos_em  taxa_participacao_enem if ano==2003&codigo_uf==26, pscore(pscores_pe)

pscore ice n_alunos_em_ep taxa_participacao_enem if ano==2007&codigo_uf==23, pscore(pscores_ce)

*pscore ice n_alunos_ef if ano==2010&codigo_uf==33, pscore(pscores_rj)

pscore ice n_alunos_em taxa_participacao_enem if ano==2011&codigo_uf==35, pscore(pscores_sp)

pscore ice n_alunos_em  taxa_participacao_enem if ano==2012&codigo_uf==52, pscore(pscores_go)




gen pscore_total=.
replace pscore_total=1 if ice==1

replace pscore_total=1/(1-pscores_pe) if codigo_uf==26&ice==0

replace pscore_total=1/(1-pscores_ce) if codigo_uf==23&ice==0

*replace pscore_total=1/(1-pscores_rj) if codigo_uf==33&ice==0

replace pscore_total=1/(1-pscores_sp) if codigo_uf==35&ice==0

replace pscore_total=1/(1-pscores_go) if codigo_uf==52&ice==0

bysort codigo_municipio_novo: egen pscore_total_aux=max(pscore_total)
replace pscore_total=pscore_total_aux

gen enem_nota_objetivab=(enem_nota_matematica +enem_nota_ciencias +enem_nota_humanas+enem_nota_linguagens)/4

foreach xx in 26 23 35 52 {

foreach x in "enem_nota_matematica" "enem_nota_ciencias" "enem_nota_humanas" "enem_nota_linguagens" "apr_em" "rep_em" "aba_em" "dist_em" {
egen `x'_std_`xx'=std(`x') if codigo_uf==`xx'
}

foreach a in 2003 2004 2005 2006 2007 2008 {
egen enem_nota_red_std_aux_`a'_`xx'=std(enem_nota_redacao) if ano==`a' & codigo_uf==`xx'
}
egen enem_nota_red_std_`xx'=std(enem_nota_redacao) if ano>=2009 & codigo_uf==`xx'

foreach a in 2003 2004 2005 2006 2007 2008 {
replace enem_nota_red_std_`xx'=enem_nota_red_std_aux_`a'_`xx' if ano==`a' & codigo_uf==`xx'
}

foreach a in 2003 2004 2005 2006 2007 2008 {
egen enem_nota_ob_std_aux_`a'_`xx'=std(enem_nota_objetiva) if ano==`a' & codigo_uf==`xx'
}


egen enem_nota_ob_std_`xx'=std(enem_nota_objetivab) if ano>=2009 & codigo_uf==`xx'

foreach a in 2003 2004 2005 2006 2007 2008 {
replace enem_nota_ob_std_`xx'=enem_nota_ob_std_aux_`a'_`xx' if ano==`a'& codigo_uf==`xx'
}

*"enem_nota_matematica_std" "enem_nota_ciencias_std" "enem_nota_humanas_std" "enem_nota_linguagens_std" "enem_nota_red_std" "apr_em_std"
foreach x in   "enem_nota_ob_std" "rep_em_std" "aba_em_std" "dist_em_std" {


***Controlando por demais carateristicas da escola 
xtreg `x'_`xx' prop_alunos_ice_em_ep d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total], fe 
*outreg2 using "\\fs-eesp-01\EESP\Usuarios\_CHV\ICE\Dados ICE\ICE_spill_uf_new.xls", excel append label ctitle(`x', `xx') 

}
}

************************************************************************************************
******************************** GERAL EF ***************************************
************************************************************************************************
use "\\fs-eesp-01\EESP\Usuarios\_CHV\ICE\Dados ICE\ice_clean.dta", clear

keep if n_alunos_ef>0
keep if codigo_uf==33 | codigo_uf==35

gen ice_inte=0
replace ice_inte=1 if integral==1 

gen d_ice_inte=d_ice*ice_inte
gen ice_inte2=ice*ice_inte

bysort codigo_municipio_novo ano: egen n_com_ice=sum(d_ice_inte)
gen m_tem_ice=0
replace m_tem_ice=1 if n_com_ice>0

bysort codigo_municipio_novo: egen n_com_ice2=sum(ice_inte2)
gen m_teve_ice=0
replace m_teve_ice=1 if n_com_ice2>0
drop ice
rename m_teve_ice ice

gen n_alunos_ice_ef=0
replace n_alunos_ice_ef=n_alunos_ef if ice==1

gen n_alunos_ef_total=n_alunos_ef

drop if d_ice==1
drop if dep==4
collapse (mean) ice codigo_uf taxa_participacao_pb pb_esc_sup_mae pb_esc_sup_pai media_lp_prova_brasil_9 media_mt_prova_brasil_9 media_pb_9 m_tem_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca internet n_alunos_em n_alunos_ef n_alunos_ep n_alunos_ef_em n_alunos_em_ep apr_em rep_em aba_em dist_em (sum) n_alunos_ice_ef n_alunos_ef_t /*
*/ , by(codigo_municipio_novo ano)


iis codigo_municipio_novo
tis ano

gen prop_alunos_ice_ef=n_alunos_ice_ef/n_alunos_ef_t

* Gerar pscores

set matsize 10000


*pscore ice n_alunos_em taxa_participacao_enem if ano==2003&codigo_uf==26, pscore(pscores_pe)

*pscore ice n_alunos_em_ep taxa_participacao_enem if ano==2007&codigo_uf==23, pscore(pscores_ce)

*pscore ice n_alunos_ef taxa_participacao_pb if ano==2010&codigo_uf==33, pscore(pscores_rj)

pscore ice n_alunos_ef taxa_participacao_pb if ano==2011&codigo_uf==35, pscore(pscores_sp)

*pscore ice n_alunos_em taxa_participacao_enem if ano==2012&codigo_uf==52, pscore(pscores_go)


gen pscore_total=.
replace pscore_total=1 if ice==1

*replace pscore_total=1/(1-pscores_pe) if codigo_uf==26&ice==0

*replace pscore_total=1/(1-pscores_ce) if codigo_uf==23&ice==0

*replace pscore_total=1/(1-pscores_rj) if codigo_uf==33&ice==0

replace pscore_total=1/(1-pscores_sp) if codigo_uf==35&ice==0

*replace pscore_total=1/(1-pscores_go) if codigo_uf==52&ice==0

bysort codigo_municipio_novo: egen pscore_total_aux=max(pscore_total)
replace pscore_total=pscore_total_aux


foreach x in "media_lp_prova_brasil_9" "media_mt_prova_brasil_9" "media_pb_9" "apr_em" "rep_em" "aba_em" "dist_em" {
egen `x'_std=std(`x')
}

foreach x in  "media_lp_prova_brasil_9_std" "media_mt_prova_brasil_9_std" "media_pb_9_std" "apr_em_std" "rep_em_std" "aba_em_std" "dist_em_std" {


***Controlando por demais carateristicas da escola 
xtreg `x' m_tem_ice d_ano* pb_esc_sup_mae pb_esc_sup_pai n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet [pw=pscore_total], fe cluster(codigo_uf)
*outreg2 using "E:\CMICRO\_CHV\ICE\Dados ICE\ICE_resultados_spillover_efv3.xls", excel append label ctitle(`x', escola2) 


}

