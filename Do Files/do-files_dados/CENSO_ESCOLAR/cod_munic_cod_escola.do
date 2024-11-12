
sysdir set PLUS \\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\ado
capture log close
clear all
set more off, permanently
set trace on
global folderservidor "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"



use "$folderservidor\censo_escolar\censo_escolar_escolas_2007.dta", clear

capture keep  pk_cod_entidade fk_cod_municipio no_entidade
capture rename pk_cod_entidade codigo_escola
capture rename fk_cod_municipio codigo_municipio
save "$folderservidor\censo_escolar\cod_munic_cod_escola_2007.dta", replace

use "$folderservidor\censo_escolar\censo_escolar_escolas_2008.dta", clear
capture keep  pk_cod_entidade fk_cod_municipio no_entidade
capture rename pk_cod_entidade codigo_escola
capture rename fk_cod_municipio codigo_municipio
save "$folderservidor\censo_escolar\cod_munic_cod_escola_2008.dta", replace


use "$folderservidor\censo_escolar\censo_escolar_escolas_2009.dta", clear
capture keep  pk_cod_entidade fk_cod_municipio no_entidade
capture rename pk_cod_entidade codigo_escola
capture rename fk_cod_municipio codigo_municipio
save "$folderservidor\censo_escolar\cod_munic_cod_escola_2009.dta", replace

use "$folderservidor\censo_escolar\censo_escolar_escolas_2010.dta", clear

capture keep  pk_cod_entidade fk_cod_municipio no_entidade
capture rename pk_cod_entidade codigo_escola
capture rename fk_cod_municipio codigo_municipio
save "$folderservidor\censo_escolar\cod_munic_cod_escola_2010.dta", replace

use "$folderservidor\censo_escolar\censo_escolar_escolas_2011.dta", clear

capture keep  pk_cod_entidade fk_cod_municipio no_entidade
capture rename pk_cod_entidade codigo_escola
capture rename fk_cod_municipio codigo_municipio
save "$folderservidor\censo_escolar\cod_munic_cod_escola_2011.dta", replace

use "$folderservidor\censo_escolar\censo_escolar_escolas_2012.dta", clear

capture keep  pk_cod_entidade fk_cod_municipio no_entidade
capture rename pk_cod_entidade codigo_escola
capture rename fk_cod_municipio codigo_municipio
save "$folderservidor\censo_escolar\cod_munic_cod_escola_2012.dta", replace

use "$folderservidor\censo_escolar\censo_escolar_escolas_2013.dta", clear
capture keep  pk_cod_entidade fk_cod_municipio no_entidade
capture rename pk_cod_entidade codigo_escola
capture rename fk_cod_municipio codigo_municipio
save "$folderservidor\censo_escolar\cod_munic_cod_escola_2013.dta", replace


use "$folderservidor\censo_escolar\censo_escolar_escolas_2014.dta", clear

capture keep  pk_cod_entidade fk_cod_municipio no_entidade
capture rename pk_cod_entidade codigo_escola
capture rename fk_cod_municipio codigo_municipio
save "$folderservidor\censo_escolar\cod_munic_cod_escola_2014.dta", replace

use "$folderservidor\censo_escolar\censo_escolar_escolas_2015.dta", clear

capture keep co_entidade no_entidade co_municipio
capture rename co_entidade codigo_escola
capture rename co_municipio codigo_municipio
save "$folderservidor\censo_escolar\cod_munic_cod_escola_2015.dta", replace



append using "$folderservidor\censo_escolar\cod_munic_cod_escola_2014.dta"
append using "$folderservidor\censo_escolar\cod_munic_cod_escola_2013.dta"
append using "$folderservidor\censo_escolar\cod_munic_cod_escola_2012.dta"
append using "$folderservidor\censo_escolar\cod_munic_cod_escola_2011.dta"
append using "$folderservidor\censo_escolar\cod_munic_cod_escola_2010.dta"
append using "$folderservidor\censo_escolar\cod_munic_cod_escola_2009.dta"
append using "$folderservidor\censo_escolar\cod_munic_cod_escola_2008.dta"
append using "$folderservidor\censo_escolar\cod_munic_cod_escola_2007.dta"

duplicates drop codigo_escola, force
save "$folderservidor\censo_escolar\cod_munic_cod_escola.dta",replace

