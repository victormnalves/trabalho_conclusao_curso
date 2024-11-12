sysdir set PLUS \\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\ado
capture log close
clear all
set more off, permanently

global folderservidor "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"
log using "$folderservidor\\logfiles/counting.log", replace


use "$folderservidor\base_final_ice_2_14.dta", clear
/*gen ensino_medio=1 
replace ensino_medio = 0 if ice_segmento == "EFII" | ice_segmento == "EF FINAIS" 
tab ice_segmento ensino_medio
order ensino_medio, after(ensino_fundamental)
*/

*número de escolas novas por ano, por segmento
forvalues a=2003(1)2015{
di `a'
count if ano_ice == `a'
}
forvalues a=2003(1)2015{
di `a'
count if ano_ice == `a' & ensino_fundamental ==1

}

forvalues a=2003(1)2015{
di `a'
count if ano_ice == `a' & ensino_medio ==1

}


*número de escolas, total
forvalues a=2003(1)2015{
di `a'
count if ano_ice <= `a'
}
forvalues a=2003(1)2015{
di `a'
count if ano_ice <= `a' & ensino_fundamental ==1

}

forvalues a=2003(1)2015{
di `a'
count if ano_ice <= `a' & ensino_medio ==1

}
