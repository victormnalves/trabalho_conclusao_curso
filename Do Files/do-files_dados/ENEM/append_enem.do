/******************Append ENEM************/
cd "E:\bases_dta\enem\"


use "enem2003.dta", clear
append using "enem2004.dta"
append using "enem2005.dta"
append using "enem2006.dta"
append using "enem2007.dta"
append using "enem2008.dta"
append using "enem2009.dta"
append using "enem2010.dta"
append using "enem2011.dta"
append using "enem2012.dta"
append using "enem2013.dta"
append using "enem2014.dta"
append using "enem2015.dta"
drop _merge
save "enem_todos.dta", replace
save "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\enem\enem_todos.dta", replace
