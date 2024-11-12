/*************************Prova Brasil 2013********************************/
/*
vari�veis finais:
	pb_empregada_5vez_`x', pb_esc_sup_mae, pb_esc_sup_pai
	ano_prova_brasil codigo_escola
	media_lp_prova_brasil_`x' media_mt_prova_brasil_`x'
	pb_tx_partic
*/
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

/*-------------   Question�rio Alunos  	-------------*/
/*------------- 	 5� ano e 9� ano	-------------*/
* vari�veis finais
*	pb_empregada_5vez_`x', pb_esc_sup_mae, pb_esc_sup_pai
foreach x in 5 9 {
import delimited "E:\SAEB Prova Brasil\microdados_aneb_prova_brasil_2013\DADOS\TS_ALUNO_`x'EF.csv", delimiter(",") case(upper) clear 
*Renomaer
rename ID_PROVA_BRASIL ano_prova_brasil
rename ID_ESCOLA codigo_escola

* Dropar escolas particulares (Prova Brasil � censit�ria para p�blicas)

drop if ID_DEPENDENCIA_ADM==4

*Vari�veis do question�rio

gen pb_empregada_5vez_`x'=.
replace pb_empregada_5vez_`x'=1 if TX_RESP_Q017=="B" | TX_RESP_Q017=="C" | TX_RESP_Q017=="D" | TX_RESP_Q017=="E"
replace pb_empregada_5vez_`x'=0 if TX_RESP_Q017=="A"

gen pb_esc_sup_mae_`x'=.
replace pb_esc_sup_mae_`x'=1 if TX_RESP_Q019=="F" 
replace pb_esc_sup_mae_`x'=0 if TX_RESP_Q019=="A"|TX_RESP_Q019=="B"|TX_RESP_Q019=="C"|TX_RESP_Q019=="D"|TX_RESP_Q019=="E"

gen pb_esc_sup_pai_`x'=.
replace pb_esc_sup_pai_`x'=1 if TX_RESP_Q023=="F" 
replace pb_esc_sup_pai_`x'=0 if TX_RESP_Q023=="A"|TX_RESP_Q023=="B"|TX_RESP_Q023=="C"|TX_RESP_Q023=="D"|TX_RESP_Q023=="E"

*collapse
#delimit ;
collapse 
(mean) ano_prova_brasil 
pb_empregada_5vez_`x' 
pb_esc_sup_mae_`x' 
pb_esc_sup_pai_`x', by(codigo_escola)
;
#delimit cr
save "E:\bases_dta\saeb_prova_brasil\2013\provabrasil2013_alunos_`x'.dta", replace

}

/*-------------    Matem�tica e Portugu�s 	-------------*/
/*------------- 	 5� ano e 9� ano		-------------*/
* vari�veis finais
*	ano_prova_brasil codigo_escola
*	media_lp_prova_brasil_`x' media_mt_prova_brasil_`x'
*	pb_tx_partic
foreach x in 5 9 {
import delimited "E:\SAEB Prova Brasil\microdados_aneb_prova_brasil_2013\DADOS\TS_ESCOLA.csv", delimiter(",") case(upper) clear 

drop if ID_DEPENDENCIA_ADM==4



rename ID_PROVA_BRASIL ano_prova_brasil
rename ID_ESCOLA codigo_escola

rename MEDIA_`x'EF_LP media_lp_prova_brasil_`x'
rename MEDIA_`x'EF_MT media_mt_prova_brasil_`x'
rename TAXA_PARTICIPACAO_`x'EF pb_tx_partic_`x'

#delimit ;
keep 
codigo_escola 
ano_prova_brasil 
media_lp_prova_brasil_`x' 
media_mt_prova_brasil_`x' 
pb_tx_partic_`x'
;
#delimit cr
save "E:\bases_dta\saeb_prova_brasil\2013\provabrasil2013_notas_`x'.dta", replace

}
/*-------------    Merge 	-------------*/

foreach x in 5 9 {
use "E:\bases_dta\saeb_prova_brasil\2013\provabrasil2013_alunos_`x'.dta", clear
merge 1:1 codigo_escola using "E:\bases_dta\saeb_prova_brasil\2013\provabrasil2013_notas_`x'.dta"
drop _merge
save "E:\bases_dta\saeb_prova_brasil\2013\provabrasil2013_`x'.dta", replace
}

use "E:\bases_dta\saeb_prova_brasil\2013\provabrasil2013_5.dta", clear
merge 1:1 codigo_escola using "E:\bases_dta\saeb_prova_brasil\2013\provabrasil2013_9.dta"
drop _merge
save "E:\bases_dta\saeb_prova_brasil\2013\provabrasil2013.dta", replace
