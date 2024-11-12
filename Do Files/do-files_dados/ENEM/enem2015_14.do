/*************************Enem 2015********************************/

/*criado: 17/05/2018*/
/*última modif: 17/05/2018*/
/*objetivo final é replicar os resultados obtidos anteriormente. Logo, 
vamos traduzir a base original do enem para uma base somente com as 
variáveis usadas no trabalho anteior*/

/*objetivo do do-file: 
gerar dummies adequadas e renomear,
keep as variáveis que foram usadas nas estimacoes anteriores, 
dropar as não usadas
collpase em escola
com base no do-file 
enem2015_agregadoescola_replic_semconcludentes.do
*/
clear all
set more off
set trace on
import delimited "\\tsclient\E\\ENEM\microdados_enem2015\microdados_enem_2015\DADOS5\MICRODADOS_ENEM_2015.csv", delimiter(",")
# delimit ;
keep
nu_inscricao
nu_ano
tp_st_conclusao
tp_ensino
co_escola
co_municipio_esc
sg_uf_esc
tp_presenca_cn
tp_presenca_mt
tp_presenca_ch
tp_presenca_lc
tp_status_redacao
nu_nota_cn
nu_nota_ch
nu_nota_lc
nu_nota_mt
nu_nota_redacao
q005
q001
q002
q006
q010
q026
;
# delimit cr
save "\\tsclient\E\bases_dta\enem\enem2015_sujo_14.dta", replace


use "\\tsclient\E\bases_dta\enem\enem2015_sujo_14.dta", clear

*variavel numero de inscricoes no enem por escola
*1
rename nu_inscricao n_inscricoes_enem

*variavel de ano do enem
*2
rename nu_ano ano_enem
label variable ano_enem "Ano da prova do ENEM (ENEM)"


*variavel que indica se inscrito terminou o terceiro ano no ano do enem
*3
gen concluir_em_ano_enem = .
replace concluir_em_ano_enem = 1 if tp_st_conclusao == 2
replace concluir_em_ano_enem = 0 if tp_st_conclusao == 1 |				///
	tp_st_conclusao == 3 | tp_st_conclusao == 4
label variable concluir_em_ano_enem 									///
	"Conclui EM no ano do ENEM (ST_CONCLUSAO == 2) (ENEM)"

*manter somente alunos do terceiro ano
keep if concluir_em_ano_enem == 1	

*variavel que indica qual tipo de instituicao onde o estudante concluiu ou concluira o ensino medio
* assume 1 se a instituicao eh regular
*4
gen  insc_regular_enem = .
replace insc_regular_enem = 1 if tp_ensino == 1
replace insc_regular_enem = 0 if tp_ensino == 2 | tp_ensino == 3
label variable insc_regular_enem 										///
	"Tipo de instituição onde o estudante concluiu ou concluirá o ensino médio (IN_TP_ENSINO == 1 (Ensino Regular)) (ENEM)"

	
* nao tem variavel de professionalizacao


*variavel com codigo de escola
*5
rename co_escola  codigo_escola	
label variable codigo_escola											///
	"Código da Escola: Número geradocomo identificação da escola (ENEM)"

*variavel codigo do municipio da escola
*6
rename co_municipio_esc codigo_municipio


*variavel estado/uf da escola
*7
rename sg_uf_esc sigla


*variavel de presenca nas provas
*8
gen  presentes_enem = .
replace presentes_enem = 1 if tp_presenca_cn == 1  &  tp_presenca_mt 	///
	== 1 & tp_presenca_ch  == 1 & tp_presenca_lc == 1  
label variable presentes_enem "Presente nas duas provas do enem (IN_PRESENCA=1 e IN_SITUACAO=P ou B ou N) (ENEM)"

*variavel que indica se inscrito estava presente 
*nas duas provas (obj e redacao)
*9
gen presentes_enem_obj_red = .
replace presentes_enem = 1 if tp_presenca_cn == 1 & tp_presenca_ch == 1	///
	& tp_presenca_lc == 1 & tp_presenca_mt == 1  & ///
	(tp_status_redacao == 1 | tp_status_redacao == 2 | tp_status_redacao == 3	| tp_status_redacao == 4 | tp_status_redacao == 5 | tp_status_redacao == 6 | tp_status_redacao == 7 | tp_status_redacao == 8 | tp_status_redacao == 9	)
label variable presentes_enem_obj_red "Presente nas duas provas do enem"




*variaveis notas das provas objetivas
*10
rename nu_nota_cn enem_nota_ciencias
label variable enem_nota_ciencias 										///
	"Nota da prova de Ciências da Natureza"
*11
rename nu_nota_ch enem_nota_humanas
label variable enem_nota_humanas 										///
	"Nota da prova de Ciências da Humanas"
*12
rename nu_nota_lc enem_nota_linguagens
label variable enem_nota_linguagens 									///
	"Nota da prova de Ciências da Linguagens e Códigos"
*13
rename nu_nota_mt enem_nota_matematica
label variable  enem_nota_matematica									///
	"Nota da prova de Ciências da Matemática"

*variável nota da redacao
*14
rename nu_nota_redacao enem_nota_redacao
label variable enem_nota_redacao 										///
	"Nota da Prova de Redação (ENEM)"

*variavel que indica se inscrito mora com mais de 6 pessoas
*15
gen e_mora_mais_de_6_pessoas = .
replace e_mora_mais_de_6_pessoas = 1 if q005 > 7
replace e_mora_mais_de_6_pessoas = 0 if q005 <= 7 & q005 != .
label variable e_mora_mais_de_6_pessoas "Mora com mais de 6 pessoas (Q15==E)(ENEM)"

*variavel que indica se inscrito mora com mais 7 pessoas
*16
gen  e_mora_mais_de_7_pessoas = .
replace e_mora_mais_de_7_pessoas = 1 if q005 > 8
replace e_mora_mais_de_7_pessoas = 0 if q005 <= 8 & q005 != .
label variable e_mora_mais_de_7_pessoas "Quantas pessoas moram com você? (Q04 >7 ) (ENEM)"


*variavel que indica se pai do inscrito tem ensino superior
*17
gen e_escol_sup_pai = . 
replace e_escol_sup_pai = 1 if q001 == "F" | q001 == "G" 
replace e_escol_sup_pai = 0 if q001 == "A" | q001 == "B" | 				///
	q001 == "C" | q001 == "D" | q001 == "E" | q001 == "H" 
label  variable e_escol_sup_pai "Até quando pai estudou (Q001 = F G) (ENEM)"

*variavel que indica se mae do inscrito tem ensino superior
*18
gen e_escol_sup_mae = .
replace e_escol_sup_mae = 1 if q002 == "F" | q002 == "G"  
replace e_escol_sup_mae = 0 if q002 == "A" | q002 == "B" | 			///
	q002 == "C" | q002 == "D" | q002 == "E" | q002 == "H" 
label variable e_escol_sup_mae "Até quando mãe estudou (Q02 == F G) (ENEM)"

*variavel que indica se renda da familia do inscrito eh maior igual a 5 
*salarios minimos
*19
gen e_renda_familia_5_salarios = .
replace e_renda_familia_5_salarios = 1 if  q006 == "I" | q006 == "J" 	///
| q006 == "K" | q006 =="L" | q006 == "M" | q006 == "O" | q006 == "P" 	///
| q006 == "Q"   
replace e_renda_familia_5_salarios = 0 if  q006 == "A" | q006 == "B" 	///
| q006 == "C" | q006 =="D" | q006 == "E" | q006 == "F" | q006 == "G" 	///
| q006 == "H"   
label variable e_renda_familia_5_salarios "Renda familiar é maior que 5 salários mínimos (Q006== I J  K L M N O P Q (ENEM))"

*variavel que indica se inscrito possui automovel
*20
gen e_automovel = .
replace e_automovel = 1 if q010 == "B" | q010 == "C" | q010 == "D" | 	///
q010 == "E" 
replace e_automovel = 0 if q010 == "A"

label variable e_automovel "Tem automóvel(q010!=A) (ENEM)"

*variavel que indica se inscrito trabalhao ou já trabalhou
*21
gen  e_trabalhou = .
replace e_trabalhou = 1 if q026 == "B" | q026 == "C" 
replace e_trabalhou = 0 if q026 == "A"
label variable e_trabalhou "Você trabalha ou já trabalhou? (Q026 == A) (ENEM)"


/*A próxima etapa é manter só as variáveis desejáveis*/
#d;
/*
keep
n_inscricoes_enem
ano_enem

codigo_municipio
sigla
enem_nota_ciencias
enem_nota_humanas
enem_nota_linguagens
enem_nota_matematica
enem_nota_redacao
concluir_em_ano_enem
insc_regular_enem
/*insc_prof_enem*/
presentes_enem
e_mora_mais_de_6_pessoas
e_mora_mais_de_7_pessoas
e_escol_sup_pai
e_escol_sup_mae
e_renda_familia_5_salarios
e_automovel
/*e_casa_propria*/
e_trabalhou
codigo_escola;

drop if codigo_escola ==.;
*/

/*Agora, agregar por escola*/
compress;
collapse 
(count) n_inscricoes_enem
(mean) ano_enem

(mean) codigo_municipio
/*(mean) sigla*/
(mean) enem_nota_ciencias
(mean) enem_nota_humanas
(mean) enem_nota_linguagens
(mean) enem_nota_matematica
(mean) enem_nota_redacao
(sum) concluir_em_ano_enem
(sum) insc_regular_enem
/*(sum) insc_prof_enem*/
(sum) presentes_enem
(mean) e_mora_mais_de_6_pessoas
(mean) e_mora_mais_de_7_pessoas
(mean) e_escol_sup_pai
(mean) e_escol_sup_mae
(mean) e_renda_familia_5_salarios
(mean) e_automovel
/*(mean) e_casa_propria*/
(mean) e_trabalhou,
by (codigo_escola);

save "\\tsclient\E\\bases_dta\enem\enem2015_14.dta", replace;

#d cr;
