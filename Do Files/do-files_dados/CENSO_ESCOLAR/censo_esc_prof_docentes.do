/*
CENSO ESCOLAR - professores/docentes
*/
sysdir set PLUS \\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\ado
capture log close
clear all
set more off, permanently

global folderservidor "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"
log using "$folderservidor\\logfiles/censo_escolar_professores_docentes.log", replace

/**********************************************************************************

2003

extraindo informações de professores do censo escolar 2003

**********************************************************************************/
use "\\fs-eesp-01\EESP-BD-01\BASES-CMICRO\Educacao\Censo Escolar\Censo Escolar 2003\DADOS\DADOS_CENSOESC.dta", clear
keep ano mascara ///
	vdg1c3 vdg1c4  vdg1c6 vdg1c9 ///
	vdg161 vdg162 vdg163 vdg164 vdg165 vdg166 vdg167 ///
	vdg171 vdg172 vdg173 vdg174 vdg175 vdg176 vdg177 ///
	vdg1j1 vdg1j2 vdg1j3 vdg1j4 vdg1j5 vdg1j6 vdg1j7 ///
	vdg1k1 vdg1k2 vdg1k3 vdg1k4 vdg1k5 vdg1k6 vdg1k7 ///
	vdg1d1 vdg1d2 vdg1d3 vdg1d4 vdg1d5 vdg1d6 vdg1d7 

/*	VDG1C3 VDG1C4 VDG1C3 VDG1C4 VDG1CB  VDG1C5 VDG1C6 VDG1C9 ///
	VDG161 VDG162 VDG163 VDG164 VDG165 VDG166 VDG167 ///
	VDG171 VDG172 VDG173 VDG174 VDG175 VDG176 VDG177 ///
	VDG1G1 VDG1G2 VDG1G3 VDG1G4 VDG1G5 VDG1G6 VDG1G7 ///
	VDG1J1 VDG1J2 VDG1J3 VDG1J4 VDG1J5 VDG1J6 VDG1J7 ///
	VDG1K1 VDG1K2 VDG1K3 VDG1K4 VDG1K5 VDG1K6 VDG1K7 ///
	VDG1D1 VDG1D2 VDG1D3 VDG1D4 VDG1D5 VDG1D6 VDG1D7 
* na base não há informação de curso nomral em nível médio (?)
*/
/*
VDG1C3 Nº de Professores no Ensino Fundamental 
VDG1C4 Nº de Professores no Ensino Médio e Médio Profissionalizante 
*VDG1CB Nº de Professores no Curso Normal em Nível Médio 
VDG1C5 Nº de Professores na Educação Especial 
VDG1C6 Nº de Professores na Educação de Jovens e Adultos/Supletivo 
VDG1C9 Nº de Professores na Educação Profissional Nível Técnico 
*/
	
rename vdg1c3 n_prof_ef
rename vdg1c4 n_prof_em_ep
rename vdg1c6 n_prof_eja
rename vdg1c9 n_prof_tecn

local lista n_prof_ef n_prof_em_ep n_prof_eja n_prof_tecn
foreach x in `lista' {

replace `x' =0 if `x'==.
}

***************************************************************************
*NÚMERO DE PROFESSORES SEGUNDO NÍVEL/MODALIDADE DE ATUAÇÃO POR NÍVEL DE FORMAÇÃO
***************************************************************************
/*
Ensino Fundamental - 5ª à 8ª Série
VDG161 Com Fundamental (1º Grau) Incompleto 
VDG162 Com Fundamental (1º Grau) Completo 
VDG163 Com Médio (2º Grau) Magistério Completo 
VDG164 Com Médio (2º Grau) Outra Formação Completa 
VDG165 Superior (3º Grau) Licenciatura Completa 
VDG166 Superior (3º Grau) Completo sem Licenciatura Com Magistério 
VDG167 Superior (3º Grau) Completo sem Licenciatura Sem Magistério 
*/

rename vdg161 n_prof_ef_ef_incomp
rename vdg162 n_prof_ef_ef_comp
rename vdg163 n_prof_ef_em_mag_compl
rename vdg164 n_prof_ef_em_outra
rename vdg165 n_prof_ef_sup_lic_comp
rename vdg166 n_prof_ef_sup_com_mag
rename vdg167 n_prof_ef_sup_sem_mag

/*
gen ef_incompl=0
gen ef_comp =0
gen em_completo =0 
gen sup_completo = 0

essas serão os 4 tipos de diferenciação entre professores
ensino fundamental incompleto
ensino fundamental completo
ensino médio completo
superior completo
*/
	
local lista n_prof_ef_ef_incomp n_prof_ef_ef_comp n_prof_ef_em_mag_compl n_prof_ef_em_outra n_prof_ef_sup_lic_comp n_prof_ef_sup_com_mag n_prof_ef_sup_sem_mag
foreach x in `lista' {

replace `x' =0 if `x'==.
}

gen n_prof_ef_em = n_prof_ef_em_mag_compl + n_prof_ef_em_outra
drop n_prof_ef_em_mag_compl n_prof_ef_em_outra
gen n_prof_ef_sup =  n_prof_ef_sup_lic_comp + n_prof_ef_sup_com_mag + n_prof_ef_sup_sem_mag
drop n_prof_ef_sup_lic_comp n_prof_ef_sup_com_mag n_prof_ef_sup_sem_mag
/*
aqui serão quatro os tipos de número de professores no ensino médio
n_prof_ef_ef_incomp n_prof_ef_ef_comp n_prof_ef_em n_prof_ef_sup

*/


gen n_prof_ef_9_ef_incomp=0
gen n_prof_ef_9_ef_comp=0
gen n_prof_ef_9_em=0
gen n_prof_ef_9_sup=0

/*
Ensino Médio e Médio Profissionalizante
VDG171 Com Fundamental (1º Grau) Incompleto 865 7 Numérica
VDG172 Com Fundamental (1º Grau) Completo 872 7 Numérica
VDG173 Com Médio (2º Grau) Magistério Completo 879 7 Numérica
VDG174 Com Médio (2º Grau) Outra Formação Completa 886 7 Numérica
VDG175 Superior (3º Grau) Licenciatura Completa 893 7 Numérica
VDG176 Superior (3º Grau) Completo sem Licenciatura Com Magistério 
VDG177 Superior (3º Grau) Completo sem Licenciatura Sem Magistério 
*/

rename vdg171 n_prof_em_ef_incomp
rename vdg172 n_prof_em_ef_comp
rename vdg173 n_prof_em_em_mag_compl
rename vdg174 n_prof_em_em_outra
rename vdg175 n_prof_em_sup_lic_comp
rename vdg176 n_prof_em_sup_com_mag
rename vdg177 n_prof_em_sup_sem_mag

local lista n_prof_em_ef_incomp n_prof_em_ef_comp n_prof_em_em_mag_compl n_prof_em_em_outra n_prof_em_sup_lic_comp n_prof_em_sup_com_mag n_prof_em_sup_sem_mag
foreach x in `lista' {

replace `x' =0 if `x'==.
}

gen n_prof_em_em = n_prof_em_em_mag_compl + n_prof_em_em_outra
drop n_prof_em_em_mag_compl n_prof_em_em_outra

gen n_prof_em_sup =  n_prof_em_sup_lic_comp + n_prof_em_sup_com_mag + n_prof_em_sup_sem_mag
drop n_prof_em_sup_lic_comp n_prof_em_sup_com_mag n_prof_em_sup_sem_mag

/*
aqui serão quatro os tipos de número de professores no ensino médio
n_prof_em_ef_incomp n_prof_em_ef_comp n_prof_em_em n_prof_em_sup

*/

/*
Educação de Jovens e Adultos (Supletivo) - 5ª à 8ª Série
VDG1J1 Com Fundamental (1º Grau) Incompleto 1159 7 Numérica
VDG1J2 Com Fundamental (1º Grau) Completo 1166 7 Numérica
VDG1J3 Com Médio (2º Grau) Magistério Completo 1173 7 Numérica
VDG1J4 Com Médio (2º Grau) Outra Formação Completa 1180 7 Numérica
VDG1J5 Superior (3º Grau) Licenciatura Completa 1187 7 Numérica
VDG1J6 Superior (3º Grau) Completo sem Licenciatura Com Magistério 1194 7 Numérica
VDG1J7 Superior (3º Grau) Completo sem Licenciatura Sem Magistério 1201 7 Numérica
*/
rename vdg1j1 n_prof_ef_eja_ef_incomp
rename vdg1j2 n_prof_ef_eja_ef_comp
rename vdg1j3 n_prof_ef_eja_em_mag_compl
rename vdg1j4 n_prof_ef_eja_em_outra
rename vdg1j5 n_prof_ef_eja_sup_lic_comp
rename vdg1j6 n_prof_ef_eja_sup_com_mag
rename vdg1j7 n_prof_ef_eja_sup_sem_mag

local lista n_prof_ef_eja_ef_incomp n_prof_ef_eja_ef_comp n_prof_ef_eja_em_mag_compl n_prof_ef_eja_em_outra n_prof_ef_eja_sup_lic_comp n_prof_ef_eja_sup_com_mag n_prof_ef_eja_sup_sem_mag
foreach x in `lista' {

replace `x' =0 if `x'==.
}

gen n_prof_ef_eja_em = n_prof_ef_eja_em_mag_compl + n_prof_ef_eja_em_outra
drop n_prof_ef_eja_em_mag_compl n_prof_ef_eja_em_outra

gen n_prof_ef_eja_sup =  n_prof_ef_eja_sup_lic_comp + n_prof_ef_eja_sup_com_mag + n_prof_ef_eja_sup_sem_mag
drop n_prof_ef_eja_sup_lic_comp n_prof_ef_eja_sup_com_mag n_prof_ef_eja_sup_sem_mag

/*
aqui serão quatro os tipos de número de professores no ensino médio
n_prof_ef_eja_ef_incomp n_prof_ef_eja_ef_comp n_prof_ef_eja_em n_prof_ef_eja_sup

*/
/*

Educação de Jovens e Adultos (Supletivo) - Ensino Médio
VDG1K1 Com Fundamental (1º Grau) Incompleto 1208 7 Numérica
VDG1K2 Com Fundamental (1º Grau) Completo 1215 7 Numérica
VDG1K3 Com Médio (2º Grau) Magistério Completo 1222 7 Numérica
VDG1K4 Com Médio (2º Grau) Outra Formação Completa 1229 7 Numérica
VDG1K5 Superior (3º Grau) Licenciatura Completa 1236 7 Numérica
VDG1K6 Superior (3º Grau) Completo sem Licenciatura Com Magistério 1243 7 Numérica
VDG1K7 Superior (3º Grau) Completo sem Licenciatura Sem Magistério 1250 7 Numérica

*/
rename vdg1k1 n_prof_em_eja_ef_incomp
rename vdg1k2 n_prof_em_eja_ef_comp
rename vdg1k3 n_prof_em_eja_em_mag_compl
rename vdg1k4 n_prof_em_eja_em_outra
rename vdg1k5 n_prof_em_eja_sup_lic_comp
rename vdg1k6 n_prof_em_eja_sup_com_mag
rename vdg1k7 n_prof_em_eja_sup_sem_mag

local lista n_prof_em_eja_ef_incomp n_prof_em_eja_ef_comp n_prof_em_eja_em_mag_compl n_prof_em_eja_em_outra n_prof_em_eja_sup_lic_comp n_prof_em_eja_sup_com_mag n_prof_em_eja_sup_sem_mag
foreach x in `lista' {

replace `x' =0 if `x'==.
}

gen n_prof_em_eja_em = n_prof_em_eja_em_mag_compl + n_prof_em_eja_em_outra
drop n_prof_em_eja_em_mag_compl n_prof_em_eja_em_outra

gen n_prof_em_eja_sup =  n_prof_em_eja_sup_lic_comp + n_prof_em_eja_sup_com_mag + n_prof_em_eja_sup_sem_mag
drop n_prof_em_eja_sup_lic_comp n_prof_em_eja_sup_com_mag n_prof_em_eja_sup_sem_mag

/*
aqui serão quatro os tipos de número de professores no ensino médio
n_prof_em_eja_ef_incomp n_prof_em_eja_ef_comp n_prof_em_eja_em n_prof_em_eja_sup
*/
/*
Educação Profissional - Nível Técnico
VDG1D1 Com Fundamental (1º Grau) Incompleto 1257 7 Numérica
VDG1D2 Com Fundamental (1º Grau) Completo 1264 7 Numérica
VDG1D3 Com Médio (2º Grau) Magistério Completo 1271 7 Numérica
VDG1D4 Com Médio (2º Grau) Outra Formação Completa 1278 7 Numérica
VDG1D5 Superior (3º Grau) Licenciatura Completa 1285 7 Numérica
VDG1D6 Superior (3º Grau) Completo sem Licenciatura Com Magistério 1292 7 Numérica
VDG1D7 Superior (3º Grau) Completo sem Licenciatura Sem Magistério 
*/
 
rename vdg1d1 n_prof_ep_nt_ef_incomp
rename vdg1d2 n_prof_ep_nt_ef_comp
rename vdg1d3 n_prof_ep_nt_em_mag_compl
rename vdg1d4 n_prof_ep_nt_em_outra
rename vdg1d5 n_prof_ep_nt_sup_lic_comp
rename vdg1d6 n_prof_ep_nt_sup_com_mag
rename vdg1d7 n_prof_ep_nt_sup_sem_mag


local lista n_prof_ep_nt_ef_incomp n_prof_ep_nt_ef_comp n_prof_ep_nt_em_mag_compl n_prof_ep_nt_em_outra n_prof_ep_nt_sup_lic_comp n_prof_ep_nt_sup_com_mag n_prof_ep_nt_sup_sem_mag
foreach x in `lista' {

replace `x' =0 if `x'==.
}

gen n_prof_ep_nt_em = n_prof_ep_nt_em_mag_compl + n_prof_ep_nt_em_outra
drop n_prof_ep_nt_em_mag_compl n_prof_ep_nt_em_outra

gen n_prof_ep_nt_sup =  n_prof_ep_nt_sup_lic_comp + n_prof_ep_nt_sup_com_mag + n_prof_ep_nt_sup_sem_mag
drop n_prof_ep_nt_sup_lic_comp n_prof_ep_nt_sup_com_mag n_prof_ep_nt_sup_sem_mag

/*
aqui serão quatro os tipos de número de professores no ensino médio
n_prof_ep_nt_ef_incomp n_prof_ep_nt_ef_comp n_prof_ep_nt_em n_prof_ep_nt_sup
*/

gen ano_censo_escolar_doc = ano

merge 1:1 mascara using "$folderservidor\censo_escolar\mascara censo (2003).dta"
save "$folderservidor\censo_escolar\censo_escolar_doc_2003.dta", replace 
/**********************************************************************************

2004

**********************************************************************************/
use "\\fs-eesp-01\EESP-BD-01\BASES-CMICRO\Educacao\Censo Escolar\Censo Escolar 2004\DADOS\DADOS_CENSOESC.dta", clear
keep ano mascara ///
	vdg1c3 vdg1c4  vdg1c6 vdg1c9 ///
	vdg161 vdg162 vdg163 vdg164 vdg165 vdg166 vdg167 ///
	vdg1m1 vdg1m2 vdg1m3 vdg1m4 vdg1m5 vdg1m6 vdg1m7 ///
	vdg171 vdg172 vdg173 vdg174 vdg175 vdg176 vdg177 ///
	vdg1j1 vdg1j2 vdg1j3 vdg1j4 vdg1j5 vdg1j6 vdg1j7 ///
	vdg1k1 vdg1k2 vdg1k3 vdg1k4 vdg1k5 vdg1k6 vdg1k7 ///
	vdg1d1 vdg1d2 vdg1d3 vdg1d4 vdg1d5 vdg1d6 vdg1d7 
/*	VDG1C3 VDG1C4 VDG1C3 VDG1C4 VDG1CB  VDG1C5 VDG1C6 VDG1C9 ///
	VDG161 VDG162 VDG163 VDG164 VDG165 VDG166 VDG167 ///
	VDG171 VDG172 VDG173 VDG174 VDG175 VDG176 VDG177 ///
	VDG1G1 VDG1G2 VDG1G3 VDG1G4 VDG1G5 VDG1G6 VDG1G7 ///
	VDG1J1 VDG1J2 VDG1J3 VDG1J4 VDG1J5 VDG1J6 VDG1J7 ///
	VDG1K1 VDG1K2 VDG1K3 VDG1K4 VDG1K5 VDG1K6 VDG1K7 ///
	VDG1D1 VDG1D2 VDG1D3 VDG1D4 VDG1D5 VDG1D6 VDG1D7 
* na base não há informação de curso nomral em nível médio (?)
*/
/*
VDG1C3 Nº de Professores no Ensino Fundamental 
VDG1C4 Nº de Professores no Ensino Médio e Médio Profissionalizante 
*VDG1CB Nº de Professores no Curso Normal em Nível Médio 
VDG1C5 Nº de Professores na Educação Especial 
VDG1C6 Nº de Professores na Educação de Jovens e Adultos/Supletivo 
VDG1C9 Nº de Professores na Educação Profissional Nível Técnico 
*/
	
rename vdg1c3 n_prof_ef
rename vdg1c4 n_prof_em_ep
rename vdg1c6 n_prof_eja
rename vdg1c9 n_prof_tecn

local lista n_prof_ef n_prof_em_ep n_prof_eja n_prof_tecn
foreach x in `lista' {

replace `x' =0 if `x'==.
}
***************************************************************************
*NÚMERO DE PROFESSORES SEGUNDO NÍVEL/MODALIDADE DE ATUAÇÃO POR NÍVEL DE FORMAÇÃO
***************************************************************************
/*
Ensino Fundamental - 5ª à 8ª Série
VDG161 Com Fundamental (1º Grau) Incompleto 
VDG162 Com Fundamental (1º Grau) Completo 
VDG163 Com Médio (2º Grau) Magistério Completo 
VDG164 Com Médio (2º Grau) Outra Formação Completa 
VDG165 Superior (3º Grau) Licenciatura Completa 
VDG166 Superior (3º Grau) Completo sem Licenciatura Com Magistério 
VDG167 Superior (3º Grau) Completo sem Licenciatura Sem Magistério 
*/

rename vdg161 n_prof_ef_ef_incomp
rename vdg162 n_prof_ef_ef_comp
rename vdg163 n_prof_ef_em_mag_compl
rename vdg164 n_prof_ef_em_outra
rename vdg165 n_prof_ef_sup_lic_comp
rename vdg166 n_prof_ef_sup_com_mag
rename vdg167 n_prof_ef_sup_sem_mag


local lista n_prof_ef_ef_incomp n_prof_ef_ef_comp n_prof_ef_em_mag_compl n_prof_ef_em_outra n_prof_ef_sup_lic_comp n_prof_ef_sup_com_mag n_prof_ef_sup_sem_mag
foreach x in `lista' {

replace `x' =0 if `x'==.
}

gen n_prof_ef_em = n_prof_ef_em_mag_compl + n_prof_ef_em_outra
drop n_prof_ef_em_mag_compl n_prof_ef_em_outra
gen n_prof_ef_sup =  n_prof_ef_sup_lic_comp + n_prof_ef_sup_com_mag + n_prof_ef_sup_sem_mag
drop n_prof_ef_sup_lic_comp n_prof_ef_sup_com_mag n_prof_ef_sup_sem_mag
/*
aqui serão quatro os tipos de número de professores no ensino médio
n_prof_ef_ef_incomp n_prof_ef_ef_comp n_prof_ef_em n_prof_ef_sup

*/

/*
Ensino Fundamental em 9 anos - 5ª à 8ª Série
VDG1M1 Com Fundamental (1º Grau) Incompleto 1444 12 Numérica
VDG1M2 Com Fundamental (1º Grau) Completo 1456 12 Numérica
VDG1M3 Com Médio (2º Grau) Magistério Completo 1468 12 Numérica
VDG1M4 Com Médio (2º Grau) Outra Formação Completa 1480 12 Numérica
VDG1M5 Superior (3º Grau) Licenciatura Completa 1492 12 Numérica
VDG1M6 Superior (3º Grau) Completo sem Licenciatura Com Magistério 1504 12 Numérica
VDG1M7 Superior (3º Grau) Completo sem Licenciatura Sem Magistério
*/
rename vdg1m1 n_prof_ef_9_ef_incomp
rename vdg1m2 n_prof_ef_9_ef_comp
rename vdg1m3 n_prof_ef_9_em_mag_compl
rename vdg1m4 n_prof_ef_9_em_outra
rename vdg1m5 n_prof_ef_9_sup_lic_comp
rename vdg1m6 n_prof_ef_9_sup_com_mag
rename vdg1m7 n_prof_ef_9_sup_sem_mag

local lista n_prof_ef_9_ef_incomp n_prof_ef_9_ef_comp n_prof_ef_9_em_mag_compl n_prof_ef_9_em_outra n_prof_ef_9_sup_lic_comp n_prof_ef_9_sup_com_mag n_prof_ef_9_sup_sem_mag
foreach x in `lista' {

replace `x' =0 if `x'==.
}

gen n_prof_ef_9_em = n_prof_ef_9_em_mag_compl + n_prof_ef_9_em_outra
drop n_prof_ef_9_em_mag_compl n_prof_ef_9_em_outra
gen n_prof_ef_9_sup =  n_prof_ef_9_sup_lic_comp + n_prof_ef_9_sup_com_mag + n_prof_ef_9_sup_sem_mag
drop n_prof_ef_9_sup_lic_comp n_prof_ef_9_sup_com_mag n_prof_ef_9_sup_sem_mag
/*
aqui serão quatro os tipos de número de professores no ensino médio
n_prof_ef_9_ef_incomp n_prof_ef_9_ef_comp n_prof_ef_9_em n_prof_ef_9_sup

*/
/*
Ensino Médio e Médio Profissionalizante
VDG171 Com Fundamental (1º Grau) Incompleto 865 7 Numérica
VDG172 Com Fundamental (1º Grau) Completo 872 7 Numérica
VDG173 Com Médio (2º Grau) Magistério Completo 879 7 Numérica
VDG174 Com Médio (2º Grau) Outra Formação Completa 886 7 Numérica
VDG175 Superior (3º Grau) Licenciatura Completa 893 7 Numérica
VDG176 Superior (3º Grau) Completo sem Licenciatura Com Magistério 
VDG177 Superior (3º Grau) Completo sem Licenciatura Sem Magistério 
*/

rename vdg171 n_prof_em_ef_incomp
rename vdg172 n_prof_em_ef_comp
rename vdg173 n_prof_em_em_mag_compl
rename vdg174 n_prof_em_em_outra
rename vdg175 n_prof_em_sup_lic_comp
rename vdg176 n_prof_em_sup_com_mag
rename vdg177 n_prof_em_sup_sem_mag

local lista n_prof_em_ef_incomp n_prof_em_ef_comp n_prof_em_em_mag_compl n_prof_em_em_outra n_prof_em_sup_lic_comp n_prof_em_sup_com_mag n_prof_em_sup_sem_mag
foreach x in `lista' {

replace `x' =0 if `x'==.
}

gen n_prof_em_em = n_prof_em_em_mag_compl + n_prof_em_em_outra
drop n_prof_em_em_mag_compl n_prof_em_em_outra

gen n_prof_em_sup =  n_prof_em_sup_lic_comp + n_prof_em_sup_com_mag + n_prof_em_sup_sem_mag
drop n_prof_em_sup_lic_comp n_prof_em_sup_com_mag n_prof_em_sup_sem_mag

/*
aqui serão quatro os tipos de número de professores no ensino médio
n_prof_em_ef_incomp n_prof_em_ef_comp n_prof_em_em n_prof_em_sup

*/

/*
Educação de Jovens e Adultos (Supletivo) - 5ª à 8ª Série
VDG1J1 Com Fundamental (1º Grau) Incompleto 1159 7 Numérica
VDG1J2 Com Fundamental (1º Grau) Completo 1166 7 Numérica
VDG1J3 Com Médio (2º Grau) Magistério Completo 1173 7 Numérica
VDG1J4 Com Médio (2º Grau) Outra Formação Completa 1180 7 Numérica
VDG1J5 Superior (3º Grau) Licenciatura Completa 1187 7 Numérica
VDG1J6 Superior (3º Grau) Completo sem Licenciatura Com Magistério 1194 7 Numérica
VDG1J7 Superior (3º Grau) Completo sem Licenciatura Sem Magistério 1201 7 Numérica
*/
rename vdg1j1 n_prof_ef_eja_ef_incomp
rename vdg1j2 n_prof_ef_eja_ef_comp
rename vdg1j3 n_prof_ef_eja_em_mag_compl
rename vdg1j4 n_prof_ef_eja_em_outra
rename vdg1j5 n_prof_ef_eja_sup_lic_comp
rename vdg1j6 n_prof_ef_eja_sup_com_mag
rename vdg1j7 n_prof_ef_eja_sup_sem_mag




local lista n_prof_ef_eja_ef_incomp n_prof_ef_eja_ef_comp n_prof_ef_eja_em_mag_compl n_prof_ef_eja_em_outra n_prof_ef_eja_sup_lic_comp n_prof_ef_eja_sup_com_mag n_prof_ef_eja_sup_sem_mag
foreach x in `lista' {

replace `x' =0 if `x'==.
}

gen n_prof_ef_eja_em = n_prof_ef_eja_em_mag_compl + n_prof_ef_eja_em_outra
drop n_prof_ef_eja_em_mag_compl n_prof_ef_eja_em_outra

gen n_prof_ef_eja_sup =  n_prof_ef_eja_sup_lic_comp + n_prof_ef_eja_sup_com_mag + n_prof_ef_eja_sup_sem_mag
drop n_prof_ef_eja_sup_lic_comp n_prof_ef_eja_sup_com_mag n_prof_ef_eja_sup_sem_mag

/*
aqui serão quatro os tipos de número de professores no ensino médio
n_prof_ef_eja_ef_incomp n_prof_ef_eja_ef_comp n_prof_ef_eja_em n_prof_ef_eja_sup

*/
/*
Educação de Jovens e Adultos (Supletivo) - Ensino Médio
VDG1K1 Com Fundamental (1º Grau) Incompleto 1208 7 Numérica
VDG1K2 Com Fundamental (1º Grau) Completo 1215 7 Numérica
VDG1K3 Com Médio (2º Grau) Magistério Completo 1222 7 Numérica
VDG1K4 Com Médio (2º Grau) Outra Formação Completa 1229 7 Numérica
VDG1K5 Superior (3º Grau) Licenciatura Completa 1236 7 Numérica
VDG1K6 Superior (3º Grau) Completo sem Licenciatura Com Magistério 1243 7 Numérica
VDG1K7 Superior (3º Grau) Completo sem Licenciatura Sem Magistério 1250 7 Numérica

*/
rename vdg1k1 n_prof_em_eja_ef_incomp
rename vdg1k2 n_prof_em_eja_ef_comp
rename vdg1k3 n_prof_em_eja_em_mag_compl
rename vdg1k4 n_prof_em_eja_em_outra
rename vdg1k5 n_prof_em_eja_sup_lic_comp
rename vdg1k6 n_prof_em_eja_sup_com_mag
rename vdg1k7 n_prof_em_eja_sup_sem_mag



local lista n_prof_em_eja_ef_incomp n_prof_em_eja_ef_comp n_prof_em_eja_em_mag_compl n_prof_em_eja_em_outra n_prof_em_eja_sup_lic_comp n_prof_em_eja_sup_com_mag n_prof_em_eja_sup_sem_mag
foreach x in `lista' {

replace `x' =0 if `x'==.
}

gen n_prof_em_eja_em = n_prof_em_eja_em_mag_compl + n_prof_em_eja_em_outra
drop n_prof_em_eja_em_mag_compl n_prof_em_eja_em_outra

gen n_prof_em_eja_sup =  n_prof_em_eja_sup_lic_comp + n_prof_em_eja_sup_com_mag + n_prof_em_eja_sup_sem_mag
drop n_prof_em_eja_sup_lic_comp n_prof_em_eja_sup_com_mag n_prof_em_eja_sup_sem_mag

/*
aqui serão quatro os tipos de número de professores no ensino médio
n_prof_em_eja_ef_incomp n_prof_em_eja_ef_comp n_prof_em_eja_em n_prof_em_eja_sup
*/

/*
Educação Profissional - Nível Técnico
VDG1D1 Com Fundamental (1º Grau) Incompleto 1257 7 Numérica
VDG1D2 Com Fundamental (1º Grau) Completo 1264 7 Numérica
VDG1D3 Com Médio (2º Grau) Magistério Completo 1271 7 Numérica
VDG1D4 Com Médio (2º Grau) Outra Formação Completa 1278 7 Numérica
VDG1D5 Superior (3º Grau) Licenciatura Completa 1285 7 Numérica
VDG1D6 Superior (3º Grau) Completo sem Licenciatura Com Magistério 1292 7 Numérica
VDG1D7 Superior (3º Grau) Completo sem Licenciatura Sem Magistério 
*/
 
rename vdg1d1 n_prof_ep_nt_ef_incomp
rename vdg1d2 n_prof_ep_nt_ef_comp
rename vdg1d3 n_prof_ep_nt_em_mag_compl
rename vdg1d4 n_prof_ep_nt_em_outra
rename vdg1d5 n_prof_ep_nt_sup_lic_comp
rename vdg1d6 n_prof_ep_nt_sup_com_mag
rename vdg1d7 n_prof_ep_nt_sup_sem_mag


local lista n_prof_ep_nt_ef_incomp n_prof_ep_nt_ef_comp n_prof_ep_nt_em_mag_compl n_prof_ep_nt_em_outra n_prof_ep_nt_sup_lic_comp n_prof_ep_nt_sup_com_mag n_prof_ep_nt_sup_sem_mag
foreach x in `lista' {

replace `x' =0 if `x'==.
}

gen n_prof_ep_nt_em = n_prof_ep_nt_em_mag_compl + n_prof_ep_nt_em_outra
drop n_prof_ep_nt_em_mag_compl n_prof_ep_nt_em_outra

gen n_prof_ep_nt_sup =  n_prof_ep_nt_sup_lic_comp + n_prof_ep_nt_sup_com_mag + n_prof_ep_nt_sup_sem_mag
drop n_prof_ep_nt_sup_lic_comp n_prof_ep_nt_sup_com_mag n_prof_ep_nt_sup_sem_mag

/*
aqui serão quatro os tipos de número de professores no ensino médio
n_prof_ep_nt_ef_incomp n_prof_ep_nt_ef_comp n_prof_ep_nt_em n_prof_ep_nt_sup
*/

gen ano_censo_escolar_doc = ano

merge 1:1 mascara using "$folderservidor\censo_escolar\mascara censo (2004).dta"
save "$folderservidor\censo_escolar\censo_escolar_doc_2004.dta", replace 


/**********************************************************************************

2005

**********************************************************************************/
use "\\fs-eesp-01\EESP-BD-01\BASES-CMICRO\Educacao\Censo Escolar\Censo Escolar 2005\DADOS\CENSOESC_2005.dta", clear
keep ano mascara ///
	vdg1c3 vdg1c4  vdg1c6 vdg1c9 ///
	vdg161 vdg162 vdg163 vdg164 vdg165 vdg166 vdg167 ///
	vdg1m1 vdg1m2 vdg1m3 vdg1m4 vdg1m5 vdg1m6 vdg1m7 ///
	vdg171 vdg172 vdg173 vdg174 vdg175 vdg176 vdg177 ///
	vdg1j1 vdg1j2 vdg1j3 vdg1j4 vdg1j5 vdg1j6 vdg1j7 ///
	vdg1k1 vdg1k2 vdg1k3 vdg1k4 vdg1k5 vdg1k6 vdg1k7 ///
	vdg1d1 vdg1d2 vdg1d3 vdg1d4 vdg1d5 vdg1d6 vdg1d7 
/*	VDG1C3 VDG1C4 VDG1C3 VDG1C4 VDG1CB  VDG1C5 VDG1C6 VDG1C9 ///
	VDG161 VDG162 VDG163 VDG164 VDG165 VDG166 VDG167 ///
	VDG171 VDG172 VDG173 VDG174 VDG175 VDG176 VDG177 ///
	VDG1G1 VDG1G2 VDG1G3 VDG1G4 VDG1G5 VDG1G6 VDG1G7 ///
	VDG1J1 VDG1J2 VDG1J3 VDG1J4 VDG1J5 VDG1J6 VDG1J7 ///
	VDG1K1 VDG1K2 VDG1K3 VDG1K4 VDG1K5 VDG1K6 VDG1K7 ///
	VDG1D1 VDG1D2 VDG1D3 VDG1D4 VDG1D5 VDG1D6 VDG1D7 
* na base não há informação de curso nomral em nível médio (?)
*/
/*
VDG1C3 Nº de Professores no Ensino Fundamental 
VDG1C4 Nº de Professores no Ensino Médio e Médio Profissionalizante 
*VDG1CB Nº de Professores no Curso Normal em Nível Médio 
VDG1C5 Nº de Professores na Educação Especial 
VDG1C6 Nº de Professores na Educação de Jovens e Adultos/Supletivo 
VDG1C9 Nº de Professores na Educação Profissional Nível Técnico 
*/
	
rename vdg1c3 n_prof_ef
rename vdg1c4 n_prof_em_ep
rename vdg1c6 n_prof_eja
rename vdg1c9 n_prof_tecn


local lista n_prof_ef n_prof_em_ep n_prof_eja n_prof_tecn
foreach x in `lista' {

replace `x' =0 if `x'==.
}
***************************************************************************
*NÚMERO DE PROFESSORES SEGUNDO NÍVEL/MODALIDADE DE ATUAÇÃO POR NÍVEL DE FORMAÇÃO
***************************************************************************
/*
Ensino Fundamental - 5ª à 8ª Série
VDG161 Com Fundamental (1º Grau) Incompleto 
VDG162 Com Fundamental (1º Grau) Completo 
VDG163 Com Médio (2º Grau) Magistério Completo 
VDG164 Com Médio (2º Grau) Outra Formação Completa 
VDG165 Superior (3º Grau) Licenciatura Completa 
VDG166 Superior (3º Grau) Completo sem Licenciatura Com Magistério 
VDG167 Superior (3º Grau) Completo sem Licenciatura Sem Magistério 
*/

rename vdg161 n_prof_ef_ef_incomp
rename vdg162 n_prof_ef_ef_comp
rename vdg163 n_prof_ef_em_mag_compl
rename vdg164 n_prof_ef_em_outra
rename vdg165 n_prof_ef_sup_lic_comp
rename vdg166 n_prof_ef_sup_com_mag
rename vdg167 n_prof_ef_sup_sem_mag

local lista n_prof_ef_ef_incomp n_prof_ef_ef_comp n_prof_ef_em_mag_compl n_prof_ef_em_outra n_prof_ef_sup_lic_comp n_prof_ef_sup_com_mag n_prof_ef_sup_sem_mag
foreach x in `lista' {

replace `x' =0 if `x'==.
}

gen n_prof_ef_em = n_prof_ef_em_mag_compl + n_prof_ef_em_outra
drop n_prof_ef_em_mag_compl n_prof_ef_em_outra
gen n_prof_ef_sup =  n_prof_ef_sup_lic_comp + n_prof_ef_sup_com_mag + n_prof_ef_sup_sem_mag
drop n_prof_ef_sup_lic_comp n_prof_ef_sup_com_mag n_prof_ef_sup_sem_mag
/*
aqui serão quatro os tipos de número de professores no ensino médio
n_prof_ef_ef_incomp n_prof_ef_ef_comp n_prof_ef_em n_prof_ef_sup

*/

/*
Ensino Fundamental em 9 anos - 5ª à 8ª Série
VDG1M1 Com Fundamental (1º Grau) Incompleto 1444 12 Numérica
VDG1M2 Com Fundamental (1º Grau) Completo 1456 12 Numérica
VDG1M3 Com Médio (2º Grau) Magistério Completo 1468 12 Numérica
VDG1M4 Com Médio (2º Grau) Outra Formação Completa 1480 12 Numérica
VDG1M5 Superior (3º Grau) Licenciatura Completa 1492 12 Numérica
VDG1M6 Superior (3º Grau) Completo sem Licenciatura Com Magistério 1504 12 Numérica
VDG1M7 Superior (3º Grau) Completo sem Licenciatura Sem Magistério
*/
rename vdg1m1 n_prof_ef_9_ef_incomp
rename vdg1m2 n_prof_ef_9_ef_comp
rename vdg1m3 n_prof_ef_9_em_mag_compl
rename vdg1m4 n_prof_ef_9_em_outra
rename vdg1m5 n_prof_ef_9_sup_lic_comp
rename vdg1m6 n_prof_ef_9_sup_com_mag
rename vdg1m7 n_prof_ef_9_sup_sem_mag



local lista n_prof_ef_9_ef_incomp n_prof_ef_9_ef_comp n_prof_ef_9_em_mag_compl n_prof_ef_9_em_outra n_prof_ef_9_sup_lic_comp n_prof_ef_9_sup_com_mag n_prof_ef_9_sup_sem_mag
foreach x in `lista' {

replace `x' =0 if `x'==.
}

gen n_prof_ef_9_em = n_prof_ef_9_em_mag_compl + n_prof_ef_9_em_outra
drop n_prof_ef_9_em_mag_compl n_prof_ef_9_em_outra
gen n_prof_ef_9_sup =  n_prof_ef_9_sup_lic_comp + n_prof_ef_9_sup_com_mag + n_prof_ef_9_sup_sem_mag
drop n_prof_ef_9_sup_lic_comp n_prof_ef_9_sup_com_mag n_prof_ef_9_sup_sem_mag
/*
aqui serão quatro os tipos de número de professores no ensino médio
n_prof_ef_9_ef_incomp n_prof_ef_9_ef_comp n_prof_ef_9_em n_prof_ef_9_sup

*/

/*
Ensino Médio e Médio Profissionalizante
VDG171 Com Fundamental (1º Grau) Incompleto 865 7 Numérica
VDG172 Com Fundamental (1º Grau) Completo 872 7 Numérica
VDG173 Com Médio (2º Grau) Magistério Completo 879 7 Numérica
VDG174 Com Médio (2º Grau) Outra Formação Completa 886 7 Numérica
VDG175 Superior (3º Grau) Licenciatura Completa 893 7 Numérica
VDG176 Superior (3º Grau) Completo sem Licenciatura Com Magistério 
VDG177 Superior (3º Grau) Completo sem Licenciatura Sem Magistério 
*/

rename vdg171 n_prof_em_ef_incomp
rename vdg172 n_prof_em_ef_comp
rename vdg173 n_prof_em_em_mag_compl
rename vdg174 n_prof_em_em_outra
rename vdg175 n_prof_em_sup_lic_comp
rename vdg176 n_prof_em_sup_com_mag
rename vdg177 n_prof_em_sup_sem_mag



local lista n_prof_em_ef_incomp n_prof_em_ef_comp n_prof_em_em_mag_compl n_prof_em_em_outra n_prof_em_sup_lic_comp n_prof_em_sup_com_mag n_prof_em_sup_sem_mag
foreach x in `lista' {

replace `x' =0 if `x'==.
}

gen n_prof_em_em = n_prof_em_em_mag_compl + n_prof_em_em_outra
drop n_prof_em_em_mag_compl n_prof_em_em_outra

gen n_prof_em_sup =  n_prof_em_sup_lic_comp + n_prof_em_sup_com_mag + n_prof_em_sup_sem_mag
drop n_prof_em_sup_lic_comp n_prof_em_sup_com_mag n_prof_em_sup_sem_mag

/*
aqui serão quatro os tipos de número de professores no ensino médio
n_prof_em_ef_incomp n_prof_em_ef_comp n_prof_em_em n_prof_em_sup

*/


/*
Educação de Jovens e Adultos (Supletivo) - 5ª à 8ª Série
VDG1J1 Com Fundamental (1º Grau) Incompleto 1159 7 Numérica
VDG1J2 Com Fundamental (1º Grau) Completo 1166 7 Numérica
VDG1J3 Com Médio (2º Grau) Magistério Completo 1173 7 Numérica
VDG1J4 Com Médio (2º Grau) Outra Formação Completa 1180 7 Numérica
VDG1J5 Superior (3º Grau) Licenciatura Completa 1187 7 Numérica
VDG1J6 Superior (3º Grau) Completo sem Licenciatura Com Magistério 1194 7 Numérica
VDG1J7 Superior (3º Grau) Completo sem Licenciatura Sem Magistério 1201 7 Numérica
*/
rename vdg1j1 n_prof_ef_eja_ef_incomp
rename vdg1j2 n_prof_ef_eja_ef_comp
rename vdg1j3 n_prof_ef_eja_em_mag_compl
rename vdg1j4 n_prof_ef_eja_em_outra
rename vdg1j5 n_prof_ef_eja_sup_lic_comp
rename vdg1j6 n_prof_ef_eja_sup_com_mag
rename vdg1j7 n_prof_ef_eja_sup_sem_mag




local lista n_prof_ef_eja_ef_incomp n_prof_ef_eja_ef_comp n_prof_ef_eja_em_mag_compl n_prof_ef_eja_em_outra n_prof_ef_eja_sup_lic_comp n_prof_ef_eja_sup_com_mag n_prof_ef_eja_sup_sem_mag
foreach x in `lista' {

replace `x' =0 if `x'==.
}

gen n_prof_ef_eja_em = n_prof_ef_eja_em_mag_compl + n_prof_ef_eja_em_outra
drop n_prof_ef_eja_em_mag_compl n_prof_ef_eja_em_outra

gen n_prof_ef_eja_sup =  n_prof_ef_eja_sup_lic_comp + n_prof_ef_eja_sup_com_mag + n_prof_ef_eja_sup_sem_mag
drop n_prof_ef_eja_sup_lic_comp n_prof_ef_eja_sup_com_mag n_prof_ef_eja_sup_sem_mag

/*
aqui serão quatro os tipos de número de professores no ensino médio
n_prof_ef_eja_ef_incomp n_prof_ef_eja_ef_comp n_prof_ef_eja_em n_prof_ef_eja_sup

*/



/*

Educação de Jovens e Adultos (Supletivo) - Ensino Médio
VDG1K1 Com Fundamental (1º Grau) Incompleto 1208 7 Numérica
VDG1K2 Com Fundamental (1º Grau) Completo 1215 7 Numérica
VDG1K3 Com Médio (2º Grau) Magistério Completo 1222 7 Numérica
VDG1K4 Com Médio (2º Grau) Outra Formação Completa 1229 7 Numérica
VDG1K5 Superior (3º Grau) Licenciatura Completa 1236 7 Numérica
VDG1K6 Superior (3º Grau) Completo sem Licenciatura Com Magistério 1243 7 Numérica
VDG1K7 Superior (3º Grau) Completo sem Licenciatura Sem Magistério 1250 7 Numérica

*/
rename vdg1k1 n_prof_em_eja_ef_incomp
rename vdg1k2 n_prof_em_eja_ef_comp
rename vdg1k3 n_prof_em_eja_em_mag_compl
rename vdg1k4 n_prof_em_eja_em_outra
rename vdg1k5 n_prof_em_eja_sup_lic_comp
rename vdg1k6 n_prof_em_eja_sup_com_mag
rename vdg1k7 n_prof_em_eja_sup_sem_mag


local lista n_prof_em_eja_ef_incomp n_prof_em_eja_ef_comp n_prof_em_eja_em_mag_compl n_prof_em_eja_em_outra n_prof_em_eja_sup_lic_comp n_prof_em_eja_sup_com_mag n_prof_em_eja_sup_sem_mag
foreach x in `lista' {

replace `x' =0 if `x'==.
}

gen n_prof_em_eja_em = n_prof_em_eja_em_mag_compl + n_prof_em_eja_em_outra
drop n_prof_em_eja_em_mag_compl n_prof_em_eja_em_outra

gen n_prof_em_eja_sup =  n_prof_em_eja_sup_lic_comp + n_prof_em_eja_sup_com_mag + n_prof_em_eja_sup_sem_mag
drop n_prof_em_eja_sup_lic_comp n_prof_em_eja_sup_com_mag n_prof_em_eja_sup_sem_mag

/*
aqui serão quatro os tipos de número de professores no ensino médio
n_prof_em_eja_ef_incomp n_prof_em_eja_ef_comp n_prof_em_eja_em n_prof_em_eja_sup
*/

/*
Educação Profissional - Nível Técnico
VDG1D1 Com Fundamental (1º Grau) Incompleto 1257 7 Numérica
VDG1D2 Com Fundamental (1º Grau) Completo 1264 7 Numérica
VDG1D3 Com Médio (2º Grau) Magistério Completo 1271 7 Numérica
VDG1D4 Com Médio (2º Grau) Outra Formação Completa 1278 7 Numérica
VDG1D5 Superior (3º Grau) Licenciatura Completa 1285 7 Numérica
VDG1D6 Superior (3º Grau) Completo sem Licenciatura Com Magistério 1292 7 Numérica
VDG1D7 Superior (3º Grau) Completo sem Licenciatura Sem Magistério 
*/
 
rename vdg1d1 n_prof_ep_nt_ef_incomp
rename vdg1d2 n_prof_ep_nt_ef_comp
rename vdg1d3 n_prof_ep_nt_em_mag_compl
rename vdg1d4 n_prof_ep_nt_em_outra
rename vdg1d5 n_prof_ep_nt_sup_lic_comp
rename vdg1d6 n_prof_ep_nt_sup_com_mag
rename vdg1d7 n_prof_ep_nt_sup_sem_mag




local lista n_prof_ep_nt_ef_incomp n_prof_ep_nt_ef_comp n_prof_ep_nt_em_mag_compl n_prof_ep_nt_em_outra n_prof_ep_nt_sup_lic_comp n_prof_ep_nt_sup_com_mag n_prof_ep_nt_sup_sem_mag
foreach x in `lista' {

replace `x' =0 if `x'==.
}

gen n_prof_ep_nt_em = n_prof_ep_nt_em_mag_compl + n_prof_ep_nt_em_outra
drop n_prof_ep_nt_em_mag_compl n_prof_ep_nt_em_outra

gen n_prof_ep_nt_sup =  n_prof_ep_nt_sup_lic_comp + n_prof_ep_nt_sup_com_mag + n_prof_ep_nt_sup_sem_mag
drop n_prof_ep_nt_sup_lic_comp n_prof_ep_nt_sup_com_mag n_prof_ep_nt_sup_sem_mag

/*
aqui serão quatro os tipos de número de professores no ensino médio
n_prof_ep_nt_ef_incomp n_prof_ep_nt_ef_comp n_prof_ep_nt_em n_prof_ep_nt_sup
*/

gen ano_censo_escolar_doc = ano
merge 1:1 mascara using "$folderservidor\censo_escolar\mascara censo (2005).dta"
save "$folderservidor\censo_escolar\censo_escolar_doc_2005.dta", replace 




/**********************************************************************************

2006

**********************************************************************************/
use "\\fs-eesp-01\EESP-BD-01\BASES-CMICRO\Educacao\Censo Escolar\Censo Escolar 2006\DADOS\CENSOESC_2006.dta", clear 
keep ano mascara ///
	vdg1c3 vdg1c4  vdg1c6 vdg1c9 ///
	vdg161 vdg162 vdg163 vdg164 vdg165 vdg166 vdg167 ///
	vdg1m1 vdg1m2 vdg1m3 vdg1m4 vdg1m5 vdg1m6 vdg1m7 ///
	vdg171 vdg172 vdg173 vdg174 vdg175 vdg176 vdg177 ///
	vdg1j1 vdg1j2 vdg1j3 vdg1j4 vdg1j5 vdg1j6 vdg1j7 ///
	vdg1k1 vdg1k2 vdg1k3 vdg1k4 vdg1k5 vdg1k6 vdg1k7 ///
	vdg1d1 vdg1d2 vdg1d3 vdg1d4 vdg1d5 vdg1d6 vdg1d7 
/*	VDG1C3 VDG1C4 VDG1C3 VDG1C4 VDG1CB  VDG1C5 VDG1C6 VDG1C9 ///
	VDG161 VDG162 VDG163 VDG164 VDG165 VDG166 VDG167 ///
	VDG171 VDG172 VDG173 VDG174 VDG175 VDG176 VDG177 ///
	VDG1G1 VDG1G2 VDG1G3 VDG1G4 VDG1G5 VDG1G6 VDG1G7 ///
	VDG1J1 VDG1J2 VDG1J3 VDG1J4 VDG1J5 VDG1J6 VDG1J7 ///
	VDG1K1 VDG1K2 VDG1K3 VDG1K4 VDG1K5 VDG1K6 VDG1K7 ///
	VDG1D1 VDG1D2 VDG1D3 VDG1D4 VDG1D5 VDG1D6 VDG1D7 
* na base não há informação de curso nomral em nível médio (?)
*/
/*
VDG1C3 Nº de Professores no Ensino Fundamental 
VDG1C4 Nº de Professores no Ensino Médio e Médio Profissionalizante 
*VDG1CB Nº de Professores no Curso Normal em Nível Médio 
VDG1C5 Nº de Professores na Educação Especial 
VDG1C6 Nº de Professores na Educação de Jovens e Adultos/Supletivo 
VDG1C9 Nº de Professores na Educação Profissional Nível Técnico 
*/
	
rename vdg1c3 n_prof_ef
rename vdg1c4 n_prof_em_ep
rename vdg1c6 n_prof_eja
rename vdg1c9 n_prof_tecn

local lista n_prof_ef n_prof_em_ep n_prof_eja n_prof_tecn
foreach x in `lista' {

replace `x' =0 if `x'==.
}

***************************************************************************
*NÚMERO DE PROFESSORES SEGUNDO NÍVEL/MODALIDADE DE ATUAÇÃO POR NÍVEL DE FORMAÇÃO
***************************************************************************
/*
Ensino Fundamental - 5ª à 8ª Série
VDG161 Com Fundamental (1º Grau) Incompleto 
VDG162 Com Fundamental (1º Grau) Completo 
VDG163 Com Médio (2º Grau) Magistério Completo 
VDG164 Com Médio (2º Grau) Outra Formação Completa 
VDG165 Superior (3º Grau) Licenciatura Completa 
VDG166 Superior (3º Grau) Completo sem Licenciatura Com Magistério 
VDG167 Superior (3º Grau) Completo sem Licenciatura Sem Magistério 
*/

rename vdg161 n_prof_ef_ef_incomp
rename vdg162 n_prof_ef_ef_comp
rename vdg163 n_prof_ef_em_mag_compl
rename vdg164 n_prof_ef_em_outra
rename vdg165 n_prof_ef_sup_lic_comp
rename vdg166 n_prof_ef_sup_com_mag
rename vdg167 n_prof_ef_sup_sem_mag


	
local lista n_prof_ef_ef_incomp n_prof_ef_ef_comp n_prof_ef_em_mag_compl n_prof_ef_em_outra n_prof_ef_sup_lic_comp n_prof_ef_sup_com_mag n_prof_ef_sup_sem_mag
foreach x in `lista' {

replace `x' =0 if `x'==.
}

gen n_prof_ef_em = n_prof_ef_em_mag_compl + n_prof_ef_em_outra
drop n_prof_ef_em_mag_compl n_prof_ef_em_outra
gen n_prof_ef_sup =  n_prof_ef_sup_lic_comp + n_prof_ef_sup_com_mag + n_prof_ef_sup_sem_mag
drop n_prof_ef_sup_lic_comp n_prof_ef_sup_com_mag n_prof_ef_sup_sem_mag
/*
aqui serão quatro os tipos de número de professores no ensino médio
n_prof_ef_ef_incomp n_prof_ef_ef_comp n_prof_ef_em n_prof_ef_sup

*/


/*
Ensino Fundamental em 9 anos - 5ª à 8ª Série
VDG1M1 Com Fundamental (1º Grau) Incompleto 1444 12 Numérica
VDG1M2 Com Fundamental (1º Grau) Completo 1456 12 Numérica
VDG1M3 Com Médio (2º Grau) Magistério Completo 1468 12 Numérica
VDG1M4 Com Médio (2º Grau) Outra Formação Completa 1480 12 Numérica
VDG1M5 Superior (3º Grau) Licenciatura Completa 1492 12 Numérica
VDG1M6 Superior (3º Grau) Completo sem Licenciatura Com Magistério 1504 12 Numérica
VDG1M7 Superior (3º Grau) Completo sem Licenciatura Sem Magistério
*/
rename vdg1m1 n_prof_ef_9_ef_incomp
rename vdg1m2 n_prof_ef_9_ef_comp
rename vdg1m3 n_prof_ef_9_em_mag_compl
rename vdg1m4 n_prof_ef_9_em_outra
rename vdg1m5 n_prof_ef_9_sup_lic_comp
rename vdg1m6 n_prof_ef_9_sup_com_mag
rename vdg1m7 n_prof_ef_9_sup_sem_mag



local lista n_prof_ef_9_ef_incomp n_prof_ef_9_ef_comp n_prof_ef_9_em_mag_compl n_prof_ef_9_em_outra n_prof_ef_9_sup_lic_comp n_prof_ef_9_sup_com_mag n_prof_ef_9_sup_sem_mag
foreach x in `lista' {

replace `x' =0 if `x'==.
}

gen n_prof_ef_9_em = n_prof_ef_9_em_mag_compl + n_prof_ef_9_em_outra
drop n_prof_ef_9_em_mag_compl n_prof_ef_9_em_outra
gen n_prof_ef_9_sup =  n_prof_ef_9_sup_lic_comp + n_prof_ef_9_sup_com_mag + n_prof_ef_9_sup_sem_mag
drop n_prof_ef_9_sup_lic_comp n_prof_ef_9_sup_com_mag n_prof_ef_9_sup_sem_mag
/*
aqui serão quatro os tipos de número de professores no ensino médio
n_prof_ef_9_ef_incomp n_prof_ef_9_ef_comp n_prof_ef_9_em n_prof_ef_9_sup

*/


/*
Ensino Médio e Médio Profissionalizante
VDG171 Com Fundamental (1º Grau) Incompleto 865 7 Numérica
VDG172 Com Fundamental (1º Grau) Completo 872 7 Numérica
VDG173 Com Médio (2º Grau) Magistério Completo 879 7 Numérica
VDG174 Com Médio (2º Grau) Outra Formação Completa 886 7 Numérica
VDG175 Superior (3º Grau) Licenciatura Completa 893 7 Numérica
VDG176 Superior (3º Grau) Completo sem Licenciatura Com Magistério 
VDG177 Superior (3º Grau) Completo sem Licenciatura Sem Magistério 
*/

rename vdg171 n_prof_em_ef_incomp
rename vdg172 n_prof_em_ef_comp
rename vdg173 n_prof_em_em_mag_compl
rename vdg174 n_prof_em_em_outra
rename vdg175 n_prof_em_sup_lic_comp
rename vdg176 n_prof_em_sup_com_mag
rename vdg177 n_prof_em_sup_sem_mag



local lista n_prof_em_ef_incomp n_prof_em_ef_comp n_prof_em_em_mag_compl n_prof_em_em_outra n_prof_em_sup_lic_comp n_prof_em_sup_com_mag n_prof_em_sup_sem_mag
foreach x in `lista' {

replace `x' =0 if `x'==.
}

gen n_prof_em_em = n_prof_em_em_mag_compl + n_prof_em_em_outra
drop n_prof_em_em_mag_compl n_prof_em_em_outra

gen n_prof_em_sup =  n_prof_em_sup_lic_comp + n_prof_em_sup_com_mag + n_prof_em_sup_sem_mag
drop n_prof_em_sup_lic_comp n_prof_em_sup_com_mag n_prof_em_sup_sem_mag

/*
aqui serão quatro os tipos de número de professores no ensino médio
n_prof_em_ef_incomp n_prof_em_ef_comp n_prof_em_em n_prof_em_sup

*/

/*
Educação de Jovens e Adultos (Supletivo) - 5ª à 8ª Série
VDG1J1 Com Fundamental (1º Grau) Incompleto 1159 7 Numérica
VDG1J2 Com Fundamental (1º Grau) Completo 1166 7 Numérica
VDG1J3 Com Médio (2º Grau) Magistério Completo 1173 7 Numérica
VDG1J4 Com Médio (2º Grau) Outra Formação Completa 1180 7 Numérica
VDG1J5 Superior (3º Grau) Licenciatura Completa 1187 7 Numérica
VDG1J6 Superior (3º Grau) Completo sem Licenciatura Com Magistério 1194 7 Numérica
VDG1J7 Superior (3º Grau) Completo sem Licenciatura Sem Magistério 1201 7 Numérica
*/
rename vdg1j1 n_prof_ef_eja_ef_incomp
rename vdg1j2 n_prof_ef_eja_ef_comp
rename vdg1j3 n_prof_ef_eja_em_mag_compl
rename vdg1j4 n_prof_ef_eja_em_outra
rename vdg1j5 n_prof_ef_eja_sup_lic_comp
rename vdg1j6 n_prof_ef_eja_sup_com_mag
rename vdg1j7 n_prof_ef_eja_sup_sem_mag




local lista n_prof_ef_eja_ef_incomp n_prof_ef_eja_ef_comp n_prof_ef_eja_em_mag_compl n_prof_ef_eja_em_outra n_prof_ef_eja_sup_lic_comp n_prof_ef_eja_sup_com_mag n_prof_ef_eja_sup_sem_mag
foreach x in `lista' {

replace `x' =0 if `x'==.
}

gen n_prof_ef_eja_em = n_prof_ef_eja_em_mag_compl + n_prof_ef_eja_em_outra
drop n_prof_ef_eja_em_mag_compl n_prof_ef_eja_em_outra

gen n_prof_ef_eja_sup =  n_prof_ef_eja_sup_lic_comp + n_prof_ef_eja_sup_com_mag + n_prof_ef_eja_sup_sem_mag
drop n_prof_ef_eja_sup_lic_comp n_prof_ef_eja_sup_com_mag n_prof_ef_eja_sup_sem_mag

/*
aqui serão quatro os tipos de número de professores no ensino médio
n_prof_ef_eja_ef_incomp n_prof_ef_eja_ef_comp n_prof_ef_eja_em n_prof_ef_eja_sup

*/

/*

Educação de Jovens e Adultos (Supletivo) - Ensino Médio
VDG1K1 Com Fundamental (1º Grau) Incompleto 1208 7 Numérica
VDG1K2 Com Fundamental (1º Grau) Completo 1215 7 Numérica
VDG1K3 Com Médio (2º Grau) Magistério Completo 1222 7 Numérica
VDG1K4 Com Médio (2º Grau) Outra Formação Completa 1229 7 Numérica
VDG1K5 Superior (3º Grau) Licenciatura Completa 1236 7 Numérica
VDG1K6 Superior (3º Grau) Completo sem Licenciatura Com Magistério 1243 7 Numérica
VDG1K7 Superior (3º Grau) Completo sem Licenciatura Sem Magistério 1250 7 Numérica

*/
rename vdg1k1 n_prof_em_eja_ef_incomp
rename vdg1k2 n_prof_em_eja_ef_comp
rename vdg1k3 n_prof_em_eja_em_mag_compl
rename vdg1k4 n_prof_em_eja_em_outra
rename vdg1k5 n_prof_em_eja_sup_lic_comp
rename vdg1k6 n_prof_em_eja_sup_com_mag
rename vdg1k7 n_prof_em_eja_sup_sem_mag



local lista n_prof_em_eja_ef_incomp n_prof_em_eja_ef_comp n_prof_em_eja_em_mag_compl n_prof_em_eja_em_outra n_prof_em_eja_sup_lic_comp n_prof_em_eja_sup_com_mag n_prof_em_eja_sup_sem_mag
foreach x in `lista' {

replace `x' =0 if `x'==.
}

gen n_prof_em_eja_em = n_prof_em_eja_em_mag_compl + n_prof_em_eja_em_outra
drop n_prof_em_eja_em_mag_compl n_prof_em_eja_em_outra

gen n_prof_em_eja_sup =  n_prof_em_eja_sup_lic_comp + n_prof_em_eja_sup_com_mag + n_prof_em_eja_sup_sem_mag
drop n_prof_em_eja_sup_lic_comp n_prof_em_eja_sup_com_mag n_prof_em_eja_sup_sem_mag

/*
aqui serão quatro os tipos de número de professores no ensino médio
n_prof_em_eja_ef_incomp n_prof_em_eja_ef_comp n_prof_em_eja_em n_prof_em_eja_sup
*/

/*
Educação Profissional - Nível Técnico
VDG1D1 Com Fundamental (1º Grau) Incompleto 1257 7 Numérica
VDG1D2 Com Fundamental (1º Grau) Completo 1264 7 Numérica
VDG1D3 Com Médio (2º Grau) Magistério Completo 1271 7 Numérica
VDG1D4 Com Médio (2º Grau) Outra Formação Completa 1278 7 Numérica
VDG1D5 Superior (3º Grau) Licenciatura Completa 1285 7 Numérica
VDG1D6 Superior (3º Grau) Completo sem Licenciatura Com Magistério 1292 7 Numérica
VDG1D7 Superior (3º Grau) Completo sem Licenciatura Sem Magistério 
*/
 
rename vdg1d1 n_prof_ep_nt_ef_incomp
rename vdg1d2 n_prof_ep_nt_ef_comp
rename vdg1d3 n_prof_ep_nt_em_mag_compl
rename vdg1d4 n_prof_ep_nt_em_outra
rename vdg1d5 n_prof_ep_nt_sup_lic_comp
rename vdg1d6 n_prof_ep_nt_sup_com_mag
rename vdg1d7 n_prof_ep_nt_sup_sem_mag



local lista n_prof_ep_nt_ef_incomp n_prof_ep_nt_ef_comp n_prof_ep_nt_em_mag_compl n_prof_ep_nt_em_outra n_prof_ep_nt_sup_lic_comp n_prof_ep_nt_sup_com_mag n_prof_ep_nt_sup_sem_mag
foreach x in `lista' {

replace `x' =0 if `x'==.
}

gen n_prof_ep_nt_em = n_prof_ep_nt_em_mag_compl + n_prof_ep_nt_em_outra
drop n_prof_ep_nt_em_mag_compl n_prof_ep_nt_em_outra

gen n_prof_ep_nt_sup =  n_prof_ep_nt_sup_lic_comp + n_prof_ep_nt_sup_com_mag + n_prof_ep_nt_sup_sem_mag
drop n_prof_ep_nt_sup_lic_comp n_prof_ep_nt_sup_com_mag n_prof_ep_nt_sup_sem_mag

/*
aqui serão quatro os tipos de número de professores no ensino médio
n_prof_ep_nt_ef_incomp n_prof_ep_nt_ef_comp n_prof_ep_nt_em n_prof_ep_nt_sup
*/

gen ano_censo_escolar_doc = ano
merge 1:1 mascara using "$folderservidor\censo_escolar\mascara censo (2006).dta"

save "$folderservidor\censo_escolar\censo_escolar_doc_2006.dta", replace 


/**********************************************************************************

2007

**********************************************************************************/

use "\\fs-eesp-01\EESP-BD-01\BASES-CMICRO\Educacao\Censo Escolar\Censo Escolar 2007\DADOS\docentes_co.dta", clear
append using "\\fs-eesp-01\EESP-BD-01\BASES-CMICRO\Educacao\Censo Escolar\Censo Escolar 2007\DADOS\docentes_nordeste.dta"
append using "\\fs-eesp-01\EESP-BD-01\BASES-CMICRO\Educacao\Censo Escolar\Censo Escolar 2007\DADOS\docentes_sudeste.dta"

keep ano_censo fk_cod_docente fk_cod_escolaridade fk_cod_etapa_ensino pk_cod_entidade

gen ef_incompleto=0
replace ef_incompleto = 1 if fk_cod_escolaridade == 1

gen ef_completo =0
replace ef_completo = 1 if fk_cod_escolaridade == 2

gen em_completo =0 
replace em_completo =1 if fk_cod_escolaridade >= 3 & fk_cod_escolaridade <= 5

gen sup_completo = 0
replace sup_completo =1 if fk_cod_escolaridade == 6 | fk_cod_escolaridade == 7

gen etapa_fund = 0
replace etapa_fund = 1 if fk_cod_etapa_ensino >= 4 & fk_cod_etapa_ensino <= 24

gen etapa_medio = 0
replace etapa_medio = 1 if fk_cod_etapa_ensino >= 25 & fk_cod_etapa_ensino <= 38

gen etapa_ef_eja = 0
replace etapa_ef_eja = 1 if fk_cod_etapa_ensino == 43 | fk_cod_etapa_ensino == 44 | ///
	fk_cod_etapa_ensino == 46 | fk_cod_etapa_ensino == 47 | fk_cod_etapa_ensino == 49 | ///
	fk_cod_etapa_ensino == 50 | fk_cod_etapa_ensino == 51 | fk_cod_etapa_ensino == 53 | ///
	fk_cod_etapa_ensino == 54 | fk_cod_etapa_ensino == 56


gen etapa_em_eja = 0
replace etapa_em_eja = 1 if fk_cod_etapa_ensino == 45 | fk_cod_etapa_ensino == 48 | ///
	fk_cod_etapa_ensino == 52 | fk_cod_etapa_ensino == 55 | fk_cod_etapa_ensino == 57


gen etapa_ep_nt = 0
replace etapa_ep_nt = 1 if fk_cod_etapa_ensino == 39 | fk_cod_etapa_ensino == 40 

/*
ef_incompleto 
ef_completo
em_completo
sup_completo

etapa_fund
etapa_medio
etapa_ef_eja
etapa_em_eja
etapa_ep_nt
*/

/*criando dummies que viraram as variáveis de número de professores quando for dado o colapse*/
/**/
/*
n_prof_ef_ef_incomp n_prof_ef_ef_comp n_prof_ef_em n_prof_ef_sup
n_prof_ef_9_ef_incomp n_prof_ef_9_ef_comp n_prof_ef_9_em n_prof_ef_9_sup
n_prof_em_ef_incomp n_prof_em_ef_comp n_prof_em_em n_prof_em_sup
n_prof_ef_eja_ef_incomp n_prof_ef_eja_ef_comp n_prof_ef_eja_em n_prof_ef_eja_sup
n_prof_em_eja_ef_incomp n_prof_em_eja_ef_comp n_prof_em_eja_em n_prof_em_eja_sup
n_prof_ep_nt_ef_incomp n_prof_ep_nt_ef_comp n_prof_ep_nt_em n_prof_ep_nt_sup
*/


gen n_prof_ef_ef_incomp = 0
replace n_prof_ef_ef_incomp =1 if ef_incompleto== 1 & etapa_fund == 1

gen n_prof_ef_ef_comp = 0
replace n_prof_ef_ef_comp = 1 if ef_completo == 1 & etapa_fund == 1

gen n_prof_ef_em = 0
replace n_prof_ef_em = 1 if em_completo & etapa_fund == 1

gen n_prof_ef_sup = 0
replace n_prof_ef_sup = 1 if sup_completo & etapa_fund == 1

gen n_prof_ef_9_ef_incomp = 0
gen n_prof_ef_9_ef_comp = 0 
gen n_prof_ef_9_em = 0 
gen n_prof_ef_9_sup = 0 


gen n_prof_em_ef_incomp = 0 
replace n_prof_em_ef_incomp = 1 if ef_incompleto==1 & etapa_medio == 1

gen n_prof_em_ef_comp = 0 
replace n_prof_em_ef_comp = 1 if ef_completo ==1 & etapa_medio == 1

gen n_prof_em_em = 0 
replace n_prof_em_em = 1 if em_completo == 1 & etapa_medio == 1 

gen n_prof_em_sup = 0
replace n_prof_em_sup = 1 if sup_completo == 1 & etapa_medio == 1

gen n_prof_ef_eja_ef_incomp = 0 
replace n_prof_ef_eja_ef_incomp = 1 if ef_incompleto==1 & etapa_ef_eja == 1

gen n_prof_ef_eja_ef_comp = 0 
replace n_prof_ef_eja_ef_comp = 1 if ef_completo == 1 & etapa_ef_eja == 1

gen n_prof_ef_eja_em = 0
replace n_prof_ef_eja_em = 1 if em_completo == 1 & etapa_ef_eja == 1 

gen n_prof_ef_eja_sup = 0
replace n_prof_ef_eja_sup = 1 if sup_completo == 1 & etapa_ef_eja == 1

gen n_prof_em_eja_ef_incomp = 0 
replace n_prof_em_eja_ef_incomp = 1 if ef_incompleto == 1 & etapa_em_eja == 1

gen n_prof_em_eja_ef_comp = 0 
replace n_prof_em_eja_ef_comp = 1 if ef_completo ==1 & etapa_em_eja == 1

gen n_prof_em_eja_em = 0 
replace n_prof_em_eja_em = 1 if em_completo == 1 & etapa_em_eja == 1

gen n_prof_em_eja_sup = 0
replace n_prof_em_eja_sup = 1 if sup_completo == 1 & etapa_em_eja ==1

gen n_prof_ep_nt_ef_incomp = 0 
replace n_prof_ep_nt_ef_incomp = 1 if  ef_incompleto == 1 & etapa_ep_nt == 1

gen n_prof_ep_nt_ef_comp = 0
replace n_prof_ep_nt_ef_comp = 1 if ef_completo == 1 & etapa_ep_nt == 1

gen n_prof_ep_nt_em = 0
replace n_prof_ep_nt_em = 1 if em_completo == 1 & etapa_ep_nt == 1

gen n_prof_ep_nt_sup = 0
replace n_prof_ep_nt_sup = 1 if sup_completo == 1 & etapa_ep_nt == 1
/*
ef_incompleto 
ef_completo
em_completo
sup_completo

etapa_fund
etapa_medio
etapa_ef_eja
etapa_em_eja
etapa_ep_nt
*/

gen n_prof_ef = 0
replace n_prof_ef = 1 if etapa_fund == 1
gen n_prof_em_ep = 0
replace n_prof_em_ep  = 1 if etapa_medio == 1 
gen n_prof_eja = 0
replace n_prof_eja = 1 if etapa_ef_eja == 1 | etapa_em_eja == 1
gen n_prof_tecn = 0
replace n_prof_tecn = 1 if etapa_ep_nt == 1

keep ano_censo fk_cod_docente pk_cod_entidade ef_incompleto ef_completo em_completo sup_completo etapa_fund etapa_medio etapa_ef_eja etapa_em_eja etapa_ep_nt n_prof_ef_ef_incomp - n_prof_tecn
collapse (sum) ef_incompleto ef_completo em_completo sup_completo etapa_fund etapa_medio etapa_ef_eja etapa_em_eja etapa_ep_nt n_prof_ef_ef_incomp - n_prof_tecn, by(pk_cod_entidade)

gen ano_censo_escolar_doc = 2007
rename pk_cod_entidade codigo_escola
save "$folderservidor\censo_escolar\censo_escolar_doc_2007.dta", replace 



/**********************************************************************************

2008

**********************************************************************************/


use "\\fs-eesp-01\EESP-BD-01\BASES-CMICRO\Educacao\Censo Escolar\Censo Escolar 2008\DADOS\docentes_co.dta", clear
append using "\\fs-eesp-01\EESP-BD-01\BASES-CMICRO\Educacao\Censo Escolar\Censo Escolar 2008\DADOS\docentes_nordeste.dta"
append using "\\fs-eesp-01\EESP-BD-01\BASES-CMICRO\Educacao\Censo Escolar\Censo Escolar 2008\DADOS\docentes_sudeste.dta"

keep ano_censo fk_cod_docente fk_cod_escolaridade fk_cod_etapa_ensino pk_cod_entidade


gen ef_incompleto=0
replace ef_incompleto = 1 if fk_cod_escolaridade == 1

gen ef_completo =0
replace ef_completo = 1 if fk_cod_escolaridade == 2

gen em_completo =0 
replace em_completo =1 if fk_cod_escolaridade >= 3 & fk_cod_escolaridade <= 5

gen sup_completo = 0
*replace sup_completo =1 if fk_cod_escolaridade == 6 | fk_cod_escolaridade == 7 (do ano de 2007)
replace sup_completo =1 if fk_cod_escolaridade == 6 

gen etapa_fund = 0
replace etapa_fund = 1 if fk_cod_etapa_ensino >= 4 & fk_cod_etapa_ensino <= 24

gen etapa_medio = 0
replace etapa_medio = 1 if fk_cod_etapa_ensino >= 25 & fk_cod_etapa_ensino <= 38

gen etapa_ef_eja = 0
/*replace etapa_ef_eja = 1 if fk_cod_etapa_ensino == 43 | fk_cod_etapa_ensino == 44 | ///
	fk_cod_etapa_ensino == 46 | fk_cod_etapa_ensino == 47 | fk_cod_etapa_ensino == 49 | ///
	fk_cod_etapa_ensino == 50 | fk_cod_etapa_ensino == 51 | fk_cod_etapa_ensino == 53 | ///
	fk_cod_etapa_ensino == 54 | fk_cod_etapa_ensino == 56 (do ano de 2007)*/
replace etapa_ef_eja = 1 if fk_cod_etapa_ensino == 43 | fk_cod_etapa_ensino == 44 | ///
	fk_cod_etapa_ensino == 46 | fk_cod_etapa_ensino == 47 | fk_cod_etapa_ensino == 49 | ///
	fk_cod_etapa_ensino == 50 | fk_cod_etapa_ensino == 51 | fk_cod_etapa_ensino == 53 | ///
	fk_cod_etapa_ensino == 54 | fk_cod_etapa_ensino == 56 |fk_cod_etapa_ensino == 58 | ///
	fk_cod_etapa_ensino == 59


gen etapa_em_eja = 0
replace etapa_em_eja = 1 if fk_cod_etapa_ensino == 45 | fk_cod_etapa_ensino == 48 | ///
	fk_cod_etapa_ensino == 52 | fk_cod_etapa_ensino == 55 | fk_cod_etapa_ensino == 57


gen etapa_ep_nt = 0
replace etapa_ep_nt = 1 if fk_cod_etapa_ensino == 39 | fk_cod_etapa_ensino == 40 

/*
ef_incompleto 
ef_completo
em_completo
sup_completo

etapa_fund
etapa_medio
etapa_ef_eja
etapa_em_eja
etapa_ep_nt
*/

/*criando dummies que viraram as variáveis de número de professores quando for dado o colapse*/
/**/
/*
n_prof_ef_ef_incomp n_prof_ef_ef_comp n_prof_ef_em n_prof_ef_sup
n_prof_ef_9_ef_incomp n_prof_ef_9_ef_comp n_prof_ef_9_em n_prof_ef_9_sup
n_prof_em_ef_incomp n_prof_em_ef_comp n_prof_em_em n_prof_em_sup
n_prof_ef_eja_ef_incomp n_prof_ef_eja_ef_comp n_prof_ef_eja_em n_prof_ef_eja_sup
n_prof_em_eja_ef_incomp n_prof_em_eja_ef_comp n_prof_em_eja_em n_prof_em_eja_sup
n_prof_ep_nt_ef_incomp n_prof_ep_nt_ef_comp n_prof_ep_nt_em n_prof_ep_nt_sup
*/


gen n_prof_ef_ef_incomp = 0
replace n_prof_ef_ef_incomp =1 if ef_incompleto== 1 & etapa_fund == 1

gen n_prof_ef_ef_comp = 0
replace n_prof_ef_ef_comp = 1 if ef_completo == 1 & etapa_fund == 1

gen n_prof_ef_em = 0
replace n_prof_ef_em = 1 if em_completo & etapa_fund == 1

gen n_prof_ef_sup = 0
replace n_prof_ef_sup = 1 if sup_completo & etapa_fund == 1

gen n_prof_ef_9_ef_incomp = 0
gen n_prof_ef_9_ef_comp = 0 
gen n_prof_ef_9_em = 0 
gen n_prof_ef_9_sup = 0 


gen n_prof_em_ef_incomp = 0 
replace n_prof_em_ef_incomp = 1 if ef_incompleto==1 & etapa_medio == 1

gen n_prof_em_ef_comp = 0 
replace n_prof_em_ef_comp = 1 if ef_completo ==1 & etapa_medio == 1

gen n_prof_em_em = 0 
replace n_prof_em_em = 1 if em_completo == 1 & etapa_medio == 1 

gen n_prof_em_sup = 0
replace n_prof_em_sup = 1 if sup_completo == 1 & etapa_medio == 1

gen n_prof_ef_eja_ef_incomp = 0 
replace n_prof_ef_eja_ef_incomp = 1 if ef_incompleto==1 & etapa_ef_eja == 1

gen n_prof_ef_eja_ef_comp = 0 
replace n_prof_ef_eja_ef_comp = 1 if ef_completo == 1 & etapa_ef_eja == 1

gen n_prof_ef_eja_em = 0
replace n_prof_ef_eja_em = 1 if em_completo == 1 & etapa_ef_eja == 1 

gen n_prof_ef_eja_sup = 0
replace n_prof_ef_eja_sup = 1 if sup_completo == 1 & etapa_ef_eja == 1

gen n_prof_em_eja_ef_incomp = 0 
replace n_prof_em_eja_ef_incomp = 1 if ef_incompleto == 1 & etapa_em_eja == 1

gen n_prof_em_eja_ef_comp = 0 
replace n_prof_em_eja_ef_comp = 1 if ef_completo ==1 & etapa_em_eja == 1

gen n_prof_em_eja_em = 0 
replace n_prof_em_eja_em = 1 if em_completo == 1 & etapa_em_eja == 1

gen n_prof_em_eja_sup = 0
replace n_prof_em_eja_sup = 1 if sup_completo == 1 & etapa_em_eja ==1

gen n_prof_ep_nt_ef_incomp = 0 
replace n_prof_ep_nt_ef_incomp = 1 if  ef_incompleto == 1 & etapa_ep_nt == 1

gen n_prof_ep_nt_ef_comp = 0
replace n_prof_ep_nt_ef_comp = 1 if ef_completo == 1 & etapa_ep_nt == 1

gen n_prof_ep_nt_em = 0
replace n_prof_ep_nt_em = 1 if em_completo == 1 & etapa_ep_nt == 1

gen n_prof_ep_nt_sup = 0
replace n_prof_ep_nt_sup = 1 if sup_completo == 1 & etapa_ep_nt == 1
/*
ef_incompleto 
ef_completo
em_completo
sup_completo

etapa_fund
etapa_medio
etapa_ef_eja
etapa_em_eja
etapa_ep_nt
*/

gen n_prof_ef = 0
replace n_prof_ef = 1 if etapa_fund == 1
gen n_prof_em_ep = 0
replace n_prof_em_ep  = 1 if etapa_medio == 1 
gen n_prof_eja = 0
replace n_prof_eja = 1 if etapa_ef_eja == 1 | etapa_em_eja == 1
gen n_prof_tecn = 0
replace n_prof_tecn = 1 if etapa_ep_nt == 1

keep ano_censo fk_cod_docente pk_cod_entidade ef_incompleto ef_completo em_completo sup_completo etapa_fund etapa_medio etapa_ef_eja etapa_em_eja etapa_ep_nt n_prof_ef_ef_incomp - n_prof_tecn
gen ano_censo_escolar_doc = ano_censo
gen ano = ano_censo
collapse (mean) ano ano_censo_escolar_doc (sum) ef_incompleto ef_completo em_completo sup_completo etapa_fund etapa_medio etapa_ef_eja etapa_em_eja etapa_ep_nt n_prof_ef_ef_incomp - n_prof_tecn, by(pk_cod_entidade)
rename pk_cod_entidade codigo_escola
save "$folderservidor\censo_escolar\censo_escolar_doc_2008.dta", replace 


/**********************************************************************************

2009

**********************************************************************************/

use "\\fs-eesp-01\EESP-BD-01\BASES-CMICRO\Educacao\Censo Escolar\Censo Escolar 2009\DADOS\docentes_co.dta", clear
append using "\\fs-eesp-01\EESP-BD-01\BASES-CMICRO\Educacao\Censo Escolar\Censo Escolar 2009\DADOS\docentes_nordeste.dta"
append using "\\fs-eesp-01\EESP-BD-01\BASES-CMICRO\Educacao\Censo Escolar\Censo Escolar 2009\DADOS\docentes_sudeste.dta"

keep ano_censo fk_cod_docente fk_cod_escolaridade fk_cod_etapa_ensino pk_cod_entidade



gen ef_incompleto=0
replace ef_incompleto = 1 if fk_cod_escolaridade == 1

gen ef_completo =0
replace ef_completo = 1 if fk_cod_escolaridade == 2

gen em_completo =0 
replace em_completo =1 if fk_cod_escolaridade >= 3 & fk_cod_escolaridade <= 5

gen sup_completo = 0
*replace sup_completo =1 if fk_cod_escolaridade == 6 | fk_cod_escolaridade == 7 (do ano de 2007)
replace sup_completo =1 if fk_cod_escolaridade == 6 

gen etapa_fund = 0
replace etapa_fund = 1 if fk_cod_etapa_ensino >= 4 & fk_cod_etapa_ensino <= 24

gen etapa_medio = 0
replace etapa_medio = 1 if fk_cod_etapa_ensino >= 25 & fk_cod_etapa_ensino <= 38
/*
43 - EJA - Presencial - 1ª a 4ª Série
44 - EJA - Presencial - 5ª a 8ª Série
45 - EJA - Presencial - Ensino Médio
46 - EJA - Semipresencial - 1ª a 4ª Série
47 - EJA - Semipresencial - 5ª a 8ª Série
Página 37 de 37
48 - EJA - Semipresencial - Ensino Médio
51 - EJA Presencial - 1ª a 8ª Série
58 - EJA Semipresencial - 1ª a 8ª Série
60 - EJA - Presencial - Integrada à Ed.
Profissional de Nível Fundamental - FIC
61 - EJA - Semipresencial - Integrada à Ed.
Profissional de Nível Fundamental - FIC
62 - EJA - Presencial - Integrada à Ed.
Profissional de Nível Médio
63 - EJA - Semipresencial - Integrada à Ed.
Profissional de Nível Médi*/
gen etapa_ef_eja = 0
/*
replace etapa_ef_eja = 1 if fk_cod_etapa_ensino == 43 | fk_cod_etapa_ensino == 44 | ///
	fk_cod_etapa_ensino == 46 | fk_cod_etapa_ensino == 47 | fk_cod_etapa_ensino == 49 | ///
	fk_cod_etapa_ensino == 50 | fk_cod_etapa_ensino == 51 | fk_cod_etapa_ensino == 53 | ///
	fk_cod_etapa_ensino == 54 | fk_cod_etapa_ensino == 56 |fk_cod_etapa_ensino == 58 | ///
	fk_cod_etapa_ensino == 59
*/
replace etapa_ef_eja = 1 if fk_cod_etapa_ensino == 43 | fk_cod_etapa_ensino == 44 | ///
	fk_cod_etapa_ensino == 46 | fk_cod_etapa_ensino == 47 | fk_cod_etapa_ensino == 49 | ///
	fk_cod_etapa_ensino == 50 | fk_cod_etapa_ensino == 51 | fk_cod_etapa_ensino == 53 | ///
	fk_cod_etapa_ensino == 54 | fk_cod_etapa_ensino == 56 | fk_cod_etapa_ensino == 58 | ///
	fk_cod_etapa_ensino == 59 | fk_cod_etapa_ensino == 60 | fk_cod_etapa_ensino == 61



gen etapa_em_eja = 0
/*replace etapa_em_eja = 1 if fk_cod_etapa_ensino == 45 | fk_cod_etapa_ensino == 48 | ///
	fk_cod_etapa_ensino == 52 | fk_cod_etapa_ensino == 55 | fk_cod_etapa_ensino == 57
*/
replace etapa_em_eja = 1 if fk_cod_etapa_ensino == 45 | fk_cod_etapa_ensino == 48 | ///
	fk_cod_etapa_ensino == 52 | fk_cod_etapa_ensino == 55 | fk_cod_etapa_ensino == 57  | ///
	fk_cod_etapa_ensino == 62 | fk_cod_etapa_ensino == 63 

gen etapa_ep_nt = 0
replace etapa_ep_nt = 1 if fk_cod_etapa_ensino == 39 | fk_cod_etapa_ensino == 40 

/*
ef_incompleto 
ef_completo
em_completo
sup_completo

etapa_fund
etapa_medio
etapa_ef_eja
etapa_em_eja
etapa_ep_nt
*/

/*criando dummies que viraram as variáveis de número de professores quando for dado o colapse*/
/**/
/*
n_prof_ef_ef_incomp n_prof_ef_ef_comp n_prof_ef_em n_prof_ef_sup
n_prof_ef_9_ef_incomp n_prof_ef_9_ef_comp n_prof_ef_9_em n_prof_ef_9_sup
n_prof_em_ef_incomp n_prof_em_ef_comp n_prof_em_em n_prof_em_sup
n_prof_ef_eja_ef_incomp n_prof_ef_eja_ef_comp n_prof_ef_eja_em n_prof_ef_eja_sup
n_prof_em_eja_ef_incomp n_prof_em_eja_ef_comp n_prof_em_eja_em n_prof_em_eja_sup
n_prof_ep_nt_ef_incomp n_prof_ep_nt_ef_comp n_prof_ep_nt_em n_prof_ep_nt_sup
*/


gen n_prof_ef_ef_incomp = 0
replace n_prof_ef_ef_incomp =1 if ef_incompleto== 1 & etapa_fund == 1

gen n_prof_ef_ef_comp = 0
replace n_prof_ef_ef_comp = 1 if ef_completo == 1 & etapa_fund == 1

gen n_prof_ef_em = 0
replace n_prof_ef_em = 1 if em_completo & etapa_fund == 1

gen n_prof_ef_sup = 0
replace n_prof_ef_sup = 1 if sup_completo & etapa_fund == 1

gen n_prof_ef_9_ef_incomp = 0
gen n_prof_ef_9_ef_comp = 0 
gen n_prof_ef_9_em = 0 
gen n_prof_ef_9_sup = 0 


gen n_prof_em_ef_incomp = 0 
replace n_prof_em_ef_incomp = 1 if ef_incompleto==1 & etapa_medio == 1

gen n_prof_em_ef_comp = 0 
replace n_prof_em_ef_comp = 1 if ef_completo ==1 & etapa_medio == 1

gen n_prof_em_em = 0 
replace n_prof_em_em = 1 if em_completo == 1 & etapa_medio == 1 

gen n_prof_em_sup = 0
replace n_prof_em_sup = 1 if sup_completo == 1 & etapa_medio == 1

gen n_prof_ef_eja_ef_incomp = 0 
replace n_prof_ef_eja_ef_incomp = 1 if ef_incompleto==1 & etapa_ef_eja == 1

gen n_prof_ef_eja_ef_comp = 0 
replace n_prof_ef_eja_ef_comp = 1 if ef_completo == 1 & etapa_ef_eja == 1

gen n_prof_ef_eja_em = 0
replace n_prof_ef_eja_em = 1 if em_completo == 1 & etapa_ef_eja == 1 

gen n_prof_ef_eja_sup = 0
replace n_prof_ef_eja_sup = 1 if sup_completo == 1 & etapa_ef_eja == 1

gen n_prof_em_eja_ef_incomp = 0 
replace n_prof_em_eja_ef_incomp = 1 if ef_incompleto == 1 & etapa_em_eja == 1

gen n_prof_em_eja_ef_comp = 0 
replace n_prof_em_eja_ef_comp = 1 if ef_completo ==1 & etapa_em_eja == 1

gen n_prof_em_eja_em = 0 
replace n_prof_em_eja_em = 1 if em_completo == 1 & etapa_em_eja == 1

gen n_prof_em_eja_sup = 0
replace n_prof_em_eja_sup = 1 if sup_completo == 1 & etapa_em_eja ==1

gen n_prof_ep_nt_ef_incomp = 0 
replace n_prof_ep_nt_ef_incomp = 1 if  ef_incompleto == 1 & etapa_ep_nt == 1

gen n_prof_ep_nt_ef_comp = 0
replace n_prof_ep_nt_ef_comp = 1 if ef_completo == 1 & etapa_ep_nt == 1

gen n_prof_ep_nt_em = 0
replace n_prof_ep_nt_em = 1 if em_completo == 1 & etapa_ep_nt == 1

gen n_prof_ep_nt_sup = 0
replace n_prof_ep_nt_sup = 1 if sup_completo == 1 & etapa_ep_nt == 1
/*
ef_incompleto 
ef_completo
em_completo
sup_completo

etapa_fund
etapa_medio
etapa_ef_eja
etapa_em_eja
etapa_ep_nt
*/

gen n_prof_ef = 0
replace n_prof_ef = 1 if etapa_fund == 1
gen n_prof_em_ep = 0
replace n_prof_em_ep  = 1 if etapa_medio == 1 
gen n_prof_eja = 0
replace n_prof_eja = 1 if etapa_ef_eja == 1 | etapa_em_eja == 1
gen n_prof_tecn = 0
replace n_prof_tecn = 1 if etapa_ep_nt == 1

keep ano_censo fk_cod_docente pk_cod_entidade ef_incompleto ef_completo em_completo sup_completo etapa_fund etapa_medio etapa_ef_eja etapa_em_eja etapa_ep_nt n_prof_ef_ef_incomp - n_prof_tecn
gen ano_censo_escolar_doc = ano_censo
gen ano = ano_censo
collapse (mean) ano ano_censo_escolar_doc (sum) ef_incompleto ef_completo em_completo sup_completo etapa_fund etapa_medio etapa_ef_eja etapa_em_eja etapa_ep_nt n_prof_ef_ef_incomp - n_prof_tecn, by(pk_cod_entidade)
rename pk_cod_entidade codigo_escola

save "$folderservidor\censo_escolar\censo_escolar_doc_2009.dta", replace 


/**********************************************************************************

2010

**********************************************************************************/
use "\\fs-eesp-01\EESP-BD-01\BASES-CMICRO\Educacao\Censo Escolar\Censo Escolar 2010\DADOS\docentes_co.dta", clear
append using "\\fs-eesp-01\EESP-BD-01\BASES-CMICRO\Educacao\Censo Escolar\Censo Escolar 2010\DADOS\docentes_nordeste.dta"
append using "\\fs-eesp-01\EESP-BD-01\BASES-CMICRO\Educacao\Censo Escolar\Censo Escolar 2010\DADOS\docentes_sudeste.dta"



keep ano_censo fk_cod_docente fk_cod_escolaridade fk_cod_etapa_ensino pk_cod_entidade



gen ef_incompleto=0
replace ef_incompleto = 1 if fk_cod_escolaridade == 1

gen ef_completo =0
replace ef_completo = 1 if fk_cod_escolaridade == 2

gen em_completo =0 
replace em_completo =1 if fk_cod_escolaridade >= 3 & fk_cod_escolaridade <= 5

gen sup_completo = 0
*replace sup_completo =1 if fk_cod_escolaridade == 6 | fk_cod_escolaridade == 7 (do ano de 2007)
replace sup_completo =1 if fk_cod_escolaridade == 6 

gen etapa_fund = 0
replace etapa_fund = 1 if fk_cod_etapa_ensino >= 4 & fk_cod_etapa_ensino <= 24

gen etapa_medio = 0
replace etapa_medio = 1 if fk_cod_etapa_ensino >= 25 & fk_cod_etapa_ensino <= 38
/*
43 - EJA - Presencial - 1ª a 4ª Série
44 - EJA - Presencial - 5ª a 8ª Série
45 - EJA - Presencial - Ensino Médio
46 - EJA - Semipresencial - 1ª a 4ª Série
47 - EJA - Semipresencial - 5ª a 8ª Série
Página 37 de 37
48 - EJA - Semipresencial - Ensino Médio
51 - EJA Presencial - 1ª a 8ª Série
58 - EJA Semipresencial - 1ª a 8ª Série
60 - EJA - Presencial - Integrada à Ed.
Profissional de Nível Fundamental - FIC
61 - EJA - Semipresencial - Integrada à Ed.
Profissional de Nível Fundamental - FIC
62 - EJA - Presencial - Integrada à Ed.
Profissional de Nível Médio
63 - EJA - Semipresencial - Integrada à Ed.
Profissional de Nível Médi*/
gen etapa_ef_eja = 0
/*
replace etapa_ef_eja = 1 if fk_cod_etapa_ensino == 43 | fk_cod_etapa_ensino == 44 | ///
	fk_cod_etapa_ensino == 46 | fk_cod_etapa_ensino == 47 | fk_cod_etapa_ensino == 49 | ///
	fk_cod_etapa_ensino == 50 | fk_cod_etapa_ensino == 51 | fk_cod_etapa_ensino == 53 | ///
	fk_cod_etapa_ensino == 54 | fk_cod_etapa_ensino == 56 |fk_cod_etapa_ensino == 58 | ///
	fk_cod_etapa_ensino == 59
*/
replace etapa_ef_eja = 1 if fk_cod_etapa_ensino == 43 | fk_cod_etapa_ensino == 44 | ///
	fk_cod_etapa_ensino == 46 | fk_cod_etapa_ensino == 47 | fk_cod_etapa_ensino == 49 | ///
	fk_cod_etapa_ensino == 50 | fk_cod_etapa_ensino == 51 | fk_cod_etapa_ensino == 53 | ///
	fk_cod_etapa_ensino == 54 | fk_cod_etapa_ensino == 56 | fk_cod_etapa_ensino == 58 | ///
	fk_cod_etapa_ensino == 59 | fk_cod_etapa_ensino == 60 | fk_cod_etapa_ensino == 61



gen etapa_em_eja = 0
/*replace etapa_em_eja = 1 if fk_cod_etapa_ensino == 45 | fk_cod_etapa_ensino == 48 | ///
	fk_cod_etapa_ensino == 52 | fk_cod_etapa_ensino == 55 | fk_cod_etapa_ensino == 57
*/
replace etapa_em_eja = 1 if fk_cod_etapa_ensino == 45 | fk_cod_etapa_ensino == 48 | ///
	fk_cod_etapa_ensino == 52 | fk_cod_etapa_ensino == 55 | fk_cod_etapa_ensino == 57  | ///
	fk_cod_etapa_ensino == 62 | fk_cod_etapa_ensino == 63 
/*
39 - Educação Profissional (Concomitante)
40 - Educação Profissional (Subsequente)
64 - Educação Profissional Mista
(Concomitante e Subsequente)
*/
gen etapa_ep_nt = 0
*replace etapa_ep_nt = 1 if fk_cod_etapa_ensino == 39 | fk_cod_etapa_ensino == 40 

replace etapa_ep_nt = 1 if fk_cod_etapa_ensino == 39 | fk_cod_etapa_ensino == 40 | fk_cod_etapa_ensino == 64 

/*
ef_incompleto 
ef_completo
em_completo
sup_completo

etapa_fund
etapa_medio
etapa_ef_eja
etapa_em_eja
etapa_ep_nt
*/

/*criando dummies que viraram as variáveis de número de professores quando for dado o colapse*/
/**/
/*
n_prof_ef_ef_incomp n_prof_ef_ef_comp n_prof_ef_em n_prof_ef_sup
n_prof_ef_9_ef_incomp n_prof_ef_9_ef_comp n_prof_ef_9_em n_prof_ef_9_sup
n_prof_em_ef_incomp n_prof_em_ef_comp n_prof_em_em n_prof_em_sup
n_prof_ef_eja_ef_incomp n_prof_ef_eja_ef_comp n_prof_ef_eja_em n_prof_ef_eja_sup
n_prof_em_eja_ef_incomp n_prof_em_eja_ef_comp n_prof_em_eja_em n_prof_em_eja_sup
n_prof_ep_nt_ef_incomp n_prof_ep_nt_ef_comp n_prof_ep_nt_em n_prof_ep_nt_sup
*/


gen n_prof_ef_ef_incomp = 0
replace n_prof_ef_ef_incomp =1 if ef_incompleto== 1 & etapa_fund == 1

gen n_prof_ef_ef_comp = 0
replace n_prof_ef_ef_comp = 1 if ef_completo == 1 & etapa_fund == 1

gen n_prof_ef_em = 0
replace n_prof_ef_em = 1 if em_completo & etapa_fund == 1

gen n_prof_ef_sup = 0
replace n_prof_ef_sup = 1 if sup_completo & etapa_fund == 1

gen n_prof_ef_9_ef_incomp = 0
gen n_prof_ef_9_ef_comp = 0 
gen n_prof_ef_9_em = 0 
gen n_prof_ef_9_sup = 0 


gen n_prof_em_ef_incomp = 0 
replace n_prof_em_ef_incomp = 1 if ef_incompleto==1 & etapa_medio == 1

gen n_prof_em_ef_comp = 0 
replace n_prof_em_ef_comp = 1 if ef_completo ==1 & etapa_medio == 1

gen n_prof_em_em = 0 
replace n_prof_em_em = 1 if em_completo == 1 & etapa_medio == 1 

gen n_prof_em_sup = 0
replace n_prof_em_sup = 1 if sup_completo == 1 & etapa_medio == 1

gen n_prof_ef_eja_ef_incomp = 0 
replace n_prof_ef_eja_ef_incomp = 1 if ef_incompleto==1 & etapa_ef_eja == 1

gen n_prof_ef_eja_ef_comp = 0 
replace n_prof_ef_eja_ef_comp = 1 if ef_completo == 1 & etapa_ef_eja == 1

gen n_prof_ef_eja_em = 0
replace n_prof_ef_eja_em = 1 if em_completo == 1 & etapa_ef_eja == 1 

gen n_prof_ef_eja_sup = 0
replace n_prof_ef_eja_sup = 1 if sup_completo == 1 & etapa_ef_eja == 1

gen n_prof_em_eja_ef_incomp = 0 
replace n_prof_em_eja_ef_incomp = 1 if ef_incompleto == 1 & etapa_em_eja == 1

gen n_prof_em_eja_ef_comp = 0 
replace n_prof_em_eja_ef_comp = 1 if ef_completo ==1 & etapa_em_eja == 1

gen n_prof_em_eja_em = 0 
replace n_prof_em_eja_em = 1 if em_completo == 1 & etapa_em_eja == 1

gen n_prof_em_eja_sup = 0
replace n_prof_em_eja_sup = 1 if sup_completo == 1 & etapa_em_eja ==1

gen n_prof_ep_nt_ef_incomp = 0 
replace n_prof_ep_nt_ef_incomp = 1 if  ef_incompleto == 1 & etapa_ep_nt == 1

gen n_prof_ep_nt_ef_comp = 0
replace n_prof_ep_nt_ef_comp = 1 if ef_completo == 1 & etapa_ep_nt == 1

gen n_prof_ep_nt_em = 0
replace n_prof_ep_nt_em = 1 if em_completo == 1 & etapa_ep_nt == 1

gen n_prof_ep_nt_sup = 0
replace n_prof_ep_nt_sup = 1 if sup_completo == 1 & etapa_ep_nt == 1
/*
ef_incompleto 
ef_completo
em_completo
sup_completo

etapa_fund
etapa_medio
etapa_ef_eja
etapa_em_eja
etapa_ep_nt
*/

gen n_prof_ef = 0
replace n_prof_ef = 1 if etapa_fund == 1
gen n_prof_em_ep = 0
replace n_prof_em_ep  = 1 if etapa_medio == 1 
gen n_prof_eja = 0
replace n_prof_eja = 1 if etapa_ef_eja == 1 | etapa_em_eja == 1
gen n_prof_tecn = 0
replace n_prof_tecn = 1 if etapa_ep_nt == 1

keep ano_censo fk_cod_docente pk_cod_entidade ef_incompleto ef_completo em_completo sup_completo etapa_fund etapa_medio etapa_ef_eja etapa_em_eja etapa_ep_nt n_prof_ef_ef_incomp - n_prof_tecn
gen ano_censo_escolar_doc = ano_censo
gen ano = ano_censo
collapse (mean) ano ano_censo_escolar_doc (sum) ef_incompleto ef_completo em_completo sup_completo etapa_fund etapa_medio etapa_ef_eja etapa_em_eja etapa_ep_nt n_prof_ef_ef_incomp - n_prof_tecn, by(pk_cod_entidade)
rename pk_cod_entidade codigo_escola

save "$folderservidor\censo_escolar\censo_escolar_doc_2010.dta", replace 




/**********************************************************************************

2011

**********************************************************************************/
use "\\fs-eesp-01\EESP-BD-01\BASES-CMICRO\Educacao\Censo Escolar\Censo Escolar 2011\DADOS\docentes_co.dta", clear
append using "\\fs-eesp-01\EESP-BD-01\BASES-CMICRO\Educacao\Censo Escolar\Censo Escolar 2011\DADOS\docentes_nordeste.dta"
append using "\\fs-eesp-01\EESP-BD-01\BASES-CMICRO\Educacao\Censo Escolar\Censo Escolar 2011\DADOS\docentes_sudeste.dta"



keep ano_censo fk_cod_docente fk_cod_escolaridade fk_cod_etapa_ensino pk_cod_entidade



gen ef_incompleto=0
replace ef_incompleto = 1 if fk_cod_escolaridade == 1

gen ef_completo =0
replace ef_completo = 1 if fk_cod_escolaridade == 2

gen em_completo =0 
replace em_completo =1 if fk_cod_escolaridade >= 3 & fk_cod_escolaridade <= 5

gen sup_completo = 0
*replace sup_completo =1 if fk_cod_escolaridade == 6 | fk_cod_escolaridade == 7 (do ano de 2007)
replace sup_completo =1 if fk_cod_escolaridade == 6 

gen etapa_fund = 0
replace etapa_fund = 1 if fk_cod_etapa_ensino >= 4 & fk_cod_etapa_ensino <= 24

gen etapa_medio = 0
replace etapa_medio = 1 if fk_cod_etapa_ensino >= 25 & fk_cod_etapa_ensino <= 38
/*
43 - EJA - Presencial - 1ª a 4ª Série
44 - EJA - Presencial - 5ª a 8ª Série
45 - EJA - Presencial - Ensino Médio
46 - EJA - Semipresencial - 1ª a 4ª Série
47 - EJA - Semipresencial - 5ª a 8ª Série
Página 37 de 37
48 - EJA - Semipresencial - Ensino Médio
51 - EJA Presencial - 1ª a 8ª Série
58 - EJA Semipresencial - 1ª a 8ª Série
60 - EJA - Presencial - Integrada à Ed.
Profissional de Nível Fundamental - FIC
61 - EJA - Semipresencial - Integrada à Ed.
Profissional de Nível Fundamental - FIC
62 - EJA - Presencial - Integrada à Ed.
Profissional de Nível Médio
63 - EJA - Semipresencial - Integrada à Ed.
Profissional de Nível Médi*/
gen etapa_ef_eja = 0
/*
replace etapa_ef_eja = 1 if fk_cod_etapa_ensino == 43 | fk_cod_etapa_ensino == 44 | ///
	fk_cod_etapa_ensino == 46 | fk_cod_etapa_ensino == 47 | fk_cod_etapa_ensino == 49 | ///
	fk_cod_etapa_ensino == 50 | fk_cod_etapa_ensino == 51 | fk_cod_etapa_ensino == 53 | ///
	fk_cod_etapa_ensino == 54 | fk_cod_etapa_ensino == 56 |fk_cod_etapa_ensino == 58 | ///
	fk_cod_etapa_ensino == 59
*/
replace etapa_ef_eja = 1 if fk_cod_etapa_ensino == 43 | fk_cod_etapa_ensino == 44 | ///
	fk_cod_etapa_ensino == 46 | fk_cod_etapa_ensino == 47 | fk_cod_etapa_ensino == 49 | ///
	fk_cod_etapa_ensino == 50 | fk_cod_etapa_ensino == 51 | fk_cod_etapa_ensino == 53 | ///
	fk_cod_etapa_ensino == 54 | fk_cod_etapa_ensino == 56 | fk_cod_etapa_ensino == 58 | ///
	fk_cod_etapa_ensino == 59 | fk_cod_etapa_ensino == 60 | fk_cod_etapa_ensino == 61



gen etapa_em_eja = 0
/*replace etapa_em_eja = 1 if fk_cod_etapa_ensino == 45 | fk_cod_etapa_ensino == 48 | ///
	fk_cod_etapa_ensino == 52 | fk_cod_etapa_ensino == 55 | fk_cod_etapa_ensino == 57
*/
replace etapa_em_eja = 1 if fk_cod_etapa_ensino == 45 | fk_cod_etapa_ensino == 48 | ///
	fk_cod_etapa_ensino == 52 | fk_cod_etapa_ensino == 55 | fk_cod_etapa_ensino == 57  | ///
	fk_cod_etapa_ensino == 62 | fk_cod_etapa_ensino == 63 
/*
39 - Educação Profissional (Concomitante)
40 - Educação Profissional (Subsequente)
64 - Educação Profissional Mista
(Concomitante e Subsequente)
*/
gen etapa_ep_nt = 0
*replace etapa_ep_nt = 1 if fk_cod_etapa_ensino == 39 | fk_cod_etapa_ensino == 40 

replace etapa_ep_nt = 1 if fk_cod_etapa_ensino == 39 | fk_cod_etapa_ensino == 40 | fk_cod_etapa_ensino == 64 

/*
ef_incompleto 
ef_completo
em_completo
sup_completo

etapa_fund
etapa_medio
etapa_ef_eja
etapa_em_eja
etapa_ep_nt
*/

/*criando dummies que viraram as variáveis de número de professores quando for dado o colapse*/
/**/
/*
n_prof_ef_ef_incomp n_prof_ef_ef_comp n_prof_ef_em n_prof_ef_sup
n_prof_ef_9_ef_incomp n_prof_ef_9_ef_comp n_prof_ef_9_em n_prof_ef_9_sup
n_prof_em_ef_incomp n_prof_em_ef_comp n_prof_em_em n_prof_em_sup
n_prof_ef_eja_ef_incomp n_prof_ef_eja_ef_comp n_prof_ef_eja_em n_prof_ef_eja_sup
n_prof_em_eja_ef_incomp n_prof_em_eja_ef_comp n_prof_em_eja_em n_prof_em_eja_sup
n_prof_ep_nt_ef_incomp n_prof_ep_nt_ef_comp n_prof_ep_nt_em n_prof_ep_nt_sup
*/


gen n_prof_ef_ef_incomp = 0
replace n_prof_ef_ef_incomp =1 if ef_incompleto== 1 & etapa_fund == 1

gen n_prof_ef_ef_comp = 0
replace n_prof_ef_ef_comp = 1 if ef_completo == 1 & etapa_fund == 1

gen n_prof_ef_em = 0
replace n_prof_ef_em = 1 if em_completo & etapa_fund == 1

gen n_prof_ef_sup = 0
replace n_prof_ef_sup = 1 if sup_completo & etapa_fund == 1

gen n_prof_ef_9_ef_incomp = 0
gen n_prof_ef_9_ef_comp = 0 
gen n_prof_ef_9_em = 0 
gen n_prof_ef_9_sup = 0 


gen n_prof_em_ef_incomp = 0 
replace n_prof_em_ef_incomp = 1 if ef_incompleto==1 & etapa_medio == 1

gen n_prof_em_ef_comp = 0 
replace n_prof_em_ef_comp = 1 if ef_completo ==1 & etapa_medio == 1

gen n_prof_em_em = 0 
replace n_prof_em_em = 1 if em_completo == 1 & etapa_medio == 1 

gen n_prof_em_sup = 0
replace n_prof_em_sup = 1 if sup_completo == 1 & etapa_medio == 1

gen n_prof_ef_eja_ef_incomp = 0 
replace n_prof_ef_eja_ef_incomp = 1 if ef_incompleto==1 & etapa_ef_eja == 1

gen n_prof_ef_eja_ef_comp = 0 
replace n_prof_ef_eja_ef_comp = 1 if ef_completo == 1 & etapa_ef_eja == 1

gen n_prof_ef_eja_em = 0
replace n_prof_ef_eja_em = 1 if em_completo == 1 & etapa_ef_eja == 1 

gen n_prof_ef_eja_sup = 0
replace n_prof_ef_eja_sup = 1 if sup_completo == 1 & etapa_ef_eja == 1

gen n_prof_em_eja_ef_incomp = 0 
replace n_prof_em_eja_ef_incomp = 1 if ef_incompleto == 1 & etapa_em_eja == 1

gen n_prof_em_eja_ef_comp = 0 
replace n_prof_em_eja_ef_comp = 1 if ef_completo ==1 & etapa_em_eja == 1

gen n_prof_em_eja_em = 0 
replace n_prof_em_eja_em = 1 if em_completo == 1 & etapa_em_eja == 1

gen n_prof_em_eja_sup = 0
replace n_prof_em_eja_sup = 1 if sup_completo == 1 & etapa_em_eja ==1

gen n_prof_ep_nt_ef_incomp = 0 
replace n_prof_ep_nt_ef_incomp = 1 if  ef_incompleto == 1 & etapa_ep_nt == 1

gen n_prof_ep_nt_ef_comp = 0
replace n_prof_ep_nt_ef_comp = 1 if ef_completo == 1 & etapa_ep_nt == 1

gen n_prof_ep_nt_em = 0
replace n_prof_ep_nt_em = 1 if em_completo == 1 & etapa_ep_nt == 1

gen n_prof_ep_nt_sup = 0
replace n_prof_ep_nt_sup = 1 if sup_completo == 1 & etapa_ep_nt == 1
/*
ef_incompleto 
ef_completo
em_completo
sup_completo

etapa_fund
etapa_medio
etapa_ef_eja
etapa_em_eja
etapa_ep_nt
*/

gen n_prof_ef = 0
replace n_prof_ef = 1 if etapa_fund == 1
gen n_prof_em_ep = 0
replace n_prof_em_ep  = 1 if etapa_medio == 1 
gen n_prof_eja = 0
replace n_prof_eja = 1 if etapa_ef_eja == 1 | etapa_em_eja == 1
gen n_prof_tecn = 0
replace n_prof_tecn = 1 if etapa_ep_nt == 1

keep ano_censo fk_cod_docente pk_cod_entidade ef_incompleto ef_completo em_completo sup_completo etapa_fund etapa_medio etapa_ef_eja etapa_em_eja etapa_ep_nt n_prof_ef_ef_incomp - n_prof_tecn
gen ano_censo_escolar_doc = ano_censo
gen ano = ano_censo
collapse (mean) ano ano_censo_escolar_doc (sum) ef_incompleto ef_completo em_completo sup_completo etapa_fund etapa_medio etapa_ef_eja etapa_em_eja etapa_ep_nt n_prof_ef_ef_incomp - n_prof_tecn, by(pk_cod_entidade)

rename pk_cod_entidade codigo_escola
save "$folderservidor\censo_escolar\censo_escolar_doc_2011.dta", replace 



/**********************************************************************************

2012

**********************************************************************************/
use "\\fs-eesp-01\EESP-BD-01\BASES-CMICRO\Educacao\Censo Escolar\Censo Escolar 2012\DADOS\docentes_co.dta", clear
append using "\\fs-eesp-01\EESP-BD-01\BASES-CMICRO\Educacao\Censo Escolar\Censo Escolar 2012\DADOS\docentes_nordeste.dta"
append using "\\fs-eesp-01\EESP-BD-01\BASES-CMICRO\Educacao\Censo Escolar\Censo Escolar 2012\DADOS\docentes_sudeste.dta"



keep ano_censo fk_cod_docente fk_cod_escolaridade fk_cod_etapa_ensino pk_cod_entidade



gen ef_incompleto=0
replace ef_incompleto = 1 if fk_cod_escolaridade == 1

gen ef_completo =0
replace ef_completo = 1 if fk_cod_escolaridade == 2

gen em_completo =0 
replace em_completo =1 if fk_cod_escolaridade >= 3 & fk_cod_escolaridade <= 5

gen sup_completo = 0
*replace sup_completo =1 if fk_cod_escolaridade == 6 | fk_cod_escolaridade == 7 (do ano de 2007)
replace sup_completo =1 if fk_cod_escolaridade == 6 

gen etapa_fund = 0
replace etapa_fund = 1 if fk_cod_etapa_ensino >= 4 & fk_cod_etapa_ensino <= 24

gen etapa_medio = 0
replace etapa_medio = 1 if fk_cod_etapa_ensino >= 25 & fk_cod_etapa_ensino <= 38
/*
43 - EJA - Presencial - 1ª a 4ª Série
44 - EJA - Presencial - 5ª a 8ª Série
45 - EJA - Presencial - Ensino Médio
46 - EJA - Semipresencial - 1ª a 4ª Série
47 - EJA - Semipresencial - 5ª a 8ª Série
Página 37 de 37
48 - EJA - Semipresencial - Ensino Médio
51 - EJA Presencial - 1ª a 8ª Série
58 - EJA Semipresencial - 1ª a 8ª Série
60 - EJA - Presencial - Integrada à Ed.
Profissional de Nível Fundamental - FIC
61 - EJA - Semipresencial - Integrada à Ed.
Profissional de Nível Fundamental - FIC
62 - EJA - Presencial - Integrada à Ed.
Profissional de Nível Médio
63 - EJA - Semipresencial - Integrada à Ed.
Profissional de Nível Médi*/
gen etapa_ef_eja = 0
/*
replace etapa_ef_eja = 1 if fk_cod_etapa_ensino == 43 | fk_cod_etapa_ensino == 44 | ///
	fk_cod_etapa_ensino == 46 | fk_cod_etapa_ensino == 47 | fk_cod_etapa_ensino == 49 | ///
	fk_cod_etapa_ensino == 50 | fk_cod_etapa_ensino == 51 | fk_cod_etapa_ensino == 53 | ///
	fk_cod_etapa_ensino == 54 | fk_cod_etapa_ensino == 56 |fk_cod_etapa_ensino == 58 | ///
	fk_cod_etapa_ensino == 59
*/
replace etapa_ef_eja = 1 if fk_cod_etapa_ensino == 43 | fk_cod_etapa_ensino == 44 | ///
	fk_cod_etapa_ensino == 46 | fk_cod_etapa_ensino == 47 | fk_cod_etapa_ensino == 49 | ///
	fk_cod_etapa_ensino == 50 | fk_cod_etapa_ensino == 51 | fk_cod_etapa_ensino == 53 | ///
	fk_cod_etapa_ensino == 54 | fk_cod_etapa_ensino == 56 | fk_cod_etapa_ensino == 58 | ///
	fk_cod_etapa_ensino == 59 | fk_cod_etapa_ensino == 60 | fk_cod_etapa_ensino == 61 | ///
	fk_cod_etapa_ensino == 65



gen etapa_em_eja = 0
/*replace etapa_em_eja = 1 if fk_cod_etapa_ensino == 45 | fk_cod_etapa_ensino == 48 | ///
	fk_cod_etapa_ensino == 52 | fk_cod_etapa_ensino == 55 | fk_cod_etapa_ensino == 57
*/
replace etapa_em_eja = 1 if fk_cod_etapa_ensino == 45 | fk_cod_etapa_ensino == 48 | ///
	fk_cod_etapa_ensino == 52 | fk_cod_etapa_ensino == 55 | fk_cod_etapa_ensino == 57  | ///
	fk_cod_etapa_ensino == 62 | fk_cod_etapa_ensino == 63 
/*
39 - Educação Profissional (Concomitante)
40 - Educação Profissional (Subsequente)
64 - Educação Profissional Mista
(Concomitante e Subsequente)
*/
gen etapa_ep_nt = 0
*replace etapa_ep_nt = 1 if fk_cod_etapa_ensino == 39 | fk_cod_etapa_ensino == 40 

replace etapa_ep_nt = 1 if fk_cod_etapa_ensino == 39 | fk_cod_etapa_ensino == 40 | fk_cod_etapa_ensino == 64 

/*
ef_incompleto 
ef_completo
em_completo
sup_completo

etapa_fund
etapa_medio
etapa_ef_eja
etapa_em_eja
etapa_ep_nt
*/

/*criando dummies que viraram as variáveis de número de professores quando for dado o colapse*/
/**/
/*
n_prof_ef_ef_incomp n_prof_ef_ef_comp n_prof_ef_em n_prof_ef_sup
n_prof_ef_9_ef_incomp n_prof_ef_9_ef_comp n_prof_ef_9_em n_prof_ef_9_sup
n_prof_em_ef_incomp n_prof_em_ef_comp n_prof_em_em n_prof_em_sup
n_prof_ef_eja_ef_incomp n_prof_ef_eja_ef_comp n_prof_ef_eja_em n_prof_ef_eja_sup
n_prof_em_eja_ef_incomp n_prof_em_eja_ef_comp n_prof_em_eja_em n_prof_em_eja_sup
n_prof_ep_nt_ef_incomp n_prof_ep_nt_ef_comp n_prof_ep_nt_em n_prof_ep_nt_sup
*/


gen n_prof_ef_ef_incomp = 0
replace n_prof_ef_ef_incomp =1 if ef_incompleto== 1 & etapa_fund == 1

gen n_prof_ef_ef_comp = 0
replace n_prof_ef_ef_comp = 1 if ef_completo == 1 & etapa_fund == 1

gen n_prof_ef_em = 0
replace n_prof_ef_em = 1 if em_completo & etapa_fund == 1

gen n_prof_ef_sup = 0
replace n_prof_ef_sup = 1 if sup_completo & etapa_fund == 1

gen n_prof_ef_9_ef_incomp = 0
gen n_prof_ef_9_ef_comp = 0 
gen n_prof_ef_9_em = 0 
gen n_prof_ef_9_sup = 0 


gen n_prof_em_ef_incomp = 0 
replace n_prof_em_ef_incomp = 1 if ef_incompleto==1 & etapa_medio == 1

gen n_prof_em_ef_comp = 0 
replace n_prof_em_ef_comp = 1 if ef_completo ==1 & etapa_medio == 1

gen n_prof_em_em = 0 
replace n_prof_em_em = 1 if em_completo == 1 & etapa_medio == 1 

gen n_prof_em_sup = 0
replace n_prof_em_sup = 1 if sup_completo == 1 & etapa_medio == 1

gen n_prof_ef_eja_ef_incomp = 0 
replace n_prof_ef_eja_ef_incomp = 1 if ef_incompleto==1 & etapa_ef_eja == 1

gen n_prof_ef_eja_ef_comp = 0 
replace n_prof_ef_eja_ef_comp = 1 if ef_completo == 1 & etapa_ef_eja == 1

gen n_prof_ef_eja_em = 0
replace n_prof_ef_eja_em = 1 if em_completo == 1 & etapa_ef_eja == 1 

gen n_prof_ef_eja_sup = 0
replace n_prof_ef_eja_sup = 1 if sup_completo == 1 & etapa_ef_eja == 1

gen n_prof_em_eja_ef_incomp = 0 
replace n_prof_em_eja_ef_incomp = 1 if ef_incompleto == 1 & etapa_em_eja == 1

gen n_prof_em_eja_ef_comp = 0 
replace n_prof_em_eja_ef_comp = 1 if ef_completo ==1 & etapa_em_eja == 1

gen n_prof_em_eja_em = 0 
replace n_prof_em_eja_em = 1 if em_completo == 1 & etapa_em_eja == 1

gen n_prof_em_eja_sup = 0
replace n_prof_em_eja_sup = 1 if sup_completo == 1 & etapa_em_eja ==1

gen n_prof_ep_nt_ef_incomp = 0 
replace n_prof_ep_nt_ef_incomp = 1 if  ef_incompleto == 1 & etapa_ep_nt == 1

gen n_prof_ep_nt_ef_comp = 0
replace n_prof_ep_nt_ef_comp = 1 if ef_completo == 1 & etapa_ep_nt == 1

gen n_prof_ep_nt_em = 0
replace n_prof_ep_nt_em = 1 if em_completo == 1 & etapa_ep_nt == 1

gen n_prof_ep_nt_sup = 0
replace n_prof_ep_nt_sup = 1 if sup_completo == 1 & etapa_ep_nt == 1
/*
ef_incompleto 
ef_completo
em_completo
sup_completo

etapa_fund
etapa_medio
etapa_ef_eja
etapa_em_eja
etapa_ep_nt
*/

gen n_prof_ef = 0
replace n_prof_ef = 1 if etapa_fund == 1
gen n_prof_em_ep = 0
replace n_prof_em_ep  = 1 if etapa_medio == 1 
gen n_prof_eja = 0
replace n_prof_eja = 1 if etapa_ef_eja == 1 | etapa_em_eja == 1
gen n_prof_tecn = 0
replace n_prof_tecn = 1 if etapa_ep_nt == 1

keep ano_censo fk_cod_docente pk_cod_entidade ef_incompleto ef_completo em_completo sup_completo etapa_fund etapa_medio etapa_ef_eja etapa_em_eja etapa_ep_nt n_prof_ef_ef_incomp - n_prof_tecn
gen ano_censo_escolar_doc = ano_censo
gen ano = ano_censo
collapse (mean) ano ano_censo_escolar_doc (sum) ef_incompleto ef_completo em_completo sup_completo etapa_fund etapa_medio etapa_ef_eja etapa_em_eja etapa_ep_nt n_prof_ef_ef_incomp - n_prof_tecn, by(pk_cod_entidade)

rename pk_cod_entidade codigo_escola
save "$folderservidor\censo_escolar\censo_escolar_doc_2012.dta", replace 


/**********************************************************************************

2013

**********************************************************************************/
use "\\fs-eesp-01\EESP-BD-01\BASES-CMICRO\Educacao\Censo Escolar\Censo Escolar 2013\DADOS\docentes_co.dta", clear
append using "\\fs-eesp-01\EESP-BD-01\BASES-CMICRO\Educacao\Censo Escolar\Censo Escolar 2013\DADOS\docentes_nordeste.dta"
append using "\\fs-eesp-01\EESP-BD-01\BASES-CMICRO\Educacao\Censo Escolar\Censo Escolar 2013\DADOS\docentes_sudeste.dta"



keep ano_censo fk_cod_docente fk_cod_escolaridade fk_cod_etapa_ensino pk_cod_entidade



gen ef_incompleto=0
replace ef_incompleto = 1 if fk_cod_escolaridade == 1

gen ef_completo =0
replace ef_completo = 1 if fk_cod_escolaridade == 2

gen em_completo =0 
replace em_completo =1 if fk_cod_escolaridade >= 3 & fk_cod_escolaridade <= 5

gen sup_completo = 0
*replace sup_completo =1 if fk_cod_escolaridade == 6 | fk_cod_escolaridade == 7 (do ano de 2007)
replace sup_completo =1 if fk_cod_escolaridade == 6 

gen etapa_fund = 0
replace etapa_fund = 1 if fk_cod_etapa_ensino >= 4 & fk_cod_etapa_ensino <= 24

gen etapa_medio = 0
replace etapa_medio = 1 if fk_cod_etapa_ensino >= 25 & fk_cod_etapa_ensino <= 38
/*
43 - EJA - Presencial - 1ª a 4ª Série
44 - EJA - Presencial - 5ª a 8ª Série
45 - EJA - Presencial - Ensino Médio
46 - EJA - Semipresencial - 1ª a 4ª Série
47 - EJA - Semipresencial - 5ª a 8ª Série
Página 37 de 37
48 - EJA - Semipresencial - Ensino Médio
51 - EJA Presencial - 1ª a 8ª Série
58 - EJA Semipresencial - 1ª a 8ª Série
60 - EJA - Presencial - Integrada à Ed.
Profissional de Nível Fundamental - FIC
61 - EJA - Semipresencial - Integrada à Ed.
Profissional de Nível Fundamental - FIC
62 - EJA - Presencial - Integrada à Ed.
Profissional de Nível Médio
63 - EJA - Semipresencial - Integrada à Ed.
Profissional de Nível Médi*/
gen etapa_ef_eja = 0
/*
replace etapa_ef_eja = 1 if fk_cod_etapa_ensino == 43 | fk_cod_etapa_ensino == 44 | ///
	fk_cod_etapa_ensino == 46 | fk_cod_etapa_ensino == 47 | fk_cod_etapa_ensino == 49 | ///
	fk_cod_etapa_ensino == 50 | fk_cod_etapa_ensino == 51 | fk_cod_etapa_ensino == 53 | ///
	fk_cod_etapa_ensino == 54 | fk_cod_etapa_ensino == 56 |fk_cod_etapa_ensino == 58 | ///
	fk_cod_etapa_ensino == 59
*/
replace etapa_ef_eja = 1 if fk_cod_etapa_ensino == 43 | fk_cod_etapa_ensino == 44 | ///
	fk_cod_etapa_ensino == 46 | fk_cod_etapa_ensino == 47 | fk_cod_etapa_ensino == 49 | ///
	fk_cod_etapa_ensino == 50 | fk_cod_etapa_ensino == 51 | fk_cod_etapa_ensino == 53 | ///
	fk_cod_etapa_ensino == 54 | fk_cod_etapa_ensino == 56 | fk_cod_etapa_ensino == 58 | ///
	fk_cod_etapa_ensino == 59 | fk_cod_etapa_ensino == 60 | fk_cod_etapa_ensino == 61 | ///
	fk_cod_etapa_ensino == 65



gen etapa_em_eja = 0
/*replace etapa_em_eja = 1 if fk_cod_etapa_ensino == 45 | fk_cod_etapa_ensino == 48 | ///
	fk_cod_etapa_ensino == 52 | fk_cod_etapa_ensino == 55 | fk_cod_etapa_ensino == 57
*/
replace etapa_em_eja = 1 if fk_cod_etapa_ensino == 45 | fk_cod_etapa_ensino == 48 | ///
	fk_cod_etapa_ensino == 52 | fk_cod_etapa_ensino == 55 | fk_cod_etapa_ensino == 57  | ///
	fk_cod_etapa_ensino == 62 | fk_cod_etapa_ensino == 63 
/*
39 - Educação Profissional (Concomitante)
40 - Educação Profissional (Subsequente)
64 - Educação Profissional Mista
(Concomitante e Subsequente)
*/
gen etapa_ep_nt = 0
*replace etapa_ep_nt = 1 if fk_cod_etapa_ensino == 39 | fk_cod_etapa_ensino == 40 

replace etapa_ep_nt = 1 if fk_cod_etapa_ensino == 39 | fk_cod_etapa_ensino == 40 | fk_cod_etapa_ensino == 64 

/*
ef_incompleto 
ef_completo
em_completo
sup_completo

etapa_fund
etapa_medio
etapa_ef_eja
etapa_em_eja
etapa_ep_nt
*/

/*criando dummies que viraram as variáveis de número de professores quando for dado o colapse*/
/**/
/*
n_prof_ef_ef_incomp n_prof_ef_ef_comp n_prof_ef_em n_prof_ef_sup
n_prof_ef_9_ef_incomp n_prof_ef_9_ef_comp n_prof_ef_9_em n_prof_ef_9_sup
n_prof_em_ef_incomp n_prof_em_ef_comp n_prof_em_em n_prof_em_sup
n_prof_ef_eja_ef_incomp n_prof_ef_eja_ef_comp n_prof_ef_eja_em n_prof_ef_eja_sup
n_prof_em_eja_ef_incomp n_prof_em_eja_ef_comp n_prof_em_eja_em n_prof_em_eja_sup
n_prof_ep_nt_ef_incomp n_prof_ep_nt_ef_comp n_prof_ep_nt_em n_prof_ep_nt_sup
*/


gen n_prof_ef_ef_incomp = 0
replace n_prof_ef_ef_incomp =1 if ef_incompleto== 1 & etapa_fund == 1

gen n_prof_ef_ef_comp = 0
replace n_prof_ef_ef_comp = 1 if ef_completo == 1 & etapa_fund == 1

gen n_prof_ef_em = 0
replace n_prof_ef_em = 1 if em_completo & etapa_fund == 1

gen n_prof_ef_sup = 0
replace n_prof_ef_sup = 1 if sup_completo & etapa_fund == 1

gen n_prof_ef_9_ef_incomp = 0
gen n_prof_ef_9_ef_comp = 0 
gen n_prof_ef_9_em = 0 
gen n_prof_ef_9_sup = 0 


gen n_prof_em_ef_incomp = 0 
replace n_prof_em_ef_incomp = 1 if ef_incompleto==1 & etapa_medio == 1

gen n_prof_em_ef_comp = 0 
replace n_prof_em_ef_comp = 1 if ef_completo ==1 & etapa_medio == 1

gen n_prof_em_em = 0 
replace n_prof_em_em = 1 if em_completo == 1 & etapa_medio == 1 

gen n_prof_em_sup = 0
replace n_prof_em_sup = 1 if sup_completo == 1 & etapa_medio == 1

gen n_prof_ef_eja_ef_incomp = 0 
replace n_prof_ef_eja_ef_incomp = 1 if ef_incompleto==1 & etapa_ef_eja == 1

gen n_prof_ef_eja_ef_comp = 0 
replace n_prof_ef_eja_ef_comp = 1 if ef_completo == 1 & etapa_ef_eja == 1

gen n_prof_ef_eja_em = 0
replace n_prof_ef_eja_em = 1 if em_completo == 1 & etapa_ef_eja == 1 

gen n_prof_ef_eja_sup = 0
replace n_prof_ef_eja_sup = 1 if sup_completo == 1 & etapa_ef_eja == 1

gen n_prof_em_eja_ef_incomp = 0 
replace n_prof_em_eja_ef_incomp = 1 if ef_incompleto == 1 & etapa_em_eja == 1

gen n_prof_em_eja_ef_comp = 0 
replace n_prof_em_eja_ef_comp = 1 if ef_completo ==1 & etapa_em_eja == 1

gen n_prof_em_eja_em = 0 
replace n_prof_em_eja_em = 1 if em_completo == 1 & etapa_em_eja == 1

gen n_prof_em_eja_sup = 0
replace n_prof_em_eja_sup = 1 if sup_completo == 1 & etapa_em_eja ==1

gen n_prof_ep_nt_ef_incomp = 0 
replace n_prof_ep_nt_ef_incomp = 1 if  ef_incompleto == 1 & etapa_ep_nt == 1

gen n_prof_ep_nt_ef_comp = 0
replace n_prof_ep_nt_ef_comp = 1 if ef_completo == 1 & etapa_ep_nt == 1

gen n_prof_ep_nt_em = 0
replace n_prof_ep_nt_em = 1 if em_completo == 1 & etapa_ep_nt == 1

gen n_prof_ep_nt_sup = 0
replace n_prof_ep_nt_sup = 1 if sup_completo == 1 & etapa_ep_nt == 1
/*
ef_incompleto 
ef_completo
em_completo
sup_completo

etapa_fund
etapa_medio
etapa_ef_eja
etapa_em_eja
etapa_ep_nt
*/

gen n_prof_ef = 0
replace n_prof_ef = 1 if etapa_fund == 1
gen n_prof_em_ep = 0
replace n_prof_em_ep  = 1 if etapa_medio == 1 
gen n_prof_eja = 0
replace n_prof_eja = 1 if etapa_ef_eja == 1 | etapa_em_eja == 1
gen n_prof_tecn = 0
replace n_prof_tecn = 1 if etapa_ep_nt == 1

keep ano_censo fk_cod_docente pk_cod_entidade ef_incompleto ef_completo em_completo sup_completo etapa_fund etapa_medio etapa_ef_eja etapa_em_eja etapa_ep_nt n_prof_ef_ef_incomp - n_prof_tecn
gen ano_censo_escolar_doc = ano_censo
gen ano = ano_censo
collapse (mean) ano ano_censo_escolar_doc (sum) ef_incompleto ef_completo em_completo sup_completo etapa_fund etapa_medio etapa_ef_eja etapa_em_eja etapa_ep_nt n_prof_ef_ef_incomp - n_prof_tecn, by(pk_cod_entidade)

rename pk_cod_entidade codigo_escola
save "$folderservidor\censo_escolar\censo_escolar_doc_2013.dta", replace 


/**********************************************************************************

2014

**********************************************************************************/
use "\\fs-eesp-01\EESP-BD-01\BASES-CMICRO\Educacao\Censo Escolar\Censo Escolar 2014\DADOS\docentes_co.dta", clear
append using "\\fs-eesp-01\EESP-BD-01\BASES-CMICRO\Educacao\Censo Escolar\Censo Escolar 2014\DADOS\docentes_nordeste.dta"
append using "\\fs-eesp-01\EESP-BD-01\BASES-CMICRO\Educacao\Censo Escolar\Censo Escolar 2014\DADOS\docentes_sudeste.dta"



keep ano_censo fk_cod_docente fk_cod_escolaridade fk_cod_etapa_ensino pk_cod_entidade



gen ef_incompleto=0
replace ef_incompleto = 1 if fk_cod_escolaridade == 1

gen ef_completo =0
replace ef_completo = 1 if fk_cod_escolaridade == 2

gen em_completo =0 
replace em_completo =1 if fk_cod_escolaridade >= 3 & fk_cod_escolaridade <= 5

gen sup_completo = 0
*replace sup_completo =1 if fk_cod_escolaridade == 6 | fk_cod_escolaridade == 7 (do ano de 2007)
replace sup_completo =1 if fk_cod_escolaridade == 6 

gen etapa_fund = 0
replace etapa_fund = 1 if fk_cod_etapa_ensino >= 4 & fk_cod_etapa_ensino <= 24

gen etapa_medio = 0
replace etapa_medio = 1 if fk_cod_etapa_ensino >= 25 & fk_cod_etapa_ensino <= 38
/*
43 - EJA - Presencial - 1ª a 4ª Série
44 - EJA - Presencial - 5ª a 8ª Série
45 - EJA - Presencial - Ensino Médio
46 - EJA - Semipresencial - 1ª a 4ª Série
47 - EJA - Semipresencial - 5ª a 8ª Série
Página 37 de 37
48 - EJA - Semipresencial - Ensino Médio
51 - EJA Presencial - 1ª a 8ª Série
58 - EJA Semipresencial - 1ª a 8ª Série
60 - EJA - Presencial - Integrada à Ed.
Profissional de Nível Fundamental - FIC
61 - EJA - Semipresencial - Integrada à Ed.
Profissional de Nível Fundamental - FIC
62 - EJA - Presencial - Integrada à Ed.
Profissional de Nível Médio
63 - EJA - Semipresencial - Integrada à Ed.
Profissional de Nível Médi*/
gen etapa_ef_eja = 0
/*
replace etapa_ef_eja = 1 if fk_cod_etapa_ensino == 43 | fk_cod_etapa_ensino == 44 | ///
	fk_cod_etapa_ensino == 46 | fk_cod_etapa_ensino == 47 | fk_cod_etapa_ensino == 49 | ///
	fk_cod_etapa_ensino == 50 | fk_cod_etapa_ensino == 51 | fk_cod_etapa_ensino == 53 | ///
	fk_cod_etapa_ensino == 54 | fk_cod_etapa_ensino == 56 |fk_cod_etapa_ensino == 58 | ///
	fk_cod_etapa_ensino == 59
*/
replace etapa_ef_eja = 1 if fk_cod_etapa_ensino == 43 | fk_cod_etapa_ensino == 44 | ///
	fk_cod_etapa_ensino == 46 | fk_cod_etapa_ensino == 47 | fk_cod_etapa_ensino == 49 | ///
	fk_cod_etapa_ensino == 50 | fk_cod_etapa_ensino == 51 | fk_cod_etapa_ensino == 53 | ///
	fk_cod_etapa_ensino == 54 | fk_cod_etapa_ensino == 56 | fk_cod_etapa_ensino == 58 | ///
	fk_cod_etapa_ensino == 59 | fk_cod_etapa_ensino == 60 | fk_cod_etapa_ensino == 61 | ///
	fk_cod_etapa_ensino == 65



gen etapa_em_eja = 0
/*replace etapa_em_eja = 1 if fk_cod_etapa_ensino == 45 | fk_cod_etapa_ensino == 48 | ///
	fk_cod_etapa_ensino == 52 | fk_cod_etapa_ensino == 55 | fk_cod_etapa_ensino == 57
*/
replace etapa_em_eja = 1 if fk_cod_etapa_ensino == 45 | fk_cod_etapa_ensino == 48 | ///
	fk_cod_etapa_ensino == 52 | fk_cod_etapa_ensino == 55 | fk_cod_etapa_ensino == 57  | ///
	fk_cod_etapa_ensino == 62 | fk_cod_etapa_ensino == 63 
/*
39 - Educação Profissional (Concomitante)
40 - Educação Profissional (Subsequente)
64 - Educação Profissional Mista
(Concomitante e Subsequente)
*/
gen etapa_ep_nt = 0
*replace etapa_ep_nt = 1 if fk_cod_etapa_ensino == 39 | fk_cod_etapa_ensino == 40 

replace etapa_ep_nt = 1 if fk_cod_etapa_ensino == 39 | fk_cod_etapa_ensino == 40 | fk_cod_etapa_ensino == 64 

/*
ef_incompleto 
ef_completo
em_completo
sup_completo

etapa_fund
etapa_medio
etapa_ef_eja
etapa_em_eja
etapa_ep_nt
*/

/*criando dummies que viraram as variáveis de número de professores quando for dado o colapse*/
/**/
/*
n_prof_ef_ef_incomp n_prof_ef_ef_comp n_prof_ef_em n_prof_ef_sup
n_prof_ef_9_ef_incomp n_prof_ef_9_ef_comp n_prof_ef_9_em n_prof_ef_9_sup
n_prof_em_ef_incomp n_prof_em_ef_comp n_prof_em_em n_prof_em_sup
n_prof_ef_eja_ef_incomp n_prof_ef_eja_ef_comp n_prof_ef_eja_em n_prof_ef_eja_sup
n_prof_em_eja_ef_incomp n_prof_em_eja_ef_comp n_prof_em_eja_em n_prof_em_eja_sup
n_prof_ep_nt_ef_incomp n_prof_ep_nt_ef_comp n_prof_ep_nt_em n_prof_ep_nt_sup
*/


gen n_prof_ef_ef_incomp = 0
replace n_prof_ef_ef_incomp =1 if ef_incompleto== 1 & etapa_fund == 1

gen n_prof_ef_ef_comp = 0
replace n_prof_ef_ef_comp = 1 if ef_completo == 1 & etapa_fund == 1

gen n_prof_ef_em = 0
replace n_prof_ef_em = 1 if em_completo & etapa_fund == 1

gen n_prof_ef_sup = 0
replace n_prof_ef_sup = 1 if sup_completo & etapa_fund == 1

gen n_prof_ef_9_ef_incomp = 0
gen n_prof_ef_9_ef_comp = 0 
gen n_prof_ef_9_em = 0 
gen n_prof_ef_9_sup = 0 


gen n_prof_em_ef_incomp = 0 
replace n_prof_em_ef_incomp = 1 if ef_incompleto==1 & etapa_medio == 1

gen n_prof_em_ef_comp = 0 
replace n_prof_em_ef_comp = 1 if ef_completo ==1 & etapa_medio == 1

gen n_prof_em_em = 0 
replace n_prof_em_em = 1 if em_completo == 1 & etapa_medio == 1 

gen n_prof_em_sup = 0
replace n_prof_em_sup = 1 if sup_completo == 1 & etapa_medio == 1

gen n_prof_ef_eja_ef_incomp = 0 
replace n_prof_ef_eja_ef_incomp = 1 if ef_incompleto==1 & etapa_ef_eja == 1

gen n_prof_ef_eja_ef_comp = 0 
replace n_prof_ef_eja_ef_comp = 1 if ef_completo == 1 & etapa_ef_eja == 1

gen n_prof_ef_eja_em = 0
replace n_prof_ef_eja_em = 1 if em_completo == 1 & etapa_ef_eja == 1 

gen n_prof_ef_eja_sup = 0
replace n_prof_ef_eja_sup = 1 if sup_completo == 1 & etapa_ef_eja == 1

gen n_prof_em_eja_ef_incomp = 0 
replace n_prof_em_eja_ef_incomp = 1 if ef_incompleto == 1 & etapa_em_eja == 1

gen n_prof_em_eja_ef_comp = 0 
replace n_prof_em_eja_ef_comp = 1 if ef_completo ==1 & etapa_em_eja == 1

gen n_prof_em_eja_em = 0 
replace n_prof_em_eja_em = 1 if em_completo == 1 & etapa_em_eja == 1

gen n_prof_em_eja_sup = 0
replace n_prof_em_eja_sup = 1 if sup_completo == 1 & etapa_em_eja ==1

gen n_prof_ep_nt_ef_incomp = 0 
replace n_prof_ep_nt_ef_incomp = 1 if  ef_incompleto == 1 & etapa_ep_nt == 1

gen n_prof_ep_nt_ef_comp = 0
replace n_prof_ep_nt_ef_comp = 1 if ef_completo == 1 & etapa_ep_nt == 1

gen n_prof_ep_nt_em = 0
replace n_prof_ep_nt_em = 1 if em_completo == 1 & etapa_ep_nt == 1

gen n_prof_ep_nt_sup = 0
replace n_prof_ep_nt_sup = 1 if sup_completo == 1 & etapa_ep_nt == 1
/*
ef_incompleto 
ef_completo
em_completo
sup_completo

etapa_fund
etapa_medio
etapa_ef_eja
etapa_em_eja
etapa_ep_nt
*/

gen n_prof_ef = 0
replace n_prof_ef = 1 if etapa_fund == 1
gen n_prof_em_ep = 0
replace n_prof_em_ep  = 1 if etapa_medio == 1 
gen n_prof_eja = 0
replace n_prof_eja = 1 if etapa_ef_eja == 1 | etapa_em_eja == 1
gen n_prof_tecn = 0
replace n_prof_tecn = 1 if etapa_ep_nt == 1

keep ano_censo fk_cod_docente pk_cod_entidade ef_incompleto ef_completo em_completo sup_completo etapa_fund etapa_medio etapa_ef_eja etapa_em_eja etapa_ep_nt n_prof_ef_ef_incomp - n_prof_tecn
gen ano_censo_escolar_doc = ano_censo
gen ano = ano_censo
collapse (mean) ano ano_censo_escolar_doc (sum) ef_incompleto ef_completo em_completo sup_completo etapa_fund etapa_medio etapa_ef_eja etapa_em_eja etapa_ep_nt n_prof_ef_ef_incomp - n_prof_tecn, by(pk_cod_entidade)

rename pk_cod_entidade codigo_escola
save "$folderservidor\censo_escolar\censo_escolar_doc_2014.dta", replace 






/**********************************************************************************

2015

**********************************************************************************/
use "\\fs-eesp-01\EESP-BD-01\BASES-CMICRO\Educacao\Censo Escolar\Censo Escolar 2015\DADOS\docentes_co.dta", clear
append using "\\fs-eesp-01\EESP-BD-01\BASES-CMICRO\Educacao\Censo Escolar\Censo Escolar 2015\DADOS\docentes_nordeste.dta"
append using "\\fs-eesp-01\EESP-BD-01\BASES-CMICRO\Educacao\Censo Escolar\Censo Escolar 2015\DADOS\docentes_sudeste.dta"



keep nu_ano_censo co_pessoa_fisica tp_escolaridade  tp_etapa_ensino co_entidade



gen ef_incompleto=0
replace ef_incompleto = 1 if tp_escolaridade  == 1

gen ef_completo =0
replace ef_completo = 1 if tp_escolaridade  == 2

gen em_completo =0 
replace em_completo =1 if tp_escolaridade == 3

gen sup_completo = 0

replace sup_completo =1 if tp_escolaridade  == 4

gen etapa_fund = 0
replace etapa_fund = 1 if tp_etapa_ensino >= 4 & tp_etapa_ensino <= 24

gen etapa_medio = 0
replace etapa_medio = 1 if tp_etapa_ensino >= 25 & tp_etapa_ensino <= 38
/*
43 - EJA - Presencial - 1ª a 4ª Série
44 - EJA - Presencial - 5ª a 8ª Série
45 - EJA - Presencial - Ensino Médio
46 - EJA - Semipresencial - 1ª a 4ª Série
47 - EJA - Semipresencial - 5ª a 8ª Série
Página 37 de 37
48 - EJA - Semipresencial - Ensino Médio
51 - EJA Presencial - 1ª a 8ª Série
58 - EJA Semipresencial - 1ª a 8ª Série
60 - EJA - Presencial - Integrada à Ed.
Profissional de Nível Fundamental - FIC
61 - EJA - Semipresencial - Integrada à Ed.
Profissional de Nível Fundamental - FIC
62 - EJA - Presencial - Integrada à Ed.
Profissional de Nível Médio
63 - EJA - Semipresencial - Integrada à Ed.
Profissional de Nível Médi*/
gen etapa_ef_eja = 0
/*
replace etapa_ef_eja = 1 if tp_etapa_ensino == 43 | tp_etapa_ensino == 44 | ///
	tp_etapa_ensino == 46 | tp_etapa_ensino == 47 | tp_etapa_ensino == 49 | ///
	tp_etapa_ensino == 50 | tp_etapa_ensino == 51 | tp_etapa_ensino == 53 | ///
	tp_etapa_ensino == 54 | tp_etapa_ensino == 56 |tp_etapa_ensino == 58 | ///
	tp_etapa_ensino == 59
*/
replace etapa_ef_eja = 1 if tp_etapa_ensino == 43 | tp_etapa_ensino == 44 | ///
	tp_etapa_ensino == 46 | tp_etapa_ensino == 47 | tp_etapa_ensino == 49 | ///
	tp_etapa_ensino == 50 | tp_etapa_ensino == 51 | tp_etapa_ensino == 53 | ///
	tp_etapa_ensino == 54 | tp_etapa_ensino == 56 | tp_etapa_ensino == 58 | ///
	tp_etapa_ensino == 59 | tp_etapa_ensino == 60 | tp_etapa_ensino == 61 | ///
	tp_etapa_ensino == 65 | tp_etapa_ensino == 69 | tp_etapa_ensino == 70 | ///
	tp_etapa_ensino == 72 | tp_etapa_ensino == 73 



gen etapa_em_eja = 0
/*replace etapa_em_eja = 1 if tp_etapa_ensino == 45 | tp_etapa_ensino == 48 | ///
	tp_etapa_ensino == 52 | tp_etapa_ensino == 55 | tp_etapa_ensino == 57
*/
replace etapa_em_eja = 1 if tp_etapa_ensino == 45 | tp_etapa_ensino == 48 | ///
	tp_etapa_ensino == 52 | tp_etapa_ensino == 55 | tp_etapa_ensino == 57 | ///
	tp_etapa_ensino == 62 | tp_etapa_ensino == 63 | tp_etapa_ensino == 67 | ///
	tp_etapa_ensino == 71 | tp_etapa_ensino == 74
/*
39 - Educação Profissional (Concomitante)
40 - Educação Profissional (Subsequente)
64 - Educação Profissional Mista
(Concomitante e Subsequente)
*/
gen etapa_ep_nt = 0
*replace etapa_ep_nt = 1 if tp_etapa_ensino == 39 | tp_etapa_ensino == 40 

replace etapa_ep_nt = 1 if tp_etapa_ensino == 39 | tp_etapa_ensino == 40 | tp_etapa_ensino == 64 

/*
ef_incompleto 
ef_completo
em_completo
sup_completo

etapa_fund
etapa_medio
etapa_ef_eja
etapa_em_eja
etapa_ep_nt
*/

/*criando dummies que viraram as variáveis de número de professores quando for dado o colapse*/
/**/
/*
n_prof_ef_ef_incomp n_prof_ef_ef_comp n_prof_ef_em n_prof_ef_sup
n_prof_ef_9_ef_incomp n_prof_ef_9_ef_comp n_prof_ef_9_em n_prof_ef_9_sup
n_prof_em_ef_incomp n_prof_em_ef_comp n_prof_em_em n_prof_em_sup
n_prof_ef_eja_ef_incomp n_prof_ef_eja_ef_comp n_prof_ef_eja_em n_prof_ef_eja_sup
n_prof_em_eja_ef_incomp n_prof_em_eja_ef_comp n_prof_em_eja_em n_prof_em_eja_sup
n_prof_ep_nt_ef_incomp n_prof_ep_nt_ef_comp n_prof_ep_nt_em n_prof_ep_nt_sup
*/


gen n_prof_ef_ef_incomp = 0
replace n_prof_ef_ef_incomp =1 if ef_incompleto== 1 & etapa_fund == 1

gen n_prof_ef_ef_comp = 0
replace n_prof_ef_ef_comp = 1 if ef_completo == 1 & etapa_fund == 1

gen n_prof_ef_em = 0
replace n_prof_ef_em = 1 if em_completo & etapa_fund == 1

gen n_prof_ef_sup = 0
replace n_prof_ef_sup = 1 if sup_completo & etapa_fund == 1

gen n_prof_ef_9_ef_incomp = 0
gen n_prof_ef_9_ef_comp = 0 
gen n_prof_ef_9_em = 0 
gen n_prof_ef_9_sup = 0 


gen n_prof_em_ef_incomp = 0 
replace n_prof_em_ef_incomp = 1 if ef_incompleto==1 & etapa_medio == 1

gen n_prof_em_ef_comp = 0 
replace n_prof_em_ef_comp = 1 if ef_completo ==1 & etapa_medio == 1

gen n_prof_em_em = 0 
replace n_prof_em_em = 1 if em_completo == 1 & etapa_medio == 1 

gen n_prof_em_sup = 0
replace n_prof_em_sup = 1 if sup_completo == 1 & etapa_medio == 1

gen n_prof_ef_eja_ef_incomp = 0 
replace n_prof_ef_eja_ef_incomp = 1 if ef_incompleto==1 & etapa_ef_eja == 1

gen n_prof_ef_eja_ef_comp = 0 
replace n_prof_ef_eja_ef_comp = 1 if ef_completo == 1 & etapa_ef_eja == 1

gen n_prof_ef_eja_em = 0
replace n_prof_ef_eja_em = 1 if em_completo == 1 & etapa_ef_eja == 1 

gen n_prof_ef_eja_sup = 0
replace n_prof_ef_eja_sup = 1 if sup_completo == 1 & etapa_ef_eja == 1

gen n_prof_em_eja_ef_incomp = 0 
replace n_prof_em_eja_ef_incomp = 1 if ef_incompleto == 1 & etapa_em_eja == 1

gen n_prof_em_eja_ef_comp = 0 
replace n_prof_em_eja_ef_comp = 1 if ef_completo ==1 & etapa_em_eja == 1

gen n_prof_em_eja_em = 0 
replace n_prof_em_eja_em = 1 if em_completo == 1 & etapa_em_eja == 1

gen n_prof_em_eja_sup = 0
replace n_prof_em_eja_sup = 1 if sup_completo == 1 & etapa_em_eja ==1

gen n_prof_ep_nt_ef_incomp = 0 
replace n_prof_ep_nt_ef_incomp = 1 if  ef_incompleto == 1 & etapa_ep_nt == 1

gen n_prof_ep_nt_ef_comp = 0
replace n_prof_ep_nt_ef_comp = 1 if ef_completo == 1 & etapa_ep_nt == 1

gen n_prof_ep_nt_em = 0
replace n_prof_ep_nt_em = 1 if em_completo == 1 & etapa_ep_nt == 1

gen n_prof_ep_nt_sup = 0
replace n_prof_ep_nt_sup = 1 if sup_completo == 1 & etapa_ep_nt == 1
/*
ef_incompleto 
ef_completo
em_completo
sup_completo

etapa_fund
etapa_medio
etapa_ef_eja
etapa_em_eja
etapa_ep_nt
*/

gen n_prof_ef = 0
replace n_prof_ef = 1 if etapa_fund == 1
gen n_prof_em_ep = 0
replace n_prof_em_ep  = 1 if etapa_medio == 1 
gen n_prof_eja = 0
replace n_prof_eja = 1 if etapa_ef_eja == 1 | etapa_em_eja == 1
gen n_prof_tecn = 0
replace n_prof_tecn = 1 if etapa_ep_nt == 1

keep nu_ano_censo co_pessoa_fisica co_entidade ef_incompleto ef_completo em_completo sup_completo etapa_fund etapa_medio etapa_ef_eja etapa_em_eja etapa_ep_nt n_prof_ef_ef_incomp - n_prof_tecn
gen ano_censo_escolar_doc = nu_ano_censo
gen ano = nu_ano_censo
collapse (mean) ano ano_censo_escolar_doc (sum) ef_incompleto ef_completo em_completo sup_completo etapa_fund etapa_medio etapa_ef_eja etapa_em_eja etapa_ep_nt n_prof_ef_ef_incomp - n_prof_tecn, by(co_entidade)
rename co_entidade codigo_escola

save "$folderservidor\censo_escolar\censo_escolar_doc_2015.dta", replace 

use "$folderservidor\censo_escolar\censo_escolar_doc_2003.dta", clear

append using "$folderservidor\censo_escolar\censo_escolar_doc_2004.dta"

append using "$folderservidor\censo_escolar\censo_escolar_doc_2005.dta"
append using "$folderservidor\censo_escolar\censo_escolar_doc_2006.dta"


append using "$folderservidor\censo_escolar\censo_escolar_doc_2007.dta"
append using "$folderservidor\censo_escolar\censo_escolar_doc_2008.dta"


append using "$folderservidor\censo_escolar\censo_escolar_doc_2009.dta"
append using "$folderservidor\censo_escolar\censo_escolar_doc_2010.dta"


append using "$folderservidor\censo_escolar\censo_escolar_doc_2011.dta"
append using "$folderservidor\censo_escolar\censo_escolar_doc_2012.dta"


append using "$folderservidor\censo_escolar\censo_escolar_doc_2013.dta"
append using "$folderservidor\censo_escolar\censo_escolar_doc_2014.dta"

append using "$folderservidor\censo_escolar\censo_escolar_doc_2015.dta"

replace ano = ano_censo_escolar_doc if ano ==.
replace codigo_escola = pk_cod_entidade if codigo_escola==.
drop _merge pk_cod_entidade mascara

tab ano

tab ano if n_prof_ef != 0 
tab ano if n_prof_ef == 0  

tab ano if n_prof_em_ep != 0
tab ano if n_prof_em_ep == 0

* a base parece boa
* n_prof_ef_9_ef_incomp n_prof_ef_9_ef_comp n_prof_ef_9_em n_prof_ef_9_sup
gen n_prof_ef_todos_ef_incomp =  n_prof_ef_9_ef_incomp + n_prof_ef_ef_incomp
gen n_prof_ef_todos_ef_comp =  n_prof_ef_9_ef_comp + n_prof_ef_ef_comp
gen n_prof_ef_todos_em =  n_prof_ef_9_em + n_prof_ef_em
gen n_prof_ef_todos_sup =  n_prof_ef_9_sup + n_prof_ef_sup
drop n_prof_ef_9_ef_incomp n_prof_ef_9_ef_comp n_prof_ef_9_em n_prof_ef_9_sup
drop n_prof_ef_ef_incomp n_prof_ef_ef_comp n_prof_ef_em n_prof_ef_sup
order codigo_escola ano ano_censo_escolar_doc n_prof_ef - n_prof_tecn ///
	n_prof_ef_todos_ef_incom - n_prof_ef_todos_sup ///
	n_prof_em_ef_incom n_prof_em_ef_comp ///
	n_prof_em_em n_prof_em_sup ///
	n_prof_ef_eja_ef_incom n_prof_ef_eja_ef_comp ///
	n_prof_ef_eja_em n_prof_ef_eja_sup ///
	n_prof_em_eja_ef_incom n_prof_em_eja_ef_comp ///
	n_prof_em_eja_em n_prof_em_eja_sup ///
	n_prof_ep_nt_ef_incom n_prof_ep_nt_ef_comp ///
	n_prof_ep_nt_em n_prof_ep_nt_sup 
save "$folderservidor\censo_escolar\censo_escolar_doc_todos.dta",replace
