/*CENSO ESCOLAR 2003 - replic*/
/*criado: 25/05/2018*/
/*objetivo final: replicar os resultados obtidos anteriormente*/

/*
objetivo do do-file:
a. traduzir txt para dta
b. renomear e gerar variáveis, dropar variaveis não usadas


*/

clear all
global user "`:environment USERPROFILE'"
*global dropbox "$user/Dropbox"
global dropboxA "$user/dropbox gmail/Dropbox"
global onedrive "$user/OneDrive"

set more off
set trace on
/*
 _________________________________________________
|a.traduzindo variaveis relevantes do txt para dta|
|_________________________________________________|

*/
# delimit ;
infix 

double MASCARA 1-8
double ANO 9-13
str CODMUNIC 14-25
str UF 26-75
str SIGLA 76-77
str MUNIC 78-127
str DEP 128-137
str LOC 138-147
str CODFUNC 148-158
str NIVELMED 164-164
str NIVMEDPR 165-165
str PRED_ESC 188-188
str DIRETORI 203-203
str SAL_DE_P 205-205
str BIBLIOTE 206-206
str SALA_LEI 209-209
str REFEITOR 212-212
str LAB_INFO 215-215
str LAB_CIEN 216-216
str QUAD_DES 221-221
str QUAD_COB 222-222
VCOPIAD 279-285
ARSALAS 286-292
VIMPRESS 349-355
str INTERNET 357-357
str ENER_PUB 364-364
str AGUA_PUB 378-378
str ESG_PUB 383-383
str LIXO_COL 386-386
PERMANEN 417-423
PROVISOR 424-430
NOESTAB 431-437
FORAESTA 438-444
VDG1C4 487-493
VDG175 893-899
VDG176 900-906
VDG177 907-913
DEM113 5737-5743
DEM114 5744-5750
DEM115 5751-5757
DEM116 5758-5764
DEM117 5765-5771
DEM118 5772-5778
DEM119 5779-5785
DEM11A 5786-5792
DEM11B 5793-5799
DEM11C 5800-5806
NEM113 5807-5813
NEM114 5814-5820
NEM115 5821-5827
NEM116 5828-5834
NEM117 5835-5841
NEM118 5842-5848
NEM119 5849-5855
NEM11A 5856-5862
NEM11B 5863-5869
NEM11C 5870-5876
VEM421 6472-6478
VEM422 6479-6485
VEM423 6486-6492
VEM424 6493-6499
VEM425 6500-6506

using "D:\CENSO ESCOLAR 2002 - 2017\micro_censo_escolar_2003\MicrodCenso Escolar2003\DADOS\DADOS_CENSOESC.txt";

# delimit cr
/*
 _________________________________________________________
|b.renomear e gerar variáveis, dropar variaveis não usadas|
|_________________________________________________________|

*/

*variavel mascara
*1
rename MASCARA mascara

*variavel ano do censo
*2
rename ANO ano_censo

*variavel codigo do municipio
*3
rename CODMUNIC codigo_municipio

*variavel sigla do estado/uf
*4
rename SIGLA sigla

*variavel municipio
*5
rename MUNIC nome_municipio

*variavel dependencia administrativa
*6
rename DEP dependencia_administrativa

*variavel que indica se escola eh rural ou nao
*7
generate rural = .
replace rural = 1 if LOC == "Rural"
replace rural = 0 if LOC == "Urbana"
drop LOC

*variavel que indica condicao da escola: 1 se ativo 0 se paralisado/extinto
*8
generate ativa=.
replace ativa=1 if CODFUNC=="Ativo"
replace ativa=0 if CODFUNC=="Paralisado" | CODFUNC=="Extinto"
drop CODFUNC

*variavel que indica se a escola possui ensino medio
*9
gen em=.
replace em=1 if NIVELMED=="s"
replace em=0 if NIVELMED=="n"
drop NIVELMED

*variavel que indica se a escola possui ensino medio professionalizante
*10
gen em_prof=.
replace em_prof=1 if NIVMEDPR=="s"
replace em_prof=0 if NIVMEDPR=="n"
drop NIVMEDPR

*variavel que indica se local de funcionamento da escola eh um predio
*11
generate predio=.
replace predio=1 if PRED_ESC=="s"
replace predio=0 if PRED_ESC=="n"
drop PRED_ESC

*variavel que indica se existe a dependencia diretoria
*12
generate diretoria=.
replace diretoria=1 if DIRETORI=="s"
replace diretoria=0 if DIRETORI=="n"
drop DIRETORI

*variavel que indica se existe a dependencia sala de professores
*13
generate sala_professores=.
replace sala_professores=1 if SAL_DE_P=="s"
replace sala_professores=0 if SAL_DE_P=="n"
drop SAL_DE_P

*variavel que indica se existe a dependencia biblioteca
*14
generate biblioteca=.
replace biblioteca=1 if BIBLIOTE=="s"
replace biblioteca=0 if BIBLIOTE=="n"
drop BIBLIOTE

*variavel que indica se existe a dependencia sala de leitura
*15
generate sala_leitura=.
replace sala_leitura=1 if SALA_LEI=="s"
replace sala_leitura=0 if SALA_LEI=="n"
drop SALA_LEI

*variavel que indica se existe a dependencia refeitorio
*16
generate refeitorio=.
replace refeitorio=1 if REFEITOR=="s"
replace refeitorio=0 if REFEITOR=="n"
drop REFEITOR

*variavel que indica se existe a dependencia laboratorio de informática
*17
generate lab_info=.
replace lab_info=1 if LAB_INFO=="s"
replace lab_info=0 if LAB_INFO=="n"
drop LAB_INFO

*variavel que indica se existe a dependencia laboratorio de ciencias
*18
generate lab_ciencias=.
replace lab_ciencias=1 if LAB_CIEN=="s"
replace lab_ciencias=0 if LAB_CIEN=="n"
drop LAB_CIEN

*variavel que indica se existe a dependencia quadra de esportes
*19
generate quadra_esportes=.
replace quadra_esportes=1 if QUAD_DES=="s" | QUAD_COB=="s"
replace quadra_esportes=0 if QUAD_DES=="n" & QUAD_COB=="n"
drop QUAD_DES QUAD_COB

*variavel equipamento em uso na escola maquina copiadora
*20
rename VCOPIAD n_copiadoras

*variavel equipamento de informatica em uso da escola microcomputador
*21
rename VIMPRESS n_impressoras

*variavel Equipamento em Uso na
*Escola / Ar-Condicionado em Salas de Aula
*22
rename ARSALAS n_arsalas

*variavel que indica a existencia de internet
*23
generate internet=.
replace internet=1 if INTERNET=="s"
replace internet=0 if INTERNET=="n"
drop INTERNET

*variavel que indica a existencia de coleta de lixo periodica
*24
generate lixo_coleta=.
replace lixo_coleta=1 if LIXO_COL=="s"
replace lixo_coleta=0 if LIXO_COL=="n"
drop LIXO_COL

*variavel que indica se escola eh abastecida por energia eletrica
*25
generate eletricidade=.
replace eletricidade=1 if ENER_PUB=="s"
replace eletricidade=0 if ENER_PUB=="n"
drop ENER_PUB

*variavel que indica se escola eh abastecida por agua da rede publica
*26
generate agua=.
replace agua=1 if AGUA_PUB=="s"
replace agua=0 if AGUA_PUB=="n"
drop AGUA_PUB

*variavel que indica se escola tem acesso ao esgoto 
*27
generate esgoto=.
replace esgoto=1 if ESG_PUB=="s"
replace esgoto=0 if ESG_PUB=="n"
drop ESG_PUB

*variavel de numero de salas de aula permanentes
*28
rename PERMANEN n_salas_perm

*variavel de numero de salas de aula provisorias
*29
rename PROVISOR n_salas_prov

*variavel de numero de salas de aula utilizadas no estabelecimento
*30
rename NOESTAB n_sala_util

*variavel de numero de salas de aula utilizadas fora do estabelecimento
*31
rename FORAESTA n_sala_util_fora

*variavel de numero de salas de aula utilizadas totais
*(soma de salas utilizadas dentro e fora)
*32
gen n_salas_utilizadas= n_sala_util+n_sala_util_fora

*variavel Numero de Professores no Ensino Médio e Médio Profissionalizante*/
*33
rename VDG1C4 n_profs_em

*variavel numero de Professores com Superior (3º Grau) Licenciatura Completa
*34
rename VDG175 n_profs_em_licenciatura

*variavel numero de professores com Superior (3º Grau) Completo
*sem Licenciatura Com Magistério
*35
rename VDG176 n_profs_em_magisterio

*variavel numero de professores com Superior (3º Grau) 
*Completo sem Licenciatura Sem Magistério
*36
rename VDG177 n_profs_em_sup_sem_lic_e_mag

*variavel Turmas na 1ª Série - Turno Diurno
*37
rename DEM113 n_turmas_diu_em_1

*variavel Turmas na 2ª Série - Turno Diurno
*38
rename DEM114 n_turmas_diu_em_2

*variavel Turmas na 3ª Série - Turno Diurno 
*39
rename DEM115 n_turmas_diu_em_3

*variavel Turmas na 4ª Série - Turno Diurno
*40
rename DEM116 n_turmas_diu_em_4

*variavel Turmas - Não Seriada - Turno Diurno
*41
rename DEM117 n_turmas_diu_em_ns

*variavel Matrículas na 1ª Série - Turno Diurno
*42
rename DEM118 n_alunos_diu_em_1

*variavel Matrículas na 2ª Série - Turno Diurno
*43
rename DEM119 n_alunos_diu_em_2

*variavel Matrículas na 3ª Série - Turno Diurno
*44
rename DEM11A n_alunos_diu_em_3

*variavel Matrículas na 4ª Série - Turno Diurno
*45
rename DEM11B n_alunos_diu_em_4

*variavel Matrículas - Não Seriada - Turno Diurno
*46
rename DEM11C n_alunos_diu_em_ns

*variavel Turmas na 1ª Série - Turno Noturno
*47
rename NEM113 n_turmas_not_em_1

*variavel Turmas na 2ª Série - Turno Noturno
*48
rename NEM114 n_turmas_not_em_2

*variavel Turmas na 3ª Série - Turno Noturno
*49
rename NEM115 n_turmas_not_em_3

*variavel Turmas na 4ª Série - Turno Noturno
*50
rename NEM116 n_turmas_not_em_4

*variavel Turmas - Não Seriada - Turno Noturno
*51
rename NEM117 n_turmas_not_em_ns

*variavel Matrículas na 1ª Série - Turno Noturno
*52
rename NEM118 n_alunos_not_em_1

*variavel Matrículas na 2ª Série - Turno Noturno
*53
rename NEM119 n_alunos_not_em_2

*variavel Matrículas na 3ª Série - Turno Noturno
*54
rename NEM11A n_alunos_not_em_3

*variavel Matrículas na 4ª Série - Turno Noturno
*55
rename NEM11B n_alunos_not_em_4

*variavel Matrículas - Não Seriada - Turno Noturno
*56
rename NEM11C n_alunos_not_em_ns

*variavel Matrículas na 1ª Série - Feminino
*57
rename VEM421 n_mulheres_em_1

*variavel Matrículas na 2ª Série - Feminino
*58
rename VEM422 n_mulheres_em_2

*variavel Matrículas na 3ª Série - Feminino
*59
rename VEM423 n_mulheres_em_3

*variavel Matrículas na 4ª Série - Feminino
*60
rename VEM424 n_mulheres_em_4

*variavel Matrículas - Não Seriada - Feminino
*61
rename VEM425 n_mulheres_em_ns

*variavel de proporção de professores com licenciatura 
*entre todos os professores com ensino médio
*62
gen p_profs_em_licen=n_profs_em_licenciatura/n_profs_em

*variavel de proporção de professores com magistério sem licenciatura 
*entre todos os professores com ensino médio
*63
gen p_profs_em_magis=n_profs_em_magisterio/n_profs_em

*variavel de proporção de professores sem magistério sem licenciatura 
*entre todos os professores com ensino médio
*64
gen p_profs_em_sup_sem_lic_e_mag=n_profs_em_sup_sem_lic_e_mag/n_profs_em

*variavel de proporção alunos diurno 1º ano por turma diurno 1º ano
*65 
gen n_alunos_turma_diu_1=n_alunos_diu_em_1/n_turmas_diu_em_1

*variavel de proporção alunos diurno 2º ano por turma diurno 2º ano
*errado no original
*66
gen n_alunos_turma_diu_2=n_alunos_diu_em_2/n_turmas_diu_em_2

*variavel de proporção alunos diurno 3º ano por turma diurno 3º ano
*errado no original
*67
gen n_alunos_turma_diu_3=n_alunos_diu_em_3/n_turmas_diu_em_3

*variavel de proporção alunos noturno 1º ano por turma noturno 1º ano
*ausente no original
*68 
gen n_alunos_turma_not_1=n_alunos_not_em_1/n_turmas_not_em_1

*variavel de proporção alunos noturno 2º ano por turma noturno 2º ano
*ausente no original
*69
gen n_alunos_turma_not_2=n_alunos_not_em_2/n_turmas_not_em_2

*variavel de proporção alunos noturno 3º ano por turma noturno 3º ano
*ausente no original
*70
gen n_alunos_turma_not_3=n_alunos_not_em_3/n_turmas_not_em_3

*variavel número de alunos no 1º ano em
*71
gen n_alunos_em_1=n_alunos_diu_em_1+n_alunos_not_em_1
replace n_alunos_em_1=n_alunos_diu_em_1 if n_alunos_not_em_1==.
replace n_alunos_em_1=n_alunos_not_em_1 if n_alunos_diu_em_1==.

*variavel número de alunos no 2º ano em
*72
gen n_alunos_em_2=n_alunos_diu_em_2+n_alunos_not_em_2
replace n_alunos_em_2=n_alunos_diu_em_2 if n_alunos_not_em_2==.
replace n_alunos_em_2=n_alunos_not_em_2 if n_alunos_diu_em_2==.

*variavel número de alunos no 3º ano em
*73
gen n_alunos_em_3=n_alunos_diu_em_3+n_alunos_not_em_3
replace n_alunos_em_3=n_alunos_diu_em_3 if n_alunos_not_em_3==.
replace n_alunos_em_3=n_alunos_not_em_3 if n_alunos_diu_em_3==.

*variavel prop. de mulheres no em
*74
gen p_mulheres_em_1=n_mulheres_em_1/n_alunos_em_1
*75
gen p_mulheres_em_2=n_mulheres_em_2/n_alunos_em_2
*76
gen p_mulheres_em_3=n_mulheres_em_3/n_alunos_em_3

destring codigo_municipio, replace
compress

save "D:\bases_dta\censo_escolar\2003\censo_escolar2003.dta", replace

