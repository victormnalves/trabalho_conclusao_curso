cd "\\Egaibz094\ice\Dados ICE\"
use ice_clean.dta, clear
keep if ano==2007|ano==2014

*Balancear
gen i2007 =   ano==2007
egen ap2007= max(i2007), by(codigo_escola)
gen i2014 =   ano==2014
egen ap2014= max(i2014), by(codigo_escola)

gen indicador = min(  ap2007, ap2014)
drop if ind == 0
drop if enem_nota_objetivab_std==.

xtset codigo_escola ano

*Quem participa do programa
keep if ice==1
rename enem_nota_objetivab_std nota_enem
*Regressoes
foreach x in "nota_enem"  /*"apr_em_std" "rep_em_std" "aba_em_std" "dist_em_std"*/ {
gen aux_d_`x'=`x'-L7.`x'
egen delta_`x'=max(aux_d_`x'), by(codigo_escola)
reg `x' rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet if ano==2014
predict res_`x'_2014, res
reg `x' rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet if ano==2007
predict res_`x'_2007, res
xtreg `x' rural agua eletricidade esgoto lixo_coleta sala_professores lab_info lab_ciencias quadra_esportes biblioteca   internet , fe
predict res_`x'_d, res

sum res_`x'_2007 if ano==2007, d
scalar m_res_`x'_2007=r(p50)
gen menor_res_`x'_2007=1 if res_`x'_2007<m_res_`x'_2007 & ano==2007

sum res_`x'_2014 if ano==2014, d
scalar m_res_`x'_2014=r(p50)
gen menor_res_`x'_2014=1 if res_`x'_2014<m_res_`x'_2014 & ano==2014

sum res_`x'_d, d
scalar m_res_`x'_d=r(p50)
gen menor_res_`x'_d=1 if res_`x'_2014<m_res_`x'_2014 

}

tab nome_escola if menor_res_nota_enem_2007==1&menor_res_nota_enem_d==1
tab nome_escola if menor_res_nota_enem_2007==1&menor_res_nota_enem_d!=1
tab nome_escola if menor_res_nota_enem_2007!=1&menor_res_nota_enem_d==1
tab nome_escola if menor_res_nota_enem_2007!=1&menor_res_nota_enem_d!=1





*Graficos 2007
*foreach x in "res_enem_nota_objetivab_std"  /*"res_apr_em_std" "res_rep_em_std" "res_aba_em_std" "res_dist_em_std"*/ {
*Todas sem label
scatter res_nota_enem_d res_nota_enem_2007 if ano==2007, ///
xline(-.1677525) /// ATUALIZAR ESSE VALOR
yline( -.0425497) ///
title("Nota Objetiva Enem")                              /// Graph title  
xtitle("Resíduo 2007")                                                               /// X-axis title
ytitle("Resíduo Delta Nota")                                            // Y-axis title  
graph export res_nota_enem_todossemlabel_2007.png, as(png) replace

*Mediana inferior em 2007 e inferior no delta
scatter res_nota_enem_d res_nota_enem_2007 if ano==2007&(menor_res_nota_enem_2007==1&menor_res_nota_enem_d==1), ///
title("Nota Objetiva Enem")                              /// Graph title  
subtitle("Mediana Inferior em 2007 e Inferior no crescimento")                             /// Graph subtitle 
xtitle("Resíduo 2007")                                                               /// X-axis title
ytitle("Resíduo Delta Nota")                                            /// Y-axis title  
mlabel(nome_escola) /// nome das escola
mlabposition(5) ///
mlabs(tiny) // tamanho da letra
graph export res_nota_enem_inf_inf_2007.png, as(png) replace

*Mediana inferior em 2007 e superior no delta
scatter res_nota_enem_d res_nota_enem_2007 if ano==2007&(menor_res_nota_enem_2007==1&menor_res_nota_enem_d!=1), ///
title("Nota Objetiva Enem")                              /// Graph title  
subtitle("Mediana Inferior em 2007 e Superior no crescimento")                             /// Graph subtitle 
xtitle("Resíduo 2007")                                                               /// X-axis title
ytitle("Resíduo Delta Nota")                                            /// Y-axis title  
mlabel(nome_escola) ///
mlabposition(7) ///
mlabs(tiny)
graph export res_nota_enem_inf_sup_2007.png, as(png) replace

*Mediana superior em 2007 e inferior no delta
scatter res_nota_enem_d res_nota_enem_2007 if ano==2007&(menor_res_nota_enem_2007!=1&menor_res_nota_enem_d==1), ///
title("Nota Objetiva Enem")                              /// Graph title  
subtitle("Mediana Superior em 2007 e Inferior no crescimento")                             /// Graph subtitle 
xtitle("Resíduo 2007")                                                               /// X-axis title
ytitle("Resíduo Delta Nota")                                            /// Y-axis title  
mlabel(nome_escola) ///
mlabposition(4) ///	posicao da label
mlabs(tiny)
graph export res_nota_enem_sup_inf_2007.png, as(png) replace

*Mediana superior em 2007 e superior no delta
scatter res_nota_enem_d res_nota_enem_2007 if ano==2007&(menor_res_nota_enem_2007!=1&menor_res_nota_enem_d!=1), ///
title("Nota Objetiva Enem")                              /// Graph title  
subtitle("Mediana Superior em 2007 e Superior no crescimento")                             /// Graph subtitle 
xtitle("Resíduo 2007")                                                               /// X-axis title
ytitle("Resíduo Delta Nota")                                            /// Y-axis title  
mlabel(nome_escola) ///
mlabposition(9) ///
mlabs(tiny)
graph export res_nota_enem_sup_sup_2007.png, as(png) replace


*Graficos 2014
*foreach x in "res_enem_nota_objetivab_std"  /*"res_apr_em_std" "res_rep_em_std" "res_aba_em_std" "res_dist_em_std"*/ {
*Todas sem label
scatter res_enem_nota_objetivab_std_d res_enem_nota_objetivab_std_2014 if ano==2014, ///
xline(-.1677525) /// ATUALIZAR ESSE VALOR PARA 2014
yline( -.0425497) ///
title("Nota Objetiva Enem")                              /// Graph title  
xtitle("Resíduo 2014")                                                               /// X-axis title
ytitle("Resíduo Delta Nota")                                            // Y-axis title  
graph export res_enem_nota_objetivab_std_todossemlabel_2014.png, as(png) replace

*Mediana inferior em 2014 e inferior no delta
scatter res_enem_nota_objetivab_std_d res_enem_nota_objetivab_std_2014 if ano==2014&(menor_2014==1&menor_d==1), ///
title("Nota Objetiva Enem")                              /// Graph title  
subtitle("Mediana Inferior em 2014 e Inferior no crescimento")                             /// Graph subtitle 
xtitle("Resíduo 2014")                                                               /// X-axis title
ytitle("Resíduo Delta Nota")                                            /// Y-axis title  
mlabel(nome_escola) /// nome das escola
mlabposition(5) ///
mlabs(tiny) // tamanho da letra
graph export res_enem_nota_objetivab_std_inf_inf_2014.png, as(png) replace

*Mediana inferior em 2014 e superior no delta
scatter res_enem_nota_objetivab_std_d res_enem_nota_objetivab_std_2014 if ano==2014&(menor_2014==1&menor_d!=1), ///
title("Nota Objetiva Enem")                              /// Graph title  
subtitle("Mediana Inferior em 2014 e Superior no crescimento")                             /// Graph subtitle 
xtitle("Resíduo 2014")                                                               /// X-axis title
ytitle("Resíduo Delta Nota")                                            /// Y-axis title  
mlabel(nome_escola) ///
mlabposition(7) ///
mlabs(tiny)
graph export res_enem_nota_objetivab_std_inf_sup_2014.png, as(png) replace

*Mediana superior em 2014 e inferior no delta
scatter res_enem_nota_objetivab_std_d res_enem_nota_objetivab_std_2014 if ano==2014&(menor_2014!=1&menor_d==1), ///
title("Nota Objetiva Enem")                              /// Graph title  
subtitle("Mediana Superior em 2014 e Inferior no crescimento")                             /// Graph subtitle 
xtitle("Resíduo 2014")                                                               /// X-axis title
ytitle("Resíduo Delta Nota")                                            /// Y-axis title  
mlabel(nome_escola) ///
mlabposition(4) ///	posicao da label
mlabs(tiny)
graph export res_enem_nota_objetivab_std_sup_inf_2014.png, as(png) replace

*Mediana superior em 2014 e superior no delta
scatter res_enem_nota_objetivab_std_d res_enem_nota_objetivab_std_2014 if ano==2014&(menor_2014!=1&menor_d!=1), ///
title("Nota Objetiva Enem")                              /// Graph title  
subtitle("Mediana Superior em 2014 e Superior no crescimento")                             /// Graph subtitle 
xtitle("Resíduo 2014")                                                               /// X-axis title
ytitle("Resíduo Delta Nota")                                            /// Y-axis title  
mlabel(nome_escola) ///
mlabposition(9) ///
mlabs(tiny)
graph export res_enem_nota_objetivab_std_sup_sup_2014.png, as(png) replace

