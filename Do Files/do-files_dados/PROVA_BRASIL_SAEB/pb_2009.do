/*************************Prova Brasil 2009********************************/

clear all
set more off
set trace on

/*
saeb: aneb (avalia��o nacional da educa��o b�sica) e anresc (prova brasil)

	escolas participantes da avalia��o em 2009: considerando aquelas que possu�am 
	estudantes matriculados nas etapas conclusivas do Ensino Fundamental e M�dio, 
	quais sejam, o 5� e 9� anos do Ensino Fundamental de 9 anos, a 4� e 8� s�ries 
	do Ensino Fundamental de 8 anos e a 3� s�rie do Ensino M�dio
	
	testes de l�ngua portuguesa e matem�tica e question�rios
	
	condi��es intra e extra-escolares que incidem sobre o processo de ensino e 
	aprendizagem
		
	question�rios dos alunos
	
	question�rios aplicados aos diretores e professores
	
	dados gerais da escola
	
	anresc (prova brasil): tem por objetivo produzir um diagn�stico do 
	desempenho dos alunos em termos de aquisi��o de habilidades e	
	compet�ncias e n�o somente de aprendizagem de conte�dos
	
	O p�blico alvo da Anresc (Prova Brasil) 2009 constituiu-se de todas as
	turmas de 4� e 8� s�ries do ensino fundamental regular (em regime de 8 
	anos) e de 5� e 9� anos (em regime de 9 anos) de escolas p�blicas, 
	localizadas em zona urbana e rural, desde que possu�ssem pelo menos 20 
	alunos nas s�ries e anos avaliados
*/

*****baseado no "import prova brasil 2009.do"
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
/*------------- Question�rio Alunos -------------*/
* para 4� s�rie/5� ano do EF e para 8�s�rie/ 9� ano do EF
* vari�veis finais: escolaridade da m�e e do pai
foreach x in 5 9 {
import delimited "E:\SAEB Prova Brasil\microdados_prova_brasil_2009_2\TS_QUEST_ALUNO.txt", delimiter(";") clear 
keep if id_serie==`x'

gen ano_prova_brasil=2009

*m�e educ
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

*associando com o c�digo de escola
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
* vari�veis finais: ano pb, m�todo de escolha da dire��o
import delimited "E:\SAEB Prova Brasil\microdados_prova_brasil_2009_2\TS_QUEST_DIRETOR.txt", delimiter(";") clear 

**** Renomear e construir vari�veis

rename pk_cod_entidade codigo_escola
gen ano_prova_brasil=2009

*criar vari�veis
*no question�rio, a pergunta 21 � a referente ao m�todo de escolha da dire��o
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
* para 4� s�rie/5� ano do EF e para 8�s�rie/ 9� ano do EF
* vari�veis finais: experi�ncia dos professores
foreach x in 5 9 {

import delimited "E:\SAEB Prova Brasil\microdados_prova_brasil_2009_2\TS_QUEST_PROFESSOR.txt", delimiter(";") clear 

**** Renomear e construir vari�veis

gen ano_prova_brasil=2009
rename pk_cod_entidade codigo_escola

keep if id_serie==`x'
* criar vari�veis
* as perguntas referentes a experi�ncia est�o na posi��o 17 e 18 do quest
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
