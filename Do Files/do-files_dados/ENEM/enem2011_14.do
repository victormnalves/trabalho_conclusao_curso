/*************************Enem 2011********************************/

/*objetivo final é replicar os resultados obtidos anteriormente. Logo, vamos
traduzir a base original do enem para uma base somente com as variáveis usadas
no trabalho anteior*/

/*objetivo do do-file: 
gerar dummies adequadas e renomear,
keep as variáveis que foram usadas nas estimacoes anteriores, 
dropar as não usadas
collpase em escola
com base no do-file  import enem 2011.do e no enem2011_agregadoescola_replic_semconcludentes.do
*/

clear all
set more off
set trace on
# delimit ;
infix 

double NU_INSCRICAO 1-12
NU_ANO 13-16
ST_CONCLUSAO 180-180
IN_TP_ENSINO 181-181
double PK_COD_ENTIDADE 204-211
double COD_MUNICIPIO_ESC 212-218
str UF_ESC 369-370
IN_PRESENCA_CN 533
IN_PRESENCA_CH 534
IN_PRESENCA_LC 535
IN_PRESENCA_MT 536
NU_NT_CN 537-545
NU_NT_CH 546-554
NU_NT_LC 555-563
NU_NT_MT 564-572
str IN_STATUS_REDACAO 951
NU_NOTA_REDACAO 997-1005

/*
str NU_INSCRICAO 1-12
NU_ANO 13-16
IDADE 17-19
TP_SEXO 20
COD_MUNICIPIO_INSC 21-27
str NO_MUNICIPIO_INSC 28-177
str UF_INSC 178-179
ST_CONCLUSAO 180
IN_TP_ENSINO 181
IN_CERTIFICADO 182
IN_BRAILLE 183
IN_AMPLIADA 184
IN_LEDOR 185
IN_ACESSO 186
IN_TRANSCRICAO 187
IN_LIBRAS 188
IN_UNIDADE_PRISIONAL 189
IN_BAIXA_VISAO 190
IN_CEGUEIRA 191
IN_DEFICIENCIA_AUDITIVA 192
IN_DEFICIENCIA_FISICA 193
IN_DEFICIENCIA_MENTAL 194
IN_DEFICIT_ATENCAO 195
IN_DISLEXIA 196
IN_GESTANTE 197
IN_LACTANTE 198
IN_LEITURA_LABIAL 199
IN_SABATISTA 200
IN_SURDEZ 201
TP_ESTADO_CIVIL 202
TP_COR_RACA 203
PK_COD_ENTIDADE 204-211
COD_MUNICIPIO_ESC 212-218
str NO_MUNICIPIO_ESC 219-368
str UF_ESC 369-370
ID_DEPENDENCIA_ADM 371
ID_LOCALIZACAO 372
SIT_FUNC 373
COD_MUNICIPIO_PROVA 374-380
str NO_MUNICIPIO_PROVA 381-530
str UF_MUNICIPIO_PROVA 531-532
IN_PRESENCA_CN 533
IN_PRESENCA_CH 534
IN_PRESENCA_LC 535
IN_PRESENCA_MT 536
NU_NT_CN 537-545
NU_NT_CH 546-554
NU_NT_LC 555-563
NU_NT_MT 564-572
str TX_RESPOSTAS_CN 573-617
str TX_RESPOSTAS_CH 618-662
str TX_RESPOSTAS_LC 663-707
str TX_RESPOSTAS_MT 708-752
ID_PROVA_CN 753-755
ID_PROVA_CH 756-758
ID_PROVA_LC 759-761
ID_PROVA_MT 762-764
TP_LINGUA 765
str DS_GABARITO_CN 766-810
str DS_GABARITO_CH 811-855
str DS_GABARITO_LC 856-905
str DS_GABARITO_MT 906-950
str IN_STATUS_REDACAO 951
NU_NOTA_COMP1 952-960
NU_NOTA_COMP2 961-969
NU_NOTA_COMP3 970-978
NU_NOTA_COMP4 979-987
NU_NOTA_COMP5 988-996
NU_NOTA_REDACAO 997-1005
IN_CONCLUINTE_CENSO 1006
COD_ETAPA_ENSINO_CENSO 1007-1008
COD_ENTIDADE_CENSO 1009-1016
COD_MUNICIPIO_ESC_CENSO 1017-1023
str NO_MUNICIPIO_ESC_CENSO 1024-1173
str UF_ESC_CENSO 1174-1175
ID_DEPENDENCIA_ADM_CENSO 1176
ID_LOCALIZACAO_CENSO 1177
SIT_FUNC_CENSO 1178
*/
using "\\tsclient\E\\ENEM\microdados_enem2011\DADOS\DADOS_ENEM_2011.txt";
save "\\tsclient\E\\bases_dta\enem\enem2011_dados_14.dta", replace; 
# delimit cr
clear

# delimit ;
infix 

double NU_INSCRICAO 1-12
Q1	14-15
str Q2 16-16
str Q3 17-17
str Q4 18-18
str Q6 20-20
str Q8 22-22
str Q65 80-80
/*
str NU_INSCRICAO 1-12
IN_QSE 13
str Q1 14-15
str Q2 16
str Q3 17
str Q4 18
str Q5 19
str Q6 20
str Q7 21
str Q8 22
str Q9 23
str Q10 24
str Q11 25
str Q12 26
str Q13 27
str Q14 28
str Q15 29
str Q16 30
str Q17 31
str Q18 32
str Q19 33
str Q20 34
str Q21 35
str Q22 36
str Q23 37-38
str Q24 39
str Q25 40
str Q26 41
str Q27 42
str Q28 43
str Q29 44
str Q30 45
str Q31 46
str Q32 47
str Q33 48
str Q34 49
str Q35 50
str Q36 51
str Q37 52
str Q38 53
str Q39 54
str Q40 55
str Q41 56
str Q42 57
str Q43 58
str Q44 59
str Q45 60
str Q46 61
str Q47 62
str Q48 63
str Q49 64
str Q50 65
str Q51 66
str Q52 67
str Q53 68
str Q54 69
str Q55 70
str Q56 71
str Q57 72
str Q58 73
str Q59 74
str Q60 75
str Q61 76
str Q62 77
str Q63 78
str Q64 79
str Q65 80
str Q66 81
str Q67 82
str Q68 83
str Q69 84
str Q70 85
str Q71 86
str Q72 87
str Q73 88
str Q74 89
str Q75 90

*/
using "\\tsclient\E\\ENEM\microdados_enem2011\DADOS\QUESTIONARIO_SOCIO_ECONOMICO_ENEM_2011.txt";
save "\\tsclient\E\\bases_dta\enem\enem2011_quest_14.dta", replace; 
# delimit cr

use "\\tsclient\E\\bases_dta\enem\enem2011_quest_14.dta", clear
**************PRECISA MERGEAR COM enem2011_dados.dta
merge 1:1 NU_INSCRICAO using "\\tsclient\E\\bases_dta\enem\enem2011_dados_14.dta"

*variavel numero de inscricoes no enem por escola
*1
rename NU_INSCRICAO n_inscricoes_enem

*variavel de ano do enem
*2
rename NU_ANO ano_enem
label variable ano_enem "Ano da prova do ENEM (ENEM)"

*variavel que indica se inscrito concluiu no mesmo ano que enem
*3
gen concluir_em_ano_enem = .
replace concluir_em_ano_enem = 1 if ST_CONCLUSAO == 2
replace concluir_em_ano_enem = 0 if ST_CONCLUSAO == 1 |ST_CONCLUSAO == 3 |ST_CONCLUSAO == 4
label variable concluir_em_ano_enem "Conclui EM no ano do ENEM (ST_CONCLUSAO == 2) (ENEM)"

*manter somente alunos do terceiro ano
keep if concluir_em_ano_enem == 1

*variavel que indica qual tipo de instituicao onde o estudante concluiu ou concluira o ensino medio
* assume 1 se a instituicao eh regular
*4
gen  insc_regular_enem = .
replace insc_regular_enem = 1 if IN_TP_ENSINO == 1
replace insc_regular_enem = 0 if IN_TP_ENSINO == 2 | IN_TP_ENSINO == 3 | IN_TP_ENSINO == 4
label variable insc_regular_enem "Tipo de instituição onde o estudante concluiu ou concluirá o ensino médio (IN_TP_ENSINO == 1 (Ensino Regular)) (ENEM)"

/*variavel que indica tipo de instituicao onde o estudante concluiu ou 
concluira o ensino medio 
1 para ensino professionalizante*/
*5
gen  insc_prof_enem = .
replace insc_prof_enem = 1 if IN_TP_ENSINO == 3
replace insc_prof_enem = 0 if IN_TP_ENSINO == 2 | IN_TP_ENSINO == 1 | IN_TP_ENSINO == 4
label variable insc_prof_enem "Tipo de instituição onde o estudante concluiu ou concluirá o ensino médio (IN_TP_ENSINO == 3 (Ensino Profissionalizante)) (ENEM)"


*variavel com codigo de escola
*6
rename PK_COD_ENTIDADE codigo_escola
label variable codigo_escola "Código da Escola: Número geradocomo identificação da escola (ENEM)"



*variavel codigo do municipio da escola
*7
rename COD_MUNICIPIO_ESC codigo_municipio

*variavel de estado/uf da escola
*8
rename UF_ESC sigla


*variavel de presenca nas provas
*9
gen presentes_enem =.
replace presentes_enem = 1 if IN_PRESENCA_CN == 1 & IN_PRESENCA_CH 		///
	== 1 & IN_PRESENCA_LC == 1 & IN_PRESENCA_MT ==1  
label variable presentes_enem "Presente nas duas provas do enem (IN_PRESENCA=1 e IN_SITUACAO=P ou B ou N) (ENEM)"

*variavel que indica se inscrito estava presente 
*nas duas provas (obj e redacao)

*10
gen presentes_enem_obj_red = .
replace presentes_enem = 1 if IN_PRESENCA_CN == 1 & IN_PRESENCA_CH == 1	///
	& IN_PRESENCA_LC == 1 & IN_PRESENCA_MT == 1  & ///
	(IN_STATUS_REDACAO == "P"  | IN_STATUS_REDACAO=="B"  | IN_STATUS_REDACAO=="N")
label variable presentes_enem_obj_red "Presente nas duas provas do enem"



*variaveis de nota das provas objetivas
*11
rename NU_NT_CN enem_nota_ciencias
label variable enem_nota_ciencias "Nota da prova de Ciências da Natureza"

*12
rename NU_NT_CH enem_nota_humanas
label variable enem_nota_humanas "Nota da prova de Ciências da Humanas"

*13
rename NU_NT_LC enem_nota_linguagens
label variable enem_nota_linguagens "Nota da prova de Ciências da Linguagens e Códigos"

*14
rename NU_NT_MT enem_nota_matematica
label variable  enem_nota_matematica "Nota da prova de Ciências da Matemática"

*variavel da nota da redacao
*15
rename NU_NOTA_REDACAO enem_nota_redacao
label variable enem_nota_redacao "Nota da Prova de Redação (ENEM)"




*variavel que indica se inscrito  mora com mais de 6 pessoas
*16
destring Q1, replace
gen e_mora_mais_de_6_pessoas =.
replace e_mora_mais_de_6_pessoas = 1 if Q1 > 6 
replace e_mora_mais_de_6_pessoas = 0 if Q1 <= 6 

label variable e_mora_mais_de_6_pessoas "Mora com mais de 6 pessoas (Q01>6)(ENEM)"

*variavel que indica se inscrito mora com mais de 7 pessoas
*17
gen  e_mora_mais_de_7_pessoas =.
replace e_mora_mais_de_7_pessoas = 1 if Q1 > 7
replace e_mora_mais_de_7_pessoas = 0 if Q1 <= 7
label variable e_mora_mais_de_7_pessoas "Quantas pessoas moram com você? (Q01 >7 ) (ENEM)"

*variavel que indica se pai de inscrito tem ensino superior
*18
gen e_escol_sup_pai = .
replace e_escol_sup_pai = 1 if Q2 == "G" | Q2 == "H" 
replace e_escol_sup_pai = 0 if Q2 == "A" | Q2 == "B" | Q2=="C" | Q2=="D" | Q2=="E" | Q2=="F" 
label  variable e_escol_sup_pai "Até quando pai estudou (Q02 = G H) (ENEM)"


*variavel que indica se mae de inscrito tem ensino superior
*19
gen e_escol_sup_mae = .
replace e_escol_sup_mae = 1 if Q3 == "G" | Q3 == "H"  
replace e_escol_sup_mae = 0 if Q3 == "A" | Q3 == "B" | Q3 == "C" | Q3 == "D" | Q3 == "E" | Q3 == "F" 
label variable e_escol_sup_mae "Até quando mãe estudou (Q03 == G H) (ENEM)"

*variavel que indica se renda da familia é maior igual a cinco salarios minimos
*20
gen e_renda_familia_5_salarios = .
replace e_renda_familia_5_salarios = 1 if Q4 == "F" | Q4 == "G" | Q4 == "H" | Q4 =="I" | Q4 == "J" | Q4 == "K"    
replace e_renda_familia_5_salarios = 0 if Q4 == "A" | Q4 == "B" | Q4 == "C" | Q4 =="D" | Q4 == "E"
label variable e_renda_familia_5_salarios "Renda familiar é maior que 5 salários mínimos (QO4== F G H I J K) (ENEM)"

*variavel que indica se inscrito tem automovel ou nao
*21
gen e_automovel =.
replace e_automovel = 1 if Q65 == "A" | Q65 == "B" | Q65 == "C"
replace e_automovel = 0 if Q65 == "D" 
label variable e_automovel "Tem automóvel(Q65!=D) (ENEM)"

*variavel que indica se inscrito tem casa propria 
*22
gen e_casa_propria =.
replace e_casa_propria = 1 if Q6 == "A" | Q6 == "B"
replace e_casa_propria = 0 if Q6 == "C" | Q6 == "D"
label variable e_casa_propria "Tem casa própria (Q06 == A B) (ENEM)"

*variavel que indica se inscrito ja trabalhou
*23
gen e_trabalhou = .
replace e_trabalhou = 1 if Q8 == "A"
replace e_trabalhou = 0 if Q8 == "B"
label variable e_trabalhou "Você trabalha ou já trabalhou? (Q08 == A) (ENEM)"


/*A próxima etapa é manter só as variáveis desejáveis*/
#d;
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

save "\\tsclient\E\\bases_dta\enem\enem2011_14.dta", replace;


#d cr;
