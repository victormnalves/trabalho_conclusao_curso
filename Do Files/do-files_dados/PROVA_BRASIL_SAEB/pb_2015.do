/*************************Prova Brasil 2015********************************/
clear all
set more off
set trace on

/*
saeb est� fundamentado na ideia de sistema, com o objetivo de desencadear um 
processo de avalia��o, por meio de levantamento de informa��es a cada 2 anos,
que permita monitorar a evolu��o do quadro educacional brasileiro, a partir 
de dois pressupostos b�sicos:
	o desempenho dos alunos � uma das evid�ncias a respeito da qualidade do 
	ensino ministrado;
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

Os microdados s�o apresentados na mesma estrutura da edi��o anterior, 
qual seja:
	1. apresenta��o conjunta das bases de dados da Aneb e Anresc;
	2. base de dados reunidas por ano/s�rie avaliados;
	3. integra��o da base de resultados de alunos e escolas com as bases dos respectivos question�rios
	contextuais.

*/


* agora os arquivos s�o separados por s�rie

/*-------------   Question�rio Alunos  	-------------*/
/*------------- 	 5� ano e 9� ano	-------------*/
* vari�veis finais
*	pb_empregada_5vez_`x', pb_esc_sup_mae, pb_esc_sup_pai
foreach x in 5 9 {
import delimited "E:\SAEB Prova Brasil\microdados_saeb_2015\DADOS\TS_ALUNO_`x'EF.csv", delimiter(",") case(upper) clear 
*Renomaer
rename ID_PROVA_BRASIL ano_prova_brasil
rename ID_ESCOLA codigo_escola

* Dropar escolas particulares (Prova Brasil � censit�ria para p�blicas)

drop if ID_DEPENDENCIA_ADM==4

*Vari�veis do question�rio

gen pb_empregada_5vez_`x'=.
replace pb_empregada_5vez_`x'=1 if TX_RESP_Q017=="B" | TX_RESP_Q017=="C" | TX_RESP_Q017=="D" | TX_RESP_Q017=="E"
replace pb_empregada_5vez_`x'=0 if TX_RESP_Q017=="A"

gen pb_esc_sup_mae`x'=.
replace pb_esc_sup_mae`x'=1 if TX_RESP_Q019=="F" 
replace pb_esc_sup_mae`x'=0 if TX_RESP_Q019=="A"|TX_RESP_Q019=="B"|TX_RESP_Q019=="C"|TX_RESP_Q019=="D"|TX_RESP_Q019=="E"

gen pb_esc_sup_pai`x'=.
replace pb_esc_sup_pai`x'=1 if TX_RESP_Q023=="F" 
replace pb_esc_sup_pai`x'=0 if TX_RESP_Q023=="A"|TX_RESP_Q023=="B"|TX_RESP_Q023=="C"|TX_RESP_Q023=="D"|TX_RESP_Q023=="E"

*collapse
#delimit ;
collapse 
(mean) ano_prova_brasil 
pb_empregada_5vez_`x' 
pb_esc_sup_mae`x' 
pb_esc_sup_pai`x', by(codigo_escola)
;
#delimit cr
save "E:\bases_dta\saeb_prova_brasil\2015\provabrasil2015_alunos_`x'.dta", replace

}

/*-------------    Matem�tica e Portugu�s 	-------------*/
/*------------- 	 5� ano e 9� ano		-------------*/
* vari�veis finais
*	ano_prova_brasil codigo_escola
*	media_lp_prova_brasil_`x' media_mt_prova_brasil_`x'
*	pb_tx_partic
foreach x in 5 9 {
import delimited "E:\SAEB Prova Brasil\microdados_saeb_2015\DADOS\TS_ESCOLA.csv", delimiter(",") case(upper) clear 

drop if ID_DEPENDENCIA_ADM==4



rename ID_PROVA_BRASIL ano_prova_brasil
rename ID_ESCOLA codigo_escola

rename MEDIA_`x'EF_LP media_lp_prova_brasil_`x'
rename MEDIA_`x'EF_MT media_mt_prova_brasil_`x'
rename TAXA_PARTICIPACAO_`x'EF pb_tx_partic`x'

#delimit ;
keep 
codigo_escola 
ano_prova_brasil 
media_lp_prova_brasil_`x' 
media_mt_prova_brasil_`x' 
pb_tx_partic`x'
;
#delimit cr
save "E:\bases_dta\saeb_prova_brasil\2015\provabrasil2015_notas_`x'.dta", replace

}
/*-------------    Merge 	-------------*/

foreach x in 5 9 {
use "E:\bases_dta\saeb_prova_brasil\2015\provabrasil2015_alunos_`x'.dta", clear
merge 1:1 codigo_escola using "E:\bases_dta\saeb_prova_brasil\2015\provabrasil2015_notas_`x'.dta"
drop _merge
save "E:\bases_dta\saeb_prova_brasil\2015\provabrasil2015_`x'.dta", replace
}

use "E:\bases_dta\saeb_prova_brasil\2015\provabrasil2015_5.dta", clear
merge 1:1 codigo_escola using "E:\bases_dta\saeb_prova_brasil\2015\provabrasil2015_5.dta"

drop _merge
save "E:\bases_dta\saeb_prova_brasil\2015\provabrasil2015.dta", replace
