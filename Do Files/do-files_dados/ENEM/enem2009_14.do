/*************************Enem 2009********************************/
/*objetivo final é replicar os resultados obtidos anteriormente. Logo, vamos
traduzir a base original do enem para uma base somente com as variáveis usadas
no trabalho anteior*/

/*objetivo do do-file: 
gerar dummies adequadas e renomear,
keep as variáveis que foram usadas nas estimacoes anteriores, 
dropar as não usadas
collpase em escola

*/
clear all
set more off
/*set trace on*/
# delimit ;
infix 

double NU_INSCRICAO 1-12
NU_ANO 13-16
ST_CONCLUSAO 180-180
IN_TP_ENSINO 181-181
double PK_COD_ENTIDADE 191-198
double COD_MUNICIPIO_ESC 199-205
str UF_ESC 356-357
NU_NT_CN 524-532
NU_NT_CH 533-541
NU_NT_LC 542-550
NU_NT_MT 551-559
NU_NOTA_REDACAO 974-982
/*
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
*/
using "\\tsclient\E\\\ENEM\microdados_enem2009\Microdados ENEM 2009\Dados Enem 2009\DADOS_ENEM_2009.txt";
save "\\tsclient\E\\\bases_dta\enem\enem2009_dados_14.dta", replace; 

# delimit cr

clear all

# delimit ;
infix 

double NU_INSCRICAO 1-12
str Q15	28-28
str Q16 29-29
str Q17 30-30
str Q18 31-31
str Q21 34-34
str Q26 39-39
str Q33 46-46
str Q42 55-55
str Q53 66-66
str Q54 67-67
str Q97 110-110
str Q98 111-111
str Q100 113-113
str Q102 115-115
str Q105 118-118
str Q109 122-122
str Q147 160-160
str Q222 235-235
/*


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
str Q58 71
str Q59 72
str Q60 73
str Q61 74
str Q62 75
str Q63 76
str Q64 77
str Q65 78
str Q66 79
str Q67 80
str Q68 81
str Q69 82
str Q70 83
str Q71 84
str Q72 85
str Q73 86
str Q74 87
str Q75 88
str Q76 89
str Q77 90
str Q78 91
str Q79 92
str Q80 93
str Q81 94
str Q82 95
str Q83 96
str Q84 97
str Q85 98
str Q86 99
str Q87 100
str Q88 101
str Q89 102
str Q90 103
str Q91 104
str Q92 105
str Q93 106
str Q94 107
str Q95 108
str Q96 109
str Q97 110
str Q98 111
str Q99 112
str Q100 113
str Q101 114
str Q102 115
str Q103 116
str Q104 117
str Q105 118
str Q106 119
str Q107 120
str Q108 121
str Q109 122
str Q110 123
str Q111 124
str Q112 125
str Q113 126
str Q114 127
str Q115 128
str Q116 129
str Q117 130
str Q118 131
str Q119 132
str Q120 133
str Q121 134
str Q122 135
str Q123 136
str Q124 137
str Q125 138
str Q126 139
str Q127 140
str Q128 141
str Q129 142
str Q130 143
str Q131 144
str Q132 145
str Q133 146
str Q134 147
str Q135 148
str Q136 149
str Q137 150
str Q138 151
str Q139 152
str Q140 153
str Q141 154
str Q142 155
str Q143 156
str Q144 157
str Q145 158
str Q146 159
str Q147 160
str Q148 161
str Q149 162
str Q150 163
str Q151 164
str Q152 165
str Q153 166
str Q154 167
str Q155 168
str Q156 169
str Q157 170
str Q158 171
str Q159 172
str Q160 173
str Q161 174
str Q162 175
str Q163 176
str Q164 177
str Q165 178
str Q166 179
str Q167 180
str Q168 181
str Q169 182
str Q170 183
str Q171 184
str Q172 185
str Q173 186
str Q174 187
str Q175 188
str Q176 189
str Q177 190
str Q178 191
str Q179 192
str Q180 193
str Q181 194
str Q182 195
str Q183 196
str Q184 197
str Q185 198
str Q186 199
str Q187 200
str Q188 201
str Q189 202
str Q190 203
str Q191 204
str Q192 205
str Q193 206
str Q194 207
str Q195 208
str Q196 209
str Q197 210
str Q198 211
str Q199 212
str Q200 213
str Q201 214
str Q202 215
str Q203 216
str Q204 217
str Q205 218
str Q206 219
str Q207 220
str Q208 221
str Q209 222
str Q210 223
str Q211 224
str Q212 225
str Q213 226
str Q214 227
str Q215 228
str Q216 229
str Q217 230
str Q218 231
str Q219 232
str Q220 233
str Q221 234
str Q222 235
str Q223 236
str Q224 237
str Q225 238
str Q226 239
str Q227 240
str Q228 241
str Q229 242
str Q230 243
str Q231 244
str Q232 245
str Q233 246
str Q234 247
str Q235 248
str Q236 249
str Q237 250
str Q238 251
str Q239 252
str Q240 253
str Q241 254
str Q242 255
str Q243 256
str Q244 257
str Q245 258
str Q246 259
str Q247 260
str Q248 261
str Q249 262
str Q250 263
str Q251 264
str Q252 265
str Q253 266
str Q254 267
str Q255 268
str Q256 269
str Q257 270
str Q258 271


*/

using "\\tsclient\E\\\ENEM\microdados_enem2009\Microdados ENEM 2009\Dados Enem 2009\QUESTIONARIO_SOCIO_ECONOMICO_ENEM_2009.txt";
save "\\tsclient\E\\\bases_dta\enem\enem2009_quest_14.dta", replace; 
# delimit cr



**************PRECISA MERGEAR COM enem2009_dados.dta
merge 1:1 NU_INSCRICAO using "\\tsclient\E\\\bases_dta\enem\enem2009_dados_14.dta"

*variavel numero de inscricoes
*1
rename NU_INSCRICAO n_inscricoes_enem

*variavel de ano de enem
*2
rename NU_ANO ano_enem
label variable ano_enem "Ano da prova do ENEM (ENEM)"


*variavel que indica se inscrito concluiu no mesmo ano que enem
*3
gen concluir_em_ano_enem = .
replace concluir_em_ano_enem = 1 if ST_CONCLUSAO == 2
replace concluir_em_ano_enem = 0 if ST_CONCLUSAO == 1 | ST_CONCLUSAO == 3 | ST_CONCLUSAO == 4
label variable concluir_em_ano_enem "Conclui EM no ano do ENEM (ST_CONCLUSAO == 2) (ENEM)"

*manter somente alunos do terceiro ano
keep if concluir_em_ano_enem == 1

*variavel que indica qual tipo de instituicao onde o estudante concluiu ou concluira o ensino medio
*4
gen insc_regular_enem = .
replace insc_regular_enem = 1 if IN_TP_ENSINO==1
replace insc_regular_enem = 0 if IN_TP_ENSINO == 2 | IN_TP_ENSINO == 3 |  IN_TP_ENSINO == 4

label variable insc_regular_enem "Tipo de instituição onde o estudante concluiu ou concluirá o ensino médio (IN_TP_ENSINO == 1 (Ensino Regular)) (ENEM)"

/*variavel que indica tipo de instituicao onde o estudante concluiu ou 
concluira o ensino medio 
1 para ensino professionalizante*/
*5
gen  insc_prof_enem = . 
replace insc_prof_enem = 1 if IN_TP_ENSINO==3
replace insc_prof_enem = 0 if IN_TP_ENSINO == 1 | IN_TP_ENSINO == 2 |  IN_TP_ENSINO == 4
label variable insc_prof_enem "Tipo de instituição onde o estudante concluiu ou concluirá o ensino médio (IN_TP_ENSINO == 3 (Ensino Profissionalizante)) (ENEM)"


*variavel de codigo de escola
*6
rename PK_COD_ENTIDADE codigo_escola
label variable codigo_escola "Código da Escola: Número geradocomo identificação da escola (ENEM)"

*variavel codigo  do municipio
*7
rename COD_MUNICIPIO_ESC codigo_municipio

*variavel de estado/uf da escola
*8
rename UF_ESC sigla

/*

*variavel que indica se inscrito estava presente na prova do enem
*9
gen presentes_enem = .
replace presentes_enem = 1 if IN_PRESENCA == 1 
replace presentes_enem = 0 if IN_PRESENCA == 0 

label variable presentes_enem "Presente nas duas provas do enem (IN_PRESENCA=1 e IN_SITUACAO=P ou B ou N) (ENEM)"

*variavel que indica se inscrito estava presente 
*nas duas provas (obj e redacao)
*10
gen presentes_enem_obj_red = .
replace presentes_enem_obj_red = 1 if IN_PRESENCA == 1 & (IN_STATUS_REDACAO == "P"  	///
	| IN_STATUS_REDACAO == "B"  | IN_STATUS_REDACAO == "N")
replace presentes_enem_obj_red = 0 if IN_PRESENCA == 0 | IN_STATUS_REDACAO ==  "F"
label variable presentes_enem_obj_red "Presente nas duas provas do enem"

*/

*variavel de notas objetivas
*11
rename NU_NT_CN enem_nota_ciencias
label variable enem_nota_ciencias "Nota da prova de Ciências da Natureza"
*12
rename NU_NT_CH enem_nota_humanas
label variable enem_nota_humanas "Nota da prova de Ciências da Humanas"
*13
rename NU_NT_LC enem_nota_linguagens 
label variable enem_nota_linguagens "Nota da prova de Ciências da Linguagens e Códigos"
*14
rename NU_NT_MT enem_nota_matematica  
label variable  enem_nota_matematica "Nota da prova de Ciências da Matemática"




*variavel de nota de redacao
*15
rename NU_NOTA_REDACAO enem_nota_redacao
label variable enem_nota_redacao "Nota da Prova de Redação (ENEM)"



*variavel que indica se inscrito mora com mais de 6 pessoas ou não
*16
gen e_mora_mais_de_6_pessoas =.
/*
replace e_mora_mais_de_6_pessoas = 1 if Q15 == "E"
replace e_mora_mais_de_6_pessoas = 0 if Q15 != "E" & Q15!="." & Q15 !=""
*/
replace e_mora_mais_de_6_pessoas=1 if Q15=="E"
replace e_mora_mais_de_6_pessoas=0 if Q15=="A" | Q15=="B" | Q15=="C" |Q15=="D" | Q15=="F"

label variable e_mora_mais_de_6_pessoas "Mora com mais de 6 pessoas (Q15==E)(ENEM)"

*variavel que indica se inscrito tem filhos
*17
gen e_tem_filho = .
replace e_tem_filho = 1 if Q16 == "A" | Q16 == "B" | Q16 == "C" 	///
	| Q16 == "D"
replace e_tem_filho = 0 if Q16 == "E"
label variable e_tem_filho "Tem filhos (Q16!=E)(ENEM)"

*variavel que indica se pai tem educacao superior
*18
gen e_escol_sup_pai=.
replace e_escol_sup_pai = 1 if Q17 == "G" | Q17 == "H" 
replace e_escol_sup_pai = 0 if Q17 == "A" | Q17 == "B" | Q17 == "C" 	///
	| Q17 == "D" | Q17 == "E" | Q17 == "F"
label  variable e_escol_sup_pai "Até quando pai estudou (Q17 =  F G H) (ENEM)"

*variavel que indica se mae tem educacao superior
*19
gen e_escol_sup_mae=.
replace e_escol_sup_mae = 1 if Q18 == "G" | Q18 == "H" 
replace e_escol_sup_mae=0 if Q18 == "A" | Q18 == "B" | Q18 == "C" 		///
	| Q18 == "D" | Q18=="E" | Q18=="F"
label variable e_escol_sup_mae "Até quando mãe estudou (Q17 ==  F G H) (ENEM)"

*variavel que indica se familia tem renda com mais de 5 salarios minimos
*20
gen e_renda_familia_5_salarios = . 
replace e_renda_familia_5_salarios = 1 if Q21 == "D" | Q21 == "E" | 	///
	Q21 == "F" | Q21 =="G"  
replace e_renda_familia_5_salarios = 0 if Q21 == "A" | Q21 == "B" | 	///
	Q21 == "C" | Q21 == "H"
label variable e_renda_familia_5_salarios "Renda familiar é maior que 5 salários mínimos (Q21== D E F G) (ENEM)"

*variavel que indica se inscrito tem automovel
*21
gen e_automovel = .
replace e_automovel=1 if Q26 == "A" | Q26 == "B" | Q26 == "C"
replace e_automovel=0 if Q26 == "D"
label variable e_automovel "Tem automóvel(Q26!=D) (ENEM)"


*variavel que indica se inscrito tem casa propria
*22
gen e_casa_propria = .
replace e_casa_propria = 1 if Q33 == "A"
replace e_casa_propria = 0 if Q33 == "B"
label variable e_casa_propria "Tem casa própria (Q33 == A) (ENEM)"

*variavel que indica se inscrito já trabalhou ou já procurou trabalho
*23
gen e_trabalhou_ou_procurou=.
replace e_trabalhou_ou_procurou = 1 if Q42 == "A" | Q42 == "B" | Q42 == "C"		/// 
	| Q42 == "D" | Q42 == "F"
replace e_trabalhou_ou_procurou = 0 if Q42 == "E" 
label variable e_trabalhou_ou_procurou "Trabalha,já trabalhou ou procurou, ganhando algum salário ou rendimento (Q42 != E) (ENEM)"

*variavel que indica se inscrito cre que conhecimento foi bem desenvolvido com aulas praticas etc
*24
gen e_conhecimento_lab = .
replace e_conhecimento_lab = 1 if Q53 == "A"
replace e_conhecimento_lab = 0 if Q53 == "B"
label variable  e_conhecimento_lab "Os conhecimentos no ensino médio foram bem desenvolvidos, com aulas práticas, laboratórios, etc (Q53 == A)(ENEM)"

*variavel que indica se inscrito  cre que conhecimento do ensino medio proporcionaram cultura e conhecimento
*25
gen e_cultura_conhec = . 
replace e_cultura_conhec = 1 if Q54 == "A"
replace e_cultura_conhec = 0 if Q54 == "B"

label variable e_cultura_conhec "Os conhecimentos no ensino médio proporcionaram cultura e conhecimento (Q54 == A)(ENEM)"

*variavel que indica se inscrito cre que professores tem conhecimento ou não
*26
gen e_profs_conhec_reg = .
replace e_profs_conhec_reg = 1 if Q97 == "B" | Q97 == "C"
replace e_profs_conhec_reg = 0 if Q97 == "A"
label  variable e_profs_conhec_reg "Avaliação da escola que fez o ensino médio quanto o conhecimento que os(as) professores(as) têm das matérias e a maneira de transmiti-lo (Q97 == B C(regular a bom e Bom a excelente)) (ENEM)"

*variavel que indica se inscrito cre se professores eram dedicados
*27
gen e_profs_dedic_reg = .
replace e_profs_dedic_reg = 1 if Q98 == "B" | Q98 == "C"
replace e_profs_dedic_reg = 0 if Q98 == "A"
label variable e_profs_dedic_reg "Avaliação da escola que fez o ensino médio quanto a dedicação dos(as) professores(as) para preparar aulas e atender aos alunos (Q98 == B C(regular a bom e Bom a excelente)) (ENEM)" 

*variavel que indica se escola do inscrito tinha biblioteca boa ou regular
*28
gen e_biblioteca_reg =.
replace e_biblioteca_reg = 1 if Q100 == "B" | Q100 == "C"
replace e_biblioteca_reg = 0 if Q100 == "A"
label variable e_biblioteca_reg "Avaliação da escola que fez o ensino médio quanto a biblioteca (Q100 == B C(regular a bom e Bom a excelente)) (ENEM)"

*variavel que indica se escola do inscrito tinha laboratorio boa ou regular
*29
gen e_lab_reg = .
replace e_lab_reg = 1 if Q102 == "B" | Q102 == "C"
replace e_lab_reg = 0 if Q102 == "A"
label variable e_lab_reg "Avaliação da escola que fez o ensino médio quanto as condições dos laboratórios (Q102 == B C(regular a bom e Bom a excelente)) (ENEM)"

*variavel que indica se inscrito avalia o interesse dos alunos da escola como bom ou regular
*30
gen  e_interesse_alunos_reg = .
replace e_interesse_alunos_reg = 1 if Q105 == "B" | Q105 == "C"
replace e_interesse_alunos_reg = 0 if Q105 == "A"
label variable e_interesse_alunos_reg "Avaliação da escola que fez o ensino médio quanto o interesse dos(as) alunos(as) (Q105 == B C(regular a bom e Bom a excelente)) (ENEM)"


*variavel que indica se inscrito avalia a direcao da escola era bom ou reuglar
*31
gen  e_direcao_reg = .
replace e_direcao_reg = 1 if Q109 == "B" | Q109 == "C"
replace e_direcao_reg = 0 if Q109 == "A"
label variable e_direcao_reg "Avaliação da escola que fez o ensino médio quanto a direção dela (Q109 == B C(regular a bom e Bom a excelente)) (ENEM)"


*variavel que indica se inscrito avalia formacao que obteve no ensino medio é maior ou igual 7
*32
gen  e_nota_em_7 = .
replace e_nota_em_7 = 1 if Q147 == "H" | Q147 == "I" | Q147 == "J"		///
	|  Q147 == "K"
replace e_nota_em_7 = 0 if Q147 == "A" | Q147 == "B" | Q147 == "C" 		///
	| Q147=="D" | Q147=="E" | Q147 == "F" | Q147 == "G"
label variable e_nota_em_7 "Nota para a formação que obteve no ensino médio (Q147 == H I J K) (ENEM)"

*variavel que indica se inscrito cre que a escola o ajudou a tomar decisão sobre profissão
*33
gen  e_ajuda_esc_profissao_muito = .
replace e_ajuda_esc_profissao_muito = 1 if Q222 == "A" 
replace e_ajuda_esc_profissao_muito = 0 if Q222 == "C" | Q222 == "B"  
label variable e_ajuda_esc_profissao_muito "A escola ajudou a tomar minha decisão sobre minha profissão (Q222 == A) (ENEM)"


/*A próxima etapa é manter só as variáveis desejáveis*/
 
#d;
/*

keep 
ano_enem 
concluir_em_ano_enem 
enem_nota_redacao 
e_mora_mais_de_6_pessoas 
e_tem_filho 
e_escol_sup_pai 
e_escol_sup_mae 
e_renda_familia_5_salarios 
e_automovel 
e_casa_propria 
e_trabalhou_ou_procurou 
e_conhecimento_lab 
e_cultura_conhec 
e_profs_conhec_reg 
e_profs_dedic_reg 
e_biblioteca_reg 
e_lab_reg 
e_interesse_alunos_reg 
e_direcao_reg 
e_nota_em_7 
e_ajuda_esc_profissao_muito 
codigo_escola 
insc_regular_enem 
presentes_enem 
insc_prof_enem 
enem_nota_matematica 
enem_nota_linguagens 
enem_nota_humanas 
enem_nota_ciencias
codigo_municipio
sigla
n_inscricoes_enem
;
drop if codigo_escola ==.;

*/
/*Agora, agregar por escola*/

collapse 
/*(mean) sigla*/
(sum) concluir_em_ano_enem
(sum) insc_regular_enem 
(sum) insc_prof_enem
(mean) ano_enem 
(count) n_inscricoes_enem
(mean) codigo_municipio
 
 
/*(sum) presentes_enem */
(mean) enem_nota_matematica 
(mean) enem_nota_linguagens 
(mean) enem_nota_humanas 
(mean) enem_nota_ciencias
(mean) enem_nota_redacao 
(mean) e_mora_mais_de_6_pessoas  
(mean) e_tem_filho 
(mean) e_escol_sup_pai 
(mean) e_escol_sup_mae 
(mean) e_renda_familia_5_salarios 
(mean) e_automovel 
(mean) e_casa_propria 
(mean) e_trabalhou_ou_procurou 
(mean) e_conhecimento_lab 
(mean) e_cultura_conhec 
(mean) e_profs_conhec_reg 
(mean) e_profs_dedic_reg 
(mean) e_biblioteca_reg 
(mean) e_lab_reg 
(mean) e_interesse_alunos_reg  
(mean) e_direcao_reg 
(mean) e_nota_em_7 
(mean) e_ajuda_esc_profissao_muito, 
by (codigo_escola);



save "\\tsclient\E\\\bases_dta\enem\enem2009_14.dta", replace;

#d cr;
