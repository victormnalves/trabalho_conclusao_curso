/***************************M�scara Censo*************************************/
/*
de 2003 a 2006, as escolas est�o sem c�digo de escola
nos arquivos mascara censo (200`x').dta, h� o c�digo de escola para cada m�scara correspondente
*/
foreach x in "3" "4" "5" "6" {

use "F:\bases_dta\censo_escolar\200`x'\censo_escolar200`x'.dta"
merge 1:1 mascara using "F:\bases_dta\censo_escolar\m�scaras\mascara censo (200`x').dta"
save "F:\bases_dta\censo_escolar\200`x'\censo_escolar200`x'.dta", replace
}
