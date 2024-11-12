/*CENSO ESCOLAR 2005 - replic*/
/*criado: 26/05/2018*/
/*objetivo final: replicar os resultados obtidos anteriormente*/

/*
objetivo do do-file:
a. traduzir txt para dta
b. renomear e gerar vari�veis, dropar variaveis n�o usadas


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
str NIVM_INT 166-166
str PRED_ESC 186-186
str DIRETORI 212-212
str SAL_DE_P 214-214
str REFEITOR 219-219
str LAB_INFO 222-222
str LAB_CIEN 223-223
str QUAD_DES 228-228
str QUAD_COB 229-229
str BIBLIO 245-245
str SAL_LEIT 246-246
str LIXO_COL 282-282
VIMPRESS 360-371
VCOPIAD 408-419
ARSALAS 420-431
str S_CONEX 581-581
str ENER_PUB 602-602
str AGUA_PUB 617-617
str ESG_PUB 623-623
PERMANEN 805-816
PROVISOR 817-828
NOESTAB 829-840
FORAESTA 841-852
VDG1C4 961-972
VDG175 1813-1824
VDG176 1825-1836
VDG177 1837-1848
DEM113 25737-25748
DEM114 25749-25760
DEM115 25761-25772
DEM116 25773-25784
DEM117 25785-25796
DEM118 25797-25808
DEM119 25809-25820
DEM11A 25821-25832
DEM11B 25833-25844
DEM11C 25845-25856
NEM113 25857-25868
NEM114 25869-25880
NEM115 25881-25892
NEM116 25893-25904
NEM117 25905-25916
NEM118 25917-25928
NEM119 25929-25940
NEM11A 25941-25952
NEM11B 25953-25964
NEM11C 25965-25976
VEM4D31 27897-27908
VEM4D32 27969-27980
VEM4D33 28041-28052
VEM4D34 28113-28124
VEM4D35 28185-28196
VEM4D91 28257-28268
VEM4DA1 28269-28280
VEM4DB1 28281-28292
VEM4DC1 28293-28304
VEM4DD1 28305-28316
VEM4DE1 28317-28328
VEM4D92 28329-28340
VEM4DA2 28341-28352
VEM4DB2 28353-28364
VEM4DC2 28365-28376
VEM4DD2 28377-28388
VEM4DE2 28389-28400
VEM4D93 28401-28412
VEM4DA3 28413-28424
VEM4DB3 28425-28436
VEM4DC3 28437-28448
VEM4DD3 28449-28460
VEM4DE3 28461-28472
VEM4D94 28473-28484
VEM4DA4 28485-28496
VEM4DB4 28497-28508
VEM4DC4 28509-28520
VEM4DD4 28521-28532
VEM4DE4 28533-28544
VEM4D95 28545-28556
VEM4DA5 28557-28568
VEM4DB5 28569-28580
VEM4DC5 28581-28592
VEM4DD5 28593-28604
VEM4DE5 28605-28616
VEM4N31 28617-28628
VEM4N32 28689-28700
VEM4N33 28761-28772
VEM4N34 28833-28844
VEM4N35 28905-28916
VEM4N91 28977-28988
VEM4NA1 28989-29000
VEM4NB1 29001-29012
VEM4NC1 29013-29024
VEM4ND1 29025-29036
VEM4NE1 29037-29048
VEM4N92 29049-29060
VEM4NA2 29061-29072
VEM4NB2 29073-29084
VEM4NC2 29085-29096
VEM4ND2 29097-29108
VEM4NE2 29109-29120
VEM4N93 29121-29132
VEM4NA3 29133-29144
VEM4NB3 29145-29156
VEM4NC3 29157-29168
VEM4ND3 29169-29180
VEM4NE3 29181-29192
VEM4N94 29193-29204
VEM4NA4 29205-29216
VEM4NB4 29217-29228
VEM4NC4 29229-29240
VEM4ND4 29241-29252
VEM4NE4 29253-29264
VEM4N95 29265-29276
VEM4NA5 29277-29288
VEM4NB5 29289-29300
VEM4NC5 29301-29312
VEM4ND5 29313-29324
VEM4NE5 29325-29336


using "D:\CENSO ESCOLAR 2002 - 2017\micro_censo_escolar_2005\DADOS\CENSOESC_2005.txt";

# delimit cr
/*
 _________________________________________________________
|b.renomear e gerar vari�veis, dropar variaveis n�o usadas|
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


*variavel que indica se a escola possui Ensino M�dio Integrado com Educa��o Profissional
*10
gen em_int_prof=.
replace em_int_prof=1 if NIVM_INT=="s"
replace em_int_prof=0 if NIVM_INT=="n"
drop NIVM_INT


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
replace biblioteca=1 if BIBLIO=="s"
replace biblioteca=0 if BIBLIO=="n"
drop BIBLIO

*variavel que indica se existe a dependencia sala de leitura
*15
generate sala_leitura=.
replace sala_leitura=1 if SAL_LEIT=="s"
replace sala_leitura=0 if SAL_LEIT=="n"
drop SAL_LEIT


*variavel que indica se existe a dependencia refeitorio
*16
generate refeitorio=.
replace refeitorio=1 if REFEITOR=="s"
replace refeitorio=0 if REFEITOR=="n"
drop REFEITOR

*variavel que indica se existe a dependencia laboratorio de inform�tica
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
replace internet=1 if S_CONEX=="n"
replace internet=0 if S_CONEX=="s"
drop S_CONEX

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

/*
*variavel que indica se o diretor tem superior sem licenciatura 
*Escolaridade do Diretor - Superior sem licenciatura
*28
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

*variavel que indica se o diretor tem p�s-gradua��o
*Escolaridade do Diretor - P�s-Gradua��o
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

*variavel que indica se o direto foi escolhido por indica��o
*Forma de escolha do diretor da escola - Indica��o
*31
generate dir_indicado=.
replace dir_indicado=1 if DIR_INDIC=="s"
replace dir_indicado=0 if DIR_INDIC=="n"
drop DIR_INDIC

*variavel que indica se o diretor foi escolhido por elei��o
*Forma de escolha do diretor da escola - Elei��o
*32
generate dir_eleito=.
replace dir_eleito=1 if DIR_ELEI=="s"
replace dir_eleito=0 if DIR_ELEI=="n"
drop DIR_ELEI
*/
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

*variavel Numero de Professores no Ensino M�dio e M�dio Profissionalizante*/
*33
rename VDG1C4 n_profs_em

*variavel numero de Professores com Superior (3� Grau) Licenciatura Completa
*34
rename VDG175 n_profs_em_licenciatura

*variavel numero de professores com Superior (3� Grau) Completo
*sem Licenciatura Com Magist�rio
*35
rename VDG176 n_profs_em_magisterio

*variavel numero de professores com Superior (3� Grau) 
*Completo sem Licenciatura Sem Magist�rio
*36
rename VDG177 n_profs_em_sup_sem_lic_e_mag

/*
*variavel que indica que a organizacao do em diurno � feito por s�ries anual
*42
generate org_series_anual_diu=.
replace org_series_anual_diu=1 if VEM2111=="s"
replace org_series_anual_diu=0 if VEM2111=="n"
drop VEM2111

*variavel que indica que a organizacao do em noturno � feito por s�ries anual
*43
generate org_series_anual_not=.
replace org_series_anual_not=1 if VEM2112=="s"
replace org_series_anual_not=0 if VEM2112=="n"
drop VEM2112

*variavel que indica que a organizacao do em diurno � feito por s�ries semestral
*44
generate org_series_semes_diu=.
replace org_series_semes_diu=1 if VEM2113=="s"
replace org_series_semes_diu=0 if VEM2113=="n"
drop VEM2113

*variavel que indica que a organizacao do em noturno � feito por s�ries semestral
*45
generate org_series_semes_not=.
replace org_series_anual_diu=1 if VEM2114=="s"
replace org_series_anual_diu=0 if VEM2114=="n"
drop VEM2114

*variavel que indica que a organizacao do em diurno � feito por ciclos anual
*46
generate org_ciclos_anual_diu=.
replace org_ciclos_anual_diu=1 if VEM2121=="s"
replace org_ciclos_anual_diu=0 if VEM2121=="n"
drop VEM2121

*variavel que indica que a organizacao do em noturno � feito por ciclos anual
*47
generate org_ciclos_anual_not=.
replace org_ciclos_anual_not=1 if VEM2122=="s"
replace org_ciclos_anual_not=0 if VEM2122=="n"
drop VEM2122

*variavel que indica que a organizacao do em diurno � feito por ciclos semestral
*48
generate org_ciclos_semes_diu=.
replace org_ciclos_semes_diu=1 if VEM2123=="s"
replace org_ciclos_semes_diu=0 if VEM2123=="n"
drop VEM2123

*variavel que indica que a organizacao do em noturno � feito por ciclos semestral
*49
generate org_ciclos_semes_not=.
replace org_ciclos_semes_not=1 if VEM2124=="s"
replace org_ciclos_semes_not=0 if VEM2124=="n"
drop VEM2124
*/


*variavel Turmas na 1� S�rie - Turno Diurno
*37
rename DEM113 n_turmas_diu_em_1

*variavel Turmas na 2� S�rie - Turno Diurno
*38
rename DEM114 n_turmas_diu_em_2

*variavel Turmas na 3� S�rie - Turno Diurno 
*39
rename DEM115 n_turmas_diu_em_3

*variavel Turmas na 4� S�rie - Turno Diurno
*40
rename DEM116 n_turmas_diu_em_4

*variavel Turmas - N�o Seriada - Turno Diurno
*41
rename DEM117 n_turmas_diu_em_ns

*variavel Matr�culas na 1� S�rie - Turno Diurno
*42
rename DEM118 n_alunos_diu_em_1

*variavel Matr�culas na 2� S�rie - Turno Diurno
*43
rename DEM119 n_alunos_diu_em_2

*variavel Matr�culas na 3� S�rie - Turno Diurno
*44
rename DEM11A n_alunos_diu_em_3

*variavel Matr�culas na 4� S�rie - Turno Diurno
*45
rename DEM11B n_alunos_diu_em_4

*variavel Matr�culas - N�o Seriada - Turno Diurno
*46
rename DEM11C n_alunos_diu_em_ns

*variavel Turmas na 1� S�rie - Turno Noturno
*47
rename NEM113 n_turmas_not_em_1

*variavel Turmas na 2� S�rie - Turno Noturno
*48
rename NEM114 n_turmas_not_em_2

*variavel Turmas na 3� S�rie - Turno Noturno
*49
rename NEM115 n_turmas_not_em_3

*variavel Turmas na 4� S�rie - Turno Noturno
*50
rename NEM116 n_turmas_not_em_4

*variavel Turmas - N�o Seriada - Turno Noturno
*51
rename NEM117 n_turmas_not_em_ns

*variavel Matr�culas na 1� S�rie - Turno Noturno
*52
rename NEM118 n_alunos_not_em_1

*variavel Matr�culas na 2� S�rie - Turno Noturno
*53
rename NEM119 n_alunos_not_em_2

*variavel Matr�culas na 3� S�rie - Turno Noturno
*54
rename NEM11A n_alunos_not_em_3

*variavel Matr�culas na 4� S�rie - Turno Noturno
*55
rename NEM11B n_alunos_not_em_4

*variavel Matr�culas - N�o Seriada - Turno Noturno
*56
rename NEM11C n_alunos_not_em_ns

/*
*variavel  Matr�culas na 1�,2�.3�,�4� S�rie - Feminino - Turno Diurno
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

*variavel  Matr�culas na 1�,2�.3�,�4� S�rie - Feminino - Turno Noturno
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
*/

*variavel de propor��o de professores com licenciatura 
*entre todos os professores com ensino m�dio
*57
gen p_profs_em_licen=n_profs_em_licenciatura/n_profs_em

*variavel de propor��o de professores com magist�rio sem licenciatura 
*entre todos os professores com ensino m�dio
*58
gen p_profs_em_magis=n_profs_em_magisterio/n_profs_em

*variavel de propor��o de professores sem magist�rio sem licenciatura 
*entre todos os professores com ensino m�dio
*59
gen p_profs_em_sup_sem_lic_e_mag=n_profs_em_sup_sem_lic_e_mag/n_profs_em

*variavel de propor��o alunos diurno 1� ano por turma diurno 1� ano
*60
gen n_alunos_turma_diu_1=n_alunos_diu_em_1/n_turmas_diu_em_1

*variavel de propor��o alunos diurno 2� ano por turma diurno 2� ano
*errado no original
*61
gen n_alunos_turma_diu_2=n_alunos_diu_em_2/n_turmas_diu_em_2

*variavel de propor��o alunos diurno 3� ano por turma diurno 3� ano
*errado no original
*62
gen n_alunos_turma_diu_3=n_alunos_diu_em_3/n_turmas_diu_em_3

*variavel de propor��o alunos noturno 1� ano por turma noturno 1� ano
*ausente no original
*63 
gen n_alunos_turma_not_1=n_alunos_not_em_1/n_turmas_not_em_1

*variavel de propor��o alunos noturno 2� ano por turma noturno 2� ano
*ausente no original
*64
gen n_alunos_turma_not_2=n_alunos_not_em_2/n_turmas_not_em_2

*variavel de propor��o alunos noturno 3� ano por turma noturno 3� ano
*ausente no original
*65
gen n_alunos_turma_not_3=n_alunos_not_em_3/n_turmas_not_em_3

* gerar n�mero de mulheres em cada turno
*66
gen n_mulheres_diu_em_1=VEM4D91 + VEM4DA1 + VEM4DB1 + VEM4DC1 + VEM4DD1 + VEM4DE1
*drop VEM4DA1 VEM4DB1 VEM4DC1 VEM4DD1 VEM4DE1
*67
gen n_mulheres_diu_em_2=VEM4D92 + VEM4DA2 + VEM4DB2 + VEM4DC2 + VEM4DD2 + VEM4DE2
*drop VEM4DA2 VEM4DB2 VEM4DC2 VEM4DD2 VEM4DE2
*68
gen n_mulheres_diu_em_3=VEM4D93 + VEM4DA3 + VEM4DB3 + VEM4DC3 + VEM4DD3 + VEM4DE3 
*drop VEM4DA3 VEM4DB3 VEM4DC3 VEM4DD3 VEM4DE3
*69
gen n_mulheres_diu_em_4=VEM4D94 + VEM4DA4 + VEM4DB4 + VEM4DC4 + VEM4DD4 + VEM4DE4 
*drop VEM4DA4 VEM4DB4 VEM4DC4 VEM4DD4 VEM4DE4
*70
gen n_mulheres_diu_em_ns=VEM4D95 + VEM4DA5 + VEM4DB5 + VEM4DC5 + VEM4DD5 + VEM4DE5 
*drop VEM4DA5 VEM4DB5 VEM4DC5 VEM4DD5 VEM4DE5

*71
gen n_mulheres_not_em_1=VEM4N91 + VEM4NA1 + VEM4NB1 + VEM4NC1 + VEM4ND1 + VEM4NE1
*drop VEM4N91 VEM4NA1 VEM4NB1 VEM4NC1 VEM4ND1 VEM4NE1
*72
gen n_mulheres_not_em_2=VEM4N92 + VEM4NA2 + VEM4NB2 + VEM4NC2 + VEM4ND2 + VEM4NE2
*drop VEM4N92 VEM4NA2 VEM4NB2 VEM4NC2 VEM4ND2 VEM4NE2
*73
gen n_mulheres_not_em_3=VEM4N93 + VEM4NA3 + VEM4NB3 + VEM4NC3 + VEM4ND3 + VEM4NE3 
*drop VEM4N93 VEM4NA3 VEM4NB3 VEM4NC3 VEM4ND3 VEM4NE3
*74
gen n_mulheres_not_em_4=VEM4N94 + VEM4NA4 + VEM4NB4 + VEM4NC4 + VEM4ND4 + VEM4NE4 
*drop VEM4N94 VEM4NA4 VEM4NB4 VEM4NC4 VEM4ND4 VEM4NE4
*75
gen n_mulheres_not_em_ns=VEM4N95 + VEM4NA5 + VEM4NB5 + VEM4NC5 + VEM4ND5 + VEM4NE5 
*drop VEM4N95 VEM4NA5 VEM4NB5 VEM4NC5 VEM4ND5 VEM4NE5


*variavel n�mero de alunos no 1� ano em
*76
gen n_alunos_em_1=n_alunos_diu_em_1+n_alunos_not_em_1
replace n_alunos_em_1=n_alunos_diu_em_1 if n_alunos_not_em_1==.
replace n_alunos_em_1=n_alunos_not_em_1 if n_alunos_diu_em_1==.

*variavel n�mero de alunos no 2� ano em
*77
gen n_alunos_em_2=n_alunos_diu_em_2+n_alunos_not_em_2
replace n_alunos_em_2=n_alunos_diu_em_2 if n_alunos_not_em_2==.
replace n_alunos_em_2=n_alunos_not_em_2 if n_alunos_diu_em_2==.

*variavel n�mero de alunos no 3� ano em
*78
gen n_alunos_em_3=n_alunos_diu_em_3+n_alunos_not_em_3
replace n_alunos_em_3=n_alunos_diu_em_3 if n_alunos_not_em_3==.
replace n_alunos_em_3=n_alunos_not_em_3 if n_alunos_diu_em_3==.

*gerar vari�vel que soma n�mero de mulheres nos dois turnos (para compatibilizar com Censo 2013)
*79
gen n_mulheres_em_1=n_mulheres_diu_em_1+n_mulheres_not_em_1
replace n_mulheres_em_1=n_mulheres_diu_em_1 if n_mulheres_not_em_1==.
replace n_mulheres_em_1=n_mulheres_not_em_1 if n_mulheres_diu_em_1==.

*80
gen n_mulheres_em_2=n_mulheres_diu_em_2+n_mulheres_not_em_2
replace n_mulheres_em_2=n_mulheres_diu_em_2 if n_mulheres_not_em_2==.
replace n_mulheres_em_2=n_mulheres_not_em_2 if n_mulheres_diu_em_2==.

*81
gen n_mulheres_em_3=n_mulheres_diu_em_3+n_mulheres_not_em_3
replace n_mulheres_em_3=n_mulheres_diu_em_3 if n_mulheres_not_em_3==.
replace n_mulheres_em_3=n_mulheres_not_em_3 if n_mulheres_diu_em_3==.


*variavel prop. de mulheres no em dois turnos
*82
gen p_mulheres_em_1=n_mulheres_em_1/n_alunos_em_1
*83
gen p_mulheres_em_2=n_mulheres_em_2/n_alunos_em_2
*84
gen p_mulheres_em_3=n_mulheres_em_3/n_alunos_em_3

*variavel propor��o de mulheres no diurno
*85
gen p_mulheres_diu_em_1=n_mulheres_diu_em_1/n_alunos_diu_em_1
*86
gen p_mulheres_diu_em_2=n_mulheres_diu_em_2/n_alunos_diu_em_2
*87
gen p_mulheres_diu_em_3=n_mulheres_diu_em_3/n_alunos_diu_em_3

*variavel propor��o de brancos

*variavel propor��o de brancos em diurno
*88
gen n_brancos_diu_em_1=VEM4D31 + VEM4D91
*89
gen n_brancos_diu_em_2=VEM4D32 + VEM4D92
*90
gen n_brancos_diu_em_3=VEM4D33 + VEM4D93
*91
gen n_brancos_diu_em_4=VEM4D34 + VEM4D94
*92
gen n_brancos_diu_em_ns=VEM4D35 + VEM4D95

*variavel propor��o de brancos em diurno
*93
gen n_brancos_not_em_1=VEM4N31 + VEM4N91
*94
gen n_brancos_not_em_2=VEM4N32 + VEM4N92
*95
gen n_brancos_not_em_3=VEM4N33 + VEM4N93
*96
gen n_brancos_not_em_4=VEM4N34 + VEM4N94
*97
gen n_brancos_not_em_ns=VEM4N35 + VEM4N95

*variavel numero de brancos total
*98
gen n_brancos_em_1=n_brancos_diu_em_1+n_brancos_not_em_1
*99
gen n_brancos_em_2=n_brancos_diu_em_2+n_brancos_not_em_2
*100
gen n_brancos_em_3=n_brancos_diu_em_3+n_brancos_not_em_3

*variavel propor��o de brancos em rela��o ao total de alunos en
*101
gen p_brancos_em_1=n_brancos_em_1/n_alunos_em_1
*102
gen p_brancos_em_2=n_brancos_em_2/n_alunos_em_2
*103
gen p_brancos_em_3=n_brancos_em_3/n_alunos_em_3

destring codigo_municipio, replace
compress

save "D:\bases_dta\censo_escolar\2005\censo_escolar2005.dta", replace

