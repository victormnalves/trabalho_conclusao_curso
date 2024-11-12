/*************************** Base Final - Alternativo *******************************/
/*
mergeando as bases
censo escolar, 
Saeb, 
Prova Brasil, 
Mais educação,
Indicadores do INEP, 
ICE

segundo método, similar a análise anterior
*/


clear all
set more off, permanently

capture log close
global user "`:environment USERPROFILE'"
*global Folder "$user/OneDrive/EESP_ECONOMIA_mestrado_acadêmico/Dissertação/ICE/dados_ICE/Análise_Leonardo"
global Folder "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo"
global output "$Folder/resultados"
global Bases "$Folder/Bases"
global dofiles "$Folder/Do-Files"
global Logfolder "$Folder/Log"
global folderservidor "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"
log using "$folderservidor/new_merge.log", replace



use "$folderservidor\enem\enem_todos_1.dta", clear
merge 1:1 codigo_escola ano using "$folderservidor\saeb_prova_brasil\saeb_todos_1.dta"
drop _m
merge 1:1 codigo_escola ano using "$folderservidor\saeb_prova_brasil\provabrasil_todos_1.dta"
drop _m
merge 1:1 codigo_escola ano using "$folderservidor\indicadores_inep\fluxo_2007a2015.dta"
drop _m

drop if codigo_escola==.
save "$folderservidor\aux_enem_saeb_provabrasil.dta", replace

foreach x in "PE" "CE" "RJ" "SP" "GO" "ES"{
use "$folderservidor\censo_escolar\censo_escolar_`x'_1.dta", clear
drop _m
save "$folderservidor\censo_escolar\censo_escolar_`x'_1.dta", replace
}
use "$folderservidor\aux_enem_saeb_provabrasil.dta"
merge 1:1 codigo_escola ano using "$folderservidor\censo_escolar\censo_escolar_PE_1.dta"
drop if _m==1
drop _m
save "$folderservidor\aux_enem_saeb_provabrasil_censo_pe.dta", replace

use "$folderservidor\aux_enem_saeb_provabrasil.dta"
merge 1:1 codigo_escola ano using "$folderservidor\censo_escolar\censo_escolar_CE_1.dta"
drop if _m==1
drop _m
save "$folderservidor\aux_enem_saeb_provabrasil_censo_ce.dta", replace

use "$folderservidor\aux_enem_saeb_provabrasil.dta"
merge 1:1 codigo_escola ano using "$folderservidor\censo_escolar\censo_escolar_RJ_1.dta"
drop if _m==1
drop _m
save "$folderservidor\aux_enem_saeb_provabrasil_censo_rj.dta", replace

use "$folderservidor\aux_enem_saeb_provabrasil.dta"
merge 1:1 codigo_escola ano using "$folderservidor\censo_escolar\censo_escolar_SP_1.dta"
drop if _m==1
drop _m
save "$folderservidor\aux_enem_saeb_provabrasil_censo_sp.dta", replace

use "$folderservidor\aux_enem_saeb_provabrasil.dta"
merge 1:1 codigo_escola ano using "$folderservidor\censo_escolar\censo_escolar_GO_1.dta"
drop if _m==1
drop _m
save "$folderservidor\aux_enem_saeb_provabrasil_censo_go.dta", replace

use "$folderservidor\aux_enem_saeb_provabrasil.dta"
merge 1:1 codigo_escola ano using "$folderservidor\censo_escolar\censo_escolar_ES_1.dta"
drop if _m==1
drop _m
save "$folderservidor\aux_enem_saeb_provabrasil_censo_es.dta", replace


*************************************************************
**************************Merge final nota************************
*************************************************************
/*use "$folderservidor\\base_final_ice_nota.dta", clear
drop _m
save "$folderservidor\\base_final_ice_nota.dta", replace */
***************************
*********** PE ************
***************************
clear
use "$folderservidor\\base_final_ice_nota.dta"
keep if uf=="PE"
merge 1:1 codigo_escola using "$folderservidor\\mais_educacao_todos.dta"
drop _merge
merge 1:m codigo_escola using "$folderservidor\aux_enem_saeb_provabrasil_censo_pe.dta"
drop _merge
keep if UF=="Pernambuco" | sigla=="PE" | codigo_uf==26 | ice_2004==1 | ice_2005==1 | ice_2006==1 | ice_2007==1 | ice_2008==1| ice_2009==1| ice_2010==1| ice_2011==1| ice_2012==1| ice_2013==1| ice_2014==1| ice_2015==1

save "$folderservidor\ice_completo_pe_nota.dta", replace

***************************
*********** CE ************
***************************
clear
use "$folderservidor\base_final_ice_nota.dta"
keep if uf=="CE"
* inserir codigos de escola se chegarem
drop if codigo_escola==.
merge 1:1 codigo_escola using "$folderservidor\mais_educacao_todos.dta"
drop _merge
merge 1:m codigo_escola using "$folderservidor\aux_enem_saeb_provabrasil_censo_ce.dta"
drop _merge
keep if sigla=="CE" | codigo_uf==23 | ice_2004==1 | ice_2005==1 | ice_2006==1 | ice_2007==1 | ice_2008==1| ice_2009==1| ice_2010==1| ice_2011==1| ice_2012==1| ice_2013==1| ice_2014==1| ice_2015==1

save "$folderservidor\ice_completo_ce_nota.dta", replace

***************************
*********** RJ ************
***************************
clear
use "$folderservidor\base_final_ice_nota.dta"
keep if uf=="RJ"
* inserir codigos de escola se chegarem
drop if codigo_escola==.
merge 1:1 codigo_escola using "$folderservidor\\mais_educacao_todos.dta"
drop _merge
merge 1:m codigo_escola using "$folderservidor\aux_enem_saeb_provabrasil_censo_rj.dta"
drop _merge
keep if sigla=="RJ" | codigo_uf==33 | ice_2004==1 | ice_2005==1 | ice_2006==1 | ice_2007==1 | ice_2008==1| ice_2009==1| ice_2010==1| ice_2011==1| ice_2012==1| ice_2013==1| ice_2014==1| ice_2015==1

save "$folderservidor\ice_completo_rj_nota.dta", replace

***************************
*********** SP ************
***************************
clear
use "$folderservidor\base_final_ice_nota.dta"
keep if uf=="SP"
* inserir codigos de escola se chegarem
drop if codigo_escola==.
* para retirar duplicata, vou remover a escola em que foi implementado em 2015 pois nao da para avaliar

merge 1:1 codigo_escola using "$folderservidor\mais_educacao_todos.dta"
drop _merge
merge 1:m codigo_escola using "$folderservidor\aux_enem_saeb_provabrasil_censo_sp.dta"
drop _merge
keep if sigla=="SP" | codigo_uf==35 | ice_2004==1 | ice_2005==1 | ice_2006==1 | ice_2007==1 | ice_2008==1| ice_2009==1| ice_2010==1| ice_2011==1| ice_2012==1| ice_2013==1| ice_2014==1| ice_2015==1

save "$folderservidor\ice_completo_sp_nota.dta", replace

***************************
*********** GO ************
***************************
clear
use "$folderservidor\base_final_ice_nota.dta"
keep if uf=="GO"
* inserir codigos de escola se chegarem
drop if codigo_escola==.
merge 1:1 codigo_escola using "$folderservidor\\mais_educacao_todos.dta"
drop _merge
merge 1:m codigo_escola using "$folderservidor\aux_enem_saeb_provabrasil_censo_go.dta"
drop _merge
keep if sigla=="GO" | codigo_uf==52 | ice_2004==1 | ice_2005==1 | ice_2006==1 | ice_2007==1 | ice_2008==1| ice_2009==1| ice_2010==1| ice_2011==1| ice_2012==1| ice_2013==1| ice_2014==1| ice_2015==1

save "$folderservidor\\ice_completo_go_nota.dta", replace

***************************
*********** ES ************
***************************
clear
use "$folderservidor\base_final_ice_nota.dta"
keep if uf=="ES"
* inserir codigos de escola se chegarem
drop if codigo_escola==.
merge 1:1 codigo_escola using "$folderservidor\\mais_educacao_todos.dta"
drop _merge
merge 1:m codigo_escola using "$folderservidor\aux_enem_saeb_provabrasil_censo_es.dta"
drop _merge
keep if sigla=="ES" | codigo_uf==32 | ice_2004==1 | ice_2005==1 | ice_2006==1 | ice_2007==1 | ice_2008==1| ice_2009==1| ice_2010==1| ice_2011==1| ice_2012==1| ice_2013==1| ice_2014==1| ice_2015==1

save "$folderservidor\\ice_completo_es_nota.dta", replace




*************************************************************
**************************Merge final fluxo************************
*************************************************************
/*use "$folderservidor\\base_final_ice_fluxo.dta", clear
drop _m
save "$folderservidor\\base_final_ice_fluxo.dta", replace*/
***************************
*********** PE ************
***************************
clear
use "$folderservidor\\base_final_ice_fluxo.dta"
keep if uf=="PE"
merge 1:1 codigo_escola using "$folderservidor\\mais_educacao_todos.dta"
drop _merge
merge 1:m codigo_escola using "$folderservidor\aux_enem_saeb_provabrasil_censo_pe.dta"
drop _merge
keep if UF=="Pernambuco" | sigla=="PE" | codigo_uf==26 | ice_2004==1 | ice_2005==1 | ice_2006==1 | ice_2007==1 | ice_2008==1| ice_2009==1| ice_2010==1| ice_2011==1| ice_2012==1| ice_2013==1| ice_2014==1| ice_2015==1

save "$folderservidor\ice_completo_pe_fluxo.dta", replace

***************************
*********** CE ************
***************************
clear
use "$folderservidor\base_final_ice_fluxo.dta"
keep if uf=="CE"
* inserir codigos de escola se chegarem
drop if codigo_escola==.
merge 1:1 codigo_escola using "$folderservidor\mais_educacao_todos.dta"
drop _merge
merge 1:m codigo_escola using "$folderservidor\aux_enem_saeb_provabrasil_censo_ce.dta"
drop _merge
keep if sigla=="CE" | codigo_uf==23 | ice_2004==1 | ice_2005==1 | ice_2006==1 | ice_2007==1 | ice_2008==1| ice_2009==1| ice_2010==1| ice_2011==1| ice_2012==1| ice_2013==1| ice_2014==1| ice_2015==1

save "$folderservidor\ice_completo_ce_fluxo.dta", replace

***************************
*********** RJ ************
***************************
clear
use "$folderservidor\base_final_ice_fluxo.dta"
keep if uf=="RJ"
* inserir codigos de escola se chegarem
drop if codigo_escola==.
merge 1:1 codigo_escola using "$folderservidor\\mais_educacao_todos.dta"
drop _merge
merge 1:m codigo_escola using "$folderservidor\aux_enem_saeb_provabrasil_censo_rj.dta"
drop _merge
keep if sigla=="RJ" | codigo_uf==33 | ice_2004==1 | ice_2005==1 | ice_2006==1 | ice_2007==1 | ice_2008==1| ice_2009==1| ice_2010==1| ice_2011==1| ice_2012==1| ice_2013==1| ice_2014==1| ice_2015==1

save "$folderservidor\ice_completo_rj_fluxo.dta", replace

***************************
*********** SP ************
***************************
clear
use "$folderservidor\base_final_ice_fluxo.dta"
keep if uf=="SP"
* inserir codigos de escola se chegarem
drop if codigo_escola==.
* para retirar duplicata, vou remover a escola em que foi implementado em 2015 pois nao da para avaliar

merge 1:1 codigo_escola using "$folderservidor\mais_educacao_todos.dta"
drop _merge
merge 1:m codigo_escola using "$folderservidor\aux_enem_saeb_provabrasil_censo_sp.dta"
drop _merge
keep if sigla=="SP" | codigo_uf==35 | ice_2004==1 | ice_2005==1 | ice_2006==1 | ice_2007==1 | ice_2008==1| ice_2009==1| ice_2010==1| ice_2011==1| ice_2012==1| ice_2013==1| ice_2014==1| ice_2015==1

save "$folderservidor\ice_completo_sp_fluxo.dta", replace

***************************
*********** GO ************
***************************
clear
use "$folderservidor\base_final_ice_fluxo.dta"
keep if uf=="GO"
* inserir codigos de escola se chegarem
drop if codigo_escola==.
merge 1:1 codigo_escola using "$folderservidor\\mais_educacao_todos.dta"
drop _merge
merge 1:m codigo_escola using "$folderservidor\aux_enem_saeb_provabrasil_censo_go.dta"
drop _merge
keep if sigla=="GO" | codigo_uf==52 | ice_2004==1 | ice_2005==1 | ice_2006==1 | ice_2007==1 | ice_2008==1| ice_2009==1| ice_2010==1| ice_2011==1| ice_2012==1| ice_2013==1| ice_2014==1| ice_2015==1

save "$folderservidor\\ice_completo_go_fluxo.dta", replace

***************************
*********** ES ************
***************************
clear
use "$folderservidor\base_final_ice_fluxo.dta"
keep if uf=="ES"
* inserir codigos de escola se chegarem
drop if codigo_escola==.
merge 1:1 codigo_escola using "$folderservidor\\mais_educacao_todos.dta"
drop _merge
merge 1:m codigo_escola using "$folderservidor\aux_enem_saeb_provabrasil_censo_es.dta"
drop _merge
keep if sigla=="ES" | codigo_uf==32 | ice_2004==1 | ice_2005==1 | ice_2006==1 | ice_2007==1 | ice_2008==1| ice_2009==1| ice_2010==1| ice_2011==1| ice_2012==1| ice_2013==1| ice_2014==1| ice_2015==1

save "$folderservidor\\ice_completo_es_fluxo.dta", replace



*************************************************************
*************************** Append Nota **************************
*************************************************************



*************************************************************
*************************** Append Nota **************************
*************************************************************

use "$folderservidor\ice_completo_go_nota.dta", clear

local x "pe rj ce sp es"

foreach i in `x'{
append using "$folderservidor\ice_completo_`i'_nota"
}

****************************************************************************************************************************
****************************************************************************************************************************
****************************************************************************************************************************

************* Gerar UFs ***********
replace ice=0 if ice==.

replace codigo_uf=26 if sigla=="PE" |uf=="PE"|UF=="Pernambuco"
replace codigo_uf=23 if sigla=="CE" |uf=="CE"|UF=="Ceará"|UF=="Ceara"
replace codigo_uf=35 if sigla=="SP" |uf=="SP"|UF=="São Paulo"|UF=="Sao Paulo"
replace codigo_uf=33 if sigla=="RJ" |uf=="RJ"|UF=="Rio de Janeiro"
replace codigo_uf=52 if sigla=="GO" |uf=="GO"|UF=="Goiás"|UF=="Goias"
replace codigo_uf=32 if sigla=="ES" | uf=="ES"|UF=="Espirito Santo"
***** Padronizar codigos de municipio ***

tostring codigo_municipio, gen(codigo_municipios) format(%20.0g) 
gen cod_aux1=substr(codigo_municipios,1,2) 
gen cod_aux2=substr(codigo_municipios,8,4)
gen cod_aux3=cod_aux1+cod_aux2

rename codigo_municipio codigo_municipio_enorme
rename cod_aux3 codigo_municipio
destring codigo_municipio, replace

merge m:1 codigo_municipio using "$folderservidor\cod_munic.dta"
drop if _merge==2
replace codigo_municipio_novo=ufmundv if codigo_municipio_novo==.

**** Dependencia Administrativa *****

qui tab dep, gen(d_dep)

**** Mais Educacaoo ***

gen mais_educ=0

foreach x of varlist mais_educacao_fund_2010- mais_educacao_x_2009 n_turmas_mais_educ_em_1- n_turmas_mais_educ_em_3 n_turmas_mais_educ_fund_5_8anos- n_turmas_mais_educ_fund_9_9anos n_turmas_mais_educ_em_inte_1- n_turmas_mais_educ_em_inte_ns{
replace mais_educ=1 if `x'>0&`x'!=.
}

**** Rigor do ICE ****
replace ice_rigor="Sem Apoio" if ice_rigor==""&ice==1

tab ice_rigor if ice==1, gen(d_rigor)


gen media_pb_9=(media_lp_prova_brasil_9+ media_mt_prova_brasil_9)/2

******* Padronizacao das notas *****

foreach x in "enem_nota_matematica" "enem_nota_ciencias" "enem_nota_humanas" "enem_nota_linguagens" "media_lp_prova_brasil_9" "media_mt_prova_brasil_9" "media_pb_9" "apr_ef" "apr_em" "rep_ef" "rep_em" "aba_ef" "aba_em" "dist_ef" "dist_em" {
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



******* Padronizacao das notas por UF *****

foreach xx in 26 52 35 23 33 {
foreach x in "enem_nota_matematica" "enem_nota_ciencias" "enem_nota_humanas" "enem_nota_linguagens" "media_lp_prova_brasil_9" "media_mt_prova_brasil_9" "media_pb_9" "apr_ef" "apr_em" "rep_ef" "rep_em" "aba_ef" "aba_em" "dist_ef" "dist_em" {

capture egen `x'`xx'_std=std(`x') if codigo_uf==`xx' 
}
}

foreach xx in 26 52 35 23 33 {
foreach a in 2003 2004 2005 2006 2007 2008 {
capture egen enem_nota_redacao`xx'_std_aux_`a'=std(enem_nota_redacao) if ano==`a' & codigo_uf==`xx'
}
capture egen enem_nota_redacao`xx'_std=std(enem_nota_redacao) if ano>=2009 & codigo_uf==`xx'

foreach a in 2003 2004 2005 2006 2007 2008 {
replace enem_nota_redacao`xx'_std=enem_nota_redacao_std_aux_`a' if ano==`a' & codigo_uf==`xx'
}

foreach a in 2003 2004 2005 2006 2007 2008 {
capture egen enem_nota_objetiva`xx'_std_aux_`a'=std(enem_nota_objetiva) if ano==`a' & codigo_uf==`xx'
}

gen enem_nota_objetivab`xx'=(enem_nota_matematica +enem_nota_ciencias +enem_nota_humanas+enem_nota_linguagens)/4 if codigo_uf==`xx'
capture egen enem_nota_objetivab`xx'_std=std(enem_nota_objetivab) if ano>=2009 & codigo_uf==`xx'

foreach a in 2003 2004 2005 2006 2007 2008 {
replace enem_nota_objetivab`xx'_std=enem_nota_objetiva_std_aux_`a' if ano==`a' & codigo_uf==`xx'

}
}



*save "$folderservidor\ice_clean.dta", replace

* Em 2010, a pergunta no enem sobre renda familiar foi diferente dos outros anos. Consertar

replace e_renda_familia_5_salarios=e_renda_familia_6_salarios if ano==2010

* Calcular numero de alunos por ciclo de ensino contemplado pelo programa

forvalues x=1(1)3{
replace n_alunos_em_`x'=0 if n_alunos_em_`x'==.
replace n_mulheres_em_`x'=0 if n_mulheres_em_`x'==.
replace n_brancos_em_`x'=0 if n_brancos_em_`x'==.
}

gen n_alunos_em=n_alunos_em_1+n_alunos_em_2 +n_alunos_em_3
replace n_alunos_em=0 if n_alunos_em==.
gen n_mulheres_em=n_mulheres_em_1+n_mulheres_em_2 +n_mulheres_em_3
replace n_mulheres_em=0 if n_mulheres_em==.
gen n_brancos_em=n_brancos_em_1+n_brancos_em_2 +n_brancos_em_3
replace n_brancos_em=0 if n_brancos_em==.

forvalues x=8(1)9{
forvalues i=5(1)9{
capture replace n_alunos_fund_`x'_`i'anos=0 if n_alunos_fund_`x'_`i'anos==.
capture replace n_mulheres_fund_`x'=0 if n_mulheres_fund_`x'==.
capture replace n_brancos_fund_`x'=0 if n_brancos_fund_`x'==.
}
}

gen n_alunos_ef=n_alunos_fund_5_8anos+ n_alunos_fund_6_8anos +n_alunos_fund_7_8anos +n_alunos_fund_8_8anos +n_alunos_fund_6_9anos +n_alunos_fund_7_9anos +n_alunos_fund_8_9anos +n_alunos_fund_9_9anos
replace n_alunos_ef=0 if n_alunos_ef==.
gen n_mulheres_ef=n_mulheres_fund_5_8anos+ n_mulheres_fund_6_8anos +n_mulheres_fund_7_8anos +n_mulheres_fund_8_8anos +n_mulheres_fund_6_9anos +n_mulheres_fund_7_9anos +n_mulheres_fund_8_9anos +n_mulheres_fund_9_9anos
replace n_mulheres_ef=0 if n_mulheres_ef==.
gen n_brancos_ef=n_brancos_fund_5_8anos+ n_brancos_fund_6_8anos +n_brancos_fund_7_8anos +n_brancos_fund_8_8anos +n_brancos_fund_6_9anos +n_brancos_fund_7_9anos +n_brancos_fund_8_9anos +n_brancos_fund_9_9anos
replace n_brancos_ef=0 if n_brancos_ef==.

foreach x in "1" "2" "3" "4" "ns"{
replace n_alunos_em_inte_`x'=0 if n_alunos_em_inte_`x'==.
replace n_mulheres_em_inte_`x'=0 if n_mulheres_em_inte_`x'==.
replace n_brancos_em_inte_`x'=0 if n_brancos_em_inte_`x'==.

}

gen n_alunos_ep=n_alunos_em_inte_1+ n_alunos_em_inte_2+ n_alunos_em_inte_3 +n_alunos_em_inte_4 +n_alunos_em_inte_ns
replace n_alunos_ep=0 if n_alunos_ep==.
gen n_mulheres_ep=n_mulheres_em_inte_1+ n_mulheres_em_inte_2+ n_mulheres_em_inte_3 +n_mulheres_em_inte_4 +n_mulheres_em_inte_ns
replace n_mulheres_ep=0 if n_mulheres_ep==.
gen n_brancos_ep=n_brancos_em_inte_1+ n_brancos_em_inte_2+ n_brancos_em_inte_3 +n_brancos_em_inte_4 +n_brancos_em_inte_ns
replace n_brancos_ep=0 if n_brancos_ep==.

gen n_alunos_ef_em=n_alunos_ef+n_alunos_em
gen n_alunos_em_ep=n_alunos_em+n_alunos_ep

gen n_alunos_ef_em_ep=n_alunos_ef+n_alunos_em+n_alunos_ep
gen n_mulheres_ef_em_ep=n_mulheres_ef+n_mulheres_em+n_mulheres_ep
gen n_brancos_ef_em_ep=n_brancos_ef+n_brancos_em+n_brancos_ep

*Gerar variavel de ano de entrada da escola no programa

gen d_ice=0



forvalues x=2004(1)2015{
replace d_ice=1 if ice_`x'==1 &ano==`x' 
}



tab codigo_uf, gen(d_uf)
tab ano, gen(d_ano)
********** Construcao da variavel de numero de alunos para regressao por estado*********
gen nalunos=.
replace nalunos=n_alunos_em if codigo_uf==26
replace nalunos=n_alunos_em if codigo_uf==52
replace nalunos=n_alunos_ef if codigo_uf==33
replace nalunos=n_alunos_ef_em if codigo_uf==35
replace nalunos=n_alunos_ep if codigo_uf==23
replace nalunos=. if nalunos==0

gen nmulheres=.
replace nmulheres=n_mulheres_em if codigo_uf==26
replace nmulheres=n_mulheres_em if codigo_uf==52
replace nmulheres=n_mulheres_ef if codigo_uf==33
replace nmulheres=n_mulheres_ef_em if codigo_uf==35
replace nmulheres=n_mulheres_ep if codigo_uf==23
replace nmulheres=. if nmulheres==0

gen nbrancos=.
replace nbrancos=n_brancos_em if codigo_uf==26
replace nbrancos=n_brancos_em if codigo_uf==52
replace nbrancos=n_brancos_ef if codigo_uf==33
replace nbrancos=n_brancos_ef_em if codigo_uf==35
replace nbrancos=n_brancos_ep if codigo_uf==23
replace nbrancos=. if nbrancos==0


******* Taxas de Participacao no ENEM e na Prova Brasil **********

**** ENEM ****
replace concluir_em_ano_enem=0 if concluir_em_ano_enem==.
*gen taxa_participacao_enem=taxa_participacao_enem/100
gen taxa_participacao_enem_aux=concluir_em_ano_enem/n_alunos_em_3
gen taxa_participacao_enem_aux2=concluir_em_ano_enem/(n_alunos_em_inte_3+n_alunos_em_3) if codigo_uf==23

gen taxa_participacao_enem=taxa_participacao_enem_aux
replace taxa_participacao_enem=taxa_participacao_enem_aux2 if codigo_uf==23

**** Prova Brasil ****
replace pb_n_partic_9=0 if pb_n_partic_9==.
replace pb_tx_partic_9=pb_tx_partic_9/100 if ano==2011
rename pb_tx_partic_9 taxa_participacao_pb_9
gen taxa_participacao_pb_aux_9=pb_n_partic_9/(n_alunos_fund_8_8anos+n_alunos_fund_9_9anos) if ano==2009
replace taxa_participacao_pb_9=taxa_participacao_pb_aux_9 if ano==2009

replace pb_n_partic_5=0 if pb_n_partic_5==.
replace pb_tx_partic_5=pb_tx_partic_5/100 if ano==2011
rename pb_tx_partic_5 taxa_participacao_pb_5


*save "$folderservidor\ice_clean_nota.dta", replace

*drop e_trabalhou_ou_procurou- e_ajuda_esc_profissao_muito mascara2003- s_exp_prof_escola_mais_3_9 n_turmas_em_1- p_profs_sup_em_3 n_profs_em- cod_aux2




save "$folderservidor\ice_clean_notas.dta", replace





*************************************************************
*************************** Append FLUXO **************************
*************************************************************

use "$folderservidor\ice_completo_go_fluxo.dta", clear

local x "pe rj ce sp es"

foreach i in `x'{
append using "$folderservidor\ice_completo_`i'_fluxo"
}

****************************************************************************************************************************
****************************************************************************************************************************
****************************************************************************************************************************

************* Gerar UFs ***********
replace ice=0 if ice==.

replace codigo_uf=26 if sigla=="PE" |uf=="PE"|UF=="Pernambuco"
replace codigo_uf=23 if sigla=="CE" |uf=="CE"|UF=="Ceará"|UF=="Ceara"
replace codigo_uf=35 if sigla=="SP" |uf=="SP"|UF=="São Paulo"|UF=="Sao Paulo"
replace codigo_uf=33 if sigla=="RJ" |uf=="RJ"|UF=="Rio de Janeiro"
replace codigo_uf=52 if sigla=="GO" |uf=="GO"|UF=="Goiás"|UF=="Goias"
replace codigo_uf=32 if sigla=="ES" | uf=="ES"|UF=="Espirito Santo"
***** Padronizar codigos de municipio ***

tostring codigo_municipio, gen(codigo_municipios) format(%20.0g) 
gen cod_aux1=substr(codigo_municipios,1,2) 
gen cod_aux2=substr(codigo_municipios,8,4)
gen cod_aux3=cod_aux1+cod_aux2

rename codigo_municipio codigo_municipio_enorme
rename cod_aux3 codigo_municipio
destring codigo_municipio, replace

merge m:1 codigo_municipio using "$folderservidor\cod_munic.dta"
drop if _merge==2
replace codigo_municipio_novo=ufmundv if codigo_municipio_novo==.

**** Dependencia Administrativa *****

qui tab dep, gen(d_dep)

**** Mais Educacaoo ***

gen mais_educ=0

foreach x of varlist mais_educacao_fund_2010- mais_educacao_x_2009 n_turmas_mais_educ_em_1- n_turmas_mais_educ_em_3 n_turmas_mais_educ_fund_5_8anos- n_turmas_mais_educ_fund_9_9anos n_turmas_mais_educ_em_inte_1- n_turmas_mais_educ_em_inte_ns{
replace mais_educ=1 if `x'>0&`x'!=.
}

**** Rigor do ICE ****
replace ice_rigor="Sem Apoio" if ice_rigor==""&ice==1

tab ice_rigor if ice==1, gen(d_rigor)


gen media_pb_9=(media_lp_prova_brasil_9+ media_mt_prova_brasil_9)/2

******* Padronizacao das notas *****

foreach x in "enem_nota_matematica" "enem_nota_ciencias" "enem_nota_humanas" "enem_nota_linguagens" "media_lp_prova_brasil_9" "media_mt_prova_brasil_9" "media_pb_9" "apr_ef" "apr_em" "rep_ef" "rep_em" "aba_ef" "aba_em" "dist_ef" "dist_em" {
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



******* Padronizacao das notas por UF *****

foreach xx in 26 52 35 23 33 {
foreach x in "enem_nota_matematica" "enem_nota_ciencias" "enem_nota_humanas" "enem_nota_linguagens" "media_lp_prova_brasil_9" "media_mt_prova_brasil_9" "media_pb_9" "apr_ef" "apr_em" "rep_ef" "rep_em" "aba_ef" "aba_em" "dist_ef" "dist_em" {

capture egen `x'`xx'_std=std(`x') if codigo_uf==`xx' 
}
}

foreach xx in 26 52 35 23 33 {
foreach a in 2003 2004 2005 2006 2007 2008 {
capture egen enem_nota_redacao`xx'_std_aux_`a'=std(enem_nota_redacao) if ano==`a' & codigo_uf==`xx'
}
capture egen enem_nota_redacao`xx'_std=std(enem_nota_redacao) if ano>=2009 & codigo_uf==`xx'

foreach a in 2003 2004 2005 2006 2007 2008 {
replace enem_nota_redacao`xx'_std=enem_nota_redacao_std_aux_`a' if ano==`a' & codigo_uf==`xx'
}

foreach a in 2003 2004 2005 2006 2007 2008 {
capture egen enem_nota_objetiva`xx'_std_aux_`a'=std(enem_nota_objetiva) if ano==`a' & codigo_uf==`xx'
}

gen enem_nota_objetivab`xx'=(enem_nota_matematica +enem_nota_ciencias +enem_nota_humanas+enem_nota_linguagens)/4 if codigo_uf==`xx'
capture egen enem_nota_objetivab`xx'_std=std(enem_nota_objetivab) if ano>=2009 & codigo_uf==`xx'

foreach a in 2003 2004 2005 2006 2007 2008 {
replace enem_nota_objetivab`xx'_std=enem_nota_objetiva_std_aux_`a' if ano==`a' & codigo_uf==`xx'

}
}



*save "$folderservidor\ice_clean.dta", replace

* Em 2010, a pergunta no enem sobre renda familiar foi diferente dos outros anos. Consertar

replace e_renda_familia_5_salarios=e_renda_familia_6_salarios if ano==2010

* Calcular numero de alunos por ciclo de ensino contemplado pelo programa

forvalues x=1(1)3{
replace n_alunos_em_`x'=0 if n_alunos_em_`x'==.
replace n_mulheres_em_`x'=0 if n_mulheres_em_`x'==.
replace n_brancos_em_`x'=0 if n_brancos_em_`x'==.
}

gen n_alunos_em=n_alunos_em_1+n_alunos_em_2 +n_alunos_em_3
replace n_alunos_em=0 if n_alunos_em==.
gen n_mulheres_em=n_mulheres_em_1+n_mulheres_em_2 +n_mulheres_em_3
replace n_mulheres_em=0 if n_mulheres_em==.
gen n_brancos_em=n_brancos_em_1+n_brancos_em_2 +n_brancos_em_3
replace n_brancos_em=0 if n_brancos_em==.

forvalues x=8(1)9{
forvalues i=5(1)9{
capture replace n_alunos_fund_`x'_`i'anos=0 if n_alunos_fund_`x'_`i'anos==.
capture replace n_mulheres_fund_`x'=0 if n_mulheres_fund_`x'==.
capture replace n_brancos_fund_`x'=0 if n_brancos_fund_`x'==.
}
}

gen n_alunos_ef=n_alunos_fund_5_8anos+ n_alunos_fund_6_8anos +n_alunos_fund_7_8anos +n_alunos_fund_8_8anos +n_alunos_fund_6_9anos +n_alunos_fund_7_9anos +n_alunos_fund_8_9anos +n_alunos_fund_9_9anos
replace n_alunos_ef=0 if n_alunos_ef==.
gen n_mulheres_ef=n_mulheres_fund_5_8anos+ n_mulheres_fund_6_8anos +n_mulheres_fund_7_8anos +n_mulheres_fund_8_8anos +n_mulheres_fund_6_9anos +n_mulheres_fund_7_9anos +n_mulheres_fund_8_9anos +n_mulheres_fund_9_9anos
replace n_mulheres_ef=0 if n_mulheres_ef==.
gen n_brancos_ef=n_brancos_fund_5_8anos+ n_brancos_fund_6_8anos +n_brancos_fund_7_8anos +n_brancos_fund_8_8anos +n_brancos_fund_6_9anos +n_brancos_fund_7_9anos +n_brancos_fund_8_9anos +n_brancos_fund_9_9anos
replace n_brancos_ef=0 if n_brancos_ef==.

foreach x in "1" "2" "3" "4" "ns"{
replace n_alunos_em_inte_`x'=0 if n_alunos_em_inte_`x'==.
replace n_mulheres_em_inte_`x'=0 if n_mulheres_em_inte_`x'==.
replace n_brancos_em_inte_`x'=0 if n_brancos_em_inte_`x'==.

}

gen n_alunos_ep=n_alunos_em_inte_1+ n_alunos_em_inte_2+ n_alunos_em_inte_3 +n_alunos_em_inte_4 +n_alunos_em_inte_ns
replace n_alunos_ep=0 if n_alunos_ep==.
gen n_mulheres_ep=n_mulheres_em_inte_1+ n_mulheres_em_inte_2+ n_mulheres_em_inte_3 +n_mulheres_em_inte_4 +n_mulheres_em_inte_ns
replace n_mulheres_ep=0 if n_mulheres_ep==.
gen n_brancos_ep=n_brancos_em_inte_1+ n_brancos_em_inte_2+ n_brancos_em_inte_3 +n_brancos_em_inte_4 +n_brancos_em_inte_ns
replace n_brancos_ep=0 if n_brancos_ep==.

gen n_alunos_ef_em=n_alunos_ef+n_alunos_em
gen n_alunos_em_ep=n_alunos_em+n_alunos_ep

gen n_mulheres_em_ep = n_mulheres_em+n_mulheres_ep
gen n_brancos_em_ep = +n_brancos_em+n_brancos_ep

gen n_alunos_ef_em_ep=n_alunos_ef+n_alunos_em+n_alunos_ep
gen n_mulheres_ef_em_ep=n_mulheres_ef+n_mulheres_em+n_mulheres_ep
gen n_brancos_ef_em_ep=n_brancos_ef+n_brancos_em+n_brancos_ep

*Gerar variavel de ano de entrana da escola no programa

gen d_ice=0

tab ano, gen(d_ano)

forvalues x=2004(1)2015{
replace d_ice=1 if ice_`x'==1 &ano==`x' 
}



tab codigo_uf, gen(d_uf)

********** Construcao da variavel de numero de alunos para regressao por estado*********
gen nalunos=.
replace nalunos=n_alunos_em if codigo_uf==26
replace nalunos=n_alunos_em if codigo_uf==52
replace nalunos=n_alunos_ef if codigo_uf==33
replace nalunos=n_alunos_ef_em if codigo_uf==35
replace nalunos=n_alunos_ep if codigo_uf==23
replace nalunos=. if nalunos==0

gen nmulheres=.
replace nmulheres=n_mulheres_em if codigo_uf==26
replace nmulheres=n_mulheres_em if codigo_uf==52
replace nmulheres=n_mulheres_ef if codigo_uf==33
replace nmulheres=n_mulheres_ef_em if codigo_uf==35
replace nmulheres=n_mulheres_ep if codigo_uf==23
replace nmulheres=. if nmulheres==0

gen nbrancos=.
replace nbrancos=n_brancos_em if codigo_uf==26
replace nbrancos=n_brancos_em if codigo_uf==52
replace nbrancos=n_brancos_ef if codigo_uf==33
replace nbrancos=n_brancos_ef_em if codigo_uf==35
replace nbrancos=n_brancos_ep if codigo_uf==23
replace nbrancos=. if nbrancos==0


******* Taxas de Participacao no ENEM e na Prova Brasil **********

**** ENEM ****
replace concluir_em_ano_enem=0 if concluir_em_ano_enem==.
*gen taxa_participacao_enem=taxa_participacao_enem/100
gen taxa_participacao_enem_aux=concluir_em_ano_enem/n_alunos_em_3
gen taxa_participacao_enem_aux2=concluir_em_ano_enem/(n_alunos_em_inte_3+n_alunos_em_3) if codigo_uf==23

gen taxa_participacao_enem=taxa_participacao_enem_aux
replace taxa_participacao_enem=taxa_participacao_enem_aux2 if codigo_uf==23

**** Prova Brasil ****


replace pb_n_partic_9=0 if pb_n_partic_9==.
replace pb_tx_partic_9=pb_tx_partic_9/100 if ano==2011
rename pb_tx_partic_9 taxa_participacao_pb_9
gen taxa_participacao_pb_aux_9=pb_n_partic_9/(n_alunos_fund_8_8anos+n_alunos_fund_9_9anos) if ano==2009
replace taxa_participacao_pb_9=taxa_participacao_pb_aux_9 if ano==2009

replace pb_n_partic_5=0 if pb_n_partic_5==.
replace pb_tx_partic_5=pb_tx_partic_5/100 if ano==2011
rename pb_tx_partic_5 taxa_participacao_pb_5





*drop e_trabalhou_ou_procurou- e_ajuda_esc_profissao_muito mascara2003- s_exp_prof_escola_mais_3_9  n_turmas_em_1- p_profs_sup_em_3 n_profs_em- cod_aux2




save "$folderservidor\ice_clean_fluxo.dta", replace

use "$folderservidor\ice_clean_fluxo.dta", clear

drop _merge
save "$folderservidor\ice_clean_fluxo.dta", replace
use "$folderservidor\ice_clean_notas.dta", clear
drop _merge
save "$folderservidor\ice_clean_notas.dta",  replace

*fazendo merge com pib per capita por cidade
use "$folderservidor\pib_municipio\pib_capita_municipio_2003_2015_final_14.dta",clear
rename cod_munic codigo_municipio_novo
merge 1:m codigo_municipio_novo ano using "$folderservidor\ice_clean_notas.dta"
save "$folderservidor\ice_clean_notas.dta", replace


use "$folderservidor\pib_municipio\pib_capita_municipio_2003_2015_final_14.dta",clear
rename cod_munic codigo_municipio_novo
merge 1:m codigo_municipio_novo ano using "$folderservidor\ice_clean_fluxo.dta"
save "$folderservidor\ice_clean_fluxo.dta", replace
