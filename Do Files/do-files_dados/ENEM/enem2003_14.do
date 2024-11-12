/*************************Enem 2003********************************/

set more off
set trace on 

clear all

#delimit ;
infix

NU_ANO 9-16
IN_CONCLUIU 107-114
double MASC_ESC 115-122
double CODMUNIC_ESC 123-134
str SIGLA 149-150
IN_PRESENCA 232-239
NU_NOTA_OBJETIVA 280-287
NU_NOTA_GLOBAL_REDACAO 329-336
str Q14	351-351
str Q15 352-352
str Q16 353-353
str Q17 354-354
str Q22 359-359
str Q27 364-364
str Q34 371-371
str Q40 377-377
str Q52 389-389
str Q53 390-390
str Q87 424-424
str Q88 425-425
str Q90 427-427
str Q92 429-429
str Q95 432-432
str Q99 436-436
str Q130 467-467
str Q162 499-499

using "\\tsclient\E\ENEM\microdados_enem2003\DADOS\DADOS_ENEM_2003.txt";
# delimit cr


*renomeando as variáveis

rename NU_ANO ano_enem

*variável que indica se conclui ensino médio no ano do enem
gen concluir_em_ano_enem=.
replace concluir_em_ano_enem=1 if IN_CONCLUIU==1
replace concluir_em_ano_enem=0 if IN_CONCLUIU==2 | IN_CONCLUIU==3 

*manter só alunos do 3º ano
keep if concluir_em_ano_enem == 1

/*Máscara da escola*/
rename MASC_ESC mascara

/*Código do Município da escola em que estudou:*/
rename CODMUNIC_ESC codigo_municipio

/*Sigla da UF da escola*/
rename SIGLA sigla

/*IN_PRESENCA indica presença na prova objetiva*/
gen presentes_enem=.
replace presentes_enem=1 if IN_PRESENCA==1
replace presentes_enem=0 if IN_PRESENCA==0

/*Nota da prova objetiva*/
rename NU_NOTA_OBJETIVA enem_nota_objetiva

/*Nota da redacão*/
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
"E" indica que não tem filho
*/
gen e_tem_filho=.
replace e_tem_filho=1 if Q15=="A" | Q15=="B" | Q15=="C" | Q15=="D"
replace e_tem_filho=0 if Q15=="E"

/*
Q16: Até quando o pai estudou
"G" e "H" indica que pai estudou completou faculdade ou superior
*/
gen e_escol_sup_pai=.
replace e_escol_sup_pai=1 if Q16=="G" | Q16=="H"
replace e_escol_sup_pai=0 if Q16=="A" | Q16=="B" | Q16=="C" | Q16=="D" | Q16=="E" | Q16=="F"
/*
Q17: Até quando a mãe estudou
"G" e "H" indica que pai estudou completou faculdade ou superior
*/
gen e_escol_sup_mae=.
replace e_escol_sup_mae=1 if Q17=="G" | Q17=="H"
replace e_escol_sup_mae=0 if Q17=="A" | Q17=="B" | Q17=="C" | Q17=="D" | Q16=="E" | Q16=="F"
/*
Q22:Renda familiar (somando a do respondente e com a das
pessoas que moram com ele)
"D" "E" "F" "G" indica que a renda familiar é igual ou maior que 5 salários mínimos
*/
gen e_renda_familia_5_salarios=.
replace e_renda_familia_5_salarios=1 if Q22=="D" | Q22=="E" | Q22=="F" | Q22=="G"
replace e_renda_familia_5_salarios=0 if Q22=="A" | Q22=="B" | Q22=="C" | Q22=="H"


/*
Q27:Tem Automóvel e quantos
"D" indica que não tinha automóvel
*/
gen e_automovel=.
replace e_automovel=1 if Q27=="A" | Q27=="B" | Q27=="C"
replace e_automovel=0 if Q27=="D"


/*
Q34:Tem casa própria
"A" indica que tem casa própria
*/
gen e_casa_propria=.
replace e_casa_propria=1 if Q34=="A"
replace e_casa_propria=0 if Q34=="B"

/*
Q40:Trabalha, ou já trabalhou, ganhando algum salário ou
rendimento
"A" ou "C" indica que trabalhou ou já procurou trabalho
*/
gen e_trabalhou_ou_procurou=.
replace e_trabalhou_ou_procurou=1 if Q40=="A" | Q40=="C"
replace e_trabalhou_ou_procurou=0 if Q40=="B" 
/*
Q52:Os conhecimentos no ensino médio foram bem
desenvolvidos, com aulas práticas, laboratórios, etc
"A" indica que conhecimentos foram bem desenolvidos com laboratórios
*/
gen e_conhecimento_lab=.
replace e_conhecimento_lab=1 if Q52=="A"
replace e_conhecimento_lab=0 if Q52=="B"

/*
Q53:Os conhecimentos no ensino médio proporcionaram
cultura e conhecimento
"A" indica que o conhecimentos no em proporcionaram cultura e conhecimento
*/
gen e_cultura_conhec=.
replace e_cultura_conhec=1 if Q53=="A"
replace e_cultura_conhec=0 if Q53=="B"

/*
Q87:Avaliação da escola que fez o ensino médio quanto o
conhecimento que os(as) professores(as) têm das
matérias e a maneira de transmiti-lo
"B" indica regular a bom
"C" indica bom ou excelente
*/
gen e_profs_conhec_reg=.
replace e_profs_conhec_reg=1 if Q87=="B" | Q87=="C"
replace e_profs_conhec_reg=0 if Q87=="A"

/*
Q88:
Avaliação da escola que fez o ensino médio quanto a
dedicação dos professores para preparar aulas e
atender aos alunos
"B" indica regular a bom
"C" indica bom ou excelente
*/
gen e_profs_dedic_reg=.
replace e_profs_dedic_reg=1 if Q88=="B" | Q88=="C"
replace e_profs_dedic_reg=0 if Q88=="A"

/*
Q90: Avaliação da escola que fez o ensino médio quanto a
biblioteca da escola
"B" indica regular a bom
"C" indica bom ou excelente
*/
gen e_biblioteca_reg=.
replace e_biblioteca_reg=1 if Q90=="B" | Q90=="C"
replace e_biblioteca_reg=0 if Q90=="A"

/*
Q92: Avaliação da escola que fez o ensino médio quanto as
condições dos laboratórios
"B" indica regular a bom
"C" indica bom ou excelente
*/
gen e_lab_reg=.
replace e_lab_reg=1 if Q92=="B" | Q92=="C"
replace e_lab_reg=0 if Q92=="A"

/*
Q95: Avaliação da escola que fez o ensino médio quanto o
interesse dos alunos
"B" indica regular a bom
"C" indica bom ou excelente
*/
gen e_interesse_alunos_reg=.
replace e_interesse_alunos_reg=1 if Q95=="B" | Q95=="C"
replace e_interesse_alunos_reg=0 if Q95=="A"

/*
Q99: Avaliação da escola que fez o ensino médio quanto a
direção dela
"B" indica regular a bom
"C" indica bom ou excelente
*/
gen e_direcao_reg=.
replace e_direcao_reg=1 if Q99=="B" | Q99=="C"
replace e_direcao_reg=0 if Q99=="A"

/*
Q130: Nota para a formação que obteve no ensino
médio
"H" "I" "J" "K" indica que nota é igual ou maior que 7*/

gen e_nota_em_7=.
replace e_nota_em_7=1 if Q130=="H" | Q130=="I" | Q130=="J" | Q130=="K"
replace e_nota_em_7=0 if Q130=="A" | Q130=="B" | Q130=="C" | Q130=="D" | Q130=="E" | Q130=="F" | Q130=="G"

/*
Q162: A escola ajudou a tomar minha decisão sobre
minha profissão
"A": ajudou muito*/
gen e_ajuda_esc_profissao_muito=.
replace e_ajuda_esc_profissao_muito=1 if Q162=="A" 
replace e_ajuda_esc_profissao_muito=0 if Q162=="C" | Q162=="B"

*collapse

collapse (sum) concluir_em_ano_enem (mean) codigo_municipio ano_enem enem_nota_objetiva-enem_nota_redacao  e_mora_mais_de_6_pessoas-e_ajuda_esc_profissao_muito, by(mascara)


save "\\tsclient\E\\bases_dta\enem\enem2003_14.dta", replace
