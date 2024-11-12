*******************************************************************************
/*							ENSINO MÉDIO SPILLOVER							*/
*******************************************************************************

/*
vamos calcular o efeito no programa na nota média da cidade, excluindo as
escolas que receberam o programa
*/

sysdir set PLUS \\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\ado

capture log close
clear all
set more off, permanently

global user "`:environment USERPROFILE'"
global Folder "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"
global output "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\resultados finais"
global Bases "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"
global dofiles "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\Do-Files"
global Logfolder "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\logfiles"



global folderservidor "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"

log using "$Logfolder/em_spillover_v3.log", replace
use "$folderservidor\dados_EM_14_v3.dta", clear

by codigo_escola, sort: gen n_codigo_escola = _n == 1
*para calcular o número de escolas 
gen n_observac = 1
*para calcular o número de observações

count if n_codigo_escola
* 18,999
count if n_observac
*142,636

replace ice=0 if ice ==.

* dropando as escolas que eram privadas e que não eram ice
* note que as primerias escolas do ice são consideradas com privadas no censo
* escolar
drop if dep ==4&ice==0 

count if n_codigo_escola
*12,009
count if n_observac
* 95,192

/*
gera por municipio, para cada ano, uma variável que é a soma das dummies de
d_ice_fluxo
isto é, n_com_ice é o número de escolas ice, em um dado ano
*/
bysort cod_munic ano: egen n_com_ice = sum (d_ice_fluxo)
drop if cod_munic ==.



/*
gera dummy que indica que o município tem ice
*/
gen m_tem_ice= 0
replace m_tem_ice = 1 if n_com_ice > 0

count if m_tem_ice ==1
*  17,337
/*
gera uma variável que é a soma de escolas que receberam ou 
receberão o programa
*/
bysort cod_munic: egen n_com_ice2 = sum (ice)

/*
gera dummy que indica se município tem ou terá escola com ice
*/
gen m_teve_ice = 0
replace m_teve_ice = 1 if n_com_ice2 > 0


/*dropando as escolas que tiveram ice */
drop if d_ice_fluxo == 1

/*colapsando em município e em ano*/
collapse (mean) enem - ano_ice m_teve_ice m_tem_ice ice codigo_uf cod_meso pop pib_capita_reais_real_2015 ///
	enem_nota_objetivab_std enem_nota_redacao_std apr_em_std rep_em_std ///
	aba_em_std dist_em_std concluir_em_ano_enem e_mora_mais_de_6_pessoas ///
	e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios  ///
	e_trabalhou_ou_procurou n_alunos_em_ep n_mulheres_em_ep ///
	rural predio diretoria sala_professores biblioteca ///
	lab_info lab_ciencias ///
	quadra_esportes internet lixo_coleta ///
	eletricidade agua esgoto ///
	d_ano* taxa_participacao_enem mais_educ ///
	 n_prof_em_ep n_prof_tecn n_prof_eja n_prof_em_ef_comp n_prof_em_em ///
	 n_prof_em_sup p_em_superior ///
	(count) codigo_escola	, ///
	by(cod_munic ano)
rename codigo_escola numero_escolas_por_cidade
save "$folderservidor\dados_EM_cidades_v3.dta", replace



use "$folderservidor\dados_EM_cidades_v3.dta", clear
global controles  concluir_em_ano_enem e_mora_mais_de_6_pessoas e_escol_sup_pai	///
	e_escol_sup_mae e_renda_familia_5_salarios e_trabalhou_ou_procurou predio 	///
	diretoria sala_professores lab_info lab_ciencias quadra_esportes internet 	///
	rural lixo_coleta eletricidade agua esgoto 				///
	n_alunos_em_ep n_mulheres_em_ep taxa_participacao_enem pib_capita_reais_real_2015 pop mais_educ ///
	n_prof_em_ep n_prof_tecn n_prof_eja n_prof_em_ef_comp n_prof_em_em ///
	n_prof_em_sup p_em_superior ///
	numero_escolas_por_cidade

egen double_cluster=group(codigo_uf ano)


xtset cod_munic ano


xtreg enem_nota_objetivab_std m_tem_ice d_ano* ///
	$controles, ///
	fe vce(rob)
outreg2 using "$output/em_spillover_v3.xls", ///
	excel replace label ctitle(enem_nota_objetivab_std, fe rob)
	
xtreg enem_nota_objetivab_std m_tem_ice d_ano* ///
	$controles, ///
	fe vce (cluster codigo_uf)
outreg2 using "$output/em_spillover_v3.xls", ///
	excel append label ctitle(enem_nota_objetivab_std, cluster uf)

xtreg enem_nota_objetivab_std m_tem_ice d_ano* ///
	$controles, ///
	fe vce (cluster cod_meso)
outreg2 using "$output/em_spillover_v3.xls", ///
	excel append label ctitle(enem_nota_objetivab_std, cluster meso)
	
xtreg enem_nota_objetivab_std m_tem_ice d_ano* ///
	$controles, ///
	fe vce (cluster double_cluster)  nonest
outreg2 using "$output/em_spillover_v3.xls", ///
	excel append label ctitle(enem_nota_objetivab_std, cluster uf ano)

foreach x in "enem_nota_redacao_std" "apr_em_std" "rep_em_std" "aba_em_std" "dist_em_std"{

xtreg `x' m_tem_ice d_ano* ///
	$controles, ///
	fe vce(rob)
outreg2 using "$output/em_spillover_v3.xls", ///
	excel append label ctitle(`x', fe rob)
	
xtreg `x' m_tem_ice d_ano* ///
	$controles, ///
	fe vce (cluster codigo_uf)
outreg2 using "$output/em_spillover_v3.xls", ///
	excel append label ctitle(`x', cluster uf)

xtreg `x' m_tem_ice d_ano* ///
	$controles, ///
	fe vce (cluster cod_meso)
outreg2 using "$output/em_spillover_v3.xls", ///
	excel append label ctitle(`x', cluster meso)
	
xtreg `x' m_tem_ice d_ano* ///
	$controles, ///
	fe vce (cluster double_cluster)  nonest
outreg2 using "$output/em_spillover_v3.xls", ///
	excel append label ctitle(`x', cluster uf ano)


} 
/*
olhando para os resultados, parece de fato que o ice faz com que a nota e as
variáveis de fluxo médias da cidade, excluindo a escola que recebeu o ice, diminui 
de fato
mas existe um problema de seleção antural: em determinados estados, era um
guidance escolher escolas em cidades piores condições
existe um viés de seleção para o sentido contrário
prcisamos controlar por observáveis

*/
use "$folderservidor\dados_EM_cidades_v3.dta", clear
xtset cod_munic ano
sort cod_munic ano 
count if m_tem_ice
count if m_teve_ice
forvalues x =2003(1)2015{
count if m_teve_ice & ano == `x'
gen m_teve_ice_`x' = r(N) if m_teve_ice & ano == `x'
}
/*

*/
/*analisando os dados, vemos que há mais cidades que já tiveram ice 
em 2003 do que em 2015
isso acontece porque algumas cidades só tem uma escola, e essa é a escola
querecebe o programa em um determinado ano
como as escolas que receberam o programa são excluídas da média,
para termos somente a média das escolas que não receberam o programa,
a cidade desaparece da base de cidades
assim, para realizarmos o matching, isso precisa ser endereçado
isso por que o matching vai ser feito em 2004, entre cidades que virão a ter
o programa com cidades que nunca terão

*/
*gerando uma variável com o  número de anos que o municipio aparece
by cod_munic: gen anos_tot = _N


egen max_ano =max(anos_tot)


/*
mantendo as cidades que aparecem todos os anos na base 
inidiretamente, estaremos mantendo as cidades que tem mais escolas além daquelas
que receberam o ice
*/

keep if max_ano == anos_tot

*(1,231 observations deleted)


xtset cod_munic ano
/*. . xtset cod_munic ano
       panel variable:  cod_munic (strongly balanced)
        time variable:  ano, 2004 to 2015
                delta:  1 unit

*/

/* temos um painel fortemente balanceado. faz sentido, já que, diferente 
da base das escolas, as cidades em geral já existiam nas bases
ainda, foram tiradas as cidades com escolas unica que receberam o ice 
*/

/*

como o painel está balanceado, faz sentido fazermos um propensity score matching
pareando no primeiro ano	

*/

by cod_munic: gen enem_nota_objetivab_std_lag = enem_nota_objetivab_std[_n-1] if ano==ano[_n-1]+1
order enem_nota_objetivab_std_lag, after(enem_nota_objetivab_std)

by cod_munic: gen enem_nota_redacao_std_lag = enem_nota_redacao_std[_n-1] if ano==ano[_n-1]+1 
order enem_nota_redacao_std_lag, after(enem_nota_redacao_std)
/*
   k-Nearest neighbors matching:


        psmatch2 depvar [indepvars] [if exp] [in range] , [outcome(varlist)
                     pscore(varname) neighbor(integer k>1) caliper(real)
                     common trim(real) odds index logit ties nowarnings
                     quietly ate]
*/
global controles_match pib_capita_reais_real_2015 enem_nota_objetivab_std_lag ////
	enem_nota_redacao_std_lag concluir_em_ano_enem e_mora_mais_de_6_pessoas 	///
	e_escol_sup_pai e_escol_sup_mae e_renda_familia_5_salarios ///
	e_trabalhou_ou_procurou n_alunos_em_ep n_mulheres_em_ep rural ///
	predio diretoria sala_professores biblioteca lab_info lab_ciencias ///
	quadra_esportes internet lixo_coleta eletricidade agua esgoto ///
	taxa_participacao_enem mais_educ numero_escolas_por_cidade ///
	n_prof_em_ep  n_prof_em_ef_comp n_prof_em_em ///
	n_prof_em_sup p_em_superior ///
	
keep if ano ==2004
psmatch2 m_teve_ice $controles_match  if ano ==2004,  neighbor(3)

count if _treated == 1
*  273
count if _treated == 0
* 1,007

sort _id
gen match = .
forvalues x= 1008(1)1280 {
	replace match =1 if _n == `x'
	forvalues y = 1(1)3{
	replace match = 1 if _n == _n`y'[`x']
	}

}




/*comparando tratados e controles antes do matching*/
tabstat $controles_match, by(m_teve_ice) stat(mean sd)
 
eststo controle: quietly estpost summarize ///
    $controles_match if m_teve_ice == 0
eststo tratado: quietly estpost summarize ///
    $controles_match if m_teve_ice == 1
eststo diff: quietly estpost ttest ///
    $controles_match, by(m_teve_ice) unequal
esttab controle tratado diff, ///
cells("mean(pattern(1 1 0) fmt(2)) sd(pattern(1 1 0)) b(star pattern(0 0 1) fmt(2)) t(pattern(0 0 1) par fmt(2))") ///
label
/*



*/
keep if match ==1
/*comparando tratados e controles no ano do matching*/
tabstat $controles, by(m_teve_ice) stat(mean sd)
 
eststo controle: quietly estpost summarize ///
    $controles_match if m_teve_ice == 0
eststo tratado: quietly estpost summarize ///
    $controles_match if m_teve_ice == 1
eststo diff: quietly estpost ttest ///
    $controles_match, by(m_teve_ice) unequal
esttab controle tratado diff, ///
cells("mean(pattern(1 1 0) fmt(2)) sd(pattern(1 1 0)) b(star pattern(0 0 1) fmt(2)) t(pattern(0 0 1) par fmt(2))") ///
label
/*

*/
keep cod_munic match
expand 12
sort cod_munic
gen ano=.	
count 
local a = r(N)

	


	forvalues x = 1(12)`a'{
		
		replace ano = 2004 in `x'
		
	}

		forvalues x = 2(12)`a'{
		
		replace ano = 2005 in `x'
		
	}

	forvalues x = 3(12)`a'{
		
		replace ano = 2006 in `x'
		
	}

	forvalues x = 4(12)`a'{
		
		replace ano = 2007 in `x'
		
	}

	
	forvalues x = 5(12)`a'{
		
		replace ano = 2008 in `x'
		
	}
	forvalues x = 6(12)`a'{
		
		replace ano = 2009 in `x'
		
	}
	forvalues x = 7(12)`a'{
		
		replace ano = 2010 in `x'
		
	}
	forvalues x = 8(12)`a'{
		
		replace ano = 2011 in `x'
		
	}
	forvalues x = 9(12)`a'{
		
		replace ano = 2012 in `x'
		
	}
	forvalues x = 10(12)`a'{
		
		replace ano = 2013 in `x'
		
	}
	
	forvalues x = 11(12)`a'{
		
		replace ano = 2014 in `x'
		
	}
	forvalues x = 12(12)`a'{
		
		replace ano = 2015 in `x'
		
	}

save "$folderservidor\EM_cidades_match2004_v3.dta", replace

use "$folderservidor\EM_cidades_match2004_v3.dta", clear
*usando n=3
merge 1:1 cod_munic ano using "$folderservidor\dados_EM_cidades_v3.dta"

/*


*/

keep if _merg==3



egen double_cluster=group(codigo_uf ano)
save "$folderservidor\EM_cidades_matched_v3.dta", replace

xtset cod_munic ano


xtreg enem_nota_objetivab_std m_tem_ice d_ano* ///
	$controles, ///
	fe vce(rob)
outreg2 using "$output/em_spillover_matched_v3.xls", ///
	excel replace label ctitle(enem_nota_objetivab_std, fe rob)
	
xtreg enem_nota_objetivab_std m_tem_ice d_ano* ///
	$controles, ///
	fe vce (cluster codigo_uf)
outreg2 using "$output/em_spillover_matched_v3.xls", ///
	excel append label ctitle(enem_nota_objetivab_std, cluster uf)

xtreg enem_nota_objetivab_std m_tem_ice d_ano* ///
	$controles, ///
	fe vce (cluster cod_meso)
outreg2 using "$output/em_spillover_matched_v3.xls", ///
	excel append label ctitle(enem_nota_objetivab_std, cluster meso)
	
xtreg enem_nota_objetivab_std m_tem_ice d_ano* ///
	$controles, ///
	fe vce (cluster double_cluster)  nonest
outreg2 using "$output/em_spillover_matched_v3.xls", ///
	excel append label ctitle(enem_nota_objetivab_std, cluster uf ano)

foreach x in "enem_nota_redacao_std" "apr_em_std" "rep_em_std" "aba_em_std" "dist_em_std"{

xtreg `x' m_tem_ice d_ano* ///
	$controles, ///
	fe vce(rob)
outreg2 using "$output/em_spillover_matched_v3.xls", ///
	excel append label ctitle(`x', fe rob)
	
xtreg `x' m_tem_ice d_ano* ///
	$controles, ///
	fe vce (cluster codigo_uf)
outreg2 using "$output/em_spillover_matched_v3.xls", ///
	excel append label ctitle(`x', cluster uf)

xtreg `x' m_tem_ice d_ano* ///
	$controles, ///
	fe vce (cluster cod_meso)
outreg2 using "$output/em_spillover_matched_v3.xls", ///
	excel append label ctitle(`x', cluster meso)
	
xtreg `x' m_tem_ice d_ano* ///
	$controles, ///
	fe vce (cluster double_cluster)  nonest
outreg2 using "$output/em_spillover_matched_v3.xls", ///
	excel append label ctitle(`x', cluster uf ano)


} 



log close
