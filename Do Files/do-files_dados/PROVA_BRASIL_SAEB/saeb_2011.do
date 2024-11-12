/*******************************SAEB 2011**************************************/


clear all
set more off
set trace on
/*
saeb está fundamentado na ideia de sistema, com o objetivo de desencadear um 
processo de avaliação, por meio de levantamento de informações a cada 2 anos,
que permita monitorar a evolução do quadro educacional brasileiro, a partir 
de dois pressupostos básicos:
o rendimento dos alunos reflete a qualidade do ensino ministrado;
nenhum fator determina, isoladamente, a qualidade do ensino.

duas avaliações:
	Aneb – Avaliação Nacional da Educação Básica, abrange de
maneira amostral os estudantes das redes públicas e particulars do país, 
localizados na área rural e urbana e matriculados no 5º e 9º anos do Ensino 
Fundamental (EF) e também no 3ª série do Ensino Médio (EM).
	Anresc - Avaliação Nacional do Rendimento Escolar, é aplicada 
censitariamente a alunos de 5º e 9º anos do ensino fundamental público, 
nas redes estaduais, municipais e federais, de área rural e urbana, em 
escolas que tenham no mínimo 20 alunos matriculados na série avaliada
(prova brasil)


Aneb 
produção de informação sobre os níveis de aprendizagem demonstrados pelos
alunos agregados por unidade escolar e nas respectivas redes de ensino. 
O Saeb é composto por uma parte censitária e uma parte amostral. A parte censitária é
constituída por escolas públicas com 20 ou mais alunos do 5º ano e 9º ano do Ensino
Fundamental. Já a parte amostral é formada por escolas particulars do 5º ano e 9º ano do Ensino
Fundamental com 10 ou mais alunos em turmas regulares, e também por escolas públicas e
particulars da 3ª série do Ensino Médio com 10 ou mais alunos em turmas regulares

*/


/*
Matemáticae e Português
	para 3º ano
	para 

Diretor
Docentes
Merge
*/

/*------------- Matemáticae e Português -------------*/
/*-------------       para 3º ano EM	-------------*/

*variáveis finais: 
*	ano_saeb, serie, turno,profic_p_esc_saeb_3, profic_250_p_saeb_3, 
*	profic_m_esc_saeb_3, profic_250_m_saeb_3, codigo_escola
import delimited "E:\SAEB Prova Brasil\microdados_saeb_2011\Arquivos Finais\Dados\TS_RESULTADO_ALUNO.csv", delimiter(";") case(upper) clear 

*ano do saeb
rename ID_SAEB ano_saeb

*código da unidade da federação
rename ID_UF codigo_uf

*código do município
rename ID_MUNICIPIO codigo_municipio

*código da escola
rename ID_ESCOLA codigo_escola

*turno da turma:
/*
	1 - Matutino
	2 - Vespertino
	3 - Noturno
	4 - Intermediário
*/
rename ID_TURNO turno

*série:
/*
5 - 4ª série/5º ano Ensino Fundamental
9 - 8ª série/9º ano Ensino Fundamental
12 - 3ª série Ensino Médio
*/
rename ID_SERIE serie

/*
Proficiência do aluno em Língua Portuguesa calculada na escala única do SAEB, 
com média = 0 e desvio = 1 na população de referência
*/
rename PROFICIENCIA_LP profic_p_esc_saeb_3

/*
Proficiência em Língua Portuguesa transformada na escala única do SAEB, 
com média = 250, desvio = 50 (do SAEB/97)
*/
rename PROFICIENCIA_LP_SAEB profic_250_p_saeb_3

/*
Proficiência do aluno em Matemática calculada na escala única do SAEB, 
com média = 0 e desvio = 1 na população de referência
*/
rename PROFICIENCIA_MT profic_m_esc_saeb_3

/*
Proficiência do aluno em Matemática transformada na escala única do SAEB, 
com média = 250, desvio = 50 (do SAEB/97)
*/
rename PROFICIENCIA_MT_SAEB profic_250_m_saeb_3


* obs: essas variáveis estão disponíveis para os 3 anos,
* mas para o resultado por escola (que vai estar para na próxima seção)
* temos somente para 5 e 9 ano, não para o 3. então,
* o referente ao terceiro ano será feito por aluno, e depois collapse.
* já as variávies referente serão feitas via as variáveis já agregadas por escola
*manter só 3 ano

keep if serie==12

*destring
	*substituindo ",", ".", por .
replace profic_p_esc_saeb_3=subinstr(profic_p_esc_saeb,",",".",.)
replace profic_250_p_saeb_3=subinstr(profic_250_p_saeb,",",".",.)
replace profic_m_esc_saeb_3=subinstr(profic_m_esc_saeb,",",".",.)
replace profic_250_m_saeb_3=subinstr(profic_250_m_saeb,",",".",.)

destring turno, replace

destring profic_p_esc_saeb_3, replace
destring profic_250_p_saeb_3, replace
destring profic_m_esc_saeb_3, replace
destring profic_250_m_saeb_3, replace

#delimit ;
collapse 
(mean) ano_saeb 
serie 
turno 
profic_p_esc_saeb_3 
profic_250_p_saeb_3 
profic_m_esc_saeb_3 
profic_250_m_saeb_3, 
by(codigo_escola)
;
#delimit cr
save "E:\bases_dta\saeb_prova_brasil\2011\saeb2011_notas_3.dta", replace

/*------------- Matemáticae e Português -------------*/
/*-------------      para 5º/9º EF		-------------*/
*variáveis finais: nota média por escola por ano e código da escola
foreach x in 5 9 {
import delimited "E:\SAEB Prova Brasil\microdados_saeb_2011\Arquivos Finais\Dados\TS_RESULTADO_ESCOLA.csv", delimiter(";") case(upper) clear 

rename ID_SAEB ano_saeb
rename ID_UF codigo_uf
rename ID_MUNICIPIO codigo_municipio
rename ID_ESCOLA codigo_escola
rename ID_SERIE serie

keep if serie==`x'

*Nota média dos participantes em Língua Portuguesa
rename MEDIA_LP media_lp_saeb_`x'

*Nota média dos participantes em Matemática
rename MEDIA_MT media_mt_saeb_`x'


*destring
	*substituindo ",", ".", por .
replace media_lp_saeb_`x'=subinstr(media_lp_saeb_`x',",",".",.)
replace media_mt_saeb_`x'=subinstr(media_mt_saeb_`x',",",".",.)

destring media_lp_saeb_`x', replace
destring media_mt_saeb_`x', replace

* não precisa de collpase pois os dados já estão por escola
keep codigo_escola ano_saeb media_lp_saeb_`x' media_mt_saeb_`x'

save "E:\bases_dta\saeb_prova_brasil\2011\saeb2011_notas_`x'.dta", replace


}
/*------------- Questionário Alunos -------------*/
* para 4ª série/5º ano do EF, para 8ªsérie/ 9º ano do EF e para 3º do EM
* variáveis finais: 
*	escolaridade da mãe e do pai
*	internet e empregada doméstica
foreach x in 5 9 3{

import delimited "E:\SAEB Prova Brasil\microdados_saeb_2011\Arquivos Finais\Dados\TS_QUEST_ALUNO.csv", delimiter(";") case(upper) clear 
replace ID_SERIE = 3 if ID_SERIE ==12
keep if ID_SERIE==`x'
**** Renomear e construir variáveis

rename ID_ESCOLA codigo_escola
rename ID_SAEB ano_saeb

*variável que indica se aluno tem computador com internet em casa
*Na sua casa tem computador?
*Sim, com internet.("A")

gen s_comp_internet_`x'=.
replace s_comp_internet_`x'=1 if TX_RESP_Q013=="A"
replace s_comp_internet_`x'=0 if TX_RESP_Q013=="B" | TX_RESP_Q013=="C"
*variável que indica se na casa do aluno trabalha alguma empregada doméstica
*Na sua casa trabalha alguma empregada doméstica?

gen s_empregada_diarista_`x'=.
replace s_empregada_diarista_`x'=1 if TX_RESP_Q015=="A" | TX_RESP_Q015=="B" | TX_RESP_Q015=="C"
*Não.("D")
replace s_empregada_diarista_`x'=0 if TX_RESP_Q015=="D"


*collapse
#delimit ;
collapse 
(mean) 
ano_saeb 
s_comp_internet_`x'
s_empregada_diarista_`x', 
by(codigo_escola);
#delimit cr

save "E:\bases_dta\saeb_prova_brasil\2011\saeb2011_alunos_`x'.dta", replace

}
/*------------- Diretor -------------*/
* variáveis finais: ano pb, método de escolha da direção
import delimited "E:\SAEB Prova Brasil\microdados_saeb_2011\Arquivos Finais\Dados\TS_QUEST_DIRETOR.csv", delimiter(";") case(upper) clear 


**** Renomear e construir variáveis

rename ID_ESCOLA codigo_escola
rename ID_SAEB ano_saeb

*criar variáveis

gen s_metodo_esc_dir_selecao=.
replace s_metodo_esc_dir_selecao=1 if TX_RESP_Q021=="A"
replace s_metodo_esc_dir_selecao=0 if TX_RESP_Q021=="B" | TX_RESP_Q021=="C" | TX_RESP_Q021=="D" | TX_RESP_Q021=="E" | TX_RESP_Q021=="F" | TX_RESP_Q021=="G"

gen s_metodo_esc_dir_eleicao=.
replace s_metodo_esc_dir_eleicao=1 if TX_RESP_Q021=="B"
replace s_metodo_esc_dir_eleicao=0 if TX_RESP_Q021=="A" | TX_RESP_Q021=="C" | TX_RESP_Q021=="D" | TX_RESP_Q021=="E" | TX_RESP_Q021=="F" | TX_RESP_Q021=="G"

gen s_metodo_esc_dir_sel_ele=.
replace s_metodo_esc_dir_sel_ele=1 if TX_RESP_Q021=="C"
replace s_metodo_esc_dir_sel_ele=0 if TX_RESP_Q021=="A" | TX_RESP_Q021=="C" | TX_RESP_Q021=="D" | TX_RESP_Q021=="E" | TX_RESP_Q021=="F" | TX_RESP_Q021=="G"

gen s_metodo_esc_dir_indic=.
replace s_metodo_esc_dir_indic=1 if TX_RESP_Q021=="D" | TX_RESP_Q021=="E" | TX_RESP_Q021=="F"
replace s_metodo_esc_dir_indic=0 if TX_RESP_Q021=="A" | TX_RESP_Q021=="B" | TX_RESP_Q021=="C" | TX_RESP_Q021=="G"

collapse (mean) ano_saeb s_metodo_esc_dir_selecao-s_metodo_esc_dir_indic, by (codigo_escola)

save "E:\bases_dta\saeb_prova_brasil\2011\saeb2011_dir.dta", replace

/*------------- Docentes -------------*/
* para 4ª série/5º ano do EF, para 8ªsérie/ 9º ano do EF e para 3º do EM
* variáveis finais: experiência do professor
foreach x in 5 9 3{
import delimited "E:\SAEB Prova Brasil\microdados_saeb_2011\Arquivos Finais\Dados\TS_QUEST_PROFESSOR.csv", delimiter(";") case(upper) clear 

rename ID_SAEB ano_saeb
rename ID_ESCOLA codigo_escola

replace ID_SERIE = 3 if ID_SERIE ==12
keep if ID_SERIE==`x'

*criar variáveis

gen s_exp_prof_mais_2_`x'=.
replace s_exp_prof_mais_2_`x'=1 if TX_RESP_Q017=="C" | TX_RESP_Q017=="D" | TX_RESP_Q017=="E" | TX_RESP_Q017=="F" | TX_RESP_Q017=="G" | TX_RESP_Q017=="H" 
replace s_exp_prof_mais_2_`x'=0 if TX_RESP_Q017=="A" | TX_RESP_Q017=="B"

gen s_exp_prof_escola_mais_2_`x'=.
replace s_exp_prof_escola_mais_2_`x'=1 if TX_RESP_Q018=="C" | TX_RESP_Q018=="D" | TX_RESP_Q018=="E" | TX_RESP_Q018=="F" | TX_RESP_Q018=="G" | TX_RESP_Q018=="H"
replace s_exp_prof_escola_mais_2_`x'=0 if TX_RESP_Q018=="A" | TX_RESP_Q018=="B"


collapse (mean) ano_saeb s_exp_prof_mais_2_`x' s_exp_prof_escola_mais_2_`x', by (codigo_escola)

save "E:\bases_dta\saeb_prova_brasil\2011\saeb2011_prof_`x'.dta", replace

}

/*------------- Merge -------------*/
foreach x in 5 9 3{
use "E:\bases_dta\saeb_prova_brasil\2011\saeb2011_notas_`x'.dta", clear
merge 1:1 codigo_escola using "E:\bases_dta\saeb_prova_brasil\2011\saeb2011_alunos_`x'.dta"
drop _merge
merge 1:1 codigo_escola using "E:\bases_dta\saeb_prova_brasil\2011\saeb2011_dir.dta"
drop _merge
merge 1:1 codigo_escola using "E:\bases_dta\saeb_prova_brasil\2011\saeb2011_prof_`x'.dta"
drop _merge
save "E:\bases_dta\saeb_prova_brasil\2011\saeb2011_`x'.dta", replace

}

use "E:\bases_dta\saeb_prova_brasil\2011\saeb2011_5.dta", replace
merge 1:1 codigo_escola using  "E:\bases_dta\saeb_prova_brasil\2011\saeb2011_9.dta"

drop _merge

merge 1:1 codigo_escola using  "E:\bases_dta\saeb_prova_brasil\2011\saeb2011_3.dta"
save "E:\bases_dta\saeb_prova_brasil\2011\saeb2011.dta", replace

