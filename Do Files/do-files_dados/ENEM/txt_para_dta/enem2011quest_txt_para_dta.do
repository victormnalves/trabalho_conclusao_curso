/* ENEM 2011 QUESTIONARIO- TXT PARA DTA - TODAS AS VARIÁVEIS E OBSERVAÇÕES*/

clear
set more off 

#d;
infix
/*traducao das variáveis aqui*/
/*na pasta de cada ano deverá ter um dicioario em xlsx, se este não tiver sido fornecdo*/
str NU_INSCRICAO 1-12
IN_QSE 13
str Q1 14-15
str Q2 16
str Q3 17
str Q4 18
str Q5 19
str Q6 20
str Q7 21
str Q8 22
str Q9 23
str Q10 24
str Q11 25
str Q12 26
str Q13 27
str Q14 28
str Q15 29
str Q16 30
str Q17 31
str Q18 32
str Q19 33
str Q20 34
str Q21 35
str Q22 36
str Q23 37-38
str Q24 39
str Q25 40
str Q26 41
str Q27 42
str Q28 43
str Q29 44
str Q30 45
str Q31 46
str Q32 47
str Q33 48
str Q34 49
str Q35 50
str Q36 51
str Q37 52
str Q38 53
str Q39 54
str Q40 55
str Q41 56
str Q42 57
str Q43 58
str Q44 59
str Q45 60
str Q46 61
str Q47 62
str Q48 63
str Q49 64
str Q50 65
str Q51 66
str Q52 67
str Q53 68
str Q54 69
str Q55 70
str Q56 71
str Q57 72
str Q58 73
str Q59 74
str Q60 75
str Q61 76
str Q62 77
str Q63 78
str Q64 79
str Q65 80
str Q66 81
str Q67 82
str Q68 83
str Q69 84
str Q70 85
str Q71 86
str Q72 87
str Q73 88
str Q74 89
str Q75 90

using "C:\Users\Administrator\Dropbox\microdados\ENEM\microdados_enem2011\DADOS\QUESTIONARIO_SOCIO_ECONOMICO_ENEM_2011.TXT"; /*coloque entre aspas o caminho do arquivo que vai ser traduzido*/

compress; /*comprime a base de dados para economizar espaço*/
save "C:\Users\Administrator\Dropbox\microdados\para stata\ENEM\enem2011quest.dta", replace; /*coloque entre aspas aonde deve ser salvo o arquivo*/

#d cr;
