/*************************Prova Brasil 2009********************************/

clear all
set more off
set trace on

/*
saeb: aneb (avaliação nacional da educação básica) e anresc (prova brasil)

	escolas participantes da avaliação em 2009: considerando aquelas que possuíam 
	estudantes matriculados nas etapas conclusivas do Ensino Fundamental e Médio, 
	quais sejam, o 5º e 9º anos do Ensino Fundamental de 9 anos, a 4ª e 8ª séries 
	do Ensino Fundamental de 8 anos e a 3ª série do Ensino Médio
	
	testes de língua portuguesa e matemática e questionários
	
	condições intra e extra-escolares que incidem sobre o processo de ensino e 
	aprendizagem
		
	questionários dos alunos
	
	questionários aplicados aos diretores e professores
	
	dados gerais da escola
	
	anresc (prova brasil): tem por objetivo produzir um diagnóstico do 
	desempenho dos alunos em termos de aquisição de habilidades e	
	competências e não somente de aprendizagem de conteúdos
	
	O público alvo da Anresc (Prova Brasil) 2009 constituiu-se de todas as
	turmas de 4ª e 8ª séries do ensino fundamental regular (em regime de 8 
	anos) e de 5º e 9º anos (em regime de 9 anos) de escolas públicas, 
	localizadas em zona urbana e rural, desde que possuíssem pelo menos 20 
	alunos nas séries e anos avaliados
*/

*****baseado no "import prova brasil 2009.do"
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
import delimited "E:\SAEB Prova Brasil\microdados_prova_brasil_2009_2\TS_RESULTADO_ESCOLA.txt", delimiter(";") clear 
keep if id_serie==`x'
rename pk_cod_entidade codigo_escola
rename nu_media_port media_lp_prova_brasil_`x'
rename nu_media_mat media_mt_prova_brasil_`x'
rename nu_participantes pb_n_partic_`x'

*ano
gen ano_prova_brasil=2009





# delimit ;
collapse (mean) 
ano_prova_brasil 
media_lp_prova_brasil_`x' 
media_mt_prova_brasil_`x' 
pb_n_partic_`x', 
by(codigo_escola);

# delimit cr
save "E:\bases_dta\saeb_prova_brasil\2009\provabrasil2009_notas_`x'.dta", replace

}
/*------------- Questionário Alunos -------------*/
* para 4ª série/5º ano do EF e para 8ªsérie/ 9º ano do EF
* variáveis finais: escolaridade da mãe e do pai
foreach x in 5 9 {
import delimited "E:\SAEB Prova Brasil\microdados_prova_brasil_2009_2\TS_QUEST_ALUNO.txt", delimiter(";") clear 
keep if id_serie==`x'

gen ano_prova_brasil=2009

*mãe educ
gen mae=substr(tx_respostas,19,1)
*pai educ
gen pai=substr(tx_respostas,23,1)

gen pb_esc_sup_mae_`x'=.
replace pb_esc_sup_mae_`x'=1 if mae=="E" 
replace pb_esc_sup_mae_`x'=0 if mae=="A"|mae=="B"|mae=="C"|mae=="D"|mae=="F"

gen pb_esc_sup_pai_`x'=.
replace pb_esc_sup_pai_`x'=1 if pai=="E" 
replace pb_esc_sup_pai_`x'=0 if pai=="A"|pai=="B"|pai=="C"|pai=="D"|pai=="F"
save "E:\bases_dta\saeb_prova_brasil\2009\provabrasil2009_alunos_semcod_`x'.dta", replace

*associando com o código de escola
import delimited "E:\SAEB Prova Brasil\microdados_prova_brasil_2009_2\TS_ALUNO.txt", delimiter(";") clear 
keep id_aluno pk_cod_entidade id_serie
keep if id_serie==`x'

rename pk_cod_entidade codigo_escola

merge 1:1 id_aluno using "E:\bases_dta\saeb_prova_brasil\2009\provabrasil2009_alunos_semcod_`x'.dta"

*collapse

collapse (mean) ano_prova_brasil pb_esc_sup_mae_`x' pb_esc_sup_pai_`x', by(codigo_escola)

save "E:\bases_dta\saeb_prova_brasil\2009\provabrasil2009_alunos_`x'.dta", replace


}
/*------------- Diretor -------------*/
* variáveis finais: ano pb, método de escolha da direção
import delimited "E:\SAEB Prova Brasil\microdados_prova_brasil_2009_2\TS_QUEST_DIRETOR.txt", delimiter(";") clear 

**** Renomear e construir variáveis

rename pk_cod_entidade codigo_escola
gen ano_prova_brasil=2009

*criar variáveis
*no questionário, a pergunta 21 é a referente ao método de escolha da direção
gen metodo=substr(tx_resp_questionario,21,1)

gen pb_metodo_esc_dir_selecao=.
replace pb_metodo_esc_dir_selecao=1 if metodo=="A"
replace pb_metodo_esc_dir_selecao=0 if metodo=="B" | metodo=="C" | metodo=="D" | metodo=="E" | metodo=="F" | metodo=="G"

gen pb_metodo_esc_dir_eleicao=.
replace pb_metodo_esc_dir_eleicao=1 if metodo=="B"
replace pb_metodo_esc_dir_eleicao=0 if metodo=="A" | metodo=="C" | metodo=="D" | metodo=="E" | metodo=="F" | metodo=="G"

gen pb_metodo_esc_dir_sel_ele=.
replace pb_metodo_esc_dir_sel_ele=1 if metodo=="C"
replace pb_metodo_esc_dir_sel_ele=0 if metodo=="A" | metodo=="B" | metodo=="D" | metodo=="E" | metodo=="F" | metodo=="G"

gen pb_metodo_esc_dir_indic=.
replace pb_metodo_esc_dir_indic=1 if metodo=="D" | metodo=="E" | metodo=="F"
replace pb_metodo_esc_dir_indic=0 if metodo=="A" | metodo=="B" | metodo=="C" | metodo=="G"

collapse (mean) ano_prova_brasil pb_metodo_esc_dir_selecao-pb_metodo_esc_dir_indic, by (codigo_escola)

save "E:\bases_dta\saeb_prova_brasil\2009\provabrasil2009_dir.dta", replace


/*------------- Docentes -------------*/
* para 4ª série/5º ano do EF e para 8ªsérie/ 9º ano do EF
* variáveis finais: experiência dos professores
foreach x in 5 9 {

import delimited "E:\SAEB Prova Brasil\microdados_prova_brasil_2009_2\TS_QUEST_PROFESSOR.txt", delimiter(";") clear 

**** Renomear e construir variáveis

gen ano_prova_brasil=2009
rename pk_cod_entidade codigo_escola

keep if id_serie==`x'
* criar variáveis
* as perguntas referentes a experiência estão na posição 17 e 18 do quest
gen prof1=substr(tx_resp_questionario,17,1)
gen prof2=substr(tx_resp_questionario,18,1)

gen pb_exp_prof_mais_3_`x'=.
replace pb_exp_prof_mais_3_`x'=1 if prof1=="C" | prof1=="D" | prof1=="E" | prof1=="F" | prof1=="G"
replace pb_exp_prof_mais_3_`x'=0 if prof1=="A" | prof1=="B"

gen pb_exp_prof_escola_mais_3_`x'=.
replace pb_exp_prof_escola_mais_3_`x'=1 if prof2=="C" | prof2=="D" | prof2=="E" | prof2=="F" | prof2=="G" 
replace pb_exp_prof_escola_mais_3_`x'=0 if prof2=="A" | prof2=="B"

# delimit ;
collapse 
(mean) ano_prova_brasil 
pb_exp_prof_mais_3_`x' 
pb_exp_prof_escola_mais_3_`x', 
by (codigo_escola)
;
# delimit cr
save "E:\bases_dta\saeb_prova_brasil\2009\provabrasil2009_prof_`x'.dta", replace

}

/*------------- Merge -------------*/
foreach x in 5 9 {

use "E:\bases_dta\saeb_prova_brasil\2009\provabrasil2009_notas_`x'.dta", clear
merge 1:1 codigo_escola using "E:\bases_dta\saeb_prova_brasil\2009\provabrasil2009_alunos_`x'.dta"
drop _merge
merge 1:1 codigo_escola using "E:\bases_dta\saeb_prova_brasil\2009\provabrasil2009_dir.dta"
drop _merge
merge 1:1 codigo_escola using "E:\bases_dta\saeb_prova_brasil\2009\provabrasil2009_prof_`x'.dta"
drop _merge
save "E:\bases_dta\saeb_prova_brasil\2009\provabrasil2009_`x'.dta", replace

}

use "E:\bases_dta\saeb_prova_brasil\2009\provabrasil2009_5.dta", clear
merge 1:1 codigo_escola using "E:\bases_dta\saeb_prova_brasil\2009\provabrasil2009_9.dta"
drop _merge
save "E:\bases_dta\saeb_prova_brasil\2009\provabrasil2009.dta", replace
