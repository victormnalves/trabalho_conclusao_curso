/*----------------------Intera��es de turno e Alavanca-----------------------*/


/*dummy ice integral*/
*vari�vei que indica se escola em um dado ano  participou do ICE integral
gen ice_inte=0
replace ice_inte=1 if ice_jornada=="INTEGRAL" 
replace ice_inte=1 if ice_jornada=="Integral" 

/*dummy ice semi-integral*/
*vari�vei que indica se escola em um dado ano participou do ICE semi-integral
gen ice_semi_inte=0
replace ice_semi_inte=1 if ice_jornada=="Semi-integral"
replace ice_semi_inte=1 if ice_jornada=="SEMI-INTEGRAL"

/*lembrando d_ice � a dummy de ano de entrada do ICE*/

/*dummy intera��o ice e integral*/
*vari�vel que indica se escola em um dado ano entrou no programa
*na modalidade integral
gen d_ice_inte=d_ice*ice_inte

/*dummy intera��o ice e semi-integral*/
*vari�vel que indica se escola em um dado ano entrou no programa
*na modalidade semi-integral
gen d_ice_semi_inte=d_ice*ice_semi_inte

/*colocando zero nos missings nas dummies de alavancas*/
foreach x in "al_engaj_gov" "al_engaj_sec" "al_time_seduc" "al_marcos_lei" "al_todos_marcos" "al_sel_dir" "al_sel_prof" "al_proj_vida" {
replace `x'=0 if `x'==.
}

/*gerando as intera��es en a dummy ice e dummies de alavanca*/
gen al_outros=0
replace al_outros=1 if (al_engaj_gov==1|al_time_seduc==1|al_marcos_lei==1|al_proj_vida==1)

*vari�vel que indica se escola, quando entrou no programa: 

*teve bom engajamento do governador
gen d_ice_al1=d_ice*al_engaj_gov

*teve bom engajamento do secret�rio de educa��o
gen d_ice_al2=d_ice*al_engaj_sec

*tinha time da SEDUC deducado para a implanta��o do programa
gen d_ice_al3=d_ice*al_time_seduc

*teve implanta��o dos marcos legais na forma da Lei?
gen d_ice_al4=d_ice*al_marcos_lei

*teve Implanta��o de todos os marcos legais previstos no cronograma estipulado?
gen d_ice_al5=d_ice*al_todos_marcos

*teve Implanta��o do processo de sele��o e remo��o de diretores?
gen d_ice_al6=d_ice*al_sel_dir

*teve Implanta��o do processo de sele��o e remo��o de professores?
gen d_ice_al7=d_ice*al_sel_prof

*teve Implanta��o do projeto de vida na Matriz Curricular?
gen d_ice_al8=d_ice*al_proj_vida
gen d_ice_al9=d_ice*al_outros
