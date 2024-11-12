/*******************************SAEB 2011**************************************/


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


Aneb 
produ��o de informa��o sobre os n�veis de aprendizagem demonstrados pelos
alunos agregados por unidade escolar e nas respectivas redes de ensino. 
O Saeb � composto por uma parte censit�ria e uma parte amostral. A parte censit�ria �
constitu�da por escolas p�blicas com 20 ou mais alunos do 5� ano e 9� ano do Ensino
Fundamental. J� a parte amostral � formada por escolas particulars do 5� ano e 9� ano do Ensino
Fundamental com 10 ou mais alunos em turmas regulares, e tamb�m por escolas p�blicas e
particulars da 3� s�rie do Ensino M�dio com 10 ou mais alunos em turmas regulares

*/


/*
Matem�ticae e Portugu�s
	para 3� ano
	para 

Diretor
Docentes
Merge
*/

/*------------- Matem�ticae e Portugu�s -------------*/
/*-------------       para 3� ano EM	-------------*/

*vari�veis finais: 
*	ano_saeb, serie, turno,profic_p_esc_saeb_3, profic_250_p_saeb_3, 
*	profic_m_esc_saeb_3, profic_250_m_saeb_3, codigo_escola
import delimited "E:\SAEB Prova Brasil\microdados_saeb_2011\Arquivos Finais\Dados\TS_RESULTADO_ALUNO.csv", delimiter(";") case(upper) clear 

*ano do saeb
rename ID_SAEB ano_saeb

*c�digo da unidade da federa��o
rename ID_UF codigo_uf

*c�digo do munic�pio
rename ID_MUNICIPIO codigo_municipio

*c�digo da escola
rename ID_ESCOLA codigo_escola

*turno da turma:
/*
	1 - Matutino
	2 - Vespertino
	3 - Noturno
	4 - Intermedi�rio
*/
rename ID_TURNO turno

*s�rie:
/*
5 - 4� s�rie/5� ano Ensino Fundamental
9 - 8� s�rie/9� ano Ensino Fundamental
12 - 3� s�rie Ensino M�dio
*/
rename ID_SERIE serie

/*
Profici�ncia do aluno em L�ngua Portuguesa calculada na escala �nica do SAEB, 
com m�dia = 0 e desvio = 1 na popula��o de refer�ncia
*/
rename PROFICIENCIA_LP profic_p_esc_saeb_3

/*
Profici�ncia em L�ngua Portuguesa transformada na escala �nica do SAEB, 
com m�dia = 250, desvio = 50 (do SAEB/97)
*/
rename PROFICIENCIA_LP_SAEB profic_250_p_saeb_3

/*
Profici�ncia do aluno em Matem�tica calculada na escala �nica do SAEB, 
com m�dia = 0 e desvio = 1 na popula��o de refer�ncia
*/
rename PROFICIENCIA_MT profic_m_esc_saeb_3

/*
Profici�ncia do aluno em Matem�tica transformada na escala �nica do SAEB, 
com m�dia = 250, desvio = 50 (do SAEB/97)
*/
rename PROFICIENCIA_MT_SAEB profic_250_m_saeb_3


* obs: essas vari�veis est�o dispon�veis para os 3 anos,
* mas para o resultado por escola (que vai estar para na pr�xima se��o)
* temos somente para 5 e 9 ano, n�o para o 3. ent�o,
* o referente ao terceiro ano ser� feito por aluno, e depois collapse.
* j� as vari�vies referente ser�o feitas via as vari�veis j� agregadas por escola
*manter s� 3 ano

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

/*------------- Matem�ticae e Portugu�s -------------*/
/*-------------      para 5�/9� EF		-------------*/
*vari�veis finais: nota m�dia por escola por ano e c�digo da escola
foreach x in 5 9 {
import delimited "E:\SAEB Prova Brasil\microdados_saeb_2011\Arquivos Finais\Dados\TS_RESULTADO_ESCOLA.csv", delimiter(";") case(upper) clear 

rename ID_SAEB ano_saeb
rename ID_UF codigo_uf
rename ID_MUNICIPIO codigo_municipio
rename ID_ESCOLA codigo_escola
rename ID_SERIE serie

keep if serie==`x'

*Nota m�dia dos participantes em L�ngua Portuguesa
rename MEDIA_LP media_lp_saeb_`x'

*Nota m�dia dos participantes em Matem�tica
rename MEDIA_MT media_mt_saeb_`x'


*destring
	*substituindo ",", ".", por .
replace media_lp_saeb_`x'=subinstr(media_lp_saeb_`x',",",".",.)
replace media_mt_saeb_`x'=subinstr(media_mt_saeb_`x',",",".",.)

destring media_lp_saeb_`x', replace
destring media_mt_saeb_`x', replace

* n�o precisa de collpase pois os dados j� est�o por escola
keep codigo_escola ano_saeb media_lp_saeb_`x' media_mt_saeb_`x'

save "E:\bases_dta\saeb_prova_brasil\2011\saeb2011_notas_`x'.dta", replace


}
/*------------- Question�rio Alunos -------------*/
* para 4� s�rie/5� ano do EF, para 8�s�rie/ 9� ano do EF e para 3� do EM
* vari�veis finais: 
*	escolaridade da m�e e do pai
*	internet e empregada dom�stica
foreach x in 5 9 3{

import delimited "E:\SAEB Prova Brasil\microdados_saeb_2011\Arquivos Finais\Dados\TS_QUEST_ALUNO.csv", delimiter(";") case(upper) clear 
replace ID_SERIE = 3 if ID_SERIE ==12
keep if ID_SERIE==`x'
**** Renomear e construir vari�veis

rename ID_ESCOLA codigo_escola
rename ID_SAEB ano_saeb

*vari�vel que indica se aluno tem computador com internet em casa
*Na sua casa tem computador?
*Sim, com internet.("A")

gen s_comp_internet_`x'=.
replace s_comp_internet_`x'=1 if TX_RESP_Q013=="A"
replace s_comp_internet_`x'=0 if TX_RESP_Q013=="B" | TX_RESP_Q013=="C"
*vari�vel que indica se na casa do aluno trabalha alguma empregada dom�stica
*Na sua casa trabalha alguma empregada dom�stica?

gen s_empregada_diarista_`x'=.
replace s_empregada_diarista_`x'=1 if TX_RESP_Q015=="A" | TX_RESP_Q015=="B" | TX_RESP_Q015=="C"
*N�o.("D")
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
* vari�veis finais: ano pb, m�todo de escolha da dire��o
import delimited "E:\SAEB Prova Brasil\microdados_saeb_2011\Arquivos Finais\Dados\TS_QUEST_DIRETOR.csv", delimiter(";") case(upper) clear 


**** Renomear e construir vari�veis

rename ID_ESCOLA codigo_escola
rename ID_SAEB ano_saeb

*criar vari�veis

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
* para 4� s�rie/5� ano do EF, para 8�s�rie/ 9� ano do EF e para 3� do EM
* vari�veis finais: experi�ncia do professor
foreach x in 5 9 3{
import delimited "E:\SAEB Prova Brasil\microdados_saeb_2011\Arquivos Finais\Dados\TS_QUEST_PROFESSOR.csv", delimiter(";") case(upper) clear 

rename ID_SAEB ano_saeb
rename ID_ESCOLA codigo_escola

replace ID_SERIE = 3 if ID_SERIE ==12
keep if ID_SERIE==`x'

*criar vari�veis

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

