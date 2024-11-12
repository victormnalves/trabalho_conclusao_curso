/*************************Prova Brasil 2011********************************/

clear all
set more off
set trace on


/*
principal objetivo: oferecer um diagn�stico dos sistemas educacionais 
	brasileiros

A metodologia do Saeb/Prova Brasil baseia-se na aplica��o de testes padronizados
de L�ngua Portuguesa e Matem�tica e Question�rios Socioecon�micos a estudantes 
de 5� ano e 9� ano do Ensino Fundamental e 3� s�rie do Ensino M�dio

diretores e professores tamb�m respondem a questino�rios socioeconomicos 	
Avalia��o Nacional da Educa��o B�sica (Aneb)
Avalia��o Nacional do Rendimento Escolar (Anresc) (Prova Brasil)

Participam da Prova Brasil (Anresc), as escolas que atendem a crit�rios de quantidade m�nima
de estudantes nas s�ries avaliadas, permitindo gerar resultados por escola. A Prova Brasil avaliou
em 2011 todas as escolas com pelo menos 20 estudantes matriculados no 5� Ano (4� S�rie) e 9� Ano
(8� S�rie) do ensino fundamental regular, matriculados, em escolas p�blicas, localizadas em zona
urbana e rural. A Prova Brasil 2011 avaliou censitariamente 56.222 escolas, totalizando 4.286.276 de
alunos participantes

A parte amostral do SAEB � denominada de Aneb e manteve os procedimentos da avalia��o
amostral das redes p�blicas e privadas. Em 2011, a parte amostral foi composta pelo seguinte
p�blico-alvo:
	I. escolas que tenham de 10 a 19 estudantes matriculados no 5� ano (4� s�rie)
	ou 9� ano (8� 	s�rie) do ensino fundamental regular e p�blico;
	II. escolas que tenham 10 ou mais estudantes matriculados no 5� ano (4� s�rie) 
	ou 9� ano (8� s�rie) do ensino fundamental regular e privado;
	III. escolas que tenham 10 ou mais estudantes matriculados na 3� s�rie do 
	ensino m�dio regular p�blico ou privado.
*/
*****baseado no "import prova brasil 2011.do"

/*
resultados escolas
question�rio alunos
Notas alunos (para pegar c�digo da escola)
Diretor
Docentes
merge
*/

/*------------- Resultado Alunos -------------*/
* para 4� s�rie/5� ano do EF e para 8�s�rie/ 9� ano do EF
* vari�veis finais: 
* ano da pb, m�dia lingua port, m�dia mat, n�mero de particip
* codigo_escola
foreach x in 5 9 {
import delimited "E:\SAEB Prova Brasil\microdados_prova_brasil_2011\Microdados Prova Brasil 2011\Dados\TS_RESULTADO_ESCOLA.csv", delimiter(";") case(upper) clear 

rename ID_PROVA_BRASIL ano_prova_brasil
rename ID_ESCOLA codigo_escola
rename MEDIA_LP media_lp_prova_brasil_`x'
rename MEDIA_MT media_mt_prova_brasil_`x'
rename TAXA_PARTICIPACAO pb_tx_partic_`x'

keep if ID_SERIE==`x'


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

/*------------- Question�rio Alunos -------------*/
* para 4� s�rie/5� ano do EF e para 8�s�rie/ 9� ano do EF
* vari�veis finais: 
*	escolaridade da m�e e do pai
*	internet e empregada dom�stica

foreach x in 5 9 {
import delimited "E:\SAEB Prova Brasil\microdados_prova_brasil_2011\Microdados Prova Brasil 2011\Dados\TS_QUEST_ALUNO.csv", delimiter(";") case(upper) clear 

keep if ID_SERIE==`x'

**** Renomear e construir vari�veis

rename ID_ESCOLA codigo_escola
rename ID_PROVA_BRASIL ano_prova_brasil
*Na sua casa tem computador?
gen pb_comp_internet_`x'=.
*Sim, com internet. ("A")
replace pb_comp_internet_`x'=1 if TX_RESP_Q013=="A" 
replace pb_comp_internet_`x'=0 if TX_RESP_Q013=="B" | TX_RESP_Q013=="C"

*Na sua casa trabalha alguma empregada dom�stica?
gen pb_empregada_diarista_`x'=.
replace pb_empregada_diarista_`x'=1 if TX_RESP_Q015=="A" | TX_RESP_Q015=="B" | TX_RESP_Q015=="C"
*N�o ("D")
replace pb_empregada_diarista_`x'=0 if TX_RESP_Q015=="D"

*vari�vel que indica se m�e completou ensino superior
*At� que s�rie sua m�e ou a mulher respons�vel por voc� estudou?
gen pb_esc_sup_mae_`x'=.
*Completou a Faculdade. ("F")
replace pb_esc_sup_mae_`x'=1 if TX_RESP_Q019=="F" 
replace pb_esc_sup_mae_`x'=0 if TX_RESP_Q019=="A"|TX_RESP_Q019=="B"|TX_RESP_Q019=="C"|TX_RESP_Q019=="D"|TX_RESP_Q019=="E"

*vari�vel que indica se pai completou ensino superior
*At� que s�rie seu pai ou o homem respons�vel por voc� estudou?
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
* vari�veis finais: ano pb, m�todo de escolha da dire��o


import delimited "E:\SAEB Prova Brasil\microdados_prova_brasil_2011\Microdados Prova Brasil 2011\Dados\TS_QUEST_DIRETOR.csv", delimiter(";") case(upper) clear 

**** Renomear e construir vari�veis

rename ID_ESCOLA codigo_escola
rename ID_PROVA_BRASIL ano_prova_brasil

*criar vari�veis

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
* para 4� s�rie/5� ano do EF e para 8�s�rie/ 9� ano do EF
* vari�veis finais: experi�ncia dos professores
foreach x in 5 9 {
import delimited "E:\SAEB Prova Brasil\microdados_prova_brasil_2011\Microdados Prova Brasil 2011\Dados\TS_QUEST_PROFESSOR.csv", delimiter(";") case(upper) clear 

**** Renomear e construir vari�veis

rename ID_PROVA_BRASIL ano_prova_brasil
rename ID_ESCOLA codigo_escola

keep if ID_SERIE==`x'


*vari�vel de experi�ncia do professor
*obs: aqui a dummy � definida com 2 anos de experi�ncia, e n�o 3 anos como
* ocorreu nos casos anteriores. isso por que o question�rio possui as op��es
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
