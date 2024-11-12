/***************************Máscara Censo*************************************/
/*
de 2003 a 2006, as escolas estão sem código de escola
nos arquivos mascara censo (200`x').dta, há o código de escola para cada máscara correspondente
*/
foreach x in "3" "4" "5" "6" {

use "F:\bases_dta\censo_escolar\200`x'\censo_escolar200`x'.dta"
merge 1:1 mascara using "F:\bases_dta\censo_escolar\máscaras\mascara censo (200`x').dta"
save "F:\bases_dta\censo_escolar\200`x'\censo_escolar200`x'.dta", replace
}
