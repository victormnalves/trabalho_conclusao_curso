/*

--------------------- Propensity Score  - Ensino Médio --------------------

*/

/*
O objetivo é obter estimativas do propensity score  que balanceie as 
covariadas, isto é, que entre subamostras com valores similares de 
propensity scores, a distribuição de covariadas entre tratados deve 
ser similar a distribuição de covariadas entre controle.
*/

/*
1. Espeficicação de um modelo inicial

especificação de um modelo inicial, baseado em conhecimento substativo

isso pode incluir covariadas que a priori são vistas importantes para a 
atribuição do tratamento, que são possívelmente relacionadas com algumas 
medidas de outcome, ou que a priori são consideradas associadas fortemente
com os outcomes


*/

/*
Na base de dados do ensino médio dados_EM_14_v1.dta, 
temos as seguintes variáveis:

codigo_esc~a  enem_~va_std  n_alunos~m_1  n_alunos_e~4  fund_8_anos   ice_not~2007  ~o_semi_inte  d_uf3
ano           enem_n~b_std  n_alunos~m_2  n_alunos_e~s  fund_9_anos   ice_not~2008  ~a_semi_inte  d_uf4
ano_enem      enem_n~o_std  n_alunos~m_3  n_mulher~e_1  distrito_e~o  ice_not~2009  al_outros     d_uf5
cod_munic     enem_~ca_std  p_mulheres~1  n_mulher~e_2  n_turmas~e_1  ice_not~2010  d_ice_not~l1  d_uf6
codigo_mu~go  enem~ias_std  p_mulheres~2  n_mulher~e_3  n_turmas~e_2  ice_not~2011  d_ice_flu~l1  d_ano1
cod_meso      enem~nas_std  p_mulheres~3  n_mulher~e_4  al_engaj_gov  ice_not~2012  d_ice_not~l2  d_ano2
nome_munic~o  enem_~ns_std  n_branco~m_1  n_mulhe~e_ns  al_engaj_sec  ice_not~2013  d_ice_flu~l2  d_ano3
codigo_uf     apr_em_std    n_branco~m_2  n_branco~e_1  al_time_se~c  ice_not~2014  d_ice_not~l3  d_ano4
estado        rep_em_std    n_branco~m_3  n_branco~e_2  al_marcos_~i  ice_not~2015  d_ice_flu~l3  d_ano5
pib           aba_em_std    p_brancos_~1  n_branco~e_3  al_todos_m~s  ice_flu~2004  d_ice_not~l4  d_ano6
pop           dist_em_std   p_brancos_~2  n_brancos_~4  al_sel_dir    ice_flu~2005  d_ice_flu~l4  d_ano7
pib_capita~s  dependenci~a  p_brancos_~3  n_brancos_~s  al_sel_prof   ice_flu~2006  d_ice_nota~5  d_ano8
pib_cap~2003  n_profs_em~g  nome_escola   n_alu_tr~e_1  al_proj_vida  ice_flu~2007  d_ice_flux~5  d_ano9
pib_cap~2015  n_mulher~m_1  codigo_mu~vo  n_alu_tr~e_2  ensino_fun~l  ice_flu~2008  d_ice_nota~6  d_ano10
concluir_e~m  n_mulher~m_2  n_salas_exis  n_alu_tr~e_3  ice           ice_flu~2009  d_ice_flux~6  d_ano11
e_mora_mai~s  n_mulher~m_3  regular       n_alu_tran~4  ice_2004      ice_flu~2010  d_ice_nota~7  d_ano12
e_escol_su~i  n_mulher~m_4  em_integrado  n_alu_tran~s  ice_2005      ice_flu~2011  d_ice_flux~7  d_ano13
e_escol_su~e  n_mulhe~m_ns  em_normal     n_profs_em_1  ice_2006      ice_flu~2012  d_ice_nota~8  n_alunos_em
e_renda_fa~s  rural         n_turmas~m_1  n_profs_em_2  ice_2007      ice_flu~2013  d_ice_flux~8  n_mulheres~m
e_trabalho~u  ativa         n_turmas~m_2  n_profs_em_3  ice_2008      ice_flu~2014  d_ice_nota~9  n_brancos_em
enem_nota~va  em            n_turmas~m_3  n_pro~p_em_1  ice_2009      ice_flu~2015  d_ice_flux~9  n_alunos_ep
enem_nota~ca  em_prof       n_turmas~e_3  n_pro~p_em_2  ice_2010      d_ice_fluxo   d_ice_not~p1  n_mulhe~s_ep
enem_nota~ns  predio        n_turmas_e~4  n_pro~p_em_3  ice_2011      d_ice_nota    d_ice_flu~p1  n_brancos_ep
enem_not~nas  diretoria     n_turmas_e~s  p_profs_su~1  ice_2012      d_rigor1      d_ice_not~p2  n_aluno~m_ep
enem_not~ias  sala_profe~s  n_alu_tr~m_1  p_profs_su~2  ice_2013      d_rigor2      d_ice_flu~p2  n_mulhe~m_ep
enem_nota_~o  biblioteca    n_alu_tr~m_2  p_profs_su~3  ice_2014      d_rigor3      d_ice_not~p3  n_branc~m_ep
apr_ef        sala_leitura  n_alu_tr~m_3  n_profs_em..  ice_2015      d_rigor4      d_ice_flu~p3  taxa_parti~x
apr_em        refeitorio    m_idade_em_1  n_profs_em..  integral      d_segmento1   d_ice_not~p4  taxa_parti~2
rep_ef        lab_info      m_idade_em_2  n_profs_em..  ensino_medio  d_segmento2   d_ice_flu~p4  taxa_parti~m
rep_em        lab_ciencias  m_idade_em_3  n_profs_em~4  comp_polit~o  d_segmento3   mais_educ
aba_ef        quadra_esp~s  p_alu_tran~1  n_profs_em~s  comp_selec~o  d_segmento4   d_dep1
aba_em        internet      p_alu_tran~2  ~p_em_inte_1  comp_eng_e~o  d_segmento5   d_dep2
dist_ef       lixo_coleta   p_alu_tran~3  ~p_em_inte_2  comp_proj_~o  ice_inte      d_dep3
dist_em       eletricidade  n_alunos~e_1  ~p_em_inte_3  ice_not~2004  ice_semi_i~e  d_dep4
em_fluxo      agua          n_alunos~e_2  n_profs_su~4  ice_not~2005  d_ice~o_inte  d_uf1
enem_nota_~b  esgoto        n_alunos~e_3  n_profs_su~s  ice_not~2006  d_ice~a_inte  d_uf2

primeiramente, vamos escolher dessa lista as variáveis básicas,
isto é, variáveis que são importantes para a atribuição do tratamento;
variáveis que são possivelmente relacionadas com alguma medida de outcome;
ou então variáveis que são a priori consideradas associadas fortemente com os
outcomes.

* predio 
* diretoria 
* sala_professores 
* biblioteca 
* internet 
* lixo_coleta
* eletricidade 
* agua 
* esgoto
* n_alunos_em_1
* são variáveis presentes 
* em todos anos, com poucos missings

* p_mulheres_em_1
* são variáveis presentes, mas com uma taxa relativamente alta de
* missings

* sala de leitura 
* não está presente nos anos de 2007 e 2008

* refeitório 
* não está presente nos anos de 2007 a 2011

* n_brancos_em_1  
* p_brancos_em_1 
* não está presente nos anos de 2003 e 2004

* n_salas_exis  
* regular 
* em_integrado  
* em_normal
* n_turmas_em_1 
* n_alu_transporte_publico_em_1 
* m_idade_em_1*
* p_alu_transporte_publico_em_1 
* n_alunos_em_inte_1
* n_mulheres_em_inte_1 
* n_brancos_em_inte_1
* n_profs_em_1 
* n_profs_sup_em_1 
* p_profs_sup_em_1
* n_profs_em_inte_1 
* n_profs_sup_em_inte_1
* não está presente nos anos de 2003 a 2006 
* muitas das variáveis não estão presentes no pré 2007 pois em 2007 o INEP
* implementou o educacenso, um sistema onde as próprias escolas imputavam as 
* informações, permitindo a desagregação por aluno

Note que a partir de 2007 o educacenso foi implementado, então algumas variáveis
só estão presentes a partir dessa data.
Logo, existe um trade off claro entre colocar mais variáveis e ter menos observações
ao longo do tempo e ter menos variáveis ao longo de mais anos.

Assim, vamos dividir a análise principal em várias análises, com mais e menos covariadas,
com menos e mais anos.

Inicialmente, vamos focar no caso com menos covariadas, mas com observações em 
todos os anos, ie, de 2003 a 2015

pela base de dados do censo escolar, temos que as seguintes variáveis estão em 
todos os anos
* predio 
* diretoria 
* sala_professores 
* biblioteca 
* internet 
* lixo_coleta
* eletricidade 
* agua 
* esgoto
* n_alunos_em_1
* n_mulheres
(n_alunos_em, n_alunos_ep)
* são variáveis presentes 
* em todos anos, com poucos missings

* p_mulheres_em_1
(p_mulheres_em)
(são variáveis presentes, mas com uma taxa relativamente alta de missings)

pela base do enem, as seguintes variáveis estão presentes em todos os anos
e_mora_mais_de_6_pessoas 
e_escol_sup_pai 
e_escol_sup_mae 
e_renda_familia_5_salarios 
e_trabalhou_ou_procurou


pib_capita_reais_real_2015 está presente em todos os anos
dependencia_administrativa
d_dep1
d_dep2
d_dep3

está presente em todas ons anos

obs.: 
d_dep1 indica se a escola é federal
d_dep2 indica se a escola é estadual
d_dep3 indica se a escola é municipal
d_dep4 indica se a escola é privada

rural 
ativa



outcomes:
enem_nota_objetiva_std 
enem_nota_objetivab_std 
enem_nota_redacao_std 
enem_nota_matematica_std 
enem_nota_ciencias_std 
enem_nota_humanas_std 
enem_nota_linguagens_std 
apr_em_std 
rep_em_std 
aba_em_std 
dist_em_std


A atribuição do tratamento não é aleatória. O programa é voltado para escolas com
determinadas características:
se a escola é pública ou não
infraestrutura presente na escola
número de alunos
característica média dos alunos da escola

de forma análoga, todas essas características  são importantes para os out - 
comes analisados, pois são com eles correlacionados. Adicionalmente, outcomes no 
período t são altamente correlacionados com outcomes no período t-1.

Relembrando,queremos  variáveis que são importantes para a atribuição do tratamento;
variáveis que são possivelmente relacionadas com alguma medida de outcome;
ou então variáveis que são a priori consideradas associadas fortemente com os
outcomes.

Assim, as variáveis que usaremos são:
	variáveis de infraestrutura:
	
*		predio 
* 		diretoria 
* 		sala_professores 
* 		biblioteca 
* 		internet 
* 		lixo_coleta
* 		eletricidade 
* 		agua 
* 		esgoto
	
	variáveis com caracterísitcas dos alunos da escola
 		n_alunos_em_ep
			e_mora_mais_de_6_pessoas 
			e_escol_sup_pai 
			e_escol_sup_mae 
			e_renda_familia_5_salarios 
			e_trabalhou_ou_procurou
			taxa_participacao_enem
	
	variáveis com características da escola
		d_dep1
		d_dep2
		d_dep3
		rural
		ativa
		mais_educ
		n_alunos_em_ep
		n_mulheres_em_ep
		concluir_em_ano_enem
	
	variáveis com características da cidade
		pop
		pib_capita_reais_real_2015
	oucomtes defasados (lagged outcomes)
		enem_nota_objetivab_std lagged
		enem_nota_redacao_std lagged
		
		rep_em_std lagged*
		aba_em_std lagged*
		
		
		* note que as variáveis de fluxo só estão disponíveis a partir de 2007
		* assim, somente nas análise pós 2007
	
*/

sysdir set PLUS \\fs-eesp-01\EESP\Usuarios\leonardo.kawahara\ado

capture log close
clear all
set more off, permanently

global folderservidor "\\fs-eesp-01\EESP\Usuarios\leonardo.kawahara"
log using "$folderservidor\logfiles/em_pscore_v1.log", replace

use "$folderservidor\dados_EM_14_v2.dta", clear

* declarando dados como painel
* ano é t e codigo_escola é i

xtset codigo_escola ano

* como usamos outcomes defasados, precisamos gerar os lags

sort codigo_escola ano

by codigo_escola: gen enem_nota_objetivab_std_lag = enem_nota_objetivab_std[_n-1] if ano==ano[_n-1]+1
order enem_nota_objetivab_std_lag, after(enem_nota_objetivab_std)

by codigo_escola: gen enem_nota_redacao_std_lag = enem_nota_redacao_std[_n-1] if ano==ano[_n-1]+1 
order enem_nota_redacao_std_lag, after(enem_nota_redacao_std)

by codigo_escola: gen rep_em_std_lag = rep_em_std[_n-1] if ano==ano[_n-1]+1 
order rep_em_std_lag, after(rep_em_std)

by codigo_escola: gen aba_em_std_lag = aba_em_std[_n-1] if ano==ano[_n-1]+1 
order aba_em_std_lag, after(aba_em_std)


* precisamos de dummies para indicar a entrada no programa em determinado ano
gen d_entrada_2004 = 0
replace d_entrada_2004 = 1 if ano_ice==2004 & ano==2004

gen d_entrada_2005 = 0
replace d_entrada_2005 = 1 if ano_ice==2005 & ano==2005

gen d_entrada_2006 = 0
replace d_entrada_2006 = 1 if ano_ice==2006 & ano==2006

gen d_entrada_2007 = 0
replace d_entrada_2007 = 1 if ano_ice==2007& ano==2007

gen d_entrada_2008 = 0
replace d_entrada_2008 = 1 if ano_ice==2008& ano==2008

gen d_entrada_2009 = 0
replace d_entrada_2009 = 1 if ano_ice==2009& ano==2009

gen d_entrada_2010 = 0
replace d_entrada_2010 = 1 if ano_ice==2010& ano==2010

gen d_entrada_2011 = 0
replace d_entrada_2011 = 1 if ano_ice==2011& ano==2011

gen d_entrada_2012 = 0
replace d_entrada_2012 = 1 if ano_ice==2012& ano==2012

gen d_entrada_2013 = 0
replace d_entrada_2013 = 1 if ano_ice==2013& ano==2013

gen d_entrada_2014 = 0
replace d_entrada_2014 = 1 if ano_ice==2014& ano==2014


gen d_entrada_2015 = 0
replace d_entrada_2015 = 1 if ano_ice==2015& ano==2015

* vamos calcular o logit usando as variáveis especificadas acima
* para cada ano, vamos estimar a probabilidade de cada escola de pertencer ao
* tratamento

* algumas questões ficam em aberto: para cada estimação em um dado ano, devemos
* utilizar na amostra observações que já eram tratadas no ano anterior?
* ou devemos calcular a probabilidade de uma determinada observação 
* de ser tratada, dado que no ano anterior ela não tinha sido tratada?

* intuitivamente,  queremos comparar escolas similares entre tratados e controles

* faz sentido então que, para parear uma escola tratada, analisar ela quando ela
* acaba de entrar no programa com uma escola do controle que é muito parecida com ela

* isto é, se a escola entrou em 2004, calcular o propensity score entre as escolas
* somente no ano de 2004, e ver qual controle tem o propensity score mais próximo
* do propensity do tratado

* no entanto, há algumas diferenças em como o progama foi implementado

* de 2004 a 2007, o programa foi implementado somente em escoals do pernambuco,
* e para tal, escolas novas eram criadas. Assim, essas escolas não tem um passado
* nem desempenho anterior na prova do enem, por exemplo, ou variáveis de fluxo  

* Assim, a análise do propensity score será feita ano a ano, de acordo com as
* informações disponíveis para as escolas tratadas

* Lembradno: o objetivo é selecionar uma subamostra cuja distribuição de 
* covariadas seja similar a distribuição do grupo oposto.

/*
2004
em 2004, temos somente uma escola entrando no programa. Ainda, ela foi "criada"
com o programa. Ela só possui dados de censo escola. os dados do enem só aparecem
2 anos depois, pois o programa começou com o primeiro ano do ensino médio.
ainda não possui dados de indicadores de fluxo, que só foram introduzidos em 2007
pelo sistema educacenso.
Assim, para o ano de 2004, devemos usar somente as informações que a escola 
tratada dispõe

*/ 

pscore ice pib_capita_reais_real_2015 pop rural ativa ///
	predio diretoria sala_professores biblioteca internet ///
	lixo_coleta eletricidade agua esgoto n_alunos_em_ep n_mulheres_em_ep ///
	d_uf* ///
	if ano == 2004, pscore(pscore2004)

* predio 
* diretoria 
* sala_professores 
* biblioteca 
* internet 
* lixo_coleta
* eletricidade 
* agua 
* esgoto
* n_alunos_em_1
* n_mulheres
*(n_alunos_em, n_alunos_ep)



