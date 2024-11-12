/**missings censo escolar todos**/
clear all
capture log close
set more off, permanently
global user "`:environment USERPROFILE'"
*global Folder "$user/OneDrive/EESP_ECONOMIA_mestrado_acadêmico/Dissertação/ICE/dados_ICE/Análise_Leonardo"
global Folder "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\"
global output "$Folder/resultados"
global Bases "$Folder/Bases"
global dofiles "$Folder/Do-Files"
global Logfolder "$Folder/Log"
global folderservidor "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"

log using "$Logfolder/censo_escolar_missings.log", replace



use "$folderservidor\enem_censo_escolar_14_v3.dta", clear
misstable summarize
mdesc n_copiadoras - n_profs_em_sup_sem_lic_e_mag

*  n_copiadoras - n_profs_em_sup_sem_lic_e_mag tem o mesmo padrão de missings 
*2003 até 2006
tab ano if n_copiadoras==.
tab ano if n_copiadoras!=.

* n_turmas_diu_em_1 -  n_alunos_diu_em_ns
*2003 até 2006
tab ano if n_turmas_diu_em_1==.
tab ano if n_turmas_diu_em_1!=.

* n_turmas_not_em_1 -  n_alunos_not_em_ns
*2003 até 2006
tab ano if n_turmas_not_em_1==.
tab ano if n_turmas_not_em_1!=.

*n_mulheres_em_1 - n_mulheres_em_3
* 2003 -2015
tab ano if n_mulheres_em_1==.
tab ano if n_mulheres_em_1!=.
n_mulheres_em_4 n_mulheres_em_ns
*2003
tab ano if n_mulheres_em_ns==.
tab ano if n_mulheres_em_ns!=.


tab ano if rural ==.
tab ano if rural !=.
*falta 2015
tab ano if em ==.
tab ano if em !=.

*falta 2005 2006 e 2015

tab ano if em_prof ==.
tab ano if em_prof !=. 

* as variáveis abaixo parecem estar ok
tab ano if predio ==.
tab ano if predio !=.

tab ano if diretoria ==.
tab ano if diretoria !=.

tab ano if sala_prof ==.
tab ano if sala_prof !=.


* sala de leitura tem muitos missins, mas é uma variável presente em todos os anos
*24,000
tab ano if sala_leitura==.
tab ano if sala_leitura!=.

*2007 até 2011 não tem a variável refeitório
tab ano if refeitorio ==.
tab ano if refeitorio !=.

*lab_info lab_ciencias quadra_esportes
*parece ok
tab ano if lab_info==.
tab ano if lab_info !=.

*internet 
*parece ok
tab ano if internet ==.
tab ano if internet !=.
*lixo_coleta eletricidade agua esgoto n_salas_utilizadas
*parece ok
tab ano if lixo_coleta ==.
tab ano if lixo_coleta !=.

tab ano if eletricidade ==.
tab ano if eletricidade !=.

logclose
