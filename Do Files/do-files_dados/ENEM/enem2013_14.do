/*************************Enem 2013********************************/

/*objetivo final é replicar os resultados obtidos anteriormente. Logo, 
vamos traduzir a base original do enem para uma base somente com as 
variáveis usadas no trabalho anteior*/

/*objetivo do do-file: 
gerar dummies adequadas e renomear,
keep as variáveis que foram usadas nas estimacoes anteriores, 
dropar as não usadas
collpase em escola
com base no do-file  import enem 2013.do e no 
enem2013_agregadoescola_replic_semconcludentes.do
*/
clear all
set more off

import delimited "\\tsclient\E\\ENEM\microdados_enem2013\Microdados_Enem_2013\DADOS\MICRODADOS_ENEM_2013.csv", delimiter(";")
# delimit ;
keep 

nu_inscricao
nu_ano
st_conclusao
in_tp_ensino
cod_escola
cod_municipio_esc
uf_esc
in_presenca_cn
in_presenca_mt
in_presenca_ch
in_presenca_lc
in_status_redacao
nota_cn
nota_ch
nota_lc
nota_mt
nu_nota_redacao
q004
q001
q002
q003
q011
q005
q022

;
# delimit cr

save "\\tsclient\E\\bases_dta\enem\enem2013_sujo_14.dta", replace 

use "\\tsclient\E\\bases_dta\enem\enem2013_sujo_14.dta", clear
*variavel numero de inscricoes no enem por escola
*1
rename nu_inscricao n_inscricoes_enem

*variavel de ano do enem
*2
rename nu_ano ano_enem
label variable ano_enem "Ano da prova do ENEM (ENEM)"

*variavel que indica se inscrito terminou o terceiro ano no ano do enem
*3
gen concluir_em_ano_enem =. 
replace concluir_em_ano_enem = 1 if st_conclusao == 2
replace concluir_em_ano_enem = 0 if st_conclusao == 1 | 				/// 
		st_conclusao == 3 | st_conclusao == 4
label variable concluir_em_ano_enem 									///
	"Conclui EM no ano do ENEM (ST_CONCLUSAO == 2) (ENEM)"

*manter somente alunos do terceiro ano
keep if concluir_em_ano_enem == 1	

*variavel que indica qual tipo de instituicao onde o estudante concluiu ou concluira o ensino medio
* assume 1 se a instituicao eh regular
*4
gen  insc_regular_enem = .
replace insc_regular_enem = 1 if in_tp_ensino == 1
replace insc_regular_enem = 0 if in_tp_ensino == 2 | in_tp_ensino == 3	///
	| in_tp_ensino == 4
label variable insc_regular_enem										///
	"Tipo de instituição onde o estudante concluiu ou concluirá o ensino médio (IN_TP_ENSINO == 1 (Ensino Regular)) (ENEM)"

/*variavel que indica tipo de instituicao onde o estudante concluiu ou 
concluira o ensino medio 
1 para ensino professionalizante*/
*5
gen  insc_prof_enem = .
replace insc_prof_enem = 1 if in_tp_ensino == 3
replace insc_prof_enem = 0 if in_tp_ensino == 2 | in_tp_ensino == 1 	///
	| in_tp_ensino == 4
label variable insc_prof_enem "Tipo de instituição onde o estudante concluiu ou concluirá o ensino médio (IN_TP_ENSINO == 3 (Ensino Profissionalizante)) (ENEM)"


*variavel com codigo de escola
*6
rename cod_escola  codigo_escola
label variable codigo_escola 											///
	"Código da Escola: Número geradocomo identificação da escola (ENEM)"


*variavel codigo do municipio da escola
*7
rename cod_municipio_esc codigo_municipio

*variavel estado/uf da escola
*8
rename uf_esc sigla


*variavel de presenca nas provas
*9
gen  presentes_enem = .
replace presentes_enem = 1 if in_presenca_cn == 1  & 					/// 
	in_presenca_mt == 1 & in_presenca_ch == 1 & in_presenca_lc == 1
label variable presentes_enem "Presente nas duas provas do enem (IN_PRESENCA=1 e IN_SITUACAO=P ou B ou N) (ENEM)"

*variavel que indica se inscrito estava presente 
*nas duas provas (obj e redacao)

*10
gen presentes_enem_obj_red = .
replace presentes_enem = 1 if in_presenca_cn == 1 & in_presenca_ch == 1	///
	& in_presenca_lc == 1 & in_presenca_mt == 1  & (in_status_redacao == 1  | in_status_redacao == 2  | in_status_redacao == 3 | in_status_redacao == 4  | in_status_redacao == 5 | in_status_redacao == 7  | in_status_redacao == 9 | in_status_redacao == 10 | in_status_redacao == 11	)
label variable presentes_enem_obj_red "Presente nas duas provas do enem"



	
*variaveis notas das provas objetivas
*11
rename nota_cn enem_nota_ciencias
label variable enem_nota_ciencias 										///
	"Nota da prova de Ciências da Natureza"
*12
rename nota_ch enem_nota_humanas
label variable enem_nota_humanas										///
	"Nota da prova de Ciências da Humanas"
*13
rename nota_lc enem_nota_linguagens
label variable enem_nota_linguagens										///
	"Nota da prova de Ciências da Linguagens e Códigos"
*14
rename nota_mt enem_nota_matematica
label variable  enem_nota_matematica									///
	"Nota da prova de Ciências da Matemática"

*variavel nota da redacao
*15
rename nu_nota_redacao enem_nota_redacao
label variable enem_nota_redacao "Nota da Prova de Redação (ENEM)"	


*variavel que indica se inscrito mora com mais de 6 pessoas
*16
gen e_mora_mais_de_6_pessoas = .
replace e_mora_mais_de_6_pessoas = 1 if q004 >= 7
replace e_mora_mais_de_6_pessoas = 0 if q004 < 7 & q004 != . 
label variable e_mora_mais_de_6_pessoas "Mora com mais de 6 pessoas (Q004==E)(ENEM)"


*variavel que indica se inscrito mora com de 7 pessoas
*17
gen  e_mora_mais_de_7_pessoas = .
replace e_mora_mais_de_7_pessoas = 1 if q004 >= 8
replace e_mora_mais_de_7_pessoas = 0 if q004 < 8 & q004 != .
label variable e_mora_mais_de_7_pessoas "Quantas pessoas moram com você? (Q04 >7 ) (ENEM)"

*variavel que indica se pai do inscrito tem ensino superior
*18
gen e_escol_sup_pai = .
replace e_escol_sup_pai = 1 if q001 == "G" | q001 == "H" 
replace e_escol_sup_pai = 0 if q001 == "A" | q001 == "B" | q001 == "C"	///
	| q001 == "D" |  q001 == "E" |  q001 == "F"
label  variable e_escol_sup_pai 										///
	"Até quando pai estudou (Q001 = G H) (ENEM)"

*variavel que indica se mae do inscrito tem ensino superior
*19
gen e_escol_sup_mae = .
replace e_escol_sup_mae = 1 if q002 == "G" | q002 == "H"  
replace e_escol_sup_mae = 0 if q002 == "A" | q002 == "B" | q002 == "C"	///
	| q002 == "D" |  q002 == "E" |  q002 == "F"
label variable e_escol_sup_mae 											///
	"Até quando mãe estudou (Q002 == G H) (ENEM)"

*variavel que indica se renda da familia do inscrito eh maior igual a 5 
*salarios minimos
*20
gen e_renda_familia_5_salarios = . 
replace e_renda_familia_5_salarios = 1 if  q003 == "I" | q003 == "J" 	///
| q003 == "K" | q003 =="L" | q003 == "M" | q003 == "N" | q003 == "O"  	///
| q003 == "P" | q003 == "Q"   
replace e_renda_familia_5_salarios = 0 if q003 == "A" | q003 == "B" 	///
| q003 == "C" | q003 =="D" | q003 == "E" | q003 == "F"  | q003 == "G" 	///
| q003 == "H"

label variable e_renda_familia_5_salarios "Renda familiar é maior que 5 salários mínimos (Q003== I J  K L M N O P Q (ENEM))"

*variavel que indica se inscrito possui automovel
*21
gen e_automovel = .
replace e_automovel = 1 if q011 == "A" | q011 == "B" | q011 == "C"
replace e_automovel = 0 if q011 == "D"
label variable e_automovel "Tem automóvel(Q11!=D) (ENEM)"

*variavel que indica se inscrito possui casa propria
*22
gen e_casa_propria = .
replace e_casa_propria = 1 if q005 == "A" | q005 == "B"
replace e_casa_propria = 0 if q005 == "C" | q005 == "D" | q005 == "E"
label variable e_casa_propria "Tem casa própria (Q05 == A B) (ENEM)"

*variavel que indica se inscrito ja trabalhou
*23
gen  e_trabalhou = .
replace e_trabalhou = 1 if q022 == "A" | q022 == "B"
replace e_trabalhou = 0 if q022 == "C"

label variable e_trabalhou "Você trabalha ou já trabalhou? (Q22 == A) (ENEM)"

*_______________________________________________________________




/*A próxima etapa é manter só as variáveis desejáveis*/
#d;
/*
keep
n_inscricoes_enem
ano_enem
concluir_em_ano_enem
insc_regular_enem
insc_prof_enem

codigo_escola
codigo_municipio
sigla
presentes_enem
presentes_enem_obj_red
enem_nota_ciencias
enem_nota_humanas
enem_nota_linguagens
enem_nota_matematica
enem_nota_redacao

e_mora_mais_de_6_pessoas
e_mora_mais_de_7_pessoas
e_escol_sup_pai
e_escol_sup_mae
e_renda_familia_5_salarios
e_automovel
e_casa_propria
e_trabalhou
;

drop if codigo_escola ==.;

*/
compress;
/*Agora, agregar por escola*/
collapse 
(count) n_inscricoes_enem
(mean) ano_enem
(sum) concluir_em_ano_enem
(mean) codigo_municipio
/*(mean) sigla*/
(sum) insc_regular_enem
(sum) insc_prof_enem
(sum) presentes_enem
(sum) presentes_enem_obj_red

(mean) enem_nota_ciencias
(mean) enem_nota_humanas
(mean) enem_nota_linguagens
(mean) enem_nota_matematica
(mean) enem_nota_redacao



(mean) e_mora_mais_de_6_pessoas
(mean) e_mora_mais_de_7_pessoas
(mean) e_escol_sup_pai
(mean) e_escol_sup_mae
(mean) e_renda_familia_5_salarios
(mean) e_automovel
(mean) e_casa_propria
(mean) e_trabalhou,
by (codigo_escola);

save "\\tsclient\E\\bases_dta\enem\enem2013_14.dta", replace;

#d cr;
