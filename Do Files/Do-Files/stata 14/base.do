/*Vamos reproduzir as análises do ICE, usando as bases de dados presentes na pasta
do ICE. Nessa primeira etapa, será reproduzido a construção das bases de dados
*/

 
 ******************** 1. Base Original ***********************************
 
/*
Aqui, vamos modificar a base original, importando a base do excel para dta
a base original se chama Base de dados estudo 2016 v1.xlsx, renomenado as 
variáveis e criando as dummies necessárias
*/

/*importando do xlsx para o stata*/
clear all
cap cd "C:\Users\Administrator\OneDrive\EESP - ECONOMIA - mestrado acadêmico\Dissertação\ICE\dados ICE\Dados ICE\"
import excel "Base de dados estudo 2016 v1.xlsx", sheet("Escolas") firstrow


/*renomeando as variáveis*/

rename UF uf
rename MUNICÍPIO nome_municipio
rename ESCOLA nome_escola
rename Jornada ice_jornada
rename Segmento ice_segmento
rename Ano ano
rename CódigoINEP codigo_escola
rename Rigor ice_rigor

replace nome_municipio = "IGARASSU" if nome_municipio == "Igarassu"


/*gerar dummies*/

/*dummy de participação do programa*/
gen ice = 1

/* bloco de código q talvez tenha que ser usado para completar anos faltantes
em algumas observações
******* Completar anos *******

* gerar dummy de imputado
gen input_ano=0
*replace input_ano=1 if ano=="2010 - 2014"
*replace input_ano=1 if ano==""

*gen input_ano_m=0
*replace input_ano_m=1 if ano==""

* se o ano foi em 2010 e 2014, assumir que foi 2012
*replace ano="2012" if ano=="2010 - 2014"

*destring ano, replace

* imputar ano para os que sao missing - ano maximo do municipio quando houver ou ano moda do estado
bysort nome_municipio: egen max_ano_munic=max(ano)
bysort uf: egen mode_ano_uf=mode(ano)

replace max_ano_munic=mode_ano_uf if max_ano_munic==.

gen anos_aux=(2015-max_ano_munic+1)/2
gen anos_aux_2=2015-anos_aux
replace anos_aux_2=round(anos_aux_2)

replace ano=anos_aux_2 if ano==.
*/

/*dummy de ensino fundamental, a partir do segmento*/

gen ensino_fundamental = 0
replace ensino_fundamental = 1 if ice_segmento == "EF FINAIS"
replace ensino_fundamental = 1 if ice_segmento == "EF FINAIS + EM"
replace ensino_fundamental = 1 if ice_segmento == "EFII"
replace ensino_fundamental = . if ice_segmento == "Não temos info"

/*dummies de ano de entrada no ICE*/
/*
a dummy assumirá 1 para todos anos anteriores
assim, uma escola que entrou em 2004 vai ter a dummy de 2005
o que indica a continuidade da escola no programa
*/
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

/*
forvalues vai dar zero para as dummies de entrada de ano
para escolas que até dois anos antes da entrada do programa
era uma scola de ensino fundamental
e também estavam no estado de PE ou CE
*/
forvalues a = 2004(1)2015{
replace ice_`a' = 0 if (ano > `a' - 2 & ano <= `a') & (uf == "PE" | uf == "CE") & ensino_fundamental == 0 

}
/*renomenado ano em ano_ice*/
rename ano ano_ice


/*dummy de ensino integral*/
gen integral = 1
replace integral = 0 if ice_jornada == "Semi-integral"

*dropar escola com codigo_inep duplicado e errado (de qualquer maneira, o ano de entrada e 2015, entao a escola esta fora da analise)
drop if nome_escola == "LOURENCO FILHO" & codigo_escola == 35003669

* dropar escolas sem codigo (nao serao mergeadas)
drop if codigo_escola == .

save "C:\Users\Administrator\OneDrive\EESP - ECONOMIA - mestrado acadêmico\Dissertação\ICE\dados ICE\Análise Leonardo\base original ice.dta", replace

******************** 2. Base Alavancas ***********************************
/*
Aqui, vamos modificar a base de alavancas, importando a base do excel para dta
a base original se chama Base_geral_escolas_alavancas.xlsx, renomenado as 
variáveis e criando as dummies necessárias
*/
clear
import excel "Base_geral_escolas_alavancas.xlsx", sheet("Plan1") firstrow
  
/*renomeando as variáveis*/
rename UF uf
rename MUNICÍPIO nome_municipio
rename ESCOLA nome_escola
rename Ano ano_ice
rename CódigoINEP codigo_escola
rename BomengajamentodoGovernador al_engaj_gov
rename Bomengajamentodosecretáriode al_engaj_sec
rename TimedaSEDUCdedicadoparaimpl al_time_seduc
rename Implantaçãodosmarcoslegaisna al_marcos_lei
rename Implantaçãodetodososmarcosl al_todos_marcos
rename Implantaçãodoprocessodeseleç al_sel_dir
rename L al_sel_prof
rename Implantaçãodoprojetodevidan al_proj_vida
 
/*transformando em dummies as variáveis*/
 foreach x of varlist al_engaj_gov al_engaj_sec al_time_seduc al_marcos_lei al_todos_marcos al_sel_dir al_sel_prof al_proj_vida {
replace `x'="1" if `x'=="SIM"
replace `x'="0" if `x'=="NAO"
replace `x'="0" if `x'=="NÃO"
}

destring al_engaj_gov al_engaj_sec al_time_seduc al_marcos_lei al_todos_marcos al_sel_dir al_sel_prof al_proj_vida, replace
 
*drop ano (porque foi modificado na primeira base)
drop ano_ice

*drop escola com codigo_inep duplicado e errado (de qualquer maneira, o ano de entrada e 2015, entao a escola esta fora da an⭩se)
drop if nome_escola=="LOURENCO FILHO" & codigo_escola==35003669


/*mergeando com a base original ice.dta*/
merge 1:1 codigo_escola using "C:\Users\Administrator\OneDrive\EESP - ECONOMIA - mestrado acadêmico\Dissertação\ICE\dados ICE\Análise Leonardo\base original ice.dta"

drop _m
save "base original ice.dta", replace

******************** 3. Juntando ENEM, SAEB, Proba Brasil ***********************************
 
******************** 3.a. ajustando ENEM 
/*aqui será necessário utilizar dados da pasta Dados importados, que não está disponibilizado*/ 
/*
clear
cd "C:\Users\vladimir.ponczek\Documents\ICE\"
use "Dados importados\ENEM\enem_todos.dta"
*rename ano_enem ano
*drop _m
save "Dados importados\ENEM\enem_todos.dta", replace
*/

******************** 3.b. ajustando SAEB
/*aqui será necessário utilizar dados da pasta Dados importados, que não está disponibilizado*/ 
/*
use "Dados importados\SAEB\saeb_todos.dta"
rename ano_saeb ano
drop _m
drop if codigo_escola==.
save "Dados importados\SAEB\saeb_todos.dta", replace
*/

******************** 3.c. ajustando PB
/*aqui será necessário utilizar dados da pasta Dados importados, que não está disponibilizado*/ 
/*
use "Dados importados\Prova Brasil\provabrasil_todos.dta"
rename ano_prova_brasil ano
save "Dados importados\Prova Brasil\provabrasil_todos.dta", replace
*/

******************** 3.d. mergeando ENEM, SAEB, PB, FLUXO
/*aqui será necessário utilizar dados da pasta Dados importados, que não está disponibilizado*/ 
/*
use "Dados importados\ENEM\enem_todos.dta", clear
merge 1:1 codigo_escola ano using "Dados importados\SAEB\saeb_todos.dta"
drop _m
merge 1:1 codigo_escola ano using "Dados importados\Prova Brasil\provabrasil_todos.dta"
drop _m
merge 1:1 codigo_escola ano using "Dados importados\Censo Escolar\Indicadores INEP\fluxo_2007a2014.dta"
drop _m

drop if codigo_escola==.
save "Dados ICE\aux_enem_saeb_provabrasil.dta", replace
*/



******************** 3.e. Ajustes CENSO (por estado) 
/*aqui será necessário utilizar dados da pasta Dados importados, que não está disponibilizado*/ 
/*
use "Dados importados\Censo Escolar\censo_escolar_PE.dta"
rename ano_censo ano
keep if UF=="Pernambuco" | sigla=="PE" | codigo_uf==26
drop if codigo_escola==.
save "Dados importados\Censo Escolar\censo_escolar_PE.dta", replace

use "Dados importados\Censo Escolar\censo_escolar_CE.dta"
rename ano_censo ano
keep if sigla=="CE" | codigo_uf==23
drop if codigo_escola==.
save "Dados importados\Censo Escolar\censo_escolar_CE.dta", replace

use "Dados importados\Censo Escolar\censo_escolar_SP.dta"
rename ano_censo ano
keep if sigla=="SP" | codigo_uf==35
drop if codigo_escola==.
save "Dados importados\Censo Escolar\censo_escolar_SP.dta", replace

use "Dados importados\Censo Escolar\censo_escolar_RJ.dta"
rename ano_censo ano
keep if sigla=="RJ" | codigo_uf==33
drop if codigo_escola==.
save "Dados importados\Censo Escolar\censo_escolar_RJ.dta", replace

use "Dados importados\Censo Escolar\censo_escolar_GO.dta"
rename ano_censo ano
keep if sigla=="GO" | codigo_uf==52
drop if codigo_escola==.
save "Dados importados\Censo Escolar\censo_escolar_GO.dta", replace
*/

******************** 3.f. mergeando ENEM, PB/SAEB com CENSO ESCOLAR

/*aqui será necessário utilizar dados da pasta Dados importados, que não está disponibilizado*/ 
/*
use "Dados ICE\aux_enem_saeb_provabrasil.dta"
merge 1:1 codigo_escola ano using "Dados importados\Censo Escolar\censo_escolar_PE.dta"
drop if _m==1
drop _m
save "Dados ICE\aux_enem_saeb_provabrasil_censo_pe.dta", replace

use "Dados ICE\aux_enem_saeb_provabrasil.dta"
merge 1:1 codigo_escola ano using "Dados importados\Censo Escolar\censo_escolar_CE.dta"
drop if _m==1
drop _m
save "Dados ICE\aux_enem_saeb_provabrasil_censo_ce.dta", replace

use "Dados ICE\aux_enem_saeb_provabrasil.dta"
merge 1:1 codigo_escola ano using "Dados importados\Censo Escolar\censo_escolar_RJ.dta"
drop if _m==1
drop _m
save "Dados ICE\aux_enem_saeb_provabrasil_censo_rj.dta", replace

use "Dados ICE\aux_enem_saeb_provabrasil.dta"
merge 1:1 codigo_escola ano using "Dados importados\Censo Escolar\censo_escolar_SP.dta"
drop if _m==1
drop _m
save "Dados ICE\aux_enem_saeb_provabrasil_censo_sp.dta", replace

use "Dados ICE\aux_enem_saeb_provabrasil.dta"
merge 1:1 codigo_escola ano using "Dados importados\Censo Escolar\censo_escolar_GO.dta"
drop if _m==1
drop _m
save "Dados ICE\aux_enem_saeb_provabrasil_censo_go.dta", replace
*/

******************** 3.g. Merge final
/*
Nessa etapa, a base original, base alavancas, a base enem/saeb/pb/censo por estado,
obtidas nas etapas anteriores, mais a base mais_educação (que também está na pasta 
Dados Importados) serão todas mergeadas, resultando em uma base agregada para cada
estado
*/


***************************
*********** PE ************
***************************
clear
use "Dados ICE\base original ice.dta"
keep if uf=="PE"
merge 1:1 codigo_escola using "Dados importados\Mais Educação\mais_educacao_todos.dta"
drop _merge
merge 1:m codigo_escola using "Dados ICE\aux_enem_saeb_provabrasil_censo_pe.dta"
drop _merge
keep if UF=="Pernambuco" | sigla=="PE" | codigo_uf==26 | ice_2004==1 | ice_2005==1 | ice_2006==1 | ice_2007==1 | ice_2008==1| ice_2009==1| ice_2010==1| ice_2011==1| ice_2012==1| ice_2013==1| ice_2014==1| ice_2015==1

save "Dados ICE\ice_completo_pe.dta", replace

***************************
*********** CE ************
***************************
clear
use "Dados ICE\base original ice.dta"
keep if uf=="CE"
* inserir codigos de escola se chegarem
drop if codigo_escola==.
merge 1:1 codigo_escola using "Dados importados\Mais Educação\mais_educacao_todos.dta"
drop _merge
merge 1:m codigo_escola using "Dados ICE\aux_enem_saeb_provabrasil_censo_ce.dta"
drop _merge
keep if sigla=="CE" | codigo_uf==23 | ice_2004==1 | ice_2005==1 | ice_2006==1 | ice_2007==1 | ice_2008==1| ice_2009==1| ice_2010==1| ice_2011==1| ice_2012==1| ice_2013==1| ice_2014==1| ice_2015==1

save "Dados ICE\ice_completo_ce.dta", replace

***************************
*********** RJ ************
***************************
clear
use "Dados ICE\base original ice.dta"
keep if uf=="RJ"
* inserir codigos de escola se chegarem
drop if codigo_escola==.
merge 1:1 codigo_escola using "Dados importados\Mais Educação\mais_educacao_todos.dta"
drop _merge
merge 1:m codigo_escola using "Dados ICE\aux_enem_saeb_provabrasil_censo_rj.dta"
drop _merge
keep if sigla=="RJ" | codigo_uf==33 | ice_2004==1 | ice_2005==1 | ice_2006==1 | ice_2007==1 | ice_2008==1| ice_2009==1| ice_2010==1| ice_2011==1| ice_2012==1| ice_2013==1| ice_2014==1| ice_2015==1

save "Dados ICE\ice_completo_rj.dta", replace

***************************
*********** SP ************
***************************
clear
use "Dados ICE\base original ice.dta"
keep if uf=="SP"
* inserir codigos de escola se chegarem
drop if codigo_escola==.
* para retirar duplicata, vou remover a escola em que foi implementado em 2015 pois nao da para avaliar
drop if codigo_escola==35003669 & ano_ice==2015
merge 1:1 codigo_escola using "Dados importados\Mais Educação\mais_educacao_todos.dta"
drop _merge
merge 1:m codigo_escola using "Dados ICE\aux_enem_saeb_provabrasil_censo_sp.dta"
drop _merge
keep if sigla=="SP" | codigo_uf==35 | ice_2004==1 | ice_2005==1 | ice_2006==1 | ice_2007==1 | ice_2008==1| ice_2009==1| ice_2010==1| ice_2011==1| ice_2012==1| ice_2013==1| ice_2014==1| ice_2015==1

save "Dados ICE\ice_completo_sp.dta", replace

***************************
*********** GO ************
***************************
clear
use "Dados ICE\base original ice.dta"
keep if uf=="GO"
* inserir codigos de escola se chegarem
drop if codigo_escola==.
merge 1:1 codigo_escola using "Dados importados\Mais Educação\mais_educacao_todos.dta"
drop _merge
merge 1:m codigo_escola using "Dados ICE\aux_enem_saeb_provabrasil_censo_go.dta"
drop _merge
keep if sigla=="GO" | codigo_uf==52 | ice_2004==1 | ice_2005==1 | ice_2006==1 | ice_2007==1 | ice_2008==1| ice_2009==1| ice_2010==1| ice_2011==1| ice_2012==1| ice_2013==1| ice_2014==1| ice_2015==1

save "Dados ICE\ice_completo_go.dta", replace

******************** 3.h. Append por estados
/*com as bases separadas por estados, vamos append todas elas em uma só base*/
use "Dados ICE\ice_completo_go.dta", clear

local x "pe rj ce sp"

foreach i in `x'{
append using "Dados ICE\ice_completo_`i'"
}


******************** 4. Ajustes gerais na base final ***********************************

/*
O resultado do processo até agora é uma base que contém dados do ice (original e 
alavancas), dados nos microdados de educação agregados por escola (ENEM, SAEB, PB,
CENSO ESCOLAR, MAIS EDUCAÇÃO) para todos os estados que contém escolas tratadas 
pelo programa
A seguir, serão feitos algum ajustes: padronizações, criação de dummies 
Ao final desse processo,a base de dados estará pronta para análise (ice_clean.dta)

*/
******************** 4.a. Ajustes em variáveis

************* Gerar UFs ***********
replace ice=0 if ice==.

replace codigo_uf=26 if sigla=="PE" |uf=="PE"|UF=="Pernambuco"
replace codigo_uf=23 if sigla=="CE" |uf=="CE"|UF=="Ceará"|UF=="Ceara"
replace codigo_uf=35 if sigla=="SP" |uf=="SP"|UF=="São Paulo"|UF=="Sao Paulo"
replace codigo_uf=33 if sigla=="RJ" |uf=="RJ"|UF=="Rio de Janeiro"
replace codigo_uf=52 if sigla=="GO" |uf=="GO"|UF=="Goiás"|UF=="Goias"

***** Padronizar codigos de municipio ***

tostring codigo_municipio, gen(codigo_municipios) format(%20.0g) 
gen cod_aux1=substr(codigo_municipios,1,2) 
gen cod_aux2=substr(codigo_municipios,8,4)
gen cod_aux3=cod_aux1+cod_aux2

rename codigo_municipio codigo_municipio_enorme
rename cod_aux3 codigo_municipio
destring codigo_municipio, replace

merge m:1 codigo_municipio using "Dados ICE\cod_munic.dta"
drop if _merge==2
replace codigo_municipio_novo=ufmundv if codigo_municipio_novo==.

**** Dependencia Administrativa *****

qui tab dep, gen(d_dep)

**** Mais Educacaoo ***

gen mais_educ=0

foreach x of varlist mais_educacao_fund_2010- mais_educacao_x_2009 n_turmas_mais_educ_em_1- n_turmas_mais_educ_em_3 n_turmas_mais_educ_fund_5_8anos- n_turmas_mais_educ_fund_9_9anos n_turmas_mais_educ_em_inte_1- n_turmas_mais_educ_em_inte_ns{
replace mais_educ=1 if `x'>0&`x'!=.
}

**** Rigor do ICE ****
replace ice_rigor="Sem Apoio" if ice_rigor==""&ice==1

tab ice_rigor if ice==1, gen(d_rigor)


gen media_pb_9=(media_lp_prova_brasil_9+ media_mt_prova_brasil_9)/2

* Em 2010, a pergunta no enem sobre renda familiar foi diferente dos outros anos. Consertar

replace e_renda_familia_5_salarios=e_renda_familia_6_salarios if ano==2010

* Calcular numero de alunos por ciclo de ensino contemplado pelo programa

forvalues x=1(1)3{
replace n_alunos_em_`x'=0 if n_alunos_em_`x'==.
replace n_mulheres_em_`x'=0 if n_mulheres_em_`x'==.
replace n_brancos_em_`x'=0 if n_brancos_em_`x'==.
}

gen n_alunos_em=n_alunos_em_1+n_alunos_em_2 +n_alunos_em_3
replace n_alunos_em=0 if n_alunos_em==.
gen n_mulheres_em=n_mulheres_em_1+n_mulheres_em_2 +n_mulheres_em_3
replace n_mulheres_em=0 if n_mulheres_em==.
gen n_brancos_em=n_brancos_em_1+n_brancos_em_2 +n_brancos_em_3
replace n_brancos_em=0 if n_brancos_em==.

forvalues x=8(1)9{
forvalues i=5(1)9{
capture replace n_alunos_fund_`x'_`i'anos=0 if n_alunos_fund_`x'_`i'anos==.
capture replace n_mulheres_fund_`x'=0 if n_mulheres_fund_`x'==.
capture replace n_brancos_fund_`x'=0 if n_brancos_fund_`x'==.
}
}

gen n_alunos_ef=n_alunos_fund_5_8anos+ n_alunos_fund_6_8anos +n_alunos_fund_7_8anos +n_alunos_fund_8_8anos +n_alunos_fund_6_9anos +n_alunos_fund_7_9anos +n_alunos_fund_8_9anos +n_alunos_fund_9_9anos
replace n_alunos_ef=0 if n_alunos_ef==.
gen n_mulheres_ef=n_mulheres_fund_5_8anos+ n_mulheres_fund_6_8anos +n_mulheres_fund_7_8anos +n_mulheres_fund_8_8anos +n_mulheres_fund_6_9anos +n_mulheres_fund_7_9anos +n_mulheres_fund_8_9anos +n_mulheres_fund_9_9anos
replace n_mulheres_ef=0 if n_mulheres_ef==.
gen n_brancos_ef=n_brancos_fund_5_8anos+ n_brancos_fund_6_8anos +n_brancos_fund_7_8anos +n_brancos_fund_8_8anos +n_brancos_fund_6_9anos +n_brancos_fund_7_9anos +n_brancos_fund_8_9anos +n_brancos_fund_9_9anos
replace n_brancos_ef=0 if n_brancos_ef==.

foreach x in "1" "2" "3" "4" "ns"{
replace n_alunos_em_inte_`x'=0 if n_alunos_em_inte_`x'==.
replace n_mulheres_em_inte_`x'=0 if n_mulheres_em_inte_`x'==.
replace n_brancos_em_inte_`x'=0 if n_brancos_em_inte_`x'==.

}

gen n_alunos_ep=n_alunos_em_inte_1+ n_alunos_em_inte_2+ n_alunos_em_inte_3 +n_alunos_em_inte_4 +n_alunos_em_inte_ns
replace n_alunos_ep=0 if n_alunos_ep==.
gen n_mulheres_ep=n_mulheres_em_inte_1+ n_mulheres_em_inte_2+ n_mulheres_em_inte_3 +n_mulheres_em_inte_4 +n_mulheres_em_inte_ns
replace n_mulheres_ep=0 if n_mulheres_ep==.
gen n_brancos_ep=n_brancos_em_inte_1+ n_brancos_em_inte_2+ n_brancos_em_inte_3 +n_brancos_em_inte_4 +n_brancos_em_inte_ns
replace n_brancos_ep=0 if n_brancos_ep==.

gen n_alunos_ef_em=n_alunos_ef+n_alunos_em
gen n_alunos_em_ep=n_alunos_em+n_alunos_ep

gen n_alunos_ef_em_ep=n_alunos_ef+n_alunos_em+n_alunos_ep
gen n_mulheres_ef_em_ep=n_mulheres_ef+n_mulheres_em+n_mulheres_ep
gen n_brancos_ef_em_ep=n_brancos_ef+n_brancos_em+n_brancos_ep

*Gerar variavel de ano de entrana da escola no programa

gen d_ice=0

tab ano, gen(d_ano)

forvalues x=2004(1)2015{
replace d_ice=1 if ice_`x'==1 &ano==`x' 
}



tab codigo_uf, gen(d_uf)

********** Construcao da variavel de numero de alunos para regressao por estado*********
gen nalunos=.
replace nalunos=n_alunos_em if codigo_uf==26
replace nalunos=n_alunos_em if codigo_uf==52
replace nalunos=n_alunos_ef if codigo_uf==33
replace nalunos=n_alunos_ef_em if codigo_uf==35
replace nalunos=n_alunos_ep if codigo_uf==23
replace nalunos=. if nalunos==0

gen nmulheres=.
replace nmulheres=n_mulheres_em if codigo_uf==26
replace nmulheres=n_mulheres_em if codigo_uf==52
replace nmulheres=n_mulheres_ef if codigo_uf==33
replace nmulheres=n_mulheres_ef_em if codigo_uf==35
replace nmulheres=n_mulheres_ep if codigo_uf==23
replace nmulheres=. if nmulheres==0

gen nbrancos=.
replace nbrancos=n_brancos_em if codigo_uf==26
replace nbrancos=n_brancos_em if codigo_uf==52
replace nbrancos=n_brancos_ef if codigo_uf==33
replace nbrancos=n_brancos_ef_em if codigo_uf==35
replace nbrancos=n_brancos_ep if codigo_uf==23
replace nbrancos=. if nbrancos==0


******* Taxas de Participacao no ENEM e na Prova Brasil **********

**** ENEM ****
replace concluir_em_ano_enem=0 if concluir_em_ano_enem==.
*gen taxa_participacao_enem=taxa_participacao_enem/100
gen taxa_participacao_enem_aux=concluir_em_ano_enem/n_alunos_em_3
gen taxa_participacao_enem_aux2=concluir_em_ano_enem/(n_alunos_em_inte_3+n_alunos_em_3) if codigo_uf==23

gen taxa_participacao_enem=taxa_participacao_enem_aux
replace taxa_participacao_enem=taxa_participacao_enem_aux2 if codigo_uf==23

**** Prova Brasil ****
replace pb_n_partic=0 if pb_n_partic==.
replace pb_tx_partic=pb_tx_partic/100 if ano==2011
rename pb_tx_partic taxa_participacao_pb
gen taxa_participacao_pb_aux=pb_n_partic/(n_alunos_fund_8_8anos+n_alunos_fund_9_9anos) if ano==2009
replace taxa_participacao_pb=taxa_participacao_pb_aux if ano==2009





******************** 4.b. Padronizações de Nota
******* Padronizacao das notas e fluxos *****
*foreach gera para cada nota e fluxo uma nota padronizada
foreach x in "enem_nota_matematica" "enem_nota_ciencias" "enem_nota_humanas" "enem_nota_linguagens" "media_lp_prova_brasil_9" "media_mt_prova_brasil_9" "media_pb_9" "apr_ef" "apr_em" "rep_ef" "rep_em" "aba_ef" "aba_em" "dist_ef" "dist_em" {
egen `x'_std=std(`x')
}

*foreach gera para cada ano nota de redação um desvio padrão
foreach a in 2003 2004 2005 2006 2007 2008 {
egen enem_nota_redacao_std_aux_`a'=std(enem_nota_redacao) if ano==`a'
}
egen enem_nota_redacao_std=std(enem_nota_redacao) if ano>=2009

foreach a in 2003 2004 2005 2006 2007 2008 {
replace enem_nota_redacao_std=enem_nota_redacao_std_aux_`a' if ano==`a'
}


*foreach gera para cada ano a padronização da nota objetiva do enem 
foreach a in 2003 2004 2005 2006 2007 2008 {
egen enem_nota_objetiva_std_aux_`a'=std(enem_nota_objetiva) if ano==`a'
}
*gera mais uma nota objetiva como média das quatro cadernos, nos anos que houve quatro cadernos do enem
gen enem_nota_objetivab=(enem_nota_matematica +enem_nota_ciencias +enem_nota_humanas+enem_nota_linguagens)/4
egen enem_nota_objetivab_std=std(enem_nota_objetivab) if ano>=2009

*foreach: para cada ano assume paraa  padronização da nota objetiva do enem 
foreach a in 2003 2004 2005 2006 2007 2008 {
replace enem_nota_objetivab_std=enem_nota_objetiva_std_aux_`a' if ano==`a'
}



******* Padronizacao das notas por UF *****

foreach xx in 26 52 35 23 33 {
foreach x in "enem_nota_matematica" "enem_nota_ciencias" "enem_nota_humanas" "enem_nota_linguagens" "media_lp_prova_brasil_9" "media_mt_prova_brasil_9" "media_pb_9" "apr_ef" "apr_em" "rep_ef" "rep_em" "aba_ef" "aba_em" "dist_ef" "dist_em" {

capture egen `x'`xx'_std=std(`x') if codigo_uf==`xx' 
}
}

foreach xx in 26 52 35 23 33 {
foreach a in 2003 2004 2005 2006 2007 2008 {
capture egen enem_nota_redacao`xx'_std_aux_`a'=std(enem_nota_redacao) if ano==`a' & codigo_uf==`xx'
}
capture egen enem_nota_redacao`xx'_std=std(enem_nota_redacao) if ano>=2009 & codigo_uf==`xx'

foreach a in 2003 2004 2005 2006 2007 2008 {
replace enem_nota_redacao`xx'_std=enem_nota_redacao_std_aux_`a' if ano==`a' & codigo_uf==`xx'
}

foreach a in 2003 2004 2005 2006 2007 2008 {
capture egen enem_nota_objetiva`xx'_std_aux_`a'=std(enem_nota_objetiva) if ano==`a' & codigo_uf==`xx'
}

gen enem_nota_objetivab`xx'=(enem_nota_matematica +enem_nota_ciencias +enem_nota_humanas+enem_nota_linguagens)/4 if codigo_uf==`xx'
capture egen enem_nota_objetivab`xx'_std=std(enem_nota_objetivab) if ano>=2009 & codigo_uf==`xx'

foreach a in 2003 2004 2005 2006 2007 2008 {
replace enem_nota_objetivab`xx'_std=enem_nota_objetiva_std_aux_`a' if ano==`a' & codigo_uf==`xx'

}
}

save "Dados ICE\ice_clean.dta", replace

drop e_trabalhou_ou_procurou- e_ajuda_esc_profissao_muito mascara2003- s_exp_prof_escola_mais_3_9 ano_saeb n_turmas_em_1- p_profs_sup_em_3 n_profs_em- cod_aux2

save "Dados ICE\ice_clean.dta", replace

