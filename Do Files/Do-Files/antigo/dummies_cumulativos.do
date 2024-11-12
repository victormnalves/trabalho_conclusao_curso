/*					Dummies para resutados cumulativos						*/

*gerando dummies que assumem valores em relação ao ano de entrada 	



gen tempo=.
replace tempo=0 if ano==ano_ice-1
replace tempo=1 if ano==ano_ice
replace tempo=2 if ano==ano_ice+1
replace tempo=3 if ano==ano_ice+2 
replace tempo=4 if ano==ano_ice+3
replace tempo=5 if ano==ano_ice+4
replace tempo=6 if ano==ano_ice+5
replace tempo=7 if ano==ano_ice+6 
replace tempo=8 if ano==ano_ice+7
replace tempo=9 if ano==ano_ice+8
replace tempo=10 if ano==ano_ice+9
replace tempo=11 if ano==ano_ice+10
replace tempo=12 if ano==ano_ice+11

iis codigo_escol
tis tempo

tab tempo, gen(d_tempo)

gen d_ice1=d_ice*d_tempo2
gen d_ice2=d_ice*d_tempo3
gen d_ice3=d_ice*d_tempo4
gen d_ice4=d_ice*d_tempo5
gen d_ice5=d_ice*d_tempo6
gen d_ice6=d_ice*d_tempo7
gen d_ice7=d_ice*d_tempo8
gen d_ice8=d_ice*d_tempo9
gen d_ice9=d_ice*d_tempo10
