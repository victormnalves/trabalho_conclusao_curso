/*************************Prova Brasil 2011********************************/

clear all
set more off



/*
principal objetivo: oferecer um diagnóstico dos sistemas educacionais 
	brasileiros

A metodologia do Saeb/Prova Brasil baseia-se na aplicação de testes padronizados
de Língua Portuguesa e Matemática e Questionários Socioeconômicos a estudantes 
de 5º ano e 9º ano do Ensino Fundamental e 3ª série do Ensino Médio

diretores e professores também respondem a questinoários socioeconomicos 	
Avaliação Nacional da Educação Básica (Aneb)
Avaliação Nacional do Rendimento Escolar (Anresc) (Prova Brasil)

Participam da Prova Brasil (Anresc), as escolas que atendem a critérios de quantidade mínima
de estudantes nas séries avaliadas, permitindo gerar resultados por escola. A Prova Brasil avaliou
em 2011 todas as escolas com pelo menos 20 estudantes matriculados no 5º Ano (4ª Série) e 9º Ano
(8ª Série) do ensino fundamental regular, matriculados, em escolas públicas, localizadas em zona
urbana e rural. A Prova Brasil 2011 avaliou censitariamente 56.222 escolas, totalizando 4.286.276 de
alunos participantes

A parte amostral do SAEB é denominada de Aneb e manteve os procedimentos da avaliação
amostral das redes públicas e privadas. Em 2011, a parte amostral foi composta pelo seguinte
público-alvo:
	I. escolas que tenham de 10 a 19 estudantes matriculados no 5º ano (4ª série)
	ou 9º ano (8ª 	série) do ensino fundamental regular e público;
	II. escolas que tenham 10 ou mais estudantes matriculados no 5º ano (4ª série) 
	ou 9º ano (8ª série) do ensino fundamental regular e privado;
	III. escolas que tenham 10 ou mais estudantes matriculados na 3ª série do 
	ensino médio regular público ou privado.
*/
*****baseado no "import prova brasil 2011.do"

/*
resultados escolas
questionário alunos
Notas alunos (para pegar código da escola)
Diretor
Docentes
merge
*/

/*------------- Resultado Alunos -------------*/
* para 4ª série/5º ano do EF e para 8ªsérie/ 9º ano do EF
* variáveis finais: 
* ano da pb, média lingua port, média mat, número de particip
* codigo_escola
foreach x in 5 9 {
import delimited "E:\SAEB Prova Brasil\microdados_prova_brasil_2011\Microdados Prova Brasil 2011\Dados\TS_RESULTADO_ESCOLA.csv", delimiter(";") case(upper) clear 
keep if ID_SERIE==`x'
rename ID_PROVA_BRASIL ano_prova_brasil
rename ID_ESCOLA codigo_escola
rename MEDIA_LP media_lp_prova_brasil_`x'
rename MEDIA_MT media_mt_prova_brasil_`x'
rename TAXA_PARTICIPACAO pb_tx_partic_`x'




*destring
*substituindo ",", ".", por .
replace media_lp_prova_brasil_`x'=subinstr(media_lp_prova_brasil_`x',",",".",.)
replace media_mt_prova_brasil_`x'=subinstr(media_mt_prova_brasil_`x',",",".",.)
replace pb_tx_partic_`x' =subinstr(pb_tx_partic_`x',",",".",.)

destring media_lp_prova_brasil_`x', replace
destring media_mt_prova_brasil_`x', replace
destring pb_tx_partic_`x', replace
# delimit ;
collapse 
(mean) ano_prova_brasil 
media_lp_prova_brasil_`x' 
media_mt_prova_brasil_`x'
pb_tx_partic_`x', by(codigo_escola)
;
#delimit cr
save "E:\bases_dta\saeb_prova_brasil\2011\provabrasil2011_notas_`x'.dta", replace

}

/*------------- Questionário Alunos -------------*/
* para 4ª série/5º ano do EF e para 8ªsérie/ 9º ano do EF
* variáveis finais: 
*	escolaridade da mãe e do pai
*	internet e empregada doméstica

foreach x in 5 9 {
import delimited "E:\SAEB Prova Brasil\microdados_prova_brasil_2011\Microdados Prova Brasil 2011\Dados\TS_QUEST_ALUNO.csv", delimiter(";") case(upper) clear 

keep if ID_SERIE==`x'

**** Renomear e construir variáveis

rename ID_ESCOLA codigo_escola
rename ID_PROVA_BRASIL ano_prova_brasil
*Na sua casa tem computador?
gen pb_comp_internet_`x'=.
*Sim, com internet. ("A")
replace pb_comp_internet_`x'=1 if TX_RESP_Q013=="A" 
replace pb_comp_internet_`x'=0 if TX_RESP_Q013=="B" | TX_RESP_Q013=="C"

*Na sua casa trabalha alguma empregada doméstica?
gen pb_empregada_diarista_`x'=.
replace pb_empregada_diarista_`x'=1 if TX_RESP_Q015=="A" | TX_RESP_Q015=="B" | TX_RESP_Q015=="C"
*Não ("D")
replace pb_empregada_diarista_`x'=0 if TX_RESP_Q015=="D"

*variável que indica se mãe completou ensino superior
*Até que série sua mãe ou a mulher responsável por você estudou?
gen pb_esc_sup_mae_`x'=.
*Completou a Faculdade. ("F")
replace pb_esc_sup_mae_`x'=1 if TX_RESP_Q019=="F" 
replace pb_esc_sup_mae_`x'=0 if TX_RESP_Q019=="A"|TX_RESP_Q019=="B"|TX_RESP_Q019=="C"|TX_RESP_Q019=="D"|TX_RESP_Q019=="E"

*variável que indica se pai completou ensino superior
*Até que série seu pai ou o homem responsável por você estudou?
gen pb_esc_sup_pai_`x'=.
*Completou a Faculdade. ("F")
replace pb_esc_sup_pai_`x'=1 if TX_RESP_Q023=="F" 
replace pb_esc_sup_pai_`x'=0 if TX_RESP_Q023=="A"|TX_RESP_Q023=="B"|TX_RESP_Q023=="C"|TX_RESP_Q023=="D"|TX_RESP_Q023=="E"

*collapse
#delimit ;
collapse 
(mean) ano_prova_brasil 
pb_comp_internet_`x' 
pb_empregada_diarista_`x' 
pb_esc_sup_mae_`x' 
pb_esc_sup_pai_`x', 
by(codigo_escola)
;
#delimit cr
save "E:\bases_dta\saeb_prova_brasil\2011\provabrasil2011_alunos_`x'.dta", replace


}

/*------------- Diretor -------------*/
* variáveis finais: ano pb, método de escolha da direção


import delimited "E:\SAEB Prova Brasil\microdados_prova_brasil_2011\Microdados Prova Brasil 2011\Dados\TS_QUEST_DIRETOR.csv", delimiter(";") case(upper) clear 

**** Renomear e construir variáveis

rename ID_ESCOLA codigo_escola
rename ID_PROVA_BRASIL ano_prova_brasil

*criar variáveis

gen pb_metodo_esc_dir_selecao=.
replace pb_metodo_esc_dir_selecao=1 if TX_RESP_Q021=="A"
replace pb_metodo_esc_dir_selecao=0 if TX_RESP_Q021=="B" | TX_RESP_Q021=="C" | TX_RESP_Q021=="D" | TX_RESP_Q021=="E" | TX_RESP_Q021=="F" | TX_RESP_Q021=="G"

gen pb_metodo_esc_dir_eleicao=.
replace pb_metodo_esc_dir_eleicao=1 if TX_RESP_Q021=="B"
replace pb_metodo_esc_dir_eleicao=0 if TX_RESP_Q021=="A" | TX_RESP_Q021=="C" | TX_RESP_Q021=="D" | TX_RESP_Q021=="E" | TX_RESP_Q021=="F" | TX_RESP_Q021=="G"

gen pb_metodo_esc_dir_sel_ele=.
replace pb_metodo_esc_dir_sel_ele=1 if TX_RESP_Q021=="C"
replace pb_metodo_esc_dir_sel_ele=0 if TX_RESP_Q021=="A" | TX_RESP_Q021=="B" | TX_RESP_Q021=="D" | TX_RESP_Q021=="E" | TX_RESP_Q021=="F" | TX_RESP_Q021=="G"

gen pb_metodo_esc_dir_indic=.
replace pb_metodo_esc_dir_indic=1 if TX_RESP_Q021=="D" | TX_RESP_Q021=="E" | TX_RESP_Q021=="F"
replace pb_metodo_esc_dir_indic=0 if TX_RESP_Q021=="A" | TX_RESP_Q021=="B" | TX_RESP_Q021=="C" | TX_RESP_Q021=="G"

collapse (mean) ano_prova_brasil pb_metodo_esc_dir_selecao-pb_metodo_esc_dir_indic, by (codigo_escola)

save "E:\bases_dta\saeb_prova_brasil\2011\provabrasil2011_dir.dta", replace


/*------------- Docentes -------------*/
* para 4ª série/5º ano do EF e para 8ªsérie/ 9º ano do EF
* variáveis finais: experiência dos professores
foreach x in 5 9 {
import delimited "E:\SAEB Prova Brasil\microdados_prova_brasil_2011\Microdados Prova Brasil 2011\Dados\TS_QUEST_PROFESSOR.csv", delimiter(";") case(upper) clear 

**** Renomear e construir variáveis

rename ID_PROVA_BRASIL ano_prova_brasil
rename ID_ESCOLA codigo_escola

keep if ID_SERIE==`x'


*variável de experiência do professor
*obs: aqui a dummy é definida com 2 anos de experiência, e não 3 anos como
* ocorreu nos casos anteriores. isso por que o questionário possui as opções
*menos de 1 ano, de 1 a menos de 2 anos, de 2  a menos de 5 anos
gen pb_exp_prof_mais_2_`x'=.
replace pb_exp_prof_mais_2_`x'=1 if TX_RESP_Q017=="C" | TX_RESP_Q017=="D" | TX_RESP_Q017=="E" | TX_RESP_Q017=="F" | TX_RESP_Q017=="G" | TX_RESP_Q017=="H" 
replace pb_exp_prof_mais_2_`x'=0 if TX_RESP_Q017=="A" | TX_RESP_Q017=="B"

gen pb_exp_prof_escola_mais_2_`x'=.
replace pb_exp_prof_escola_mais_2_`x'=1 if TX_RESP_Q018=="C" | TX_RESP_Q018=="D" | TX_RESP_Q018=="E" | TX_RESP_Q018=="F" | TX_RESP_Q018=="G" | TX_RESP_Q018=="H"
replace pb_exp_prof_escola_mais_2_`x'=0 if TX_RESP_Q018=="A" | TX_RESP_Q018=="B"

#delimit ;
collapse 
(mean) ano_prova_brasil 
pb_exp_prof_mais_2_`x' 
pb_exp_prof_escola_mais_2_`x', 
by (codigo_escola)
;
#delimit cr
save "E:\bases_dta\saeb_prova_brasil\2011\provabrasil2011_prof_`x'.dta", replace

}
/*------------- Merge -------------*/
foreach x in 5 9 {
use "E:\bases_dta\saeb_prova_brasil\2011\provabrasil2011_notas_`x'.dta", clear
merge 1:1 codigo_escola using "E:\bases_dta\saeb_prova_brasil\2011\provabrasil2011_alunos_`x'.dta"
drop _merge
merge 1:1 codigo_escola using "E:\bases_dta\saeb_prova_brasil\2011\provabrasil2011_dir.dta"
drop _merge
merge 1:1 codigo_escola using "E:\bases_dta\saeb_prova_brasil\2011\provabrasil2011_prof_`x'.dta"
drop _merge
save "E:\bases_dta\saeb_prova_brasil\2011\provabrasil2011_`x'.dta", replace

}
use "E:\bases_dta\saeb_prova_brasil\2011\provabrasil2011_5.dta", clear
merge 1:1 codigo_escola using "E:\bases_dta\saeb_prova_brasil\2011\provabrasil2011_9.dta"
drop _merge
save "E:\bases_dta\saeb_prova_brasil\2011\provabrasil2011.dta", replace
