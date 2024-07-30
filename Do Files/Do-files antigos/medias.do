use "E:\CMICRO\_CHV\ICE\Dados ICE\ice_clean.dta", clear

* Painel
iis codigo_escola
tis ano

sort codigo_escola ano
*bysort codigo_escola : gen n_obs=_n
*bysort codigo_escola : egen max_n_obs=max(n_obs)

foreach x in "enem_nota_matematica" "enem_nota_ciencias" "enem_nota_humanas" "enem_nota_linguagens" "enem_nota_redacao" "enem_nota_objetivab" "media_lp_prova_brasil_9" "media_mt_prova_brasil_9"{

capture egen `x'_std=std(`x')

bysort codigo_escola : gen `x'diff=`x'_std[_n]-`x'_std[_n-1]

bysort codigo_escola : egen `x'diff_mean=mean(`x'diff) 
}


************ ResultadosPS (sempre especificação PSCORE e controle escola2) *******

* escolas públicas
tabstat enem_nota_matematicadiff_mean enem_nota_cienciasdiff_mean enem_nota_humanasdiff_mean enem_nota_linguagensdiff_mean enem_nota_redacaodiff_mean enem_nota_objetivabdiff_mean [aw=n_alunos_ef_em_ep] if dep!=4 & ice==0&ano==2013, save
mat a=r(StatTotal)

matrix define resultados_pub=a
matrix drop a


* públicas e privadas
tabstat enem_nota_matematicadiff_mean enem_nota_cienciasdiff_mean enem_nota_humanasdiff_mean enem_nota_linguagensdiff_mean enem_nota_redacaodiff_mean enem_nota_objetivabdiff_mean [aw=n_alunos_ef_em_ep] if ice==0&ano==2013, save
mat l=r(StatTotal)

matrix define resultados_geral=l
matrix drop l

* escolas privadas
tabstat enem_nota_matematicadiff_mean enem_nota_cienciasdiff_mean enem_nota_humanasdiff_mean enem_nota_linguagensdiff_mean enem_nota_redacaodiff_mean enem_nota_objetivabdiff_mean [aw=n_alunos_ef_em_ep] if dep==4&ice==0&ano==2013, save
mat m=r(StatTotal)

matrix define resultados_priv=m
matrix drop m

matrix list resultados_pub


matrix list resultados_geral
matrix list resultados_priv



******************************************* Por estado (EM) ******************************************

use "E:\CMICRO\_CHV\ICE\Dados ICE\ice_clean.dta", clear

* Painel
iis codigo_escola
tis ano
sort codigo_escola ano

foreach x in "enem_nota_matematica" "enem_nota_ciencias" "enem_nota_humanas" "enem_nota_linguagens" "enem_nota_redacao" "enem_nota_objetivab" {
foreach xx in 26 52 35 23 {

capture egen `x'`xx'_std=std(`x') if codigo_uf==`xx'


bysort codigo_escola : gen `x'`xx'diff=`x'`xx'_std[_n]-`x'`xx'_std[_n-1]

bysort codigo_escola : egen `x'`xx'diff_mean=mean(`x'`xx'diff)

}
}

* PE

tabstat enem_nota_matematica26diff_mean enem_nota_ciencias26diff_mean enem_nota_humanas26diff_mean enem_nota_linguagens26diff_mean enem_nota_redacao26diff_mean enem_nota_objetivab26diff_mean [aw=n_alunos_ef_em_ep] if dep!=4  & codigo_uf==26 & ice==0&ano==2013, save
mat d=r(StatTotal)

matrix define resultados_pe=d
matrix drop d

* CE

tabstat enem_nota_matematica23diff_mean enem_nota_ciencias23diff_mean enem_nota_humanas23diff_mean enem_nota_linguagens23diff_mean enem_nota_redacao23diff_mean enem_nota_objetivab23diff_mean [aw=n_alunos_ef_em_ep] if dep!=4  & codigo_uf==23 & ice==0&ano==2013, save
mat e=r(StatTotal)

matrix define resultados_ce=e
matrix drop e

* GO

tabstat enem_nota_matematica52diff_mean enem_nota_ciencias52diff_mean enem_nota_humanas52diff_mean enem_nota_linguagens52diff_mean enem_nota_redacao52diff_mean enem_nota_objetivab52diff_mean [aw=n_alunos_ef_em_ep] if dep!=4  & codigo_uf==52 & ice==0&ano==2013, save
mat f=r(StatTotal)

matrix define resultados_go=f
matrix drop f

* SP 

tabstat enem_nota_matematica35diff_mean enem_nota_ciencias35diff_mean enem_nota_humanas35diff_mean enem_nota_linguagens35diff_mean enem_nota_redacao35diff_mean enem_nota_objetivab35diff_mean [aw=n_alunos_ef_em_ep] if dep!=4  & codigo_uf==35 & ice==0&ano==2013, save
mat g=r(StatTotal)

matrix define resultados_sp_em=g
matrix drop g

matrix list resultados_pe
matrix list resultados_ce
matrix list resultados_go
matrix list resultados_sp_em

**************************************** Por estado (EF) ***************************************************


use "E:\CMICRO\_CHV\ICE\Dados ICE\ice_clean.dta", clear

keep if codigo_uf==33|codigo_uf==35

keep if ano==2011|ano==2013
sort codigo_escola ano
*Regressões OLS****
foreach x in "media_lp_prova_brasil_9" "media_mt_prova_brasil_9"{
foreach xx in 33 35{

capture egen `x'`xx'_std=std(`x') if codigo_uf==`xx' 
bysort codigo_escola : gen `x'`xx'diff=`x'`xx'_std[_n]-`x'`xx'_std[_n-1]

bysort codigo_escola : egen `x'`xx'dm=mean(`x'`xx'diff)

}
}

* RJ 

tabstat media_lp_prova_brasil_933dm media_mt_prova_brasil_933dm [aw=n_alunos_ef_em_ep] if dep!=4  & codigo_uf==33 & ice==0&ano==2013, save
mat h=r(StatTotal)

matrix define resultados_rj_ef=h
matrix drop h


* SP

tabstat media_lp_prova_brasil_935dm media_mt_prova_brasil_935dm [aw=n_alunos_ef_em_ep] if dep!=4  & codigo_uf==35 & ice==0&ano==2013, save
mat i=r(StatTotal)

matrix define resultados_sp_ef=i
matrix drop i

matrix list resultados_sp_ef
matrix list resultados_rj_ef

*************************************** Spillover ***************************************************
use "E:\CMICRO\_CHV\ICE\Dados ICE\ice_clean.dta", clear

bysort codigo_municipio_novo ano: egen n_com_ice=sum(d_ice)
gen m_tem_ice=0
replace m_tem_ice=1 if n_com_ice>0

bysort codigo_municipio_novo: egen n_com_ice2=sum(ice)
gen m_teve_ice=0
replace m_teve_ice=1 if n_com_ice2>0
drop ice
rename m_teve_ice ice

drop if d_ice==1
drop if dep==4
collapse (mean) ice codigo_uf enem_nota_matematica enem_nota_ciencias enem_nota_humanas enem_nota_linguagens enem_nota_redacao enem_nota_objetivab m_tem_ice d_ano* e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios e_casa_propria n_alunos_ef_em_ep n_mulheres_ef_em_ep n_brancos_ef_em_ep/*
*/ rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca internet n_alunos_em n_alunos_ef n_alunos_ep n_alunos_ef_em , by(codigo_municipio_novo ano)


iis codigo_municipio_novo
tis ano
sort codigo_municipio_novo ano
foreach x in "enem_nota_matematica" "enem_nota_ciencias" "enem_nota_humanas" "enem_nota_linguagens" "enem_nota_redacao" "enem_nota_objetivab" {


capture egen `x'_std=std(`x')

bysort codigo_municipio_novo : gen `x'diff=`x'_std[_n]-`x'_std[_n-1]

bysort codigo_municipio_novo : egen `x'diff_mean=mean(`x'diff)

}

*spillover

tabstat enem_nota_matematicadiff_mean enem_nota_cienciasdiff_mean enem_nota_humanasdiff_mean enem_nota_linguagensdiff_mean enem_nota_redacaodiff_mean enem_nota_objetivabdiff_mean [aw=n_alunos_ef_em_ep] if m_tem_ice==0&ano==2013, save
mat k=r(StatTotal)

matrix define spillover=k
matrix drop k

matrix list spillover
