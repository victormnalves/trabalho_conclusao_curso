/*************************Enem 2010********************************/

/*objetivo final é replicar os resultados obtidos anteriormente. Logo, vamos
traduzir a base original do enem para uma base somente com as variáveis usadas
no trabalho anteior*/

/*objetivo do do-file: 
gerar dummies adequadas e renomear,
keep as variáveis que foram usadas nas estimacoes anteriores, 
dropar as não usadas
collpase em escola
com base no do-file  import enem 2010.do e no enem2010_agregadoescola_replic_semconcludentes.do
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
str IN_STATUS_REDACAO 951
NU_NT_CN 537-545
NU_NT_CH 546-554
NU_NT_LC 555-563
NU_NT_MT 564-572
NU_NOTA_REDACAO 997-1005
/*
str NU_INSCRICAO 1-12
NU_ANO 13-16
IDADE 17-19
str TP_SEXO 20
COD_MUNIC_INSC 21-27
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
str UF_CIDADE_PROVA 531-532
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
*/
using "\\tsclient\E\\ENEM\microdados_enem2010_2\Microdados ENEM 2010\Dados Enem 2010\DADOS_ENEM_2010.txt";
save "\\tsclient\E\\bases_dta\enem\enem2010_dados_14.dta", replace; 
# delimit cr

clear

# delimit ;
infix 

double NU_INSCRICAO 1-12
str Q01	14-14
str Q02 15-15
str Q03 16-16
str Q04 17-17
str Q06 19-19
str Q08 21-21

/*str NU_INSCRICAO 1-12
IN_QSE 13
str Q01 14
str Q02 15
str Q03 16
str Q04 17
str Q05 18
str Q06 19
str Q07 20
str Q08 21
str Q09 22
str Q10 23
str Q11 24
str Q12 25
str Q13 26
str Q14 27
str Q15 28
str Q16 29
str Q17 30
str Q18 31
str Q19 32
str Q20 33
str Q21 34
str Q22 35
str Q23 36
str Q24 37
str Q25 38
str Q26 39
str Q27 40
str Q28 41
str Q29 42
str Q30 43
str Q31 44
str Q32 45
str Q33 46
str Q34 47
str Q35 48
str Q36 49
str Q37 50
str Q38 51
str Q39 52
str Q40 53
str Q41 54
str Q42 55
str Q43 56
str Q44 57
str Q45 58
str Q46 59
str Q47 60
str Q48 61
str Q49 62
str Q50 63
str Q51 64
str Q52 65
str Q53 66
str Q54 67
str Q55 68
str Q56 69
str Q57 70*/
using "\\tsclient\E\\ENEM\microdados_enem2010_2\Microdados ENEM 2010\Dados Enem 2010\QUESTIONARIO_SOCIO_ECONOMICO_ENEM_2010.txt";
save "\\tsclient\E\\bases_dta\enem\enem2010_quest_14.dta", replace; 
# delimit cr
**************PRECISA MERGEAR COM enem2010_dados.dta
merge 1:1 NU_INSCRICAO using "\\tsclient\E\\bases_dta\enem\enem2010_dados_14.dta"

*variavel numero inscricoes enem por escola (quando collapsar)
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
replace concluir_em_ano_enem = 0 if ST_CONCLUSAO == 1 | ST_CONCLUSAO == 3 
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

*variavel que indica se inscrito estava presente na prova do enem
*9
gen presentes_enem =.
replace presentes_enem = 1 if IN_PRESENCA_CN == 1 & IN_PRESENCA_CH == 1	///
	& IN_PRESENCA_LC == 1 & IN_PRESENCA_MT == 1  

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







*variavel que indica se inscrito mora com mais de 7 pessoas

*16
gen  e_mora_mais_de_7_pessoas = . 
replace e_mora_mais_de_7_pessoas = 1 if Q01 == "C"| Q01 == "D" 
replace e_mora_mais_de_7_pessoas = 0 if Q01 == "A" | Q01 == "B" | Q01 == "E"
label variable e_mora_mais_de_7_pessoas "Quantas pessoas moram com você? (Q01 == C D E) (ENEM)"

*variavel que indica se pai tem educacao superior
*17
gen e_escol_sup_pai = .
replace e_escol_sup_pai = 1 if Q02 == "D" | Q02 == "E" | Q02 == "F" | Q02 == "G" | Q02 == "H" 
replace e_escol_sup_pai = 0 if Q02 == "A" | Q02 == "B" | Q02 == "C" | Q02 == "H"
label  variable e_escol_sup_pai "Até quando pai estudou (Q02 = D E F G H) (ENEM)"

*variavel que indica se mae tem educacao superior
*18
gen e_escol_sup_mae = .
replace e_escol_sup_mae = 1 if Q03 == "D" | Q03 == "E" | Q03 == "F" | Q03 == "G" | Q03 == "H"  
replace e_escol_sup_mae = 0 if Q03 == "A" | Q03 == "B" | Q03 == "C" | Q03 == "H"
label variable e_escol_sup_mae "Até quando mãe estudou (Q03 ==  D E F G H) (ENEM)"

*variavel que indica se a renda da familia eh maior que seis salarios minimos
*19
gen e_renda_familia_6_salarios = .
replace e_renda_familia_6_salarios = 1 if Q04 == "D" | Q04 == "E" | Q04 == "F" | Q04 == "G" 
replace e_renda_familia_6_salarios = 0 if Q04 == "A" | Q04 == "B" | Q04 == "C" | Q04 == "H"
label variable e_renda_familia_6_salarios "Quantas pessoas moram com você? (Q01 == D E F G H) (ENEM)"

*variavel que indica se inscrito tem casa própria
*20
gen e_casa_propria =.
replace e_casa_propria = 1 if Q06 == "A"
replace e_casa_propria = 0 if Q06 == "B" | Q06 == "C"
label variable e_casa_propria "Tem casa própria (Q06 == A) (ENEM)"

*variavel que indica se inscrito já trabalhou ou não
*21
gen e_trabalhou = . 
replace e_trabalhou = 1 if Q08 == "A"
replace e_trabalhou = 0 if Q08 == "B"
label variable e_trabalhou "Você trabalha ou já trabalhou? (Q08 == A) (ENEM)"


/*----------------------------------------------------------------------------------*/
*A PARTIR DAQUI ESSAS VARIAVEIS NAO ESTAO NO ENEM 2010
*gen e_renda_familia_5_salarios = 1 if  Q21 == "D" | Q21 == "E" | Q21 == "F" | Q21 =="G"  
*replace e_renda_familia_5_salarios = 0 if e_renda_familia_5_salarios ==.
*replace e_renda_familia_5_salarios = . if Q21=="." | Q21==""
*label variable e_renda_familia_5_salarios "Renda familiar é maior que 5 salários mínimos (Q21== D E F G) (ENEM)"

*gen e_automovel = 1 if Q26 != "D"
*replace e_automovel = 0 if e_automovel ==.
*replace e_automovel = . if Q26=="." | Q26==""
*label variable e_automovel "Tem automóvel(Q26!=D) (ENEM)"


*gen e_trabalhou_ou_procurou = 1 if Q42 != "E"
*replace e_trabalhou_ou_procurou = 0 if e_trabalhou_ou_procurou ==.
*replace e_trabalhou_ou_procurou = . if Q42=="." | Q42==""
*label variable e_trabalhou_ou_procurou "Trabalha,já trabalhou ou procurou, ganhando algum salário ou rendimento (Q42 != E) (ENEM)"
/*
gen e_conhecimento_lab = 1 if Q53 == "A"
replace e_conhecimento_lab = 0 if e_conhecimento_lab ==.
replace e_conhecimento_lab = . if Q53=="." | Q53==""
label variable  e_conhecimento_lab "Os conhecimentos no ensino médio foram bem desenvolvidos, com aulas práticas, laboratórios, etc (Q53 == A)(ENEM)"

gen e_cultura_conhec = 1 if Q54 == "A"
replace e_cultura_conhec = 0 if e_cultura_conhec ==.
replace e_cultura_conhec = . if Q54=="." | Q54==""
label variable e_cultura_conhec "Os conhecimentos no ensino médio proporcionaram cultura e conhecimento (Q54 == A)(ENEM)"

gen e_profs_conhec_reg = 1 if Q97 == "B" | Q97 == "C"
replace e_profs_conhec_reg = 0 if e_profs_conhec_reg ==.
replace e_profs_conhec_reg = . if Q97=="." | Q97==""
label  variable e_profs_conhec_reg "Avaliação da escola que fez o ensino médio quanto o conhecimento que os(as) professores(as) têm das matérias e a maneira de transmiti-lo (Q97 == B C(regular a bom e Bom a excelente)) (ENEM)"

gen e_profs_dedic_reg = 1 if Q98 == "B" | Q98 == "C"
replace e_profs_dedic_reg = 0 if e_profs_dedic_reg ==.
replace e_profs_dedic_reg = . if Q98=="." | Q98==""
label variable e_profs_dedic_reg "Avaliação da escola que fez o ensino médio quanto a dedicação dos(as) professores(as) para preparar aulas e atender aos alunos (Q98 == B C(regular a bom e Bom a excelente)) (ENEM)" 

gen e_biblioteca_reg = 1 if Q100 == "B" | Q100 == "C"
replace e_biblioteca_reg = 0 if e_biblioteca_reg ==.
replace e_biblioteca_reg = . if Q100=="." | Q100==""
label variable e_biblioteca_reg "Avaliação da escola que fez o ensino médio quanto a biblioteca (Q100 == B C(regular a bom e Bom a excelente)) (ENEM)"


gen e_lab_reg = 1 if Q102 == "B" | Q102 == "C"
replace e_lab_reg = 0 if e_lab_reg ==.
replace e_lab_reg = . if Q102=="." | Q102==""
label variable e_lab_reg "Avaliação da escola que fez o ensino médio quanto as condições dos laboratórios (Q102 == B C(regular a bom e Bom a excelente)) (ENEM)"


gen  e_interesse_alunos_reg = 1 if Q105 == "B" | Q105 == "C"
replace e_interesse_alunos_reg = 0 if e_interesse_alunos_reg ==.
replace e_interesse_alunos_reg = . if Q105=="." | Q105==""
label variable e_interesse_alunos_reg "Avaliação da escola que fez o ensino médio quanto o interesse dos(as) alunos(as) (Q105 == B C(regular a bom e Bom a excelente)) (ENEM)"



gen  e_direcao_reg = 1 if Q109 == "B" | Q109 == "C"
replace e_direcao_reg = 0 if e_direcao_reg ==.
replace e_direcao_reg = . if Q109=="." | Q109==""
label variable e_direcao_reg "Avaliação da escola que fez o ensino médio quanto a direção dela (Q109 == B C(regular a bom e Bom a excelente)) (ENEM)"



gen  e_nota_em_7 = 1 if Q147 == "H" | Q147 == "I" | Q147 == "J" |  Q147 == "K"
replace e_nota_em_7 = 0 if e_nota_em_7 ==.
replace e_nota_em_7 = . if Q147=="." | Q147==""
label variable e_nota_em_7 "Nota para a formação que obteve no ensino médio (Q147 == H I J K) (ENEM)"

gen  e_ajuda_esc_profissao_muito = 1 if Q222 == "A" 
replace e_ajuda_esc_profissao_muito = 0 if e_ajuda_esc_profissao_muito ==.
replace e_ajuda_esc_profissao_muito = . if Q222=="." | Q222==""
label variable e_ajuda_esc_profissao_muito "A escola ajudou a tomar minha decisão sobre minha profissão (Q222 == A) (ENEM)"

*/






/*A próxima etapa é manter só as variáveis desejáveis*/
#d;
/*keep
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

e_escol_sup_pai
e_escol_sup_mae
e_casa_propria
e_mora_mais_de_7_pessoas
e_renda_familia_6_salarios
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
(count) n_inscricoes_enem

(mean) enem_nota_ciencias
(mean) enem_nota_humanas
(mean) enem_nota_linguagens
(mean) enem_nota_matematica
(mean) enem_nota_redacao

(mean) e_escol_sup_pai
(mean) e_escol_sup_mae
(mean) e_casa_propria
(mean) e_mora_mais_de_7_pessoas
(mean) e_renda_familia_6_salarios
(mean) e_trabalhou

(mean) codigo_municipio
/*(mean)sigla*/
(sum) presentes_enem
(sum) presentes_enem_obj_red


,
by (codigo_escola);

save "\\tsclient\E\\bases_dta\enem\enem2010_14.dta", replace;

#d cr;
