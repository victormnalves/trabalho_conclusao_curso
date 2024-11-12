/**************************Append censo escolar******************************/



/*------------------- separando 2003 a 2006 em UFs---------------------*/
/*
note que as bases do cesno de 2003 a 2006 não estão discriminadas por uf.
portanto, vamos separar esses censos em estados

*/


clear all
set trace on
set more off, permanently
cd "F:\bases_dta\censo_escolar\"
use "F:\bases_dta\censo_escolar\\2003\censo_escolar2003.dta", clear
foreach i in "03" "04" "05" "06"{
foreach x in "GO" "ES" "SP" "RJ" "CE" "PE"{

use "20`i'\censo_escolar20`i'.dta", clear
keep if sigla == "`x'"
save "20`i'\censo_escolar20`i'_`x'.dta", replace

}
}


foreach x in "GO" "ES" "SP" "RJ" "CE" "PE"{
set trace on
cd "F:\bases_dta\censo_escolar\"
use "2003\censo_escolar2003_`x'.dta", clear
append using "2004\censo_escolar2004_`x'.dta"
append using "2005\censo_escolar2005_`x'.dta"
append using "2006\censo_escolar2006_`x'.dta"



replace dependencia_administrativa="1" if dependencia_administrativa=="Federal"
replace dependencia_administrativa="2" if dependencia_administrativa=="Estadual"
replace dependencia_administrativa="3" if dependencia_administrativa=="Municipal"
replace dependencia_administrativa="4" if dependencia_administrativa=="Particular"

destring dependencia_administrativa, replace
append using "2007\censo_escolar2007_`x'.dta"
append using "2008\censo_escolar2008_`x'.dta"
append using "2009\censo_escolar2009_`x'.dta"
append using "2010\censo_escolar2010_`x'.dta"
append using "2011\censo_escolar2011_`x'.dta"
append using "2012\censo_escolar2012_`x'.dta"
append using "2013\censo_escolar2013_`x'.dta"
append using "2014\censo_escolar2014_`x'.dta"
append using "2015\censo_escolar2015_`x'.dta"
format codigo_escola %16.0f
drop VEM4*

save "censo_escolar_`x'.dta", replace
save "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\censo_escolar\censo_escolar_`x'.dta", replace
}
