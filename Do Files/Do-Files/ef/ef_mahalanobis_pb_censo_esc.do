sysdir set PLUS \\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\ado
*sysdir set PLUS \\fs-eesp-01\EESP\Usuarios\bruna.mirelle\makoto\ado
clear all
set more off, permanently

capture log close

global folderservidor "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"
global user "`:environment USERPROFILE'"
global Folder "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"
global output "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\resultados_v3"
global Bases "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"
global dofiles "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\Do-Files"
global Logfolder "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\logfiles"




/*
mahalanobis matching
usando variáveis do censo e da prova brasil

*/

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
log using "$Logfolder/ef_mahalanobis_pb_censo_esc.log", replace

use "$folderservidor\dados_EF_14_v2.dta", clear


gen ano_ice_impar =.

replace ano_ice_impar = ano_ice if mod(ano_ice,2)==1
replace ano_ice_impar = ano_ice - 1 if mod(ano_ice,2)==0
order ano_ice_impar, after(ano_ice)
xtset codigo_escola ano_prova_brasil

keep if pb==1
*DV indica quando a escola entrou na base
*como mantemos somente as escolas que participaram da prova brasil
* então DV indicará quando a escola apareceu pela primeira vez na 
* base da prova brasil
gen DV = 0
bysort codigo_escola (ano): replace DV = 1 if _n == 1
order DV, after(codigo_escola)
sort ano_ice codigo_escola ano  



save "$folderservidor\dados_EF_14_pb_only.dta",replace


/*
(A) PAREANDO ESCOLAS TRATADAS ASSIM QUE ELAS APARECEM COM 
INFORMAÇÕES DA PROVA BRASIL
*/
/*
********************************************************************************
2007
2007
********************************************************************************
*/
use "$folderservidor\dados_EF_14_pb_only.dta", clear
xtset codigo_escola ano_prova_brasil
keep if ano == 2007
gen double cod_escola_match_2007 =.
global varlist_censo2007 pib_capita_reais_real_2015 pop   ///
				n_salas_utilizadas n_turmas_ef n_alunos_ef ///
				n_mulheres_ef n_brancos_ef
global varlist_censo2007_const rural predio diretoria sala_professores ///
	biblioteca 	sala_leitura  lab_info  lab_ciencias ///
	quadra_esportes internet lixo_coleta eletricidade ///
	agua esgoto
	
global varlist_pb2007 pb_esc_sup_mae_9 pb_esc_sup_pai_9 ///
	media_pb_9_std apr_ef_std aba_ef_std dist_ef_std

gen ice_pb_2007 = 0
replace ice_pb_2007 =1 if DV==1 & ice ==1

mahapick $varlist_censo2007  $varlist_pb2007, ///
	idvar(codigo_escola) treated(ice_pb_2007 ) ///
	pickids(cod_escola_match_2007) clear ///
	genfile($folderservidor\matches_pb_2007.dta) replace  ///
	nummatches(10) matchon($varlist2007_treated_const) score
/*
********************************************************************************
2009
2009
********************************************************************************
*/
use "$folderservidor\dados_EF_14_pb_only.dta", clear
xtset codigo_escola ano_prova_brasil
keep if ano == 2009
gen double cod_escola_match_2009 =.
global varlist_censo2009 pib_capita_reais_real_2015 pop   ///
				n_salas_utilizadas n_turmas_ef n_alunos_ef ///
				n_mulheres_ef n_brancos_ef
global varlist_censo2009_const rural predio diretoria sala_professores ///
	biblioteca 	sala_leitura  lab_info  lab_ciencias ///
	quadra_esportes internet lixo_coleta eletricidade ///
	agua esgoto
	
global varlist_pb2009 pb_esc_sup_mae_9 pb_esc_sup_pai_9 ///
	media_pb_9_std  ///
	apr_ef_std aba_ef_std dist_ef_std

gen ice_pb_2009 = 0
replace ice_pb_2009 =1 if DV==1 & ice ==1

mahapick $varlist_censo2009  $varlist_pb2009, ///
	idvar(codigo_escola) treated(ice_pb_2009 ) ///
	pickids(cod_escola_match_2009) clear ///
	genfile($folderservidor\matches_pb_2009.dta) replace  ///
	nummatches(10) matchon($varlist2009_treated_const) score	
	
	
/*
********************************************************************************
2011
2011
********************************************************************************
*/

use "$folderservidor\dados_EF_14_pb_only.dta", clear

xtset codigo_escola ano_prova_brasil
keep if ano == 2011

gen double cod_escola_match_2011 =.
global varlist_censo2011 pib_capita_reais_real_2015 pop   ///
				n_salas_utilizadas n_turmas_ef n_alunos_ef ///
				n_mulheres_ef n_brancos_ef


global varlist_censo2011_const rural predio diretoria sala_professores ///
	biblioteca 	sala_leitura  lab_info  lab_ciencias ///
	quadra_esportes internet lixo_coleta eletricidade ///
	agua esgoto
* aqui, todas as escolas que entraram na base da prova brasil 
* e receberam ou receberão o programa
* recebra, o programa em 2013 ou posteriormente
global varlist_pb2011  pb_esc_sup_mae_9 pb_esc_sup_pai_9 ///
	media_pb_9_std  ///
	apr_ef_std aba_ef_std dist_ef_std


gen ice_pb_2011 = 0
replace ice_pb_2011 =1 if DV==1 & ice ==1


mahapick $varlist_censo2011  $varlist_pb2011, ///
	idvar(codigo_escola) treated(ice_pb_2011 ) ///
	pickids(cod_escola_match_2011) clear ///
	genfile($folderservidor\matches_pb_2011.dta) replace  ///
	nummatches(10) matchon($varlist2011_treated_const) score	
/*
********************************************************************************
2013
2013
********************************************************************************
*/
	

use "$folderservidor\dados_EF_14_pb_only.dta", clear

xtset codigo_escola ano_prova_brasil
keep if ano == 2013

gen double cod_escola_match_2013 =.
global varlist_censo2013 pib_capita_reais_real_2015 pop   ///
				n_salas_utilizadas n_turmas_ef n_alunos_ef ///
				n_mulheres_ef n_brancos_ef


global varlist_censo2013_const rural predio diretoria sala_professores ///
	biblioteca 	sala_leitura  lab_info  lab_ciencias ///
	quadra_esportes internet lixo_coleta eletricidade ///
	agua esgoto
* em 2013 das escolas que entraram na base da prova brasil nesse ano
* também entraram no programa, há algumas que entraram no programa ou em
* 2012 ou em 2013. então para o pareamento, não usaremos as variáveis 
* de outcome. podemos usar as informações de fluxo de dois anos atrás
global varlist_pb2013  pb_esc_sup_mae_9 pb_esc_sup_pai_9 ///


gen ice_pb_2013 = 0
replace ice_pb_2013 =1 if DV==1 & ice ==1


mahapick $varlist_censo2013  $varlist_pb2013, ///
	idvar(codigo_escola) treated(ice_pb_2013 ) ///
	pickids(cod_escola_match_2013) clear ///
	genfile($folderservidor\matches_pb_2013.dta) replace  //
	
	
/*
********************************************************************************
2015
2015
********************************************************************************
*/
	

use "$folderservidor\dados_EF_14_pb_only.dta", clear

xtset codigo_escola ano_prova_brasil
keep if ano == 2015

gen double cod_escola_match_2015 =.
global varlist_censo2015 pib_capita_reais_real_2015 pop   ///
				n_salas_utilizadas n_turmas_ef n_alunos_ef ///
				n_mulheres_ef n_brancos_ef


global varlist_censo2015_const rural predio diretoria sala_professores ///
	biblioteca 	sala_leitura  lab_info  lab_ciencias ///
	quadra_esportes internet lixo_coleta eletricidade ///
	agua esgoto
* em 2015 das escolas que entraram na base da prova brasil nesse ano
* também entraram no programa, há algumas que entraram no programa ou em
* 2012 ou em 2015. então para o pareamento, não usaremos as variáveis 
* de outcome. podemos usar as informações de fluxo de dois anos atrás
global varlist_pb2015  pb_esc_sup_mae_9 pb_esc_sup_pai_9 ///



gen ice_pb_2015 = 0
replace ice_pb_2015 =1 if DV==1 & ice ==1


mahapick $varlist_censo2015  $varlist_pb2015, ///
	idvar(codigo_escola) treated(ice_pb_2015 ) ///
	pickids(cod_escola_match_2015) clear ///
	genfile($folderservidor\matches_pb_2015.dta) replace  //
	
	
use "$folderservidor\matches_pb_2007.dta",clear
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

save "$folderservidor\matches_censo_escolar\2007_pb_final.dta", replace


use "$folderservidor\matches_pb_2009.dta",clear
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

save "$folderservidor\matches_censo_escolar\2009_pb_final.dta", replace


use "$folderservidor\matches_pb_2011.dta",clear
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

save "$folderservidor\matches_censo_escolar\2011_pb_final.dta", replace

use "$folderservidor\matches_pb_2013.dta",clear
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



save "$folderservidor\matches_censo_escolar\2013_pb_final.dta", replace

use "$folderservidor\matches_pb_2015.dta",clear
keep codigo_escola
count

gen ano=.
gen match=1
sort codigo_escola
quietly by codigo_escola:  gen dup = cond(_N==1,0,_n)
sort codigo_escola dup
drop if dup >=2
replace ano = 2015
save "$folderservidor\matches_censo_escolar\2015_pb_final.dta", replace
use "$folderservidor\matches_censo_escolar\2015_pb_final.dta", replace


append using "$folderservidor\matches_censo_escolar\2013_pb_final.dta"
append using "$folderservidor\matches_censo_escolar\2011_pb_final.dta"
append using "$folderservidor\matches_censo_escolar\2009_pb_final.dta"
append using "$folderservidor\matches_censo_escolar\2007_pb_final.dta"


drop dup
sort codigo_escola ano
quietly by codigo_escola ano:  gen dup = cond(_N==1,0,_n)
drop if dup >=2

merge 1:m codigo_escola ano using "$folderservidor\dados_EF_14_pb_only.dta"


keep if match ==1
keep if _m == 3


save "$folderservidor\dados_EF_par_cen_esc_pb.dta", replace



























