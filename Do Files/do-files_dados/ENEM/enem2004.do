/*************************Enem 2004********************************/
clear all
set more off
set trace on
# delimit ;
infix 

NU_ANO 9-16
IN_CONCLUIU 107-114
double MASC_ESC 115-122
double CODMUNIC_ESC 123-134
str SIGLA 155-156
IN_PRESENCA 238-245
NU_NOTA_OBJETIVA 286-293
NU_NOTA_GLOBAL_REDACAO 335-342
str Q14	357-357
str Q15 358-358
str Q16 359-359
str Q17 360-360
str Q22 365-365
str Q27 370-370
str Q34 377-377
str Q40 383-383
str Q52 395-395
str Q53 396-396
str Q87 430-430
str Q88 431-431
str Q90 433-433
str Q92 435-435
str Q95 438-438
str Q99 442-442
str Q130 473-473
str Q179 522-522

using "E:\ENEM\microdados_enem2004\DADOS\DADOS_ENEM_2004.txt";

# delimit cr

**** Renomear e construir vari�veis

/*Ano do Enem*/
rename NU_ANO ano_enem

/*
IN_CONCLUIU: Situa��o em rela��o ao ensino m�dio
"IN_CONCLUIU=1" indica que concluir� em 2004 (ano do ENEM)
*/
gen concluir_em_ano_enem=.
replace concluir_em_ano_enem=1 if IN_CONCLUIU==1
replace concluir_em_ano_enem=0 if IN_CONCLUIU==2 | IN_CONCLUIU==3

* manter s� alunos do 3� ano

keep if concluir_em_ano_enem==1

/*M�scara da escola*/
rename MASC_ESC mascara

/*C�digo do Munic�pio da escola em que estudou:*/
rename CODMUNIC_ESC codigo_municipio

/*Sigla da UF da escola*/
rename SIGLA sigla

/*
IN_PRESENCA: Presenca na prova objetiva
IN_PRESENCA==1 indica que esteve presente na prova
*/
gen presentes_enem=.
replace presentes_enem=1 if IN_PRESENCA==1
replace presentes_enem=0 if IN_PRESENCA==0

/*
Nota da prova objetiva
*/
rename NU_NOTA_OBJETIVA enem_nota_objetiva

/*
Nota da redac�o
*/
rename NU_NOTA_GLOBAL_REDACAO enem_nota_redacao

/*
Q14:Quantidade de pessoas que moram na casa
"F" indica que mora com mais de 6 pessoas
*/
gen e_mora_mais_de_6_pessoas=.
replace e_mora_mais_de_6_pessoas=1 if Q14=="F"
replace e_mora_mais_de_6_pessoas=0 if Q14=="A" | Q14=="B" | Q14=="C" |Q14=="D" | Q14=="E" | Q14=="G"

/*
Q15: Quantos filhos tem
"E" indica que n�o tem filho
*/
gen e_tem_filho=.
replace e_tem_filho=1 if Q15=="A" | Q15=="B" | Q15=="C" | Q15=="D"
replace e_tem_filho=0 if Q15=="E"

/*
Q16: At� quando o pai estudou
"G" e "H" indica que pai estudou completou faculdade ou superior
*/
gen e_escol_sup_pai=.
replace e_escol_sup_pai=1 if Q16=="G" | Q16=="H"
replace e_escol_sup_pai=0 if Q16=="A" | Q16=="B" | Q16=="C" | Q16=="D" | Q16=="E" | Q16=="F"

/*
Q17: At� quando a m�e estudou
"G" e "H" indica que pai estudou completou faculdade ou superior
*/
gen e_escol_sup_mae=.
replace e_escol_sup_mae=1 if Q17=="G" | Q17=="H"
replace e_escol_sup_mae=0 if Q17=="A" | Q17=="B" | Q17=="C" | Q17=="D" | Q17=="E" | Q17=="F"

/*
Q22:Renda familiar (somando a do respondente e com a das
pessoas que moram com ele)
"D" "E" "F" "G" indica que a renda familiar � igual ou maior que 5 sal�rios m�nimos
*/
gen e_renda_familia_5_salarios=.
replace e_renda_familia_5_salarios=1 if Q22=="D" | Q22=="E" | Q22=="F" | Q22=="G"
replace e_renda_familia_5_salarios=0 if Q22=="A" | Q22=="B" | Q22=="C" | Q22=="H"
/*
Q27:Tem Autom�vel e quantos
"D" indica que n�o tinha autom�vel
*/
gen e_automovel=.
replace e_automovel=1 if Q27=="A" | Q27=="B" | Q27=="C"
replace e_automovel=0 if Q27=="D"
/*
Q34:Tem casa pr�pria
"A" indica que tem casa pr�pria
*/
gen e_casa_propria=.
replace e_casa_propria=1 if Q34=="A"
replace e_casa_propria=0 if Q34=="B"
/*
Q40:Trabalha, ou j� trabalhou, ganhando algum sal�rio ou
rendimento
"A" ou "C" indica que trabalhou ou j� procurou trabalho
*/
gen e_trabalhou_ou_procurou=.
replace e_trabalhou_ou_procurou=1 if Q40=="A" | Q40=="C"
replace e_trabalhou_ou_procurou=0 if Q40=="B" 
/*
Q52:Os conhecimentos no ensino m�dio foram bem
desenvolvidos, com aulas pr�ticas, laborat�rios, etc
"A" indica que conhecimentos foram bem desenolvidos com laborat�rios
*/
gen e_conhecimento_lab=.
replace e_conhecimento_lab=1 if Q52=="A"
replace e_conhecimento_lab=0 if Q52=="B"
/*
Q53:Os conhecimentos no ensino m�dio proporcionaram
cultura e conhecimento
"A" indica que o conhecimentos no em proporcionaram cultura e conhecimento
*/
gen e_cultura_conhec=.
replace e_cultura_conhec=1 if Q53=="A"
replace e_cultura_conhec=0 if Q53=="B"
/*
Q87:Avalia��o da escola que fez o ensino m�dio quanto o
conhecimento que os(as) professores(as) t�m das
mat�rias e a maneira de transmiti-lo
"B" indica regular a bom
"C" indica bom ou excelente
*/
gen e_profs_conhec_reg=.
replace e_profs_conhec_reg=1 if Q87=="B" | Q87=="C"
replace e_profs_conhec_reg=0 if Q87=="A"
/*
Q88:
Avalia��o da escola que fez o ensino m�dio quanto a
dedica��o dos professores para preparar aulas e
atender aos alunos
"B" indica regular a bom
"C" indica bom ou excelente
*/
gen e_profs_dedic_reg=.
replace e_profs_dedic_reg=1 if Q88=="B" | Q88=="C"
replace e_profs_dedic_reg=0 if Q88=="A"
/*
Q90: Avalia��o da escola que fez o ensino m�dio quanto a
biblioteca da escola
"B" indica regular a bom
"C" indica bom ou excelente
*/
gen e_biblioteca_reg=.
replace e_biblioteca_reg=1 if Q90=="B" | Q90=="C"
replace e_biblioteca_reg=0 if Q90=="A"
/*
Q92: Avalia��o da escola que fez o ensino m�dio quanto as
condi��es dos laborat�rios
"B" indica regular a bom
"C" indica bom ou excelente
*/
gen e_lab_reg=.
replace e_lab_reg=1 if Q92=="B" | Q92=="C"
replace e_lab_reg=0 if Q92=="A"
/*
Q95: Avalia��o da escola que fez o ensino m�dio quanto o
interesse dos alunos
"B" indica regular a bom
"C" indica bom ou excelente
*/
gen e_interesse_alunos_reg=.
replace e_interesse_alunos_reg=1 if Q95=="B" | Q95=="C"
replace e_interesse_alunos_reg=0 if Q95=="A"
/*
Q99: Avalia��o da escola que fez o ensino m�dio quanto a
dire��o dela
"B" indica regular a bom
"C" indica bom ou excelente
*/
gen e_direcao_reg=.
replace e_direcao_reg=1 if Q99=="B" | Q99=="C"
replace e_direcao_reg=0 if Q99=="A"
/*
Q130: Nota para a forma��o que obteve no ensino
m�dio
"H" "I" "J" "K" indica que nota � igual ou maior que 7*/

gen e_nota_em_7=.
replace e_nota_em_7=1 if Q130=="H" | Q130=="I" | Q130=="J" | Q130=="K"
replace e_nota_em_7=0 if Q130=="A" | Q130=="B" | Q130=="C" | Q130=="D" | Q130=="E" | Q130=="F" | Q130=="G"
/*
Q162: A escola ajudou a tomar minha decis�o sobre
minha profiss�o
"A": ajudou muito*/
gen e_ajuda_esc_profissao_muito=.
replace e_ajuda_esc_profissao_muito=1 if Q179=="A" 
replace e_ajuda_esc_profissao_muito=0 if Q179=="C" | Q179=="B"

*collapse

collapse (sum) concluir_em_ano_enem (mean) codigo_municipio ano_enem enem_nota_objetiva-enem_nota_redacao  e_mora_mais_de_6_pessoas-e_ajuda_esc_profissao_muito, by(mascara)


save "E:\bases_dta\enem\enem2004.dta", replace
