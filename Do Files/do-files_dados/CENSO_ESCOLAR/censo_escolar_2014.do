/***************************CENSO ESCOLAR 2012********************************/

/*objetivo final: replicar os resultados obtidos anteriormente*/

/*
objetivo do do-file:
a. traduzir txt para dta
b. renomear e gerar variáveis, dropar variáveis não usadas
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
clear all

import delimited "D:\2014\DADOS\ESCOLAS.CSV", delimiter("|") 
{







































}
# delimit;
keep 
ano_censo 
pk_cod_entidade 
no_entidade 
desc_situacao_funcionamento 
fk_cod_estado 
fk_cod_municipio 
fk_cod_distrito
id_dependencia_adm
id_localizacao
id_local_func_predio_escolar
id_agua_rede_publica
id_energia_rede_publica
id_esgoto_rede_publica
id_lixo_coleta_periodica
id_sala_diretoria
id_sala_professor
id_laboratorio_informatica
id_laboratorio_ciencias
id_quadra_esportes_coberta
id_quadra_esportes_descoberta
id_biblioteca
id_sala_leitura
id_refeitorio
num_salas_existentes
num_salas_utilizadas
id_internet
id_mod_ens_regular
id_reg_fund_8_anos
id_reg_fund_9_anos
id_reg_medio_medio
id_reg_medio_integrado
id_reg_medio_normal 
id_reg_medio_prof;
# delimit cr


/*criando e renomeando as variáveis relevantes*/




*variável codigo de escola
rename pk_cod_entidade codigo_escola

*variavel nome da escola
rename no_entidade nome_escola

*variável código de estado
rename fk_cod_estado codigo_uf
 
*não tem variável de sigla 
 
 
*variável município
rename fk_cod_municipio codigo_municipio_novo

*variável Código do distrito
rename fk_cod_distrito distrito_escola_novo

*variável dependência administrativa
rename id_dependencia_adm dependencia_administrativa

*variável que indica condição da escola: *1 se ativo, 0 se paralisada/extinta
generate ativa=.
replace ativa=1 if desc_situacao_funcionamento==1
replace ativa=0 if desc_situacao_funcionamento==2 | desc_situacao_funcionamento==3 | desc_situacao_funcionamento==4
drop desc_situacao_funcionamento

*variável que indica se escola é rural ou não
generate rural=.
replace rural=1 if id_localizacao==2
replace rural=0 if id_localizacao==1
drop id_localizacao

*variável que indica se local de funcionamento da escola é um prédio
generate predio=.
replace predio=1 if id_local_func_predio_escolar==1 | id_local_func_predio_escolar==2 | id_local_func_predio_escolar==3
replace predio=0 if id_local_func_predio_escolar==0
drop id_local_func_predio_escolar

*variável que indica se escola é abastecida por água da rede pública
*agora em int (antes em string nas bases passadas)
rename id_agua_rede_publica agua

*variável que indica se escola é abastecida pela rede pública de energia
*agora em int (antes em string nas bases passadas)
rename id_energia_rede_publica eletricidade

*variável que indica se escola tem acesso ao esgoto
*agora em int (antes em string nas bases passadas)
rename id_esgoto_rede_publica esgoto

*variável que indica a existência de coleta de lixo periódica
*agora em int (antes em string nas bases passadas)
rename id_lixo_coleta_periodica lixo_coleta

*variável que indica se existe a dependência diretoria
*agora em int (antes em string nas bases passadas)
rename id_sala_diretoria diretoria

*variavel que indica se existe a dependência sala de professores
*agora em int (antes em string nas bases passadas)
rename id_sala_professor sala_professores

*variável que indica se existe a dependência laboratótio de informática
*agora em int (antes em string nas bases passadas)
rename id_laboratorio_informatica lab_info

*variável que indica se existe a dependência laboratório de ciências
*agora em int (antes em string nas bases passadas)
rename id_laboratorio_ciencias lab_ciencias

*variável que indica se existe dependência quadra de esportes
generate quadra_esportes=.
replace quadra_esportes=1 if id_quadra_esportes_coberta==1 | id_quadra_esportes_descoberta==1
replace quadra_esportes=0 if id_quadra_esportes_coberta==0 & id_quadra_esportes_descoberta==0
drop id_quadra_esportes_coberta id_quadra_esportes_descoberta

*variável que indica se existe a dependência biblioteca
*agora em int (antes em string nas bases passadas)
rename id_biblioteca biblioteca

*variável que indica se existe a dependência sala de leitura
*agora em int (antes em string nas bases passadas)
rename id_sala_leitura sala_leitura

*variável que indica se existe a depêndencia refeitório
*agora em int (antes em string nas bases passadas)
rename id_refeitorio refeitorio

*variável de número de salas existentes
*agora em int (antes em string nas bases passadas)
rename num_salas_existentes n_salas_exis

*variavel de número de salas utilizadas
*agora em int (antes em string nas bases passadas)
rename num_salas_utilizadas n_salas_utilizadas

*variável que indica a existência de internet
*agora em int (antes em string nas bases passadas)
rename id_internet internet

*variável que indica que a modalidade é Ensino Regular
*agora em int (antes em string nas bases passadas)
rename id_mod_ens_regular regular

*variável que indica que é ensino regular - ensino fundamental - 8 anos
*agora em int (antes em string nas bases passadas)
rename id_reg_fund_8_anos fund_8_anos

*variável que indica que é ensino regular - ensino fundamental - 9 anos
*agora em int (antes em string nas bases passadas)
rename id_reg_fund_9_anos fund_9_anos

*variável que indica se a escola possui ensino médio
*agora em int (antes em string nas bases passadas)
rename id_reg_medio_medio em

*variável que indica se a escola possui ensino integrado
*agora em int (antes em string nas bases passadas)
rename id_reg_medio_integrado em_integrado

*variável que indica se a escola possui ensino médio normal
*agora em int (antes em string nas bases passadas)
rename id_reg_medio_normal em_normal

*variável que indica se a escola possui ensino médio profissional
*agora em int (antes em string nas bases passadas)
rename id_reg_medio_prof em_prof

save "D:\Dropbox\bases_dta\censo_escolar\2014\censo_escolar2014_escolas.dta", replace
{




































}
/*-----------------------------Dados de Turma----------------------------------*/
/*importação*/ 

clear all 
{









}
import delimited "D:\2014\DADOS\TURMAS.CSV", delimiter("|") 
# delimit ;
keep 
fk_cod_etapa_ensino 
id_mais_educacao
fk_cod_etapa_ensino
pk_cod_entidade 
fk_cod_estado;
# delimit cr
generate SIGLA = "."
replace SIGLA = "PE" if fk_cod_estado == 26
replace SIGLA = "GO" if fk_cod_estado == 52
replace SIGLA = "CE" if fk_cod_estado == 23
replace SIGLA = "RJ" if fk_cod_estado == 33
replace SIGLA = "SP" if fk_cod_estado == 35
replace SIGLA = "ES" if fk_cod_estado == 32

save "D:\Dropbox\bases_dta\censo_escolar\2014\censo_escolar2014_turmas.dta", replace 
/*criando e renomeando as variáveis relevantes*/
/*gerando para cada estado*/
/*PE, GO, CE, RJ, SP, ES*/
foreach x in "PE" "GO" "CE" "RJ" "SP" "ES" {
clear all
use "D:\Dropbox\bases_dta\censo_escolar\2014\censo_escolar2014_turmas.dta", clear


rename fk_cod_etapa_ensino FK_COD_ETAPA_ENSINO
rename id_mais_educacao ID_MAIS_EDUCACAO
rename pk_cod_entidade codigo_escola
rename fk_cod_estado codigo_uf


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

*variáveis com número de turmas com mais educação no ef de 8 anos

gen n_turmas_mais_educ_fund_5_8anos=1 if FK_COD_ETAPA_ENSINO==8 & ID_MAIS_EDUCACAO==1
gen n_turmas_mais_educ_fund_6_8anos=1 if FK_COD_ETAPA_ENSINO==9 & ID_MAIS_EDUCACAO==1
gen n_turmas_mais_educ_fund_7_8anos=1 if FK_COD_ETAPA_ENSINO==10 & ID_MAIS_EDUCACAO==1
gen n_turmas_mais_educ_fund_8_8anos=1 if FK_COD_ETAPA_ENSINO==11 & ID_MAIS_EDUCACAO==1

*variáveis com o número de turmas com mais educação no ef de 9 anos

gen n_turmas_mais_educ_fund_6_9anos=1 if FK_COD_ETAPA_ENSINO==19 & ID_MAIS_EDUCACAO==1
gen n_turmas_mais_educ_fund_7_9anos=1 if FK_COD_ETAPA_ENSINO==20 & ID_MAIS_EDUCACAO==1
gen n_turmas_mais_educ_fund_8_9anos=1 if FK_COD_ETAPA_ENSINO==21 & ID_MAIS_EDUCACAO==1
gen n_turmas_mais_educ_fund_9_9anos=1 if FK_COD_ETAPA_ENSINO==41 & ID_MAIS_EDUCACAO==1

*variáveis com número de turmas do 1ª,2ª,3ª
gen n_turmas_em_1=1 if FK_COD_ETAPA_ENSINO==25
gen n_turmas_em_2=1 if FK_COD_ETAPA_ENSINO==26
gen n_turmas_em_3=1 if FK_COD_ETAPA_ENSINO==27

*variáveis com número de turmas com mais educação do 1ª,2ª,3ª
gen n_turmas_mais_educ_em_1=1 if FK_COD_ETAPA_ENSINO==25 & ID_MAIS_EDUCACAO==1
gen n_turmas_mais_educ_em_2=1 if FK_COD_ETAPA_ENSINO==26 & ID_MAIS_EDUCACAO==1
gen n_turmas_mais_educ_em_3=1 if FK_COD_ETAPA_ENSINO==27 & ID_MAIS_EDUCACAO==1


*variáveis com número de turmas do ensino médio integrado, para 1º,2º,3º e 4º

gen n_turmas_em_inte_1=1 if FK_COD_ETAPA_ENSINO==30
gen n_turmas_em_inte_2=1 if FK_COD_ETAPA_ENSINO==31
gen n_turmas_em_inte_3=1 if FK_COD_ETAPA_ENSINO==32
gen n_turmas_em_inte_4=1 if FK_COD_ETAPA_ENSINO==33
gen n_turmas_em_inte_ns=1 if FK_COD_ETAPA_ENSINO==34

*variáveis com número de turmas do ensino médio integrado, com mais educação, para 1º,2º,3º e 4º

gen n_turmas_mais_educ_em_inte_1=1 if FK_COD_ETAPA_ENSINO==30 & ID_MAIS_EDUCACAO==1
gen n_turmas_mais_educ_em_inte_2=1 if FK_COD_ETAPA_ENSINO==31 & ID_MAIS_EDUCACAO==1
gen n_turmas_mais_educ_em_inte_3=1 if FK_COD_ETAPA_ENSINO==32 & ID_MAIS_EDUCACAO==1
gen n_turmas_mais_educ_em_inte_4=1 if FK_COD_ETAPA_ENSINO==33 & ID_MAIS_EDUCACAO==1
gen n_turmas_mais_educ_em_inte_ns=1 if FK_COD_ETAPA_ENSINO==34 & ID_MAIS_EDUCACAO==1

* collapse por escola
compress
# delimit ;

collapse 

(sum) n_turmas_fund_5_8anos - n_turmas_fund_9_9anos
(sum) n_turmas_em_1 n_turmas_em_2 n_turmas_em_3
(sum) n_turmas_em_inte_3 n_turmas_em_inte_4 n_turmas_em_inte_ns,
by(codigo_escola);
# delimit cr	
save "D:\Dropbox\bases_dta\censo_escolar\2014\censo_escolar2014_turmas_col(`x').dta", replace
}

/*---------------------------Dados de Matrícula--------------------------------*/
foreach x in "NORDESTE" "SUDESTE" "CO"{
clear all
/*tradução*/
import delimited "D:\2014\DADOS\MATRICULA_`x'.CSV", delimiter("|")
# delimit ;
keep 
num_idade
tp_sexo
tp_cor_raca
id_zona_residencial
id_n_t_e_p
fk_cod_mod_ensino
fk_cod_etapa_ensino
pk_cod_entidade
fk_cod_estado_escola
;
# delimit cr

generate SIGLA = "."
replace SIGLA = "PE" if fk_cod_estado_escola == 26
replace SIGLA = "GO" if fk_cod_estado_escola == 52
replace SIGLA = "CE" if fk_cod_estado_escola == 23
replace SIGLA = "RJ" if fk_cod_estado_escola == 33
replace SIGLA = "SP" if fk_cod_estado_escola == 35
replace SIGLA = "ES" if fk_cod_estado_escola == 32

rename num_idade NUM_IDADE
rename tp_sexo TP_SEXO
rename tp_cor_raca TP_COR_RACA
rename id_zona_residencial ID_ZONA_RESIDENCIAL
rename id_n_t_e_p ID_N_T_E_P
rename fk_cod_etapa_ensino FK_COD_ETAPA_ENSINO
rename pk_cod_entidade codigo_escola
rename fk_cod_estado_escola codigo_uf

save "D:\Dropbox\bases_dta\censo_escolar\2014\censo_escolar2014_matriculas_`x'.dta", replace
}
use "D:\Dropbox\bases_dta\censo_escolar\2014\censo_escolar2014_matriculas_NORDESTE.dta", clear
append using "D:\Dropbox\bases_dta\censo_escolar\2014\censo_escolar2014_matriculas_SUDESTE.dta"
append using "D:\Dropbox\bases_dta\censo_escolar\2014\censo_escolar2014_matriculas_CO.dta"

save "D:\Dropbox\bases_dta\censo_escolar\2014\censo_escolar2014_matriculas.dta", replace
{











}

foreach x in "PE" "CE" "RJ" "SP" "ES" "GO" {
use "D:\Dropbox\bases_dta\censo_escolar\2014\censo_escolar2014_matriculas.dta", clear

keep if SIGLA=="`x'"
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
gen n_mulheres_fund_5_8anos=1 if FK_COD_ETAPA_ENSINO==8 & TP_SEXO==2
gen n_mulheres_fund_6_8anos=1 if FK_COD_ETAPA_ENSINO==9 & TP_SEXO==2
gen n_mulheres_fund_7_8anos=1 if FK_COD_ETAPA_ENSINO==10 & TP_SEXO==2
gen n_mulheres_fund_8_8anos=1 if FK_COD_ETAPA_ENSINO==11 & TP_SEXO==2
gen n_mulheres_fund_6_9anos=1 if FK_COD_ETAPA_ENSINO==19 & TP_SEXO==2
gen n_mulheres_fund_7_9anos=1 if FK_COD_ETAPA_ENSINO==20 & TP_SEXO==2
gen n_mulheres_fund_8_9anos=1 if FK_COD_ETAPA_ENSINO==21 & TP_SEXO==2
gen n_mulheres_fund_9_9anos=1 if FK_COD_ETAPA_ENSINO==41 & TP_SEXO==2

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
replace p_mulheres_fund_5_8anos=1 if FK_COD_ETAPA_ENSINO==8 & TP_SEXO==2
replace p_mulheres_fund_5_8anos=0 if FK_COD_ETAPA_ENSINO==8 & TP_SEXO==1

gen p_mulheres_fund_6_8anos=.
replace p_mulheres_fund_6_8anos=1 if FK_COD_ETAPA_ENSINO==9 & TP_SEXO==2
replace p_mulheres_fund_6_8anos=0 if FK_COD_ETAPA_ENSINO==9 & TP_SEXO==1

gen p_mulheres_fund_7_8anos=.
replace p_mulheres_fund_7_8anos=1 if FK_COD_ETAPA_ENSINO==10 & TP_SEXO==2
replace p_mulheres_fund_7_8anos=0 if FK_COD_ETAPA_ENSINO==10 & TP_SEXO==1

gen p_mulheres_fund_8_8anos=.
replace p_mulheres_fund_8_8anos=1 if FK_COD_ETAPA_ENSINO==11 & TP_SEXO==2
replace p_mulheres_fund_8_8anos=0 if FK_COD_ETAPA_ENSINO==11 & TP_SEXO==1

gen p_mulheres_fund_6_9anos=.
replace p_mulheres_fund_6_9anos=1 if FK_COD_ETAPA_ENSINO==19 & TP_SEXO==2
replace p_mulheres_fund_6_9anos=0 if FK_COD_ETAPA_ENSINO==19 & TP_SEXO==1

gen p_mulheres_fund_7_9anos=.
replace p_mulheres_fund_7_9anos=1 if FK_COD_ETAPA_ENSINO==20 & TP_SEXO==2
replace p_mulheres_fund_7_9anos=0 if FK_COD_ETAPA_ENSINO==20 & TP_SEXO==1

gen p_mulheres_fund_8_9anos=.
replace p_mulheres_fund_8_9anos=1 if FK_COD_ETAPA_ENSINO==21 & TP_SEXO==2
replace p_mulheres_fund_8_9anos=0 if FK_COD_ETAPA_ENSINO==21 & TP_SEXO==1

gen p_mulheres_fund_9_9anos=.
replace p_mulheres_fund_9_9anos=1 if FK_COD_ETAPA_ENSINO==41 & TP_SEXO==2
replace p_mulheres_fund_9_9anos=0 if FK_COD_ETAPA_ENSINO==41 & TP_SEXO==1

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

gen n_mulheres_em_1=1 if FK_COD_ETAPA_ENSINO==25 & TP_SEXO==2
gen n_mulheres_em_2=1 if FK_COD_ETAPA_ENSINO==26 & TP_SEXO==2
gen n_mulheres_em_3=1 if FK_COD_ETAPA_ENSINO==27 & TP_SEXO==2

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
replace p_mulheres_em_1=1 if FK_COD_ETAPA_ENSINO==25 & TP_SEXO==2
replace p_mulheres_em_1=0 if FK_COD_ETAPA_ENSINO==25 & TP_SEXO==1
gen p_mulheres_em_2=.
replace p_mulheres_em_2=1 if FK_COD_ETAPA_ENSINO==26 & TP_SEXO==2
replace p_mulheres_em_2=0 if FK_COD_ETAPA_ENSINO==26 & TP_SEXO==1
gen p_mulheres_em_3=.
replace p_mulheres_em_3=1 if FK_COD_ETAPA_ENSINO==27 & TP_SEXO==2
replace p_mulheres_em_3=0 if FK_COD_ETAPA_ENSINO==27 & TP_SEXO==1

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

*proporção de alunos que usam transporte público por série
*variáveis que indicam se usa ou não transporte público
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
gen n_mulheres_em_inte_1=1 if FK_COD_ETAPA_ENSINO==30 & TP_SEXO==2
gen n_mulheres_em_inte_2=1 if FK_COD_ETAPA_ENSINO==31 & TP_SEXO==2
gen n_mulheres_em_inte_3=1 if FK_COD_ETAPA_ENSINO==32 & TP_SEXO==2
gen n_mulheres_em_inte_4=1 if FK_COD_ETAPA_ENSINO==33 & TP_SEXO==2
gen n_mulheres_em_inte_ns=1 if FK_COD_ETAPA_ENSINO==34 & TP_SEXO==2
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

*gerar variáveis para utitlizar na proporção
*variáveis de idade de cada aluno
gen m_idade_em_inte_1=NUM_IDADE if FK_COD_ETAPA_ENSINO==30
gen m_idade_em_inte_2=NUM_IDADE if FK_COD_ETAPA_ENSINO==31
gen m_idade_em_inte_3=NUM_IDADE if FK_COD_ETAPA_ENSINO==32
gen m_idade_em_inte_4=NUM_IDADE if FK_COD_ETAPA_ENSINO==33
gen m_idade_em_inte_ns=NUM_IDADE if FK_COD_ETAPA_ENSINO==34

gen p_mulheres_em_inte_1=.
replace p_mulheres_em_inte_1=1 if FK_COD_ETAPA_ENSINO==30 & TP_SEXO==2
replace p_mulheres_em_inte_1=0 if FK_COD_ETAPA_ENSINO==30 & TP_SEXO==1

gen p_mulheres_em_inte_2=.
replace p_mulheres_em_inte_2=1 if FK_COD_ETAPA_ENSINO==31 & TP_SEXO==2
replace p_mulheres_em_inte_2=0 if FK_COD_ETAPA_ENSINO==31 & TP_SEXO==1

gen p_mulheres_em_inte_3=.
replace p_mulheres_em_inte_3=1 if FK_COD_ETAPA_ENSINO==32 & TP_SEXO==2
replace p_mulheres_em_inte_3=0 if FK_COD_ETAPA_ENSINO==32 & TP_SEXO==1

gen p_mulheres_em_inte_4=.
replace p_mulheres_em_inte_4=1 if FK_COD_ETAPA_ENSINO==33 & TP_SEXO==2
replace p_mulheres_em_inte_4=0 if FK_COD_ETAPA_ENSINO==33 & TP_SEXO==1

gen p_mulheres_em_inte_ns=.
replace p_mulheres_em_inte_ns=1 if FK_COD_ETAPA_ENSINO==34 & TP_SEXO==2
replace p_mulheres_em_inte_ns=0 if FK_COD_ETAPA_ENSINO==34 & TP_SEXO==1

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
compress
* collapse
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
save "D:\Dropbox\bases_dta\censo_escolar\2014\censo_escolar2014_matriculas_col(`x').dta", replace
}

/*---------------------------Dados de Docentes--------------------------------*/
/*importação*/


foreach x in "NORDESTE" "SUDESTE" "CO" {
clear all
set more off
set trace on
import delimited "D:\2014\DADOS\DOCENTES_`x'.CSV", delimiter("|")

# delimit ;
keep 
fk_cod_escolaridade 
fk_cod_etapa_ensino 
pk_cod_entidade 
fk_cod_estado;
# delimit cr
generate SIGLA = "."
replace SIGLA = "PE" if fk_cod_estado == 26
replace SIGLA = "GO" if fk_cod_estado == 52
replace SIGLA = "CE" if fk_cod_estado == 23
replace SIGLA = "RJ" if fk_cod_estado == 33
replace SIGLA = "SP" if fk_cod_estado == 35
replace SIGLA = "ES" if fk_cod_estado == 32

rename fk_cod_escolaridade FK_COD_ESCOLARIDADE
rename fk_cod_etapa_ensino FK_COD_ETAPA_ENSINO
rename pk_cod_entidade codigo_escola
rename fk_cod_estado codigo_uf

save "D:\Dropbox\bases_dta\censo_escolar\2014\censo_escolar2014_docentes_`x'.dta", replace




}

use "D:\Dropbox\bases_dta\censo_escolar\2014\censo_escolar2014_docentes_NORDESTE.dta", clear
append using "D:\Dropbox\bases_dta\censo_escolar\2014\censo_escolar2014_docentes_SUDESTE.dta"

append using "D:\Dropbox\bases_dta\censo_escolar\2014\censo_escolar2014_docentes_CO.dta"

save "D:\Dropbox\bases_dta\censo_escolar\2014\censo_escolar2014_docentes.dta", replace


/* renomear e selecionar variáveis*/
foreach x in "PE" "CE" "RJ" "SP" "ES" "GO" {

clear all
use "D:\Dropbox\bases_dta\censo_escolar\2014\censo_escolar2014_docentes.dta", clear
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

*gerar variáveis para utitlizar na proporção

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
gen n_profs_sup_em_inte_ns=1 if FK_COD_ETAPA_ENSINO==34 & FK_COD_ESCOLARIDADE==6 

*gerar variáveis para utitlizar na proporção

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
save "D:\Dropbox\bases_dta\censo_escolar\2014\censo_escolar2014_docentes_col(`x').dta", replace
}

/*
 _________________________________________________
|					MERGE						  |
|_________________________________________________|
*/


foreach x in "PE" "CE" "RJ" "SP" "ES" "GO" {
use "D:\Dropbox\bases_dta\censo_escolar\2014\censo_escolar2014_escolas.dta", clear
generate SIGLA = "."
replace SIGLA = "PE" if codigo_uf == 26
replace SIGLA = "GO" if codigo_uf == 52
replace SIGLA = "CE" if codigo_uf == 23
replace SIGLA = "RJ" if codigo_uf == 33
replace SIGLA = "SP" if codigo_uf == 35
replace SIGLA = "ES" if codigo_uf == 32
keep if SIGLA=="`x'"
merge 1:1 codigo_escola using "D:\Dropbox\bases_dta\censo_escolar\2014\censo_escolar2014_turmas_col(`x').dta"
drop _merge
merge 1:1 codigo_escola using "D:\Dropbox\bases_dta\censo_escolar\2014\censo_escolar2014_matriculas_col(`x').dta"
drop _merge
merge 1:1 codigo_escola using "D:\Dropbox\bases_dta\censo_escolar\2014\censo_escolar2014_docentes_col(`x').dta"
save "D:\Dropbox\bases_dta\censo_escolar\2014\censo_escolar2014_`x'.dta", replace

}

