/* ENEM 2009 - TXT PARA DTA - TODAS AS VARIÁVEIS E OBSERVAÇÕES*/

clear
set more off 

#d;
infix
/*traducao das variáveis aqui*/
/*na pasta de cada ano deverá ter um dicioario em xlsx, se este não tiver sido fornecdo*/

str NU_INSCRICAO 1-12
NU_ANO 13-16
IDADE 17-19
str TP_SEXO 20
COD_MUNIC_INSC 21-27
str NO_MUNICIPIO_INSC 28-177
str UF_INSC 178-179
ST_CONCLUSAO 180
IN_TP_ENSINO 181
IN_CERTIFICADO 182
IN_BRAILLE 183
IN_AMPLIADA 184
IN_LEDOR 185
IN_ACESSO 186
IN_TRANSCRICAO 187
IN_OUTRO 188
IN_LIBRAS 189
IN_UNIDADE_PRISIONAL 190
PK_COD_ENTIDADE 191-198
COD_MUNICIPIO_ESC 199-205
str NO_MUNICIPIO_ESC 206-355
str UF_ESC 356-357
ID_DEPENDENCIA_ADM 358
ID_LOCALIZACAO 359
SIT_FUNC 360
COD_MUNICIPIO_PROVA 361-367
str NO_MUNICIPIO_PROVA 368-517
str UF_CIDADE_PROVA 518-519
IN_PRESENCA_CN 520
IN_PRESENCA_CH 521
IN_PRESENCA_LC 522
IN_PRESENCA_MT 523
NU_NT_CN 524-532
NU_NT_CH 533-541
NU_NT_LC 542-550
NU_NT_MT 551-559
str TX_RESPOSTAS_CN 560-604
str TX_RESPOSTAS_CH 605-649
str TX_RESPOSTAS_LC 650-694
str TX_RESPOSTAS_MT 695-739
ID_PROVA_CN 740-741
ID_PROVA_CH 742-743
ID_PROVA_LC 744-745
ID_PROVA_MT 746-747
str DS_GABARITO_CN 748-792
str DS_GABARITO_CH 793-837
str DS_GABARITO_LC 838-882
str DS_GABARITO_MT 883-927
str IN_STATUS_REDACAO 928
NU_NOTA_COMP1 929-937
NU_NOTA_COMP2 938-946
NU_NOTA_COMP3 947-955
NU_NOTA_COMP4 956-964
NU_NOTA_COMP5 965-973
NU_NOTA_REDACAO 974-982

using "C:\Users\Administrator\Dropbox\microdados\ENEM\microdados_enem2009\Microdados ENEM 2009\Dados Enem 2009\DADOS_ENEM_2009.TXT"; /*coloque entre aspas o caminho do arquivo que vai ser traduzido*/

*compress; /*comprime a base de dados para economizar espaço*/
save "C:\Users\Administrator\Dropbox\microdados\para stata\ENEM\enem2009.dta", replace; /*coloque entre aspas aonde deve ser salvo o arquivo*/

#d cr;