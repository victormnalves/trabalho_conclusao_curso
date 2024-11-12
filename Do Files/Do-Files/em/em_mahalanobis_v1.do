/*
mahalanobis matching

*/
{
/*

o objetivo aqui é fazer o matching de cada tratado com algum controle, para 
gerar uma amostra de controles que seja bem balanceada com os tratados
na abordagem com o propensity score, tinhamos o problema de que usavamos os status
de ser tratado em qualquer ano como variável de tratamento para calcular o 
propensity score em um dado ano.
Isso por que o número de tratados por ano é baixo, causando problemas de estimação
então, não podemos pegar somente as escolas que começaram a ser tratadas no ano de 2007,
por exmeplo, e rodar um logit com as escolas e infos de 2007.
precisamos usar a info das escolas que entraram no tratamento ao longo de 2004 até 2015
para calcular a probabilidade de cada escola do controle ter sido tratada
*/

/*
já aqui, vamos tentar escolher controles para cada tratado, usando mahalobinis metric

de forma análoga ao caso do propensity score, o objetvio é balancear, de modo que a
hipótese de uncounfoundness seja mais crível, isto é, queremos controlar por covariadas
de modo que a atribuição do tratamento pareça aleatório

similarmnete, queremos escolher controles que sejam parecidos com os tratados
para que se observarmos uma mudança nos outcomes, essa mudança seja devido ao
tratamento

*/

sysdir set PLUS \\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\ado

capture log close
clear all
set more off, permanently


prog def mahapicksome, sortpreserve
/* This used to be mahapick1, but I am adapting it to pick several matches. */
version 8.2

#delimit ;
syntax , idvar(varname) refobs(integer) treated(varname)
 scorevar(varname)
 [
 pickids(varlist)
 matchon(varlist)
 genfile(string) nummatches(integer 1) full all
 postfilehandle(name)
 score
 ]
 ;

#delimit cr

/*
Given a scoring, select an observation to match a given refobs. Later
(9-9-2003), this was expanded to possibly multiple observations -- as many as
there are variables in `pickids'.

This does matching WITH REPLACEMENT.  There is no guarantee that replicated
selections won't be made.  But with a large set to choose from, you generally
don't get too much replication.


If multiple equal-scored items are found, the first is picked.
I have made all the sorting stable, so, if there are any such cases, the
results will be consistent, provided that the initial sort order is
consistent.


This will sort; but will implicity restore order (sortpreserve).
That sortpreserve is important.  The calling program needs to have the same
order after the return.

If matchon is specified, then the matching is constrained to cases that match
on these vars.  Best if they are integer-valued.

Note that the sorting seems to be the big time waster.
Thus, this is improved when the calling program slices up the data into
smaller pieces.

If the score is missing on the selected item, then return missing; i.e., do
not select this one; there is no basis for choosing it.  This is a change as
of 4-18-2003.  Previously we did issue a warning, but also returned the
selected case.

9-9-2003: Previously, this was rclass, and returned the result in r(pick); the
calling program then set the pickid.  But now, I am making this do the
setting of pickid.  To do this, we needed to set up a pickid option (required).

One fault with the old system: the pickid must be numeric.  I believe that now,
this will work on any data type for the pickids.

Part of this change is to place the refobs into position 1 in the sort.  Thus,
all pickid values are loaded into [1].

Making pickid a varlist rather than a varname; i.e., it can have several vars.
Thus renaming it to pickids.

Note that the vars in pickids should be all of the same type, which should be
the same as that of idvar.

*/

disp "mahapicksome called; refobs= " as res "`refobs'" as text "; id (`idvar') = " %12.0f as res `idvar'[`refobs']


capture assert `refobs' >=1 & `refobs' <= _N
if _rc ~=0 {
  disp as error "refobs must be in the range 1 .. _N"
  exit 198
}


capture confirm numeric var `treated'
if _rc ~=0 {
  disp as error "treated must be a numeric var"
  exit 198
}

capture assert `treated'==0 | `treated'==1
if _rc ~=0 {
  disp as error "treated must be valued {0, 1}"
  exit 198
}

capture assert `treated'[`refobs']
if _rc ~=0 {
  disp as error "Warning: refobs `refobs' is not treated."
  // but this is not fatal
}

if index("`matchon'", "`treated'") {
  disp as error "treated(`treated') may not be part of the matchon vars."
  exit 198
}




tempvar is_refobs not_refobs
gen byte `is_refobs' = _n == `refobs'
quietly count if `is_refobs'
assert r(N) ==1

gen byte `not_refobs' = ~`is_refobs'




tempvar is_treated_or_ref
gen byte `is_treated_or_ref' = `treated' | `is_refobs' 
// We expect, usually, but do not require, that the ref is treated.

tempvar not_treated_or_ref
gen byte `not_treated_or_ref' = ~`is_treated_or_ref'

quietly count if `is_treated_or_ref'
local k1 = r(N) + 1
drop `is_treated_or_ref'

if `k1' > _N {
 disp as error "no non-treated non-ref obs; no matches to be made"
 exit
 /* formerly exit 198, but now (12-3-2003) just exit and continue, not an
  error; but no matches will be made.
 */
}


tempvar matchok  not_matchok
gen byte `matchok' = 1

foreach var of local matchon {
 quietly replace `matchok' = `matchok' & (`var' == `var'[`refobs'])
}

gen byte `not_matchok' = ~`matchok'


sort  `not_treated_or_ref' `not_refobs' `not_matchok' `scorevar', stable
/*
That could have been done with gsort -- eliminating the confusing use of the
"not_..." variables, but gsort doesn't have -stable-.
*/

assert `is_refobs'[1]
/*
 -- that means that, the refobs will land in place 1. (Remember
that only one obs is `is_refobs'.)  This will be useful in the following,
where we replace something -in 1-.

We could have do replace ... if `is_refobs', but the other is more efficient,
especially if we will be doing multiple picks, as we plan to do later.
*/
drop `is_refobs'


local num_pickids "0"


if "`pickids'" ~= "" {

 local d1 "0"
 local nmiss "0"
 local notokay "0"


 foreach var of local pickids {
  local ++num_pickids

  capture assert mi(`var'[1])
  if _rc ~=0 {
   disp as error "pickid (`var') must be missing in refobs (`refobs')"
   exit 198
  }
  local k2 = `k1'+`d1'

  if `k2' <= _N & `matchok'[`k2'] {

   if mi(`scorevar'[`k2']) {
    local ++nmiss
    local pickidscoremis "`pickidscoremis' `var'"
   }
   else {
    quietly replace `var' = `idvar'[`k2'] in 1
   }
  }
  else {
   local ++notokay
   local pickidnotokay "`pickidnotokay' `var'"
  }
 local ++d1
 }


 if `nmiss' >0 {
  disp as error "Warning: distance measure missing for `nmiss' of the pickids:"
  disp as error " `pickidscoremis'"
 }

 if `notokay' >0 {
  disp as error "Warning: no matching obs found for `notokay' of the pickids."
  disp as error " `pickidnotokay'"
  /* -- that refers to a lack of qualified match candidates (possibly limited
  by the use of -matchon-).
  */
 }
}


if "`genfile'" ~= "" {

 local nmiss "0"
 local notokay "0"

 local typ1: type `idvar'
 if substr("`typ1'",1,3) == "str" {
  local idvarmisval `""""'
 }
 else {
  local idvarmisval "."
 }


 if "`score'" ~= "" {
  local score_elt "(`scorevar'[1])"  // ought to be 0
 }

 post `postfilehandle' (`idvar'[1])  (`idvar'[1]) (0) `score_elt'

 if "`all'" ~= "" {  // take ALL possible matches
  count if `matchok' & `not_treated_or_ref'
  local nummatches = max(`nummatches', r(N))
  //-- replace it with the actual number of available matches, if larger.

 }

 forvalues j1 = 1 / `nummatches' {

  local k2 = `k1'+`j1' - 1

  if ("`full'" == "") & (`k2' > _N) {
   continue, break
  }

  local ok_to_post 0

  if "`score'" ~= "" {
   local score_elt "(`scorevar'[`k2'])"
  }

  if `k2' <= _N & `matchok'[`k2'] {

   if mi(`scorevar'[`k2']) {
    local ++nmiss
   }
   else {
    local ok_to_post 1
   }
  }
  else {
   local ++notokay
   if "`score'" ~= "" {
    local score_elt "(.)"  // note 1
   }
  }

  if `ok_to_post' {
   post `postfilehandle'  (`idvar'[1]) (`idvar'[`k2']) (`j1') `score_elt'
  }
  else if "`full'" ~= "" {
   post `postfilehandle'  (`idvar'[1]) (`idvarmisval') (`j1') `score_elt' // note 2
  }

 }

 if `nmiss' >0 {
  disp as error "Warning: distance measure missing for `nmiss' candidates"
 }

 if `notokay' >0 {
  disp as error "Warning: no matching obs found for `notokay' of the nummatches"
  /* -- that refers to a lack of qualified match candidates (possibly limited
  by the use of -matchon-).
  */
 }

}

/*
Note 1: Give a missing score value -- in case we have
~`ok_to_post' and "`full'" ~= "" (and "`score'" ~= "").

Then, if `k2' <= _N & ~`matchok'[`k2'], then
the scores may well exist, but they are meaningless, in that they refer to
invalidated matches.  And the scores may likely be less than those among the
valid matches.  (I.e., the scores increas as you go down the list of ok
matches; but once you go past the `matchok' segment, the scores may restart
at a lower value.

Of course, if `k2' > _N, then there is no score at all.

But if we have
~`ok_to_post' and "`full'" ~= "", where the reason for ~`ok_to_post' is a
missing score, then the score_elt will naturally be missing.  So no need
to intervene in that case.


Note 2: We could have done this:
   if "`score'" ~= "" {
    local score_elt "(.)"
   }
   post `postfilehandle' (`idvar'[1]) (`idvarmisval') (`j1') `score_elt'
That would take care of all invalid-but-posted cases (due to -full- and
-score-), and it would obviate the need for setting score_elt at the point
where note 1 is.  But it would replace any extended missing values -- if any
(which I don't expect) with sysmis.

*/



/* Report scores of 0: */
quietly count if `scorevar'==0 &  `not_treated_or_ref' & `matchok'
if r(N) >1 {
 disp as text "Note: there are " r(N) " cases of score==0"
 // That's one possible cause of multiplicities.
}




/* Report equal scores: */

local num_picks = max(`num_pickids', `nummatches')
local kmax = `k1' + `num_picks'
/* prior to 3-27-2008, kmax was `k1' + `num_picks' -1.
That captured all the scores of the chosen items.
BUT it omits one potential ambiguity: if the LAST item has the same score as
the next one in line.  E.g., if you pick 3 matches as match 3 has same score
as match 4 (were it to be included).  This higher value of kmax should
take care of that situation.
*/

forvalues j1 = `=`k1'+1' / `kmax' {
 if `j1' <= _N &  ~mi(`scorevar'[`j1']) {
  if (`scorevar'[`j1'] == `scorevar'[`j1'-1]) & ///
   ((`j1' < (`k1'+2)) | (`scorevar'[`j1'] ~= `scorevar'[`j1'-2]) ) {
   disp as text "Note: equal scores found; score: " as res `scorevar'[`j1']
   /* And an arbitrary choice was taken, the one that is earler in the order.
   */
  }
 }
 else {
  continue, break
 }
}

/*
Note: in the the above code, the extra condition,
 ((`j1' < (`k1'+2)) | (`scorevar'[`j1'] ~= `scorevar'[`j1'-2]) )
prevents multiple reports of the same repeated score.
Otherwise, if the same score value occurs more that twice, it would be
reported more than once.

Also note that this only checks adjacent pairs; that's all you need, since the
set is sorted by `scorevar'.
*/


end // mahapicksome

}
/*
********************************************************************************
********************************************************************************
********************************************************************************
mahalanobis matching 
(somente usando as características do censo escolar para ensino medio)
o objetivo é deixas a amostra balanceada entre os tratados e controles
o matching pode ser feito de várias formas:
(A) parear no ano de entrada do tratamento, e manter o mesmo par até o final da 
análise 
a vantagem é que supostamente o tratado entrante vai estar balanceado com o c
ontrole em cada ano
a desvantagem é que a informação pré tratamento dos tratados não é utilizada
o ideal seria parear na data de entrada ou talvez na história do tratado

(B) parear desde o começo e manter o mesmo par até o final da análise
a vantagem é que toda a info pré dos tratados é usada, um problema é que o
tratado pode mudar até realmente ser tratado e ficar diferente de quando foi pa-
reado 
********************************************************************************
********************************************************************************
********************************************************************************
*/

global folderservidor "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"
log using "$folderservidor\logfiles/em_mahalanobis_v1.log", replace


/*
********************************************************************************
2004
2004
********************************************************************************
*/
use "$folderservidor\dados_EM_14_v2.dta", clear

* declarando dados como painel
* ano é t e codigo_escola é i

xtset codigo_escola ano



/*

em 2004, temos somente uma escola entrando no programa. Ainda, ela foi "criada"
com o programa. Ela só possui dados de censo escola. os dados do enem só aparecem
2 anos depois, pois o programa começou com o primeiro ano do ensino médio.
ainda não possui dados de indicadores de fluxo, que só foram introduzidos em 2007
pelo sistema educacenso.
Assim, para o ano de 2004, devemos usar somente as informações que a 
escola tratada dispõe

*/

/*
2004
mas antes, precisamos excluir as observações cujas covariadas têm missings

*/
drop if (pib_capita_reais_real_2015==. | pop==. | rural==.| ativa==.| predio==.| diretoria==.| sala_professores==.| biblioteca==.|sala_leitura==.|refeitorio==.|lab_info==.|lab_ciencias==.|quadra_esportes==.| internet==.| lixo_coleta==.| eletricidade==.| agua==.| esgoto==.| n_alunos_em_ep==.| n_mulheres_em_ep==.)& codigo_escola_2004!=.
*(obs=9,955)
drop if ano != 2004
drop if ice==0 & enem ==.

drop ativa


*definindo a matriz de variância e covariância
global varlist2004  pib_capita_reais_real_2015 pop rural predio diretoria sala_professores biblioteca sala_leitura refeitorio lab_info lab_ciencias quadra_esportes internet lixo_coleta eletricidade agua esgoto n_alunos_em_ep n_mulheres_em_ep
matrix accum A = $varlist2004, deviations noconstant 
matrix A = A/(r(N)-1)
mat list A

*definindo a matriz inversa
mat A_inv = inv(A)

mat list A_inv

*definindo algumas variáveis para ajudar no cálculo do score
quietly count if d_entrada_2004 == 1
gen d_n_entrada_2004 = ~d_entrada_2004
*gen score2004=.
sort d_n_entrada_2004, stable


*como só temos um tratado em 2004

mahascore $varlist2004, gen(score2004) refobs(1) invcovarmat(A_inv)
sort score2004

quietly count if d_entrada_2004
local Ntreated_2004 = r(N)
di `Ntreated_2004'
local matched_2004 = `Ntreated_2004'+10
forvalues n1 = 1(1)`matched_2004'{
	replace d_match_2004 = 1 if _n == `n1' 

}
* mantendo só os 10 controles mais próximos do tratado

drop if d_match_2004 != 1

tabstat $varlist2004, by(d_entrada_2004) stat(mean sd)
 
eststo controle: quietly estpost summarize ///
    $varlist2004 if d_entrada_2004 == 0
eststo tratado: quietly estpost summarize ///
    $varlist2004 if d_entrada_2004 == 1
eststo diff: quietly estpost ttest ///
    $varlist2004, by(d_entrada_2004) unequal

esttab controle tratado diff, ///
cells("mean(pattern(1 1 0) fmt(2)) sd(pattern(1 1 0)) b(star pattern(0 0 1) fmt(2)) t(pattern(0 0 1) par fmt(2))") ///
label

gen match = 1
save "$folderservidor\matches_2004.dta", replace




/*
********************************************************************************
2005
2005
********************************************************************************
*/


use "$folderservidor\dados_EM_14_v2.dta", clear
* declarando dados como painel
* ano é t e codigo_escola é i

xtset codigo_escola ano

/*
em 2005, temos somente uma escola entrando no programa. Ainda, ela foi "criada"
com o programa. Ela só possui dados de censo escola. os dados do enem só aparecem
2 anos depois, pois o programa começou com o primeiro ano do ensino médio.
ainda não possui dados de indicadores de fluxo, que só foram introduzidos em 2007
pelo sistema educacenso.
Assim, para o ano de 2005, devemos usar somente as informações que a 
escola tratada dispõe*/
drop if ano != 2005
*(999,152 observations deleted)

drop if (pib_capita_reais_real_2015==. | pop==. | rural==.| ativa==.| predio==.| diretoria==.| sala_professores==.| biblioteca==.|sala_leitura==.|refeitorio==.|lab_info==.|lab_ciencias==.|quadra_esportes==.| internet==.| lixo_coleta==.| eletricidade==.| agua==.| esgoto==.| n_alunos_em_ep==.| n_mulheres_em_ep==.)& codigo_escola_2005!=.
*(66,070 observations deleted)
*(obs=10,392)
drop if ice==0 & enem ==.
count if d_entrada_2005 == 1
drop ativa


global varlist2005  pib_capita_reais_real_2015 pop rural predio diretoria sala_professores biblioteca sala_leitura refeitorio lab_info lab_ciencias quadra_esportes internet lixo_coleta eletricidade agua esgoto n_alunos_em_ep n_mulheres_em_ep

matrix accum A = $varlist2005, deviations noconstant 
matrix A = A/(r(N)-1)
mat list A

*definindo a matriz inversa
mat A_inv = inv(A)

mat list A_inv

*definindo algumas variáveis para ajudar no cálculo do score
quietly count if d_entrada_2005 == 1
gen d_n_entrada_2005 = ~d_entrada_2005
*gen score2004=.
sort d_n_entrada_2005, stable


*como só temos um tratado em 2005

mahascore $varlist2005, gen(score2005) refobs(1) invcovarmat(A_inv)
sort score2005

quietly count if d_entrada_2005
local Ntreated_2005 = r(N)
di `Ntreated_2005'
local matched_2005 = `Ntreated_2005'+10
forvalues n1 = 1(1)`matched_2005'{
	replace d_match_2005 = 1 if _n == `n1' 

}
* mantendo só os 10 controles mais próximos do tratado

drop if d_match_2005 != 1

tabstat $varlist2005, by(d_entrada_2005) stat(mean sd)
 
eststo controle: quietly estpost summarize ///
    $varlist2005 if d_entrada_2005 == 0
eststo tratado: quietly estpost summarize ///
    $varlist2005 if d_entrada_2005 == 1
eststo diff: quietly estpost ttest ///
    $varlist2005, by(d_entrada_2005) unequal

esttab controle tratado diff, ///
cells("mean(pattern(1 1 0) fmt(2)) sd(pattern(1 1 0)) b(star pattern(0 0 1) fmt(2)) t(pattern(0 0 1) par fmt(2))") ///
label

gen match = 1
save "$folderservidor\matches_2005.dta", replace



/*
********************************************************************************
2006
2006
********************************************************************************
*/


use "$folderservidor\dados_EM_14_v2.dta", clear
* declarando dados como painel
* ano é t e codigo_escola é i

xtset codigo_escola ano

* como usamos outcomes defasados, precisamos gerar os lags


/*
em 2006, temos somente uma escola entrando no programa. Ainda, ela foi "criada"
com o programa. Ela só possui dados de censo escola. os dados do enem só aparecem
2 anos depois, pois o programa começou com o primeiro ano do ensino médio.
ainda não possui dados de indicadores de fluxo, que só foram introduzidos em 2007
pelo sistema educacenso.

Assim, para o ano de 2006, devemos usar somente as informações que a 
escola tratada dispõe
*/

drop if ano != 2006
*(999,455 observations deleted)

drop if (pib_capita_reais_real_2015==. | pop==. | rural==.| predio==.| diretoria==.| sala_professores==.| biblioteca==.|sala_leitura==.|refeitorio==.|lab_info==.|lab_ciencias==.|quadra_esportes==.| internet==.| lixo_coleta==.| eletricidade==.| agua==.| esgoto==.| n_alunos_em_ep==.| n_mulheres_em_ep==.)& codigo_escola_2006!=.
*(65,525 observations deleted)
*(obs=10,634)
drop if ice==0 & enem ==.
drop if ensino_medio ==0
drop ativa


global varlist2006  pib_capita_reais_real_2015 pop rural predio diretoria ///
	sala_professores biblioteca sala_leitura refeitorio lab_info lab_ciencias ///
	quadra_esportes internet lixo_coleta eletricidade agua esgoto ///
	n_alunos_em_ep n_mulheres_em_ep
/*
variáveis sem ou com pocuca variação
rural 
predio  
diretoria 
sala_professores 
 
biblioteca
sala_leitura 
refeitorio
lab_info 
lab_ciencias
quadra_esportes
internet
lixo_coleta
eletricidade 
agua
esgoto

*/
global varlist2006_treated pib_capita_reais_real_2015 pop   ///
				n_alunos_em_ep n_mulheres_em_ep


global varlist2006_treated_const rural predio diretoria sala_professores ///
	biblioteca 	sala_leitura refeitorio lab_info  lab_ciencias ///
	quadra_esportes internet lixo_coleta eletricidade ///
	agua esgoto

matrix accum A = $varlist2006_treated if d_entrada_2006==1, deviations noconstant 
matrix A = A/(r(N)-1)
mat list A

*definindo a matriz inversa
mat A_inv = inv(A)

mat list A_inv

gen double cod_escola_match_2006 =.




mahapick $varlist2006_treated, idvar(codigo_escola) treated(d_entrada_2006) ///
	pickids(cod_escola_match_2006) clear genfile($folderservidor\matches_2006.dta) replace  ///
	 nummatches(10) matchon($varlist2006_treated_const) score

	 
	 
	 
	 
	 
	 
	 
/*
********************************************************************************
2007
2007
********************************************************************************
*/
	 
	 
	
use "$folderservidor\dados_EM_14_v2.dta", clear
* declarando dados como painel
* ano é t e codigo_escola é i

xtset codigo_escola ano 

keep if  ano == 2007
* duas escolas tratadas não tem info de internet
* vou assumir que se a escola não tem info de internet, é pq ela não tem

replace internet = 0 in 26452

replace internet = 0 in 26424

drop ativa
drop if ensino_medio ==0
drop if (pib_capita_reais_real_2015==. | pop==. | rural==.| predio==.| diretoria==.| sala_professores==.| biblioteca==.|lab_info==.|lab_ciencias==.|quadra_esportes==.|  lixo_coleta==.| eletricidade==.| agua==.| esgoto==.| n_alunos_em_ep==.| n_mulheres_em_ep==.)& codigo_escola_2007!=.
* note que refeitorio e sala_leitura não estão presentes em 2007
drop if  ice == 0 & enem==.
global varlist2007_treated pib_capita_reais_real_2015 pop   ///
				n_alunos_em_ep n_mulheres_em_ep esgoto


global varlist2007_treated_const rural predio diretoria sala_professores ///
	biblioteca  lab_info  lab_ciencias ///
	quadra_esportes internet lixo_coleta eletricidade ///
	agua 


gen double cod_escola_match_2007 =.




mahapick $varlist2007_treated, idvar(codigo_escola) treated(d_entrada_2007) ///
	pickids(cod_escola_match_2007) clear genfile($folderservidor\matches_2007.dta) replace  ///
	 nummatches(10) matchon($varlist2007_treated_const) score

	 
		 
/*
********************************************************************************
2008
2008
********************************************************************************
*/
	   

	 
	
use "$folderservidor\dados_EM_14_v2.dta", clear
* declarando dados como painel
* ano é t e codigo_escola é i

xtset codigo_escola ano 

keep if  ano == 2007 | ano == 2008
drop if (pib_capita_reais_real_2015==. | pop==. | rural==.| predio==.| diretoria==.| sala_professores==.| biblioteca==.|lab_info==.|lab_ciencias==.|quadra_esportes==.|  lixo_coleta==.| eletricidade==.| agua==.| esgoto==.| n_alunos_em_ep==.| n_mulheres_em_ep==.)& codigo_escola_2008!=.
* note que refeitorio e sala_leitura não estão presentes em 2008
drop if  ice == 0 & enem==.
drop ativa
drop if ensino_medio ==0

global varlist2008_treated pib_capita_reais_real_2015 pop   ///
				n_alunos_em_ep n_mulheres_em_ep esgoto


global varlist2008_treated_const rural predio diretoria sala_professores ///
	biblioteca  lab_info  lab_ciencias ///
	quadra_esportes internet lixo_coleta eletricidade ///
	agua 
	 
gen double cod_escola_match_2008 =. 

mahapick $varlist2008_treated, idvar(codigo_escola) treated(d_entrada_2008) ///
	pickids(cod_escola_match_2008) clear genfile($folderservidor\matches_2008.dta) ///
	replace  ///
	nummatches(10) matchon($varlist2008_treated_const) score
	 
	 
	 
	 
			 
/*
********************************************************************************
2009
2009
********************************************************************************
*/
	   
use "$folderservidor\dados_EM_14_v2.dta", clear
* declarando dados como painel
* ano é t e codigo_escola é i

xtset codigo_escola ano 

keep if  ano == 2009 
count if d_entrada_2009 == 1
*76 tratados que entraram em 2009
drop if (pib_capita_reais_real_2015==. | pop==. | rural==.| predio==.| ///
 diretoria==.| sala_professores==.| biblioteca==.| sala_leitura ==.| ///
 lab_info==.| ///
 lab_ciencias==.|quadra_esportes==.|  lixo_coleta==.| eletricidade==. ///
 | agua==.| esgoto==.| n_alunos_em_ep==.| n_mulheres_em_ep==.) ///
 & codigo_escola_2009!=.
 drop if  ice == 0 & enem==.
 count if d_entrada_2009 == 1
* note que a variável refeitório não está resente em 2009
drop ativa
drop if ensino_medio ==0

global varlist2009_treated pib_capita_reais_real_2015 pop   ///
				n_alunos_em_ep n_mulheres_em_ep 


global varlist2009_treated_const rural predio diretoria sala_professores ///
	biblioteca  lab_info  lab_ciencias ///
	quadra_esportes internet lixo_coleta eletricidade ///
	agua esgoto
	 
gen double cod_escola_match_2009 =. 

mahapick $varlist2009_treated, idvar(codigo_escola) treated(d_entrada_2009) ///
	pickids(cod_escola_match_2009) clear genfile($folderservidor\matches_2009.dta) ///
	replace  ///
	nummatches(10) matchon($varlist2009_treated_const) score

	
	
/*
********************************************************************************
2010
2010
********************************************************************************
*/
	   
use "$folderservidor\dados_EM_14_v2.dta", clear
* declarando dados como painel
* ano é t e codigo_escola é i

xtset codigo_escola ano 

keep if  ano == 2010
count if d_entrada_2010 == 1
*65tratados que entraram em 2010
drop if (pib_capita_reais_real_2015==. | pop==. | rural==.| predio==.| ///
 diretoria==.| sala_professores==.| biblioteca==.| sala_leitura ==.| ///
 lab_info==.| ///
 lab_ciencias==.|quadra_esportes==.|  lixo_coleta==.| eletricidade==. ///
 | agua==.| esgoto==.| n_alunos_em_ep==.| n_mulheres_em_ep==.) ///
 & codigo_escola_2010!=.
 drop if  ice == 0 & enem==.
 count if d_entrada_2010 == 1
* note que a variável refeitório não está resente em 2010
drop ativa
drop if ensino_medio ==0

global varlist2010_treated pib_capita_reais_real_2015 pop   ///
				n_alunos_em_ep n_mulheres_em_ep 


global varlist2010_treated_const rural predio diretoria sala_professores ///
	biblioteca  lab_info  lab_ciencias ///
	quadra_esportes internet lixo_coleta eletricidade ///
	agua esgoto
	 
gen double cod_escola_match_2010 =. 

mahapick $varlist2010_treated, idvar(codigo_escola) treated(d_entrada_2010) ///
	pickids(cod_escola_match_2010) clear genfile($folderservidor\matches_2010.dta) ///
	replace  ///
	nummatches(10) matchon($varlist2010_treated_const) score
	
	
	
	

	
/*
********************************************************************************
2011
2011
********************************************************************************
*/
use "$folderservidor\dados_EM_14_v2.dta", clear
* declarando dados como painel
* ano é t e codigo_escola é i

xtset codigo_escola ano    
keep if  ano == 2011
drop if ensino_medio ==0
count if d_entrada_2011 == 1
*32 tratados que entraram em 2011
drop if n_alunos_em_ep ==. & d_entrada_2011 == 1
 *31 tratados 
drop if (pib_capita_reais_real_2015==. | pop==. | rural==.| predio==.| ///
 diretoria==.| sala_professores==.| biblioteca==.| sala_leitura ==.| ///
 lab_info==.| ///
 lab_ciencias==.|quadra_esportes==.|  lixo_coleta==.| eletricidade==. ///
 | agua==.| esgoto==.| n_alunos_em_ep==.| n_mulheres_em_ep==.) ///
 & codigo_escola_2011!=.
 drop if  ice == 0 & enem==.
 count if d_entrada_2011 == 1
 *31 tratados 
* note que a variável refeitório não está resente em 2011


drop ativa


global varlist2011_treated pib_capita_reais_real_2015 pop   ///
				n_alunos_em_ep n_mulheres_em_ep 


global varlist2011_treated_const rural predio diretoria sala_professores ///
	biblioteca  lab_info  lab_ciencias ///
	quadra_esportes internet lixo_coleta eletricidade ///
	agua esgoto
	 
gen double cod_escola_match_2011 =. 

mahapick $varlist2011_treated, idvar(codigo_escola) treated(d_entrada_2011) ///
	pickids(cod_escola_match_2011) clear genfile($folderservidor\matches_2011.dta) ///
	replace  ///
	nummatches(10) matchon($varlist2011_treated_const) score
	
	
	
	
 /*
********************************************************************************
2012	
2012
********************************************************************************
*/	
		
use "$folderservidor\dados_EM_14_v2.dta", clear
* declarando dados como painel
* ano é t e codigo_escola é i

xtset codigo_escola ano    
keep if  ano == 2012
drop if ensino_medio ==0
count if d_entrada_2012 == 1
*75 tratados que entraram em 2012
drop if n_alunos_em_ep ==. & d_entrada_2012 == 1
 
drop if (pib_capita_reais_real_2015==. | pop==. | rural==.| predio==.| ///
 diretoria==.| sala_professores==.| biblioteca==.| sala_leitura ==.| ///
 lab_info==.| ///
 lab_ciencias==.|quadra_esportes==.|  lixo_coleta==.| eletricidade==. ///
 | agua==.| esgoto==.| n_alunos_em_ep==.| n_mulheres_em_ep==.) ///
 & codigo_escola_2012!=.
 drop if  ice == 0 & enem==.
 count if d_entrada_2012 == 1
* 75 tratados 
* note que a variável refeitório não está resente em 2012


drop ativa


global varlist2012_treated pib_capita_reais_real_2015 pop   ///
				n_alunos_em_ep n_mulheres_em_ep 


global varlist2012_treated_const rural predio diretoria sala_professores ///
	biblioteca  lab_info  lab_ciencias ///
	quadra_esportes internet lixo_coleta eletricidade ///
	agua esgoto
	 
gen double cod_escola_match_2012 =. 

mahapick $varlist2012_treated, idvar(codigo_escola) treated(d_entrada_2012) ///
	pickids(cod_escola_match_2012) clear genfile($folderservidor\matches_2012.dta) ///
	replace  ///
	nummatches(10) matchon($varlist2012_treated_const) score
	
		
	
	
	
	
 /*
********************************************************************************
2013	
2013
********************************************************************************
*/	
		
use "$folderservidor\dados_EM_14_v2.dta", clear
* declarando dados como painel
* ano é t e codigo_escola é i

xtset codigo_escola ano    
keep if  ano == 2013
drop if ensino_medio ==0
count if d_entrada_2013 == 1
*116 tratados que entraram em 2013
drop if n_alunos_em_ep ==. & d_entrada_2013 == 1
count if d_entrada_2013 == 1
* 95
 
drop if (pib_capita_reais_real_2015==. | pop==. | rural==.| predio==.| ///
 diretoria==.| sala_professores==.| biblioteca==.| sala_leitura ==.| ///
 lab_info==.| ///
 lab_ciencias==.|quadra_esportes==.|  lixo_coleta==.| eletricidade==. ///
 | agua==.| esgoto==.| n_alunos_em_ep==.| n_mulheres_em_ep==.) ///
 & codigo_escola_2013!=.
 drop if  ice == 0 & enem==.
 count if d_entrada_2013 == 1
* 95 tratados 
* note que a variável refeitório não está resente em 2013


drop ativa


global varlist2013_treated pib_capita_reais_real_2015 pop   ///
				n_alunos_em_ep n_mulheres_em_ep 


global varlist2013_treated_const rural predio diretoria sala_professores ///
	biblioteca  lab_info  lab_ciencias ///
	quadra_esportes internet lixo_coleta eletricidade ///
	agua esgoto
	 
gen double cod_escola_match_2013 =. 

mahapick $varlist2013_treated, idvar(codigo_escola) treated(d_entrada_2013) ///
	pickids(cod_escola_match_2013) clear genfile($folderservidor\matches_2013.dta) ///
	replace  ///
	nummatches(10) matchon($varlist2013_treated_const) score
	
	
 /*
********************************************************************************
2014	
2014
********************************************************************************
*/	
	

		
use "$folderservidor\dados_EM_14_v2.dta", clear
* declarando dados como painel
* ano é t e codigo_escola é i

xtset codigo_escola ano    
keep if  ano == 2014
drop if ensino_medio ==0
count if d_entrada_2014 == 1
*164 tratados que entraram em 2014
drop if n_alunos_em_ep ==. & d_entrada_2014 == 1
count if d_entrada_2014 == 1
*126
 
drop if (pib_capita_reais_real_2015==. | pop==. | rural==.| predio==.| ///
 diretoria==.| sala_professores==.| biblioteca==.| sala_leitura ==.| ///
 lab_info==.| ///
 lab_ciencias==.|quadra_esportes==.|  lixo_coleta==.| eletricidade==. ///
 | agua==.| esgoto==.| n_alunos_em_ep==.| n_mulheres_em_ep==.) ///
 & codigo_escola_2014!=.
 drop if  ice == 0 & enem==.
 count if d_entrada_2014 == 1
*126 tratados 
* note que a variável refeitório não está resente em 2014


drop ativa


global varlist2014_treated pib_capita_reais_real_2015 pop   ///
				n_alunos_em_ep n_mulheres_em_ep 


global varlist2014_treated_const rural predio diretoria sala_professores ///
	biblioteca  lab_info  lab_ciencias sala_leitura ///
	quadra_esportes internet lixo_coleta eletricidade ///
	agua esgoto
	 
gen double cod_escola_match_2014 =. 

mahapick $varlist2014_treated, idvar(codigo_escola) treated(d_entrada_2014) ///
	pickids(cod_escola_match_2014) clear genfile($folderservidor\matches_2014.dta) ///
	replace  ///
	nummatches(10) matchon($varlist2014_treated_const) score
	
	
	
 /*
********************************************************************************
2015	
2015
********************************************************************************
*/	
	

		
use "$folderservidor\dados_EM_14_v2.dta", clear
* declarando dados como painel
* ano é t e codigo_escola é i

xtset codigo_escola ano    
keep if  ano == 2015
drop if ensino_medio ==0
count if d_entrada_2015 == 1
* 77 tratados que entraram em 2015
drop if n_alunos_em_ep ==. & d_entrada_2015 == 1
* por alguma razão, 41 observações são dropadas, e elas são todas de são paulo
* 

count if d_entrada_2015 == 1
* 36
 
drop if (pib_capita_reais_real_2015==. | pop==. | rural==.| predio==.| ///
 diretoria==.| sala_professores==.| biblioteca==.| sala_leitura ==.| ///
 lab_info==.| ///
 lab_ciencias==.|quadra_esportes==.|  lixo_coleta==.| eletricidade==. ///
 | agua==.| esgoto==.| n_alunos_em_ep==.| n_mulheres_em_ep==.) ///
 & codigo_escola_2015!=.
 drop if  ice == 0 & enem==.
 count if d_entrada_2015 == 1
*126 tratados 
* note que a variável refeitório não está resente em 2015


drop ativa


global varlist2015_treated pib_capita_reais_real_2015 pop   ///
				n_alunos_em_ep n_mulheres_em_ep 


global varlist2015_treated_const rural predio diretoria sala_professores ///
	biblioteca sala_leitura refeitorio lab_info  lab_ciencias ///
	quadra_esportes internet lixo_coleta eletricidade ///
	agua esgoto
	 
gen double cod_escola_match_2015 =. 

mahapick $varlist2015_treated, idvar(codigo_escola) treated(d_entrada_2015) ///
	pickids(cod_escola_match_2015) clear genfile($folderservidor\matches_2015.dta) ///
	replace  ///
	nummatches(10) matchon($varlist2015_treated_const) score
	
	
	
/*

criando a amostra controlando por caracterísitcas das escolas
(sem repetição)

*/


use "$folderservidor\matches_2004.dta", clear
keep codigo_escola
count


	
gen ano = .
	gen match = 1
	
expand 12
sort codigo_escola	
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

save "$folderservidor\matches_censo_escolar\2004_final.dta", replace

use "$folderservidor\matches_2005.dta",clear
keep codigo_escola
gen ano=.
gen match=1
* como o ano é 2005, vamos replicar as observações para os proximos anos, 
* até 2015
expand 11
sort codigo_escola	
count 
local a = r(N)
*imputei os anos na mão, escrevendo os primeiros doze anos e depois
*colei para cada codigo de escola
	
	forvalues x = 1(11)`a'{
		
		replace ano = 2005 in `x'
		
	}

		forvalues x = 2(11)`a'{
		
		replace ano = 2006 in `x'
		
	}

	forvalues x = 3(11)`a'{
		
		replace ano = 2007 in `x'
		
	}

	forvalues x = 4(11)`a'{
		
		replace ano = 2008 in `x'
		
	}

	
	forvalues x = 5(11)`a'{
		
		replace ano = 2009 in `x'
		
	}
	forvalues x = 6(11)`a'{
		
		replace ano = 2010 in `x'
		
	}
	forvalues x = 7(11)`a'{
		
		replace ano = 2011 in `x'
		
	}
	forvalues x = 8(11)`a'{
		
		replace ano = 2012 in `x'
		
	}
	forvalues x = 9(11)`a'{
		
		replace ano = 2013 in `x'
		
	}
	forvalues x = 10(11)`a'{
		
		replace ano = 2014 in `x'
		
	}
	
		forvalues x = 11(11)`a'{
		
		replace ano = 2015 in `x'
		
	}


save "$folderservidor\matches_censo_escolar\2005_final.dta", replace
	
use "$folderservidor\matches_2006.dta",clear
keep codigo_escola
count
local num_escolas_2006 = r(N)
di `num_escolas_2006'
gen ano=.
gen match=1
* com o ano é 2006, vamos replicar as observações para os próximos anos,
* até 2015
expand 10
sort codigo_escola
count 
local a = r(N)

	forvalues x = 1(10)`a'{
		
		replace ano = 2006 in `x'
		
	}

		forvalues x = 2(10)`a'{
		
		replace ano = 2007 in `x'
		
	}

	forvalues x = 3(10)`a'{
		
		replace ano = 2008 in `x'
		
	}

	forvalues x = 4(10)`a'{
		
		replace ano = 2009 in `x'
		
	}

	
	forvalues x = 5(10)`a'{
		
		replace ano = 2010 in `x'
		
	}
	forvalues x = 6(10)`a'{
		
		replace ano = 2011 in `x'
		
	}
	forvalues x = 7(10)`a'{
		
		replace ano = 2012 in `x'
		
	}
	forvalues x = 8(10)`a'{
		
		replace ano = 2013 in `x'
		
	}
	forvalues x = 9(10)`a'{
		
		replace ano = 2014 in `x'
		
	}
	forvalues x = 10(10)`a'{
		
		replace ano = 2015 in `x'
		
	}
save "$folderservidor\matches_censo_escolar\2006_final.dta", replace

	
use "$folderservidor\matches_2007.dta",clear
keep codigo_escola
count

gen ano=.
gen match=1
sort codigo_escola

quietly by codigo_escola:  gen dup = cond(_N==1,0,_n)
sort codigo_escola dup
drop if dup ==2
* com o ano é 2007, vamos replicar as observações para os próximos anos,
* até 2015
expand 9
sort codigo_escola
count 
local a = r(N)

	forvalues x = 1(9)`a'{
		
		replace ano = 2007 in `x'
		
	}

		forvalues x = 2(9)`a'{
		
		replace ano = 2008 in `x'
		
	}

	forvalues x = 3(9)`a'{
		
		replace ano = 2009 in `x'
		
	}

	forvalues x = 4(9)`a'{
		
		replace ano = 2010 in `x'
		
	}

	
	forvalues x = 5(9)`a'{
		
		replace ano = 2011 in `x'
		
	}
	forvalues x = 6(9)`a'{
		
		replace ano = 2012 in `x'
		
	}
	forvalues x = 7(9)`a'{
		
		replace ano = 2013 in `x'
		
	}
	forvalues x = 8(9)`a'{
		
		replace ano = 2014 in `x'
		
	}
	forvalues x = 9(9)`a'{
		
		replace ano = 2015 in `x'
		
	}

save "$folderservidor\matches_censo_escolar\2007_final.dta", replace

use "$folderservidor\matches_2008.dta",clear
keep codigo_escola
count

gen ano=.
gen match=1
sort codigo_escola
quietly by codigo_escola:  gen dup = cond(_N==1,0,_n)
sort codigo_escola dup
drop if dup >=2
* com o ano é 2008, vamos replicar as observações para os próximos anos,
* até 2015
expand 8
sort codigo_escola
count 
local a = r(N)

	forvalues x = 1(8)`a'{
		
		replace ano = 2008 in `x'
		
	}

		forvalues x = 2(8)`a'{
		
		replace ano = 2009 in `x'
		
	}

	forvalues x = 3(8)`a'{
		
		replace ano = 2010 in `x'
		
	}

	forvalues x = 4(8)`a'{
		
		replace ano = 2011 in `x'
		
	}

	
	forvalues x = 5(8)`a'{
		
		replace ano = 2012 in `x'
		
	}
	forvalues x = 6(8)`a'{
		
		replace ano = 2013 in `x'
		
	}
	forvalues x = 7(8)`a'{
		
		replace ano = 2014 in `x'
		
	}
	forvalues x = 8(8)`a'{
		
		replace ano = 2015 in `x'
		
	}

save "$folderservidor\matches_censo_escolar\2008_final.dta", replace

use "$folderservidor\matches_2009.dta",clear
keep codigo_escola
count

gen ano=.
gen match=1
sort codigo_escola
quietly by codigo_escola:  gen dup = cond(_N==1,0,_n)
sort codigo_escola dup
drop if dup >=2
* com o ano é 2009, vamos replicar as observações para os próximos anos,
* até 2015
expand 7
sort codigo_escola
count 
local a = r(N)

	forvalues x = 1(7)`a'{
		
		replace ano = 2009 in `x'
		
	}

		forvalues x = 2(7)`a'{
		
		replace ano = 2010 in `x'
		
	}

	forvalues x = 3(7)`a'{
		
		replace ano = 2011 in `x'
		
	}

	forvalues x = 4(7)`a'{
		
		replace ano = 2012 in `x'
		
	}

	
	forvalues x = 5(7)`a'{
		
		replace ano = 2013 in `x'
		
	}
	forvalues x = 6(7)`a'{
		
		replace ano = 2014 in `x'
		
	}
	forvalues x = 7(7)`a'{
		
		replace ano = 2015 in `x'
		
	}

save "$folderservidor\matches_censo_escolar\2009_final.dta", replace

use "$folderservidor\matches_2010.dta",clear
keep codigo_escola
count

gen ano=.
gen match=1
sort codigo_escola
quietly by codigo_escola:  gen dup = cond(_N==1,0,_n)
sort codigo_escola dup
drop if dup >=2
* com o ano é 2010, vamos replicar as observações para os próximos anos,
* até 2015
expand 6
sort codigo_escola
count 
local a = r(N)

	forvalues x = 1(6)`a'{
		
		replace ano = 2010 in `x'
		
	}

		forvalues x = 2(6)`a'{
		
		replace ano = 2011 in `x'
		
	}

	forvalues x = 3(6)`a'{
		
		replace ano = 2012 in `x'
		
	}

	forvalues x = 4(6)`a'{
		
		replace ano = 2013 in `x'
		
	}

	
	forvalues x = 5(6)`a'{
		
		replace ano = 2014 in `x'
		
	}
	forvalues x = 6(6)`a'{
		
		replace ano = 2015 in `x'
		
	}

save "$folderservidor\matches_censo_escolar\2010_final.dta", replace


use "$folderservidor\matches_2011.dta",clear
keep codigo_escola
count

gen ano=.
gen match=1
sort codigo_escola
quietly by codigo_escola:  gen dup = cond(_N==1,0,_n)
sort codigo_escola dup
drop if dup >=2
* com o ano é 2011, vamos replicar as observações para os próximos anos,
* até 2015
expand 5
sort codigo_escola
count 
local a = r(N)

	forvalues x = 1(5)`a'{
		
		replace ano = 2011 in `x'
		
	}

		forvalues x = 2(5)`a'{
		
		replace ano = 2012 in `x'
		
	}

	forvalues x = 3(5)`a'{
		
		replace ano = 2013 in `x'
		
	}

	forvalues x = 4(5)`a'{
		
		replace ano = 2014 in `x'
		
	}

	
	forvalues x = 5(5)`a'{
		
		replace ano = 2015 in `x'
		
	}

save "$folderservidor\matches_censo_escolar\2011_final.dta", replace


use "$folderservidor\matches_2012.dta",clear
keep codigo_escola
count

gen ano=.
gen match=1
sort codigo_escola
quietly by codigo_escola:  gen dup = cond(_N==1,0,_n)
sort codigo_escola dup
drop if dup >=2
* com o ano é 2011, vamos replicar as observações para os próximos anos,
* até 2015
expand 4
sort codigo_escola
count 
local a = r(N)

	forvalues x = 1(4)`a'{
		
		replace ano = 2012 in `x'
		
	}

		forvalues x = 2(4)`a'{
		
		replace ano = 2013 in `x'
		
	}

	forvalues x = 3(4)`a'{
		
		replace ano = 2014 in `x'
		
	}

	forvalues x = 4(4)`a'{
		
		replace ano = 2015 in `x'
		
	}


save "$folderservidor\matches_censo_escolar\2012_final.dta", replace


use "$folderservidor\matches_2013.dta",clear
keep codigo_escola
count

gen ano=.
gen match=1
sort codigo_escola
quietly by codigo_escola:  gen dup = cond(_N==1,0,_n)
sort codigo_escola dup
drop if dup >=2
* com o ano é 2011, vamos replicar as observações para os próximos anos,
* até 2015
expand 3
sort codigo_escola
count 
local a = r(N)

	forvalues x = 1(3)`a'{
		
		replace ano = 2013 in `x'
		
	}

		forvalues x = 2(3)`a'{
		
		replace ano = 2014 in `x'
		
	}

	forvalues x = 3(3)`a'{
		
		replace ano = 2015 in `x'
		
	}



save "$folderservidor\matches_censo_escolar\2013_final.dta", replace


use "$folderservidor\matches_2014.dta",clear
keep codigo_escola
count

gen ano=.
gen match=1
sort codigo_escola
quietly by codigo_escola:  gen dup = cond(_N==1,0,_n)
sort codigo_escola dup
drop if dup >=2
* com o ano é 2011, vamos replicar as observações para os próximos anos,
* até 2015
expand 2
sort codigo_escola
count 
local a = r(N)

	forvalues x = 1(2)`a'{
		
		replace ano = 2014 in `x'
		
	}

		forvalues x = 2(2)`a'{
		
		replace ano = 2015 in `x'
		
	}


save "$folderservidor\matches_censo_escolar\2014_final.dta", replace

use "$folderservidor\matches_2015.dta",clear
keep codigo_escola
count

gen ano=.
gen match=1
sort codigo_escola
quietly by codigo_escola:  gen dup = cond(_N==1,0,_n)
sort codigo_escola dup
drop if dup >=2
replace ano = 2015
save "$folderservidor\matches_censo_escolar\2015_final.dta", replace
use "$folderservidor\matches_censo_escolar\2015_final.dta", replace


append using "$folderservidor\matches_censo_escolar\2014_final.dta"
append using "$folderservidor\matches_censo_escolar\2013_final.dta"
append using "$folderservidor\matches_censo_escolar\2012_final.dta"
append using "$folderservidor\matches_censo_escolar\2011_final.dta"
append using "$folderservidor\matches_censo_escolar\2010_final.dta"
append using "$folderservidor\matches_censo_escolar\2009_final.dta"
append using "$folderservidor\matches_censo_escolar\2008_final.dta"
append using "$folderservidor\matches_censo_escolar\2007_final.dta"
append using "$folderservidor\matches_censo_escolar\2006_final.dta"
append using "$folderservidor\matches_censo_escolar\2005_final.dta"
append using "$folderservidor\matches_censo_escolar\2004_final.dta"

drop dup
quietly by codigo_escola ano:  gen dup = cond(_N==1,0,_n)
drop if dup >=2



merge 1:m codigo_escola ano using "$folderservidor\dados_EM_14_v2.dta"


keep if match ==1
keep if _m == 3


save "$folderservidor\dados_EM_par_cen_esc.dta", replace

