/* ENEM 2002 - TXT PARA DTA - TODAS AS VARIÁVEIS E OBSERVAÇÕES*/

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
str DS_CIDADE 57-106
str MASC_ESC 107-114
str CODMUNIC_ESC 115-126
str UF_ESC 127-140
str SIGLA 141-142
str MUN_ESC 143-192
str DEP 193-202
str LOC 203-212
str CODFUNC 213-223
IN_PRESENCA 224-231
VL_PERC_COMP1 232-239
VL_PERC_COMP2 240-247
VL_PERC_COMP3 248-255
VL_PERC_COMP4 256-263
VL_PERC_COMP5 264-271
NU_NOTA_OBJETIVA 272-279
str IN_SITUACAO 280
NU_NOTA_REDACAO_COMP1 281-288
NU_NOTA_REDACAO_COMP2 289-296
NU_NOTA_REDACAO_COMP3 297-304
NU_NOTA_REDACAO_COMP4 305-312
NU_NOTA_REDACAO_COMP5 313-320
NU_NOTA_GLOBAL_REDACAO 321-328
str IN_QSE 329
str Q1SEXO 330
str Q2ANO_NASC 331
str Q3CONSIDERA 332
str Q4ESTADOCIVIL 333
str Q5ONDECOMO_MORA 334
str Q6_1SOZINHO 335
str Q6_2MORACOM_PAI 336
str Q6_3MORACOM_MAE 337
str Q6_4MORA_ESPOSOA 338
str Q6_5MORA_FILHOS 339
str Q6_6MORA_IRMAOS 340
str Q6_7MORA_OUTROSPARENT 341
str Q6_8MORA_AMIGOS 342
str Q7QTDADE_MORA 343
str Q8QNTS_FILHOS 344
str Q9EDUC_PAI 345
str Q10EDUC_MAE 346
str Q11AREA_PAI 347
str Q12POSIC_PAI 348
str Q13AREA_MAE 349
str Q14POSIC_MAE 350
str Q15RENDAFAMILIAR 351
str Q16_1TV 352
str Q16_2CASSETEDVD 353
str Q16_3RADIO 354
str Q16_4PC 355
str Q16_5AUTO 356
str Q16_6MAQ_LAVAR 357
str Q16_7_ASPIRADORPO 358
str Q16_8_GELADEIRA 359
str Q16_9_FREEZER 360
str Q16_10_TELEFONEFIXO 361
str Q17_1_CASAPROPRIA 362
str Q17_2_RUACALCEASFALTADA 363
str Q17_3_AGUACORRENTE 364
str Q17_4_ELETRICIDADE 365
str Q17_5_EMPREGADA 366
str Q18_MOTIVOENEM 367
str Q19_MOTIVOTRABALHO 368
str Q20_JATRABALHO 369
str Q21_JATRABALHOENSINOMEDIO 370
str Q22_HORASTRABENSINOMEDIO 371
str Q23_FINALIDADETRAB 372
str Q24_IDADECOMECOUTRAB 373
str Q25_RENDASETRABALHA 374
str Q26_TRABNOQUESEPREPAROU 375
str Q27_EMQUETRABALHA 376
str Q28_POSICTRAB 377
str Q29_TEMPOTRAB 378
str Q30_1_CONHECMEDIOTRABADEQUADO 379
str Q30_2_CONHECMEDIOTRABRELACIONADO 380
str Q30_3_CONHECMEDIOTRABDESENV 381
str Q30_4_CONHECMEDIOCULTURACONHECI 382
str Q31_TRABESTUDADOSIMULTANEAMENTE 383
str Q32 384
str Q33_1 385
str Q33_2 386
str Q33_3 387
str Q33_4 388
str Q33_5 389
str Q33_6 390
str Q33_7 391
str Q34_1 392
str Q34_2 393
str Q34_3 394
str Q34_4 395
str Q34_5 396
str Q34_6 397
str Q34_7 398
str Q35_ANOSCONCLUIRFUND 399
str Q36_TIPOESCOLAFUND 400
str Q37_ANOCONCMEDIO 401
str Q38_ANOSCONCLUIRMEDIO 402
str Q39_TURNOMEDIO 403
str Q40_TIPOMEDIO 404
str Q41_MODALIDADE 405
str Q42_1_CURSOLINGUAESTRANGFORA 406
str Q42_2_CURSOCOMPFORA 407
str Q42_3_CURSOPREPVEST 408
str Q42_4_CURSOARTESFORA 409
str Q42_5_ESPORTESFORA 410
str Q43_1_JORNAIS 411
str Q43_2_REVISTA 412
str Q43_3_REVISTAHUMORQUADRINHO 413
str Q43_4_REVISTADIVULGCIENTIFICA 414
str Q43_5_LIVROSROMANCEFICCAO 415
str Q44_1_AVALIACAOPROF 416
str Q44_2_AVALIACAOESCOLA 417
str Q44_3_AVALIACAOESCOLAEXCURSOES 418
str Q44_4_AVALIACAOESCOLABIBLIOTECA 419
str Q44_5_AVALIACAOESCOLASALA 420
str Q44_6_AVALIACAOESCOLALAB 421
str Q44_7_AVALIACAOESCOLAINFORM 422
str Q44_8_AVALESCOLALINGUAESTRANG 423
str Q44_9_AVALESCOLAINTERESSEALUNOS 424
str Q44_10_AVALESCOLATRABEMGRUPO 425
str Q44_11_AVALOESCOLAESPORTES 426
str Q44_12_AVALESCOLAATENCRESPEITO 427
str Q44_13_AVALESCOLADIRECAO 428
str Q44_14_AVALESCOLAORGANIZACAO 429
str Q44_15_AVALESCOLALOCALIZACAO 430
str Q44_16_AVALESCOLASEGURANCA 431
str Q45_1_PALESTRADEBATES 432
str Q45_2_JOGOSESPORTESCAMP 433
str Q45_3_TEATRO 434
str Q45_4_CORAL 435
str Q45_5_DANCAMUSICA 436
str Q45_6_PASSEIOS 437
str Q45_7_FEIRACIENCIASCULTURAL 438
str Q45_8_FESTASGINCANAS 439
str Q46_PREPAROPARAEMPREGO 440
str Q47_1_AMIZADE 441
str Q47_2_PROFAUTORIDADE 442
str Q47_3_PROFDISTANCIA 443
str Q47_4_PROFRESPEITO 444
str Q47_5_PROFINDIFERENCA 445
str Q47_6_PROFPREOCUPDEDIC 446
str Q47_7_PROFAUTORITARIOS 447
str Q48_1_LIBERDADEEXPRESSAO 448
str Q48_2_RESPEITOAOALUNOS 449
str Q48_3_AMIZADERESPALUNOSFUNC 450
str Q48_4_OPNIOES 451
str Q48_5_PROBLEMASATUALIDADE 452
str Q48_6_CONVIVENCIAALUNOS 453
str Q48_7_RESOLUCAODEPROBLEMASALUNOS 454
str Q48_8_RESOLDEPROBALUNOSEPROFS 455
str Q48_9_PROBPESSOAISFAMILIARES 456
str Q48_10_PROGPALESTRASDROGAS 457
str Q48_11_CONTEUDOECOTIDIANO 458
str Q48_12_CAPACIDADEESCOLAAVALIAR 459
str Q49_NOTAFORMENSOMEDIO 460
str Q50_NOTAFORMENSMEDIOBR 461
str Q51_OQUEFALTA 462
str Q52_RELIGIAO 463
str Q53_FREQIGREJA 464
str Q54_1_FAMILIAPROBSOCIAIS 465
str Q54_2_CARTOAMANTEPROBPESSOAIS 466
str Q54_3_BUZIOSPROBPESSOAIS 467
str Q54_4_IGREJAPROBPESSOAIS 468
str Q54_5_AJUDAPROFISPROBPES 469
str Q54_6_HOROSCOPOPROBPESSOAIS 470
str Q54_7_AMIGOSPROBPESSOAIS 471
str Q54_8_LIVROSREVPROBPESSOAIS 472
str Q55_TEMPOLIVREPESSOAS 473
str Q56_TEMPOLIVRE 474
str Q57_1_GREMIOESTUDANTIL 475
str Q57_2_SINDICATO 476
str Q57_3_GRUPOBAIRRO 477
str Q57_4_PARTICIPAIGREJA 478
str Q57_5_PARTICIPAPARTIDO 479
str Q57_6_PARTICIPAONG 480
str Q57_7_PARTICIPACLUBE 481
str Q58_1_INTERPOLITICA 482
str Q58_2_INTERPOLITICAOUTROSPAISES 483
str Q58_3_INTERECONOMIA 484
str Q58_4_INTERPOLITICACIDADE 485
str Q58_5_INTERESPORTES 486
str Q58_6_INTERESSEMEIOAMBIENTE 487
str Q58_7_INTERESSEQUESTOESOCIAIS 488
str Q58_8_INTERESSEARTES 489
str Q58_9_INTERESSEDROGAS 490
str Q58_10_INTERESSEIDOLO 491
str Q59_1 492
str Q59_2 493
str Q60_1 494
str Q60_2 495
str Q61_2 497
str Q62_1 498
str Q62_2 499
str Q63_1 500
str Q63_2 501
str Q64_1 502
str Q64_2 503
str Q64_3 504
str Q64_4 505
str Q64_5 506
str Q64_6 507
str Q64_7 508
str Q64_8 509
str Q64_9 510
str Q64_10 511
str Q64_11 512
str Q64_12 513
str Q64_13 514
str Q65_1 515
str Q65_2 516
str Q65_3 517
str Q66 518
str Q67 519
str Q68 520
str Q69_1 521
str Q69_2 522
str Q69_3 523
str Q69_4 524
str Q69_5 525
str Q69_6 526
str Q69_7 527
str Q69_8 528
str Q70_CONTINUOUESTUDOS 529
str Q71_1_FREQCURSOPROFISSE 530
str Q71_2_FREQCURSOPREPVEST 531
str Q71_3_FREQCURSOSUPERIOR 532
str Q71_4_FREQCURSOLINGESTRANG 533
str Q71_5_FREQCURSOINFORMATICA 534
str Q71_6_FREQOUTROCURSO 535
str Q72_1_CONCLUICURSOPROFIS 536
str Q72_2_CONCCURSOPREPNAOVEST 537
str Q72_3_CONCLUICURSOSUPERIOR 538
str Q72_4_CURSOSUPERIORNAOFORMADO 539
str Q72_5_CONCLUICURSOLINGESTRANG 540
str Q72_6_CONCLUICURSOCOMPUTACAO 541
str Q72_7_CONCLUIOUTROCURSO 542
str Q73_1_CURSOPROFESFEZFALTA 543
str Q73_2_CURSOPREPVESTFEZFALTA 544
str Q73_3_CURSOSUPERIORFEZFALTA 545
str Q73_4_CURSOLINGUAESTRANGFEZFALTA 546
str Q73_5_CURSOCOMPUTACAOFEZFALTA 547
str Q73_6_OUTROCURSOFEZFALTA 548
str VT_RESP_OBJETIVA 549-611
str TP_PROVA 612
str VT_GABARITO_PROVA 613-675
using "C:\Users\Leonardo\Dropbox\microdados\ENEM\microdados_enem2002\DADOS\DADOS_ENEM_2002\DADOS_ENEM_2002.TXT"; /*coloque entre aspas o caminho do arquivo que vai ser traduzido*/
compress; /*comprime a base de dados para economizar espaço*/
save "C:\Users\Leonardo\Dropbox\microdados\para stata\ENEM\enem2002.dta", replace; /*coloque entre aspas aonde deve ser salvo o arquivo*/

#d cr;
