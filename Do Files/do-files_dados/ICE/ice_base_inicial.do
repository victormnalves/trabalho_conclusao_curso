/*********************************   ICE   *********************************/
*baseado no excel Base de dados estudo 2016 v1.xlsx

clear all
set more off
set trace on
import excel "E:\ICE\Base de dados estudo 2016 v1.xlsx", sheet("Escolas") firstrow

rename UF uf
rename MUNICÍPIO nome_municipio
rename escola nome_escola
rename jornada ice_jornada
rename segmento ice_segmento
rename ano ano
rename CódigoINEP codigo_escola
rename rigor ice_rigor

*transformando nomes de cidades minúsculas em maiusculas (creio)(?)
replace nome_municipio="IGARASSU" if nome_municipio=="Igarassu"



*gerando dummy para escolas que participaram do programa ICE
*isto é, que estão na base
gen ice = 1

*gerando dummies de segmento
*note que no arquivo, existem algumas em que não existe informação sobre segmento
*assim, essas informações foram imputadas manualmente, com base de info do google
gen ensino_fundamental=0
replace ensino_fundamental=1 if ice_segmento=="EF FINAIS"
replace ensino_fundamental=1 if ice_segmento=="EF FINAIS + EM"
replace ensino_fundamental=1 if ice_segmento=="EFII"

/*(tirei os espaços de trás do nome das escolas)*/
replace nome_escola = "ALCINDO SOARES DO NASCIMENTO PROF" in 710
replace nome_municipio = "AMERICANA" in 710
replace ice_segmento = "EF FINAIS" in 710
replace nome_escola = "SINESIA MARTINI PROFA" in 711
replace nome_municipio = "ARARAQUARA" in 712
replace nome_escola = "NARCISO DA SILVA CESAR" in 712
replace nome_escola = "NAERSON MIRANDA PROFESSOR" in 713
replace nome_municipio = "BOFETE" in 713
replace nome_escola = "ORLANDO HORACIO VITA PROFESSOR" in 714
replace nome_municipio = "SÃO PAULO" in 714
replace nome_escola = "ALFREDO PAULINO" in 715
replace nome_municipio = "SÃO PAULO" in 715
replace nome_escola = "BRASILIO MACHADO" in 716
replace nome_municipio = "SÃO PAULO" in 716
replace ice_segmento = "EM" in 716
replace nome_escola = "LOURENCO FILHO PROFESSOR" in 717
replace nome_escola = "RAUL HUMAITA VILLA NOVA CORONEL" in 718
replace nome_escola = "MARISA DE MELLO PROFA" in 719
replace nome_escola = "IRENE RIBEIRO PROFESSORA" in 720
replace nome_escola = "ALVINO BITTENCOURT PROFESSOR" in 721
replace nome_escola = "RAUL ANTONIO FRAGOSO PROFESSOR" in 722
replace nome_escola = "MARIA ANTONIETTA DE CASTRO PROFA" in 723
replace nome_escola = "GENESIO BOAMORTE DOUTOR" in 724
replace nome_escola = "CARLOS GARCIA DOUTOR" in 725
replace nome_municipio = "SANTO ANDRÉ" in 725
replace nome_escola = "SUELY ANTUNES DE MELLO PROFESSORA" in 726
replace nome_municipio = "SÃO JOSÉ DOS CAMPOS" in 726
replace nome_escola = "WALDEMAR DE FREITAS ROSA PROFESSOR" in 727
replace nome_municipio = "SOROCABA" in 727
replace nome_escola = "NAZIRA NAGIB JORGE MURAD RODRIGUES PROFESSORA" in 728
replace nome_escola = "RUBENS OSCAR GUELLI PROFESSOR" in 729
replace nome_municipio = "SUMARÉ" in 729
replace nome_escola = "SAO JUDAS TADEU" in 616
replace nome_escola = "SHIRLEY CAMARGO VON ZUBEN" in 620
replace nome_escola = "SILVIO DE ALMEIDA" in 622
replace nome_escola = "SONIA AP MAXIMIANO BUENO" in 623
replace nome_escola = "TEOTONIO ALVES PEREIRA" in 626
replace nome_escola = "VITOR MEIRELLES" in 633
replace nome_escola = "VOLUNTARIOS DE 32" in 634
replace nome_escola = "OSWALDO ARANHA" in 596
replace nome_escola = "OSWALDO CRUZ" in 597
replace nome_escola = "OSCAR VILLARES" in 595
replace nome_escola = "OLIMPIO CATAO" in 592
replace nome_escola = "Mº GUILHERMINA L FAGUNDES" in 579
replace nome_escola = "MARIA TRUJILO TORLONI" in 571
replace nome_escola = "Mª DOLORES V MADUREIRA" in 559
replace nome_escola = "LUIZ BORTOLETTO" in 558
replace nome_escola = "LEME CARDEAL" in 553
replace nome_escola = "JUVENAL ALVIM MAJOR" in 549
replace nome_escola = "JOSE AUGUSTO RIBEIRO" in 535
replace nome_escola = "JOSE AP GUEDES DE AZEVEDO" in 534
replace nome_escola = "JORGE CORREA PROF" in 531
replace nome_escola = "JEAN PIAGET" in 523
replace nome_escola = "GABRIEL MONTEIRO DA SILVA" in 493
replace nome_escola = "ISABEL PRINCESA" in 502
replace nome_escola = "EUSTAQUIO PADRE" in 483
replace nome_escola = "CONDE DO PINHAL" in 458
replace nome_escola = "CASIMIRO DE ABREU" in 450
replace nome_escola = "BAIRRO NOVA MARILIA" in 437
replace nome_escola = "ARTHUR WEINGRILL" in 431
replace nome_escola = "ANISIO JOSE MOREIRA" in 421
replace nome_escola = "ANIGER F DE Mª MELILLO" in 420
replace nome_escola = "AMADOR BUENO DA VEIGA" in 415
replace nome_escola = "ALBERTO TORRES" in 407
replace nome_escola = "9 DE JULHO" in 401

*salvo como ice_dados1.dta
*gerando dummies de ano de entrada e participação nos anos seguitnes
*no programa ICE
destring ano, replace

gen ice_2004 = 1 if ano <= 2004
gen ice_2005 = 1 if ano <= 2005
gen ice_2006 = 1 if ano <= 2006
gen ice_2007 = 1 if ano <= 2007
gen ice_2008 = 1 if ano <= 2008
gen ice_2009 = 1 if ano <= 2009
gen ice_2010 = 1 if ano <= 2010
gen ice_2011 = 1 if ano <= 2011
gen ice_2012 = 1 if ano <= 2012
gen ice_2013 = 1 if ano <= 2013
gen ice_2014 = 1 if ano <= 2014
gen ice_2015 = 1 if ano <= 2015
* gerar dummy de integral
gen integral=1
replace integral=0 if ice_jornada=="Semi-integral"


/*
codigo_escola ==. 

escola com codigo_inep duplicado e errado 
nome_escola=="LOURENCO FILHO" & codigo_escola==35003669
--> esse é provavelmente 35003980
nome_escola=="ALEXANDRE VON HUMBOLDT" & codigo_escola==35003669 (esse é o correto)
estão sendo imputado com dados http://www.qedu.org.br (procurando com o nome da escola
e puxando o número inep)
*/
replace codigo_escola = 33176345 in 668
replace codigo_escola = 33176060 in 667
replace codigo_escola = 35495311 in 581
replace codigo_escola = 35579427 in 507
replace codigo_escola = 35565039 in 435
replace codigo_escola = 52033570 in 115
replace codigo_escola = 35003980 in 557
replace codigo_escola = 23252588 in 730
replace codigo_escola = 23252375 in 731
/*
sem missings -> escolas que estavam sem codigo_escola previamente agora estão

*/
save "E:\bases_dta\ice_dados\ice_dados3_14.dta", replace
saveold "E:\bases_dta\ice_dados\ice_dados3.dta", replace

format codigo_escola %16.0f

rename ano ano_ice
*dropando valores duplicados
drop if codigo_escola == 35003980 & nome_escola == "LOURENCO FILHO PROFESSOR"

drop if codigo_escola == 35495311 & nome_escola == "NAERSON MIRANDA PROFESSOR"

*corrigindo número inep da escola genesio boamorte

replace codigo_escola = 35034472 if nome_escola == "GENESIO BOAMORTE"

* curiosamente, com codigo_escola = 35034472 existem duas escolas
* nome_escola == "GENESIO BOAMORTE" e nome_escola == "GENESIO BOAMORTE DOUTOR"
* vamos manter nome_escola == "GENESIO BOAMORTE DOUTOR". mas note uqe 
* nome_escola == "GENESIO BOAMORTE" possui informações sobre rigor

replace ice_rigor = "Fraco" if nome_escola == "GENESIO BOAMORTE DOUTOR"
drop if codigo_escola == 35034472 & nome_escola == "GENESIO BOAMORTE"
*save "E:\bases_dta\ice_dados\ice_original_14.dta", replace

save "E:\bases_dta\ice_dados\ice_original.dta", replace
use "E:\bases_dta\ice_dados\ice_original.dta", clear
save "E:\bases_dta\ice_dados\ice_original_fluxo.dta", replace
use "E:\bases_dta\ice_dados\ice_original.dta", clear
/*
para as escolas do PE e do CE, sem ensino fundamental, atribuir à dummy 
de participação do programa  o valor zero se ano de entrada do programa for
em até dois anos abaixo do ano da dummy

ou
a dummy que indica se a escola participa do programa em um ano específico
vai assumir zero se:
o ano de entrada do programa ocorreu em até dois anos antes desse ano; e
o estado é PE ou CE; e 
se não for o ensino fundamental

estamos fazendo isso porque nas escolas do ensino médio do pernambuco e do ceara
o programa foi implementado somente no primeiro ano do ensino médio, e não no 
segundo nem no terceiro.
assim, para avaliar essas escolas, necessário dar um lag de 2 anos para o programa
*/

forvalues a=2004(1)2015{
replace ice_`a'=0 if (ano>`a'-2&ano<=`a')&(uf=="PE"|uf=="CE")&ensino_fundamental==0 
}



save "E:\bases_dta\ice_dados\ice_original_nota.dta", replace
