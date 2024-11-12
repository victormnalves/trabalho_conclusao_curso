/*************************Enem 2008********************************/

/*objetivo final é replicar os resultados obtidos anteriormente. Logo, vamos
traduzir a base original do enem para uma base somente com as variáveis usadas
no trabalho anteior*/

/*objetivo do do-file: 
gerar dummies adequadas e renomear,
keep as variáveis que foram usadas nas estimacoes anteriores, 
dropar as não usadas
collpase em escola
com base no do-file  import enem 2008.do e no enem2008_agregadoescola_replic_semconcludentes.do
*/

clear all
set more off
set trace on

# delimit ;
infix 

double NU_INSCRICAO 1-16
NU_ANO 17-24
ST_CONCLUSAO 217-224
str IN_TP_ENSINO 225-225
double PK_COD_ENTIDADE 226-234
double COD_MUNICIPIO_ESC 235-249
str UF_ESC 400-401
IN_PRESENCA 490-497
NU_NT_OBJETIVA 543-551
str IN_STATUS_REDACAO 552
NU_NT_REDACAO 598-606
str Q15	629-629
str Q16 630-630
str Q17 631-631
str Q18 632-632
str Q23 637-637
str Q28 642-642
str Q35 649-649
str Q42 656-656
str Q54 668-668
str Q55 669-669
str Q90 704-704
str Q91 705-705
str Q93 707-707
str Q95 709-709
str Q98 712-712
str Q102 716-716
str Q136 750-750
str Q196 810-810
/*str NU_INSCRICAO 1-16
NU_ANO 17-24
str DT_NASCIMENTO 25-44
str TP_SEXO 45
COD_MUNIC_INSC 46-58
str NO_MUNICIPIO_INSC 59-208
CO_UF_INSC 209-216
ST_CONCLUSAO 217-224
str IN_TP_ENSINO 225
PK_COD_ENTIDADE 226-234
COD_MUNICIPIO_ESC 235-249
str NO_MUNICIPIO_ESC 250-399
str UF_ESC 400-401
str ID_DEPENDENCIA_ADM 402
str ID_LOCALIZACAO 403
str SIT_FUNC 404-418
ID_CIDADE_PROVA 419-437
str NO_MUNICIPIO_PROVA 438-487
str UF_CIDADE_PROVA 488-489
IN_PRESENCA 490-497
NU_PERCENT_COMP1 498-506
NU_PERCENT_COMP2 507-515
NU_PERCENT_COMP3 516-524
NU_PERCENT_COMP4 525-533
NU_PERCENT_COMP5 534-542
NU_NT_OBJETIVA 543-551
str IN_STATUS_REDACAO 552
NU_NOTA_COMP1 553-561
NU_NOTA_COMP2 562-570
NU_NOTA_COMP3 571-579
NU_NOTA_COMP4 580-588
NU_NOTA_COMP5 589-597
NU_NOTA_REDACAO 598-606
IN_QSE 607-614
str Q1 615
str Q2 616
str Q3 617
str Q4 618
str Q5 619
str Q6 620
str Q7 621
str Q8 622
str Q9 623
str Q10 624
str Q11 625
str Q12 626
str Q13 627
str Q14 628
str Q15 629
str Q16 630
str Q17 631
str Q18 632
str Q19 633
str Q20 634
str Q21 635
str Q22 636
str Q23 637
str Q24 638
str Q25 639
str Q26 640
str Q27 641
str Q28 642
str Q29 643
str Q30 644
str Q31 645
str Q32 646
str Q33 647
str Q34 648
str Q35 649
str Q36 650
str Q37 651
str Q38 652
str Q39 653
str Q40 654
str Q41 655
str Q42 656
str Q43 657
str Q44 658
str Q45 659
str Q46 660
str Q47 661
str Q48 662
str Q49 663
str Q50 664
str Q51 665
str Q52 666
str Q53 667
str Q54 668
str Q55 669
str Q56 670
str Q57 671
str Q58 672
str Q59 673
str Q60 674
str Q61 675
str Q62 676
str Q63 677
str Q64 678
str Q65 679
str Q66 680
str Q67 681
str Q68 682
str Q69 683
str Q70 684
str Q71 685
str Q72 686
str Q73 687
str Q74 688
str Q75 689
str Q76 690
str Q77 691
str Q78 692
str Q79 693
str Q80 694
str Q81 695
str Q82 696
str Q83 697
str Q84 698
str Q85 699
str Q86 700
str Q87 701
str Q88 702
str Q89 703
str Q90 704
str Q91 705
str Q92 706
str Q93 707
str Q94 708
str Q95 709
str Q96 710
str Q97 711
str Q98 712
str Q99 713
str Q100 714
str Q101 715
str Q102 716
str Q103 717
str Q104 718
str Q105 719
str Q106 720
str Q107 721
str Q108 722
str Q109 723
str Q110 724
str Q111 725
str Q112 726
str Q113 727
str Q114 728
str Q115 729
str Q116 730
str Q117 731
str Q118 732
str Q119 733
str Q120 734
str Q121 735
str Q122 736
str Q123 737
str Q124 738
str Q125 739
str Q126 740
str Q127 741
str Q128 742
str Q129 743
str Q130 744
str Q131 745
str Q132 746
str Q133 747
str Q134 748
str Q135 749
str Q136 750
str Q137 751
str Q138 752
str Q139 753
str Q140 754
str Q141 755
str Q142 756
str Q143 757
str Q144 758
str Q145 759
str Q146 760
str Q147 761
str Q148 762
str Q149 763
str Q150 764
str Q151 765
str Q152 766
str Q153 767
str Q154 768
str Q155 769
str Q156 770
str Q157 771
str Q158 772
str Q159 773
str Q160 774
str Q161 775
str Q162 776
str Q163 777
str Q164 778
str Q165 779
str Q166 780
str Q167 781
str Q168 782
str Q169 783
str Q170 784
str Q171 785
str Q172 786
str Q173 787
str Q174 788
str Q175 789
str Q176 790
str Q177 791
str Q178 792
str Q179 793
str Q180 794
str Q181 795
str Q182 796
str Q183 797
str Q184 798
str Q185 799
str Q186 800
str Q187 801
str Q188 802
str Q189 803
str Q190 804
str Q191 805
str Q192 806
str Q193 807
str Q194 808
str Q195 809
str Q196 810
str Q197 811
str Q198 812
str Q199 813
str Q200 814
str Q201 815
str Q202 816
str Q203 817
str Q204 818
str Q205 819
str Q206 820
str Q207 821
str Q208 822
str Q209 823
str Q210 824
str Q211 825
str Q212 826
str Q213 827
str Q214 828
str Q215 829
str Q216 830
str Q217 831
str Q218 832
str Q219 833
str Q220 834
str Q221 835
str Q222 836
str Q223 837
str TX_RESPOSTAS 838-1037
ID_PROVA 1038-1045
str DS_TP_PROVA 1046-1095
str DS_GABARITO 1096-1195

*/
using "E:\ENEM\microdados_enem2008\MICRODADOS DO ENEM 2008\DADOS\DADOS_ENEM_2008.txt";

# delimit cr

*variavel numero de inscricao enem
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
replace concluir_em_ano_enem = 0 if ST_CONCLUSAO== 1 | ST_CONCLUSAO==3
label variable concluir_em_ano_enem "Conclui EM no ano do ENEM (ST_CONCLUSAO == 2) (ENEM)"

*manter somente alunos do terceiro ano
keep if concluir_em_ano_enem == 1

*variavel que indica qual tipo de instituicao onde o estudante concluiu ou concluira o ensino medio
*4
gen insc_regular_enem = .
replace insc_regular_enem = 1 if IN_TP_ENSINO == "1"
label variable insc_regular_enem "Tipo de instituição onde o estudante concluiu ou concluirá o ensino médio (IN_TP_ENSINO == 1 (Ensino Regular)) (ENEM)"

/*variavel que indica tipo de instituicao onde o estudante concluiu ou 
concluira o ensino medio 1 para ensino professionalizante*/
*5
gen  insc_prof_enem = . 
replace insc_prof_enem = 1 if IN_TP_ENSINO == "3"
replace insc_prof_enem = 0 if IN_TP_ENSINO == "1" | IN_TP_ENSINO == "2" | IN_TP_ENSINO == "4"
label variable insc_prof_enem "Tipo de instituição onde o estudante concluiu ou concluirá o ensino médio (IN_TP_ENSINO == 3 (Ensino Profissionalizante)) (ENEM)"


*variavel codigo de escola
*6
rename PK_COD_ENTIDADE codigo_escola
label variable codigo_escola "Código da Escola: Número geradocomo identificação da escola (ENEM)"

*variavel codigo do municipio da escola
*7
rename COD_MUNICIPIO_ESC codigo_municipio

*variavel estado/uf da escola
*8
rename UF_ESC sigla


*variavel que indica se inscrito estava presente na prova do enem
*9
gen presentes_enem = .
replace presentes_enem = 1 if IN_PRESENCA == 1 
replace presentes_enem = 0 if IN_PRESENCA == 0 
label variable presentes_enem "Presente nas duas provas do enem (IN_PRESENCA=1 e IN_SITUACAO=P) (ENEM)"

*variavel que indica se inscrito estava presente 
*nas duas provas (obj e redacao)
*10
gen presentes_enem_obj_red = .
replace presentes_enem_obj_red = 1 if IN_PRESENCA == 1 & (IN_STATUS_REDACAO == "P"  	///
	| IN_STATUS_REDACAO == "B"  | IN_STATUS_REDACAO == "N")
replace presentes_enem_obj_red = 0 if IN_PRESENCA == 0 | IN_STATUS_REDACAO ==  "F"
label variable presentes_enem_obj_red "Presente nas duas provas do enem"


*variaveis de nota
*11
rename NU_NT_OBJETIVA enem_nota_objetiva
label variable enem_nota_objetiva "Nota da Prova Objetiva (ENEM)"
*12
rename NU_NT_REDACAO enem_nota_redacao
label variable enem_nota_redacao "Nota da Prova de Redação (ENEM)"

*variavel que indica se inscrito mora com mais de 6 pessoas ou não
*13
gen e_mora_mais_de_6_pessoas = .
replace e_mora_mais_de_6_pessoas = 1 if Q15=="F"
replace e_mora_mais_de_6_pessoas = 0 if Q15!= "F" & Q15!="." & Q15 !=""
label variable e_mora_mais_de_6_pessoas "Mora com mais de 6 pessoas (Q15==F)(ENEM)"

*variavel que indica se inscrito tem filhos 
*14
gen e_tem_filho = .
replace e_tem_filho = 1 if Q16 == "A" | Q16 == "B" | Q16 == "C" | Q16 == "D"
replace e_tem_filho = 0 if Q16 == "E"
label variable e_tem_filho "Tem filhos (Q16!=E)(ENEM)"

*variavel que indica se pai tem educacao superior
*15
gen e_escol_sup_pai = . 
replace e_escol_sup_pai = 1 if Q17 == "G" | Q17 == "H" 
replace e_escol_sup_pai = 0 if Q17 == "A" | Q17 == "B" | Q17 == "C" | Q17 == "D" | Q17 == "E" | Q17 == "F"
label  variable e_escol_sup_pai "Até quando pai estudou (Q17 == G H) (ENEM)"

*variavel que indica se mae tem educacao superior
*16
gen e_escol_sup_mae = .
replace e_escol_sup_mae = 1 if Q18 == "G" | Q18 == "H" 
replace e_escol_sup_mae = 0 if Q18 == "A" | Q18 == "B" | Q18 == "C" | Q18 == "D" | Q18 == "E" | Q18 == "F"
label variable e_escol_sup_mae "Até quando mãe estudou (Q17 == G H) (ENEM)"

*variavel que indica se familia tem renda com mais de 5 salarios minimos
*17
gen e_renda_familia_5_salarios = . 
replace e_renda_familia_5_salarios = 1 if Q23 == "D" | Q23 == "E" | Q23 == "F" | Q23 == "G"  
replace e_renda_familia_5_salarios = 0 if Q23 == "A" | Q23 == "B" | Q23 == "C" | Q23 == "H"
label variable e_renda_familia_5_salarios "Renda familiar é maior que 5 salários mínimos (Q23== D E F G) (ENEM)"

*variavel que indica se inscrito tem automovel
*18
gen e_automovel = .
replace e_automovel = 1 if Q28 == "A" | Q28 == "B" | Q28 == "C"
replace e_automovel = 0 if Q28 == "D"
label variable e_automovel "Tem automóvel(Q28!=D) (ENEM)"

*variavel que indica se inscrito tem casa propria
*19
gen e_casa_propria = .
replace e_casa_propria = 1 if Q35 == "A"
replace e_casa_propria = 0 if Q35 == "B"
label variable e_casa_propria "Tem casa própria (Q35 == A) (ENEM)"

*variavel que indica se inscrito já trabalhou ou já procurou trabalho
*20
gen e_trabalhou_ou_procurou = .
replace e_trabalhou_ou_procurou = 1 if Q42 == "A" | Q42 == "C"
replace e_trabalhou_ou_procurou = 0 if Q42 == "B"
label variable e_trabalhou_ou_procurou "Trabalha,já trabalhou ou procurou, ganhando algum salário ou rendimento (Q42 != B) (ENEM)"

/*
variavel que indica se inscrito cre que conhecimento 
foi bem desenvolvido com aulas praticas etc
*/
*21

gen e_conhecimento_lab = .
replace e_conhecimento_lab = 1 if Q54 == "A"
replace e_conhecimento_lab = 0 if Q54 == "B"
label variable  e_conhecimento_lab "Os conhecimentos no ensino médio foram bem desenvolvidos, com aulas práticas, laboratórios, etc (Q54 == A)(ENEM)"

/*
variavel que indica se inscrito cre que conhecimento 
do ensino medio proporcionaram cultura e conhecimento
*/
*22
gen e_cultura_conhec = .
replace e_cultura_conhec = 1 if Q55 == "A"
replace e_cultura_conhec = 0 if Q55 == "B"
label variable e_cultura_conhec "Os conhecimentos no ensino médio proporcionaram cultura e conhecimento (Q55 == A)(ENEM)"

/*
variavel que indica se inscrito avalia professores como regulares, bons
ou excelentes, quanto conhecimento
*/
*23

gen e_profs_conhec_reg = .
replace e_profs_conhec_reg = 1 if Q90 == "B" | Q90 == "C"
replace e_profs_conhec_reg = 0 if Q90 == "A"
label  variable e_profs_conhec_reg "Avaliação da escola que fez o ensino médio quanto o conhecimento que os(as) professores(as) têm das matérias e a maneira de transmiti-lo (Q90 == B C(regular a bom e Bom a excelente)) (ENEM)"

*variavel que indica se inscrito cre se professores eram dedicados
*24
gen e_profs_dedic_reg = .
replace e_profs_dedic_reg = 1 if Q91 == "B" | Q91 == "C"
replace e_profs_dedic_reg = 0 if Q91 == "A"
label variable e_profs_dedic_reg "Avaliação da escola que fez o ensino médio quanto a dedicação dos(as) professores(as) para preparar aulas e atender aos alunos (Q91 == B C(regular a bom e Bom a excelente)) (ENEM)" 

*variavel que indica se escola do inscrito tinha biblioteca boa ou regular
*25
gen e_biblioteca_reg = .
replace e_biblioteca_reg = 1 if Q93 == "B" | Q93 == "C"
replace e_biblioteca_reg = 0 if Q93 == "A"
label variable e_biblioteca_reg "Avaliação da escola que fez o ensino médio quanto a biblioteca (Q93 == B C(regular a bom e Bom a excelente)) (ENEM)"

*variavel que indica se escola do inscrito tinha laboratorio boa ou regular
*26
gen e_lab_reg = .
replace e_lab_reg = 1 if Q95 == "B" | Q95 == "C"
replace e_lab_reg = 0 if Q95 == "A"
label variable e_lab_reg "Avaliação da escola que fez o ensino médio quanto as condições dos laboratórios (Q95 == B C(regular a bom e Bom a excelente)) (ENEM)"


*variavel que indica se inscrito avalia o interesse dos alunos da escola como bom ou regular
*27
gen  e_interesse_alunos_reg =  . 
replace e_interesse_alunos_reg = 1 if Q98 == "B" | Q98 == "C"
replace e_interesse_alunos_reg = 0 if Q98 == "A"
label variable e_interesse_alunos_reg "Avaliação da escola que fez o ensino médio quanto o interesse dos(as) alunos(as) (Q98 == B C(regular a bom e Bom a excelente)) (ENEM)"

*variavel que indica se inscrito avalia a direcao da escola era bom ou reuglar
*28
gen  e_direcao_reg = .
replace e_direcao_reg = 1 if Q102 == "B" | Q102 == "C"
replace e_direcao_reg = 0 if Q102 == "A"
label variable e_direcao_reg "Avaliação da escola que fez o ensino médio quanto a direção dela (Q102 == B C(regular a bom e Bom a excelente)) (ENEM)"


*variavel que indica se inscrito avalia formacao que obteve no ensino medio é maior ou igual 7
*29
gen  e_nota_em_7 = .
replace e_nota_em_7 = 1 if Q136 == "H" | Q136 == "I" | Q136 == "J" | Q136 == "K"
replace e_nota_em_7 = 0 if Q136 == "A" | Q136 == "B" | Q136 == "C" | Q136 == "D" | Q136 == "E" | Q136 == "F" | Q136 == "G"
label variable e_nota_em_7 "Nota para a formação que obteve no ensino médio (Q136 == H I J K) (ENEM)"

*variavel que indica se inscrito cre que a escola o ajudou a tomar decisão sobre profissão
*30
gen e_ajuda_esc_profissao_muito = .
replace e_ajuda_esc_profissao_muito = 1 if Q196 == "A" 
replace e_ajuda_esc_profissao_muito = 0 if Q196 == "C" | Q196 == "B"
label variable e_ajuda_esc_profissao_muito "A escola ajudou a tomar minha decisão sobre minha profissão (Q196 == A) (ENEM)"

/*A próxima etapa é manter só as variáveis desejáveis*/
 
#d;
/*
keep
n_inscricoes_enem
ano_enem
concluir_em_ano_enem
insc_regular_enem
insc_prof_enem
codigo_escola
codigo_municipio
sigla
presentes_enem
presentes_enem_obj_red
enem_nota_objetiva
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
;

drop if codigo_escola ==.;
*/
collapse
(mean) codigo_municipio
/*(mean) sigla*/ 
(sum) presentes_enem
(sum) presentes_enem_obj_red

(sum) concluir_em_ano_enem
(count) n_inscricoes_enem
(sum) insc_regular_enem
(sum) insc_prof_enem
(mean) ano_enem
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




save "E:\bases_dta\enem\enem2008.dta", replace;
#d cr;
