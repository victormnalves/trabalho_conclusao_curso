/*******************************SAEB 2005**************************************/
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
/* 
4ª
PROFIC_250 222-233 COMMA12.10
PROFIC_SAE 234-245 COMMA12.10
8ª
PROFIC_250 228-239 COMMA12.10
PROFIC_SAE 240-251 COMMA12.10
*/

*3º ano
	*ok infix e variáveis
		clear all 

		# delimit ;

		infix 

		double MASCARA 1-8
		ANO 17-24
		SERIE 25-26
		str DISC 27-27
		CODUF 86-87
		/*Peso do aluno por disciplina*/ 
		double PESO_AC 104-115
		/*Proficiência na escala 250 ; 50 */
		double PROFIC_250 230-241
		/*Proficiência na escala Saeb*/
		double PROFIC_SAE 242-253
		
		str A081_016 269-269
		str A081_021 274-274

		using "E:\SAEB Prova Brasil\microdados_saeb_2005\DADOS\ALUNOS\MATEMATICA_03ANO.txt";

		# delimit cr

		rename MASCARA mascara_saeb
		rename ANO ano_saeb
		rename SERIE serie
		*disciplina
		rename DISC disc
		rename CODUF codigo_uf
		*peso calibrado
		rename PESO_AC peso_m_saeb

		*proficiência (Proficiência na escala 250 ; 50)
		rename PROFIC_250 profic_250_m_saeb_3
		*proficiência(Proficiência na escala Saeb) 
		rename PROFIC_SAE profic_m_esc_saeb_3

		*casa tem computador com internet?
		gen s_comp_internet_3=.
		replace s_comp_internet_3=1 if A081_016=="A"
		replace s_comp_internet_3=0 if A081_016=="B"

		*na casa trabalha empregada doméstica?
		gen s_empregada_diarista_3=.
		replace s_empregada_diarista_3=1 if A081_021=="A" | A081_021=="B" | A081_021=="C"
		replace s_empregada_diarista_3=0 if A081_021=="D"

		*collapse

		# delimit ;
		collapse 
		(first) disc 
		(mean) ano_saeb serie peso_m_saeb profic_250_m_saeb_3 
		profic_m_esc_saeb_3 s_comp_internet_3 s_empregada_diarista_3, 
		by(mascara_saeb)
		;
		# delimit cr

		save "E:\bases_dta\saeb_prova_brasil\2005\saeb2005_mat_03ANO.dta", replace
				 

*4ª série
	
		clear all

		# delimit ;

		infix 

		double MASCARA 1-8
		ANO 17-24
		SERIE 25-26
		str DISC 27-27
		CODUF 79-80
		double PESO_AC 97-108
		double PROFIC_250 223-234

		double PROFIC_SAE 235-246
		str A041_018 264-264
		str A041_023 269-269

		using "E:\SAEB Prova Brasil\microdados_saeb_2005\DADOS\ALUNOS\MATEMATICA_04SERIE.txt";

		# delimit cr

		rename MASCARA mascara_saeb
		rename ANO ano_saeb
		rename SERIE serie
		*disciplina
		rename DISC disc
		rename CODUF codigo_uf
		*peso calibrado
		rename PESO_AC peso_m_saeb
		*proficiência (Proficiência na escala 250 ; 50)
		rename PROFIC_250 profic_250_m_saeb_5
		*proficiência(Proficiência na escala Saeb) 
		rename PROFIC_SAE profic_m_esc_saeb_5

		*casa tem computador com internet?
		gen s_comp_internet_5=.
		replace s_comp_internet_5=1 if A041_018=="A"
		replace s_comp_internet_5=0 if A041_018=="B"

		*na casa trabalha empregada doméstica?
		gen s_empregada_diarista_5=.
		replace s_empregada_diarista_5=1 if A041_023=="A" | A041_023=="B" | A041_023=="C"
		replace s_empregada_diarista_5=0 if A041_023=="D"

		*collapse

		# delimit ;
		collapse 
		(first) disc 
		(mean) ano_saeb serie peso_m_saeb profic_250_m_saeb_5 
		profic_m_esc_saeb_5 s_comp_internet_5 s_empregada_diarista_5, 
		by(mascara_saeb)
		;
		# delimit cr

		save "E:\bases_dta\saeb_prova_brasil\2005\saeb2005_mat_04SERIE.dta", replace
				 
*8ªsérie
		clear all

		# delimit ;

		infix 

		double MASCARA 1-8
		ANO 17-24
		SERIE 25-26
		str DISC 27-27
		CODUF 85-86
		double PESO_AC 103-114
		double PROFIC_250 229-240

		double PROFIC_SAE 241-252
		str A081_016 268-268
		str A081_021 273-273

		using "E:\SAEB Prova Brasil\microdados_saeb_2005\DADOS\ALUNOS\MATEMATICA_08SERIE.txt";

		# delimit cr

		rename MASCARA mascara_saeb
		rename ANO ano_saeb
		rename SERIE serie
		*disciplina
		rename DISC disc
		rename CODUF codigo_uf
		*peso calibrado
		rename PESO_AC peso_m_saeb
		*proficiência (Proficiência na escala 250 ; 50)
		rename PROFIC_250 profic_250_m_saeb_9
		*proficiência(Proficiência na escala Saeb) 
		rename PROFIC_SAE profic_m_esc_saeb_9

		*casa tem computador com internet?
		gen s_comp_internet_9=.
		replace s_comp_internet_9=1 if A081_016=="A"
		replace s_comp_internet_9=0 if A081_016=="B"

		*na casa trabalha empregada doméstica?
		gen s_empregada_diarista_9=.
		replace s_empregada_diarista_9=1 if A081_021=="A" | A081_021=="B" | A081_021=="C"
		replace s_empregada_diarista_9=0 if A081_021=="D"

		*collapse

		# delimit ;
		collapse 
		(first) disc 
		(mean) ano_saeb serie peso_m_saeb profic_250_m_saeb_9 
		profic_m_esc_saeb_9 s_comp_internet_9 s_empregada_diarista_9, 
		by(mascara_saeb)
		;
		# delimit cr

		save "E:\bases_dta\saeb_prova_brasil\2005\saeb2005_mat_08SERIE.dta", replace
				 

/*--------- Português-------------*/
*4ªsérie, 8ª série, 3º ano
*3º ano
	*infix e variáveis ok
		clear all

		# delimit ;
		infix 

		double MASCARA 1-8
		ANO 17-24
		SERIE 25-26
		str DISC 27-27
		CODUF 86-87
		double PESO_AC 106-117
		double PROFIC_250 232-243
		double PROFIC_SAE 244-255

		using "E:\SAEB Prova Brasil\microdados_saeb_2005\DADOS\ALUNOS\PORTUGUES_03ANO.txt";

		# delimit cr

		**** Renomear e construir variáveis

		rename MASCARA mascara_saeb
		rename ANO ano_saeb
		rename SERIE serie
		rename DISC disc
		rename CODUF codigo_uf
		rename PESO_AC peso_p_saeb
		rename PROFIC_250 profic_250_p_saeb_3
		rename PROFIC_SAE profic_p_esc_saeb_3


		*collapse
		# delimit ;
		collapse 
		(first) disc 
		(mean) ano_saeb serie peso_p_saeb profic_250_p_saeb_3 profic_p_esc_saeb_3, 
		by(mascara_saeb)
		;
		# delimit cr

		save "E:\bases_dta\saeb_prova_brasil\2005\saeb2005_port_03ANO.dta", replace

* 8ª série
	*infix e variáveis ok
		clear all

		# delimit ;
		infix 

		double MASCARA 1-8
		ANO 17-24
		SERIE 25-26
		str DISC 27-27
		CODUF 85-86
		double PESO_AC 105-116
		double PROFIC_250 231-242
		double PROFIC_SAE 243-254

		using "E:\SAEB Prova Brasil\microdados_saeb_2005\DADOS\ALUNOS\PORTUGUES_08SERIE.txt";

		# delimit cr
		**** Renomear e construir variáveis

		rename MASCARA mascara_saeb
		rename ANO ano_saeb
		rename SERIE serie
		rename DISC disc
		rename CODUF codigo_uf
		rename PESO_AC peso_p_saeb

		rename PROFIC_250 profic_250_p_saeb_9
		rename PROFIC_SAE profic_p_esc_saeb_9


		*collapse
		# delimit ;
		collapse 
		(first) disc 
		(mean) ano_saeb serie peso_p_saeb profic_250_p_saeb_9 profic_p_esc_saeb_9, 
		by(mascara_saeb)
		;
		# delimit cr

		save "E:\bases_dta\saeb_prova_brasil\2005\saeb2005_port_08SERIE.dta", replace

* 4ª série
	*infix e variáveis ok
		clear all

		# delimit ;
		infix 

		double MASCARA 1-8
		ANO 17-24
		SERIE 25-26
		str DISC 27-27
		CODUF 86-87
		double PESO_AC 106-117
		double PROFIC_250 225-236
		double PROFIC_SAE 237-249

		using "E:\SAEB Prova Brasil\microdados_saeb_2005\DADOS\ALUNOS\PORTUGUES_04SERIE.txt";

		# delimit cr
		**** Renomear e construir variáveis

		rename MASCARA mascara_saeb
		rename ANO ano_saeb
		rename SERIE serie
		rename DISC disc
		rename CODUF codigo_uf
		rename PESO_AC peso_p_saeb
		
		rename PROFIC_250 profic_250_p_saeb_5
		rename PROFIC_SAE profic_p_esc_saeb_5


		*collapse
		# delimit ;
		collapse 
		(first) disc 
		(mean) ano_saeb serie peso_p_saeb profic_250_p_saeb_5 profic_p_esc_saeb_5, 
		by(mascara_saeb)
		;
		# delimit cr

		save "E:\bases_dta\saeb_prova_brasil\2005\saeb2005_port_04SERIE.dta", replace





/*---------Diretor-------------*/
set trace on


clear

# delimit ;
infix 

double MASCARA 1-8
int ANO 17-24
double PESO_TC 47-58
str Q25 83-83


using "E:\SAEB Prova Brasil\microdados_saeb_2005\DADOS\DIRETOR\DIRETOR_05.txt";

# delimit cr
**** Renomear e construir variáveis

rename MASCARA mascara_saeb
rename ANO ano_saeb
rename PESO_TC peso_d_saeb


* criar variáveis
* Q25: método como a direção da escola foi assumida
* Que processo levou você a assumir a direção desta escola?: 
	/*A se foi asusmida por seleção*/
gen s_metodo_esc_dir_selecao=.

replace s_metodo_esc_dir_selecao=1 if Q25=="A"
replace s_metodo_esc_dir_selecao=0 if Q25=="B" | Q25=="C" | Q25=="D" | Q25=="E" | Q25=="F" | Q25=="G"

	/*B se foi assumida por eleição*/
gen s_metodo_esc_dir_eleicao=.
replace s_metodo_esc_dir_eleicao=1 if Q25=="B"
replace s_metodo_esc_dir_eleicao=0 if Q25=="A" | Q25=="C" | Q25=="D" | Q25=="E" | Q25=="F" | Q25=="G"

	
	/*C se foi assumida por seleção e eleção*/
gen s_metodo_esc_dir_sel_ele=.
replace s_metodo_esc_dir_sel_ele=1 if Q25=="C"
replace s_metodo_esc_dir_sel_ele=0 if Q25=="A" | Q25=="C" | Q25=="D" | Q25=="E" | Q25=="F" | Q25=="G"

	/*D, E, F se foi assumida por indicação*/
gen s_metodo_esc_dir_indic=.
replace s_metodo_esc_dir_indic=1 if Q25=="D" | Q25=="E" | Q25=="F"
replace s_metodo_esc_dir_indic=0 if Q25=="A" | Q25=="B" | Q25=="C" | Q25=="G"

*dropando a variável 
drop Q25

*collapse
# delimit ;
collapse 
(mean) ano_saeb  peso_d_saeb 
s_metodo_esc_dir_selecao-s_metodo_esc_dir_indic, 
by (mascara_saeb);
save "E:\bases_dta\saeb_prova_brasil\2005\saeb2005_dir.dta", replace;
# delimit cr


/*---------Docentes------------*/
set trace on

foreach x in "03ANO" "04SERIE" "08SERIE" {
clear

# delimit ;
infix 

double MASCARA 1-8
ANO 17-20
SERIE 25-26
double PESO_EC 91-102
double PESO_TC 103-114
str Q15 129-129
str Q16 130-130
str Q17 131-131

using "E:\SAEB Prova Brasil\microdados_saeb_2005\DADOS\DOCENTE\DOCENTE_05.txt";

# delimit cr

**** Renomear e construir variáveis

rename MASCARA mascara_saeb
rename ANO ano_saeb
rename SERIE serie
rename PESO_EC peso_p_t_saeb
rename PESO_TC peso_p_e_saeb

if "`x'" == "03ANO"{
	keep if serie == 11
	*criar variáveis

	*P009: Há quantos anos você está lecionando? 
		/*leciona há mais que 3 anos*/
	gen s_exp_prof_mais_3_3=.
	replace s_exp_prof_mais_3_3=1 if Q15=="C" | Q15=="D" | Q15=="E" | Q15=="F" | Q15=="G" 
	replace s_exp_prof_mais_3_3=0 if Q15=="A" | Q15=="B"

	*P010: Há quantos anos você trabalha nesta escola? 
		/*trabalha há mais do que 3 anos na escola*/
	gen s_exp_prof_escola_mais_3_3=.
	replace s_exp_prof_escola_mais_3_3=1 if Q16=="C" | Q16=="D" | Q16=="E" | Q16=="F" | Q16=="G" 
	replace s_exp_prof_escola_mais_3_3=0 if Q16=="A" | Q16=="B"

	*P011: Há quanto tempo você é professor desta turma?
		/*há menos de 1 ano*/
	gen s_prof_turma_desde_inicio_3=.
	replace s_prof_turma_desde_inicio_3=1 if Q17=="A"
	replace s_prof_turma_desde_inicio_3=0 if Q17=="B" | Q17=="C" | Q17=="D" | Q17=="E"

	# delimit ;

	collapse 
	(mean) ano_saeb serie peso_p_t_saeb peso_p_e_saeb
	s_exp_prof_mais_3_3-s_prof_turma_desde_inicio_3, 
	by (mascara_saeb);
	# delimit cr

	save "E:\bases_dta\saeb_prova_brasil\2005\saeb2005_prof_`x'.dta", replace
	}
if "`x'" == "04SERIE"{
	keep if serie == 4
	*criar variáveis

	*P009: Há quantos anos você está lecionando? 
		/*leciona há mais que 3 anos*/
	gen s_exp_prof_mais_3_5=.
	replace s_exp_prof_mais_3_5=1 if Q15=="C" | Q15=="D" | Q15=="E" | Q15=="F" | Q15=="G" 
	replace s_exp_prof_mais_3_5=0 if Q15=="A" | Q15=="B"

	*P010: Há quantos anos você trabalha nesta escola? 
		/*trabalha há mais do que 3 anos na escola*/
	gen s_exp_prof_escola_mais_3_5=.
	replace s_exp_prof_escola_mais_3_5=1 if Q16=="C" | Q16=="D" | Q16=="E" | Q16=="F" | Q16=="G" 
	replace s_exp_prof_escola_mais_3_5=0 if Q16=="A" | Q16=="B"

	*P011: Há quanto tempo você é professor desta turma?
		/*há menos de 1 ano*/
	gen s_prof_turma_desde_inicio_5=.
	replace s_prof_turma_desde_inicio_5=1 if Q17=="A"
	replace s_prof_turma_desde_inicio_5=0 if Q17=="B" | Q17=="C" | Q17=="D" | Q17=="E"

	# delimit ;

	collapse 
	(mean) ano_saeb serie peso_p_t_saeb peso_p_e_saeb
	s_exp_prof_mais_3_5-s_prof_turma_desde_inicio_5, 
	by (mascara_saeb);
	# delimit cr

	save "E:\bases_dta\saeb_prova_brasil\2005\saeb2005_prof_`x'.dta", replace
	}
if "`x'" == "08SERIE"{
	keep if serie == 8 
	*criar variáveis

	*P009: Há quantos anos você está lecionando? 
		/*leciona há mais que 3 anos*/
	gen s_exp_prof_mais_3_9=.
	replace s_exp_prof_mais_3_9=1 if Q15=="C" | Q15=="D" | Q15=="E" | Q15=="F" | Q15=="G" 
	replace s_exp_prof_mais_3_9=0 if Q15=="A" | Q15=="B"

	*P010: Há quantos anos você trabalha nesta escola? 
		/*trabalha há mais do que 3 anos na escola*/
	gen s_exp_prof_escola_mais_3_9=.
	replace s_exp_prof_escola_mais_3_9=1 if Q16=="C" | Q16=="D" | Q16=="E" | Q16=="F" | Q16=="G" 
	replace s_exp_prof_escola_mais_3_9=0 if Q16=="A" | Q16=="B"

	*P011: Há quanto tempo você é professor desta turma?
		/*há menos de 1 ano*/
	gen s_prof_turma_desde_inicio_9=.
	replace s_prof_turma_desde_inicio_9=1 if Q17=="A"
	replace s_prof_turma_desde_inicio_9=0 if Q17=="B" | Q17=="C" | Q17=="D" | Q17=="E"

	# delimit ;

	collapse 
	(mean) ano_saeb serie peso_p_t_saeb peso_p_e_saeb
	s_exp_prof_mais_3_9-s_prof_turma_desde_inicio_9, 
	by (mascara_saeb);
	# delimit cr

	save "E:\bases_dta\saeb_prova_brasil\2005\saeb2005_prof_`x'.dta", replace
	}
	

}



use "E:\bases_dta\saeb_prova_brasil\2005\saeb2005_mat_03ANO.dta", clear

merge 1:1 mascara_saeb using "E:\bases_dta\saeb_prova_brasil\2005\saeb2005_port_03ANO.dta"
drop _merge
merge 1:1 mascara_saeb using "E:\bases_dta\saeb_prova_brasil\2005\saeb2005_dir.dta"
drop _merge
merge 1:1 mascara_saeb using "E:\bases_dta\saeb_prova_brasil\2005\saeb2005_prof_03ANO.dta"
drop _merge
save "E:\bases_dta\saeb_prova_brasil\2005\saeb2005_03ANO.dta", replace

use "E:\bases_dta\saeb_prova_brasil\2005\saeb2005_mat_04SERIE.dta", clear

merge 1:1 mascara_saeb using "E:\bases_dta\saeb_prova_brasil\2005\saeb2005_port_04SERIE.dta"
drop _merge
merge 1:1 mascara_saeb using "E:\bases_dta\saeb_prova_brasil\2005\saeb2005_dir.dta"
drop _merge
merge 1:1 mascara_saeb using "E:\bases_dta\saeb_prova_brasil\2005\saeb2005_prof_04SERIE.dta"
drop _merge
save "E:\bases_dta\saeb_prova_brasil\2005\saeb2005_04SERIE.dta", replace

use "E:\bases_dta\saeb_prova_brasil\2005\saeb2005_mat_08SERIE.dta", clear

merge 1:1 mascara_saeb using "E:\bases_dta\saeb_prova_brasil\2005\saeb2005_port_08SERIE.dta"
drop _merge
merge 1:1 mascara_saeb using "E:\bases_dta\saeb_prova_brasil\2005\saeb2005_dir.dta"
drop _merge
merge 1:1 mascara_saeb using "E:\bases_dta\saeb_prova_brasil\2005\saeb2005_prof_08SERIE.dta"
drop _merge
save "E:\bases_dta\saeb_prova_brasil\2005\saeb2005_08SERIE.dta", replace


use "E:\bases_dta\saeb_prova_brasil\2005\saeb2005_03ANO.dta", replace
merge 1:1 mascara_saeb using  "E:\bases_dta\saeb_prova_brasil\2005\saeb2005_04SERIE.dta"

drop _merge

merge 1:1 mascara_saeb using  "E:\bases_dta\saeb_prova_brasil\2005\saeb2005_08SERIE.dta"
save "E:\bases_dta\saeb_prova_brasil\2005\saeb2005.dta", replace


*associando a escola ao código de escola

use "E:\bases_dta\saeb_prova_brasil\2005\saeb2005.dta", replace
rename mascara_saeb mascara2005
drop _m
merge 1:1 mascara2005 using "E:\bases_dta\saeb_prova_brasil\2005\mascara2005.dta"

rename escola_codigo codigo_escola

save "E:\bases_dta\saeb_prova_brasil\2005\saeb2005.dta", replace


*ajustando série
gen serie_velho = serie
replace serie = serie +1  
save "E:\bases_dta\saeb_prova_brasil\2005\saeb2005.dta", replace
