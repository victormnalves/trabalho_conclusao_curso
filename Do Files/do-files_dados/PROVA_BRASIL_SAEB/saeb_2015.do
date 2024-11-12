/*******************************SAEB 2015**************************************/
clear all
set more off
set trace on


{/* variáveis finais:
	TS_ALUNO_3EM
	ano_saeb codigo_escola turno profic_p_esc_saeb_3 profic_250_p_saeb_3
	profic_m_esc_saeb_3 profic_250_m_saeb_3
	s_empregada_5vez_3
	
	TS_ALUNO_9EF
	ano_saeb codigo_escola participacao_prova_brasil 
	profic_p_esc_saeb_9 profic_250_p_saeb_9
	profic_m_esc_saeb_9 profic_250_m_saeb_9
	s_empregada_5vez_9
	
	TS_ALUNO_5EF
	ano_saeb codigo_escola participacao_prova_brasil 
	profic_p_esc_saeb_5 profic_250_p_saeb_5
	profic_m_esc_saeb_5 profic_250_m_saeb_5
	s_empregada_5vez_5
	
	TS_DIRETOR
	codigo_escola ano_saeb
	s_metodo_esc_dir_concurso s_metodo_esc_dir_selecao 
	s_metodo_esc_dir_eleicao s_metodo_esc_dir_sel_ele
	s_metodo_esc_dir_indic s_metodo_esc_dir_sel_indic
	
*/}

/*
saeb está fundamentado na ideia de sistema, com o objetivo de desencadear um 
processo de avaliação, por meio de levantamento de informações a cada 2 anos,
que permita monitorar a evolução do quadro educacional brasileiro, a partir 
de dois pressupostos básicos:
	o desempenho dos alunos é uma das evidências a respeito da qualidade do 
	ensino ministrado;
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

Os microdados são apresentados na mesma estrutura da edição anterior, 
qual seja:
	1. apresentação conjunta das bases de dados da Aneb e Anresc;
	2. base de dados reunidas por ano/série avaliados;
	3. integração da base de resultados de alunos e escolas com as bases dos respectivos questionários
	contextuais.

*/
/*-------------    Matemática, Português e Questionário Alunos  	-------------*/
/*-------------  				 	3º ano							-------------*/
/* 
variáveis finais:
	ano_saeb codigo_escola turno profic_p_esc_saeb_3 profic_250_p_saeb_3
	profic_m_esc_saeb_3 profic_250_m_saeb_3
	s_empregada_5vez_3
*/
clear all
set more off
set trace on

import delimited "E:\SAEB Prova Brasil\microdados_saeb_2015\DADOS\TS_ALUNO_3EM.csv", delimiter(",") case(upper) clear 


*Renomaer
*Ano da ANEB/Prova Brasil
rename ID_PROVA_BRASIL ano_saeb

*Código da Escola
rename ID_ESCOLA codigo_escola

*Turno da Turma
rename ID_TURNO turno

*Proficiência do aluno em Língua Portuguesa calculada na escala única do SAEB, 
*com média = 0 e desvio = 1 na população de referência
rename PROFICIENCIA_LP profic_p_esc_saeb_3

*Proficiência em Língua Portuguesa transformada na escala única do SAEB, 
*com média = 250, desvio = 50 (do SAEB/97)
rename PROFICIENCIA_LP_SAEB profic_250_p_saeb_3

*Proficiência do aluno em Matemática calculada na escala única do SAEB, 
*com média = 0 e desvio = 1 na população de referência
rename PROFICIENCIA_MT profic_m_esc_saeb_3

*Proficiência do aluno em Matemática transformada na escala única do SAEB, 
*com média = 250, desvio = 50 (do SAEB/97)
rename PROFICIENCIA_MT_SAEB profic_250_m_saeb_3

*Variáveis do questionário
*Na sua casa tem computador?
*Não tem.("A")

gen s_comp_3=.
replace s_comp_3=1 if TX_RESP_Q013=="A"
replace s_comp_3=0 if TX_RESP_Q013=="B" | TX_RESP_Q013=="C" | TX_RESP_Q013=="D" | TX_RESP_Q013=="E"

*Em sua casa trabalha empregado(a) doméstico(a) pelo menos cinco dias por semana?
*não tem. ("A")
gen s_empregada_5vez_3=.
replace s_empregada_5vez_3=1 if TX_RESP_Q017=="B" | TX_RESP_Q017=="C" | TX_RESP_Q017=="D" | TX_RESP_Q017=="E"
replace s_empregada_5vez_3=0 if TX_RESP_Q017=="A"
#delimit ;
collapse 
(mean) 
ano_saeb 
turno 
profic_p_esc_saeb_3 
profic_250_p_saeb_3 
profic_m_esc_saeb_3 
profic_250_m_saeb_3 
s_empregada_5vez_3, 
by(codigo_escola)
;
#delimit cr
save "E:\bases_dta\saeb_prova_brasil\2015\saeb2015_notas_alunos_3.dta", replace

*comentado, excel e conferido 19/07/2018



/*------------- Matemática, Português e Questionário Alunos -------------*/
/*------------- 				  9º ano EF					-------------*/			
/* 
variáveis finais:
	ano_saeb codigo_escola participacao_prova_brasil 
	profic_p_esc_saeb_9 profic_250_p_saeb_9
	profic_m_esc_saeb_9 profic_250_m_saeb_9
	s_empregada_5vez_9
*/
clear all
set more off
set trace on

import delimited "E:\SAEB Prova Brasil\microdados_saeb_2015\DADOS\TS_ALUNO_9EF.csv", delimiter(",") case(upper) clear 

*Renomaer
*Ano da ANEB/Prova Brasil
rename ID_PROVA_BRASIL ano_saeb
*Código da Escola
rename ID_ESCOLA codigo_escola
*Indicador de participação na Prova Brasil
rename IN_PROVA_BRASIL participacao_prova_brasil

*Proficiência do aluno em Língua Portuguesa calculada na escala única do SAEB, 
*com média = 0 e desvio = 1 na população de referência
rename PROFICIENCIA_LP profic_p_esc_saeb_9
*Proficiência em Língua Portuguesa transformada na escala única do SAEB, 
*com média = 250, desvio = 50 (do SAEB/97)
rename PROFICIENCIA_LP_SAEB profic_250_p_saeb_9
*Proficiência do aluno em Matemática calculada na escala única do SAEB, 
*com média = 0 e desvio = 1 na população de referência
rename PROFICIENCIA_MT profic_m_esc_saeb_9
*Proficiência do aluno em Matemática transformada na escala única do SAEB, 
*com média = 250, desvio = 50 (do SAEB/97)
rename PROFICIENCIA_MT_SAEB profic_250_m_saeb_9

*Manter só SAEB

keep if participacao_prova_brasil==0

*Variáveis do questionário
*Variáveis do questionário
*Na sua casa tem computador?
*Não tem.("A")

gen s_comp_9=.
replace s_comp_9=1 if TX_RESP_Q013=="A"
replace s_comp_9=0 if TX_RESP_Q013=="B" | TX_RESP_Q013=="C" | TX_RESP_Q013=="D" | TX_RESP_Q013=="E"

*Em sua casa trabalha empregado(a) doméstico(a) pelo menos cinco dias por semana?
*não tem. ("A")
gen s_empregada_5vez_9=.
replace s_empregada_5vez_9=1 if TX_RESP_Q017=="B" | TX_RESP_Q017=="C" | TX_RESP_Q017=="D" | TX_RESP_Q017=="E"
replace s_empregada_5vez_9=0 if TX_RESP_Q017=="A"

collapse (mean) ano_saeb s_empregada_5vez_9 profic_p_esc_saeb_9-profic_250_m_saeb_9, by(codigo_escola)

save "E:\bases_dta\saeb_prova_brasil\2015\saeb2015_notas_alunos_9.dta", replace

*comentado, excel e conferido 19/07/2018


/*------------- Matemática, Português e Questionário Alunos -------------*/
/*------------- 				  5º ano EF					-------------*/			
/* 
variáveis finais:
	ano_saeb codigo_escola participacao_prova_brasil 
	profic_p_esc_saeb_5 profic_250_p_saeb_5
	profic_m_esc_saeb_5 profic_250_m_saeb_5
	s_empregada_5vez_5
*/
clear all
set more off
set trace on

import delimited "E:\SAEB Prova Brasil\microdados_saeb_2015\DADOS\TS_ALUNO_5EF.csv", delimiter(",") case(upper) clear 

*Renomaer
*Ano da ANEB/Prova Brasil
rename ID_PROVA_BRASIL ano_saeb
*Código da Escola
rename ID_ESCOLA codigo_escola
*Indicador de participação na Prova Brasil
rename IN_PROVA_BRASIL participacao_prova_brasil


*Proficiência do aluno em Língua Portuguesa calculada na escala única do SAEB, 
*com média = 0 e desvio = 1 na população de referência
rename PROFICIENCIA_LP profic_p_esc_saeb_5

*Proficiência em Língua Portuguesa transformada na escala única do SAEB, 
*com média = 250, desvio = 50 (do SAEB/97)
rename PROFICIENCIA_LP_SAEB profic_250_p_saeb_5

*Proficiência do aluno em Matemática calculada na escala única do SAEB, 
*com média = 0 e desvio = 1 na população de referência
rename PROFICIENCIA_MT profic_m_esc_saeb_5

*Proficiência do aluno em Matemática transformada na escala única do SAEB, 
*com média = 250, desvio = 50 (do SAEB/97)
rename PROFICIENCIA_MT_SAEB profic_250_m_saeb_5

*Manter só SAEB

keep if participacao_prova_brasil==0

*Variáveis do questionário
*Variáveis do questionário
*Na sua casa tem computador?
*Não tem.("A")

gen s_comp_5=.
replace s_comp_5=1 if TX_RESP_Q013=="A"
replace s_comp_5=0 if TX_RESP_Q013=="B" | TX_RESP_Q013=="C" | TX_RESP_Q013=="D" | TX_RESP_Q013=="E"

*Em sua casa trabalha empregado(a) doméstico(a) pelo menos cinco dias por semana?
*não tem. ("A")
gen s_empregada_5vez_5=.
replace s_empregada_5vez_5=1 if TX_RESP_Q017=="B" | TX_RESP_Q017=="C" | TX_RESP_Q017=="D" | TX_RESP_Q017=="E"
replace s_empregada_5vez_5=0 if TX_RESP_Q017=="A"

collapse (mean) ano_saeb s_empregada_5vez_5 profic_p_esc_saeb_5-profic_250_m_saeb_5, by(codigo_escola)

save "E:\bases_dta\saeb_prova_brasil\2015\saeb2015_notas_alunos_5.dta", replace


*comentado, excel e conferido 19/07/2018
/*--------------------------	Diretor 	--------------------------*/
/* 
variáveis finais:
	codigo_escola ano_saeb
	s_metodo_esc_dir_concurso s_metodo_esc_dir_selecao 
	s_metodo_esc_dir_eleicao s_metodo_esc_dir_sel_ele
	s_metodo_esc_dir_indic s_metodo_esc_dir_sel_indic
*/
clear all
set more off
set trace on

import delimited "E:\SAEB Prova Brasil\microdados_saeb_2015\DADOS\TS_DIRETOR.csv", delimiter(",") case(upper) clear 

**** Renomear e construir variáveis

rename ID_ESCOLA codigo_escola
rename ID_PROVA_BRASIL ano_saeb

*criar variáveis
*Você assumiu a direção desta escola por meio de:
* Concurso público apenas. ("A")
gen s_metodo_esc_dir_concurso=.
replace s_metodo_esc_dir_concurso=1 if TX_RESP_Q014=="A"
replace s_metodo_esc_dir_concurso=0 if TX_RESP_Q014=="B" | TX_RESP_Q014=="C" | TX_RESP_Q014=="D" | TX_RESP_Q014=="E" | TX_RESP_Q014=="F" | TX_RESP_Q014=="G"

*Processo seletivo apenas. ("D")
gen s_metodo_esc_dir_selecao=.
replace s_metodo_esc_dir_selecao=1 if TX_RESP_Q014=="D"
replace s_metodo_esc_dir_selecao=0 if TX_RESP_Q014=="B" | TX_RESP_Q014=="C" | TX_RESP_Q014=="A" | TX_RESP_Q014=="E" | TX_RESP_Q014=="F" | TX_RESP_Q014=="G"

*Eleição apenas. ("B")
gen s_metodo_esc_dir_eleicao=.
replace s_metodo_esc_dir_eleicao=1 if TX_RESP_Q014=="B"
replace s_metodo_esc_dir_eleicao=0 if TX_RESP_Q014=="A" | TX_RESP_Q014=="C" | TX_RESP_Q014=="D" | TX_RESP_Q014=="E" | TX_RESP_Q014=="F" | TX_RESP_Q014=="G"

*Processo seletivo e Eleição. ("E")
gen s_metodo_esc_dir_sel_ele=.
replace s_metodo_esc_dir_sel_ele=1 if TX_RESP_Q014=="E"
replace s_metodo_esc_dir_sel_ele=0 if TX_RESP_Q014=="A" | TX_RESP_Q014=="C" | TX_RESP_Q014=="D" | TX_RESP_Q014=="B" | TX_RESP_Q014=="F" | TX_RESP_Q014=="G"

*Indicação apenas. ("C")
gen s_metodo_esc_dir_indic=.
replace s_metodo_esc_dir_indic=1 if TX_RESP_Q014=="C" 
replace s_metodo_esc_dir_indic=0 if TX_RESP_Q014=="A" | TX_RESP_Q014=="B" | TX_RESP_Q014=="D" | TX_RESP_Q014=="E" | TX_RESP_Q014=="F" | TX_RESP_Q014=="G"

*Processo seletivo e Indicação. ("F")
gen s_metodo_esc_dir_sel_indic=.
replace s_metodo_esc_dir_sel_indic=1 if TX_RESP_Q014=="F" 
replace s_metodo_esc_dir_sel_indic=0 if TX_RESP_Q014=="A" | TX_RESP_Q014=="B" | TX_RESP_Q014=="C" | TX_RESP_Q014=="D" | TX_RESP_Q014=="E" | TX_RESP_Q014=="G"

#delimit ;
collapse 
(mean) ano_saeb 
s_metodo_esc_dir_concurso-s_metodo_esc_dir_sel_indic, 
by (codigo_escola);
#delimit cr
save "E:\bases_dta\saeb_prova_brasil\2015\saeb2015_dir.dta", replace

*comentado,  e conferido 19/07/2018


/*-----------------------------Docentes-------------------------------*/
/*------------- 		3º ano, 9ºano, 5º ano 			-------------*/			

/* 
variáveis finais:
experiência do professor
	s_exp_prof_mais_3_`x'
	s_exp_prof_escola_mais_3_`x'
*/
clear all
set more off
set trace on

foreach x in 5 9 3 {
import delimited "E:\SAEB Prova Brasil\microdados_saeb_2015\DADOS\TS_PROFESSOR.csv", delimiter(",") case(upper) clear 


**** Renomear e construir variáveis

rename ID_PROVA_BRASIL ano_saeb
rename ID_ESCOLA codigo_escola

replace ID_SERIE = 3 if ID_SERIE ==12
keep if ID_SERIE == `x'

*criar variáveis
*Há quantos anos você trabalha como professor?

gen s_exp_prof_mais_3_`x'=.
replace s_exp_prof_mais_3_`x'=1 if TX_RESP_Q013=="C" | TX_RESP_Q013=="D" | TX_RESP_Q013=="E" | TX_RESP_Q013=="F" | TX_RESP_Q013=="G" 
* Meu primeiro ano.("A")	1-2 anos. ("B")
replace s_exp_prof_mais_3_`x'=0 if TX_RESP_Q013=="A" | TX_RESP_Q013=="B"

*Há quantos anos você trabalha como professor nesta escola?

gen s_exp_prof_escola_mais_3_`x'=.
replace s_exp_prof_escola_mais_3_`x'=1 if TX_RESP_Q014=="C" | TX_RESP_Q014=="D" | TX_RESP_Q014=="E" | TX_RESP_Q014=="F" | TX_RESP_Q014=="G"
* Meu primeiro ano.("A")	1-2 anos. ("B")
replace s_exp_prof_escola_mais_3_`x'=0 if TX_RESP_Q014=="A" | TX_RESP_Q014=="B"

#delimit ;
collapse 
(mean) 
ano_saeb 
s_exp_prof_mais_3_`x' 
s_exp_prof_escola_mais_3_`x', 
by (codigo_escola);
#delimit cr
save "E:\bases_dta\saeb_prova_brasil\2015\saeb2015_prof_`x'.dta", replace
}

/*------------- Merge -------------*/
clear all
set more off
set trace on

use "E:\bases_dta\saeb_prova_brasil\2015\saeb2015_notas_alunos_3.dta", clear
merge 1:1 codigo_escola using "E:\bases_dta\saeb_prova_brasil\2015\saeb2015_notas_alunos_5.dta"
drop _merge
merge 1:1 codigo_escola using "E:\bases_dta\saeb_prova_brasil\2015\saeb2015_notas_alunos_9.dta"
drop _merge
merge 1:1 codigo_escola using "E:\bases_dta\saeb_prova_brasil\2015\saeb2015_dir.dta"
drop _merge
merge 1:1 codigo_escola using "E:\bases_dta\saeb_prova_brasil\2015\saeb2015_prof_3.dta"
drop _merge
merge 1:1 codigo_escola using "E:\bases_dta\saeb_prova_brasil\2015\saeb2015_prof_5.dta"

drop _merge
merge 1:1 codigo_escola using "E:\bases_dta\saeb_prova_brasil\2015\saeb2015_prof_9.dta"
save "E:\bases_dta\saeb_prova_brasil\2015\saeb2015.dta", replace

