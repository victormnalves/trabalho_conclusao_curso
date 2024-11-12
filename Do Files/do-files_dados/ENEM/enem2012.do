/*************************Enem 2012********************************/

/*objetivo final é replicar os resultados obtidos anteriormente. Logo, vamos
traduzir a base original do enem para uma base somente com as variáveis usadas
no trabalho anteior*/

/*objetivo do do-file: 
gerar dummies adequadas e renomear,
keep as variáveis que foram usadas nas estimacoes anteriores, 
dropar as não usadas
collpase em escola
com base no do-file  import enem 2012.do e no enem2012_agregadoescola_replic_semconcludentes.do
*/

clear all
set more off
set trace off
/*
import delimited "E:\ENEM\microdados_enem2012\DADOS\DADOS_ENEM_2012.csv"
# delimit ;
keep 
nu_inscricao
nu_ano
st_conclusao
in_tp_ensino
pk_cod_entidade
cod_municipio_esc
uf_esc
in_presenca_cn
in_presenca_mt
in_presenca_ch
in_presenca_lc
in_status_redacao
nu_nt_cn
nu_nt_ch
nu_nt_lc
nu_nt_mt
nu_nota_redacao
;
# delimit cr


save "E:\bases_dta\enem\enem2012_dados.dta", replace 

clear
import delimited "E:\ENEM\microdados_enem2012\DADOS\QUESTIONARIO_ENEM_2012.csv"
# delimit ;
keep 
nu_inscricao
q04
q01
q02
q03
q11
q05
q22
;
# delimit cr
save "E:\bases_dta\enem\enem2012_quest.dta", replace 
*/

use "E:\bases_dta\enem\enem2012_quest.dta", clear
**************PRECISA MERGEAR COM enem2012_dados.dta
merge 1:1 nu_inscricao using "E:\bases_dta\enem\enem2012_dados.dta"


*variavel numero de inscricoes no enem por escola
*1
rename nu_inscricao n_inscricoes_enem

*variavel de ano do enem
*2
rename nu_ano ano_enem
label variable ano_enem "Ano da prova do ENEM (ENEM)"


*variavel que indica se inscrito concluiu no mesmo ano que enem
*3
gen concluir_em_ano_enem =.
replace concluir_em_ano_enem = 1 if st_conclusao == 2
replace concluir_em_ano_enem = 0 if st_conclusao == 1 | st_conclusao 	///	
	== 3| st_conclusao == 4

label variable concluir_em_ano_enem "Conclui EM no ano do ENEM (ST_CONCLUSAO == 2) (ENEM)"

*manter somente alunos do terceiro ano
keep if concluir_em_ano_enem == 1

*variavel que indica qual tipo de instituicao onde o estudante concluiu ou concluira o ensino medio
* assume 1 se a instituicao eh regular
*4
gen  insc_regular_enem = .
replace insc_regular_enem = 1 if in_tp_ensino == 1
replace insc_regular_enem = 0 if in_tp_ensino == 2 | in_tp_ensino == 3 	///
| in_tp_ensino == 4
label variable insc_regular_enem "Tipo de instituição onde o estudante concluiu ou concluirá o ensino médio (IN_TP_ENSINO == 1 (Ensino Regular)) (ENEM)"


/*variavel que indica tipo de instituicao onde o estudante concluiu ou 
concluira o ensino medio 
1 para ensino professionalizante*/
*5
gen  insc_prof_enem = .
replace insc_prof_enem = 1 if in_tp_ensino == 3
replace insc_prof_enem = 0 if in_tp_ensino == 2 | in_tp_ensino == 1 	///
	| in_tp_ensino == 4
label variable insc_prof_enem "Tipo de instituição onde o estudante concluiu ou concluirá o ensino médio (IN_TP_ENSINO == 3 (Ensino Profissionalizante)) (ENEM)"

*variavel codigo da escola
*6
rename pk_cod_entidade codigo_escola
label variable codigo_escola "Código da Escola: Número geradocomo identificação da escola (ENEM)"

*variavel codigo do municipio da escola
*7
rename cod_municipio_esc codigo_municipio


*variavel de estado/uf da escola
*8
rename uf_esc sigla

*variavel de presenca nas provas
*9
gen  presentes_enem = .
replace presentes_enem = 1 if in_presenca_cn == 1  &  in_presenca_mt 	///
	== 1 & in_presenca_ch  == 1 & in_presenca_lc ==1
label variable presentes_enem "Presente nas duas provas do enem (IN_PRESENCA=1 e IN_SITUACAO=P ou B ou N) (ENEM)"

*variavel que indica se inscrito estava presente 
*nas duas provas (obj e redacao)

*10
gen presentes_enem_obj_red = .
replace presentes_enem = 1 if in_presenca_cn == 1 & in_presenca_ch == 1	///
	& in_presenca_lc == 1 & in_presenca_mt == 1  & (in_status_redacao == "P"  | in_status_redacao == "B"  | in_status_redacao == "T" | in_status_redacao == "N"  | in_status_redacao == "I"| in_status_redacao == "A"  | in_status_redacao == "H"| in_status_redacao == "C"	)
label variable presentes_enem_obj_red "Presente nas duas provas do enem"




*variaveis de nota das provas objetivas
*11
rename nu_nt_cn  enem_nota_ciencias
label variable enem_nota_ciencias "Nota da prova de Ciências da Natureza"
*12
rename  nu_nt_ch enem_nota_humanas
label variable enem_nota_humanas "Nota da prova de Ciências da Humanas"
*13
rename nu_nt_lc enem_nota_linguagens
label variable enem_nota_linguagens "Nota da prova de Ciências da Linguagens e Códigos"
*14
rename nu_nt_mt enem_nota_matematica
label variable  enem_nota_matematica "Nota da prova de Ciências da Matemática"


*variavel de nota da redacao
*15
rename nu_nota_redacao enem_nota_redacao
label variable enem_nota_redacao "Nota da Prova de Redação (ENEM)"








*variavel que indica se inscrito  mora com mais de 6 pessoas

*16
gen e_mora_mais_de_6_pessoas = .
replace e_mora_mais_de_6_pessoas = 1 if q04 >= 7
replace e_mora_mais_de_6_pessoas = 0 if q04 < 7
label variable e_mora_mais_de_6_pessoas "Mora com mais de 6 pessoas (Q15==E)(ENEM)"

*variavel que indica se inscrito mora com mais de 7 pessoas
*17
gen  e_mora_mais_de_7_pessoas = .
replace e_mora_mais_de_7_pessoas = 1 if q04 >= 8
replace e_mora_mais_de_7_pessoas = 0 if q04 <8
label variable e_mora_mais_de_7_pessoas "Quantas pessoas moram com você? (Q04 >7 ) (ENEM)"



*variavel que indica se pai de inscrito tem ensino superior
*18
gen e_escol_sup_pai = .
replace e_escol_sup_pai = 1 if q01 == "G" | q01 == "H" 
replace e_escol_sup_pai = 0 if q01 == "A" | q01 == "B" | q01 == "C" | 	///
	q01 == "D" | q01 == "E" | q01 == "F"
label  variable e_escol_sup_pai "Até quando pai estudou (Q01 = G H) (ENEM)"

*variavel que indica se mae de inscrito tem ensino superior
*19
gen e_escol_sup_mae = .
replace e_escol_sup_mae = 1 if q02 == "G" | q02 == "H"  
replace e_escol_sup_mae = 0 if q02 == "A" | q02 == "B" | q02 == "C" | 	///
q02 == "D" | q02 == "E" | q02 == "F" 
label variable e_escol_sup_mae "Até quando mãe estudou (Q02 == G H) (ENEM)"

*variavel que indica se renda da familia do inscrito eh maior ou igual a 5 salarios minimos
*20
gen e_renda_familia_5_salarios = .
replace e_renda_familia_5_salarios = 1 if q03 == "I" | q03 == "J" | 	///
	q03 == "K" | q03 =="L" | q03 == "M" | q03 == "N" | q03 == "O" |  	///
	q03 == "P" | q03 == "Q" 
replace e_renda_familia_5_salarios = 0 if q03 == "A" | q03 == "B" | 	///
	q03 == "C" | q03 =="D" | q03 == "E" | q03 == "F" | q03 == "G" | 	///
	q03 == "H" 

label variable e_renda_familia_5_salarios "Renda familiar é maior que 5 salários mínimos (QO3== I J  K L M N O P Q (ENEM))"

*variavel que indica se inscrito possui automovel
*21
gen e_automovel = .
replace e_automovel = 1 if q11 == "A" | q11 == "B" | q11 == "C"
replace e_automovel = 0 if q11 == "D"
label variable e_automovel "Tem automóvel(Q11!=D) (ENEM)"

*variavel que indica se inscrito possui casa propria
*22
gen e_casa_propria = .
replace e_casa_propria = 1 if q05 == "A" | q05 == "B"
replace e_casa_propria = 0 if q05 == "C" | q05 == "D" | q05 == "E" 
label variable e_casa_propria "Tem casa própria (Q05 == A B) (ENEM)"

*variavel que indica se inscrito ja trabalhou
*23
gen  e_trabalhou = .
replace e_trabalhou = 1 if q22 == "A"
replace e_trabalhou = 0 if q22 == "B"
label variable e_trabalhou "Você trabalha ou já trabalhou? (Q22 == A) (ENEM)"



*------------------------------------------------------

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
/*Agora, agregar por escola*/

collapse 
(sum) concluir_em_ano_enem
(sum) insc_regular_enem
(sum) insc_prof_enem

(mean) ano_enem
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
(mean) e_trabalhou


(count) n_inscricoes_enem


(mean) codigo_municipio
/*(mean) sigla*/

(sum) presentes_enem
(sum) presentes_enem_obj_red

,
by (codigo_escola);

save "E:\bases_dta\enem\enem2012.dta", replace;

#d cr;
