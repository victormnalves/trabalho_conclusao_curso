/*************************Enem 2007********************************/

/*objetivo final é replicar os resultados obtidos anteriormente. Logo, 
vamos traduzir a base original do enem para uma base somente com as 
variáveis usadas no trabalho anteior*/


/*
objetivo do do-file: 
a partir da base de dados em dta de 2007
renomear variavies
criar dummies
dropar variaveis nao usadas
agregar por escola


*/
clear all
set more off


# delimit ;
infix 


/*
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
str VT_GABARITO_PROVA 829-928*/

double MASC_INSCRITO 1-8
NU_ANO 9-16
IN_CONCLUIU 205-205
IN_SUPLETIVO 206-213
double PK_COD_ENTIDADE 214-221
double COD_MUNICIPIO_ESC 222-229
str UF_ESC 380-381
IN_PRESENCA 399-406
NU_NOTA_OBJETIVA 447-454
str IN_SITUACAO 455
NU_NOTA_GLOBAL_REDACAO 496-503
str Q15	519-519
str Q16 520-520
str Q17 521-521
str Q18 522-522
str Q23 527-527
str Q28 532-532
str Q35 539-539
str Q42 546-546
str Q54 558-558
str Q55 559-559
str Q90 594-594
str Q91 595-595
str Q93 597-597
str Q95 599-599
str Q98 602-602
str Q102 606-606
str Q136 640-640
str Q196 700-700

using "\\tsclient\E\\ENEM\microdados_enem2007_DVD\DADOS\DADOS_ENEM_2007.TXT";

# delimit cr



set more off
set trace on
*variavel para o numero de inscritos por escola quando for fazer o merge
*1
rename MASC_INSCRITO n_inscricoes_enem


*variavel ano do enem
*2
rename NU_ANO ano_enem
label variable ano_enem "Ano da prova do ENEM (ENEM)"


*variavel que indica se ano de conclusao igual ano do enem
*3
gen concluir_em_ano_enem = .
replace concluir_em_ano_enem=1 if IN_CONCLUIU==1
replace concluir_em_ano_enem=0 if IN_CONCLUIU==0 | IN_CONCLUIU==2
label variable concluir_em_ano_enem "Conclui EM no ano do ENEM (IN_CONCLUIU=1) (ENEM)"

*manter somente alunos do 3º ano

keep if concluir_em_ano_enem==1

*variavel  que indica se instituicao onde estudante conclui EM era regular ou
*supletivo
*4
gen  insc_regular_enem = . 
replace insc_regular_enem = 1 if IN_SUPLETIVO == 1
replace insc_regular_enem = 0 if IN_SUPLETIVO == 2

*variavel codigo da escola
*5
rename PK_COD_ENTIDADE codigo_escola
label variable codigo_escola "Código da Escola: Número gerado como identificação da escola (ENEM)"

*variavel codigo do municipio da escola
*6
rename COD_MUNICIPIO_ESC codigo_municipio

*variavel estado/uf da escola
*7
rename UF_ESC sigla

*variavel que indica se inscrito estava presente na prova objetiva
*8
gen  presentes_enem = .
replace presentes_enem = 1 if IN_PRESENCA == 1 
replace presentes_enem = 0 if IN_PRESENCA == 0
label variable presentes_enem "Presente na prova objetiva (ENEM)"

*variavel que indica se inscrito estava presente nas duas provas (obj e redacao)
*9
gen presentes_enem_obj_red = .
replace presentes_enem_obj_red = 1 if IN_PRESENCA == 1 & (IN_SITUACAO == "P"  	///
	| IN_SITUACAO == "B"  | IN_SITUACAO == "N")
replace presentes_enem_obj_red = 0 if IN_PRESENCA == 0 | IN_SITUACAO ==  "F"
label variable presentes_enem_obj_red "Presente nas duas provas do enem"

*variavel de nota do enem
*10
rename NU_NOTA_OBJETIVA enem_nota_objetiva
label variable enem_nota_objetiva "Nota da Prova Objetiva (ENEM)"

*11
rename NU_NOTA_GLOBAL_REDACAO enem_nota_redacao
label variable enem_nota_redacao "Nota da Prova de Redação (ENEM)"

*variavel que indica se inscrito mora com mais de seis pessoas
*12
gen e_mora_mais_de_6_pessoas = .
replace e_mora_mais_de_6_pessoas = 1 if Q15 == "F"
replace e_mora_mais_de_6_pessoas=0 if Q15=="A" | Q15=="B" | Q15=="C" 	///
	|Q15=="D" | Q15=="E" | Q15=="G"
label variable e_mora_mais_de_6_pessoas "Mora com mais de 6 pessoas (Q15==F)(ENEM)"

*variavel que indica se inscrito tem filho
*13
gen e_tem_filho =.
replace e_tem_filho = 1 if Q16 == "A" | Q16 == "B" | Q16 == "C" 		///
	| Q16 == "D"
replace e_tem_filho = 0 if Q16 == "E"
label variable e_tem_filho "Tem filhos (Q16==E)(ENEM)"

*variavel que indica se pai do inscrito tem ensino superior
*14
gen e_escol_sup_pai = .
replace e_escol_sup_pai = 1 if Q17 == "G" | Q17 == "H"
replace e_escol_sup_pai = 0 if Q17 == "A" | Q17 == "B" | Q17 == "D"		///
	| Q17 == "E" | Q17 == "F" 
label  variable e_escol_sup_pai "Até quando pai estudou (Q17 =  F G H) (ENEM)"

*variavel que indica se mae do inscrito tem ensino superior
*15
gen e_escol_sup_mae = .
replace e_escol_sup_mae = 1 if Q18 == "G" | Q18 == "H"
replace e_escol_sup_mae = 0 if Q18 == "A" | Q18 == "B" | Q18 == "C" 	///
	| Q18 == "D" | Q18 == "E" | Q18 == "F"
label variable e_escol_sup_mae "Até quando mãe estudou (Q17 ==  F G H) (ENEM)"

*variavel que indica se renda da familia eh igual ou maior que cinco
*salarios minimos
*16
gen e_renda_familia_5_salarios = .
replace e_renda_familia_5_salarios = 1 if Q23 == "D" | Q23 == "E" 		///
	| Q23 == "F" | Q23 =="G"
replace e_renda_familia_5_salarios = 0 if Q23 == "A" | Q23 == "B" 		///
	| Q23 == "C" | Q23 =="H"
label variable e_renda_familia_5_salarios "Renda familiar é maior que 5 salários mínimos (Q23== D E F G) (ENEM)"

*variavel que indica se inscrito tem automovel
*17
gen e_automovel = .
replace e_automovel = 1 if Q28 == "A" | Q28 == "B" | Q28 == "C" 
replace e_automovel = 0 if Q28 == "D"
label variable e_automovel "Tem automóvel(Q28!=D) (ENEM)"

*variavel que indica se inscrito possui casa propria
*18
gen e_casa_propria = .
replace e_casa_propria = 1 if Q35 == "A"
replace e_casa_propria = 0 if Q35 == "B"
label variable e_casa_propria "Tem casa própria (Q35 == A) (ENEM)"

*variavel que indica se inscrito trabalha, ja trabalhou ou procrou emprego
*19
gen e_trabalhou_ou_procurou = .
replace e_trabalhou_ou_procurou = 1 if Q42 == "A" | Q42 == "C"
replace e_trabalhou_ou_procurou = 0 if Q42 == "B"
label variable e_trabalhou_ou_procurou "Trabalha,já trabalhou ou procurou, ganhando algum salário ou rendimento (Q42 != B) (ENEM)"

/*
variavel que indica se inscrito cre que conhecimento 
foi bem desenvolvido com aulas praticas etc
*/
*20
gen e_conhecimento_lab = .
replace e_conhecimento_lab = 1 if Q54 == "A"
replace e_conhecimento_lab = 0 if Q54 == "B"
label variable  e_conhecimento_lab "Os conhecimentos no ensino médio foram bem desenvolvidos, com aulas práticas, laboratórios, etc (Q54 == A)(ENEM)"

/*
variavel que indica se inscrito cre que conhecimento 
do ensino medio proporcionaram cultura e conhecimento
*/
*21
gen e_cultura_conhec = .
replace e_cultura_conhec = 1 if Q55 == "A"
replace e_cultura_conhec = 0 if Q55 == "B"
label variable e_cultura_conhec "Os conhecimentos no ensino médio proporcionaram cultura e conhecimento (Q55 == A)(ENEM)"

/*
variavel que indica se inscrito avalia professores como regulares, bons
ou excelentes, quanto conhecimento
*/
*22
gen e_profs_conhec_reg = .
replace e_profs_conhec_reg = 1 if Q90 == "B" | Q90 == "C"
replace e_profs_conhec_reg = 0 if Q90 == "A"
label  variable e_profs_conhec_reg "Avaliação da escola que fez o ensino médio quanto o conhecimento que os(as) professores(as) têm das matérias e a maneira de transmiti-lo (Q90 == B C(regular a bom e Bom a excelente)) (ENEM)"

/*
variavel que indica se inscrito avalia professores como regulares, bons 
ou excelentes, quanto a dedicação
*/
*23
gen e_profs_dedic_reg = .
replace e_profs_dedic_reg = 1 if Q91 == "B" | Q91 == "C"
replace e_profs_dedic_reg = 0 if Q91 == "A"
label variable e_profs_dedic_reg "Avaliação da escola que fez o ensino médio quanto a dedicação dos(as) professores(as) para preparar aulas e atender aos alunos (Q91 == B C(regular a bom e Bom a excelente)) (ENEM)" 

/*
variavel que indica se inscrito avalia biblioteca da escola como 
regular, bom ou excelente
*/
*24
gen e_biblioteca_reg = .
replace e_biblioteca_reg = 1 if Q93 == "B" | Q93 == "C"
replace e_biblioteca_reg = 0 if Q93 == "A"
label variable e_biblioteca_reg "Avaliação da escola que fez o ensino médio quanto a biblioteca (Q93 == B C(regular a bom e Bom a excelente)) (ENEM)"

/*
variavel que indica se inscrito avalia laboratorios da escola como 
regulares, bons ou excelentes
*/
*25
gen e_lab_reg = .
replace e_lab_reg = 1 if Q95 == "B" | Q95 == "C"
replace e_lab_reg = 0 if Q95 == "A"
label variable e_lab_reg "Avaliação da escola que fez o ensino médio quanto as condições dos laboratórios (Q95 == B C(regular a bom e Bom a excelente)) (ENEM)"

/*
variavel que indica se inscrito avalia interesse dos alunos da escola como 
regular, bom ou excelente
*/
*26
gen  e_interesse_alunos_reg = .
replace e_interesse_alunos_reg = 1 if Q98 == "B" | Q98 == "C"
replace e_interesse_alunos_reg = 0 if Q98 == "A"
label variable e_interesse_alunos_reg "Avaliação da escola que fez o ensino médio quanto o interesse dos(as) alunos(as) (Q98 == B C(regular a bom e Bom a excelente)) (ENEM)"

/*
variavel que indica se inscrito avalia direcao da escola como 
regular, boa ou excelente
*/
*27
gen  e_direcao_reg = .
replace e_direcao_reg = 1 if Q102 == "B" | Q102 == "C"
replace e_direcao_reg = 0 if Q102 == "A"
label variable e_direcao_reg "Avaliação da escola que fez o ensino médio quanto a direção dela (Q102 == B C(regular a bom e Bom a excelente)) (ENEM)"

/*
variavel que indica se inscrito avalia formacao que 
obteve no ensino medio maior ou igual 7
*/
*28
gen  e_nota_em_7 = .
replace e_nota_em_7 = 1 if Q136 == "H" | Q136 == "I" | Q136 == "J"		///
	|  Q136 == "K"
replace e_nota_em_7 = 0 if Q136 == "A" | Q136 == "B" | Q136 == "C"		///
	|  Q136 == "D" | Q136 == "E" | Q136 == "F" | Q136 == "G"
label variable e_nota_em_7 "Nota para a formação que obteve no ensino médio (Q136 == H I J K) (ENEM)"
/*
variavel que indica se escola ajudou muito o inscrito 
a tomar a decisao sobre profissao
*/
*29
gen  e_ajuda_esc_profissao_muito = .
replace e_ajuda_esc_profissao_muito = 1 if Q196 == "A" 
replace e_ajuda_esc_profissao_muito = 0 if Q196 == "B" | Q196 == "C"
label variable e_ajuda_esc_profissao_muito "A escola ajudou a tomar minha decisão sobre minha profissão (Q196 == A) (ENEM)"



/*------------------------------------------------------------------------*/
#d;

collapse
(count) n_inscricoes_enem
(mean) ano_enem
(sum) concluir_em_ano_enem
(sum) insc_regular_enem
(mean) codigo_municipio
/*sigla*/ 
(sum) presentes_enem
(sum) presentes_enem_obj_red
(mean) enem_nota_objetiva
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


save "\\tsclient\E\\bases_dta\enem\enem2007_14.dta", replace;

#d cr;
