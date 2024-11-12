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
global output "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\resultados_v3"
global Bases "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"
global dofiles "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\Do-Files"
global Logfolder "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\logfiles"



global folderservidor "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"

log using "$Logfolder/em_spillover.log", replace
use "$folderservidor\dados_EM_14_enem_only.dta", clear

by codigo_escola, sort: gen n_codigo_escola = _n == 1
*para calcular o número de escolas 
gen n_observac = 1
*para calcular o número de observações

count if n_codigo_escola

count if n_observac


replace ice=0 if ice ==.

* dropando as escolas que eram privadas e que não eram ice
* note que as primerias escolas do ice são consideradas com privadas no censo
* escolar
drop if dep ==4&ice==0 

count if n_codigo_escola
* 12,331
count if n_observac
* 102,237

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
*  17,611
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
	(count) codigo_escola	, ///
	by(cod_munic ano)
rename codigo_escola numero_escolas_por_cidade
save "$folderservidor\dados_EM_cidades.dta", replace



use "$folderservidor\dados_EM_cidades.dta", clear
global controles  concluir_em_ano_enem e_mora_mais_de_6_pessoas e_escol_sup_pai	///
	e_escol_sup_mae e_renda_familia_5_salarios e_trabalhou_ou_procurou predio 	///
	diretoria sala_professores lab_info lab_ciencias quadra_esportes internet 	///
	rural lixo_coleta eletricidade agua esgoto 				///
	n_alunos_em_ep n_mulheres_em_ep taxa_participacao_enem pib_capita_reais_real_2015 pop mais_educ ///
	numero_escolas_por_cidade

egen double_cluster=group(codigo_uf ano)


xtset cod_munic ano


xtreg enem_nota_objetivab_std m_tem_ice d_ano* ///
	$controles, ///
	fe vce(rob)
outreg2 using "$output/em_spillover_v1.xls", ///
	excel replace label ctitle(enem_nota_objetivab_std, fe rob)
	
xtreg enem_nota_objetivab_std m_tem_ice d_ano* ///
	$controles, ///
	fe vce (cluster codigo_uf)
outreg2 using "$output/em_spillover_v1.xls", ///
	excel append label ctitle(enem_nota_objetivab_std, cluster uf)

xtreg enem_nota_objetivab_std m_tem_ice d_ano* ///
	$controles, ///
	fe vce (cluster cod_meso)
outreg2 using "$output/em_spillover_v1.xls", ///
	excel append label ctitle(enem_nota_objetivab_std, cluster meso)
	
xtreg enem_nota_objetivab_std m_tem_ice d_ano* ///
	$controles, ///
	fe vce (cluster double_cluster)  nonest
outreg2 using "$output/em_spillover_v1.xls", ///
	excel append label ctitle(enem_nota_objetivab_std, cluster uf ano)

foreach x in "enem_nota_redacao_std" "apr_em_std" "rep_em_std" "aba_em_std" "dist_em_std"{

xtreg `x' m_tem_ice d_ano* ///
	$controles, ///
	fe vce(rob)
outreg2 using "$output/em_spillover_v1.xls", ///
	excel append label ctitle(`x', fe rob)
	
xtreg `x' m_tem_ice d_ano* ///
	$controles, ///
	fe vce (cluster codigo_uf)
outreg2 using "$output/em_spillover_v1.xls", ///
	excel append label ctitle(`x', cluster uf)

xtreg `x' m_tem_ice d_ano* ///
	$controles, ///
	fe vce (cluster cod_meso)
outreg2 using "$output/em_spillover_v1.xls", ///
	excel append label ctitle(`x', cluster meso)
	
xtreg `x' m_tem_ice d_ano* ///
	$controles, ///
	fe vce (cluster double_cluster)  nonest
outreg2 using "$output/em_spillover_v1.xls", ///
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
use "$folderservidor\dados_EM_cidades.dta", clear
xtset cod_munic ano
sort cod_munic ano 
count if m_tem_ice
count if m_teve_ice
forvalues x =2003(1)2015{
count if m_teve_ice & ano == `x'
gen m_teve_ice_`x' = r(N) if m_teve_ice & ano == `x'
}
/*
348
349
345
350
  347
  346
  344
  337
  323
  304
  288
  288


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

*(1,400 observations deleted)


xtset cod_munic ano
/*. xtset cod_munic ano
       panel variable:  cod_munic (strongly balanced)
        time variable:  ano, 2003 to 2015
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
	taxa_participacao_enem mais_educ numero_escolas_por_cidade
	
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


-----------------------------------------------------------------------------------------------------
                              (1)                       (2)                       (3)                
                                                                                                     
                             mean           sd         mean           sd            b               t
-----------------------------------------------------------------------------------------------------
(mean) pib_capit~201     17538.39     20822.67     13876.81     17082.43      3661.58**        (3.01)
enem_nota_objetiva~g        -0.41         0.42        -0.54         0.32         0.14***       (5.86)
enem_nota_redacao_~g        -0.35         0.51        -0.46         0.38         0.12***       (4.19)
(mean) concluir_em~m        59.12        38.41        75.62        45.77       -16.50***      (-5.48)
(mean) e_mora_mais~s         0.08         0.08         0.15         0.09        -0.07***     (-12.32)
(mean) e_escol_sup~i         0.03         0.04         0.03         0.03         0.01**        (2.59)
(mean) e_escol_sup~e         0.06         0.05         0.05         0.04         0.01**        (3.02)
(mean) e_renda_fam~o         0.14         0.11         0.10         0.10         0.05***       (6.38)
(mean) e_trabalhou~u         0.79         0.13         0.77         0.11         0.02*         (2.36)
(mean) n_alunos_em~p       413.92       246.33       585.93       285.33      -172.02***      (-9.11)
(mean) n_mulheres_~p       216.50       132.46       323.95       161.49      -107.45***     (-10.14)
(mean) rural                 0.03         0.12         0.07         0.14        -0.04***      (-4.04)
(mean) predio                1.00         0.05         0.99         0.08         0.01*         (2.22)
(mean) diretoria             0.95         0.19         0.90         0.23         0.05***       (3.53)
(mean) sala_profes~s         0.95         0.19         0.93         0.16         0.02          (1.66)
(mean) biblioteca            0.54         0.46         0.64         0.36        -0.10***      (-4.00)
(mean) lab_info              0.01         0.07         0.01         0.08        -0.01         (-1.30)
(mean) lab_ciencias          0.16         0.31         0.21         0.27        -0.05**       (-2.86)
(mean) quadra_espo~s         0.32         0.42         0.18         0.25         0.14***       (6.69)
(mean) internet              0.76         0.40         0.85         0.28        -0.09***      (-4.47)
(mean) lixo_coleta           0.98         0.10         0.94         0.16         0.04***       (3.91)
(mean) eletricidade          1.00         0.04         1.00         0.03         0.00          (0.49)
(mean) agua                  0.97         0.13         0.95         0.13         0.02*         (2.34)
(mean) esgoto                0.71         0.43         0.63         0.38         0.08**        (3.06)
(mean) taxa_partic~m         0.57         0.18         0.53         0.20         0.04**        (2.68)
(mean) mais_educ             0.43         0.45         0.43         0.35        -0.00         (-0.10)
(count) codigo_esc~a         3.03        10.26        10.41        40.04        -7.39**       (-3.03)
-----------------------------------------------------------------------------------------------------
Observations                 1024                       275                      1299                
-----------------------------------------------------------------------------------------------------

. 


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
n=10
-----------------------------------------------------------------------------------------------------
                              (1)                       (2)                       (3)                
                                                                                                     
                             mean           sd         mean           sd            b               t
-----------------------------------------------------------------------------------------------------
(mean) concluir_em~m        70.17        41.13        75.81        45.87        -5.64         (-1.72)
(mean) e_mora_mais~s         0.10         0.09         0.15         0.09        -0.05***      (-7.36)
(mean) e_escol_sup~i         0.04         0.04         0.03         0.03         0.01***       (3.51)
(mean) e_escol_sup~e         0.06         0.05         0.05         0.04         0.01          (1.83)
(mean) e_renda_fam~o         0.14         0.10         0.10         0.10         0.04***       (5.58)
(mean) e_trabalhou~u         0.79         0.12         0.77         0.11         0.02*         (2.51)
(mean) predio                1.00         0.02         0.99         0.08         0.01*         (2.43)
(mean) diretoria             0.94         0.20         0.90         0.22         0.04*         (2.33)
(mean) sala_profes~s         0.95         0.18         0.93         0.16         0.02          (1.83)
(mean) lab_info              0.01         0.10         0.01         0.08        -0.00         (-0.12)
(mean) lab_ciencias          0.18         0.32         0.21         0.27        -0.03         (-1.45)
(mean) quadra_espo~s         0.27         0.39         0.18         0.25         0.08***       (3.68)
(mean) internet              0.84         0.32         0.85         0.28        -0.01         (-0.44)
(mean) rural                 0.04         0.14         0.07         0.14        -0.03*        (-2.58)
(mean) lixo_coleta           0.98         0.13         0.95         0.15         0.03**        (2.80)
(mean) eletricidade          1.00         0.01         1.00         0.03         0.00          (1.17)
(mean) agua                  0.97         0.13         0.95         0.13         0.02          (1.89)
(mean) esgoto                0.73         0.41         0.62         0.38         0.10***       (3.64)
(mean) n_alunos_em~p       497.95       252.05       586.36       285.77       -88.42***      (-4.34)
(mean) n_mulheres_~p       263.44       136.04       324.10       161.77       -60.66***      (-5.33)
(mean) taxa_partic~m         0.56         0.16         0.53         0.20         0.02          (1.56)
(mean) pib_capit~201     17645.06     22625.03     13949.65     17123.75      3695.41**        (2.61)
(mean) pop               56015.72    277814.58    148101.42    684066.28    -92085.71*        (-2.14)
(mean) mais_educ             0.43         0.44         0.43         0.35        -0.00         (-0.03)
-----------------------------------------------------------------------------------------------------
Observations                  546                       273                       819                
-----------------------------------------------------------------------------------------------------

n=5

-----------------------------------------------------------------------------------------------------
                              (1)                       (2)                       (3)                
                                                                                                     
                             mean           sd         mean           sd            b               t
-----------------------------------------------------------------------------------------------------
(mean) pib_capit~201     16932.50     20722.21     13949.65     17123.75      2982.86*         (2.05)
enem_nota_objetiva~g        -0.43         0.41        -0.54         0.32         0.12***       (4.24)
enem_nota_redacao_~g        -0.35         0.49        -0.47         0.38         0.11***       (3.34)
(mean) concluir_em~m        72.48        42.04        75.81        45.87        -3.33         (-0.96)
(mean) e_mora_mais~s         0.11         0.09         0.15         0.09        -0.04***      (-5.73)
(mean) e_escol_sup~i         0.04         0.04         0.03         0.03         0.01**        (2.80)
(mean) e_escol_sup~e         0.06         0.04         0.05         0.04         0.01          (1.85)
(mean) e_renda_fam~o         0.14         0.10         0.10         0.10         0.04***       (5.14)
(mean) e_trabalhou~u         0.79         0.12         0.77         0.11         0.02*         (2.23)
(mean) n_alunos_em~p       515.97       261.48       586.36       285.77       -70.40**       (-3.26)
(mean) n_mulheres_~p       274.11       141.24       324.10       161.77       -49.98***      (-4.16)
(mean) rural                 0.05         0.15         0.07         0.14        -0.02         (-1.84)
(mean) predio                1.00         0.02         0.99         0.08         0.01*         (2.46)
(mean) diretoria             0.93         0.21         0.90         0.22         0.03          (1.86)
(mean) sala_profes~s         0.95         0.18         0.93         0.16         0.02          (1.42)
(mean) biblioteca            0.55         0.45         0.65         0.36        -0.10**       (-3.12)
(mean) lab_info              0.01         0.09         0.01         0.08        -0.00         (-0.51)
(mean) lab_ciencias          0.19         0.33         0.21         0.27        -0.02         (-0.77)
(mean) quadra_espo~s         0.25         0.37         0.18         0.25         0.06**        (2.58)
(mean) internet              0.84         0.32         0.85         0.28        -0.01         (-0.55)
(mean) lixo_coleta           0.97         0.14         0.95         0.15         0.02*         (2.09)
(mean) eletricidade          1.00         0.00         1.00         0.03         0.00          (1.37)
(mean) agua                  0.96         0.14         0.95         0.13         0.01          (1.33)
(mean) esgoto                0.71         0.42         0.62         0.38         0.09**        (2.89)
(mean) taxa_partic~m         0.56         0.16         0.53         0.20         0.03          (1.87)
(mean) mais_educ             0.42         0.44         0.43         0.35        -0.01         (-0.26)
(count) codigo_esc~a         4.49        15.76        10.48        40.18        -5.99*        (-2.35)
-----------------------------------------------------------------------------------------------------
Observations                  409                       273                       682                
-----------------------------------------------------------------------------------------------------

n=3


-----------------------------------------------------------------------------------------------------
                              (1)                       (2)                       (3)                
                                                                                                     
                             mean           sd         mean           sd            b               t
-----------------------------------------------------------------------------------------------------
(mean) pib_capit~201     16889.44     22303.10     13949.65     17123.75      2939.79          (1.80)
enem_nota_objetiva~g        -0.44         0.41        -0.54         0.32         0.11***       (3.60)
enem_nota_redacao_~g        -0.36         0.49        -0.47         0.38         0.10**        (2.77)
(mean) concluir_em~m        73.33        43.10        75.81        45.87        -2.48         (-0.67)
(mean) e_mora_mais~s         0.12         0.10         0.15         0.09        -0.03***      (-4.31)
(mean) e_escol_sup~i         0.04         0.04         0.03         0.03         0.01*         (2.50)
(mean) e_escol_sup~e         0.06         0.04         0.05         0.04         0.01          (1.64)
(mean) e_renda_fam~o         0.14         0.11         0.10         0.10         0.04***       (4.29)
(mean) e_trabalhou~u         0.79         0.12         0.77         0.11         0.02*         (2.05)
(mean) n_alunos_em~p       525.91       264.32       586.36       285.77       -60.45**       (-2.64)
(mean) n_mulheres_~p       280.99       144.48       324.10       161.77       -43.11***      (-3.38)
(mean) rural                 0.05         0.16         0.07         0.14        -0.02         (-1.41)
(mean) predio                1.00         0.02         0.99         0.08         0.01*         (2.29)
(mean) diretoria             0.93         0.22         0.90         0.22         0.03          (1.77)
(mean) sala_profes~s         0.94         0.20         0.93         0.16         0.01          (0.81)
(mean) biblioteca            0.55         0.45         0.65         0.36        -0.10**       (-2.93)
(mean) lab_info              0.01         0.10         0.01         0.08        -0.00         (-0.20)
(mean) lab_ciencias          0.19         0.33         0.21         0.27        -0.02         (-0.64)
(mean) quadra_espo~s         0.24         0.37         0.18         0.25         0.06*         (2.30)
(mean) internet              0.84         0.32         0.85         0.28        -0.01         (-0.33)
(mean) lixo_coleta           0.97         0.14         0.95         0.15         0.03*         (2.11)
(mean) eletricidade          1.00         0.00         1.00         0.03         0.00          (1.37)
(mean) agua                  0.96         0.15         0.95         0.13         0.01          (1.17)
(mean) esgoto                0.69         0.42         0.62         0.38         0.07*         (2.02)
(mean) taxa_partic~m         0.56         0.16         0.53         0.20         0.02          (1.50)
(mean) mais_educ             0.43         0.44         0.43         0.35        -0.01         (-0.16)
(count) codigo_esc~a         4.80        17.77        10.48        40.18        -5.68*        (-2.16)
-----------------------------------------------------------------------------------------------------
Observations                  312                       273                       585                

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

save "$folderservidor\EM_cidades_match2004.dta", replace

use "$folderservidor\EM_cidades_match2004.dta", clear
*usando n=3
merge 1:1 cod_munic ano using "$folderservidor\dados_EM_cidades.dta"

/*

    Result                           # of obs.
    -----------------------------------------
    not matched                        11,267
        from master                         0  (_merge==1)
        from using                     11,267  (_merge==2)

    matched                             7,020  (_merge==3)
    -----------------------------------------

. 

*/

keep if _merg==3



egen double_cluster=group(codigo_uf ano)
save "$folderservidor\EM_cidades_matched.dta", replace

xtset cod_munic ano


xtreg enem_nota_objetivab_std m_tem_ice d_ano* ///
	$controles, ///
	fe vce(rob)
outreg2 using "$output/em_spillover_matched_v1.xls", ///
	excel replace label ctitle(enem_nota_objetivab_std, fe rob)
	
xtreg enem_nota_objetivab_std m_tem_ice d_ano* ///
	$controles, ///
	fe vce (cluster codigo_uf)
outreg2 using "$output/em_spillover_matched_v1.xls", ///
	excel append label ctitle(enem_nota_objetivab_std, cluster uf)

xtreg enem_nota_objetivab_std m_tem_ice d_ano* ///
	$controles, ///
	fe vce (cluster cod_meso)
outreg2 using "$output/em_spillover_matched_v1.xls", ///
	excel append label ctitle(enem_nota_objetivab_std, cluster meso)
	
xtreg enem_nota_objetivab_std m_tem_ice d_ano* ///
	$controles, ///
	fe vce (cluster double_cluster)  nonest
outreg2 using "$output/em_spillover_matched_v1.xls", ///
	excel append label ctitle(enem_nota_objetivab_std, cluster uf ano)

foreach x in "enem_nota_redacao_std" "apr_em_std" "rep_em_std" "aba_em_std" "dist_em_std"{

xtreg `x' m_tem_ice d_ano* ///
	$controles, ///
	fe vce(rob)
outreg2 using "$output/em_spillover_matched_v1.xls", ///
	excel append label ctitle(`x', fe rob)
	
xtreg `x' m_tem_ice d_ano* ///
	$controles, ///
	fe vce (cluster codigo_uf)
outreg2 using "$output/em_spillover_matched_v1.xls", ///
	excel append label ctitle(`x', cluster uf)

xtreg `x' m_tem_ice d_ano* ///
	$controles, ///
	fe vce (cluster cod_meso)
outreg2 using "$output/em_spillover_matched_v1.xls", ///
	excel append label ctitle(`x', cluster meso)
	
xtreg `x' m_tem_ice d_ano* ///
	$controles, ///
	fe vce (cluster double_cluster)  nonest
outreg2 using "$output/em_spillover_matched_v1.xls", ///
	excel append label ctitle(`x', cluster uf ano)


} 



/*
/* efeito cumulativo*/

use "$folderservidor\EM_cidades_matched.dta", clear
gen tempo=.

replace tempo=0 if ano==ano_ice-4
replace tempo=1 if ano==ano_ice-3 
replace tempo=2 if ano==ano_ice-2
replace tempo=3 if ano==ano_ice-1
replace tempo=4 if ano==ano_ice
replace tempo=5 if ano==ano_ice+1 
replace tempo=6 if ano==ano_ice+2
replace tempo=7 if ano==ano_ice+3
replace tempo=8 if ano==ano_ice+4


tab tempo, gen(d_tempo)
replace  d_tempo1 = 0 if  d_tempo1==.
replace  d_tempo2 = 0 if  d_tempo2==.
replace  d_tempo3 = 0 if  d_tempo3==.
replace  d_tempo4 = 0 if  d_tempo4==.
replace  d_tempo5 = 0 if  d_tempo5==.
replace  d_tempo6 = 0 if  d_tempo6==.
replace  d_tempo7 = 0 if  d_tempo7==.
replace  d_tempo8 = 0 if  d_tempo8==.
replace  d_tempo9 = 0 if  d_tempo9==.




gen d_ice_pre4=ice*d_tempo1
gen d_ice_pre3=ice*d_tempo2
gen d_ice_pre2=ice*d_tempo3
gen d_ice_pre1=ice*d_tempo4
gen d_ice_inicio=ice*d_tempo5
gen d_ice_pos1=ice*d_tempo6
gen d_ice_pos2=ice*d_tempo7
gen d_ice_pos3=ice*d_tempo8
gen d_ice_pos4=ice*d_tempo9


replace d_ice_pre4=0 if ice==0
replace d_ice_pre3=0 if ice==0
replace d_ice_pre2=0 if ice==0
replace d_ice_pre1=0 if ice==0
replace d_ice_inicio=0 if ice==0
replace d_ice_pos1=0 if ice==0
replace d_ice_pos2=0 if ice==0
replace d_ice_pos3=0 if ice==0
replace d_ice_pos4=0 if ice==0


global todos_anos d_ice_pre4 d_ice_pre3 d_ice_pre2 d_ice_pre1 d_ice_inicio  ///
	d_ice_pos1 d_ice_pos2 d_ice_pos3 d_ice_pos4

*/
