 /*Vamos reproduzir as análises do ICE, usando as bases de dados presentes na pasta
do ICE. Nessa primeira etapa, será reproduzido a construção das bases de dados
*/

 
 ******************** 1. Base Original ***********************************
 ******************** b. fluxo ********************
 /*
Aqui, vamos modificar a base original, importando a base do excel para dta
a base original se chama Base de dados estudo 2016 v1.xlsx, renomenado as 
variáveis e criando as dummies necessárias
*/
 /*
 vamos preparar a base original para a análise em fluxo
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
a diferença com a base de notas está aqui: não há o forvalues
*/

/*renomenado ano em ano_ice*/
rename ano ano_ice


/*dummy de ensino integral*/
gen integral = 1
replace integral = 0 if ice_jornada == "Semi-integral"

*dropar escola com codigo_inep duplicado e errado (de qualquer maneira, o ano de entrada e 2015, entao a escola esta fora da analise)
drop if nome_escola == "LOURENCO FILHO" & codigo_escola == 35003669

* dropar escolas sem codigo (nao serao mergeadas)
drop if codigo_escola == .

save "C:\Users\Administrator\OneDrive\EESP - ECONOMIA - mestrado acadêmico\Dissertação\ICE\dados ICE\Análise Leonardo\base original ice_fluxo.dta", replace
