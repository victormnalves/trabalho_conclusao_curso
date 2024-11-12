/* ENEM 2005 - TXT PARA DTA - TODAS AS VARIÁVEIS E OBSERVAÇÕES*/

clear
set more off 

#d;
infix
/*traducao das variáveis aqui*/
/*na pasta de cada ano deverá ter um dicioario em xlsx, se este não tiver sido fornecdo*/
str MASC_INSCRITO 1-8
NU_ANO 9-16
str DT_NASCIMENTO 17-36
TP_SEXO 37-44
str CODMUNIC_INSC 45-56
str DS_CIDADE 57-96
str IN_CONCLUIU 97-104
str MASC_ESC 105-112
str CODMUNIC_ESC 113-124
str UF_ESC 125-144
str SIGLA 145-146
str MUN_ESC 147-196
str DEP 197-206
str LOC 207-216
str CODFUNC 217-227
str IN_PRESENCA 228-235
VL_PERC_COMP1 236-243
VL_PERC_COMP2 244-251
VL_PERC_COMP3 252-259
VL_PERC_COMP4 260-267
VL_PERC_COMP5 268-275
NU_NOTA_OBJETIVA 276-283
str IN_SITUACAO 284
NU_NOTA_REDACAO_COMP1 285-292
NU_NOTA_REDACAO_COMP2 293-300
NU_NOTA_REDACAO_COMP3 301-308
NU_NOTA_REDACAO_COMP4 309-316
NU_NOTA_REDACAO_COMP5 317-324
NU_NOTA_GLOBAL_REDACAO 325-332
IN_QSE 333
str q1_SEXO 334
str q2_ANO_NASC 335
str q3_CONSIDERA 336
str q4 337
str q5_ESTADOCIVIL 338
str q6_ONDECOMO_MORA 339
str q7_SOZINHO 340
str q8_MORACOM_PAI 341
str q9_MORACOM_MAE 342
str q10_MORA_ESPOSOA 343
str q11_MORA_FILHOS 344
str q12_MORA_IRMAOS 345
str q13_MORA_OUTROSPARENT 346
str q14_MORA_AMIGOS 347
str q15_QTDADE_MORA 348
str q16_QNTS_FILHOS 349
str q17_EDUC_PAI 350
str q18_EDUC_MAE 351
str q19_AREA_PAI 352
str q20_POSIC_PAI 353
str q21_AREA_MAE 354
str q22_POSIC_MAE 355
str q23_RENDAFAMILIAR 356
str q24_TV 357
str q25_CASSETEDVD 358
str q26_RADIO 359
str q27_PC 360
str q28_AUTO 361
str q29_MAQ_LAVAR 362
str q30_GELADEIRA 363
str q31_TELEFONEFIXO 364
str q32_CELULAR 365
str q33_INTERNET 366
str q34_TVASSIN 367
str q35_CASAPROPRIA 368
str q36_RUACALCEASFALTADA 369
str q37_AGUACORRENTE 370
str q38_ELETRICIDADE 371
str q39 372
str q40_MOTIVOENEM 373
str q41 374
str q42 375
str q43 376
str q44 377
str q45 378
str q46 379
str q47 380
str q48 381
str q49 382
str q50 383
str q51 384
str q52 385
str q53 386
str q54 387
str q55 388
str q56 389
str q57 390
str q58 391
str q59 392
str q60 393
str q61 394
str q62 395
str q63 396
str q64 397
str q65 398
str q66 399
str q67 400
str q68 401
str q69 402
str q70 403
str q71 404
str q72 405
str q73 406
str q74 407
str q75 408
str q76 409
str q77 410
str q78 411
str q79 412
str q80 413
str q81 414
str q82 415
str q83 416
str q84 417
str q85 418
str q86 419
str q87 420
str q88 421
str q89 422
str q90 423
str q91 424
str q92 425
str q93 426
str q94 427
str q95 428
str q96 429
str q97 430
str q98 431
str q99 432
str q100 433
str q101 434
str q102 435
str q103 436
str q104 437
str q105 438
str q106 439
str q107 440
str q108 441
str q109 442
str q110 443
str q111 444
str q112 445
str q113 446
str q114 447
str q115 448
str q116 449
str q117 450
str q118 451
str q119 452
str q120 453
str q121 454
str q122 455
str q123 456
str q124 457
str q125 458
str q126 459
str q127 460
str q128 461
str q129 462
str q130 463
str q131 464
str q132 465
str q133 466
str q134 467
str q135 468
str q136 469
str q137 470
str q138 471
str q139 472
str q140 473
str q141 474
str q142 475
str q143 476
str q144 477
str q145 478
str q146 479
str q147 480
str q148 481
str q149 482
str q150 483
str q151 484
str q152 485
str q153 486
str q154 487
str q155 488
str q156 489
str q157 490
str q158 491
str q159 492
str q160 493
str q161 494
str q162 495
str q163 496
str q164 497
str q165 498
str q166 499
str q167 500
str q168 501
str q169 502
str q170 503
str q171 504
str q172 505
str q173 506
str q174 507
str q175 508
str q176 509
str q177 510
str q178 511
str q179 512
str q180 513
str q181 514
str q182 515
str q183 516
str q184 517
str q185 518
str q186 519
str q187 520
str q188 521
str q189 522
str q190 523
str q191 524
str q192 525
str q193 526
str q194 527
str q195 528
str q196 529
str q197 530
str q198 531
str q199 532
str q200 533
str q201 534
str q202 535
str q203 536
str q204 537
str q205 538
str q206 539
str q207 540
str q208 541
str q209 542
str q210 543
str q211 544
str q212 545
str q213 546
str q214 547
str q215 548
str q216 549
str q217 550
str q218 551
str q219 552
str q220 553
str q221 554
str q222 555
str q223 556
str VT_RESP_OBJETIVA 557-619
str TP_PROVA 620
str VT_GABARITO_PROVA 621-683
**using "C:\Users\Leonardo\Dropbox\microdados\ENEM\microdados_enem2005\DADOS_ENEM_2005\DADOS_ENEM_2005.TXT";** /*coloque entre aspas o caminho do arquivo que vai ser traduzido*/
using "C:\Users\Administrator\Dropbox\microdados\ENEM\microdados_enem2005\DADOS_ENEM_2005\DADOS_ENEM_2005.TXT";
compress; /*comprime a base de dados para economizar espaço*/
*save "C:\Users\Leonardo\Dropbox\microdados\para stata\ENEM\enem2005.dta", replace; /*coloque entre aspas aonde deve ser salvo o arquivo*/
save "C:\Users\Administrator\Dropbox\microdados\para stata\ENEM\enem2005.dta",replace;
#d cr;

