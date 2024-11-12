/* ENEM 2010 QUESTIONARIO- TXT PARA DTA - TODAS AS VARIÁVEIS E OBSERVAÇÕES*/

clear
set more off 

#d;
infix
/*traducao das variáveis aqui*/
/*na pasta de cada ano deverá ter um dicioario em xlsx, se este não tiver sido fornecdo*/
str NU_INSCRICAO 1-12
IN_QSE 13
str Q01 14
str Q02 15
str Q03 16
str Q04 17
str Q05 18
str Q06 19
str Q07 20
str Q08 21
str Q09 22
str Q10 23
str Q11 24
str Q12 25
str Q13 26
str Q14 27
str Q15 28
str Q16 29
str Q17 30
str Q18 31
str Q19 32
str Q20 33
str Q21 34
str Q22 35
str Q23 36
str Q24 37
str Q25 38
str Q26 39
str Q27 40
str Q28 41
str Q29 42
str Q30 43
str Q31 44
str Q32 45
str Q33 46
str Q34 47
str Q35 48
str Q36 49
str Q37 50
str Q38 51
str Q39 52
str Q40 53
str Q41 54
str Q42 55
str Q43 56
str Q44 57
str Q45 58
str Q46 59
str Q47 60
str Q48 61
str Q49 62
str Q50 63
str Q51 64
str Q52 65
str Q53 66
str Q54 67
str Q55 68
str Q56 69
str Q57 70


using "C:\Users\Administrator\Dropbox\microdados\ENEM\microdados_enem2010_2\Microdados ENEM 2010\Dados Enem 2010\QUESTIONARIO_SOCIO_ECONOMICO_ENEM_2010.TXT"; /*coloque entre aspas o caminho do arquivo que vai ser traduzido*/

compress; /*comprime a base de dados para economizar espaço*/
save "C:\Users\Administrator\Dropbox\microdados\para stata\ENEM\enem2010quest.dta", replace; /*coloque entre aspas aonde deve ser salvo o arquivo*/

#d cr;
