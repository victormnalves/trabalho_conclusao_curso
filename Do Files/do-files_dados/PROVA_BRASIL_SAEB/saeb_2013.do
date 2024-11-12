/*******************************SAEB 2013**************************************/

{/* vari�veis

vari�veis finais:
	ano_saeb codigo_escola turno profic_p_esc_saeb_3 profic_250_p_saeb_3
	profic_m_esc_saeb_3 profic_250_m_saeb_3
	s_empregada_5vez_3

	ano_saeb codigo_escola participacao_prova_brasil 
	profic_p_esc_saeb_9 profic_250_p_saeb_9
	profic_m_esc_saeb_9 profic_250_m_saeb_9
	s_empregada_5vez_9
	
	ano_saeb codigo_escola participacao_prova_brasil 
	profic_p_esc_saeb_5 profic_250_p_saeb_5
	profic_m_esc_saeb_5 profic_250_m_saeb_5
	s_empregada_5vez_5
	
	codigo_escola ano_saeb
	s_metodo_esc_dir_concurso s_metodo_esc_dir_selecao 
	s_metodo_esc_dir_eleicao s_metodo_esc_dir_sel_ele
	s_metodo_esc_dir_indic s_metodo_esc_dir_sel_indic

	ano_saeb 
	s_exp_prof_mais_3_3 
	s_exp_prof_escola_mais_3_3
	
	ano_saeb 
	s_exp_prof_mais_3_3inte
	s_exp_prof_escola_mais_3_3inte
	
	ano_saeb 
	s_exp_prof_mais_3_5
	s_exp_prof_escola_mais_3_5
	
	ano_saeb 
	s_exp_prof_mais_3_9 
	s_exp_prof_escola_mais_3_9
	
*/}
clear all
set more off
set trace on
/*
saeb est� fundamentado na ideia de sistema, com o objetivo de desencadear um 
processo de avalia��o, por meio de levantamento de informa��es a cada 2 anos,
que permita monitorar a evolu��o do quadro educacional brasileiro, a partir 
de dois pressupostos b�sicos:
o rendimento dos alunos reflete a qualidade do ensino ministrado;
nenhum fator determina, isoladamente, a qualidade do ensino.

duas avalia��es:
	Aneb � Avalia��o Nacional da Educa��o B�sica, abrange de
maneira amostral os estudantes das redes p�blicas e particulars do pa�s, 
localizados na �rea rural e urbana e matriculados no 5� e 9� anos do Ensino 
Fundamental (EF) e tamb�m no 3� s�rie do Ensino M�dio (EM).
	Anresc - Avalia��o Nacional do Rendimento Escolar, � aplicada 
censitariamente a alunos de 5� e 9� anos do ensino fundamental p�blico, 
nas redes estaduais, municipais e federais, de �rea rural e urbana, em 
escolas que tenham no m�nimo 20 alunos matriculados na s�rie avaliada
(prova brasil)

Esta edi��o dos microdados envolve duas das avalia��es do Saeb 2013: a Aneb e a Anresc (Prova
Brasil), e para aprimorar e facilitar o seu uso, foram introduzidas algumas mudan�as na estrutura��o e na
apresenta��o dos microdados dessas avalia��es.
A primeira delas diz respeito � apresenta��o dos microdados da Aneb e da Prova Brasil de maneira
conjunta.
Outra altera��o, que difere das edi��es anteriores, � que as bases de dados dos alunos s�o apresentadas
por s�rie/ano avaliado (4� s�rie/5�ano do ensino fundamental; 8� s�rie/9�ano do ensino fundamental e 3� s�rie
ano do ensino m�dio), ao inv�s de disponibilizar as tr�s s�ries em um �nico banco de dados. Com essa
medida, foi poss�vel integrar as bases de resultados de alunos e de escolas com as bases dos respectivos
question�rios contextual
*/

* agora os arquivos s�o separados por s�rie

/*------------- Matem�tica, Portugu�s e Question�rio Alunos -------------*/
/*------------- 				 	3� ano					-------------*/			
/* 
vari�veis finais:
	ano_saeb codigo_escola turno profic_p_esc_saeb_3 profic_250_p_saeb_3
	profic_m_esc_saeb_3 profic_250_m_saeb_3
	s_empregada_5vez_3
*/
import delimited "E:\SAEB Prova Brasil\microdados_aneb_prova_brasil_2013\DADOS\TS_ALUNO_3EM.csv", delimiter(",") case(upper) clear 

*Renomaer
rename ID_PROVA_BRASIL ano_saeb
rename ID_ESCOLA codigo_escola
rename ID_TURNO turno

*Profici�ncia do aluno em L�ngua Portuguesa calculada na escala �nica do SAEB, 
*com m�dia = 0 e desvio = 1 na popula��o de refer�ncia
rename PROFICIENCIA_LP profic_p_esc_saeb_3

*Profici�ncia em L�ngua Portuguesa transformada na escala �nica do SAEB, 
*com m�dia = 250, desvio = 50 (do SAEB/97)
rename PROFICIENCIA_LP_SAEB profic_250_p_saeb_3

*Profici�ncia do aluno em Matem�tica calculada na escala �nica do SAEB, 
*com m�dia = 0 e desvio = 1 na popula��o de refer�ncia
rename PROFICIENCIA_MT profic_m_esc_saeb_3

*Profici�ncia do aluno em Matem�tica transformada na escala �nica do SAEB, 
*com m�dia = 250, desvio = 50 (do SAEB/97)
rename PROFICIENCIA_MT_SAEB profic_250_m_saeb_3

*Vari�veis do question�rio
*Na sua casa tem computador?
*N�o tem.("A")

gen s_comp_3=.
replace s_comp_3=1 if TX_RESP_Q013=="A"
replace s_comp_3=0 if TX_RESP_Q013=="B" | TX_RESP_Q013=="C" | TX_RESP_Q013=="D" | TX_RESP_Q013=="E"

*Em sua casa trabalha empregado(a) dom�stico(a) pelo menos cinco dias por semana?
*n�o tem. ("A")
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
save "E:\bases_dta\saeb_prova_brasil\2013\saeb2013_notas_alunos_3.dta", replace


/*------------- Matem�tica, Portugu�s e Question�rio Alunos -------------*/
/*------------- 				  9� ano EF					-------------*/			
/* 
vari�veis finais:
	ano_saeb codigo_escola participacao_prova_brasil 
	profic_p_esc_saeb_9 profic_250_p_saeb_9
	profic_m_esc_saeb_9 profic_250_m_saeb_9
	s_empregada_5vez_9
*/
import delimited "E:\SAEB Prova Brasil\microdados_aneb_prova_brasil_2013\DADOS\TS_ALUNO_9EF.csv", delimiter(",") case(upper) clear 

*Renomaer
rename ID_PROVA_BRASIL ano_saeb
rename ID_ESCOLA codigo_escola

rename IN_PROVA_BRASIL participacao_prova_brasil


rename PROFICIENCIA_LP profic_p_esc_saeb_9
rename PROFICIENCIA_LP_SAEB profic_250_p_saeb_9
rename PROFICIENCIA_MT profic_m_esc_saeb_9
rename PROFICIENCIA_MT_SAEB profic_250_m_saeb_9

*Manter s� SAEB

keep if participacao_prova_brasil==0

*Vari�veis do question�rio
*Vari�veis do question�rio
*Na sua casa tem computador?
*N�o tem.("A")

gen s_comp_9=.
replace s_comp_9=1 if TX_RESP_Q013=="A"
replace s_comp_9=0 if TX_RESP_Q013=="B" | TX_RESP_Q013=="C" | TX_RESP_Q013=="D" | TX_RESP_Q013=="E"

*Em sua casa trabalha empregado(a) dom�stico(a) pelo menos cinco dias por semana?
*n�o tem. ("A")
gen s_empregada_5vez_9=.
replace s_empregada_5vez_9=1 if TX_RESP_Q017=="B" | TX_RESP_Q017=="C" | TX_RESP_Q017=="D" | TX_RESP_Q017=="E"
replace s_empregada_5vez_9=0 if TX_RESP_Q017=="A"

collapse (mean) ano_saeb s_empregada_5vez_9 profic_p_esc_saeb_9-profic_250_m_saeb_9, by(codigo_escola)

save "E:\bases_dta\saeb_prova_brasil\2013\saeb2013_notas_alunos_9.dta", replace


/*------------- Matem�tica, Portugu�s e Question�rio Alunos -------------*/
/*------------- 				  5� ano EF					-------------*/			
/* 
vari�veis finais:
	ano_saeb codigo_escola participacao_prova_brasil 
	profic_p_esc_saeb_5 profic_250_p_saeb_5
	profic_m_esc_saeb_5 profic_250_m_saeb_5
	s_empregada_5vez_5
*/
import delimited "E:\SAEB Prova Brasil\microdados_aneb_prova_brasil_2013\DADOS\TS_ALUNO_5EF.csv", delimiter(",") case(upper) clear 

*Renomaer
rename ID_PROVA_BRASIL ano_saeb
rename ID_ESCOLA codigo_escola

rename IN_PROVA_BRASIL participacao_prova_brasil


rename PROFICIENCIA_LP profic_p_esc_saeb_5
rename PROFICIENCIA_LP_SAEB profic_250_p_saeb_5
rename PROFICIENCIA_MT profic_m_esc_saeb_5
rename PROFICIENCIA_MT_SAEB profic_250_m_saeb_5

*Manter s� SAEB

keep if participacao_prova_brasil==0

*Vari�veis do question�rio
*Vari�veis do question�rio
*Na sua casa tem computador?
*N�o tem.("A")

gen s_comp_5=.
replace s_comp_5=1 if TX_RESP_Q013=="A"
replace s_comp_5=0 if TX_RESP_Q013=="B" | TX_RESP_Q013=="C" | TX_RESP_Q013=="D" | TX_RESP_Q013=="E"

*Em sua casa trabalha empregado(a) dom�stico(a) pelo menos cinco dias por semana?
*n�o tem. ("A")
gen s_empregada_5vez_5=.
replace s_empregada_5vez_5=1 if TX_RESP_Q017=="B" | TX_RESP_Q017=="C" | TX_RESP_Q017=="D" | TX_RESP_Q017=="E"
replace s_empregada_5vez_5=0 if TX_RESP_Q017=="A"

collapse (mean) ano_saeb s_empregada_5vez_5 profic_p_esc_saeb_5-profic_250_m_saeb_5, by(codigo_escola)

save "E:\bases_dta\saeb_prova_brasil\2013\saeb2013_notas_alunos_5.dta", replace

/*--------------------------	Diretor 	--------------------------*/
/* 
vari�veis finais:
	codigo_escola ano_saeb
	s_metodo_esc_dir_concurso s_metodo_esc_dir_selecao 
	s_metodo_esc_dir_eleicao s_metodo_esc_dir_sel_ele
	s_metodo_esc_dir_indic s_metodo_esc_dir_sel_indic
*/

import delimited "E:\SAEB Prova Brasil\microdados_aneb_prova_brasil_2013\DADOS\TS_DIRETOR.csv", delimiter(",") case(upper) clear 

**** Renomear e construir vari�veis

rename ID_ESCOLA codigo_escola
rename ID_PROVA_BRASIL ano_saeb

*criar vari�veis
*Voc� assumiu a dire��o desta escola por meio de:
* Concurso p�blico apenas. ("A")
gen s_metodo_esc_dir_concurso=.
replace s_metodo_esc_dir_concurso=1 if TX_RESP_Q014=="A"
replace s_metodo_esc_dir_concurso=0 if TX_RESP_Q014=="B" | TX_RESP_Q014=="C" | TX_RESP_Q014=="D" | TX_RESP_Q014=="E" | TX_RESP_Q014=="F" | TX_RESP_Q014=="G"

*Processo seletivo apenas. ("D")
gen s_metodo_esc_dir_selecao=.
replace s_metodo_esc_dir_selecao=1 if TX_RESP_Q014=="D"
replace s_metodo_esc_dir_selecao=0 if TX_RESP_Q014=="B" | TX_RESP_Q014=="C" | TX_RESP_Q014=="A" | TX_RESP_Q014=="E" | TX_RESP_Q014=="F" | TX_RESP_Q014=="G"

*Elei��o apenas. ("B")
gen s_metodo_esc_dir_eleicao=.
replace s_metodo_esc_dir_eleicao=1 if TX_RESP_Q014=="B"
replace s_metodo_esc_dir_eleicao=0 if TX_RESP_Q014=="A" | TX_RESP_Q014=="C" | TX_RESP_Q014=="D" | TX_RESP_Q014=="E" | TX_RESP_Q014=="F" | TX_RESP_Q014=="G"

*Processo seletivo e Elei��o. ("E")
gen s_metodo_esc_dir_sel_ele=.
replace s_metodo_esc_dir_sel_ele=1 if TX_RESP_Q014=="E"
replace s_metodo_esc_dir_sel_ele=0 if TX_RESP_Q014=="A" | TX_RESP_Q014=="C" | TX_RESP_Q014=="D" | TX_RESP_Q014=="B" | TX_RESP_Q014=="F" | TX_RESP_Q014=="G"

*Indica��o apenas. ("C")
gen s_metodo_esc_dir_indic=.
replace s_metodo_esc_dir_indic=1 if TX_RESP_Q014=="C" 
replace s_metodo_esc_dir_indic=0 if TX_RESP_Q014=="A" | TX_RESP_Q014=="B" | TX_RESP_Q014=="D" | TX_RESP_Q014=="E" | TX_RESP_Q014=="F" | TX_RESP_Q014=="G"

*Processo seletivo e Indica��o. ("F")
gen s_metodo_esc_dir_sel_indic=.
replace s_metodo_esc_dir_sel_indic=1 if TX_RESP_Q014=="F" 
replace s_metodo_esc_dir_sel_indic=0 if TX_RESP_Q014=="A" | TX_RESP_Q014=="B" | TX_RESP_Q014=="C" | TX_RESP_Q014=="D" | TX_RESP_Q014=="E" | TX_RESP_Q014=="G"

#delimit ;
collapse 
(mean) ano_saeb 
s_metodo_esc_dir_concurso-s_metodo_esc_dir_sel_indic, 
by (codigo_escola);
#delimit cr
save "E:\bases_dta\saeb_prova_brasil\2013\saeb2013_dir.dta", replace


/*-----------------------------Docentes-------------------------------*/
/*------------- 3� ano, 3� ano integrado, 9�ano, 5� ano -------------*/			

/* 
vari�veis finais:
experi�ncia do professor
*/
set trace on
set more off
foreach x in "5" "9" "3" "3inte"{
import delimited "E:\SAEB Prova Brasil\microdados_aneb_prova_brasil_2013\DADOS\TS_PROFESSOR.csv", delimiter(",") case(upper) clear 


**** Renomear e construir vari�veis

rename ID_PROVA_BRASIL ano_saeb
rename ID_ESCOLA codigo_escola

tostring ID_SERIE, replace
replace ID_SERIE = "3" if ID_SERIE == "12"
replace ID_SERIE = "3inte" if ID_SERIE == "13"
keep if ID_SERIE == "`x'"

*criar vari�veis
*H� quantos anos voc� trabalha como professor?

gen s_exp_prof_mais_3_`x'=.
replace s_exp_prof_mais_3_`x'=1 if TX_RESP_Q013=="C" | TX_RESP_Q013=="D" | TX_RESP_Q013=="E" | TX_RESP_Q013=="F" | TX_RESP_Q013=="G" 
* Meu primeiro ano.("A")	1-2 anos. ("B")
replace s_exp_prof_mais_3_`x'=0 if TX_RESP_Q013=="A" | TX_RESP_Q013=="B"

*H� quantos anos voc� trabalha como professor nesta escola?

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
save "E:\bases_dta\saeb_prova_brasil\2013\saeb2013_prof_`x'.dta", replace
}
/*------------- Merge -------------*/

use "E:\bases_dta\saeb_prova_brasil\2013\saeb2013_notas_alunos_3.dta", clear
merge 1:1 codigo_escola using "E:\bases_dta\saeb_prova_brasil\2013\saeb2013_notas_alunos_5.dta"
drop _merge
merge 1:1 codigo_escola using "E:\bases_dta\saeb_prova_brasil\2013\saeb2013_notas_alunos_9.dta"
drop _merge
merge 1:1 codigo_escola using "E:\bases_dta\saeb_prova_brasil\2013\saeb2013_dir.dta"
drop _merge
merge 1:1 codigo_escola using "E:\bases_dta\saeb_prova_brasil\2013\saeb2013_prof_3.dta"
drop _merge
merge 1:1 codigo_escola using "E:\bases_dta\saeb_prova_brasil\2013\saeb2013_prof_5.dta"
drop _merge
merge 1:1 codigo_escola using "E:\bases_dta\saeb_prova_brasil\2013\saeb2013_prof_3inte.dta"
drop _merge
merge 1:1 codigo_escola using "E:\bases_dta\saeb_prova_brasil\2013\saeb2013_prof_9.dta"
save "E:\bases_dta\saeb_prova_brasil\2013\saeb2013.dta", replace
