/*******************************SAEB 2003**************************************/
*parece ok
clear all
set more off
set trace on
/*
Matemática
Português
Diretor
Docentes
Merge
*/


/*--------- Matemática-------------*/
*4ªsérie, 8ª série, 3º ano


*3º ano
		clear all
		* infix ok
		# delimit ;

		infix 

		double MASCARA 1-8
		ANO 17-20
		SERIE 21-22
		str DISC 23-23
		UF 73-80
		double PESO_AC 137-144
		double PROFIC 255-266
		ESTAGIO 267-274
		A111_016 395-402
		A111_021 435-442

		using "E:\SAEB Prova Brasil\microdados_saeb_2003\DADOS\ALUNOS\MATEMATICA_03ANO.txt";

		# delimit cr

		rename MASCARA mascara_saeb
		rename ANO ano_saeb
		rename SERIE serie
		*disciplina
		rename DISC disc
		rename UF codigo_uf
		*peso calibrado
		rename PESO_AC peso_m_saeb

		*casa tem computador com internet?
		gen s_comp_internet_3=.
		replace s_comp_internet=1 if A111_016==1
		replace s_comp_internet=0 if A111_016==2

		*na casa trabalha empregada doméstica?
		gen s_empregada_diarista_3=.
		replace s_empregada_diarista=1 if A111_021==1 | A111_021==2 | A111_021==3
		replace s_empregada_diarista=0 if A111_021==4
		*proficiência
		rename PROFIC profic_m_saeb_3
		*Estágios de desempenho
		rename ESTAGIO estagio_m_saeb_3
		
		*collapse
		# delimit ;
		collapse 
		(first) disc 
		(mean) ano_saeb serie peso_m_saeb profic_m_saeb_3 
		estagio_m_saeb_3 s_comp_internet s_empregada_diarista, 
		by(mascara_saeb)
		;
		# delimit cr

		save "E:\bases_dta\saeb_prova_brasil\2003\saeb2003_mat_03ANO.dta", replace

*4ª série

		clear all
		*infix e variáveis ok
		# delimit ;

		infix 

		double MASCARA 1-8
		ANO 17-20
		SERIE 21-22
		str DISC 23-23
		UF 77-84
		double PESO_AC 141-148
		double PROFIC 259-270
		ESTAGIO 271-285
		A041_017 414-421
		A041_022 454-461

		using "E:\SAEB Prova Brasil\microdados_saeb_2003\DADOS\ALUNOS\MATEMATICA_04SERIE.txt";

		# delimit cr

		rename MASCARA mascara_saeb
		rename ANO ano_saeb
		rename SERIE serie
		*disciplina
		rename DISC disc
		rename UF codigo_uf
		*peso calibrado
		rename PESO_AC peso_m_saeb

		*casa tem computador com internet?
		gen s_comp_internet_5=.
		replace s_comp_internet_5=1 if A041_017==1
		replace s_comp_internet_5=0 if A041_017==2

		*na casa trabalha empregada doméstica?
		gen s_empregada_diarista_5=.
		replace s_empregada_diarista_5=1 if A041_022==1 | A041_022==2 | A041_022==3
		replace s_empregada_diarista_5=0 if A041_022==4
		*proficiência
		rename PROFIC profic_m_saeb_5
		*Estágios de desempenho
		rename ESTAGIO estagio_m_saeb_5
		
		*collapse
		# delimit ;
		collapse 
		(first) disc 
		(mean) ano_saeb serie peso_m_saeb profic_m_saeb_5 
		estagio_m_saeb_5 s_comp_internet_5 s_empregada_diarista_5, 
		by(mascara_saeb)
		;
		# delimit cr

		save "E:\bases_dta\saeb_prova_brasil\2003\saeb2003_mat_04SERIE.dta", replace
		 
*8ª série
		clear all

		# delimit ;

		infix 

		double MASCARA 1-8
		ANO 17-20
		SERIE 21-22
		str DISC 23-23
		UF 73-80
		double PESO_AC 137-144
		double PROFIC 255-266
		ESTAGIO 267-274
		A081_016 395-402
		A081_021 435-442

		using "E:\SAEB Prova Brasil\microdados_saeb_2003\DADOS\ALUNOS\MATEMATICA_08SERIE.txt";

		# delimit cr

		rename MASCARA mascara_saeb
		rename ANO ano_saeb
		rename SERIE serie
		*disciplina
		rename DISC disc
		rename UF codigo_uf
		*peso calibrado
		rename PESO_AC peso_m_saeb

		*casa tem computador com internet?
		gen s_comp_internet_9=.
		replace s_comp_internet_9=1 if A081_016==1
		replace s_comp_internet_9=0 if A081_016==2

		*na casa trabalha empregada doméstica?
		gen s_empregada_diarista_9=.
		replace s_empregada_diarista=1 if A081_021==1 | A081_021==2 | A081_021==3
		replace s_empregada_diarista=0 if A081_021==4
		*proficiência
		rename PROFIC profic_m_saeb_9
		*Estágios de desempenho
		rename ESTAGIO estagio_m_saeb_9
		
		*collapse
		# delimit ;
		collapse 
		(first) disc 
		(mean) ano_saeb serie peso_m_saeb profic_m_saeb_9 
		estagio_m_saeb_9 s_comp_internet_9 s_empregada_diarista_9, 
		by(mascara_saeb)
		;
		# delimit cr

		save "E:\bases_dta\saeb_prova_brasil\2003\saeb2003_mat_08SERIE.dta", replace





/*--------- Português-------------*/
*4ªsérie, 8ª série, 3º ano

*infix e variáveis ok
foreach x in "03ANO" "04SERIE" "08SERIE" {
clear all

# delimit ;
infix 

double MASCARA 1-8
ANO 17-20
SERIE 21-22
str DISC 23-23
UF 73-80
double PESO_AC 137-144
double PROFIC 255-266
ESTAGIO 267-274

using "E:\SAEB Prova Brasil\microdados_saeb_2003\DADOS\ALUNOS\PORTUGUES_`x'.txt";

# delimit cr

**** Renomear e construir variáveis

rename MASCARA mascara_saeb
rename ANO ano_saeb
rename SERIE serie
rename DISC disc
rename UF codigo_uf
rename PESO_AC peso_p_saeb


if  "03ANO" == "`x'" {
		rename PROFIC profic_p_saeb_3
		rename ESTAGIO estagio_p_saeb_3

		*collapse
		# delimit ;
		collapse 
		(first) disc 
		(mean) ano_saeb serie peso_p_saeb profic_p_saeb_3 estagio_p_saeb_3, 
		by(mascara_saeb)
		;
		# delimit cr

		save "E:\bases_dta\saeb_prova_brasil\2003\saeb2003_port_`x'.dta", replace

	}
if "04SERIE" == "`x'" {
		rename PROFIC profic_p_saeb_5
		rename ESTAGIO estagio_p_saeb_5

		*collapse
		# delimit ;
		collapse 
		(first) disc 
		(mean) ano_saeb serie peso_p_saeb profic_p_saeb_5 estagio_p_saeb_5, 
		by(mascara_saeb)
		;
		# delimit cr

		save "E:\bases_dta\saeb_prova_brasil\2003\saeb2003_port_`x'.dta", replace

	}
if "08SERIE" == "`x'" {
		rename PROFIC profic_p_saeb_9
		rename ESTAGIO estagio_p_saeb_9

		*collapse
		# delimit ;
		collapse 
		(first) disc 
		(mean) ano_saeb serie peso_p_saeb profic_p_saeb_9 estagio_p_saeb_9, 
		by(mascara_saeb)
		;
		# delimit cr

		save "E:\bases_dta\saeb_prova_brasil\2003\saeb2003_port_`x'.dta", replace

}


}
/*---------Diretor-------------*/
set trace on
foreach x in "03ANO" "04SERIE" "08SERIE" {

clear

# delimit ;
infix 

double MASCARA 1-8
ANO 17-20
SERIE 21-22
double PESOEC 43-50
D023 299-306


using "E:\SAEB Prova Brasil\microdados_saeb_2003\DADOS\DIRETOR\DIRETOR_03.txt";

# delimit cr
**** Renomear e construir variáveis

rename MASCARA mascara_saeb
rename ANO ano_saeb
rename SERIE serie
rename PESOEC peso_d_saeb

* fazendo para cada ano

if  "03ANO" == "`x'" {
	keep if serie == 11
	}
if "04SERIE" == "`x'" {
	keep if serie == 4 
	}
if "08SERIE" == "`x'" {
	keep if serie == 8 
	}
* criar variáveis
* D023: método como a direção da escola foi assumida
* Você assumiu a direção desta escola por: 
	/*1 se foi asusmida por seleção*/
gen s_metodo_esc_dir_selecao=.
replace s_metodo_esc_dir_selecao=1 if D023==1
replace s_metodo_esc_dir_selecao=0 if D023>=2

	/*2 se foi assumida por eleição*/
gen s_metodo_esc_dir_eleicao=.
replace s_metodo_esc_dir_eleicao=1 if D023==2
replace s_metodo_esc_dir_eleicao=0 if D023>=3 | D023==1
	
	/*3 se foi assumida por seleção e eleição*/
gen s_metodo_esc_dir_sel_ele=.
replace s_metodo_esc_dir_sel_ele=1 if D023==3
replace s_metodo_esc_dir_sel_ele=0 if D023>=4 | D023==1 | D023==2
	
	/*4, 5, 6 se foi assumida por indicação*/
gen s_metodo_esc_dir_indic=.
replace s_metodo_esc_dir_indic=1 if D023==4 | D023==5 | D023==6
replace s_metodo_esc_dir_indic=0 if D023==1 | D023==2 | D023==3 | D023==7

*dropando a variável 
drop D023

*collapse
# delimit ;
collapse 
(mean) ano_saeb serie peso_d_saeb 
s_metodo_esc_dir_selecao-s_metodo_esc_dir_indic, 
by (mascara_saeb);
save "E:\bases_dta\saeb_prova_brasil\2003\saeb2003_dir_`x'.dta", replace;
# delimit cr

}



/*---------Docentes------------*/
set trace on
foreach x in "03ANO" "04SERIE" "08SERIE" {
clear

# delimit ;
infix 

double MASCARA 1-8
ANO 17-20
SERIE 21-22
double PESOTC 46-53
P009 190-197
P010 198-205
P011 206-213

using "E:\SAEB Prova Brasil\microdados_saeb_2003\DADOS\DOCENTES\DOCENTE_03.txt";

# delimit cr

**** Renomear e construir variáveis

rename MASCARA mascara_saeb
rename ANO ano_saeb
rename SERIE serie
rename PESOTC peso_p_saeb

* fazendo para cada ano

if "`x'" == "03ANO"{
		keep if serie == 11
		*criar variáveis

		*P009: Há quantos anos você está lecionando? 
			/*leciona há mais que 3 anos*/
		gen s_exp_prof_mais_3_3=.
		replace s_exp_prof_mais_3_3=1 if P009>=3
		replace s_exp_prof_mais_3_3=0 if P009==1 | P009==2

		*P010: Há quantos anos você trabalha nesta escola? 
			/*trabalha há mais do que 3 anos na escola*/
		gen s_exp_prof_escola_mais_3_3=.
		replace s_exp_prof_escola_mais_3_3=1 if P010>=3
		replace s_exp_prof_escola_mais_3_3=0 if P010==1 | P009==2

		*P011: Há quanto tempo você é professor desta turma?
			/*há menos de 1 ano*/
		gen s_prof_turma_desde_inicio_3=.
		replace s_prof_turma_desde_inicio_3=1 if P011==1
		replace s_prof_turma_desde_inicio_3=0 if P011>=2

		# delimit ;

		collapse 
		(mean) ano_saeb serie peso_p_saeb 
		s_exp_prof_mais_3_3-s_prof_turma_desde_inicio_3, 
		by (mascara_saeb);
		# delimit cr

save "E:\bases_dta\saeb_prova_brasil\2003\saeb2003_prof_`x'.dta", replace
	}
if "`x'" == "04SERIE"{
		keep if serie == 4 
		*criar variáveis

		*P009: Há quantos anos você está lecionando? 
			/*leciona há mais que 3 anos*/
		gen s_exp_prof_mais_3_5=.
		replace s_exp_prof_mais_3_5=1 if P009>=3
		replace s_exp_prof_mais_3_5=0 if P009==1 | P009==2

		*P010: Há quantos anos você trabalha nesta escola? 
			/*trabalha há mais do que 3 anos na escola*/
		gen s_exp_prof_escola_mais_3_5=.
		replace s_exp_prof_escola_mais_3_5=1 if P010>=3
		replace s_exp_prof_escola_mais_3_5=0 if P010==1 | P009==2

		*P011: Há quanto tempo você é professor desta turma?
			/*há menos de 1 ano*/
		gen s_prof_turma_desde_inicio_5=.
		replace s_prof_turma_desde_inicio_5=1 if P011==1
		replace s_prof_turma_desde_inicio_5=0 if P011>=2

		# delimit ;

		collapse 
		(mean) ano_saeb serie peso_p_saeb 
		s_exp_prof_mais_3_5-s_prof_turma_desde_inicio_5, 
		by (mascara_saeb);
		# delimit cr

		save "E:\bases_dta\saeb_prova_brasil\2003\saeb2003_prof_`x'.dta", replace
	}
if "`x'" == "08SERIE"{
	keep if serie == 8 
		*criar variáveis

		*P009: Há quantos anos você está lecionando? 
			/*leciona há mais que 3 anos*/
		gen s_exp_prof_mais_3_9=.
		replace s_exp_prof_mais_3_9=1 if P009>=3
		replace s_exp_prof_mais_3_9=0 if P009==1 | P009==2

		*P010: Há quantos anos você trabalha nesta escola? 
			/*trabalha há mais do que 3 anos na escola*/
		gen s_exp_prof_escola_mais_3_9=.
		replace s_exp_prof_escola_mais_3_9=1 if P010>=3
		replace s_exp_prof_escola_mais_3_9=0 if P010==1 | P009==2

		*P011: Há quanto tempo você é professor desta turma?
			/*há menos de 1 ano*/
		gen s_prof_turma_desde_inicio_9=.
		replace s_prof_turma_desde_inicio_9=1 if P011==1
		replace s_prof_turma_desde_inicio_9=0 if P011>=2

		# delimit ;

		collapse 
		(mean) ano_saeb serie peso_p_saeb 
		s_exp_prof_mais_3_9-s_prof_turma_desde_inicio_9, 
		by (mascara_saeb);
		# delimit cr

		save "E:\bases_dta\saeb_prova_brasil\2003\saeb2003_prof_`x'.dta", replace
	}

}
/*---------Merge------------*/


use "E:\bases_dta\saeb_prova_brasil\2003\saeb2003_mat_03ANO.dta", clear

merge 1:1 mascara_saeb using "E:\bases_dta\saeb_prova_brasil\2003\saeb2003_port_03ANO.dta"
drop _merge
merge 1:1 mascara_saeb using "E:\bases_dta\saeb_prova_brasil\2003\saeb2003_dir_03ANO.dta"
drop _merge
merge 1:1 mascara_saeb using "E:\bases_dta\saeb_prova_brasil\2003\saeb2003_prof_03ANO.dta"
drop _merge
save "E:\bases_dta\saeb_prova_brasil\2003\saeb2003_03ANO.dta", replace

use "E:\bases_dta\saeb_prova_brasil\2003\saeb2003_mat_04SERIE.dta", clear

merge 1:1 mascara_saeb using "E:\bases_dta\saeb_prova_brasil\2003\saeb2003_port_04SERIE.dta"
drop _merge
merge 1:1 mascara_saeb using "E:\bases_dta\saeb_prova_brasil\2003\saeb2003_dir_04SERIE.dta"
drop _merge
merge 1:1 mascara_saeb using "E:\bases_dta\saeb_prova_brasil\2003\saeb2003_prof_04SERIE.dta"
drop _merge
save "E:\bases_dta\saeb_prova_brasil\2003\saeb2003_04SERIE.dta", replace

use "E:\bases_dta\saeb_prova_brasil\2003\saeb2003_mat_08SERIE.dta", clear

merge 1:1 mascara_saeb using "E:\bases_dta\saeb_prova_brasil\2003\saeb2003_port_08SERIE.dta"
drop _merge
merge 1:1 mascara_saeb using "E:\bases_dta\saeb_prova_brasil\2003\saeb2003_dir_08SERIE.dta"
drop _merge
merge 1:1 mascara_saeb using "E:\bases_dta\saeb_prova_brasil\2003\saeb2003_prof_08SERIE.dta"
drop _merge
save "E:\bases_dta\saeb_prova_brasil\2003\saeb2003_08SERIE.dta", replace


use "E:\bases_dta\saeb_prova_brasil\2003\saeb2003_03ANO.dta", clear

merge 1:1 mascara_saeb using "E:\bases_dta\saeb_prova_brasil\2003\saeb2003_04SERIE.dta"
drop _merge
merge 1:1 mascara_saeb using "E:\bases_dta\saeb_prova_brasil\2003\saeb2003_08SERIE.dta"
save "E:\bases_dta\saeb_prova_brasil\2003\saeb2003.dta", replace

*associando a escola ao código de escola

use "E:\bases_dta\saeb_prova_brasil\2003\saeb2003.dta", replace
rename mascara_saeb mascara2003
drop _m
merge 1:1 mascara2003 using "E:\bases_dta\saeb_prova_brasil\2003\mascara2003.dta"

rename escola_codigo codigo_escola

save "E:\bases_dta\saeb_prova_brasil\2003\saeb2003.dta", replace


*ajustando série 
*ajustando série
gen serie_velho = serie
replace serie = serie +1  
save "E:\bases_dta\saeb_prova_brasil\2003\saeb2003.dta", replace
