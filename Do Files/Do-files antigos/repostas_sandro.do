************************************************************************************************
******************************** RESULTADOS PAINEL PSCORE***************************************
************************************************************************************************

use "E:\CMICRO\_CHV\ICE\Dados ICE\ice_clean.dta", clear

******************************* EM *****************************************************
keep if n_alunos_em_ep>0
drop if codigo_uf==33

gen exc=0 if dep~=4 & (codigo_uf==23 | codigo_uf==26)
replace exc=1 if codigo_escola==23502983
replace exc=1 if codigo_escola==26071606
replace exc=1 if codigo_escola==26003066
replace exc=1 if codigo_escola==26086077
replace exc=1 if codigo_escola==26133920
replace exc=1 if codigo_escola==26033356
replace exc=1 if codigo_escola==26070880



set more off

mat coef=[.]
mat var=[.]
mat mu1=[.]
mat mu2=[.]
mat sd1=[.]
mat sd2=[.]
mat t=[.]
mat t2=[.]

mat B=[.,.,.,.,.]

 foreach x of varlist enem_nota_matematica enem_nota_ciencias enem_nota_humanas enem_nota_linguagens enem_nota_redacao enem_nota_objetivab apr_em rep_em aba_em dist_em { 
 display("`x'")

 sum `x' [aw=n_alunos_em_ep] if exc==0 
 mat mu1=[mu1 \ `r(mean)']
 mat sd1=[sd1 \ `r(sd)']
 
 sum `x' [aw=n_alunos_em_ep] if exc==1 
 mat mu2=[mu2 \ `r(mean)']
 mat sd2=[sd2 \ `r(sd)']
 
reg `x' exc [aw=n_alunos_em_ep]

mat coef=e(b)
mat varcov= e(V)
mat t2=coef[1,1]/sqrt(varcov[1,1])
mat t=[t \ t2]
mat drop coef varcov t2

}

clear

mat B=[mu1, mu2, sd1, sd2, t]


svmat B

*rename B1 p_valor
rename B1 media_n_selecao
rename B2 media_selecao
rename B3 sd_n_selecao
rename B4 sd_selecao
rename B5 t_test


gen flag =0
replace flag =1 if abs(t_test)>1.96 &t_test!=.

drop if _n==1

******************************* EM *********************************************
keep if n_alunos_em_ep>0
drop if codigo_uf==33

gen exc=0 if dep~=4 & (codigo_uf==23 | codigo_uf==26)
replace exc=1 if codigo_escola==23502983
replace exc=1 if codigo_escola==26071606
replace exc=1 if codigo_escola==26003066
replace exc=1 if codigo_escola==26086077
replace exc=1 if codigo_escola==26133920
replace exc=1 if codigo_escola==26033356
replace exc=1 if codigo_escola==26070880



set more off

mat coef=[.]
mat var=[.]
mat mu1=[.]
mat mu2=[.]
mat sd1=[.]
mat sd2=[.]
mat t=[.]
mat t2=[.]

mat B=[.,.,.,.,.]

 foreach x of varlist n_alunos_em_ep taxa_participacao_enem { 
 display("`x'")

 sum `x'  if exc==0 
 mat mu1=[mu1 \ `r(mean)']
 mat sd1=[sd1 \ `r(sd)']
 
 sum `x'  if exc==1 
 mat mu2=[mu2 \ `r(mean)']
 mat sd2=[sd2 \ `r(sd)']
 
reg `x' exc 

mat coef=e(b)
mat varcov= e(V)
mat t2=coef[1,1]/sqrt(varcov[1,1])
mat t=[t \ t2]
mat drop coef varcov t2

}

clear

mat B=[mu1, mu2, sd1, sd2, t]


svmat B

*rename B1 p_valor
rename B1 media_n_selecao
rename B2 media_selecao
rename B3 sd_n_selecao
rename B4 sd_selecao
rename B5 t_test


gen flag =0
replace flag =1 if abs(t_test)>1.96 &t_test!=.

drop if _n==1

********************************************************************************
use "E:\CMICRO\_CHV\ICE\Dados ICE\ice_clean.dta", clear

******************************* EM *********************************************
keep if n_alunos_em_ep>0
drop if codigo_uf==33

gen exc=0 if dep~=4 & (codigo_uf==23 | codigo_uf==26)
replace exc=1 if codigo_escola==23502983
replace exc=1 if codigo_escola==26071606
replace exc=1 if codigo_escola==26003066
replace exc=1 if codigo_escola==26086077
replace exc=1 if codigo_escola==26133920
replace exc=1 if codigo_escola==26033356
replace exc=1 if codigo_escola==26070880

foreach x of varlist enem_nota_objetivab rep_em aba_em dist_em { 
 
gen `x'2014m=`x' if ano==2014
replace `x'2014m=0 if `x'2014m==.
bysort codigo_escola: egen `x'2014=sum(`x'2014m) 


gen `x'2013m=`x' if ano==2013
replace `x'2013m=0 if `x'2013m==.
bysort codigo_escola: egen `x'2013=sum(`x'2013m) 

gen `x'1314=`x'2014-`x'2013
}

mat coef=[.]
mat var=[.]
mat mu1=[.]
mat mu2=[.]
mat sd1=[.]
mat sd2=[.]
mat t=[.]
mat t2=[.]

mat B=[.,.,.,.,.]

 foreach x of varlist enem_nota_objetivab1314 rep_em1314 aba_em1314 dist_em1314 { 
 display("`x'")

 sum `x' [aw=n_alunos_em_ep] if exc==0 
 mat mu1=[mu1 \ `r(mean)']
 mat sd1=[sd1 \ `r(sd)']
 
 sum `x' [aw=n_alunos_em_ep] if exc==1 
 mat mu2=[mu2 \ `r(mean)']
 mat sd2=[sd2 \ `r(sd)']
 
reg `x' exc [aw=n_alunos_em_ep] 

mat coef=e(b)
mat varcov= e(V)
mat t2=coef[1,1]/sqrt(varcov[1,1])
mat t=[t \ t2]
mat drop coef varcov t2

}

clear

mat B=[mu1, mu2, sd1, sd2, t]


svmat B

*rename B1 p_valor
rename B1 media_n_selecao
rename B2 media_selecao
rename B3 sd_n_selecao
rename B4 sd_selecao
rename B5 t_test


gen flag =0
replace flag =1 if abs(t_test)>1.96 &t_test!=.

drop if _n==1
************************************************************************************************
******************************** GERAL EM ***************************************
************************************************************************************************
use "E:\CMICRO\_CHV\ICE\Dados ICE\ice_clean.dta", clear

keep if n_alunos_em_ep>0
drop if codigo_uf==33


gen ice_inte=0
replace ice_inte=1 if integral==1 

gen d_ice_inte=d_ice*ice_inte
gen ice_inte2=ice*ice_inte

bysort codigo_municipio_novo ano: egen n_com_ice=sum(d_ice_inte)
gen m_tem_ice=0
replace m_tem_ice=1 if n_com_ice>0

bysort codigo_municipio_novo: egen n_com_ice2=sum(ice_inte2)
gen m_teve_ice=0
replace m_teve_ice=1 if n_com_ice2>0
drop ice
rename m_teve_ice ice

drop if d_ice==1
drop if dep==4
collapse (mean) ice codigo_uf taxa_participacao_enem enem_nota_matematica enem_nota_ciencias enem_nota_humanas enem_nota_linguagens enem_nota_redacao enem_nota_objetiva m_tem_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca internet n_alunos_em n_alunos_ef n_alunos_ep n_alunos_ef_em n_alunos_em_ep apr_em rep_em aba_em dist_em, by(codigo_municipio_novo ano)


iis codigo_municipio_novo
tis ano

keep if m_tem_ice==1 & codigo_uf==26

gen enem_nota_objetivab=(enem_nota_matematica +enem_nota_ciencias +enem_nota_humanas+enem_nota_linguagens)/4

foreach x of varlist enem_nota_objetivab rep_em aba_em dist_em { 

bysort ano: summ `x'
}


