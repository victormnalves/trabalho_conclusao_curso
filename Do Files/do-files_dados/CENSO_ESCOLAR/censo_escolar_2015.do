/*Censo Escolar 2015*/
/*tradução da base de dados*/
timer on  1


clear all
global user "`:environment USERPROFILE'"
*global dropbox "$user/Dropbox"
global dropboxA "$user/dropbox gmail/Dropbox"
global onedrive "$user/OneDrive"
clear
set more off
set trace on
/*
dados de escola
dados de turma 
dados de matrícula
dados de docentes

estados
CE, ES, GO, PE, RJ, SP

extrair dados de turma matrícula e docentes para EFII, EM, e EM profissionalizante
*/

/*Dados de escola*/

/*importação*/

*import delimited "$dropboxA/CENSO ESCOLAR 2002 - 2017\micro_censo_escolar_2015\MicrodCenso Escolar2015/DADOS\ESCOLAS.CSV", delimiter("|")
import delimited "D:\2015\DADOS\ESCOLAS.CSV", delimiter("|")

# delimit ;
keep 
nu_ano_censo
co_entidade 
no_entidade 
tp_situacao_funcionamento
co_uf
co_municipio
co_distrito
tp_dependencia 
tp_localizacao
tp_ocupacao_predio_escolar
in_agua_rede_publica
in_energia_rede_publica
in_esgoto_rede_publica
in_lixo_coleta_periodica
in_sala_diretoria
in_sala_professor
in_laboratorio_informatica 
in_laboratorio_ciencias
in_quadra_esportes_coberta 
in_quadra_esportes_descoberta 
in_biblioteca 
in_sala_leitura 
in_refeitorio 
nu_salas_existentes 
nu_salas_utilizadas 
in_internet 
/*variáveis que estavam na base de escolas de 2014, mas não estão na de 2015*/

/*
id_mod_ens_regular *Modalidade - Ensino Regular  (dummy)
id_reg_fund_8_anos *Ensino Regular - Ensino Fundamental - 8 anos (dummy)
id_reg_fund_9_anos * Ensino Regular - Ensino Fundamental - 9 anos (dummy)
id_reg_medio_medio  * Ensino Regular - Ensino Médio - Propedêutico (dummy)
id_reg_medio_integrado *Ensino Regular - Ensino Médio - Integrado (dummy)
id_reg_medio_normal  *Ensino Regular - Ensino Médio - Normal/Magistério
id_reg_medio_prof *Ensino Regular - Ensino Médio - Educação Profissional

rename id_mod_ens_regular regular
rename id_reg_fund_8_anos fund_8_anos
rename id_reg_fund_9_anos fund_9_anos
rename id_reg_medio_medio em
rename id_reg_medio_integrado em_integrado
rename id_reg_medio_normal em_normal
rename id_reg_medio_prof em_prof
as variáveis abaixo talvez sejam, talvez não

id_mod_ens_regular-> in_regular
*/
in_regular
;
# delimit cr

rename co_entidade codigo_escola
rename no_entidade nome_escola

generate ativa=.
replace ativa=1 if tp_situacao_funcionamento==1
replace ativa=0 if tp_situacao_funcionamento==2 | tp_situacao_funcionamento==3 | tp_situacao_funcionamento==4
drop tp_situacao_funcionamento

rename co_uf codigo_uf
rename co_municipio codigo_municipio_novo
rename co_distrito distrito_escola_novo
rename tp_dependencia dependencia_administrativa

generate rural=.
replace rural=1 if tp_localizacao==2
replace rural=0 if tp_localizacao==1
drop tp_localizacao

generate predio=.
replace predio=1 if tp_ocupacao_predio_escolar==1 | tp_ocupacao_predio_escolar==2 | tp_ocupacao_predio_escolar==3
replace predio=0 if tp_ocupacao_predio_escolar==0
drop tp_ocupacao_predio_escolar

rename in_agua_rede_publica agua
rename in_energia_rede_publica eletricidade
rename in_esgoto_rede_publica esgoto
rename in_lixo_coleta_periodica lixo_coleta
rename in_sala_diretoria diretoria
rename in_sala_professor sala_professores
rename in_laboratorio_informatica lab_info
rename in_laboratorio_ciencias lab_ciencias

generate quadra_esportes=.
replace quadra_esportes=1 if in_quadra_esportes_coberta==1 | in_quadra_esportes_descoberta==1
replace quadra_esportes=0 if in_quadra_esportes_coberta==0 & in_quadra_esportes_descoberta==0
drop in_quadra_esportes_coberta in_quadra_esportes_descoberta

rename in_biblioteca biblioteca
rename in_sala_leitura sala_leitura
rename in_refeitorio refeitorio

rename nu_salas_existentes n_salas_exis
rename nu_salas_utilizadas n_salas_utilizadas

rename in_internet internet

/*
as variáveis a seguir estavam na base escolas de 2014 mas não na de 2015
necessário encontrar variável correspondente
rename id_mod_ens_regular regular
rename id_reg_fund_8_anos fund_8_anos
rename id_reg_fund_9_anos fund_9_anos
rename id_reg_medio_medio em
rename id_reg_medio_integrado em_integrado
rename id_reg_medio_normal em_normal
rename id_reg_medio_prof em_prof
*/

save "F:\bases_dta\censo_escolar\2015\censo_escolar2015_escolas.dta", replace

/*-----------------------------Dados de Turma----------------------------------*/

/*importação*/
/*geral*/
set more off
set trace on
clear
*import delimited "$dropboxA/CENSO ESCOLAR 2002 - 2017\micro_censo_escolar_2015\MicrodCenso Escolar2015/DADOS\TURMAS.CSV", delimiter("|")
import delimited "D:\2015\DADOS\TURMAS.CSV", delimiter("|")

# delimit ;
keep
tp_etapa_ensino
in_mais_educ
co_entidade
co_uf
;

# delimit cr

generate SIGLA = "."
replace SIGLA = "PE" if co_uf == 26
replace SIGLA = "GO" if co_uf == 52
replace SIGLA = "CE" if co_uf == 23
replace SIGLA = "RJ" if co_uf == 33
replace SIGLA = "SP" if co_uf == 35
replace SIGLA = "ES" if co_uf == 32
rename tp_etapa_ensino FK_COD_ETAPA_ENSINO
rename in_mais_educ ID_MAIS_EDUCACAO
rename co_entidade codigo_escola
rename co_uf codigo_uf

save "F:\bases_dta\censo_escolar\2015\censo_escolar2015_turmas.dta", replace

/*gerando para cada estado*/
/*PE, GO, CE, RJ, SP, ES*/
foreach x in "PE" "GO" "CE" "RJ" "SP" "ES" {
clear all
set more off
set trace on
use "F:\bases_dta\censo_escolar\2015\censo_escolar2015_turmas.dta", clear

*mantendo uf
keep if SIGLA=="`x'"
gen n_turmas_em_1=1 if FK_COD_ETAPA_ENSINO==25
gen n_turmas_em_2=1 if FK_COD_ETAPA_ENSINO==26
gen n_turmas_em_3=1 if FK_COD_ETAPA_ENSINO==27

gen n_turmas_mais_educ_em_1=1 if FK_COD_ETAPA_ENSINO==25 & ID_MAIS_EDUCACAO==1
gen n_turmas_mais_educ_em_2=1 if FK_COD_ETAPA_ENSINO==26 & ID_MAIS_EDUCACAO==1
gen n_turmas_mais_educ_em_3=1 if FK_COD_ETAPA_ENSINO==27 & ID_MAIS_EDUCACAO==1

gen n_turmas_em_inte_1=1 if FK_COD_ETAPA_ENSINO==30
gen n_turmas_em_inte_2=1 if FK_COD_ETAPA_ENSINO==31
gen n_turmas_em_inte_3=1 if FK_COD_ETAPA_ENSINO==32
gen n_turmas_em_inte_4=1 if FK_COD_ETAPA_ENSINO==33
gen n_turmas_em_inte_ns=1 if FK_COD_ETAPA_ENSINO==34

gen n_turmas_mais_educ_em_inte_1=1 if FK_COD_ETAPA_ENSINO==30 & ID_MAIS_EDUCACAO==1
gen n_turmas_mais_educ_em_inte_2=1 if FK_COD_ETAPA_ENSINO==31 & ID_MAIS_EDUCACAO==1
gen n_turmas_mais_educ_em_inte_3=1 if FK_COD_ETAPA_ENSINO==32 & ID_MAIS_EDUCACAO==1
gen n_turmas_mais_educ_em_inte_4=1 if FK_COD_ETAPA_ENSINO==33 & ID_MAIS_EDUCACAO==1
gen n_turmas_mais_educ_em_inte_ns=1 if FK_COD_ETAPA_ENSINO==34 & ID_MAIS_EDUCACAO==1

gen n_turmas_fund_5_8anos=1 if FK_COD_ETAPA_ENSINO==8
gen n_turmas_fund_6_8anos=1 if FK_COD_ETAPA_ENSINO==9
gen n_turmas_fund_7_8anos=1 if FK_COD_ETAPA_ENSINO==10
gen n_turmas_fund_8_8anos=1 if FK_COD_ETAPA_ENSINO==11

gen n_turmas_fund_6_9anos=1 if FK_COD_ETAPA_ENSINO==19
gen n_turmas_fund_7_9anos=1 if FK_COD_ETAPA_ENSINO==20
gen n_turmas_fund_8_9anos=1 if FK_COD_ETAPA_ENSINO==21
gen n_turmas_fund_9_9anos=1 if FK_COD_ETAPA_ENSINO==41

gen n_turmas_mais_educ_fund_5_8anos=1 if FK_COD_ETAPA_ENSINO==8 & ID_MAIS_EDUCACAO==1
gen n_turmas_mais_educ_fund_6_8anos=1 if FK_COD_ETAPA_ENSINO==9 & ID_MAIS_EDUCACAO==1
gen n_turmas_mais_educ_fund_7_8anos=1 if FK_COD_ETAPA_ENSINO==10 & ID_MAIS_EDUCACAO==1
gen n_turmas_mais_educ_fund_8_8anos=1 if FK_COD_ETAPA_ENSINO==11 & ID_MAIS_EDUCACAO==1

gen n_turmas_mais_educ_fund_6_9anos=1 if FK_COD_ETAPA_ENSINO==19 & ID_MAIS_EDUCACAO==1
gen n_turmas_mais_educ_fund_7_9anos=1 if FK_COD_ETAPA_ENSINO==20 & ID_MAIS_EDUCACAO==1
gen n_turmas_mais_educ_fund_8_9anos=1 if FK_COD_ETAPA_ENSINO==21 & ID_MAIS_EDUCACAO==1
gen n_turmas_mais_educ_fund_9_9anos=1 if FK_COD_ETAPA_ENSINO==41 & ID_MAIS_EDUCACAO==1
compress
# delimit ;
collapse 
(sum) n_turmas_em_1-n_turmas_mais_educ_em_3
(sum) n_turmas_em_inte_1-n_turmas_mais_educ_em_inte_ns
(sum) n_turmas_fund_5_8anos-n_turmas_mais_educ_fund_9_9anos
, by(codigo_escola)
;
# delimit cr
save "F:\bases_dta\censo_escolar\2015\censo_escolar2015_turmas_col(`x').dta", replace

}

/*---------------------------Dados de Matrícula--------------------------------*/
foreach x in "NORDESTE" "SUDESTE" "CO"{
clear all
set more off
set trace on
*import delimited "$dropboxA/CENSO ESCOLAR 2002 - 2017\micro_censo_escolar_2015\MicrodCenso Escolar2015/DADOS\MATRICULA_NORDESTE.CSV", delimiter("|")
import delimited "D:\2015\DADOS\MATRICULA_`x'.CSV", delimiter("|")
# delimit ;
keep
/*num_idade 
tp_sexo 
tp_cor_raca 
id_zona_residencial 
id_n_t_e_p 
fk_cod_mod_ensino 
fk_cod_etapa_ensino
pk_cod_entidade 
fk_cod_estado_escola*/
nu_idade
tp_sexo
tp_cor_raca
tp_zona_residencial
in_transporte_publico

tp_etapa_ensino
co_entidade
co_uf
;
# delimit cr

generate SIGLA = "."
replace SIGLA = "PE" if co_uf == 26
replace SIGLA = "GO" if co_uf == 52
replace SIGLA = "CE" if co_uf == 23
replace SIGLA = "RJ" if co_uf == 33
replace SIGLA = "SP" if co_uf == 35
replace SIGLA = "ES" if co_uf == 32
rename nu_idade NUM_IDADE
rename tp_sexo TP_SEXO
rename tp_cor_raca TP_COR_RACA
rename tp_zona_residencial ID_ZONA_RESIDENCIAL
rename in_transporte_publico ID_N_T_E_P
rename tp_etapa_ensino FK_COD_ETAPA_ENSINO
rename co_entidade codigo_escola
rename co_uf codigo_uf


save "F:\bases_dta\censo_escolar\2015\censo_escolar2015_matriculas_`x'.dta", replace
}


use "F:\bases_dta\censo_escolar\2015\censo_escolar2015_matriculas_NORDESTE.dta", clear
append using "F:\bases_dta\censo_escolar\2015\censo_escolar2015_matriculas_SUDESTE.dta"
append using "F:\bases_dta\censo_escolar\2015\censo_escolar2015_matriculas_CO.dta"

save "F:\bases_dta\censo_escolar\2015\censo_escolar2015_matriculas.dta", replace

foreach x in "PE" "CE" "RJ" "SP" "ES" "GO" {
clear all
set more off
set trace on
use "F:\bases_dta\censo_escolar\2015\censo_escolar2015_matriculas.dta", clear

keep if SIGLA=="`x'"
/*
variáveis, por série: 
número de alunos
número de mulheres
número de brancos
número de alunos que pegam transporte público
média de idade
proporção de mulheres
proporção de brancos
proporção de alunos que usam transporte público
*/
/*gerando variáveis de ensino fundamental*/
*variáveis dummy para soma, para quando der collapse
gen n_alunos_fund_5_8anos=1 if FK_COD_ETAPA_ENSINO==8
gen n_alunos_fund_6_8anos=1 if FK_COD_ETAPA_ENSINO==9
gen n_alunos_fund_7_8anos=1 if FK_COD_ETAPA_ENSINO==10
gen n_alunos_fund_8_8anos=1 if FK_COD_ETAPA_ENSINO==11
gen n_alunos_fund_6_9anos=1 if FK_COD_ETAPA_ENSINO==19
gen n_alunos_fund_7_9anos=1 if FK_COD_ETAPA_ENSINO==20
gen n_alunos_fund_8_9anos=1 if FK_COD_ETAPA_ENSINO==21
gen n_alunos_fund_9_9anos=1 if FK_COD_ETAPA_ENSINO==41

gen n_mulheres_fund_5_8anos=1 if FK_COD_ETAPA_ENSINO==8 & TP_SEXO==2
gen n_mulheres_fund_6_8anos=1 if FK_COD_ETAPA_ENSINO==9 & TP_SEXO==2
gen n_mulheres_fund_7_8anos=1 if FK_COD_ETAPA_ENSINO==10 & TP_SEXO==2
gen n_mulheres_fund_8_8anos=1 if FK_COD_ETAPA_ENSINO==11 & TP_SEXO==2
gen n_mulheres_fund_6_9anos=1 if FK_COD_ETAPA_ENSINO==19 & TP_SEXO==2
gen n_mulheres_fund_7_9anos=1 if FK_COD_ETAPA_ENSINO==20 & TP_SEXO==2
gen n_mulheres_fund_8_9anos=1 if FK_COD_ETAPA_ENSINO==21 & TP_SEXO==2
gen n_mulheres_fund_9_9anos=1 if FK_COD_ETAPA_ENSINO==41 & TP_SEXO==2

gen n_brancos_fund_5_8anos=1 if FK_COD_ETAPA_ENSINO==8 & TP_COR_RACA==1
gen n_brancos_fund_6_8anos=1 if FK_COD_ETAPA_ENSINO==9 & TP_COR_RACA==1
gen n_brancos_fund_7_8anos=1 if FK_COD_ETAPA_ENSINO==10 & TP_COR_RACA==1
gen n_brancos_fund_8_8anos=1 if FK_COD_ETAPA_ENSINO==11 & TP_COR_RACA==1
gen n_brancos_fund_6_9anos=1 if FK_COD_ETAPA_ENSINO==19 & TP_COR_RACA==1
gen n_brancos_fund_7_9anos=1 if FK_COD_ETAPA_ENSINO==20 & TP_COR_RACA==1
gen n_brancos_fund_8_9anos=1 if FK_COD_ETAPA_ENSINO==21 & TP_COR_RACA==1
gen n_brancos_fund_9_9anos=1 if FK_COD_ETAPA_ENSINO==41 & TP_COR_RACA==1

gen n_transp_pub_fund_5_8anos=1 if FK_COD_ETAPA_ENSINO==8 & ID_N_T_E_P==1
gen n_transp_pub_fund_6_8anos=1 if FK_COD_ETAPA_ENSINO==9 & ID_N_T_E_P==1
gen n_transp_pub_fund_7_8anos=1 if FK_COD_ETAPA_ENSINO==10 & ID_N_T_E_P==1
gen n_transp_pub_fund_8_8anos=1 if FK_COD_ETAPA_ENSINO==11 & ID_N_T_E_P==1
gen n_transp_pub_fund_6_9anos=1 if FK_COD_ETAPA_ENSINO==19 & ID_N_T_E_P==1
gen n_transp_pub_fund_7_9anos=1 if FK_COD_ETAPA_ENSINO==20 & ID_N_T_E_P==1
gen n_transp_pub_fund_8_9anos=1 if FK_COD_ETAPA_ENSINO==21 & ID_N_T_E_P==1
gen n_transp_pub_fund_9_9anos=1 if FK_COD_ETAPA_ENSINO==41 & ID_N_T_E_P==1

*variáveis para média, quando der collapse

gen m_idade_fund_5_8anos=NUM_IDADE if FK_COD_ETAPA_ENSINO==8
gen m_idade_fund_6_8anos=NUM_IDADE if FK_COD_ETAPA_ENSINO==9
gen m_idade_fund_7_8anos=NUM_IDADE if FK_COD_ETAPA_ENSINO==10
gen m_idade_fund_8_8anos=NUM_IDADE if FK_COD_ETAPA_ENSINO==11
gen m_idade_fund_6_9anos=NUM_IDADE if FK_COD_ETAPA_ENSINO==19
gen m_idade_fund_7_9anos=NUM_IDADE if FK_COD_ETAPA_ENSINO==20
gen m_idade_fund_8_9anos=NUM_IDADE if FK_COD_ETAPA_ENSINO==21
gen m_idade_fund_9_9anos=NUM_IDADE if FK_COD_ETAPA_ENSINO==41

*variáveis para proporção

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

/*gerando variáveis de ensino médio*/
*variáveis dummy para soma, para quando der collapse
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
*variáveis para média, quando der collapse

gen m_idade_em_1=NUM_IDADE if FK_COD_ETAPA_ENSINO==25
gen m_idade_em_2=NUM_IDADE if FK_COD_ETAPA_ENSINO==26
gen m_idade_em_3=NUM_IDADE if FK_COD_ETAPA_ENSINO==27

*gerar variáveis para utitlizar na proporção

gen p_mulheres_em_1=.
replace p_mulheres_em_1=1 if FK_COD_ETAPA_ENSINO==25 & TP_SEXO==2
replace p_mulheres_em_1=0 if FK_COD_ETAPA_ENSINO==25 & TP_SEXO==1

gen p_mulheres_em_2=.
replace p_mulheres_em_2=1 if FK_COD_ETAPA_ENSINO==26 & TP_SEXO==2
replace p_mulheres_em_2=0 if FK_COD_ETAPA_ENSINO==26 & TP_SEXO==1

gen p_mulheres_em_3=.
replace p_mulheres_em_3=1 if FK_COD_ETAPA_ENSINO==27 & TP_SEXO==2
replace p_mulheres_em_3=0 if FK_COD_ETAPA_ENSINO==27 & TP_SEXO==1

gen p_brancos_em_1=.
replace p_brancos_em_1=1 if FK_COD_ETAPA_ENSINO==25 & TP_COR_RACA==1
replace p_brancos_em_1=0 if FK_COD_ETAPA_ENSINO==25 & (TP_COR_RACA==2 | TP_COR_RACA==3 | TP_COR_RACA==4 | TP_COR_RACA==5)

gen p_brancos_em_2=.
replace p_brancos_em_2=1 if FK_COD_ETAPA_ENSINO==26 & TP_COR_RACA==1
replace p_brancos_em_2=0 if FK_COD_ETAPA_ENSINO==26 & (TP_COR_RACA==2 | TP_COR_RACA==3 | TP_COR_RACA==4 | TP_COR_RACA==5)

gen p_brancos_em_3=.
replace p_brancos_em_3=1 if FK_COD_ETAPA_ENSINO==27 & TP_COR_RACA==1
replace p_brancos_em_3=0 if FK_COD_ETAPA_ENSINO==27 & (TP_COR_RACA==2 | TP_COR_RACA==3 | TP_COR_RACA==4 | TP_COR_RACA==5)

gen p_alu_transporte_publico_em_1=.
replace p_alu_transporte_publico_em_1=1 if FK_COD_ETAPA_ENSINO==25 & ID_N_T_E_P==1
replace p_alu_transporte_publico_em_1=0 if FK_COD_ETAPA_ENSINO==25 & ID_N_T_E_P==0

gen p_alu_transporte_publico_em_2=.
replace p_alu_transporte_publico_em_2=1 if FK_COD_ETAPA_ENSINO==26 & ID_N_T_E_P==1
replace p_alu_transporte_publico_em_2=0 if FK_COD_ETAPA_ENSINO==26 & ID_N_T_E_P==0

gen p_alu_transporte_publico_em_3=.
replace p_alu_transporte_publico_em_3=1 if FK_COD_ETAPA_ENSINO==27 & ID_N_T_E_P==1
replace p_alu_transporte_publico_em_3=0 if FK_COD_ETAPA_ENSINO==27 & ID_N_T_E_P==0


/*gerando variáveis de ensino médio profissionalizante (integrado)*/ 
*variáveis dummy para soma, para quando der collapse




gen n_alunos_em_inte_1=1 if FK_COD_ETAPA_ENSINO==30
gen n_alunos_em_inte_2=1 if FK_COD_ETAPA_ENSINO==31
gen n_alunos_em_inte_3=1 if FK_COD_ETAPA_ENSINO==32
gen n_alunos_em_inte_4=1 if FK_COD_ETAPA_ENSINO==33
gen n_alunos_em_inte_ns=1 if FK_COD_ETAPA_ENSINO==34

gen n_mulheres_em_inte_1=1 if FK_COD_ETAPA_ENSINO==30 & TP_SEXO==2
gen n_mulheres_em_inte_2=1 if FK_COD_ETAPA_ENSINO==31 & TP_SEXO==2
gen n_mulheres_em_inte_3=1 if FK_COD_ETAPA_ENSINO==32 & TP_SEXO==2
gen n_mulheres_em_inte_4=1 if FK_COD_ETAPA_ENSINO==33 & TP_SEXO==2
gen n_mulheres_em_inte_ns=1 if FK_COD_ETAPA_ENSINO==34 & TP_SEXO==2

gen n_brancos_em_inte_1=1 if FK_COD_ETAPA_ENSINO==30 & TP_COR_RACA==1
gen n_brancos_em_inte_2=1 if FK_COD_ETAPA_ENSINO==31 & TP_COR_RACA==1
gen n_brancos_em_inte_3=1 if FK_COD_ETAPA_ENSINO==32 & TP_COR_RACA==1
gen n_brancos_em_inte_4=1 if FK_COD_ETAPA_ENSINO==33 & TP_COR_RACA==1
gen n_brancos_em_inte_ns=1 if FK_COD_ETAPA_ENSINO==34 & TP_COR_RACA==1

gen n_alu_transp_publico_em_inte_1=1 if FK_COD_ETAPA_ENSINO==30 & ID_N_T_E_P==1
gen n_alu_transp_publico_em_inte_2=1 if FK_COD_ETAPA_ENSINO==31 & ID_N_T_E_P==1
gen n_alu_transp_publico_em_inte_3=1 if FK_COD_ETAPA_ENSINO==32 & ID_N_T_E_P==1
gen n_alu_transp_publico_em_inte_4=1 if FK_COD_ETAPA_ENSINO==33 & ID_N_T_E_P==1
gen n_alu_transp_publico_em_inte_ns=1 if FK_COD_ETAPA_ENSINO==34 & ID_N_T_E_P==1

*variáveis para média, quando der collapse
gen m_idade_em_inte_1=NUM_IDADE if FK_COD_ETAPA_ENSINO==30
gen m_idade_em_inte_2=NUM_IDADE if FK_COD_ETAPA_ENSINO==31
gen m_idade_em_inte_3=NUM_IDADE if FK_COD_ETAPA_ENSINO==32
gen m_idade_em_inte_4=NUM_IDADE if FK_COD_ETAPA_ENSINO==33
gen m_idade_em_inte_ns=NUM_IDADE if FK_COD_ETAPA_ENSINO==34

*gerar variáveis para utitlizar na proporção

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
save "F:\bases_dta\censo_escolar\2015\censo_escolar2015_matriculas_col(`x').dta", replace


}

/*---------------------------Dados de Docentes--------------------------------*/

foreach x in "NORDESTE" "SUDESTE" "CO"{
clear all
set more off
set trace on
*import delimited "$dropboxA/CENSO ESCOLAR 2002 - 2017\micro_censo_escolar_2015\MicrodCenso Escolar2015/DADOS\DOCENTES_`x'.CSV", delimiter("|")

import delimited "D:\2015\DADOS\DOCENTES_`x'.CSV", delimiter("|")
# delimit ;
keep
/*
fk_cod_escolaridade 
fk_cod_etapa_ensino 
pk_cod_entidade 
fk_cod_estado
*/
/**/
tp_escolaridade
tp_etapa_ensino
co_entidade
co_uf
;
# delimit cr

generate SIGLA = "."
replace SIGLA = "PE" if co_uf == 26
replace SIGLA = "GO" if co_uf == 52
replace SIGLA = "CE" if co_uf == 23
replace SIGLA = "RJ" if co_uf == 33
replace SIGLA = "SP" if co_uf == 35
replace SIGLA = "ES" if co_uf == 32

rename tp_escolaridade FK_COD_ESCOLARIDADE
rename tp_etapa_ensino FK_COD_ETAPA_ENSINO
rename co_entidade codigo_escola
rename co_uf codigo_uf
save "F:\bases_dta\censo_escolar\2015\censo_escolar2015_docentes_`x'.dta", replace

}
use "F:\bases_dta\censo_escolar\2015\censo_escolar2015_docentes_NORDESTE.dta", clear
append using "F:\bases_dta\censo_escolar\2015\censo_escolar2015_docentes_SUDESTE.dta"

append using "F:\bases_dta\censo_escolar\2015\censo_escolar2015_docentes_CO.dta"

save "F:\bases_dta\censo_escolar\2015\censo_escolar2015_docentes.dta", replace


foreach x in "PE" "CE" "RJ" "SP" "ES" "GO" {
clear all
set more off
set trace on
use "F:\bases_dta\censo_escolar\2015\censo_escolar2015_docentes.dta", clear

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

gen n_profs_sup_fund_5_8anos=1 if FK_COD_ETAPA_ENSINO==8 & FK_COD_ESCOLARIDADE==4 
gen n_profs_sup_fund_6_8anos=1 if FK_COD_ETAPA_ENSINO==9 & FK_COD_ESCOLARIDADE==4 
gen n_profs_sup_fund_7_8anos=1 if FK_COD_ETAPA_ENSINO==10 & FK_COD_ESCOLARIDADE==4
gen n_profs_sup_fund_8_8anos=1 if FK_COD_ETAPA_ENSINO==11 & FK_COD_ESCOLARIDADE==4 
gen n_profs_sup_fund_6_9anos=1 if FK_COD_ETAPA_ENSINO==19 & FK_COD_ESCOLARIDADE==4 
gen n_profs_sup_fund_7_9anos=1 if FK_COD_ETAPA_ENSINO==20 & FK_COD_ESCOLARIDADE==4 
gen n_profs_sup_fund_8_9anos=1 if FK_COD_ETAPA_ENSINO==21 & FK_COD_ESCOLARIDADE==4 
gen n_profs_sup_fund_9_9anos=1 if FK_COD_ETAPA_ENSINO==41 & FK_COD_ESCOLARIDADE==4

gen p_profs_sup_fund_5_8anos=.
replace p_profs_sup_fund_5_8anos=1 if FK_COD_ETAPA_ENSINO==8 & FK_COD_ESCOLARIDADE==4 
replace p_profs_sup_fund_5_8anos=0 if FK_COD_ETAPA_ENSINO==8 & (FK_COD_ESCOLARIDADE==1 | FK_COD_ESCOLARIDADE==2 | FK_COD_ESCOLARIDADE==3) 

gen p_profs_sup_fund_6_8anos=.
replace p_profs_sup_fund_6_8anos=1 if FK_COD_ETAPA_ENSINO==9 & FK_COD_ESCOLARIDADE==4
replace p_profs_sup_fund_6_8anos=0 if FK_COD_ETAPA_ENSINO==9 & (FK_COD_ESCOLARIDADE==1 | FK_COD_ESCOLARIDADE==2 | FK_COD_ESCOLARIDADE==3)

gen p_profs_sup_fund_7_8anos=.
replace p_profs_sup_fund_7_8anos=1 if FK_COD_ETAPA_ENSINO==10 & FK_COD_ESCOLARIDADE==4
replace p_profs_sup_fund_7_8anos=0 if FK_COD_ETAPA_ENSINO==10 & (FK_COD_ESCOLARIDADE==1 | FK_COD_ESCOLARIDADE==2 | FK_COD_ESCOLARIDADE==3)

gen p_profs_sup_fund_8_8anos=.
replace p_profs_sup_fund_8_8anos=1 if FK_COD_ETAPA_ENSINO==11 & FK_COD_ESCOLARIDADE==4 
replace p_profs_sup_fund_8_8anos=0 if FK_COD_ETAPA_ENSINO==11 & (FK_COD_ESCOLARIDADE==1 | FK_COD_ESCOLARIDADE==2 | FK_COD_ESCOLARIDADE==3 )

gen p_profs_sup_fund_6_9anos=.
replace p_profs_sup_fund_6_9anos=1 if FK_COD_ETAPA_ENSINO==19 & FK_COD_ESCOLARIDADE==4 
replace p_profs_sup_fund_6_9anos=0 if FK_COD_ETAPA_ENSINO==19 & (FK_COD_ESCOLARIDADE==1 | FK_COD_ESCOLARIDADE==2 | FK_COD_ESCOLARIDADE==3)

gen p_profs_sup_fund_7_9anos=.
replace p_profs_sup_fund_7_9anos=1 if FK_COD_ETAPA_ENSINO==20 & FK_COD_ESCOLARIDADE==4 
replace p_profs_sup_fund_7_9anos=0 if FK_COD_ETAPA_ENSINO==20 & (FK_COD_ESCOLARIDADE==1 | FK_COD_ESCOLARIDADE==2 | FK_COD_ESCOLARIDADE==3 )

gen p_profs_sup_fund_8_9anos=.
replace p_profs_sup_fund_8_9anos=1 if FK_COD_ETAPA_ENSINO==21 & FK_COD_ESCOLARIDADE==4 
replace p_profs_sup_fund_8_9anos=0 if FK_COD_ETAPA_ENSINO==21 & (FK_COD_ESCOLARIDADE==1 | FK_COD_ESCOLARIDADE==2 | FK_COD_ESCOLARIDADE==3)

gen p_profs_sup_fund_9_9anos=.
replace p_profs_sup_fund_9_9anos=1 if FK_COD_ETAPA_ENSINO==41 & FK_COD_ESCOLARIDADE==4 
replace p_profs_sup_fund_9_9anos=0 if FK_COD_ETAPA_ENSINO==41 & (FK_COD_ESCOLARIDADE==1 | FK_COD_ESCOLARIDADE==2 | FK_COD_ESCOLARIDADE==3)

/*gerando variáveis de ensino médio*/
gen n_profs_em_1=1 if FK_COD_ETAPA_ENSINO==25
gen n_profs_em_2=1 if FK_COD_ETAPA_ENSINO==26
gen n_profs_em_3=1 if FK_COD_ETAPA_ENSINO==27

gen n_profs_sup_em_1=1 if FK_COD_ETAPA_ENSINO==25 & FK_COD_ESCOLARIDADE==4
gen n_profs_sup_em_2=1 if FK_COD_ETAPA_ENSINO==26 & FK_COD_ESCOLARIDADE==4 
gen n_profs_sup_em_3=1 if FK_COD_ETAPA_ENSINO==27 & FK_COD_ESCOLARIDADE==4

gen p_profs_sup_em_1=.
replace p_profs_sup_em_1=1 if FK_COD_ETAPA_ENSINO==25 & FK_COD_ESCOLARIDADE==4
replace p_profs_sup_em_1=0 if FK_COD_ETAPA_ENSINO==25 & (FK_COD_ESCOLARIDADE==1 | FK_COD_ESCOLARIDADE==2 | FK_COD_ESCOLARIDADE==3 )

gen p_profs_sup_em_2=.
replace p_profs_sup_em_2=1 if FK_COD_ETAPA_ENSINO==26 & FK_COD_ESCOLARIDADE==4
replace p_profs_sup_em_2=0 if FK_COD_ETAPA_ENSINO==26 & (FK_COD_ESCOLARIDADE==1 | FK_COD_ESCOLARIDADE==2 | FK_COD_ESCOLARIDADE==3)

gen p_profs_sup_em_3=.
replace p_profs_sup_em_3=1 if FK_COD_ETAPA_ENSINO==27 & FK_COD_ESCOLARIDADE==4
replace p_profs_sup_em_3=0 if FK_COD_ETAPA_ENSINO==27 & (FK_COD_ESCOLARIDADE==1 | FK_COD_ESCOLARIDADE==2 | FK_COD_ESCOLARIDADE==3)

/*gerando variáveis de ensino médio profissionalizante*/


gen n_profs_em_inte_1=1 if FK_COD_ETAPA_ENSINO==30
gen n_profs_em_inte_2=1 if FK_COD_ETAPA_ENSINO==31
gen n_profs_em_inte_3=1 if FK_COD_ETAPA_ENSINO==32
gen n_profs_em_inte_4=1 if FK_COD_ETAPA_ENSINO==33
gen n_profs_em_inte_ns=1 if FK_COD_ETAPA_ENSINO==34

gen n_profs_sup_em_inte_1=1 if FK_COD_ETAPA_ENSINO==30 & FK_COD_ESCOLARIDADE==4
gen n_profs_sup_em_inte_2=1 if FK_COD_ETAPA_ENSINO==31 & FK_COD_ESCOLARIDADE==4
gen n_profs_sup_em_inte_3=1 if FK_COD_ETAPA_ENSINO==32 & FK_COD_ESCOLARIDADE==4
gen n_profs_sup_em_inte_4=1 if FK_COD_ETAPA_ENSINO==33 & FK_COD_ESCOLARIDADE==4
gen n_profs_sup_em_inte_ns=1 if FK_COD_ETAPA_ENSINO==34 & FK_COD_ESCOLARIDADE==4 

gen p_profs_sup_em_inte_1=.
replace p_profs_sup_em_inte_1=1 if FK_COD_ETAPA_ENSINO==30 & FK_COD_ESCOLARIDADE==4
replace p_profs_sup_em_inte_1=0 if FK_COD_ETAPA_ENSINO==30 & (FK_COD_ESCOLARIDADE==1 | FK_COD_ESCOLARIDADE==2 | FK_COD_ESCOLARIDADE==3 )

gen p_profs_sup_em_inte_2=.
replace p_profs_sup_em_inte_2=1 if FK_COD_ETAPA_ENSINO==31 & FK_COD_ESCOLARIDADE==4
replace p_profs_sup_em_inte_2=0 if FK_COD_ETAPA_ENSINO==31 & (FK_COD_ESCOLARIDADE==1 | FK_COD_ESCOLARIDADE==2 | FK_COD_ESCOLARIDADE==3 )

gen p_profs_sup_em_inte_3=.
replace p_profs_sup_em_inte_3=1 if FK_COD_ETAPA_ENSINO==32 & FK_COD_ESCOLARIDADE==4 
replace p_profs_sup_em_inte_3=0 if FK_COD_ETAPA_ENSINO==32 & (FK_COD_ESCOLARIDADE==1 | FK_COD_ESCOLARIDADE==2 | FK_COD_ESCOLARIDADE==3)

gen p_profs_sup_em_inte_4=.
replace p_profs_sup_em_inte_4=1 if FK_COD_ETAPA_ENSINO==33 & FK_COD_ESCOLARIDADE==4 
replace p_profs_sup_em_inte_4=0 if FK_COD_ETAPA_ENSINO==33 & (FK_COD_ESCOLARIDADE==1 | FK_COD_ESCOLARIDADE==2 | FK_COD_ESCOLARIDADE==3)

gen p_profs_sup_em_inte_ns=.
replace p_profs_sup_em_inte_ns=1 if FK_COD_ETAPA_ENSINO==34 & FK_COD_ESCOLARIDADE==4
replace p_profs_sup_em_inte_ns=0 if FK_COD_ETAPA_ENSINO==34 & (FK_COD_ESCOLARIDADE==1 | FK_COD_ESCOLARIDADE==2 | FK_COD_ESCOLARIDADE==3)
compress
# delimit ;
collapse 
(sum) n_profs_fund_5_8anos-n_profs_sup_fund_9_9anos  
(mean) p_profs_sup_fund_5_8anos-p_profs_sup_fund_9_9anos 
(sum) n_profs_em_1-n_profs_sup_em_3 
(mean) p_profs_sup_em_1	p_profs_sup_em_2 p_profs_sup_em_3 
(sum) n_profs_em_inte_1-n_profs_sup_em_inte_ns 
(mean) p_profs_sup_em_inte_1-p_profs_sup_em_inte_ns


, by (codigo_escola);
# delimit cr
save "F:\bases_dta\censo_escolar\2015\censo_escolar2015_docentes_col(`x').dta", replace

}


/****************************Merging das bases*******************************/

foreach x in "PE" "CE" "RJ" "SP" "ES" "GO" {
use "F:\bases_dta\censo_escolar\2015\censo_escolar2015_escolas.dta", clear
generate SIGLA = "."
replace SIGLA = "PE" if codigo_uf == 26
replace SIGLA = "GO" if codigo_uf == 52
replace SIGLA = "CE" if codigo_uf == 23
replace SIGLA = "RJ" if codigo_uf == 33
replace SIGLA = "SP" if codigo_uf == 35
replace SIGLA = "ES" if codigo_uf == 32
keep if SIGLA=="`x'"
merge 1:1 codigo_escola using "F:\bases_dta\censo_escolar\2015\censo_escolar2015_turmas_col(`x').dta"
drop _merge
merge 1:1 codigo_escola using "F:\bases_dta\censo_escolar\2015\censo_escolar2015_matriculas_col(`x').dta"
drop _merge
merge 1:1 codigo_escola using "F:\bases_dta\censo_escolar\2015\censo_escolar2015_docentes_col(`x').dta"
rename nu_ano_censo ano_censo
save "F:\bases_dta\censo_escolar\2015\censo_escolar2015_`x'.dta", replace

}


timer off 1

timer list 
