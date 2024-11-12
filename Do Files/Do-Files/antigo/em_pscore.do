/*---------------------------- Propensity Score ---------------------------*/
/*
do file que gera os propensity scores e transforma em pesos para serem usados
na regressão em painel
*/

/*
como o tratamento não é aleatório, precisamos usar alguma metodologia para fazer 
a análise do programa. Aqui, vamos calcular os propensity scores, para fazer 
regressões em painel ponderadas
*/

set matsize 10000

/*
geraremos um pscore, ie, a probabilidade condicional de receber o tratamento, 
dado características predeterminadas
no nosso caso, será estimada a probabilidade cond de determinada
escola receber tratamento ice, dado o número de alunos

pscore treatment [varlist] [weight] [if exp] [in range] , pscore(newvar) [ 
blockid(newvar) detail logit comsup level(#) numblo(#) ]
ver https://www.stata-journal.com/sjpdf.html?articlenum=st0026
*/

/*
gerando um pscore para cada escola, por estado
probabilidade de ser tratado dado número de alunos no ensino médio e taxa de participação
gerando para cada estado
aqui, condicional em numero de alunos e taxa de participação de alunos, a participação do ice é 
independente
*/
pscore ice n_alunos_em taxa_participacao_enem  if ano==2003&codigo_uf==26&dep!=4, pscore(pscores_pe)

pscore ice n_alunos_em_ep taxa_participacao_enem  if ano==2007&codigo_uf==23&dep!=4, pscore(pscores_ce)

*pscore ice n_alunos_ef  if ano==2010&codigo_uf==33&dep!=4, pscore(pscores_rj)

pscore ice n_alunos_em taxa_participacao_enem   if ano==2011&codigo_uf==35&dep!=4, pscore(pscores_sp)

pscore ice n_alunos_em taxa_participacao_enem if ano==2012&codigo_uf==52&dep!=4, pscore(pscores_go)

gen pscore_total=.

/*
probabilidade de ser tratado é 1 se foi tratado
*/

replace pscore_total = 1 if ice == 1

/*o propensity score de cada escola em cada ano vai ser um um peso com base no 
propensity score criado anteriormente*/

replace pscore_total=1/(1-pscores_pe) if codigo_uf==26&dep!=4&ice==0

replace pscore_total=1/(1-pscores_ce) if codigo_uf==23&dep!=4&ice==0

*replace pscore_total=1/(1-pscores_rj) if codigo_uf==33&dep!=4&ice==0

replace pscore_total=1/(1-pscores_sp) if codigo_uf==35&dep!=4&ice==0

replace pscore_total=1/(1-pscores_go) if codigo_uf==52&dep!=4&ice==0

*For each category of codigo_escola, generate pscore_total_aux = maximo do pscore_total
*sort arranges the observations of the current data into ascending order
/*
aqui, o propesnity score de cada escola tem que ser equalizado para rodar
o xtreg. isto é, cada escola, ao longo dos anos, tem que ter o mesmo pscore
assim, o max do pscore ao longo dos anos é atribuído como pscore da escola
*/

bysort codigo_escola: egen pscore_total_aux = max(pscore_total)
replace pscore_total = pscore_total_aux

/*
In -xt- analyses, the weight must be constant within panels
o pscore_total será usado como peso weight no xtreg 
*/
