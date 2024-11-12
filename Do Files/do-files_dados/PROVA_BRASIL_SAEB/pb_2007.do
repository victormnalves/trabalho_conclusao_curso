/*************************Prova Brasil 2007********************************/
clear all
set more off
set trace on

/*
saeb: mecanismo de coleta, sistematiza��o e an�lise de dados sobre o EF e EM
acesso ao ensino b�sico, qualidade, efici�ncia e equidade do sistema
reformula��o do processo de avalia��o:
	avalia��o do rendimento escolar (prova brasil)
	avalia��o dos sistemas de ensino (saeb)
	
prova brasil: produzir um diagn�stico do desempenho dos alunos em termos de
aquisi��o de habilidades e compet�ncias e n�o somente de aprendizagem de
conte�dos

A avalia��o da Prova Brasil conjuga testes de desempenho, aplicados aos
estudantes, com question�rios socioecon�micos sobre fatores associados a esses
resultados, endere�ados a diferentes atores que comp�em a escola. Os testes de
desempenho concentram-se em l�ngua portuguesa (leitura) e Matem�tica (resolu��o de
problemas)
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
* vari�veis finais: ano da pb, m�dia lingua port, m�dia mat, n�mero de particip
foreach x in 5 9 {
clear all
# delimit ;
infix  

long PK_COD_ENTIDADE 1-8 
float NU_MEDIA_PORT 9-16 
float NU_MEDIA_MAT 17-24 
long NU_PARTICIPANTES 25-32 
int ID_SERIE 33-33 
int ID_DEPENDENCIA_ADM 34-34 

using "E:\SAEB Prova Brasil\microdados_prova_brasil_2007\Prova Brasil 2007\DADOS\TS_RESULTADO_ESCOLA.txt"
;
# delimit cr

keep if ID_SERIE==`x'-1
rename PK_COD_ENTIDADE codigo_escola
rename NU_MEDIA_PORT media_lp_prova_brasil_`x'
rename NU_MEDIA_MAT media_mt_prova_brasil_`x'
rename NU_PARTICIPANTES pb_n_partic_`x'

*gerado vari�vel de ano
gen ano_prova_brasil=2009

# delimit ;
collapse (mean) 
ano_prova_brasil 
media_lp_prova_brasil_`x' 
media_mt_prova_brasil_`x' 
pb_n_partic_`x', 
by(codigo_escola);

# delimit cr
save "E:\bases_dta\saeb_prova_brasil\2007\provabrasil2007_notas_`x'.dta", replace



}
/*------------- Question�rio Alunos -------------*/
* para 4� s�rie/5� ano do EF e para 8�s�rie/ 9� ano do EF
* vari�veis finais: escolaridade da m�e e do pai
foreach x in 5 9 {
clear all
set more off
set trace on
# delimit ;
infix  

long id_aluno 1-8
int id_serie 9
int id_dependencia_adm 10
int id_localizacao 11
str2 sigla_uf 12-13
int cod_uf 14-15
str50 no_municipio 16-65
cod_municipio 66-72 
str47 tx_respostas 73-119

using "E:\SAEB Prova Brasil\microdados_prova_brasil_2007\Prova Brasil 2007\DADOS\TS_QUEST_ALUNO.TXT"
;
# delimit cr

keep if id_serie==`x'-1

**** Renomear e construir vari�veis

*gerado vari�vel de ano
gen ano_prova_brasil=2009


*no quest para 4� s�rie/5� ano, a posi��o da pergunta da m�e � 19 e do pai � 23

*m�e educ
gen mae=substr(tx_respostas,19,1)
*pai educ
gen pai=substr(tx_respostas,23,1)

*vari�vel que indica se m�e completou faculdade 
gen pb_esc_sup_mae_`x'=.
replace pb_esc_sup_mae_`x'=1 if mae=="E" 
replace pb_esc_sup_mae_`x'=0 if mae=="A"|mae=="B"|mae=="C"|mae=="D"|mae=="F"
*vari�vel que indica se pai completou faculdade
gen pb_esc_sup_pai_`x'=.
replace pb_esc_sup_pai_`x'=1 if pai=="E" 
replace pb_esc_sup_pai_`x'=0 if pai=="A"|pai=="B"|pai=="C"|pai=="D"|pai=="F"

save "E:\bases_dta\saeb_prova_brasil\2007\provabrasil2007_alunos_semcod_`x'.dta", replace


*associando com o c�digo de escola
clear all
# delimit ;
infix  

long id_aluno 1-8
int id_serie 30
long pk_cod_entidade 31-38


using "E:\SAEB Prova Brasil\microdados_prova_brasil_2007\Prova Brasil 2007\DADOS\TS_ALUNO.TXT"
;
# delimit cr
keep id_aluno pk_cod_entidade id_serie
keep if id_serie==`x'-1
rename pk_cod_entidade codigo_escola

merge 1:1 id_aluno using "E:\bases_dta\saeb_prova_brasil\2007\provabrasil2007_alunos_semcod_`x'.dta"
*collapse

collapse (mean) ano_prova_brasil pb_esc_sup_mae_`x' pb_esc_sup_pai_`x', by(codigo_escola)

save "E:\bases_dta\saeb_prova_brasil\2007\provabrasil2007_alunos_`x'.dta", replace

}
/*------------- Diretor -------------*/
* vari�veis finais: ano pb, m�todo de escolha da dire��o

clear all
# delimit ;
infix  
long codigo_escola 1-8
str tx_resp_questionario 72-233

using "E:\SAEB Prova Brasil\microdados_prova_brasil_2007\Prova Brasil 2007\DADOS\TS_QUEST_DIRETOR.TXT"
;
# delimit cr

*criar vari�veis

gen ano_prova_brasil=2009

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

save "E:\bases_dta\saeb_prova_brasil\2007\provabrasil2007_dir.dta", replace


/*------------- Docentes -------------*/
* para 4� s�rie/5� ano do EF e para 8�s�rie/ 9� ano do EF
* vari�veis finais: experi�ncia dos professores
foreach x in 5 9 {
clear all
# delimit ;
infix  
long pk_cod_entidade 1-8
int id_serie 79

str tx_resp_questionario 81 - 211

using "E:\SAEB Prova Brasil\microdados_prova_brasil_2007\Prova Brasil 2007\DADOS\TS_QUEST_PROFESSOR.TXT"
;
# delimit cr
**** Renomear e construir vari�veis

gen ano_prova_brasil = 2009
rename pk_cod_entidade codigo_escola



keep if id_serie==`x'-1

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


collapse (mean) ano_prova_brasil pb_exp_prof_mais_3_`x' pb_exp_prof_escola_mais_3_`x', by (codigo_escola)

save "E:\bases_dta\saeb_prova_brasil\2007\provabrasil2007_prof_`x'.dta", replace
}

foreach x in 5 9 {

use "E:\bases_dta\saeb_prova_brasil\2007\provabrasil2007_notas_`x'.dta", clear
merge 1:1 codigo_escola using "E:\bases_dta\saeb_prova_brasil\2007\provabrasil2007_alunos_`x'.dta"
drop _merge
merge 1:1 codigo_escola using "E:\bases_dta\saeb_prova_brasil\2007\\provabrasil2007_dir.dta"
drop _merge
merge 1:1 codigo_escola using "E:\bases_dta\saeb_prova_brasil\2007\provabrasil2007_prof_`x'.dta"
drop _merge
save "E:\bases_dta\saeb_prova_brasil\2007\provabrasil2007_`x'.dta", replace
}



use "E:\bases_dta\saeb_prova_brasil\2007\provabrasil2007_5.dta",clear
merge 1:1 codigo_escola using "E:\bases_dta\saeb_prova_brasil\2007\provabrasil2007_9.dta"
drop _merge
save "E:\bases_dta\saeb_prova_brasil\2007\provabrasil2007.dta", replace
