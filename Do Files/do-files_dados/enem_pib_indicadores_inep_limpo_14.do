/*************************** Base Final  versão 3 EM *******************************/

/*
mergeando as bases
enem
pib por cidade
indicadores do inep

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
log using "$folderservidor\\logfiles/ajuste_enem_pib_indicadores_inep_v3.log", replace


**************************criando a base de em****************************
*ajustando a base do enem
use "$folderservidor\enem\enem_todos.dta", clear
*use "E:\bases_dta\enem\enem_todos.dta", clear

*mantendo somente variáveis que vão ser utilizadas
keep concluir_em_ano_enem codigo_municipio ano_enem e_mora_mais_de_6_pessoas e_mora_mais_de_7_pessoas e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_automovel e_casa_propria e_trabalhou_ou_procurou e_trabalhou codigo_escola enem_nota_objetiva enem_nota_redacao enem_nota_matematica enem_nota_linguagens enem_nota_humanas enem_nota_ciencias e_tem_filho e_renda_familia_6_salarios

*variável e_automovel não tem em 2010

*variável e_casa_propria não tem em 2015


*variável e_tem_filho só de 2003 até 2009

*variável e_trabalhou só de 2010 até 2015 e e_trabalhou_ou_procurou só de 2003 até 2009
replace e_trabalhou_ou_procurou = e_trabalhou if ano > 2009
tab ano if e_trabalhou_ou_procurou !=.
tab ano if e_trabalhou !=.
*variável e_renda_familia_6_salarios só em 2010 e e_renda_familia_5_salarios em todos os anos menos em 2010
replace e_renda_familia_5_salarios = e_renda_familia_6_salarios if ano ==2010


tab ano if e_renda_familia_5_salarios !=.
tab ano if e_renda_familia_6_salarios !=.
*variável e_mora_mais_de_6_pessoas não está em 2010. usar e_mora_mais_de_7_pessoas
replace e_mora_mais_de_6_pessoas = e_mora_mais_de_7_pessoas if ano ==2010

tab ano if e_mora_mais_de_6_pessoas !=.
tab ano if e_mora_mais_de_7_pessoas !=.

* e_mora_mais_de_7_pessoas e_renda_familia_6_salarios e_trabalhou e_automovel e_tem_filho e_casa_propria
* tem missings sistemáticos
drop e_mora_mais_de_7_pessoas e_renda_familia_6_salarios e_trabalhou e_automovel e_tem_filho e_casa_propria

*codigo do município está diferente para alguns anos. necessário padronizar
/*
tostring codigo_municipio, gen(codigo_municipios) format(%20.0g) 
gen cod_aux1=substr(codigo_municipios,1,2) 
gen cod_aux2=substr(codigo_municipios,8,4)
gen cod_aux3=cod_aux1+cod_aux2
*replace nome_municipio = substr(nome_municipio, 1, strlen(nome_municipio) - 5)

rename codigo_municipio codigo_municipio_enorme
rename cod_aux3 codigo_municipio
destring codigo_municipio, replace

merge m:1 codigo_municipio using "$folderservidor\cod_munic.dta"
drop if _merge==2
sort ano
format ufmundv %10.0g
replace codigo_municipio_enorme=ufmundv if ufmundv!=.
drop codigo_municipios cod_aux1 cod_aux2 codigo_municipio ufmundv _merge
rename codigo_municipio_enorme cod_munic

replace cod_munic = 320100302256 if cod_munic == 3202256
replace cod_munic = 330601802858 if cod_munic == 3302858
replace cod_munic = 520300610158 if cod_munic == 5210158
replace cod_munic = 520300704854 if cod_munic == 5204854
replace cod_munic = 520501608152 if cod_munic == 5208152
replace cod_munic = 520501812253 if cod_munic == 5212253
*/
*os primeiros dois digitos e os ultimos cinco dão o codi
tostring codigo_municipio, gen(codigo_municipios) format(%20.0g) 
gen cod_aux1=substr(codigo_municipios,1,2) 
gen cod_aux2=substr(codigo_municipios,strlen(codigo_municipios) - 4,5)
gen cod_munic = cod_aux1 +cod_aux2

destring cod_munic, replace
order cod_munic, after (codigo_municipios)
drop codigo_municipios cod_aux1 cod_aux2 
sort cod_munic
rename codigo_municipio codigo_municipio_longo
*adicionando variável de pib por município na base
*renomeando a variável de ano para fazer o merge
gen ano = ano_enem
merge m:1 cod_munic ano using "$folderservidor\\pib_municipio\pib_capita_municipio_2003_2015_final_14.dta"
drop if _merge==2
rename pib_capita_mil_reals pib_capita_mil_reais
drop _merge pib_capita_mil_reais ipca_acumulado_2015 ipca_acumulado_base2003 ipca_acumulado_ano 
merge m:1 cod_munic  using "$folderservidor\\pib_municipio\codigo_uf_cod_munic.dta"
drop _merge
*vamos reordernar as variáveis na tabela para faciliar a manipulação das notas

order codigo_escola
order ano, after(codigo_escola)
order ano_enem, after(ano)
order cod_munic, after(ano_enem)
order cod_meso, after(cod_munic)
order nome_municipio pib pop pib_capita_reias pib_capita_reais_real_2003 pib_capita_reais_real_2015, after (cod_meso)
order codigo_uf estado, after (nome_municipio)
order enem_nota_objetiva, before (enem_nota_matematica)
order enem_nota_redacao, after (enem_nota_ciencias)
order codigo_municipio_longo, after(cod_munic)
sort ano codigo_escola
drop if codigo_escola ==.
save "$folderservidor\enem\enem_todos_limpo.dta", replace 
* até aqui, todas as variáveis do enem, com exceção das notas, estão bem ajustadas
*vamos mergear as informações de fluxo, presentes na base dos indicadores do INEP
* mas antes, vamos manter somente as escolas do ensino médio

use "$folderservidor\indicadores_inep\fluxo_2007a2015.dta", clear
keep if dist_em!=. | aba_em!= . | rep_em!= .  | apr_em != .
save "$folderservidor\indicadores_inep\fluxo_2007a2015_em.dta", replace
 

use "$folderservidor\enem\enem_todos_limpo.dta", clear 


drop if codigo_escola==.
merge 1:1 codigo_escola ano using "$folderservidor\indicadores_inep\fluxo_2007a2015_em.dta"
drop _m
sort ano codigo_escola

drop apr_ef rep_ef aba_ef dist_ef


*necessário padronizar as notas:
*variável enem_nota_obj só de 2003 até 2008

*variável enem_nota_mat, cie, ling, humanas só de 2009 até 2015
******* Padronizacao das notas *****

******* Padronizacao das notas *****

foreach x in "enem_nota_matematica" "enem_nota_ciencias" "enem_nota_humanas" "enem_nota_linguagens"   "apr_em"  "rep_em"  "aba_em"  "dist_em" {
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
drop enem_nota_redacao_std_aux_2003 - enem_nota_redacao_std_aux_2008 
drop enem_nota_objetiva_std_aux_2003 - enem_nota_objetiva_std_aux_2008


/*
******* Padronizacao das notas por UF *****

foreach xx in 26 52 35 23 33 {
foreach x in "enem_nota_matematica" "enem_nota_ciencias" "enem_nota_humanas" "enem_nota_linguagens"  "apr_em"  "rep_em" "aba_em"  "dist_em" {

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



*padronizando nota do enem entre estados
*(note que a padronização intra estados já foi feita no dofile merge final)
*aqui a padronização está sendo feita par a par
* PE uf 26 CE uf  23 SP uf 35 RJ uf 33 GO uf 52 ES uf 32

*padronizando notas de redação intra anos (2003 a 2009) e entre CE e PE
foreach a in 2003 2004 2005 2006 2007 2008 {
capture egen enem_nota_redacao2326_std_aux_`a'=std(enem_nota_redacao) if ano==`a' & (codigo_uf==23|codigo_uf==26)
}

capture egen enem_nota_redacao2326_std=std(enem_nota_redacao) if ano>=2009 & (codigo_uf==23|codigo_uf==26)


foreach a in 2003 2004 2005 2006 2007 2008 {
replace enem_nota_redacao2326_std=enem_nota_redacao_std_aux_`a' if ano==`a' & (codigo_uf==23|codigo_uf==26)
}

*padronizando notas objetiva intra anos (2003 a 2009) e entre CE e PE
foreach a in 2003 2004 2005 2006 2007 2008 {
capture egen enem_nota_objetiva2326_std_aux_`a'=std(enem_nota_objetiva) if ano==`a' &(codigo_uf==23|codigo_uf==26)
}

gen enem_nota_objetivab2326=(enem_nota_matematica +enem_nota_ciencias +enem_nota_humanas+enem_nota_linguagens)/4 if (codigo_uf==23|codigo_uf==26)
capture egen enem_nota_objetivab2326_std=std(enem_nota_objetivab) if ano>=2009 & (codigo_uf==23|codigo_uf==26)

foreach a in 2003 2004 2005 2006 2007 2008 {
replace enem_nota_objetivab2326_std=enem_nota_objetiva_std_aux_`a' if ano==`a' & (codigo_uf==23|codigo_uf==26)

}

*padronizando notas de redação intra anos (2003 a 2009) e entre SP e GO
foreach a in 2003 2004 2005 2006 2007 2008 {
capture egen enem_nota_redacao3552_std_aux_`a'=std(enem_nota_redacao) if ano==`a' & (codigo_uf==35|codigo_uf==52)
}
capture egen enem_nota_redacao3552_std=std(enem_nota_redacao) if ano>=2009 & (codigo_uf==35|codigo_uf==52)

foreach a in 2003 2004 2005 2006 2007 2008 {
replace enem_nota_redacao3552_std=enem_nota_redacao_std_aux_`a' if ano==`a' & (codigo_uf==35|codigo_uf==52)
}

*padronizando notas objetiva intra anos (2003 a 2009) e entre SP e GO

foreach a in 2003 2004 2005 2006 2007 2008 {
capture egen enem_nota_objetiva3552_std_aux_`a'=std(enem_nota_objetiva) if ano==`a' &(codigo_uf==35|codigo_uf==52)
}

gen enem_nota_objetivab3552=(enem_nota_matematica +enem_nota_ciencias +enem_nota_humanas+enem_nota_linguagens)/4 if (codigo_uf==35|codigo_uf==52)
capture egen enem_nota_objetivab3552_std=std(enem_nota_objetivab) if ano>=2009 & (codigo_uf==35|codigo_uf==52)

foreach a in 2003 2004 2005 2006 2007 2008 {
replace enem_nota_objetivab3552_std=enem_nota_objetiva_std_aux_`a' if ano==`a' & (codigo_uf==35|codigo_uf==52)

}

*padronização das variáveis de fluxo para ensino médio
foreach x in "apr_em" "rep_em"  "aba_em" "dist_em" {
// padronização entre sp e go
egen `x'3552_std=std(`x') if (codigo_uf==35|codigo_uf==52) 
// padronização entre ce e pe
egen `x'2326_std=std(`x') if (codigo_uf==23|codigo_uf==26)
}

*dropando variáveis auxiliares

drop enem_nota_redacao26_std_aux_2003 - enem_nota_redacao26_std_aux_2008
drop enem_nota_redacao52_std_aux_2003 - enem_nota_redacao52_std_aux_2008
drop enem_nota_redacao35_std_aux_2003 - enem_nota_redacao35_std_aux_2008
drop enem_nota_redacao23_std_aux_2003 - enem_nota_redacao23_std_aux_2008
drop enem_nota_redacao33_std_aux_2003 - enem_nota_redacao33_std_aux_2008
*/
save "$folderservidor\enem\enem_todos_limpo.dta", replace 
log close
