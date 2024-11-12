/*************************Prova Brasil 2013********************************/
/*
variáveis finais:
	pb_empregada_5vez_`x', pb_esc_sup_mae, pb_esc_sup_pai
	ano_prova_brasil codigo_escola
	media_lp_prova_brasil_`x' media_mt_prova_brasil_`x'
	pb_tx_partic
*/
clear all
set more off


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

Esta edição dos microdados envolve duas das avaliações do Saeb 2013: a Aneb e a Anresc (Prova
Brasil), e para aprimorar e facilitar o seu uso, foram introduzidas algumas mudanças na estruturação e na
apresentação dos microdados dessas avaliações.
A primeira delas diz respeito à apresentação dos microdados da Aneb e da Prova Brasil de maneira
conjunta.
Outra alteração, que difere das edições anteriores, é que as bases de dados dos alunos são apresentadas
por série/ano avaliado (4ª série/5ºano do ensino fundamental; 8ª série/9ºano do ensino fundamental e 3ª série
ano do ensino médio), ao invés de disponibilizar as três séries em um único banco de dados. Com essa
medida, foi possível integrar as bases de resultados de alunos e de escolas com as bases dos respectivos
questionários contextual
*/

* agora os arquivos são separados por série

/*-------------   Questionário Alunos  	-------------*/
/*------------- 	 5º ano e 9º ano	-------------*/
* variáveis finais
*	pb_empregada_5vez_`x', pb_esc_sup_mae, pb_esc_sup_pai
foreach x in 5 9 {
import delimited "E:\SAEB Prova Brasil\microdados_aneb_prova_brasil_2013\DADOS\TS_ALUNO_`x'EF.csv", delimiter(",") case(upper) clear 
*Renomaer
rename ID_PROVA_BRASIL ano_prova_brasil
rename ID_ESCOLA codigo_escola

* Dropar escolas particulares (Prova Brasil é censitária para públicas)

drop if ID_DEPENDENCIA_ADM==4

*Variáveis do questionário

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

/*-------------    Matemática e Português 	-------------*/
/*------------- 	 5º ano e 9º ano		-------------*/
* variáveis finais
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
