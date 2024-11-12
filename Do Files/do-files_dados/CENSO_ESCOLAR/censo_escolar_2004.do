/*CENSO ESCOLAR 2004 - replic*/
/*criado: 26/05/2018*/
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
str NIVELMED 165-165
str PRED_ESC 182-182
str DIRETORI 208-208
str SAL_DE_P 210-210
str REFEITOR 215-215
str LAB_INFO 218-218
str LAB_CIEN 219-219
str QUAD_DES 224-224
str QUAD_COB 225-225
str BIBLIO 241-241
str SAL_LEIT 242-242
str LIXO_COL 278-278
VCOPIAD 356-367
ARSALAS 368-379
VIMPRESS 500-511
str INTERNET 537-537
str ENER_PUB 558-558
str AGUA_PUB 573-573
str ESG_PUB 578-578
str DIRSUP_SEM 607-607
str DIRSUP_COM 608-608
str DIR_POS 609-609
str DIR_CONC 610-610
str DIR_INDIC 611-611
str DIR_ELEI 612-612
PERMANEN 676-687
PROVISOR 688-699
NOESTAB 700-711
FORAESTA 712-723
VDG1C4 808-819
VDG175 1576-1587
VDG176 1588-1599
VDG177 1600-1611
str VEM2111 21264-21264
str VEM2112 21265-21265
str VEM2113 21266-21266
str VEM2114 21267-21267
str VEM2121 21268-21268
str VEM2122 21269-21269
str VEM2123 21270-21270
str VEM2124 21271-21271
DEM113 21272-21283
DEM114 21284-21295
DEM115 21296-21307
DEM116 21308-21319
DEM117 21320-21331
DEM118 21332-21343
DEM119 21344-21355
DEM11A 21356-21367
DEM11B 21368-21379
DEM11C 21380-21391
NEM113 21392-21403
NEM114 21404-21415
NEM115 21416-21427
NEM116 21428-21439
NEM117 21440-21451
NEM118 21452-21463
NEM119 21464-21475
NEM11A 21476-21487
NEM11B 21488-21499
NEM11C 21500-21511
VEM4D21 23492-23503
VEM4D22 23504-23515
VEM4D23 23516-23527
VEM4D24 23528-23539
VEM4D25 23540-23551
VEM4N21 23612-23623
VEM4N22 23624-23635
VEM4N23 23636-23647
VEM4N24 23648-23659
VEM4N25 23660-23671

using "D:\CENSO ESCOLAR 2002 - 2017\micro_censo_escolar_2004\MicrodCenso Escolar2004\DADOS\DADOS_CENSOESC.txt";

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

*variavel sinal do estado/uf
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

/*
*variavel que indica se a escola possui ensino medio professionalizante
*10
gen em_prof=.
replace em_prof=1 if NIVMEDPR=="s"
replace em_prof=0 if NIVMEDPR=="n"
drop NIVMEDPR
*/

*variavel que indica se local de funcionamento da escola eh um predio
*10
generate predio=.
replace predio=1 if PRED_ESC=="s"
replace predio=0 if PRED_ESC=="n"
drop PRED_ESC

*variavel que indica se existe a dependencia diretoria
*11
generate diretoria=.
replace diretoria=1 if DIRETORI=="s"
replace diretoria=0 if DIRETORI=="n"
drop DIRETORI

*variavel que indica se existe a dependencia sala de professores
*12
generate sala_professores=.
replace sala_professores=1 if SAL_DE_P=="s"
replace sala_professores=0 if SAL_DE_P=="n"
drop SAL_DE_P

*variavel que indica se existe a dependencia biblioteca
*13
generate biblioteca=.
replace biblioteca=1 if BIBLIO=="s"
replace biblioteca=0 if BIBLIO=="n"
drop BIBLIO

*variavel que indica se existe a dependencia sala de leitura
*14
generate sala_leitura=.
replace sala_leitura=1 if SAL_LEIT=="s"
replace sala_leitura=0 if SAL_LEIT=="n"
drop SAL_LEIT


*variavel que indica se existe a dependencia refeitorio
*15
generate refeitorio=.
replace refeitorio=1 if REFEITOR=="s"
replace refeitorio=0 if REFEITOR=="n"
drop REFEITOR

*variavel que indica se existe a dependencia laboratorio de informática
*16
generate lab_info=.
replace lab_info=1 if LAB_INFO=="s"
replace lab_info=0 if LAB_INFO=="n"
drop LAB_INFO

*variavel que indica se existe a dependencia laboratorio de ciencias
*17
generate lab_ciencias=.
replace lab_ciencias=1 if LAB_CIEN=="s"
replace lab_ciencias=0 if LAB_CIEN=="n"
drop LAB_CIEN

*variavel que indica se existe a dependencia quadra de esportes
*18
generate quadra_esportes=.
replace quadra_esportes=1 if QUAD_DES=="s" | QUAD_COB=="s"
replace quadra_esportes=0 if QUAD_DES=="n" & QUAD_COB=="n"
drop QUAD_DES QUAD_COB

*variavel equipamento em uso na escola maquina copiadora
*19
rename VCOPIAD n_copiadoras

*variavel equipamento de informatica em uso da escola microcomputador
*20
rename VIMPRESS n_impressoras

*variavel Equipamento em Uso na
*Escola / Ar-Condicionado em Salas de Aula
*21
rename ARSALAS n_arsalas

*variavel que indica a existencia de internet
*22
generate internet=.
replace internet=1 if INTERNET=="s"
replace internet=0 if INTERNET=="n"
drop INTERNET

*variavel que indica a existencia de coleta de lixo periodica
*23
generate lixo_coleta=.
replace lixo_coleta=1 if LIXO_COL=="s"
replace lixo_coleta=0 if LIXO_COL=="n"
drop LIXO_COL

*variavel que indica se escola eh abastecida por energia eletrica
*24
generate eletricidade=.
replace eletricidade=1 if ENER_PUB=="s"
replace eletricidade=0 if ENER_PUB=="n"
drop ENER_PUB

*variavel que indica se escola eh abastecida por agua da rede publica
*25
generate agua=.
replace agua=1 if AGUA_PUB=="s"
replace agua=0 if AGUA_PUB=="n"
drop AGUA_PUB

*variavel que indica se escola tem acesso ao esgoto 
*26
generate esgoto=.
replace esgoto=1 if ESG_PUB=="s"
replace esgoto=0 if ESG_PUB=="n"
drop ESG_PUB

*variavel que indica se o diretor tem superior sem licenciatura 
*Escolaridade do Diretor - Superior sem licenciatura
*27
generate dir_sup_sem_licen=.
replace dir_sup_sem_licen=1 if DIRSUP_SEM=="s"
replace dir_sup_sem_licen=0 if DIRSUP_SEM=="n"
drop DIRSUP_SEM

*variavel que indica se o diretor tem superior com licenciatura
*Escolaridade do Diretor - Superior com licenciatura
*28
generate dir_sup_com_licen=.
replace dir_sup_com_licen=1 if DIRSUP_COM=="s"
replace dir_sup_com_licen=0 if DIRSUP_COM=="n"
drop DIRSUP_COM

*variavel que indica se o diretor tem pós-graduação
*Escolaridade do Diretor - Pós-Graduação
*29
generate dir_pos=.
replace dir_pos=1 if DIR_POS=="s"
replace dir_pos=0 if DIR_POS=="n"
drop DIR_POS

*variavel que indiac se o diretor foi escolhido por concurso
*Forma de escolha do diretor da escola - Concurso
*30
generate dir_concurso=.
replace dir_concurso=1 if DIR_CONC=="s"
replace dir_concurso=0 if DIR_CONC=="n"
drop DIR_CONC

*variavel que indica se o direto foi escolhido por indicação
*Forma de escolha do diretor da escola - Indicação
*31
generate dir_indicado=.
replace dir_indicado=1 if DIR_INDIC=="s"
replace dir_indicado=0 if DIR_INDIC=="n"
drop DIR_INDIC

*variavel que indica se o diretor foi escolhido por eleição
*Forma de escolha do diretor da escola - Eleição
*32
generate dir_eleito=.
replace dir_eleito=1 if DIR_ELEI=="s"
replace dir_eleito=0 if DIR_ELEI=="n"
drop DIR_ELEI

*variavel de numero de salas de aula permanentes
*33
rename PERMANEN n_salas_perm

*variavel de numero de salas de aula provisorias
*34
rename PROVISOR n_salas_prov

*variavel de numero de salas de aula utilizadas no estabelecimento
*35
rename NOESTAB n_sala_util

*variavel de numero de salas de aula utilizadas fora do estabelecimento
*36
rename FORAESTA n_sala_util_fora

*variavel de numero de salas de aula utilizadas totais
*(soma de salas utilizadas dentro e fora)
*37
gen n_salas_utilizadas= n_sala_util+n_sala_util_fora

*variavel Numero de Professores no Ensino Médio e Médio Profissionalizante*/
*38
rename VDG1C4 n_profs_em

*variavel numero de Professores com Superior (3º Grau) Licenciatura Completa
*39
rename VDG175 n_profs_em_licenciatura

*variavel numero de professores com Superior (3º Grau) Completo
*sem Licenciatura Com Magistério
*40
rename VDG176 n_profs_em_magisterio

*variavel numero de professores com Superior (3º Grau) 
*Completo sem Licenciatura Sem Magistério
*41
rename VDG177 n_profs_em_sup_sem_lic_e_mag

*variavel que indica que a organizacao do em diurno é feito por séries anual
*42
generate org_series_anual_diu=.
replace org_series_anual_diu=1 if VEM2111=="s"
replace org_series_anual_diu=0 if VEM2111=="n"
drop VEM2111

*variavel que indica que a organizacao do em noturno é feito por séries anual
*43
generate org_series_anual_not=.
replace org_series_anual_not=1 if VEM2112=="s"
replace org_series_anual_not=0 if VEM2112=="n"
drop VEM2112

*variavel que indica que a organizacao do em diurno é feito por séries semestral
*44
generate org_series_semes_diu=.
replace org_series_semes_diu=1 if VEM2113=="s"
replace org_series_semes_diu=0 if VEM2113=="n"
drop VEM2113

*variavel que indica que a organizacao do em noturno é feito por séries semestral
*45
generate org_series_semes_not=.
replace org_series_anual_diu=1 if VEM2114=="s"
replace org_series_anual_diu=0 if VEM2114=="n"
drop VEM2114

*variavel que indica que a organizacao do em diurno é feito por ciclos anual
*46
generate org_ciclos_anual_diu=.
replace org_ciclos_anual_diu=1 if VEM2121=="s"
replace org_ciclos_anual_diu=0 if VEM2121=="n"
drop VEM2121

*variavel que indica que a organizacao do em noturno é feito por ciclos anual
*47
generate org_ciclos_anual_not=.
replace org_ciclos_anual_not=1 if VEM2122=="s"
replace org_ciclos_anual_not=0 if VEM2122=="n"
drop VEM2122

*variavel que indica que a organizacao do em diurno é feito por ciclos semestral
*48
generate org_ciclos_semes_diu=.
replace org_ciclos_semes_diu=1 if VEM2123=="s"
replace org_ciclos_semes_diu=0 if VEM2123=="n"
drop VEM2123

*variavel que indica que a organizacao do em noturno é feito por ciclos semestral
*49
generate org_ciclos_semes_not=.
replace org_ciclos_semes_not=1 if VEM2124=="s"
replace org_ciclos_semes_not=0 if VEM2124=="n"
drop VEM2124


*variavel Turmas na 1ª Série - Turno Diurno
*50
rename DEM113 n_turmas_diu_em_1

*variavel Turmas na 2ª Série - Turno Diurno
*51
rename DEM114 n_turmas_diu_em_2

*variavel Turmas na 3ª Série - Turno Diurno 
*52
rename DEM115 n_turmas_diu_em_3

*variavel Turmas na 4ª Série - Turno Diurno
*53
rename DEM116 n_turmas_diu_em_4

*variavel Turmas - Não Seriada - Turno Diurno
*54
rename DEM117 n_turmas_diu_em_ns

*variavel Matrículas na 1ª Série - Turno Diurno
*55
rename DEM118 n_alunos_diu_em_1

*variavel Matrículas na 2ª Série - Turno Diurno
*56
rename DEM119 n_alunos_diu_em_2

*variavel Matrículas na 3ª Série - Turno Diurno
*57
rename DEM11A n_alunos_diu_em_3

*variavel Matrículas na 4ª Série - Turno Diurno
*58
rename DEM11B n_alunos_diu_em_4

*variavel Matrículas - Não Seriada - Turno Diurno
*59
rename DEM11C n_alunos_diu_em_ns

*variavel Turmas na 1ª Série - Turno Noturno
*60
rename NEM113 n_turmas_not_em_1

*variavel Turmas na 2ª Série - Turno Noturno
*61
rename NEM114 n_turmas_not_em_2

*variavel Turmas na 3ª Série - Turno Noturno
*62
rename NEM115 n_turmas_not_em_3

*variavel Turmas na 4ª Série - Turno Noturno
*63
rename NEM116 n_turmas_not_em_4

*variavel Turmas - Não Seriada - Turno Noturno
*64
rename NEM117 n_turmas_not_em_ns

*variavel Matrículas na 1ª Série - Turno Noturno
*65
rename NEM118 n_alunos_not_em_1

*variavel Matrículas na 2ª Série - Turno Noturno
*66
rename NEM119 n_alunos_not_em_2

*variavel Matrículas na 3ª Série - Turno Noturno
*67
rename NEM11A n_alunos_not_em_3

*variavel Matrículas na 4ª Série - Turno Noturno
*68
rename NEM11B n_alunos_not_em_4

*variavel Matrículas - Não Seriada - Turno Noturno
*69
rename NEM11C n_alunos_not_em_ns

*variavel  Matrículas na 1ª,2ª.3ª,³4ª Série - Feminino - Turno Diurno
*70
rename VEM4D21 n_mulheres_diu_em_1
*71
rename VEM4D22 n_mulheres_diu_em_2
*72
rename VEM4D23 n_mulheres_diu_em_3
*73
rename VEM4D24 n_mulheres_diu_em_4
*74
rename VEM4D25 n_mulheres_diu_em_ns

*variavel  Matrículas na 1ª,2ª.3ª,³4ª Série - Feminino - Turno Noturno
*75
rename VEM4N21 n_mulheres_not_em_1
*76
rename VEM4N22 n_mulheres_not_em_2
*77
rename VEM4N23 n_mulheres_not_em_3
*78
rename VEM4N24 n_mulheres_not_em_4
*79
rename VEM4N25 n_mulheres_not_em_ns

*variavel de proporção de professores com licenciatura 
*entre todos os professores com ensino médio
*80
gen p_profs_em_licen=n_profs_em_licenciatura/n_profs_em

*variavel de proporção de professores com magistério sem licenciatura 
*entre todos os professores com ensino médio
*81
gen p_profs_em_magis=n_profs_em_magisterio/n_profs_em

*variavel de proporção de professores sem magistério sem licenciatura 
*entre todos os professores com ensino médio
*82
gen p_profs_em_sup_sem_lic_e_mag=n_profs_em_sup_sem_lic_e_mag/n_profs_em

*variavel de proporção alunos diurno 1º ano por turma diurno 1º ano
*83
gen n_alunos_turma_diu_1=n_alunos_diu_em_1/n_turmas_diu_em_1

*variavel de proporção alunos diurno 2º ano por turma diurno 2º ano
*errado no original
*84
gen n_alunos_turma_diu_2=n_alunos_diu_em_2/n_turmas_diu_em_2

*variavel de proporção alunos diurno 3º ano por turma diurno 3º ano
*errado no original
*85
gen n_alunos_turma_diu_3=n_alunos_diu_em_3/n_turmas_diu_em_3

*variavel de proporção alunos noturno 1º ano por turma noturno 1º ano
*ausente no original
*86 
gen n_alunos_turma_not_1=n_alunos_not_em_1/n_turmas_not_em_1

*variavel de proporção alunos noturno 2º ano por turma noturno 2º ano
*ausente no original
*87
gen n_alunos_turma_not_2=n_alunos_not_em_2/n_turmas_not_em_2

*variavel de proporção alunos noturno 3º ano por turma noturno 3º ano
*ausente no original
*88
gen n_alunos_turma_not_3=n_alunos_not_em_3/n_turmas_not_em_3

*variavel número de alunos no 1º ano em
*89
gen n_alunos_em_1=n_alunos_diu_em_1+n_alunos_not_em_1
replace n_alunos_em_1=n_alunos_diu_em_1 if n_alunos_not_em_1==.
replace n_alunos_em_1=n_alunos_not_em_1 if n_alunos_diu_em_1==.

*variavel número de alunos no 2º ano em
*90
gen n_alunos_em_2=n_alunos_diu_em_2+n_alunos_not_em_2
replace n_alunos_em_2=n_alunos_diu_em_2 if n_alunos_not_em_2==.
replace n_alunos_em_2=n_alunos_not_em_2 if n_alunos_diu_em_2==.

*variavel número de alunos no 3º ano em
*91
gen n_alunos_em_3=n_alunos_diu_em_3+n_alunos_not_em_3
replace n_alunos_em_3=n_alunos_diu_em_3 if n_alunos_not_em_3==.
replace n_alunos_em_3=n_alunos_not_em_3 if n_alunos_diu_em_3==.

*gerar variável que soma número de mulheres nos dois turnos (para compatibilizar com Censo 2013)
*92
gen n_mulheres_em_1=n_mulheres_diu_em_1+n_mulheres_not_em_1
replace n_mulheres_em_1=n_mulheres_diu_em_1 if n_mulheres_not_em_1==.
replace n_mulheres_em_1=n_mulheres_not_em_1 if n_mulheres_diu_em_1==.

*93
gen n_mulheres_em_2=n_mulheres_diu_em_2+n_mulheres_not_em_2
replace n_mulheres_em_2=n_mulheres_diu_em_2 if n_mulheres_not_em_2==.
replace n_mulheres_em_2=n_mulheres_not_em_2 if n_mulheres_diu_em_2==.

*94
gen n_mulheres_em_3=n_mulheres_diu_em_3+n_mulheres_not_em_3
replace n_mulheres_em_3=n_mulheres_diu_em_3 if n_mulheres_not_em_3==.
replace n_mulheres_em_3=n_mulheres_not_em_3 if n_mulheres_diu_em_3==.


*variavel prop. de mulheres no em dois turnos
*92
gen p_mulheres_em_1=n_mulheres_em_1/n_alunos_em_1
*93
gen p_mulheres_em_2=n_mulheres_em_2/n_alunos_em_2
*94
gen p_mulheres_em_3=n_mulheres_em_3/n_alunos_em_3

*variavel proporção de mulheres no diurno
*95
gen p_mulheres_diu_em_1=n_mulheres_diu_em_1/n_alunos_diu_em_1
*96
gen p_mulheres_diu_em_2=n_mulheres_diu_em_2/n_alunos_diu_em_2
*97
gen p_mulheres_diu_em_3=n_mulheres_diu_em_3/n_alunos_diu_em_3

destring codigo_municipio, replace
compress

save "D:\bases_dta\censo_escolar\2004\censo_escolar2004.dta", replace

