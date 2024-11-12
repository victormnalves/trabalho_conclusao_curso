/***************************CENSO ESCOLAR 2009********************************/

/*objetivo final: replicar os resultados obtidos anteriormente*/

/*
objetivo do do-file:
a. traduzir txt para dta
b. renomear e gerar variáveis, dropar variaveis não usadas

dados de escola
dados de turma 
dados de matrícula
dados de docentes

estados
CE, ES, GO, PE, RJ, SP

extrair dados de turma matrícula e docentes para EFII, EM, e EM profissionalizante

*/
clear all
global user "`:environment USERPROFILE'"
*global dropbox "$user/Dropbox"
global dropboxA "$user/dropbox gmail/Dropbox"
global onedrive "$user/OneDrive"
set more off
set trace on


/*-----------------------------Dados de Escola----------------------------------*/

/*importação*/
/*
# delimit ;
infix 

double ANO_CENSO 1-5 
double PK_COD_ENTIDADE 6-14
NO_ENTIDADE
str DESC_SITUACAO_FUNCIONAMENTO 20-34 
FK_COD_ESTADO 75-77
str SIGLA 78-79
double FK_COD_MUNICIPIO 80-87
str ID_DEPENDENCIA_ADM 88-88 
str ID_LOCALIZACAO 89-89
str ID_LOCAL_FUNC_PREDIO_ESCOLAR 99-99
str ID_AGUA_REDE_PUBLICA 109-109 
str ID_ENERGIA_REDE_PUBLICA 114-114 
str ID_ESGOTO_REDE_PUBLICA 118-118 
str ID_LIXO_COLETA_PERIODICA 121-121
str ID_SALA_DIRETORIA 127-127
str ID_SALA_PROFESSOR 128-128
str ID_LABORATORIO_INFORMATICA 129-129 
str ID_LABORATORIO_CIENCIAS 130-130
str ID_QUADRA_ESPORTES 132-132
str ID_BIBLIOTECA 134-134 
double NUM_SALAS_EXISTENTES 144-148
double NUM_SALAS_UTILIZADAS 149-153 
str ID_INTERNET 177-177
str ID_MOD_ENS_REGULAR 190-190
str ID_REG_MEDIO_MEDIO 195-195
str ID_REG_MEDIO_INTEGRADO 196-196
str ID_REG_MEDIO_NORMAL 197-197
str ID_REG_MEDIO_PROF 198-198

using "D:\2009\DADOS\TS_ESCOLA.txt";

# delimit cr
*/


* por alguma razão, os dados do censo, antes de 2015, eram dados em txt. depois, em csv. ainda, o inep atualizou todas as bases até 2007 para csv
* então, necessário mudar os infix de txt para import delimited de csv
* o delimitador é o pipe
import delimited "D:\2009\DADOS\ESCOLAS.CSV", delimiter("|") case(upper)
# delimit ;
keep
ANO_CENSO
PK_COD_ENTIDADE
NO_ENTIDADE
DESC_SITUACAO_FUNCIONAMENTO
FK_COD_ESTADO
SIGLA
FK_COD_MUNICIPIO
ID_DEPENDENCIA_ADM
ID_LOCALIZACAO
ID_LOCAL_FUNC_PREDIO_ESCOLAR
ID_AGUA_REDE_PUBLICA
ID_ENERGIA_REDE_PUBLICA
ID_ESGOTO_REDE_PUBLICA
ID_LIXO_COLETA_PERIODICA
ID_SALA_DIRETORIA
ID_SALA_PROFESSOR
ID_LABORATORIO_INFORMATICA
ID_LABORATORIO_CIENCIAS
ID_QUADRA_ESPORTES
ID_BIBLIOTECA
ID_SALA_LEITURA
NUM_SALAS_EXISTENTES
NUM_SALAS_UTILIZADAS
ID_INTERNET
ID_MOD_ENS_REGULAR
ID_REG_MEDIO_MEDIO
ID_REG_MEDIO_INTEGRADO
ID_REG_MEDIO_NORMAL
ID_REG_MEDIO_PROF

;
#delimit cr

/*criando e renomeando as variáveis relevantes*/
 
*variável ano do censo
rename ANO_CENSO ano_censo

*variável codigo de escola
rename PK_COD_ENTIDADE codigo_escola

*variavel nome da escola
rename NO_ENTIDADE nome_escola

*variável código de estado
rename FK_COD_ESTADO codigo_uf

*variável sigla de estado/uf
rename SIGLA sigla

*variável município
rename FK_COD_MUNICIPIO codigo_municipio_novo

*variável dependência administrativa
rename ID_DEPENDENCIA_ADM dependencia_administrativa

*variável que indica se escola é rural ou não
generate rural=.
replace rural=1 if ID_LOCALIZACAO==2
replace rural=0 if ID_LOCALIZACAO==1
drop ID_LOCALIZACAO

*variável que indica condição da escola: 1 se ativo, 0 se paralisada/extinta
generate ativa=.
replace ativa=1 if DESC_SITUACAO_FUNCIONAMENTO==1
replace ativa=0 if DESC_SITUACAO_FUNCIONAMENTO==2 | DESC_SITUACAO_FUNCIONAMENTO==3 | DESC_SITUACAO_FUNCIONAMENTO==4
drop DESC_SITUACAO_FUNCIONAMENTO

*variável que indica se local de funcionamento da escola é um prédio
generate predio=.
replace predio=1 if ID_LOCAL_FUNC_PREDIO_ESCOLAR==1
replace predio=0 if ID_LOCAL_FUNC_PREDIO_ESCOLAR==0
drop ID_LOCAL_FUNC_PREDIO_ESCOLAR

*variável que indica se escola é abastecida por água da rede pública
generate agua=.
replace agua=1 if ID_AGUA_REDE_PUBLICA==1
replace agua=0 if ID_AGUA_REDE_PUBLICA==0
drop ID_AGUA_REDE_PUBLICA

*variável que indica se escola é abastecida pela rede pública de energia
generate eletricidade=.
replace eletricidade=1 if ID_ENERGIA_REDE_PUBLICA==1
replace eletricidade=0 if ID_ENERGIA_REDE_PUBLICA==0
drop ID_ENERGIA_REDE_PUBLICA

*variável que indica se escola tem acesso ao esgoto
generate esgoto=.
replace esgoto=1 if ID_ESGOTO_REDE_PUBLICA==1
replace esgoto=0 if ID_ESGOTO_REDE_PUBLICA==0
drop ID_ESGOTO_REDE_PUBLICA

*variável que indica a existência de coleta de lixo periódica
generate lixo_coleta=.
replace lixo_coleta=1 if ID_LIXO_COLETA_PERIODICA==1
replace lixo_coleta=0 if ID_LIXO_COLETA_PERIODICA==0
drop ID_LIXO_COLETA_PERIODICA

*variável que indica se existe a dependência diretoria
generate diretoria=.
replace diretoria=1 if ID_SALA_DIRETORIA==1
replace diretoria=0 if ID_SALA_DIRETORIA==0
drop ID_SALA_DIRETORIA

*variavel que indica se existe a dependência sala de professores
generate sala_professores=.
replace sala_professores=1 if ID_SALA_PROFESSOR==1
replace sala_professores=0 if ID_SALA_PROFESSOR==0
drop ID_SALA_PROFESSOR

*variável que indica se existe a dependência laboratótio de informática
generate lab_info=.
replace lab_info=1 if ID_LABORATORIO_INFORMATICA==1
replace lab_info=0 if ID_LABORATORIO_INFORMATICA==0
drop ID_LABORATORIO_INFORMATICA

*variável que indica se existe a dependência laboratório de ciências
generate lab_ciencias=.
replace lab_ciencias=1 if ID_LABORATORIO_CIENCIAS==1
replace lab_ciencias=0 if ID_LABORATORIO_CIENCIAS==0
drop ID_LABORATORIO_CIENCIAS

*variável que indica se existe dependência quadra de esportes
generate quadra_esportes=.
replace quadra_esportes=1 if ID_QUADRA_ESPORTES==1
replace quadra_esportes=0 if ID_QUADRA_ESPORTES==0
drop ID_QUADRA_ESPORTES

*variável que indica se existe a dependência biblioteca
generate biblioteca=.
replace biblioteca=1 if ID_BIBLIOTECA==1
replace biblioteca=0 if ID_BIBLIOTECA==0
drop ID_BIBLIOTECA

*variável que indica se existe a dependência sala de leitura
generate sala_leitura=.
replace sala_leitura=1 if ID_SALA_LEITURA==1
replace sala_leitura=0 if ID_SALA_LEITURA==0
drop ID_SALA_LEITURA

*variável de número de salas existentes
rename NUM_SALAS_EXISTENTES n_salas_exis

*variavel de número de salas utilizadas
rename NUM_SALAS_UTILIZADAS n_salas_utilizadas

*variável que indica a existência de internet
generate internet=.
replace internet=1 if ID_INTERNET==1
replace internet=0 if ID_INTERNET==0
drop ID_INTERNET

*variável que indica que a modalidade é Ensino Regular
gen regular=.
replace regular=1 if ID_MOD_ENS_REGULAR==1
replace regular=0 if ID_MOD_ENS_REGULAR==0
drop ID_MOD_ENS_REGULAR













*variável que indica se a escola possui ensino médio
gen em=.
replace em=1 if ID_REG_MEDIO_MEDIO==1
replace em=0 if ID_REG_MEDIO_MEDIO==0
drop ID_REG_MEDIO_MEDIO

*variável que indica se a escola possui ensino integrado
gen em_integrado=.
replace em_integrado=1 if ID_REG_MEDIO_INTEGRADO==1
replace em_integrado=0 if ID_REG_MEDIO_INTEGRADO==0
drop ID_REG_MEDIO_INTEGRADO

*variável que indica se a escola possui ensino médio normal
gen em_normal=.
replace em_normal=1 if ID_REG_MEDIO_NORMAL==1
replace em_normal=0 if ID_REG_MEDIO_NORMAL==0
drop ID_REG_MEDIO_NORMAL

*variável que indica se a escola possui ensino médio profissional
gen em_prof=.
replace em_prof=1 if ID_REG_MEDIO_PROF==1
replace em_prof=0 if ID_REG_MEDIO_PROF==0
drop ID_REG_MEDIO_PROF


save "D:\Dropbox\bases_dta\censo_escolar\2009\censo_escolar2009_escolas.dta", replace


/*-----------------------------Dados de Turma----------------------------------*/
/*importação*/

clear all
/*
# delimit ;
infix
FK_COD_ETAPA_ENSINO 113-116
double PK_COD_ENTIDADE 202-210
FK_COD_ESTADO 211-213


using "D:\2009\DADOS\TS_MATRICULA_PE.txt";

# delimit cr
*/
* por alguma razão, os dados do censo, antes de 2015, eram dados em txt. depois, em csv. ainda, o inep atualizou todas as bases até 2007 para csv
* então, necessário mudar os infix de txt para import delimited de csv
*o delimitador é o pipe
import delimited "D:\2009\DADOS\TURMAS.CSV", delimiter("|") case(upper)
# delimit ;
keep
FK_COD_MOD_ENSINO
FK_COD_ETAPA_ENSINO
PK_COD_ENTIDADE
FK_COD_ESTADO
SIGLA
;
# delimit cr
save "D:\Dropbox\bases_dta\censo_escolar\2009\censo_escolar2009_turmas.dta", replace

/*criando e renomeando as variáveis relevantes*/
/*gerando para cada estado*/
/*PE, GO, CE, RJ, SP, ES*/
foreach x in "PE" "GO" "CE" "RJ" "SP" "ES" {
clear all
use "D:\Dropbox\bases_dta\censo_escolar\2009\censo_escolar2009_turmas.dta", clear

*variável código de escola
rename PK_COD_ENTIDADE codigo_escola

*variável código de uf
rename FK_COD_ESTADO codigo_uf

keep if SIGLA=="`x'"

*variavel sigla do estado/uf
rename SIGLA sigla

*variáveis número de turmas no ensino fundamental de 8 anos

gen n_turmas_fund_5_8anos=1 if FK_COD_ETAPA_ENSINO==8
gen n_turmas_fund_6_8anos=1 if FK_COD_ETAPA_ENSINO==9
gen n_turmas_fund_7_8anos=1 if FK_COD_ETAPA_ENSINO==10
gen n_turmas_fund_8_8anos=1 if FK_COD_ETAPA_ENSINO==11

*variáveis número de turmas no ensino fundamental de 9 anos

gen n_turmas_fund_6_9anos=1 if FK_COD_ETAPA_ENSINO==19
gen n_turmas_fund_7_9anos=1 if FK_COD_ETAPA_ENSINO==20
gen n_turmas_fund_8_9anos=1 if FK_COD_ETAPA_ENSINO==21
gen n_turmas_fund_9_9anos=1 if FK_COD_ETAPA_ENSINO==41

*variável com numero de turmas do 1ª,2ª,3ª

gen n_turmas_em_1=1 if FK_COD_ETAPA_ENSINO==25
gen n_turmas_em_2=1 if FK_COD_ETAPA_ENSINO==26
gen n_turmas_em_3=1 if FK_COD_ETAPA_ENSINO==27

*variaveis numero de turmas ensino medio integrado para 1º,2º,3º e 4º

gen n_turmas_em_inte_1=1 if FK_COD_ETAPA_ENSINO==30
gen n_turmas_em_inte_2=1 if FK_COD_ETAPA_ENSINO==31
gen n_turmas_em_inte_3=1 if FK_COD_ETAPA_ENSINO==32
gen n_turmas_em_inte_4=1 if FK_COD_ETAPA_ENSINO==33
gen n_turmas_em_inte_ns=1 if FK_COD_ETAPA_ENSINO==34

* collapse por escola
compress
# delimit ;

collapse 

(sum) n_turmas_fund_5_8anos - n_turmas_fund_9_9anos
(sum) n_turmas_em_1 n_turmas_em_2 n_turmas_em_3
(sum) n_turmas_em_inte_3 n_turmas_em_inte_4 n_turmas_em_inte_ns
,
by(codigo_escola);
# delimit cr	
save "D:\Dropbox\bases_dta\censo_escolar\2009\censo_escolar2009_turmas_col(`x').dta", replace

}

/*---------------------------Dados de Matrícula--------------------------------*/
foreach x in "NORDESTE" "SUDESTE" "CO"{
clear all
/*tradução*/
/*
# delimit ;
infix

NUM_IDADE 44-48
str TP_SEXO 49-49
str TP_COR_RACA 50-50
str ID_ZONA_RESIDENCIAL 82-82 
ID_N_T_E_P 84-84
FK_COD_MOD_ENSINO 100-102
FK_COD_ETAPA_ENSINO 103-106
double PK_COD_ENTIDADE 132-140
FK_COD_ESTADO_ESCOLA 141-143
str SIGLA_ESCOLA 144-145
*using "E:\Bases de Dados\Educação\Censo Escolar\Censo Escolar 2009\DADOS\TS_MATRICULA_PE.txt";
using "D:\2009\DADOS\TS_MATRICULA_PE.txt";
# delimit cr
*/

* por alguma razão, os dados do censo, antes de 2015, eram dados em txt. depois, em csv. ainda, o inep atualizou todas as bases até 2007 para csv
* então, necessário mudar os infix de txt para import delimited de csv
*o delimitador é o pipe
import delimited "D:\2009\DADOS\MATRICULA_`x'.CSV", delimiter("|") case(upper)
# delimit ;
keep
NUM_IDADE
TP_SEXO
TP_COR_RACA
ID_ZONA_RESIDENCIAL
ID_N_T_E_P
FK_COD_MOD_ENSINO
FK_COD_ETAPA_ENSINO
PK_COD_ENTIDADE
SIGLA_ESCOLA
FK_COD_ESTADO_ESCOLA
;

# delimit cr
*variável sigla da UF da escola
rename SIGLA_ESCOLA sigla_escola

*variável código de escola
rename PK_COD_ENTIDADE codigo_escola

*variável códidgo da uf
rename FK_COD_ESTADO_ESCOLA codigo_uf

destring ID_N_T_E_P, replace

save "D:\Dropbox\bases_dta\censo_escolar\2009\censo_escolar2009_matriculas_`x'.dta", replace
}
use "D:\Dropbox\bases_dta\censo_escolar\2009\censo_escolar2009_matriculas_NORDESTE.dta", clear
append using "D:\Dropbox\bases_dta\censo_escolar\2009\censo_escolar2009_matriculas_SUDESTE.dta"
append using "D:\Dropbox\bases_dta\censo_escolar\2009\censo_escolar2009_matriculas_CO.dta"

save "D:\Dropbox\bases_dta\censo_escolar\2009\censo_escolar2009_matriculas.dta", replace

foreach x in "PE" "CE" "RJ" "SP" "ES" "GO" {
set more off
use "D:\Dropbox\bases_dta\censo_escolar\2009\censo_escolar2009_matriculas.dta", clear

keep if sigla_escola=="`x'"
/*
variáveis por modalidade, por série : 
número de alunos
número de mulheres
número de brancos
número de alunos que pegam transporte público
média de idade
proporção de mulheres
proporção de brancos
proporção de alunos que usam transporte público
*/
/*gerando variáveis dummy para quando dar collapse, termos somas, proporções ou médias*/
/*gerando variáveis para ensino fundamental*/

*variáveis para soma
*número de alunos por série
gen n_alunos_fund_5_8anos=1 if FK_COD_ETAPA_ENSINO==8
gen n_alunos_fund_6_8anos=1 if FK_COD_ETAPA_ENSINO==9
gen n_alunos_fund_7_8anos=1 if FK_COD_ETAPA_ENSINO==10
gen n_alunos_fund_8_8anos=1 if FK_COD_ETAPA_ENSINO==11
gen n_alunos_fund_6_9anos=1 if FK_COD_ETAPA_ENSINO==19
gen n_alunos_fund_7_9anos=1 if FK_COD_ETAPA_ENSINO==20
gen n_alunos_fund_8_9anos=1 if FK_COD_ETAPA_ENSINO==21
gen n_alunos_fund_9_9anos=1 if FK_COD_ETAPA_ENSINO==41

*número de mulheres por série
gen n_mulheres_fund_5_8anos=1 if FK_COD_ETAPA_ENSINO==8 & TP_SEXO=="F"
gen n_mulheres_fund_6_8anos=1 if FK_COD_ETAPA_ENSINO==9 & TP_SEXO=="F"
gen n_mulheres_fund_7_8anos=1 if FK_COD_ETAPA_ENSINO==10 & TP_SEXO=="F"
gen n_mulheres_fund_8_8anos=1 if FK_COD_ETAPA_ENSINO==11 & TP_SEXO=="F"
gen n_mulheres_fund_6_9anos=1 if FK_COD_ETAPA_ENSINO==19 & TP_SEXO=="F"
gen n_mulheres_fund_7_9anos=1 if FK_COD_ETAPA_ENSINO==20 & TP_SEXO=="F"
gen n_mulheres_fund_8_9anos=1 if FK_COD_ETAPA_ENSINO==21 & TP_SEXO=="F"
gen n_mulheres_fund_9_9anos=1 if FK_COD_ETAPA_ENSINO==41 & TP_SEXO=="F"

*número de brancos por série
gen n_brancos_fund_5_8anos=1 if FK_COD_ETAPA_ENSINO==8 & TP_COR_RACA==1
gen n_brancos_fund_6_8anos=1 if FK_COD_ETAPA_ENSINO==9 & TP_COR_RACA==1
gen n_brancos_fund_7_8anos=1 if FK_COD_ETAPA_ENSINO==10 & TP_COR_RACA==1
gen n_brancos_fund_8_8anos=1 if FK_COD_ETAPA_ENSINO==11 & TP_COR_RACA==1
gen n_brancos_fund_6_9anos=1 if FK_COD_ETAPA_ENSINO==19 & TP_COR_RACA==1
gen n_brancos_fund_7_9anos=1 if FK_COD_ETAPA_ENSINO==20 & TP_COR_RACA==1
gen n_brancos_fund_8_9anos=1 if FK_COD_ETAPA_ENSINO==21 & TP_COR_RACA==1
gen n_brancos_fund_9_9anos=1 if FK_COD_ETAPA_ENSINO==41 & TP_COR_RACA==1

*número de alunos que usam o transporte público por série
gen n_transp_pub_fund_5_8anos=1 if FK_COD_ETAPA_ENSINO==8 & ID_N_T_E_P==1
gen n_transp_pub_fund_6_8anos=1 if FK_COD_ETAPA_ENSINO==9 & ID_N_T_E_P==1
gen n_transp_pub_fund_7_8anos=1 if FK_COD_ETAPA_ENSINO==10 & ID_N_T_E_P==1
gen n_transp_pub_fund_8_8anos=1 if FK_COD_ETAPA_ENSINO==11 & ID_N_T_E_P==1
gen n_transp_pub_fund_6_9anos=1 if FK_COD_ETAPA_ENSINO==19 & ID_N_T_E_P==1
gen n_transp_pub_fund_7_9anos=1 if FK_COD_ETAPA_ENSINO==20 & ID_N_T_E_P==1
gen n_transp_pub_fund_8_9anos=1 if FK_COD_ETAPA_ENSINO==21 & ID_N_T_E_P==1
gen n_transp_pub_fund_9_9anos=1 if FK_COD_ETAPA_ENSINO==41 & ID_N_T_E_P==1

*variáveis para média
gen m_idade_fund_5_8anos=NUM_IDADE if FK_COD_ETAPA_ENSINO==8
gen m_idade_fund_6_8anos=NUM_IDADE if FK_COD_ETAPA_ENSINO==9
gen m_idade_fund_7_8anos=NUM_IDADE if FK_COD_ETAPA_ENSINO==10
gen m_idade_fund_8_8anos=NUM_IDADE if FK_COD_ETAPA_ENSINO==11
gen m_idade_fund_6_9anos=NUM_IDADE if FK_COD_ETAPA_ENSINO==19
gen m_idade_fund_7_9anos=NUM_IDADE if FK_COD_ETAPA_ENSINO==20
gen m_idade_fund_8_9anos=NUM_IDADE if FK_COD_ETAPA_ENSINO==21
gen m_idade_fund_9_9anos=NUM_IDADE if FK_COD_ETAPA_ENSINO==41

*variáveis para proporção

*proporção de mulheres por série
gen p_mulheres_fund_5_8anos=.
replace p_mulheres_fund_5_8anos=1 if FK_COD_ETAPA_ENSINO==8 & TP_SEXO=="F"
replace p_mulheres_fund_5_8anos=0 if FK_COD_ETAPA_ENSINO==8 & TP_SEXO=="M"

gen p_mulheres_fund_6_8anos=.
replace p_mulheres_fund_6_8anos=1 if FK_COD_ETAPA_ENSINO==9 & TP_SEXO=="F"
replace p_mulheres_fund_6_8anos=0 if FK_COD_ETAPA_ENSINO==9 & TP_SEXO=="M"

gen p_mulheres_fund_7_8anos=.
replace p_mulheres_fund_7_8anos=1 if FK_COD_ETAPA_ENSINO==10 & TP_SEXO=="F"
replace p_mulheres_fund_7_8anos=0 if FK_COD_ETAPA_ENSINO==10 & TP_SEXO=="M"

gen p_mulheres_fund_8_8anos=.
replace p_mulheres_fund_8_8anos=1 if FK_COD_ETAPA_ENSINO==11 & TP_SEXO=="F"
replace p_mulheres_fund_8_8anos=0 if FK_COD_ETAPA_ENSINO==11 & TP_SEXO=="M"

gen p_mulheres_fund_6_9anos=.
replace p_mulheres_fund_6_9anos=1 if FK_COD_ETAPA_ENSINO==19 & TP_SEXO=="F"
replace p_mulheres_fund_6_9anos=0 if FK_COD_ETAPA_ENSINO==19 & TP_SEXO=="M"

gen p_mulheres_fund_7_9anos=.
replace p_mulheres_fund_7_9anos=1 if FK_COD_ETAPA_ENSINO==20 & TP_SEXO=="F"
replace p_mulheres_fund_7_9anos=0 if FK_COD_ETAPA_ENSINO==20 & TP_SEXO=="M"

gen p_mulheres_fund_8_9anos=.
replace p_mulheres_fund_8_9anos=1 if FK_COD_ETAPA_ENSINO==21 & TP_SEXO=="F"
replace p_mulheres_fund_8_9anos=0 if FK_COD_ETAPA_ENSINO==21 & TP_SEXO=="M"

gen p_mulheres_fund_9_9anos=.
replace p_mulheres_fund_9_9anos=1 if FK_COD_ETAPA_ENSINO==41 & TP_SEXO=="F"
replace p_mulheres_fund_9_9anos=0 if FK_COD_ETAPA_ENSINO==41 & TP_SEXO=="M"

*proporção de brancos por série
gen p_brancos_fund_5_8anos=.
replace p_brancos_fund_5_8anos=1 if FK_COD_ETAPA_ENSINO==8 & TP_COR_RACA==1
replace p_brancos_fund_5_8anos=0 if FK_COD_ETAPA_ENSINO==8 & (TP_COR_RACA==2 | TP_COR_RACA==3 | TP_COR_RACA==4 | TP_COR_RACA==5)

gen p_brancos_fund_6_8anos=.
replace p_brancos_fund_6_8anos=1 if FK_COD_ETAPA_ENSINO==9 & TP_COR_RACA==1
replace p_brancos_fund_6_8anos=0 if FK_COD_ETAPA_ENSINO==9 & (TP_COR_RACA==2 | TP_COR_RACA==3 | TP_COR_RACA==4 | TP_COR_RACA==5)

gen p_brancos_fund_7_8anos=.
replace p_brancos_fund_7_8anos=1 if FK_COD_ETAPA_ENSINO==10 & TP_COR_RACA==1
replace p_brancos_fund_7_8anos=0 if FK_COD_ETAPA_ENSINO==10 & (TP_COR_RACA==2 | TP_COR_RACA==3 | TP_COR_RACA==4 | TP_COR_RACA==5)

gen p_brancos_fund_8_8anos=.
replace p_brancos_fund_8_8anos=1 if FK_COD_ETAPA_ENSINO==11 & TP_COR_RACA==1
replace p_brancos_fund_8_8anos=0 if FK_COD_ETAPA_ENSINO==11 & (TP_COR_RACA==2 | TP_COR_RACA==3 | TP_COR_RACA==4 | TP_COR_RACA==5)

gen p_brancos_fund_6_9anos=.
replace p_brancos_fund_6_9anos=1 if FK_COD_ETAPA_ENSINO==19 & TP_COR_RACA==1
replace p_brancos_fund_6_9anos=0 if FK_COD_ETAPA_ENSINO==19 & (TP_COR_RACA==2 | TP_COR_RACA==3 | TP_COR_RACA==4 | TP_COR_RACA==5)

gen p_brancos_fund_7_9anos=.
replace p_brancos_fund_7_9anos=1 if FK_COD_ETAPA_ENSINO==20 & TP_COR_RACA==1
replace p_brancos_fund_7_9anos=0 if FK_COD_ETAPA_ENSINO==20 & (TP_COR_RACA==2 | TP_COR_RACA==3 | TP_COR_RACA==4 | TP_COR_RACA==5)

gen p_brancos_fund_8_9anos=.
replace p_brancos_fund_8_9anos=1 if FK_COD_ETAPA_ENSINO==21 & TP_COR_RACA==1
replace p_brancos_fund_8_9anos=0 if FK_COD_ETAPA_ENSINO==21 & (TP_COR_RACA==2 | TP_COR_RACA==3 | TP_COR_RACA==4 | TP_COR_RACA==5)

gen p_brancos_fund_9_9anos=.
replace p_brancos_fund_9_9anos=1 if FK_COD_ETAPA_ENSINO==41 & TP_COR_RACA==1
replace p_brancos_fund_9_9anos=0 if FK_COD_ETAPA_ENSINO==41 & (TP_COR_RACA==2 | TP_COR_RACA==3 | TP_COR_RACA==4 | TP_COR_RACA==5)

*proporção de alunos que usam o transporte público por série
gen p_transp_pub_fund_5_8anos=.
replace p_transp_pub_fund_5_8anos=1 if FK_COD_ETAPA_ENSINO==8 & ID_N_T_E_P==1
replace p_transp_pub_fund_5_8anos=0 if FK_COD_ETAPA_ENSINO==8 & ID_N_T_E_P==0

gen p_transp_pub_fund_6_8anos=.
replace p_transp_pub_fund_6_8anos=1 if FK_COD_ETAPA_ENSINO==9 & ID_N_T_E_P==1
replace p_transp_pub_fund_6_8anos=0 if FK_COD_ETAPA_ENSINO==9 & ID_N_T_E_P==0

gen p_transp_pub_fund_7_8anos=.
replace p_transp_pub_fund_7_8anos=1 if FK_COD_ETAPA_ENSINO==10 & ID_N_T_E_P==1
replace p_transp_pub_fund_7_8anos=0 if FK_COD_ETAPA_ENSINO==10 & ID_N_T_E_P==0

gen p_transp_pub_fund_8_8anos=.
replace p_transp_pub_fund_8_8anos=1 if FK_COD_ETAPA_ENSINO==11 & ID_N_T_E_P==1
replace p_transp_pub_fund_8_8anos=0 if FK_COD_ETAPA_ENSINO==11 & ID_N_T_E_P==0

gen p_transp_pub_fund_6_9anos=.
replace p_transp_pub_fund_6_9anos=1 if FK_COD_ETAPA_ENSINO==19 & ID_N_T_E_P==1
replace p_transp_pub_fund_6_9anos=0 if FK_COD_ETAPA_ENSINO==19 & ID_N_T_E_P==0

gen p_transp_pub_fund_7_9anos=.
replace p_transp_pub_fund_7_9anos=1 if FK_COD_ETAPA_ENSINO==20 & ID_N_T_E_P==1
replace p_transp_pub_fund_7_9anos=0 if FK_COD_ETAPA_ENSINO==20 & ID_N_T_E_P==0

gen p_transp_pub_fund_8_9anos=.
replace p_transp_pub_fund_8_9anos=1 if FK_COD_ETAPA_ENSINO==21 & ID_N_T_E_P==1
replace p_transp_pub_fund_8_9anos=0 if FK_COD_ETAPA_ENSINO==21 & ID_N_T_E_P==0

gen p_transp_pub_fund_9_9anos=.
replace p_transp_pub_fund_9_9anos=1 if FK_COD_ETAPA_ENSINO==41 & ID_N_T_E_P==1
replace p_transp_pub_fund_9_9anos=0 if FK_COD_ETAPA_ENSINO==41 & ID_N_T_E_P==0



/*gerando variáveis para ensino médio*/
*gerar variáveis de número por série

gen n_alunos_em_1=1 if FK_COD_ETAPA_ENSINO==25
gen n_alunos_em_2=1 if FK_COD_ETAPA_ENSINO==26
gen n_alunos_em_3=1 if FK_COD_ETAPA_ENSINO==27

gen n_mulheres_em_1=1 if FK_COD_ETAPA_ENSINO==25 & TP_SEXO=="F"
gen n_mulheres_em_2=1 if FK_COD_ETAPA_ENSINO==26 & TP_SEXO=="F"
gen n_mulheres_em_3=1 if FK_COD_ETAPA_ENSINO==27 & TP_SEXO=="F"

gen n_brancos_em_1=1 if FK_COD_ETAPA_ENSINO==25 & TP_COR_RACA==1
gen n_brancos_em_2=1 if FK_COD_ETAPA_ENSINO==26 & TP_COR_RACA==1
gen n_brancos_em_3=1 if FK_COD_ETAPA_ENSINO==27 & TP_COR_RACA==1

gen n_alu_transporte_publico_em_1=1 if FK_COD_ETAPA_ENSINO==25 & ID_N_T_E_P==1
gen n_alu_transporte_publico_em_2=1 if FK_COD_ETAPA_ENSINO==26 & ID_N_T_E_P==1
gen n_alu_transporte_publico_em_3=1 if FK_COD_ETAPA_ENSINO==27 & ID_N_T_E_P==1

*gerar variáveis para utitlizar na proporção
*variáveis de média de idade por série
gen m_idade_em_1=NUM_IDADE if FK_COD_ETAPA_ENSINO==25
gen m_idade_em_2=NUM_IDADE if FK_COD_ETAPA_ENSINO==26
gen m_idade_em_3=NUM_IDADE if FK_COD_ETAPA_ENSINO==27

*proporção de mulheres por série
*variaveis que indicam se é mulher ou não por série

gen p_mulheres_em_1=.
replace p_mulheres_em_1=1 if FK_COD_ETAPA_ENSINO==25 & TP_SEXO=="F"
replace p_mulheres_em_1=0 if FK_COD_ETAPA_ENSINO==25 & TP_SEXO=="M"

gen p_mulheres_em_2=.
replace p_mulheres_em_2=1 if FK_COD_ETAPA_ENSINO==26 & TP_SEXO=="F"
replace p_mulheres_em_2=0 if FK_COD_ETAPA_ENSINO==26 & TP_SEXO=="M"

gen p_mulheres_em_3=.
replace p_mulheres_em_3=1 if FK_COD_ETAPA_ENSINO==27 & TP_SEXO=="F"
replace p_mulheres_em_3=0 if FK_COD_ETAPA_ENSINO==27 & TP_SEXO=="M"

*proporção de brancos por série
*variáveis que indicam se é branco ou não por série

gen p_brancos_em_1=.
replace p_brancos_em_1=1 if FK_COD_ETAPA_ENSINO==25 & TP_COR_RACA==1
replace p_brancos_em_1=0 if FK_COD_ETAPA_ENSINO==25 & (TP_COR_RACA==2 | TP_COR_RACA==3 | TP_COR_RACA==4 | TP_COR_RACA==5)

gen p_brancos_em_2=.
replace p_brancos_em_2=1 if FK_COD_ETAPA_ENSINO==26 & TP_COR_RACA==1
replace p_brancos_em_2=0 if FK_COD_ETAPA_ENSINO==26 & (TP_COR_RACA==2 | TP_COR_RACA==3 | TP_COR_RACA==4 | TP_COR_RACA==5)

gen p_brancos_em_3=.
replace p_brancos_em_3=1 if FK_COD_ETAPA_ENSINO==27 & TP_COR_RACA==1
replace p_brancos_em_3=0 if FK_COD_ETAPA_ENSINO==27 & (TP_COR_RACA==2 | TP_COR_RACA==3 | TP_COR_RACA==4 | TP_COR_RACA==5)

*proporção de alunos que usam o transporte público por série
*variáveis que indicam se alunos utilizam ou não trasnporte público por série

gen p_alu_transporte_publico_em_1=.
replace p_alu_transporte_publico_em_1=1 if FK_COD_ETAPA_ENSINO==25 & ID_N_T_E_P==1
replace p_alu_transporte_publico_em_1=0 if FK_COD_ETAPA_ENSINO==25 & ID_N_T_E_P==0

gen p_alu_transporte_publico_em_2=.
replace p_alu_transporte_publico_em_2=1 if FK_COD_ETAPA_ENSINO==26 & ID_N_T_E_P==1
replace p_alu_transporte_publico_em_2=0 if FK_COD_ETAPA_ENSINO==26 & ID_N_T_E_P==0

gen p_alu_transporte_publico_em_3=.
replace p_alu_transporte_publico_em_3=1 if FK_COD_ETAPA_ENSINO==27 & ID_N_T_E_P==1
replace p_alu_transporte_publico_em_3=0 if FK_COD_ETAPA_ENSINO==27 & ID_N_T_E_P==0


/*gerando variáveis de ensino médio integrado*/
* note que só escolas profissionais tem ensino não seriado ou 4º ano
* ns --> *ensino integrado não seriado
*variáveis que indicam o número de alunos no em integrado
gen n_alunos_em_inte_1=1 if FK_COD_ETAPA_ENSINO==30
gen n_alunos_em_inte_2=1 if FK_COD_ETAPA_ENSINO==31
gen n_alunos_em_inte_3=1 if FK_COD_ETAPA_ENSINO==32
gen n_alunos_em_inte_4=1 if FK_COD_ETAPA_ENSINO==33
gen n_alunos_em_inte_ns=1 if FK_COD_ETAPA_ENSINO==34


*variáveis que indicam o número de mulheres no em integrado
gen n_mulheres_em_inte_1=1 if FK_COD_ETAPA_ENSINO==30 & TP_SEXO=="F"
gen n_mulheres_em_inte_2=1 if FK_COD_ETAPA_ENSINO==31 & TP_SEXO=="F"
gen n_mulheres_em_inte_3=1 if FK_COD_ETAPA_ENSINO==32 & TP_SEXO=="F"
gen n_mulheres_em_inte_4=1 if FK_COD_ETAPA_ENSINO==33 & TP_SEXO=="F"
gen n_mulheres_em_inte_ns=1 if FK_COD_ETAPA_ENSINO==34 & TP_SEXO=="F"

*variáveis que indicam o número de brancos no em integrado
gen n_brancos_em_inte_1=1 if FK_COD_ETAPA_ENSINO==30 & TP_COR_RACA==1
gen n_brancos_em_inte_2=1 if FK_COD_ETAPA_ENSINO==31 & TP_COR_RACA==1
gen n_brancos_em_inte_3=1 if FK_COD_ETAPA_ENSINO==32 & TP_COR_RACA==1
gen n_brancos_em_inte_4=1 if FK_COD_ETAPA_ENSINO==33 & TP_COR_RACA==1
gen n_brancos_em_inte_ns=1 if FK_COD_ETAPA_ENSINO==34 & TP_COR_RACA==1

*variáveis que indicam se aulno vai de transporte público para a escola
gen n_alu_transp_publico_em_inte_1=1 if FK_COD_ETAPA_ENSINO==30 & ID_N_T_E_P==1
gen n_alu_transp_publico_em_inte_2=1 if FK_COD_ETAPA_ENSINO==31 & ID_N_T_E_P==1
gen n_alu_transp_publico_em_inte_3=1 if FK_COD_ETAPA_ENSINO==32 & ID_N_T_E_P==1
gen n_alu_transp_publico_em_inte_4=1 if FK_COD_ETAPA_ENSINO==33 & ID_N_T_E_P==1
gen n_alu_transp_publico_em_inte_ns=1 if FK_COD_ETAPA_ENSINO==34 & ID_N_T_E_P==1

*variáveis de idade de cada aluno
gen m_idade_em_inte_1=NUM_IDADE if FK_COD_ETAPA_ENSINO==30
gen m_idade_em_inte_2=NUM_IDADE if FK_COD_ETAPA_ENSINO==31
gen m_idade_em_inte_3=NUM_IDADE if FK_COD_ETAPA_ENSINO==32
gen m_idade_em_inte_4=NUM_IDADE if FK_COD_ETAPA_ENSINO==33

gen m_idade_em_inte_ns=NUM_IDADE if FK_COD_ETAPA_ENSINO==34 


gen p_mulheres_em_inte_1=.
replace p_mulheres_em_inte_1=1 if FK_COD_ETAPA_ENSINO==30 & TP_SEXO=="F"
replace p_mulheres_em_inte_1=0 if FK_COD_ETAPA_ENSINO==30 & TP_SEXO=="M"
gen p_mulheres_em_inte_2=.
replace p_mulheres_em_inte_2=1 if FK_COD_ETAPA_ENSINO==31 & TP_SEXO=="F"
replace p_mulheres_em_inte_2=0 if FK_COD_ETAPA_ENSINO==31 & TP_SEXO=="M"
gen p_mulheres_em_inte_3=.
replace p_mulheres_em_inte_3=1 if FK_COD_ETAPA_ENSINO==32 & TP_SEXO=="F"
replace p_mulheres_em_inte_3=0 if FK_COD_ETAPA_ENSINO==32 & TP_SEXO=="M"
gen p_mulheres_em_inte_4=.
replace p_mulheres_em_inte_4=1 if FK_COD_ETAPA_ENSINO==33 & TP_SEXO=="F"
replace p_mulheres_em_inte_4=0 if FK_COD_ETAPA_ENSINO==33 & TP_SEXO=="M"
gen p_mulheres_em_inte_ns=.
replace p_mulheres_em_inte_ns=1 if FK_COD_ETAPA_ENSINO==34 & TP_SEXO=="F"
replace p_mulheres_em_inte_ns=0 if FK_COD_ETAPA_ENSINO==34 & TP_SEXO=="M"


gen p_brancos_em_inte_1=.
replace p_brancos_em_inte_1=1 if FK_COD_ETAPA_ENSINO==30 & TP_COR_RACA==1
replace p_brancos_em_inte_1=0 if FK_COD_ETAPA_ENSINO==30 & (TP_COR_RACA==2 | TP_COR_RACA==3 | TP_COR_RACA==4 | TP_COR_RACA==5)

gen p_brancos_em_inte_2=.
replace p_brancos_em_inte_2=1 if FK_COD_ETAPA_ENSINO==31 & TP_COR_RACA==1
replace p_brancos_em_inte_2=0 if FK_COD_ETAPA_ENSINO==31 & (TP_COR_RACA==2 | TP_COR_RACA==3 | TP_COR_RACA==4 | TP_COR_RACA==5)


gen p_brancos_em_inte_3=.
replace p_brancos_em_inte_3=1 if FK_COD_ETAPA_ENSINO==32 & TP_COR_RACA==1
replace p_brancos_em_inte_3=0 if FK_COD_ETAPA_ENSINO==32 & (TP_COR_RACA==2 | TP_COR_RACA==3 | TP_COR_RACA==4 | TP_COR_RACA==5)


gen p_brancos_em_inte_4=.
replace p_brancos_em_inte_4=1 if FK_COD_ETAPA_ENSINO==33 & TP_COR_RACA==1
replace p_brancos_em_inte_4=0 if FK_COD_ETAPA_ENSINO==33 & (TP_COR_RACA==2 | TP_COR_RACA==3 | TP_COR_RACA==4 | TP_COR_RACA==5)

gen p_brancos_em_inte_ns=.
replace p_brancos_em_inte_ns=1 if FK_COD_ETAPA_ENSINO==34 & TP_COR_RACA==1
replace p_brancos_em_inte_ns=0 if FK_COD_ETAPA_ENSINO==34 & (TP_COR_RACA==2 | TP_COR_RACA==3 | TP_COR_RACA==4 | TP_COR_RACA==5)

gen p_alu_transp_publico_em_inte_1=.
replace p_alu_transp_publico_em_inte_1=1 if FK_COD_ETAPA_ENSINO==30 & ID_N_T_E_P==1
replace p_alu_transp_publico_em_inte_1=0 if FK_COD_ETAPA_ENSINO==30 & ID_N_T_E_P==0

gen p_alu_transp_publico_em_inte_2=.
replace p_alu_transp_publico_em_inte_2=1 if FK_COD_ETAPA_ENSINO==31 & ID_N_T_E_P==1
replace p_alu_transp_publico_em_inte_2=0 if FK_COD_ETAPA_ENSINO==31 & ID_N_T_E_P==0


gen p_alu_transp_publico_em_inte_3=.
replace p_alu_transp_publico_em_inte_3=1 if FK_COD_ETAPA_ENSINO==32 & ID_N_T_E_P==1
replace p_alu_transp_publico_em_inte_3=0 if FK_COD_ETAPA_ENSINO==32 & ID_N_T_E_P==0


gen p_alu_transp_publico_em_inte_4=.
replace p_alu_transp_publico_em_inte_4=1 if FK_COD_ETAPA_ENSINO==33 & ID_N_T_E_P==1
replace p_alu_transp_publico_em_inte_4=0 if FK_COD_ETAPA_ENSINO==33 & ID_N_T_E_P==0


gen p_alu_transp_publico_em_inte_ns=.
replace p_alu_transp_publico_em_inte_ns=1 if FK_COD_ETAPA_ENSINO==34 & ID_N_T_E_P==1
replace p_alu_transp_publico_em_inte_ns=0 if FK_COD_ETAPA_ENSINO==34 & ID_N_T_E_P==0


* collapse
compress
# delimit ;
collapse 
(sum) n_alunos_fund_5_8anos-n_transp_pub_fund_9_9anos 
(mean) m_idade_fund_5_8anos-p_transp_pub_fund_9_9anos
(sum) n_alunos_em_1-n_alu_transporte_publico_em_3
(mean) m_idade_em_1-p_alu_transporte_publico_em_3
(sum) n_alunos_em_inte_1-n_alu_transp_publico_em_inte_ns 
(mean) m_idade_em_inte_1-p_alu_transp_publico_em_inte_ns
, by(codigo_escola)
;
# delimit cr
save "D:\Dropbox\bases_dta\censo_escolar\2009\censo_escolar2009_matriculas_col(`x').dta", replace


}

/*---------------------------Dados de Docentes--------------------------------*/
/*importação*/
foreach x in "NORDESTE" "SUDESTE" "CO"{
clear
/*
# delimit ;
infix

FK_COD_ESCOLARIDADE 67-68
FK_COD_ETAPA_ENSINO 505-508
double PK_COD_ENTIDADE 518-526
using "D:\2009\DADOS\ts_docentes_pe.txt";
*using "E:\Bases de Dados\Educação\Censo Escolar\Censo Escolar 2009\DADOS\ts_docentes_pe.txt";

# delimit cr
*/


import delimited "D:\2009\DADOS\DOCENTES_`x'.CSV", delimiter("|") case(upper)
# delimit ;
keep
FK_COD_ESCOLARIDADE
FK_COD_ETAPA_ENSINO
PK_COD_ENTIDADE
SIGLA
FK_COD_ESTADO 
;
# delimit cr

rename PK_COD_ENTIDADE codigo_escola
rename FK_COD_ESTADO codigo_uf

save "D:\Dropbox\bases_dta\censo_escolar\2009\censo_escolar2009_docentes_`x'.dta", replace

}
use "D:\Dropbox\bases_dta\censo_escolar\2009\censo_escolar2009_docentes_NORDESTE.dta", clear
append using "D:\Dropbox\bases_dta\censo_escolar\2009\censo_escolar2009_docentes_SUDESTE.dta"

append using "D:\Dropbox\bases_dta\censo_escolar\2009\censo_escolar2009_docentes_CO.dta"

save "D:\Dropbox\bases_dta\censo_escolar\2009\censo_escolar2009_docentes.dta", replace



/* renomear e selecionar variáveis*/
foreach x in "PE" "CE" "RJ" "SP" "ES" "GO" {
clear all
use "D:\Dropbox\bases_dta\censo_escolar\2009\censo_escolar2009_docentes.dta", clear

*mantendo uf
keep if SIGLA=="`x'"

/*
variáveis, por série: 
número de professores, por série
número de professores com ensino superior, por série
proporção de professores com ensino superior
*/

/*gerando variáveis de ensino fundamental*/
gen n_profs_fund_5_8anos=1 if FK_COD_ETAPA_ENSINO==8
gen n_profs_fund_6_8anos=1 if FK_COD_ETAPA_ENSINO==9
gen n_profs_fund_7_8anos=1 if FK_COD_ETAPA_ENSINO==10
gen n_profs_fund_8_8anos=1 if FK_COD_ETAPA_ENSINO==11
gen n_profs_fund_6_9anos=1 if FK_COD_ETAPA_ENSINO==19
gen n_profs_fund_7_9anos=1 if FK_COD_ETAPA_ENSINO==20
gen n_profs_fund_8_9anos=1 if FK_COD_ETAPA_ENSINO==21
gen n_profs_fund_9_9anos=1 if FK_COD_ETAPA_ENSINO==41

/*
FK_COD_ESCOLARIDADE: Escolaridade
6 - Superior completo com Licenciatura


*/
gen n_profs_sup_fund_5_8anos=1 if FK_COD_ETAPA_ENSINO==8 & FK_COD_ESCOLARIDADE==6
gen n_profs_sup_fund_6_8anos=1 if FK_COD_ETAPA_ENSINO==9 & FK_COD_ESCOLARIDADE==6
gen n_profs_sup_fund_7_8anos=1 if FK_COD_ETAPA_ENSINO==10 & FK_COD_ESCOLARIDADE==6
gen n_profs_sup_fund_8_8anos=1 if FK_COD_ETAPA_ENSINO==11 & FK_COD_ESCOLARIDADE==6
gen n_profs_sup_fund_6_9anos=1 if FK_COD_ETAPA_ENSINO==19 & FK_COD_ESCOLARIDADE==6
gen n_profs_sup_fund_7_9anos=1 if FK_COD_ETAPA_ENSINO==20 & FK_COD_ESCOLARIDADE==6
gen n_profs_sup_fund_8_9anos=1 if FK_COD_ETAPA_ENSINO==21 & FK_COD_ESCOLARIDADE==6
gen n_profs_sup_fund_9_9anos=1 if FK_COD_ETAPA_ENSINO==41 & FK_COD_ESCOLARIDADE==6

gen p_profs_sup_fund_5_8anos=.
replace p_profs_sup_fund_5_8anos=1 if FK_COD_ETAPA_ENSINO==8 & FK_COD_ESCOLARIDADE==6
replace p_profs_sup_fund_5_8anos=0 if FK_COD_ETAPA_ENSINO==8 & (FK_COD_ESCOLARIDADE==1 | FK_COD_ESCOLARIDADE==2 | FK_COD_ESCOLARIDADE==3 | FK_COD_ESCOLARIDADE==4 | FK_COD_ESCOLARIDADE==5)

gen p_profs_sup_fund_6_8anos=.
replace p_profs_sup_fund_6_8anos=1 if FK_COD_ETAPA_ENSINO==9 & FK_COD_ESCOLARIDADE==6
replace p_profs_sup_fund_6_8anos=0 if FK_COD_ETAPA_ENSINO==9 & (FK_COD_ESCOLARIDADE==1 | FK_COD_ESCOLARIDADE==2 | FK_COD_ESCOLARIDADE==3 | FK_COD_ESCOLARIDADE==4 | FK_COD_ESCOLARIDADE==5)

gen p_profs_sup_fund_7_8anos=.
replace p_profs_sup_fund_7_8anos=1 if FK_COD_ETAPA_ENSINO==10 & FK_COD_ESCOLARIDADE==6
replace p_profs_sup_fund_7_8anos=0 if FK_COD_ETAPA_ENSINO==10 & (FK_COD_ESCOLARIDADE==1 | FK_COD_ESCOLARIDADE==2 | FK_COD_ESCOLARIDADE==3 | FK_COD_ESCOLARIDADE==4 | FK_COD_ESCOLARIDADE==5)

gen p_profs_sup_fund_8_8anos=.
replace p_profs_sup_fund_8_8anos=1 if FK_COD_ETAPA_ENSINO==11 & FK_COD_ESCOLARIDADE==6
replace p_profs_sup_fund_8_8anos=0 if FK_COD_ETAPA_ENSINO==11 & (FK_COD_ESCOLARIDADE==1 | FK_COD_ESCOLARIDADE==2 | FK_COD_ESCOLARIDADE==3 | FK_COD_ESCOLARIDADE==4 | FK_COD_ESCOLARIDADE==5)

gen p_profs_sup_fund_6_9anos=.
replace p_profs_sup_fund_6_9anos=1 if FK_COD_ETAPA_ENSINO==19 & FK_COD_ESCOLARIDADE==6
replace p_profs_sup_fund_6_9anos=0 if FK_COD_ETAPA_ENSINO==19 & (FK_COD_ESCOLARIDADE==1 | FK_COD_ESCOLARIDADE==2 | FK_COD_ESCOLARIDADE==3 | FK_COD_ESCOLARIDADE==4 | FK_COD_ESCOLARIDADE==5)

gen p_profs_sup_fund_7_9anos=.
replace p_profs_sup_fund_7_9anos=1 if FK_COD_ETAPA_ENSINO==20 & FK_COD_ESCOLARIDADE==6
replace p_profs_sup_fund_7_9anos=0 if FK_COD_ETAPA_ENSINO==20 & (FK_COD_ESCOLARIDADE==1 | FK_COD_ESCOLARIDADE==2 | FK_COD_ESCOLARIDADE==3 | FK_COD_ESCOLARIDADE==4 | FK_COD_ESCOLARIDADE==5)

gen p_profs_sup_fund_8_9anos=.
replace p_profs_sup_fund_8_9anos=1 if FK_COD_ETAPA_ENSINO==21 & FK_COD_ESCOLARIDADE==6
replace p_profs_sup_fund_8_9anos=0 if FK_COD_ETAPA_ENSINO==21 & (FK_COD_ESCOLARIDADE==1 | FK_COD_ESCOLARIDADE==2 | FK_COD_ESCOLARIDADE==3 | FK_COD_ESCOLARIDADE==4 | FK_COD_ESCOLARIDADE==5)

gen p_profs_sup_fund_9_9anos=.
replace p_profs_sup_fund_9_9anos=1 if FK_COD_ETAPA_ENSINO==41 & FK_COD_ESCOLARIDADE==6
replace p_profs_sup_fund_9_9anos=0 if FK_COD_ETAPA_ENSINO==41 & (FK_COD_ESCOLARIDADE==1 | FK_COD_ESCOLARIDADE==2 | FK_COD_ESCOLARIDADE==3 | FK_COD_ESCOLARIDADE==4 | FK_COD_ESCOLARIDADE==5)


/*para professores do ensino médio*/

*gerar variáveis para utitlizar na soma
*variável de número de professores por série
gen n_profs_em_1=1 if FK_COD_ETAPA_ENSINO==25
gen n_profs_em_2=1 if FK_COD_ETAPA_ENSINO==26
gen n_profs_em_3=1 if FK_COD_ETAPA_ENSINO==27

*variável de número de professores que tem ensino superior com ou sem licenciatura
gen n_profs_sup_em_1=1 if FK_COD_ETAPA_ENSINO==25 & FK_COD_ESCOLARIDADE==6
gen n_profs_sup_em_2=1 if FK_COD_ETAPA_ENSINO==26 & FK_COD_ESCOLARIDADE==6
gen n_profs_sup_em_3=1 if FK_COD_ETAPA_ENSINO==27 & FK_COD_ESCOLARIDADE==6

*gerar variáveis para utitlizar na proporção
*variável de proporção de professores com ensino superior com ou sem lic
*por série

gen p_profs_sup_em_1=.
replace p_profs_sup_em_1=1 if FK_COD_ETAPA_ENSINO==25 & FK_COD_ESCOLARIDADE==6
replace p_profs_sup_em_1=0 if FK_COD_ETAPA_ENSINO==25 & (FK_COD_ESCOLARIDADE==1 | FK_COD_ESCOLARIDADE==2 | FK_COD_ESCOLARIDADE==3 | FK_COD_ESCOLARIDADE==4 | FK_COD_ESCOLARIDADE==5)
gen p_profs_sup_em_2=.
replace p_profs_sup_em_2=1 if FK_COD_ETAPA_ENSINO==26 & FK_COD_ESCOLARIDADE==6
replace p_profs_sup_em_2=0 if FK_COD_ETAPA_ENSINO==26 & (FK_COD_ESCOLARIDADE==1 | FK_COD_ESCOLARIDADE==2 | FK_COD_ESCOLARIDADE==3 | FK_COD_ESCOLARIDADE==4 | FK_COD_ESCOLARIDADE==5)
gen p_profs_sup_em_3=.
replace p_profs_sup_em_3=1 if FK_COD_ETAPA_ENSINO==27 & FK_COD_ESCOLARIDADE==6
replace p_profs_sup_em_3=0 if FK_COD_ETAPA_ENSINO==27 & (FK_COD_ESCOLARIDADE==1 | FK_COD_ESCOLARIDADE==2 | FK_COD_ESCOLARIDADE==3 | FK_COD_ESCOLARIDADE==4 | FK_COD_ESCOLARIDADE==5)



/*para professores do ensino médio integrado*/


*gerar variáveis para utitlizar na soma
*variáveis de soma/número de professores no em integrado, por série

gen n_profs_em_inte_1=1 if FK_COD_ETAPA_ENSINO==30
gen n_profs_em_inte_2=1 if FK_COD_ETAPA_ENSINO==31
gen n_profs_em_inte_3=1 if FK_COD_ETAPA_ENSINO==32
gen n_profs_em_inte_4=1 if FK_COD_ETAPA_ENSINO==33
gen n_profs_em_inte_ns=1 if FK_COD_ETAPA_ENSINO==34

*variável de soma/número de professores no em integrado, com superior
*por série

gen n_profs_sup_em_inte_1=1 if FK_COD_ETAPA_ENSINO==30 & FK_COD_ESCOLARIDADE==6
gen n_profs_sup_em_inte_2=1 if FK_COD_ETAPA_ENSINO==31 & FK_COD_ESCOLARIDADE==6
gen n_profs_sup_em_inte_3=1 if FK_COD_ETAPA_ENSINO==32 & FK_COD_ESCOLARIDADE==6
gen n_profs_sup_em_inte_4=1 if FK_COD_ETAPA_ENSINO==33 & FK_COD_ESCOLARIDADE==6
*não seriado
gen n_profs_sup_em_inte_ns=1 if FK_COD_ETAPA_ENSINO==34 & FK_COD_ESCOLARIDADE==6

*gerar variáveis para utitlizar na proporção
*variável de proporção de professores no em integrado, com superior

gen p_profs_sup_em_inte_1=.
replace p_profs_sup_em_inte_1=1 if FK_COD_ETAPA_ENSINO==30 & FK_COD_ESCOLARIDADE==6
replace p_profs_sup_em_inte_1=0 if FK_COD_ETAPA_ENSINO==30 & (FK_COD_ESCOLARIDADE==1 | FK_COD_ESCOLARIDADE==2 | FK_COD_ESCOLARIDADE==3 | FK_COD_ESCOLARIDADE==4 | FK_COD_ESCOLARIDADE==5)

gen p_profs_sup_em_inte_2=.
replace p_profs_sup_em_inte_2=1 if FK_COD_ETAPA_ENSINO==31 & FK_COD_ESCOLARIDADE==6
replace p_profs_sup_em_inte_2=0 if FK_COD_ETAPA_ENSINO==31 & (FK_COD_ESCOLARIDADE==1 | FK_COD_ESCOLARIDADE==2 | FK_COD_ESCOLARIDADE==3 | FK_COD_ESCOLARIDADE==4 | FK_COD_ESCOLARIDADE==5)

gen p_profs_sup_em_inte_3=.
replace p_profs_sup_em_inte_3=1 if FK_COD_ETAPA_ENSINO==32 & FK_COD_ESCOLARIDADE==6
replace p_profs_sup_em_inte_3=0 if FK_COD_ETAPA_ENSINO==32 & (FK_COD_ESCOLARIDADE==1 | FK_COD_ESCOLARIDADE==2 | FK_COD_ESCOLARIDADE==3 | FK_COD_ESCOLARIDADE==4 | FK_COD_ESCOLARIDADE==5)

gen p_profs_sup_em_inte_4=.
replace p_profs_sup_em_inte_4=1 if FK_COD_ETAPA_ENSINO==33 & FK_COD_ESCOLARIDADE==6
replace p_profs_sup_em_inte_4=0 if FK_COD_ETAPA_ENSINO==33 & (FK_COD_ESCOLARIDADE==1 | FK_COD_ESCOLARIDADE==2 | FK_COD_ESCOLARIDADE==3 | FK_COD_ESCOLARIDADE==4 | FK_COD_ESCOLARIDADE==5)

gen p_profs_sup_em_inte_ns=.
replace p_profs_sup_em_inte_ns=1 if FK_COD_ETAPA_ENSINO==34 & FK_COD_ESCOLARIDADE==6
replace p_profs_sup_em_inte_ns=0 if FK_COD_ETAPA_ENSINO==34 & (FK_COD_ESCOLARIDADE==1 | FK_COD_ESCOLARIDADE==2 | FK_COD_ESCOLARIDADE==3 | FK_COD_ESCOLARIDADE==4 | FK_COD_ESCOLARIDADE==5)

compress
# delimit ;
collapse 
(sum) n_profs_fund_5_8anos-n_profs_sup_fund_9_9anos  
(mean) p_profs_sup_fund_5_8anos-p_profs_sup_fund_9_9anos 
(sum) n_profs_em_1-n_profs_sup_em_3 
(mean) p_profs_sup_em_1	p_profs_sup_em_2 p_profs_sup_em_3   
(sum) n_profs_em_inte_1-n_profs_sup_em_inte_ns 
(mean) p_profs_sup_em_inte_1-p_profs_sup_em_inte_ns,	
	
by (codigo_escola);
#delimit cr
save "D:\Dropbox\bases_dta\censo_escolar\2009\censo_escolar2009_docentes_col(`x').dta", replace

}

/*
 _________________________________________________
|					MERGE						  |
|_________________________________________________|
*/


foreach x in "PE" "CE" "RJ" "SP" "ES" "GO" {
use "D:\Dropbox\bases_dta\censo_escolar\2009\censo_escolar2009_escolas.dta", clear
keep if sigla=="`x'"
merge 1:1 codigo_escola using "D:\Dropbox\bases_dta\censo_escolar\2009\censo_escolar2009_turmas_col(`x').dta"
drop _merge
merge 1:1 codigo_escola using "D:\Dropbox\bases_dta\censo_escolar\2009\censo_escolar2009_matriculas_col(`x').dta"
drop _merge
merge 1:1 codigo_escola using "D:\Dropbox\bases_dta\censo_escolar\2009\censo_escolar2009_docentes_col(`x').dta"
save "D:\Dropbox\bases_dta\censo_escolar\2009\censo_escolar2009_`x'.dta", replace

}
