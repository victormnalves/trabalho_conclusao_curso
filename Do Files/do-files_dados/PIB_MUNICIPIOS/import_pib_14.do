/**PIB por município per capita**/

capture log close
clear all
set more off, permanently

set excelxlsxlargefile on


*importando população por município
	* 2002 até 2007
clear all	
import excel "C:\Users\Leonardo.idea-PC\Dropbox\OneDrive\O\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\pib por município\2003 - 2007\base.xls", sheet ("BASE") firstrow 
*5564 municípios
keep ano cod_munic pop

save "C:\Users\Leonardo.idea-PC\Dropbox\OneDrive\O\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\pib por município\pop_2002_2007_14.dta", replace
	
	

	*2008
clear all

import excel "C:\Users\Leonardo.idea-PC\Dropbox\OneDrive\O\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\pib por município\estimativas população\POP2008_DOU.xls", sheet ("POP08DOU") 
drop if _n<6
*5567 municípios
rename E pop
destring pop, replace
drop A D


gen cod_munic = B+C
drop B C
gen ano = "2008"
keep  cod_munic pop ano 
drop if _n > _N-2
save "C:\Users\Leonardo.idea-PC\Dropbox\OneDrive\O\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\pib por município\pop_2008_14.dta", replace
	
	
	*2009
clear all
import excel "C:\Users\Leonardo.idea-PC\Dropbox\OneDrive\O\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\pib por município\2005 - 2009\base.xls", sheet ("BASE") firstrow 

keep ano cod_munic pop
keep if ano == "2009"

save "C:\Users\Leonardo.idea-PC\Dropbox\OneDrive\O\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\pib por município\pop_2009_14.dta", replace
	
	
	*2010 até 2013
clear all
import excel "C:\Users\Leonardo.idea-PC\Dropbox\OneDrive\O\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\pib por município\2010 - 2013\base.xls", sheet ("BASE") firstrow 
rename Anodereferência ano
rename CódigodoMunicípio cod_munic
rename PopulaçãoNºdehabitantes pop
keep ano cod_munic pop

save "C:\Users\Leonardo.idea-PC\Dropbox\OneDrive\O\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\pib por município\pop_2010_2013_14.dta", replace


	*2014
clear all
import excel "C:\Users\Leonardo.idea-PC\Dropbox\OneDrive\O\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\pib por município\estimativas população\estimativa_TCU_2014_20170614.xls", sheet ("Municípios") 
drop if _n<3

replace E = "10531" if D == "Jacareacanga"
replace E = "17256" if D == "Coronel João Sá"
destring E, gen(pop) force
drop A D


gen cod_munic = B+C
drop B C F
gen ano = "2014"
keep  cod_munic pop ano 
drop if _n > _N-6
save "C:\Users\Leonardo.idea-PC\Dropbox\OneDrive\O\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\pib por município\pop_2014_14.dta", replace


	*2015
clear all

import excel "C:\Users\Leonardo.idea-PC\Dropbox\OneDrive\O\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\pib por município\estimativas população\estimativa_TCU_2015_20170614.xls", sheet ("Municípios") 
drop if _n<3
*5570 municípios
replace E = "502748" if D == "Porto Velho"
replace E = "17098" if D == "Coronel João Sá"
replace E = "9677" if D == "Jacareacanga"
replace E = "60066" if D == "Euclides da Cunha"
replace E = "13178" if D == "Presidente Jânio Quadros"
replace E = "28655" if D == "Quijingue"
destring E, replace
rename E pop
destring pop, replace
rename D nome_municipio
drop A  F


gen cod_munic = B+C
drop B C
gen ano = "2015"
keep  cod_munic pop ano nome_municipio
drop if _n > _N-7
save "C:\Users\Leonardo.idea-PC\Dropbox\OneDrive\O\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\pib por município\pop_2015_14.dta", replace
keep cod_munic nome_municipio
save "C:\Users\Leonardo.idea-PC\Dropbox\OneDrive\O\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\pib por município\nome_municipios_14.dta", replace
*append 

cd "C:\Users\Leonardo.idea-PC\Dropbox\OneDrive\O\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\pib por município"
use "pop_2002_2007_14.dta", clear
append using "pop_2008_14.dta"
append using "pop_2009_14.dta" 
append using "pop_2010_2013_14.dta"

append using "pop_2014_14.dta"
append using "pop_2015_14.dta"
save "pop_2002_2015_14.dta", replace

use "C:\Users\Leonardo.idea-PC\Dropbox\OneDrive\O\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\pib por município\nome_municipios_14.dta", replace

merge 1:m cod_munic using "pop_2002_2015_14.dta"
drop _m
destring ano, replace
destring cod_munic, replace
save "pop_municipio_2002_2015_14.dta",replace

*importando base com pib por município
cd "C:\Users\Leonardo.idea-PC\Dropbox\OneDrive\O\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\pib por município"


import excel "tabela5938.xlsx", sheet(Tabela) clear
rename B cod_munic
destring cod_munic,replace
rename C nome_municipio 
rename D pib2003
rename E pib2004
rename F pib2005
rename G pib2006
rename H pib2007
rename I pib2008
rename J pib2009
rename K pib2010
rename L pib2011
rename M pib2012
rename N pib2013
rename O pib2014
rename P pib2015

drop if _n<6
drop if _n == _N
destring  pib2003 pib2004 pib2005 pib2006 pib2007 pib2008 pib2009 pib2010 pib2011 pib2012 , force replace


drop A

*reshaping wide to long (transformando em painel)

reshape long pib, i(cod_munic) j(ano)

save "pib_municipio_14.dta",replace
destring ano, replace
destring cod_munic, replace

*juntado com a base de população
merge 1:1 cod_munic ano using  "pop_municipio_2002_2015_14.dta"
*só a partir de 2003
drop if ano ==2002

drop _m
*gerando a variável pib per capita por município em mil reais
generate pib_capita_mil_reais = pib/pop 
*gerando a variável pib per capita por município em reais
generate pib_capita_reais = pib/pop *1000


save "pib_capita_municipio_2003_2015_14.dta", replace

cd "C:\Users\Leonardo.idea-PC\Dropbox\OneDrive\O\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\pib por município\"

import excel "IPCA\ipca_201807SerieHist.xls", sheet(ACUMULADA_ANO) firstrow clear
destring ano, replace
drop if ano == 2016 | ano ==2017 | ano ==.
*definindo 2003 como ano de referência

save "ipca_acumulada_ano_14.dta",replace

use "ipca_acumulada_ano_14.dta", replace

merge 1:m ano using "pib_capita_municipio_2003_2015_14.dta"
drop _m
sort cod_munic ano
rename inflaçãoacumuladaano ipca_acumulado_ano

*calculando pib per capita por municipio em reais valores de 2003
* pib per capita real aqui está sendo calculado da seguinte maneira:
* pib nominal do ano/ inflação acumulada de 2003 até o ano em questão

gen pib_capita_reais_real_2003 = pib_capita_reais / deflator_pib_base2003


*calculando pib per capita por município real a valores de 2015
* pib nominal do ano * inflação acumulada do ano até 2015
gen pib_capita_reais_real_2015 = pib_capita_reais / deflator_pib_base2015

*arrumando os nomes das cidades

replace nome_municipio = substr(nome_municipio, 1, strlen(nome_municipio) - 5)

drop E

save "pib_capita_municipio_2003_2015_1_14.dta",replace

*adicionando meso região
import excel "C:\Users\Leonardo.idea-PC\Dropbox\OneDrive\O\EESP_ECONOMIA_mestrado_acadêmico\Dissertação\ICE\dados_ICE\Análise_Leonardo\Bases\pib por município\2010 - 2013\base.xls", sheet(BASE) firstrow clear
rename CódigodoMunicípio cod_munic
destring cod_munic, replace
rename CódigodaMesorregião cod_meso
destring cod_meso, replace
rename Anodereferência ano 
destring ano, replace
keep if ano==2013
keep cod_munic cod_meso
save "meso/municipios_meso_14.dta",replace

use "meso/municipios_meso_14.dta", clear

merge 1:m cod_munic using "pib_capita_municipio_2003_2015_1_14.dta"
drop _merge
sort cod_munic ano
save "pib_capita_municipio_2003_2015_final_14.dta",replace
