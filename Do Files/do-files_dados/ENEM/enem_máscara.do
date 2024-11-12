/***************************M�scara ENEM*************************************/

/*
de 2003 a 2006, as escolas est�o sem c�digo de escola
nos arquivos mascara censo (200`x').dta, h� o c�digo de escola para cada m�scara correspondente
*/

foreach x in "3" "4" "5" "6" {

use "E:\bases_dta\enem\enem200`x'.dta"
merge 1:1 mascara using "E:\bases_dta\censo_escolar\m�scaras\mascara censo (200`x').dta"
drop if _merge==2
save "E:\bases_dta\enem\enem200`x'.dta", replace
}
