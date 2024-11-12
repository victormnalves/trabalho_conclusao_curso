/*************************Enem 2006********************************/
clear all
set more off
set trace on

*** Importação de dados ***

clear

# delimit ;
infix 

NU_ANO 9-16
IN_CONCLUIU 107-114
double MASC_ESC 123-130
double CODMUNIC_ESC 131-142
str SIGLA 157-158
IN_PRESENCA 240-247
NU_NOTA_OBJETIVA 288-295
NU_NOTA_GLOBAL_REDACAO 337-344
str Q15	360-360
str Q16 361-361
str Q17 362-362
str Q18 363-363
str Q23 368-368
str Q28 373-373
str Q35 380-380
str Q42 387-387
str Q54 399-399
str Q55 400-400
str Q90 435-435
str Q91 436-436
str Q93 438-438
str Q95 440-440
str Q98 443-443
str Q102 447-447
str Q136 481-481
str Q196 541-541

using "\\tsclient\E\\ENEM\microdados_enem2006\Dados\DADOS_ENEM_2006.txt";




# delimit cr

set more off
set trace on
**** Renomear e construir variáveis
/*Ano do Enem*/
rename NU_ANO ano_enem

/*
IN_CONCLUIU: Situação em relação ao ensino médio
"IN_CONCLUIU=1" indica que concluirá em 2004 (ano do ENEM)
*/
gen concluir_em_ano_enem=.
replace concluir_em_ano_enem=1 if IN_CONCLUIU==1
replace concluir_em_ano_enem=0 if IN_CONCLUIU==2 | IN_CONCLUIU==3

* manter só alunos do 3º ano

keep if concluir_em_ano_enem==1
/*Máscara da escola*/
rename MASC_ESC mascara

/*Código do Município da escola em que estudou:*/
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
Nota da redacão
*/
rename NU_NOTA_GLOBAL_REDACAO enem_nota_redacao
/*
Q15:Quantidade de pessoas que moram na casa
"F" indica que mora com mais de 6 pessoas
*/
gen e_mora_mais_de_6_pessoas=.
replace e_mora_mais_de_6_pessoas=1 if Q15=="F"
replace e_mora_mais_de_6_pessoas=0 if Q15=="A" | Q15=="B" | Q15=="C" |Q15=="D" | Q15=="E" | Q15=="G"
/*
Q16: Quantos filhos tem
"E" indica que não tem filho
*/
gen e_tem_filho=.
replace e_tem_filho=1 if Q16=="A" | Q16=="B" | Q16=="C" | Q16=="D"
replace e_tem_filho=0 if Q16=="E"
/*
Q17: Até quando o pai estudou
"G" e "H" indica que pai estudou completou faculdade ou superior
*/
gen e_escol_sup_pai=.
replace e_escol_sup_pai=1 if Q17=="G" | Q17=="H"
replace e_escol_sup_pai=0 if Q17=="A" | Q17=="B" | Q17=="C" | Q17=="D" | Q17=="E" | Q17=="F"
/*
Q18: Até quando a mãe estudou
"G" e "H" indica que pai estudou completou faculdade ou superior
*/
gen e_escol_sup_mae=.
replace e_escol_sup_mae=1 if Q18=="G" | Q18=="H"
replace e_escol_sup_mae=0 if Q18=="A" | Q18=="B" | Q18=="C" | Q18=="D" | Q18=="E" | Q18=="F"
/*
Q23:Renda familiar (somando a do respondente e com a das
pessoas que moram com ele)
"D" "E" "F" "G" indica que a renda familiar é igual ou maior que 5 salários mínimos
*/
gen e_renda_familia_5_salarios=.
replace e_renda_familia_5_salarios=1 if Q23=="D" | Q23=="E" | Q23=="F" | Q23=="G"
replace e_renda_familia_5_salarios=0 if Q23=="A" | Q23=="B" | Q23=="C" | Q23=="H"
/*
Q28:Tem Automóvel e quantos
"D" indica que não tinha automóvel
*/
gen e_automovel=.
replace e_automovel=1 if Q28=="A" | Q28=="B" | Q28=="C"
replace e_automovel=0 if Q28=="D"
/*
Q35:Tem casa própria
"A" indica que tem casa própria
*/
gen e_casa_propria=.
replace e_casa_propria=1 if Q35=="A"
replace e_casa_propria=0 if Q35=="B"
/*
Q42:Trabalha, ou já trabalhou, ganhando algum salário ou
rendimento
"A" ou "C" indica que trabalhou ou já procurou trabalho
*/
gen e_trabalhou_ou_procurou=.
replace e_trabalhou_ou_procurou=1 if Q42=="A" | Q42=="C"
replace e_trabalhou_ou_procurou=0 if Q42=="B" 
/*
Q54:Os conhecimentos no ensino médio foram bem
desenvolvidos, com aulas práticas, laboratórios, etc
"A" indica que conhecimentos foram bem desenolvidos com laboratórios
*/
gen e_conhecimento_lab=.
replace e_conhecimento_lab=1 if Q54=="A"
replace e_conhecimento_lab=0 if Q54=="B"
/*
Q55:Os conhecimentos no ensino médio proporcionaram
cultura e conhecimento
"A" indica que o conhecimentos no em proporcionaram cultura e conhecimento
*/
gen e_cultura_conhec=.
replace e_cultura_conhec=1 if Q55=="A"
replace e_cultura_conhec=0 if Q55=="B"
/*
Q90:Avaliação da escola que fez o ensino médio quanto o
conhecimento que os(as) professores(as) têm das
matérias e a maneira de transmiti-lo
"B" indica regular a bom
"C" indica bom ou excelente
*/
gen e_profs_conhec_reg=.
replace e_profs_conhec_reg=1 if Q90=="B" | Q90=="C"
replace e_profs_conhec_reg=0 if Q90=="A"
/*
Q91:
Avaliação da escola que fez o ensino médio quanto a
dedicação dos professores para preparar aulas e
atender aos alunos
"B" indica regular a bom
"C" indica bom ou excelente
*/
gen e_profs_dedic_reg=.
replace e_profs_dedic_reg=1 if Q91=="B" | Q91=="C"
replace e_profs_dedic_reg=0 if Q91=="A"
/*
Q93: Avaliação da escola que fez o ensino médio quanto a
biblioteca da escola
"B" indica regular a bom
"C" indica bom ou excelente
*/
gen e_biblioteca_reg=.
replace e_biblioteca_reg=1 if Q93=="B" | Q93=="C"
replace e_biblioteca_reg=0 if Q93=="A"
/*
Q95: Avaliação da escola que fez o ensino médio quanto as
condições dos laboratórios
"B" indica regular a bom
"C" indica bom ou excelente
*/
gen e_lab_reg=.
replace e_lab_reg=1 if Q95=="B" | Q95=="C"
replace e_lab_reg=0 if Q95=="A"
/*
Q98: Avaliação da escola que fez o ensino médio quanto o
interesse dos alunos
"B" indica regular a bom
"C" indica bom ou excelente
*/
gen e_interesse_alunos_reg=.
replace e_interesse_alunos_reg=1 if Q98=="B" | Q98=="C"
replace e_interesse_alunos_reg=0 if Q98=="A"
/*
Q102: Avaliação da escola que fez o ensino médio quanto a
direção dela
"B" indica regular a bom
"C" indica bom ou excelente
*/
gen e_direcao_reg=.
replace e_direcao_reg=1 if Q102=="B" | Q102=="C"
replace e_direcao_reg=0 if Q102=="A"
/*
Q136: Nota para a formação que obteve no ensino
médio
"H" "I" "J" "K" indica que nota é igual ou maior que 7*/

gen e_nota_em_7=.
replace e_nota_em_7=1 if Q136=="H" | Q136=="I" | Q136=="J" | Q136=="K"
replace e_nota_em_7=0 if Q136=="A" | Q136=="B" | Q136=="C" | Q136=="D" | Q136=="E" | Q136=="F" | Q136=="G"
/*
Q162: A escola ajudou a tomar minha decisão sobre
minha profissão
"A": ajudou muito*/
gen e_ajuda_esc_profissao_muito=.
replace e_ajuda_esc_profissao_muito=1 if Q196=="A" 
replace e_ajuda_esc_profissao_muito=0 if Q196=="C" | Q196=="B"

*collapse

collapse (sum) concluir_em_ano_enem (mean) codigo_municipio ano_enem enem_nota_objetiva-enem_nota_redacao  e_mora_mais_de_6_pessoas-e_ajuda_esc_profissao_muito, by(mascara)


save "\\tsclient\E\\bases_dta\enem\enem2006_14.dta", replace

