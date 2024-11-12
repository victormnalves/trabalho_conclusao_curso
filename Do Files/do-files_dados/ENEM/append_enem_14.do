/******************Append ENEM************/
cd "\\tsclient\E\\bases_dta\enem\"


use "enem2003_14.dta", clear
append using "enem2004_14.dta"
append using "enem2005_14.dta"
append using "enem2006_14.dta"
append using "enem2007_14.dta"
append using "enem2008_14.dta"
append using "enem2009_14.dta"
append using "enem2010_14.dta"
append using "enem2011_14.dta"
append using "enem2012_14.dta"
append using "enem2013_14.dta"
append using "enem2014_14.dta"
append using "enem2015_14.dta"
drop _merge
save "enem_todos_14.dta", replace
save "C:\Users\Leonardo.idea-PC\OneDrive\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\enem\enem_todos_14.dta", replace
