/* ENEM 2009 QUESTIONARIO- TXT PARA DTA - TODAS AS VARIÁVEIS E OBSERVAÇÕES*/

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


using "C:\Users\Administrator\Dropbox\microdados\ENEM\microdados_enem2009\Microdados ENEM 2009\Dados Enem 2009\QUESTIONARIO_SOCIO_ECONOMICO_ENEM_2009.TXT"; /*coloque entre aspas o caminho do arquivo que vai ser traduzido*/

*compress; /*comprime a base de dados para economizar espaço*/
save "C:\Users\Administrator\Dropbox\microdados\para stata\ENEM\enem2009quest.dta", replace; /*coloque entre aspas aonde deve ser salvo o arquivo*/

#d cr;
