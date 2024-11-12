/******************************  INEP  ******************************/
/*
indicadores do INEP para os seguintes estados
CE, GO, PE, RJ, SP, ES
e para os anos de 2007 a 2015
*/

/*-------------------------- distorção ----------------------------*/
******* 2007 a 2009 ********

clear all
set more off, permanently
set trace on
set excelxlsxlargefile on

*import excel "D:\Dropbox\microdados\Indicadores INEP\dist 2007.xls", sheet("NE") 

foreach i in "07" "08" "09" {

foreach x in "NE" "SE" "CO"{

*importando excel
import excel "D:\Dropbox\microdados\Indicadores INEP\dist 20`i'.xls", sheet("`x'") 

*excluindo as 9 primeiras linhas
drop if _n<10

*renomenado colunas
rename A ano
rename C uf
rename G codigo_escola

*distorção ef 5ª a 8ª série/ 6º ao 9º ano
rename T dist_ef

*distorção em
rename Z dist_em

*mantendo as variáveis desejadas
keep  uf ano codigo_escola dist*


save "D:\Dropbox\bases_dta\indicadores_inep\dist_20`i'`x'.dta", replace

clear
}

use "D:\Dropbox\bases_dta\indicadores_inep\dist_20`i'NE.dta", replace
append using "D:\Dropbox\bases_dta\indicadores_inep\dist_20`i'SE.dta", force
append using "D:\Dropbox\bases_dta\indicadores_inep\dist_20`i'CO.dta", force
save "D:\Dropbox\bases_dta\indicadores_inep\dist_20`i'_total.dta", replace
clear
}
******* 2010 ********
clear all
set more off, permanently
set trace on
set excelxlsxlargefile on

foreach x in "NE" "SE" "CO"{

import excel "D:\Dropbox\microdados\Indicadores INEP\dist 2010.xls", sheet("`x'") 

drop if _n<10

rename A ano
rename C uf
rename F codigo_escola

rename T dist_ef
rename Z dist_em

keep  uf ano codigo_escola dist*


save "D:\Dropbox\bases_dta\indicadores_inep\dist_2010`x'.dta", replace

clear
}

use "D:\Dropbox\bases_dta\indicadores_inep\dist_2010NE.dta", replace
append using "D:\Dropbox\bases_dta\indicadores_inep\dist_2010SE.dta", force
append using "D:\Dropbox\bases_dta\indicadores_inep\dist_2010CO.dta", force
save "D:\Dropbox\bases_dta\indicadores_inep\dist_2010_total.dta", replace
clear

******* 2011 ********
clear
clear all
set more off, permanently
set trace on
set excelxlsxlargefile on
foreach x in "NE1" "SE" "CO"{

import excel "D:\Dropbox\microdados\Indicadores INEP\dist 2011.xls", sheet("`x'") 

drop if _n<10

rename A ano
rename C uf
rename F codigo_escola

rename L dist_ef
rename V dist_em

keep  uf ano codigo_escola dist*


save "D:\Dropbox\bases_dta\indicadores_inep\dist_2011`x'.dta", replace

clear
}

use "D:\Dropbox\bases_dta\indicadores_inep\dist_2011NE1.dta", replace
append using "D:\Dropbox\bases_dta\indicadores_inep\dist_2011SE.dta", force
append using "D:\Dropbox\bases_dta\indicadores_inep\dist_2011CO.dta", force
save "D:\Dropbox\bases_dta\indicadores_inep\dist_2011_total.dta", replace
clear



******* 2012 a 2014 ********
clear
clear all
set more off, permanently
set trace on
set excelxlsxlargefile on

foreach i in "12" "13" "14" {

import excel "D:\Dropbox\microdados\Indicadores INEP\dist 20`i'.xlsx", sheet("ESC_20`i'")

drop if _n<10


rename A ano
rename C uf
rename F codigo_escola

rename L dist_ef
rename V dist_em

keep uf ano codigo_escola dist*

save "D:\Dropbox\bases_dta\indicadores_inep\dist_20`i'_total.dta", replace

clear

}

******* 2015 ********
clear
clear all
set more off, permanently
set trace on
*set excelxlsxlargefile on

import excel "D:\Dropbox\microdados\Indicadores INEP\dist 2015.xlsx", sheet("ESCOLAS")
drop if _n<10

rename A ano
rename D uf
rename G codigo_escola

*distorção ef 5ª a 8ª série/ 6º ao 9º ano (anos finais)
rename M dist_ef
rename W dist_em

keep uf ano codigo_escola dist*

save "D:\Dropbox\bases_dta\indicadores_inep\dist_2015_total.dta", replace

clear


***** Append
clear
clear all
set more off, permanently
set trace on
*juntadno as bases de distorção
use "D:\Dropbox\bases_dta\indicadores_inep\dist_2007_total.dta"
append using "D:\Dropbox\bases_dta\indicadores_inep\dist_2008_total.dta"
append using "D:\Dropbox\bases_dta\indicadores_inep\dist_2009_total.dta"
append using "D:\Dropbox\bases_dta\indicadores_inep\dist_2010_total.dta"
append using "D:\Dropbox\bases_dta\indicadores_inep\dist_2011_total.dta"
append using "D:\Dropbox\bases_dta\indicadores_inep\dist_2012_total.dta"
append using "D:\Dropbox\bases_dta\indicadores_inep\dist_2013_total.dta"
append using "D:\Dropbox\bases_dta\indicadores_inep\dist_2014_total.dta"
append using "D:\Dropbox\bases_dta\indicadores_inep\dist_2015_total.dta"
replace ano = "" in 1278080
*mantendo os estados 
keep if uf=="PE" | uf=="CE" | uf=="SP" | uf=="RJ" | uf=="GO" | uf=="ES"

*destring
destring ano, replace
destring codigo_escola, replace

* imputando "." (missing) no lugar de "--"
foreach x of varlist dist_ef dist_em {
replace `x'="." if `x'=="--"
}

* destring as variáveis de distorção
foreach x of varlist dist_ef dist_em {
destring `x', replace
}

* dropando as escolas sem código do inep
drop if codigo_escola==.
save "D:\Dropbox\bases_dta\indicadores_inep\dist_total_2007a2015.dta", replace

/*-------------------------- fluxo ----------------------------*/
clear
clear all
set more off, permanently
set trace on
set excelxlsxlargefile on
foreach i in /*"07"*/ "08" "09" "10"{

foreach x in "NE" "SE" "CO"{

import excel "D:\Dropbox\microdados\Indicadores INEP\rend 20`i'.xls", sheet("`x'") 

drop if _n<10


rename A ano
rename C uf
rename H codigo_escola

rename T apr_ef
rename AA apr_em

rename AL rep_ef
rename AS rep_em

rename BD aba_ef
rename BK aba_em

*ok

keep  uf ano codigo_escola apr* aba* rep*


save "D:\Dropbox\bases_dta\indicadores_inep\rend_20`i'`x'.dta", replace

clear
}

use "D:\Dropbox\bases_dta\indicadores_inep\rend_20`i'NE.dta", replace
append using "D:\Dropbox\bases_dta\indicadores_inep\rend_20`i'SE.dta", force
append using "D:\Dropbox\bases_dta\indicadores_inep\rend_20`i'CO.dta", force
save "D:\Dropbox\bases_dta\indicadores_inep\rend_20`i'_total.dta", replace
clear
}
******* 2011 ********
clear
clear all
set more off, permanently
set trace on
set excelxlsxlargefile on

foreach x in "NE" "SE" "CO"{

import excel "D:\Dropbox\microdados\Indicadores INEP\rend 2011.xls", sheet("`x'") 

drop if _n<10


rename A ano
rename C uf
rename H codigo_escola

rename L apr_ef
rename V apr_em

rename AD rep_ef
rename AN rep_em

rename AV aba_ef
rename BF aba_em

keep uf ano codigo_escola apr* aba* rep*


save "D:\Dropbox\bases_dta\indicadores_inep\rend_2011`x'.dta", replace

clear
}

use "D:\Dropbox\bases_dta\indicadores_inep\rend_2011NE.dta", replace
append using "D:\Dropbox\bases_dta\indicadores_inep\rend_2011SE.dta", force
append using "D:\Dropbox\bases_dta\indicadores_inep\rend_2011CO.dta", force
save "D:\Dropbox\bases_dta\indicadores_inep\rend_2011_total.dta", replace
clear


******* 2012 a 2014 ********
clear
clear all
set more off, permanently
set trace on
set excelxlsxlargefile on
foreach i in "12" "13" "14" {

import excel "D:\Dropbox\microdados\Indicadores INEP\rend 20`i'.xlsx", sheet("ESCOLAS")

drop if _n<10


rename A ano
rename B uf
rename C codigo_escola

rename D apr_ef
rename E apr_em

rename M rep_ef
rename W rep_em

rename AE aba_ef
rename AO aba_em


keep uf ano codigo_escola apr* aba* rep*


save "D:\Dropbox\bases_dta\indicadores_inep\rend_20`i'_total.dta", replace

clear

}
******* 2015 ********
clear
clear all
set more off, permanently
set trace on
set excelxlsxlargefile on
import excel "D:\Dropbox\microdados\Indicadores INEP\rend 2015.xlsx", sheet("ESCOLAS")

drop if _n<11


rename A ano
rename C uf
rename F codigo_escola

rename K apr_ef
rename V apr_em

rename AD rep_ef
rename AN rep_em

rename AV aba_ef
rename BF aba_em


keep uf ano codigo_escola apr* aba* rep*


save "D:\Dropbox\bases_dta\indicadores_inep\rend_2015_total.dta", replace

clear

use "D:\Dropbox\bases_dta\indicadores_inep\rend_2007_total.dta"
append using "D:\Dropbox\bases_dta\indicadores_inep\rend_2008_total.dta"
append using "D:\Dropbox\bases_dta\indicadores_inep\rend_2009_total.dta"
append using "D:\Dropbox\bases_dta\indicadores_inep\rend_2010_total.dta"
append using "D:\Dropbox\bases_dta\indicadores_inep\rend_2011_total.dta"
append using "D:\Dropbox\bases_dta\indicadores_inep\rend_2012_total.dta"
append using "D:\Dropbox\bases_dta\indicadores_inep\rend_2013_total.dta"
append using "D:\Dropbox\bases_dta\indicadores_inep\rend_2014_total.dta"
append using "D:\Dropbox\bases_dta\indicadores_inep\rend_2015_total.dta"
keep if uf=="PE" | uf=="CE" | uf=="SP" | uf=="RJ" | uf=="GO" | uf=="ES"
destring ano, replace
destring codigo_escola, replace

foreach x of varlist apr_ef apr_em rep_ef rep_em aba_ef aba_em {
replace `x'="." if `x'=="--"
}

foreach x of varlist apr_ef apr_em rep_ef rep_em aba_ef aba_em {
destring `x', replace
}

drop if codigo_escola==.
save "D:\Dropbox\bases_dta\indicadores_inep\rend_total_2007a2015.dta", replace

merge 1:1 codigo_escola ano using "D:\Dropbox\bases_dta\indicadores_inep\dist_total_2007a2015.dta"
drop uf
drop _m
save "D:\Dropbox\bases_dta\indicadores_inep\fluxo_2007a2015.dta", replace
save "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\indicadores_inep\fluxo_2007a2015.dta", replace
