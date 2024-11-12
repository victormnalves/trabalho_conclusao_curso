/***************************Base Final*******************************/

/*
mergeando as bases
censo escolar, 
Saeb, 
Prova Brasil, 
Mais educação,
Indicadores do INEP, 
ICE

Mas primeiro, necessário ajustar cada uma das bases
as variáveis de merge serão codigo_escola e ano
mas em casa base, a variável de ano está com o nome ano_"nome da pesquisa"
*/

/*enem*/
clear all
set more off, permanently

capture log close

global user "`:environment USERPROFILE'"
*global Folder "$user/OneDrive/EESP_ECONOMIA_mestrado_acadêmico/Dissertação/ICE/dados_ICE/Análise_Leonardo"
global Folder "D:\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo"
global output "$Folder/resultados"
global Bases "$Folder/Bases"
global dofiles "$Folder/Do-Files"
global Logfolder "$Folder/Log"

log using "$Logfolder/ajuste_bases.log", replace

use "E:\bases_dta\enem\enem_todos.dta", clear
*renomeando a variável de ano para fazer o merge
rename ano_enem ano
drop _m
drop if codigo_escola==.
save "E:\bases_dta\enem\enem_todos_1.dta", replace
save "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\enem\\enem_todos_1.dta", replace


/*saeb*/

use "F:\bases_dta\saeb_prova_brasil\saeb_todos.dta", clear
rename ano_saeb ano
drop _m
drop if codigo_escola==.
save "F:\bases_dta\saeb_prova_brasil\saeb_todos_1.dta", replace
save "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\PROVA_BRASIL_SAEB\saeb_todos_1.dta", replace


/*pb*/

use "F:\bases_dta\saeb_prova_brasil\provabrasil_todos.dta", clear
rename ano_prova_brasil ano

drop if codigo_escola==.
save "F:\bases_dta\saeb_prova_brasil\provabrasil_todos_1.dta", replace
save "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\PROVA_BRASIL_SAEB\provabrasil_todos_1.dta", replace

/*censo escolar*/
use "F:\bases_dta\censo_escolar\censo_escolar_PE.dta", clear
rename ano_censo ano

drop if codigo_escola==.
save "F:\bases_dta\censo_escolar\censo_escolar_PE_1.dta", replace

use "F:\bases_dta\censo_escolar\\censo_escolar_CE.dta", clear
rename ano_censo ano

drop if codigo_escola==.
save "F:\bases_dta\censo_escolar\\censo_escolar_CE_1.dta", replace

use "F:\bases_dta\censo_escolar\\censo_escolar_SP.dta", clear
rename ano_censo ano

drop if codigo_escola==.
save "F:\bases_dta\censo_escolar\\censo_escolar_SP_1.dta", replace

use "F:\bases_dta\censo_escolar\censo_escolar_RJ.dta", clear
rename ano_censo ano

drop if codigo_escola==.
save "F:\bases_dta\censo_escolar\\censo_escolar_RJ_1.dta", replace

use "F:\bases_dta\censo_escolar\censo_escolar_GO.dta", clear
rename ano_censo ano

drop if codigo_escola==.
save "F:\bases_dta\censo_escolar\censo_escolar_GO_1.dta", replace

use "F:\bases_dta\censo_escolar\censo_escolar_ES.dta", clear
rename ano_censo ano

drop if codigo_escola==.
save "F:\bases_dta\censo_escolar\censo_escolar_ES_1.dta", replace

/*append dos censos escolares*/
use "F:\bases_dta\censo_escolar\\censo_escolar_CE_1.dta", clear
append using "F:\bases_dta\censo_escolar\censo_escolar_PE_1.dta"
append using "F:\bases_dta\censo_escolar\censo_escolar_GO_1.dta"
append using "F:\bases_dta\censo_escolar\censo_escolar_ES_1.dta"
append using "F:\bases_dta\censo_escolar\censo_escolar_RJ_1.dta"
append using "F:\bases_dta\censo_escolar\censo_escolar_SP_1.dta"
drop _m
save "F:\bases_dta\censo_escolar\censo_escolar_todos.dta", replace
save "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\censo_escolar\censo_escolar_todos.dta", replace
log close
/******Merge Final para fluxo******/
capture log close
set more off
set trace on
log using "$Logfolder/merge_fluxo.log", replace

use "D:\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\ice_dados\base_final_ice_fluxo.dta", clear
drop _m
merge 1:1 codigo_escola  using "D:\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\mais_educação\mais_educacao_todos.dta"
drop _m

merge 1:m codigo_escola  using "D:\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\enem\enem_todos_1.dta"
drop _m

merge 1:1 codigo_escola ano using "D:\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\censo_escolar\censo_escolar_todos.dta"
drop _m
merge 1:1 codigo_escola ano using "D:\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\saeb_prova_brasil\provabrasil_todos_1.dta"

drop _m

merge 1:1 codigo_escola ano using "D:\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\indicadores_inep\fluxo_2007a2015.dta"
drop _m
merge 1:1 codigo_escola ano using "D:\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\saeb_prova_brasil\saeb_todos_1.dta"

drop _m
compress
save "D:\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\ice_completo_fluxo.dta", replace
//save "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\ice_completo.dta", replace


/*--------------------fazendo ajustes na base---------------------------*/
use "D:\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\ice_completo_fluxo.dta", clear



/*
na base ice, as dummies só assumiram 1 ou .
*/
replace ice=0 if ice==.

/*padronizando as ufs*/
/*
imputando os valores da variável codigo_uf, com base na informação disponível

*/

replace codigo_uf=26 if sigla=="PE" | uf=="PE" | SIGLA=="PE" | UF=="Pernambuco"
replace codigo_uf=23 if sigla=="CE" | uf=="CE" | SIGLA=="CE" | UF=="Ceará"|UF=="Ceara"
replace codigo_uf=35 if sigla=="SP" | uf=="SP" | SIGLA=="SP" | UF=="São Paulo"|UF=="Sao Paulo"
replace codigo_uf=33 if sigla=="RJ" | uf=="RJ" | SIGLA=="RJ" | UF=="Rio de Janeiro"
replace codigo_uf=52 if sigla=="GO" | uf=="GO" | SIGLA=="GO" | UF=="Goiás"|UF=="Goias"
replace codigo_uf=32 if sigla=="ES" | uf=="ES" | SIGLA=="ES" | UF=="Espirito Santo"

* mantendo somente escolas do programa ou escolas dos estados 
keep if codigo_uf==32 |codigo_uf==52 | codigo_uf==33 | codigo_uf==35| codigo_uf==23| codigo_uf==26 | ice_2004==1 | ice_2005==1 | ice_2006==1 | ice_2007==1 | ice_2008==1| ice_2009==1| ice_2010==1| ice_2011==1| ice_2012==1| ice_2013==1| ice_2014==1| ice_2015==1

/*padronizando os codigos de municipio*/
/*
códigos de municípios antes e depois de 2006 são diferentes
para padronizar tais códigos, usaremos a tabela cod_munic.dta
tal tabela relaciona o codigo novo com o codigo velho
os dois primeiros digitos e os digitos 9,10,11,12 do codigo velho
formam um codigo que pode ser relacionado com o codigo novo
*/
tostring codigo_municipio, gen(codigo_municipios) format(%20.0g) 
gen cod_aux1=substr(codigo_municipios,1,2) 
gen cod_aux2=substr(codigo_municipios,8,4)
gen cod_aux3=cod_aux1+cod_aux2

rename codigo_municipio codigo_municipio_enorme
rename cod_aux3 codigo_municipio
destring codigo_municipio, replace

merge m:1 codigo_municipio using "D:\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\cod_munic.dta"
drop if _merge==2
replace codigo_municipio_novo=ufmundv if codigo_municipio_novo==.

/*dummies de depêndencia administrativa*/
*gerando dummies de depêndencia adm
qui tab dep, gen(d_dep)


/*dummies de participação no mais educação*/
gen mais_educ=0

foreach x of varlist mais_educacao_fund_2010- mais_educacao_x_2009 				///
	n_turmas_mais_educ_em_1- n_turmas_mais_educ_em_3 							///
	n_turmas_mais_educ_fund_5_8anos- n_turmas_mais_educ_fund_9_9anos 			///
	n_turmas_mais_educ_em_inte_1- n_turmas_mais_educ_em_inte_ns{
replace mais_educ=1 if `x'>0&`x'!=.
}


/*Rigor do ICE*/
*imputando valores na variável ice_rigor
replace ice_rigor="Sem Apoio" if ice_rigor==""&ice==1
*gerando dummy de rigor do ICE
tab ice_rigor if ice==1, gen(d_rigor)

/************padronização das notas***********/
/*
notas da prova brasil
(lembrando que temos notas para o 4ªsérie/ 5º ano e 8ªsérie/ 9º ano
*/
gen media_pb_9=(media_lp_prova_brasil_9+ media_mt_prova_brasil_9)/2
gen media_pb_5=(media_lp_prova_brasil_5+ media_mt_prova_brasil_5)/2


/************padronização das notas***********/
/*padronizando as notas do enem*/
foreach x in "enem_nota_matematica" "enem_nota_ciencias" "enem_nota_humanas" 	///
	"enem_nota_linguagens" "media_lp_prova_brasil_9" "media_mt_prova_brasil_9" 	///
	"media_pb_9" "media_lp_prova_brasil_5" "media_mt_prova_brasil_5" 			///
	"media_pb_5" "apr_ef" "apr_em" "rep_ef" "rep_em" "aba_ef" "aba_em" "dist_ef"///
	"dist_em" {
egen `x'_std=std(`x')
}

****padronizando as notas de redação****

*note que de 2003 a 2008, estaremos criando uma nota nova para cada ano
*(provavelmente, de 2003 a 2008 as notas não são comparáveis)
foreach a in 2003 2004 2005 2006 2007 2008 {
egen enem_nota_redacao_std_aux_`a'=std(enem_nota_redacao) if ano==`a'
}

*a partir de 2009, as notas são comparáveis
egen enem_nota_redacao_std=std(enem_nota_redacao) if ano>=2009
foreach a in 2003 2004 2005 2006 2007 2008 {
replace enem_nota_redacao_std=enem_nota_redacao_std_aux_`a' if ano==`a'
}


*****padronizando as notas objetivas****

*para 2003 a 2008, estaremos criando uma nota nova para cada ano
*(provavelmente, de 2003 a 2008 as notas não são comparáveis)

foreach a in 2003 2004 2005 2006 2007 2008 {
egen enem_nota_objetiva_std_aux_`a'=std(enem_nota_objetiva) if ano==`a'
}
*a partir de 2009, as notas são coparáveis
gen enem_nota_objetivab =(enem_nota_matematica + enem_nota_ciencias + 			///
	enem_nota_humanas+enem_nota_linguagens) / 4
egen enem_nota_objetivab_std=std(enem_nota_objetivab) if ano>=2009
foreach a in 2003 2004 2005 2006 2007 2008 {
replace enem_nota_objetivab_std=enem_nota_objetiva_std_aux_`a' if ano==`a'
}




/************padronização das notas por UF***********/

foreach xx in 26 52 35 23 32 33 {
foreach x in "enem_nota_matematica" "enem_nota_ciencias" "enem_nota_humanas" 	///
	"enem_nota_linguagens" "media_lp_prova_brasil_5" "media_mt_prova_brasil_5"  ///
	"media_pb_5" "media_lp_prova_brasil_9" "media_mt_prova_brasil_9" 			///
	"media_pb_9" "apr_ef" "apr_em" "rep_ef" "rep_em" "aba_ef" "aba_em" 			///
	"dist_ef" "dist_em" {

capture egen `x'`xx'_std=std(`x') if codigo_uf==`xx' 
}
}
foreach xx in 26 52 35 23 32 33 {
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

gen enem_nota_objetivab`xx' = (enem_nota_matematica + enem_nota_ciencias + 		///
	enem_nota_humanas + enem_nota_linguagens) / 4 if codigo_uf==`xx'
capture egen enem_nota_objetivab`xx'_std=std(enem_nota_objetivab) if ano>=2009 	///
	& codigo_uf==`xx'

foreach a in 2003 2004 2005 2006 2007 2008 {
replace enem_nota_objetivab`xx'_std=enem_nota_objetiva_std_aux_`a' if ano==`a' & codigo_uf==`xx'

}
}



/*dummies de ano de entrada da escola no programa*/

gen d_ice=0

tab ano, gen(d_ano)

forvalues x=2004(1)2015{
replace d_ice=1 if ice_`x'==1 &ano==`x' 
}

/*dummies de código de estado*/

tab codigo_uf, gen(d_uf)

save "D:\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\ice_completo_fluxo_1.dta", replace 
/***********************Lidando com os missings**************************/
* imputando zero no lugar dos missings

forvalues x=1(1)3{
replace n_alunos_em_`x'=0 if n_alunos_em_`x'==.
replace n_mulheres_em_`x'=0 if n_mulheres_em_`x'==.
replace n_brancos_em_`x'=0 if n_brancos_em_`x'==.
}
forvalues x=8(1)9{
forvalues i=5(1)9{
capture replace n_alunos_fund_`x'_`i'anos=0 if n_alunos_fund_`x'_`i'anos==.
capture replace n_mulheres_fund_`x'=0 if n_mulheres_fund_`x'==.
capture replace n_brancos_fund_`x'=0 if n_brancos_fund_`x'==.
}
}
foreach x in "1" "2" "3" "4" "ns"{
replace n_alunos_em_inte_`x'=0 if n_alunos_em_inte_`x'==.
replace n_mulheres_em_inte_`x'=0 if n_mulheres_em_inte_`x'==.
replace n_brancos_em_inte_`x'=0 if n_brancos_em_inte_`x'==.

}

* gerando variáveis de número de alunos, mulheres e brancos
* por modalidade

gen n_alunos_em=n_alunos_em_1+n_alunos_em_2 +n_alunos_em_3
replace n_alunos_em=0 if n_alunos_em==.
gen n_mulheres_em=n_mulheres_em_1+n_mulheres_em_2 +n_mulheres_em_3
replace n_mulheres_em=0 if n_mulheres_em==.
gen n_brancos_em=n_brancos_em_1+n_brancos_em_2 +n_brancos_em_3
replace n_brancos_em=0 if n_brancos_em==.

gen n_alunos_ef=n_alunos_fund_5_8anos+ n_alunos_fund_6_8anos +n_alunos_fund_7_8anos +n_alunos_fund_8_8anos +n_alunos_fund_6_9anos +n_alunos_fund_7_9anos +n_alunos_fund_8_9anos +n_alunos_fund_9_9anos
replace n_alunos_ef=0 if n_alunos_ef==.
gen n_mulheres_ef=n_mulheres_fund_5_8anos+ n_mulheres_fund_6_8anos +n_mulheres_fund_7_8anos +n_mulheres_fund_8_8anos +n_mulheres_fund_6_9anos +n_mulheres_fund_7_9anos +n_mulheres_fund_8_9anos +n_mulheres_fund_9_9anos
replace n_mulheres_ef=0 if n_mulheres_ef==.
gen n_brancos_ef=n_brancos_fund_5_8anos+ n_brancos_fund_6_8anos +n_brancos_fund_7_8anos +n_brancos_fund_8_8anos +n_brancos_fund_6_9anos +n_brancos_fund_7_9anos +n_brancos_fund_8_9anos +n_brancos_fund_9_9anos
replace n_brancos_ef=0 if n_brancos_ef==.

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


* gerando variáveis de número de alunos, mulheres e brancos
* PE uf 26 CE uf  23 SP uf 35 RJ uf 33 GO uf 52 ES uf 32
gen nalunos=.
replace nalunos=n_alunos_em if codigo_uf==26
replace nalunos=n_alunos_em if codigo_uf==52
replace nalunos=n_alunos_ef if codigo_uf==33
replace nalunos=n_alunos_ef_em if codigo_uf==35
replace nalunos=n_alunos_ep if codigo_uf==23
replace nalunos=n_alunos_ef if codigo_uf==32
replace nalunos=. if nalunos==0

gen nmulheres=.
replace nmulheres=n_mulheres_em if codigo_uf==26
replace nmulheres=n_mulheres_em if codigo_uf==52
replace nmulheres=n_mulheres_ef if codigo_uf==33
replace nmulheres=n_mulheres_ef_em if codigo_uf==35
replace nmulheres=n_mulheres_ep if codigo_uf==23
replace nmulheres=n_mulheres_ef if codigo_uf==32
replace nmulheres=. if nmulheres==0

gen nbrancos=.
replace nbrancos=n_brancos_em if codigo_uf==26
replace nbrancos=n_brancos_em if codigo_uf==52
replace nbrancos=n_brancos_ef if codigo_uf==33
replace nbrancos=n_brancos_ef_em if codigo_uf==35
replace nbrancos=n_brancos_ep if codigo_uf==23
replace nbrancos=n_brancos_ef if codigo_uf==32
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



save "D:\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\ice_clean_fluxo.dta", replace

/*
drop e_trabalhou_ou_procurou- e_ajuda_esc_profissao_muito mascara2003- s_exp_prof_escola_mais_3_9 ano_saeb n_turmas_em_1- p_profs_sup_em_3 n_profs_em- cod_aux2

save "D:\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\ice_clean_fluxo.dta", replace
*/

log close



/******Merge Final para notas******/
capture log close
set more off
set trace on
log using "$Logfolder/merge_notas.log", replace
use "D:\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\ice_dados\base_final_ice_notas.dta", clear
drop _m
merge 1:1 codigo_escola  using "D:\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\mais_educação\mais_educacao_todos.dta"
drop _m

merge 1:m codigo_escola  using "D:\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\enem\enem_todos_1.dta"
drop _m

merge 1:1 codigo_escola ano using "D:\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\censo_escolar\censo_escolar_todos.dta"
drop _m
merge 1:1 codigo_escola ano using "D:\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\saeb_prova_brasil\provabrasil_todos_1.dta"

drop _m

merge 1:1 codigo_escola ano using "D:\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\indicadores_inep\fluxo_2007a2015.dta"
drop _m
merge 1:1 codigo_escola ano using "D:\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\saeb_prova_brasil\saeb_todos_1.dta"

drop _m
compress
save "D:\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\ice_completo_notas.dta", replace
//save "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\ice_completo.dta", replace


/*--------------------fazendo ajustes na base---------------------------*/
use "D:\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\ice_completo_notas.dta", clear



/*
na base ice, as dummies só assumiram 1 ou .
*/
replace ice=0 if ice==.

/*padronizando as ufs*/
/*
imputando os valores da variável codigo_uf, com base na informação disponível

*/

replace codigo_uf=26 if sigla=="PE" | uf=="PE" | SIGLA=="PE" | UF=="Pernambuco"
replace codigo_uf=23 if sigla=="CE" | uf=="CE" | SIGLA=="CE" | UF=="Ceará"|UF=="Ceara"
replace codigo_uf=35 if sigla=="SP" | uf=="SP" | SIGLA=="SP" | UF=="São Paulo"|UF=="Sao Paulo"
replace codigo_uf=33 if sigla=="RJ" | uf=="RJ" | SIGLA=="RJ" | UF=="Rio de Janeiro"
replace codigo_uf=52 if sigla=="GO" | uf=="GO" | SIGLA=="GO" | UF=="Goiás"|UF=="Goias"
replace codigo_uf=32 if sigla=="ES" | uf=="ES" | SIGLA=="ES" | UF=="Espirito Santo"

* mantendo somente escolas do programa ou escolas dos estados 
keep if codigo_uf==32 |codigo_uf==52 | codigo_uf==33 | codigo_uf==35| codigo_uf==23| codigo_uf==26 | ice_2004==1 | ice_2005==1 | ice_2006==1 | ice_2007==1 | ice_2008==1| ice_2009==1| ice_2010==1| ice_2011==1| ice_2012==1| ice_2013==1| ice_2014==1| ice_2015==1

/*padronizando os codigos de municipio*/
/*
códigos de municípios antes e depois de 2006 são diferentes
para padronizar tais códigos, usaremos a tabela cod_munic.dta
tal tabela relaciona o codigo novo com o codigo velho
os dois primeiros digitos e os digitos 9,10,11,12 do codigo velho
formam um codigo que pode ser relacionado com o codigo novo
*/
tostring codigo_municipio, gen(codigo_municipios) format(%20.0g) 
gen cod_aux1=substr(codigo_municipios,1,2) 
gen cod_aux2=substr(codigo_municipios,8,4)
gen cod_aux3=cod_aux1+cod_aux2

rename codigo_municipio codigo_municipio_enorme
rename cod_aux3 codigo_municipio
destring codigo_municipio, replace

merge m:1 codigo_municipio using "D:\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\cod_munic.dta"
drop if _merge==2
replace codigo_municipio_novo=ufmundv if codigo_municipio_novo==.

/*dummies de depêndencia administrativa*/
*gerando dummies de depêndencia adm
qui tab dep, gen(d_dep)


/*dummies de participação no mais educação*/
gen mais_educ=0

foreach x of varlist mais_educacao_fund_2010- mais_educacao_x_2009 	n_turmas_mais_educ_em_1- n_turmas_mais_educ_em_3 n_turmas_mais_educ_fund_5_8anos- n_turmas_mais_educ_fund_9_9anos n_turmas_mais_educ_em_inte_1- n_turmas_mais_educ_em_inte_ns{
replace mais_educ=1 if `x'>0&`x'!=.
}


/*Rigor do ICE*/
*imputando valores na variável ice_rigor
replace ice_rigor="Sem Apoio" if ice_rigor==""&ice==1
*gerando dummy de rigor do ICE
tab ice_rigor if ice==1, gen(d_rigor)

/************padronização das notas***********/
/*
notas da prova brasil
(lembrando que temos notas para o 4ªsérie/ 5º ano e 8ªsérie/ 9º ano
*/
gen media_pb_9=(media_lp_prova_brasil_9+ media_mt_prova_brasil_9)/2
gen media_pb_5=(media_lp_prova_brasil_5+ media_mt_prova_brasil_5)/2


/************padronização das notas***********/
/*padronizando as notas do enem*/

foreach x in "enem_nota_matematica" "enem_nota_ciencias" "enem_nota_humanas" "enem_nota_linguagens" "media_lp_prova_brasil_9" "media_mt_prova_brasil_9" "media_pb_9" "media_lp_prova_brasil_5" "media_mt_prova_brasil_5" "media_pb_5" "apr_ef" "apr_em" "rep_ef" "rep_em" "aba_ef" "aba_em" "dist_ef" "dist_em" {
egen `x'_std=std(`x')
}

****padronizando as notas de redação****

*note que de 2003 a 2008, estaremos criando uma nota nova para cada ano
*(provavelmente, de 2003 a 2008 as notas não são comparáveis)
foreach a in 2003 2004 2005 2006 2007 2008 {
egen enem_nota_redacao_std_aux_`a'=std(enem_nota_redacao) if ano==`a'
}

*a partir de 2009, as notas são comparáveis
egen enem_nota_redacao_std=std(enem_nota_redacao) if ano>=2009
foreach a in 2003 2004 2005 2006 2007 2008 {
replace enem_nota_redacao_std=enem_nota_redacao_std_aux_`a' if ano==`a'
}


*****padronizando as notas objetivas****

*para 2003 a 2008, estaremos criando uma nota nova para cada ano
*(provavelmente, de 2003 a 2008 as notas não são comparáveis)

foreach a in 2003 2004 2005 2006 2007 2008 {
egen enem_nota_objetiva_std_aux_`a'=std(enem_nota_objetiva) if ano==`a'
}
*a partir de 2009, as notas são coparáveis
gen enem_nota_objetivab =(enem_nota_matematica + enem_nota_ciencias + 			///
	enem_nota_humanas+enem_nota_linguagens) / 4
egen enem_nota_objetivab_std=std(enem_nota_objetivab) if ano>=2009
foreach a in 2003 2004 2005 2006 2007 2008 {
replace enem_nota_objetivab_std=enem_nota_objetiva_std_aux_`a' if ano==`a'
}




/************padronização das notas por UF***********/

foreach xx in 26 52 35 23 32 33 {
foreach x in "enem_nota_matematica" "enem_nota_ciencias" "enem_nota_humanas" "enem_nota_linguagens" "media_lp_prova_brasil_5" "media_mt_prova_brasil_5" "media_pb_5" "media_lp_prova_brasil_9" "media_mt_prova_brasil_9" "media_pb_9" "apr_ef" "apr_em" "rep_ef" "rep_em" "aba_ef" "aba_em" "dist_ef" "dist_em" {

capture egen `x'`xx'_std=std(`x') if codigo_uf==`xx' 
}
}
foreach xx in 26 52 35 23 32 33 {
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

gen enem_nota_objetivab`xx' = (enem_nota_matematica + enem_nota_ciencias + 		///
	enem_nota_humanas + enem_nota_linguagens) / 4 if codigo_uf==`xx'
capture egen enem_nota_objetivab`xx'_std=std(enem_nota_objetivab) if ano>=2009 	///
	& codigo_uf==`xx'

foreach a in 2003 2004 2005 2006 2007 2008 {
replace enem_nota_objetivab`xx'_std=enem_nota_objetiva_std_aux_`a' if ano==`a' & codigo_uf==`xx'

}
}



/*dummies de ano de entrada da escola no programa*/

gen d_ice=0

tab ano, gen(d_ano)

forvalues x=2004(1)2015{
replace d_ice=1 if ice_`x'==1 &ano==`x' 
}

/*dummies de código de estado*/

tab codigo_uf, gen(d_uf)

save "D:\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\ice_completo_notas_1.dta", replace 
/***********************Lidando com os missings**************************/
* imputando zero no lugar dos missings

forvalues x=1(1)3{
replace n_alunos_em_`x'=0 if n_alunos_em_`x'==.
replace n_mulheres_em_`x'=0 if n_mulheres_em_`x'==.
replace n_brancos_em_`x'=0 if n_brancos_em_`x'==.
}
forvalues x=8(1)9{
forvalues i=5(1)9{
capture replace n_alunos_fund_`x'_`i'anos=0 if n_alunos_fund_`x'_`i'anos==.
capture replace n_mulheres_fund_`x'=0 if n_mulheres_fund_`x'==.
capture replace n_brancos_fund_`x'=0 if n_brancos_fund_`x'==.
}
}
foreach x in "1" "2" "3" "4" "ns"{
replace n_alunos_em_inte_`x'=0 if n_alunos_em_inte_`x'==.
replace n_mulheres_em_inte_`x'=0 if n_mulheres_em_inte_`x'==.
replace n_brancos_em_inte_`x'=0 if n_brancos_em_inte_`x'==.

}

* gerando variáveis de número de alunos, mulheres e brancos
* por modalidade

gen n_alunos_em=n_alunos_em_1+n_alunos_em_2 +n_alunos_em_3
replace n_alunos_em=0 if n_alunos_em==.
gen n_mulheres_em=n_mulheres_em_1+n_mulheres_em_2 +n_mulheres_em_3
replace n_mulheres_em=0 if n_mulheres_em==.
gen n_brancos_em=n_brancos_em_1+n_brancos_em_2 +n_brancos_em_3
replace n_brancos_em=0 if n_brancos_em==.

gen n_alunos_ef=n_alunos_fund_5_8anos+ n_alunos_fund_6_8anos +n_alunos_fund_7_8anos +n_alunos_fund_8_8anos +n_alunos_fund_6_9anos +n_alunos_fund_7_9anos +n_alunos_fund_8_9anos +n_alunos_fund_9_9anos
replace n_alunos_ef=0 if n_alunos_ef==.
gen n_mulheres_ef=n_mulheres_fund_5_8anos+ n_mulheres_fund_6_8anos +n_mulheres_fund_7_8anos +n_mulheres_fund_8_8anos +n_mulheres_fund_6_9anos +n_mulheres_fund_7_9anos +n_mulheres_fund_8_9anos +n_mulheres_fund_9_9anos
replace n_mulheres_ef=0 if n_mulheres_ef==.
gen n_brancos_ef=n_brancos_fund_5_8anos+ n_brancos_fund_6_8anos +n_brancos_fund_7_8anos +n_brancos_fund_8_8anos +n_brancos_fund_6_9anos +n_brancos_fund_7_9anos +n_brancos_fund_8_9anos +n_brancos_fund_9_9anos
replace n_brancos_ef=0 if n_brancos_ef==.

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


* gerando variáveis de número de alunos, mulheres e brancos
* PE uf 26 CE uf  23 SP uf 35 RJ uf 33 GO uf 52 ES uf 32
gen nalunos=.
replace nalunos=n_alunos_em if codigo_uf==26
replace nalunos=n_alunos_em if codigo_uf==52
replace nalunos=n_alunos_ef if codigo_uf==33
replace nalunos=n_alunos_ef_em if codigo_uf==35
replace nalunos=n_alunos_ep if codigo_uf==23
replace nalunos=n_alunos_ef if codigo_uf==32
replace nalunos=. if nalunos==0

gen nmulheres=.
replace nmulheres=n_mulheres_em if codigo_uf==26
replace nmulheres=n_mulheres_em if codigo_uf==52
replace nmulheres=n_mulheres_ef if codigo_uf==33
replace nmulheres=n_mulheres_ef_em if codigo_uf==35
replace nmulheres=n_mulheres_ep if codigo_uf==23
replace nmulheres=n_mulheres_ef if codigo_uf==32
replace nmulheres=. if nmulheres==0

gen nbrancos=.
replace nbrancos=n_brancos_em if codigo_uf==26
replace nbrancos=n_brancos_em if codigo_uf==52
replace nbrancos=n_brancos_ef if codigo_uf==33
replace nbrancos=n_brancos_ef_em if codigo_uf==35
replace nbrancos=n_brancos_ep if codigo_uf==23
replace nbrancos=n_brancos_ef if codigo_uf==32
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



save "D:\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\ice_clean_notas.dta", replace

/*
drop e_trabalhou_ou_procurou- e_ajuda_esc_profissao_muito mascara2003- s_exp_prof_escola_mais_3_9 ano_saeb n_turmas_em_1- p_profs_sup_em_3 n_profs_em- cod_aux2

save "D:\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\ice_clean_fluxo.dta", replace
*/


log close

