library(tidyverse)
library(arrow)

setwd('G:/Meu Drive/Insper/TCC/Dados')

# Carregando os microdados brutos

## Carregando tabela de escola

censo_escola <- read_parquet('censo_escolas.parquet') %>% 
  mutate(codigo_escola = as.integer(codigo_escola),
         ano_censo = as_factor(ano),
         rural = case_when(rural == 2 ~ 1,
                            T ~ 0),
         ativa = case_when(ativa == 1 ~ 1,
                            T ~ 0),
         cod_munic = as_factor(cod_munic),
         dependencia_administrativa = as_factor(dependencia_administrativa)) %>% 
  filter(dependencia_administrativa != 4)

## Carregando tabela de matrículas

censo_matricula_agrupado <- read_parquet('censo_matricula_agrupado.parquet') %>% 
  rename(n_alunos_em_1 = alunos_em_1,
         n_alunos_em_2 = alunos_em_2,
         n_alunos_em_3 = alunos_em_3,
         n_mulheres_em_1 = mulheres_em_1,
         n_mulheres_em_2 = mulheres_em_2,
         n_mulheres_em_3 = mulheres_em_3,
         n_brancos_em_1 = brancos_em_1,
         n_brancos_em_2 = brancos_em_2,
         n_brancos_em_3 = brancos_em_3) %>% 
  mutate(ano_censo = as_factor(ano),
         codigo_escola = as.integer(codigo_escola))

## Carregando tabela de turmas

censo_turma <- read_parquet('censo_turma.parquet')

## Dados ISG

dados_isg <- readxl::read_xlsx('dados_isg.xlsx') %>% 
  arrange(codigo_escola, ano) %>%
  group_by(codigo_escola) %>%
  summarise(ano_ice = first(ano)) %>%
  ungroup()

## Carregando indicadores escolares

indicadores <- read_parquet('indicadores.parquet') %>% 
  mutate(ano_censo = as_factor(ano),
         codigo_escola = as.integer(codigo_escola))

## Painel do censo

painel_indicadores <-  full_join(censo_escola, dados_isg, 
                                 by = c('codigo_escola')) %>% 
  full_join(., censo_matricula_agrupado,
                                by = c('ano_censo', 'codigo_escola', 'ano')) %>%
  full_join(., indicadores, 
            by = c('ano_censo', 'codigo_escola', 'ano')) %>% 
  mutate(ano_ice = coalesce(ano_ice, 0),
         tratado = case_when(ano_ice != 0 ~ 1,
                             T ~ 0))

write_parquet(painel_indicadores, 'painel_indicadores.parquet')

painel_indicadores_simplificado <- left_join(indicadores, dados_isg, by ='codigo_escola') %>% 
  left_join(., censo_escola, by = c('ano', 'codigo_escola')) %>% 
  mutate(ano_ice = coalesce(ano_ice, 0),
         tratado = case_when(ano_ice != 0 ~ 1,
                             T ~ 0))

write_parquet(painel_indicadores_simplificado, 'painel_indicadores_simplificado.parquet')

## Dados ICE

dados_ice_v3 <- 
  haven::read_dta('G:/Meu Drive/Insper/TCC/Dados/dados_ICE/dados_EM_14_v3.dta') %>% 
  select(-contains('std'),
         -contains('pb'),
         -contains('d_ano'),
         -contains('d_uf'),
         -contains('d_dep'),
         -contains('d_ice'),
         -contains('ice_fluxo'),
         -contains('d_uf'),
         -contains('ice_'),
         -contains('d_match'),
         -contains('d_entrada'),
         -contains('codigo_escola_'),
         -contains('d_uf'),
         -contains('d_ano'),
         -contains('d_dep'),
         -contains('ef'),
         -contains('fund'),
         -contains('d_dep'),
         -contains('pib'),
         -contains('pop'),
         -contains('prof'),
         -contains('sup'),
         -contains('completo'),
         -contains('taxa_participacao'),
         -c(enem, d_enem, censo_escolar, em_fluxo, DV, nome_escola_censo, cod_meso,
            any_ice, noccur, escola_ice, codigo_uf_enem, distrito_escola_novo,
            n_turmas_em_inte_1, n_turmas_em_inte_2, ano_censo_escolar_doc, n_total_em,
            etapa_medio, etapa_em_eja, etapa_ep_nt, nome_escola, ensino_medio, integral, )) %>% 
  mutate(
    ano_ice = coalesce(ano_ice, 0),
    tratado = case_when(ano_ice == 0 ~ 0,
                        .default = 1),
    cod_munic = as_factor(cod_munic),
    dependencia_administrativa = as_factor(dependencia_administrativa)
  ) 

write_parquet(dados_ice_v3, 'dados_ice_v3_limpo.parquet')

## Atualizando final

dados_ice_v4 <- left_join(censo_escola, censo_matricula_agrupado, 
                          by = c('ano', 'codigo_escola')) %>% 
  left_join(., indicadores, by = c('ano', 'codigo_escola')) %>% 
  dplyr::bind_rows(., dados_ice_v3)

write_parquet(dados_ice_v4, 'dados_ice_v4.parquet')
