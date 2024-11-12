/* ENEM 2006 - TXT PARA DTA - TODAS AS VARIÁVEIS E OBSERVAÇÕES*/

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
str COD_MUNICIPIO_INSC 45-52
str NO_MUNICIPIO_INSC 53-202
str UF_INSC 203-204
 IN_CONCLUIU 205
IN_SUPLETIVO 206-213
str PK_COD_ENTIDADE 214-221
str COD_MUNICIPIO_ESC 222-229
str NO_MUNICIPIO_ESC 230-379
str UF_ESC 380-381
str ID_DEPENDENCIA_ADM 382
str ID_LOCALIZACAO 383
str SIT_FUNC 384-398
IN_PRESENCA 399-406
VL_PERC_COMP1 407-414
VL_PERC_COMP2 415-422
VL_PERC_COMP3 423-430
VL_PERC_COMP4 431-438
VL_PERC_COMP5 439-446
NU_NOTA_OBJETIVA 447-454
str IN_SITUACAO 455
NU_NOTA_REDACAO_COMP1 456-463
NU_NOTA_REDACAO_COMP2 464-471
NU_NOTA_REDACAO_COMP3 472-479
NU_NOTA_REDACAO_COMP4 480-487
NU_NOTA_REDACAO_COMP5 488-495
NU_NOTA_GLOBAL_REDACAO 496-503
str IN_QSE 504
str Q1 505
str Q2 506
str Q3 507
str Q4 508
str Q5 509
str Q6 510
str Q7 511
str Q8 512
str Q9 513
str Q10 514
str Q11 515
str Q12 516
str Q13 517
str Q14 518
str Q15 519
str Q16 520
str Q17 521
str Q18 522
str Q19 523
str Q20 524
str Q21 525
str Q22 526
str Q23 527
str Q24 528
str Q25 529
str Q26 530
str Q27 531
str Q28 532
str Q29 533
str Q30 534
str Q31 535
str Q32 536
str Q33 537
str Q34 538
str Q35 539
str Q36 540
str Q37 541
str Q38 542
str Q39 543
str Q40 544
str Q41 545
str Q42 546
str Q43 547
str Q44 548
str Q45 549
str Q46 550
str Q47 551
str Q48 552
str Q49 553
str Q50 554
str Q51 555
str Q52 556
str Q53 557
str Q54 558
str Q55 559
str Q56 560
str Q57 561
str Q58 562
str Q59 563
str Q60 564
str Q61 565
str Q62 566
str Q63 567
str Q64 568
str Q65 569
str Q66 570
str Q67 571
str Q68 572
str Q69 573
str Q70 574
str Q71 575
str Q72 576
str Q73 577
str Q74 578
str Q75 579
str Q76 580
str Q77 581
str Q78 582
str Q79 583
str Q80 584
str Q81 585
str Q82 586
str Q83 587
str Q84 588
str Q85 589
str Q86 590
str Q87 591
str Q88 592
str Q89 593
str Q90 594
str Q91 595
str Q92 596
str Q93 597
str Q94 598
str Q95 599
str Q96 600
str Q97 601
str Q98 602
str Q99 603
str Q100 604
str Q101 605
str Q102 606
str Q103 607
str Q104 608
str Q105 609
str Q106 610
str Q107 611
str Q108 612
str Q109 613
str Q110 614
str Q111 615
str Q112 616
str Q113 617
str Q114 618
str Q115 619
str Q116 620
str Q117 621
str Q118 622
str Q119 623
str Q120 624
str Q121 625
str Q122 626
str Q123 627
str Q124 628
str Q125 629
str Q126 630
str Q127 631
str Q128 632
str Q129 633
str Q130 634
str Q131 635
str Q132 636
str Q133 637
str Q134 638
str Q135 639
str Q136 640
str Q137 641
str Q138 642
str Q139 643
str Q140 644
str Q141 645
str Q142 646
str Q143 647
str Q144 648
str Q145 649
str Q146 650
str Q147 651
str Q148 652
str Q149 653
str Q150 654
str Q151 655
str Q152 656
str Q153 657
str Q154 658
str Q155 659
str Q156 660
str Q157 661
str Q158 662
str Q159 663
str Q160 664
str Q161 665
str Q162 666
str Q163 667
str Q164 668
str Q165 669
str Q166 670
str Q167 671
str Q168 672
str Q169 673
str Q170 674
str Q171 675
str Q172 676
str Q173 677
str Q174 678
str Q175 679
str Q176 680
str Q177 681
str Q178 682
str Q179 683
str Q180 684
str Q181 685
str Q182 686
str Q183 687
str Q184 688
str Q185 689
str Q186 690
str Q187 691
str Q188 692
str Q189 693
str Q190 694
str Q191 695
str Q192 696
str Q193 697
str Q194 698
str Q195 699
str Q196 700
str Q197 701
str Q198 702
str Q199 703
str Q200 704
str Q201 705
str Q202 706
str Q203 707
str Q204 708
str Q205 709
str Q206 710
str Q207 711
str Q208 712
str Q209 713
str Q210 714
str Q211 715
str Q212 716
str Q213 717
str Q214 718
str Q215 719
str Q216 720
str Q217 721
str Q218 722
str Q219 723
str Q220 724
str Q221 725
str Q222 726
str Q223 727
str VT_RESP_OBJETIVA 728-827
str TP_PROVA 828
str VT_GABARITO_PROVA 829-928


using "C:\Users\Leonardo\Dropbox\microdados\ENEM\microdados_enem2007_DVD\DADOS\DADOS_ENEM_2007\DADOS_ENEM_2007.TXT"; /*coloque entre aspas o caminho do arquivo que vai ser traduzido*/

compress; /*comprime a base de dados para economizar espaço*/
save "C:\Users\Leonardo\Dropbox\microdados\para stata\ENEM\enem2007.dta", replace; /*coloque entre aspas aonde deve ser salvo o arquivo*/

#d cr;