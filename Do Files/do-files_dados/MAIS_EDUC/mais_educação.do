/*-------- MAIS EDUCA��O --------*/
*pegando as escolas que participaram do mais educa��o
clear all
set more off
set trace on

global user "`:environment USERPROFILE'"
*global dropbox "$user/Dropbox"
global dropboxA "$user/dropbox gmail/Dropbox"
global onedrive "$user/OneDrive"
clear



*Mais educa��o no ensino fundamental em 2010
clear
import excel "E:\Mais Educa��o\Integral Fundamental 2010.xlsx", sheet("Detalhado - PAGAS") firstrow clear
gen mais_educacao_fund_2010=1
rename CODIGOESCOLA codigo_escola
keep mais_educacao_fund_2010 codigo_escola
save "E:\bases_dta\mais_educa��o\mais_educacao_1.dta", replace

*mais educa��o no ensino m�dio em 2009
clear
import excel "E:\Mais Educa��o\Integral m�dio 2009.xlsx", sheet("Detalhado - PAGAS") firstrow clear
gen mais_educacao_med_2009=1
rename CODIGOESCOLA codigo_escola
keep mais_educacao_med_2009 codigo_escola
save "E:\bases_dta\mais_educa��o\mais_educacao_2.dta", replace

*mais educa��o no ensino m�dio em 2009
clear
import excel "E:\Mais Educa��o\Integral M�dio 2010.xlsx", sheet("Detalhado - PAGAS") firstrow clear
gen mais_educacao_med_2010=1
rename CODIGOESCOLA codigo_escola
keep mais_educacao_med_2010 codigo_escola
save "E:\bases_dta\mais_educa��o\mais_educacao_3.dta", replace

*ensino x: n�o sei se � fund ou m�dio. parece ser integral completo (fund e m�dio)
*mais educa��o no ensino x em 2012
clear
import excel "E:\Mais Educa��o\PDDE Integral 2� Parcela 2012 paga em 2013.xlsx", sheet("Detalhado - PAGAS") firstrow clear
gen mais_educacao_x_2012=1
rename CODIGOESCOLA codigo_escola
keep mais_educacao_x_2012 codigo_escola
save "E:\bases_dta\mais_educa��o\mais_educacao_4.dta", replace

*mais educa��o no ensino x em 2008
clear
import excel "E:\Mais Educa��o\PDDE Integral 2008.xlsx", sheet("Detalhado - PAGAS") firstrow clear
gen mais_educacao_x_2008=1
rename CODIGOESCOLA codigo_escola
keep mais_educacao_x_2008 codigo_escola
save "E:\bases_dta\mais_educa��o\mais_educacao_5.dta", replace

*mais educa��o no ensino x em 2014
clear
import excel "E:\Mais Educa��o\PDDE Integral Complemento 1� Parcela 2014.xlsx", sheet("Detalhado - PAGAS") firstrow clear
gen mais_educacao_x_2014=1
rename CODIGOESCOLA codigo_escola
keep mais_educacao_x_2014 codigo_escola
save "E:\bases_dta\mais_educa��o\\mais_educacao_6.dta", replace

*mais educa��o no ensino fundamental em 2013
clear
import excel "E:\Mais Educa��o\PDDE Integral Fundamental  2013.xlsx", sheet("Detalhado - PAGAS") firstrow clear
gen mais_educacao_fund_2013=1
rename CODIGOESCOLA codigo_escola
keep mais_educacao_fund_2013 codigo_escola
save "E:\bases_dta\mais_educa��o\\mais_educacao_7.dta", replace

*mais educa��o no ensino fundamental em 2014

clear
import excel "E:\Mais Educa��o\PDDE Integral Fundamental  2014.xlsx", sheet("Detalhado - PAGAS") firstrow clear
gen mais_educacao_fund_2014=1
rename CODIGOESCOLA codigo_escola
keep mais_educacao_fund_2014 codigo_escola
save "E:\bases_dta\mais_educa��o\mais_educacao_8.dta", replace

*mais educa��o no ensino fundamental em 2013
clear
import excel "E:\Mais Educa��o\PDDE Integral Fundamental 1� Parcela 2014.xlsx", sheet("Detalhado - PAGAS") firstrow clear
gen mais_educacao_fund_2014=1
rename CODIGOESCOLA codigo_escola
keep mais_educacao_fund_2014 codigo_escola
save "E:\bases_dta\mais_educa��o\\mais_educacao_9.dta", replace

*mais educa��o no ensino fundamental em 2009
clear
import excel "E:\Mais Educa��o\PDDE Integral Fundamental 2009.xlsx", sheet("Detalhado - PAGAS") firstrow clear
gen mais_educacao_fund_2009=1
rename CODIGOESCOLA codigo_escola
keep mais_educacao_fund_2009 codigo_escola
save "E:\bases_dta\mais_educa��o\mais_educacao_10.dta", replace

*mais educa��o no ensino fundamental em 2011
clear
import excel "E:\Mais Educa��o\PDDE Integral Fundamental 2011.xlsx", sheet("Detalhado - PAGAS") firstrow clear
gen mais_educacao_fund_2011=1
rename CODIGOESCOLA codigo_escola
keep mais_educacao_fund_2011 codigo_escola
save "E:\bases_dta\mais_educa��o\mais_educacao_11.dta", replace

*mais educa��o no ensino fundamental em 2012
clear
import excel "E:\Mais Educa��o\PDDE Integral Fundamental 2012.xlsx", sheet("Detalhado - PAGAS") firstrow clear
gen mais_educacao_fund_2012=1
rename CODIGOESCOLA codigo_escola
keep mais_educacao_fund_2012 codigo_escola
save "E:\bases_dta\mais_educa��o\mais_educacao_12.dta", replace

*mais educa��o no ensino fundamental em 2009
clear
import excel "E:\Mais Educa��o\PDDE Integral Fundamental Complemento 2009.xlsx", sheet("Detalhado - PAGAS") firstrow clear
gen mais_educacao_fund_2009=1
rename CODIGOESCOLA codigo_escola
keep mais_educacao_fund_2009 codigo_escola
save "E:\bases_dta\mais_educa��o\mais_educacao_13.dta", replace

*mais educa��o no ensino m�dio em 2011
clear
import excel "E:\Mais Educa��o\PDDE Integral M�dio 2011.xlsx", sheet("Detalhado - PAGAS") firstrow clear
gen mais_educacao_med_2011=1
rename CODIGOESCOLA codigo_escola
keep mais_educacao_med_2011 codigo_escola
save "E:\bases_dta\mais_educa��o\mais_educacao_14.dta", replace

*mais educal�ao no ensino x em 2008
clear
import excel "E:\Mais Educa��o\PDDE Integral Suplemento 2008.xlsx", sheet("Detalhado - PAGAS") firstrow clear
gen mais_educacao_x_2008=1
rename CODIGOESCOLA codigo_escola
keep mais_educacao_x_2008 codigo_escola
save "E:\bases_dta\mais_educa��o\mais_educacao_15.dta", replace

*mais educa��o no ensino x em 2009
clear
import excel "E:\Mais Educa��o\PDDE Integral_ Cobertura de Quadras 2009.xlsx", sheet("Detalhado - PAGAS") firstrow clear
gen mais_educacao_x_2009=1
rename CODIGOESCOLA codigo_escola
keep mais_educacao_x_2009 codigo_escola
save "E:\bases_dta\mais_educa��o\mais_educacao_16.dta", replace

*mais educa��o no ensino x em 2009
clear
import excel "E:\Mais Educa��o\PDDE Integral_Amplia��o de Quadras 2009.xlsx", sheet("Detalhado - PAGAS") firstrow clear
gen mais_educacao_x_2009=1
rename CODIGOESCOLA codigo_escola
keep mais_educacao_x_2009 codigo_escola
save "E:\bases_dta\mais_educa��o\mais_educacao_17.dta", replace

*mais educa��o no ensino x em 2009
clear
import excel "E:\Mais Educa��o\PDDE Integral_Reforma de Quadras 2009.xlsx", sheet("Detalhado - PAGAS") firstrow clear
gen mais_educacao_x_2009=1
rename CODIGOESCOLA codigo_escola
keep mais_educacao_x_2009 codigo_escola
save "E:\bases_dta\mais_educa��o\mais_educacao_18.dta", replace

* Merge*
use "E:\bases_dta\mais_educa��o\mais_educacao_1.dta"
merge 1:1 codigo_escola using "E:\bases_dta\mais_educa��o\mais_educacao_2.dta"
drop _m
merge 1:1 codigo_escola using "E:\bases_dta\mais_educa��o\mais_educacao_3.dta"
drop _m
merge 1:1 codigo_escola using "E:\bases_dta\mais_educa��o\mais_educacao_4.dta"
drop _m
merge 1:1 codigo_escola using "E:\bases_dta\mais_educa��o\mais_educacao_5.dta"
drop _m
merge 1:1 codigo_escola using "E:\bases_dta\mais_educa��o\mais_educacao_6.dta"
drop _m
merge 1:1 codigo_escola using "E:\bases_dta\mais_educa��o\mais_educacao_7.dta"
drop _m
merge 1:1 codigo_escola using "E:\bases_dta\mais_educa��o\mais_educacao_8.dta"
drop _m
merge 1:1 codigo_escola using "E:\bases_dta\mais_educa��o\mais_educacao_9.dta"
drop _m
merge 1:1 codigo_escola using "E:\bases_dta\mais_educa��o\mais_educacao_10.dta"
drop _m
merge 1:1 codigo_escola using "E:\bases_dta\mais_educa��o\mais_educacao_11.dta"
drop _m
merge 1:1 codigo_escola using "E:\bases_dta\mais_educa��o\mais_educacao_12.dta"
drop _m
merge 1:1 codigo_escola using "E:\bases_dta\mais_educa��o\mais_educacao_13.dta"
drop _m
merge 1:1 codigo_escola using "E:\bases_dta\mais_educa��o\mais_educacao_14.dta"
drop _m
merge 1:1 codigo_escola using "E:\bases_dta\mais_educa��o\mais_educacao_15.dta"
drop _m
merge 1:1 codigo_escola using "E:\bases_dta\mais_educa��o\mais_educacao_16.dta"
drop _m
merge 1:1 codigo_escola using "E:\bases_dta\mais_educa��o\mais_educacao_17.dta"
drop _m
merge 1:1 codigo_escola using "E:\bases_dta\mais_educa��o\mais_educacao_18.dta"
drop _m
destring codigo_escola, replace
save "E:\bases_dta\mais_educa��o\mais_educacao_todos.dta", replace
save "$onedrive\EESP_ECONOMIA_mestrado_acad�mico\Disserta��o\ICE\dados_ICE\An�lise_Leonardo\Bases\mais_educa��o\mais_educacao_todos.dta", replace



