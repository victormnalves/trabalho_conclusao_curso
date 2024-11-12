# Carregando as bibliotecas necessárias para manipulação e leitura de dados
library(tidyverse)
library(arrow)

# Definindo o diretório de trabalho onde os dados estão armazenados
setwd('D:/OneDrive - Insper - Instituto de Ensino e Pesquisa/Estudos/Insper/TCC/Dados')

# Carregando os microdados brutos

## Carregando tabela de escolas e ajustando variáveis
censo_escola <- read_parquet('censo_escolas.parquet') %>% 
  mutate(codigo_escola = as.integer(codigo_escola),  # Convertendo código da escola para inteiro
         ano_censo = as_factor(ano),  # Transformando o ano em fator
         rural = case_when(rural == 2 ~ 1,  # Recodificando variável rural
                           T ~ 0),
         ativa = case_when(ativa == 1 ~ 1,  # Recodificando se a escola está ativa
                           T ~ 0),
         cod_munic = as_factor(cod_munic),  # Transformando o código do município em fator
         dependencia_administrativa = as_factor(dependencia_administrativa)) %>%  # Transformando a dependência administrativa em fator
  filter(dependencia_administrativa != 4)  # Filtrando escolas que não têm dependência administrativa igual a 4

## Carregando tabela de matrículas e renomeando colunas
censo_matricula_agrupado <- read_parquet('censo_matricula_agrupado.parquet') %>% 
  rename(n_alunos_em_1 = alunos_em_1,  # Renomeando colunas para facilitar interpretação
         n_alunos_em_2 = alunos_em_2,
         n_alunos_em_3 = alunos_em_3,
         n_mulheres_em_1 = mulheres_em_1,
         n_mulheres_em_2 = mulheres_em_2,
         n_mulheres_em_3 = mulheres_em_3,
         n_brancos_em_1 = brancos_em_1,
         n_brancos_em_2 = brancos_em_2,
         n_brancos_em_3 = brancos_em_3) %>% 
  mutate(ano_censo = as_factor(ano),  # Transformando o ano em fator
         codigo_escola = as.integer(codigo_escola))  # Convertendo o código da escola para inteiro

## Carregando tabela de turmas
censo_turma <- read_parquet('censo_turma.parquet')

## Carregando dados do ISG 
isg <- read.csv('dados_isg.csv') %>% 
  rename(codigo_escola = codigo_da_escola)

# Resumo do número de registros por ano no dataset ISG
isg %>% 
  group_by(ano) %>% 
  summarise(n())

# Preparando dados do ISG, resumindo informações sobre a entrada e saída de escolas no programa
dados_isg <- isg %>%
  arrange(codigo_escola, ano) %>%  # Ordena os dados por código de escola e ano
  group_by(codigo_escola) %>%
  summarise(
    ano_ice = first(ano),  # Primeiro ano em que a escola entrou no programa
    ano_ultimo = max(ano),  # Último ano em que a escola aparece nos dados
    saiu_programa = ifelse(ano_ultimo < max(isg$ano), 1, 0)  # Indica se a escola saiu do programa
  ) %>%
  ungroup() %>%
  mutate(tratado = 1)  # Marca as escolas que participaram do programa como tratadas

# Resumo de escolas tratadas por ano de entrada no programa
dados_isg %>% 
  group_by(ano_ice) %>% 
  summarise(tratado = sum(tratado),
            saiu_programa = sum(saiu_programa))

# Resumo do número de registros por ano de entrada no programa
dados_isg %>% 
  group_by(ano_ice) %>% 
  summarise(n())

## Carregando indicadores escolares
indicadores <- read_parquet('indicadores.parquet') %>% 
  mutate(ano_censo = as_factor(ano),  # Transformando o ano em fator
         codigo_escola = as.integer(codigo_escola))  # Convertendo o código da escola para inteiro

## Criando painel completo com dados do censo e ISG

painel_indicadores <- 
  full_join(censo_escola, dados_isg, by = 'codigo_escola') %>%
  full_join(., censo_matricula_agrupado, by = c('ano_censo', 'codigo_escola')) %>%
  full_join(., indicadores, by = c('ano_censo', 'codigo_escola')) %>%
  mutate(ano_ice = replace_na(ano_ice, 0),  # Preenche valores faltantes com 0
         tratado = replace_na(tratado, 0),  # Preenche valores faltantes com 0
         ano_tratamento = case_when(  # Define ano de tratamento
           ano >= ano_ice & ano_ice > 0 ~ 1,
           TRUE ~ 0
         )) %>% 
  filter(saiu_programa == 0 | ano_ice == 0)  # Filtra escolas que saíram do programa

# Resumo do número de escolas tratadas por ano
painel_indicadores %>% 
  group_by(ano) %>% 
  summarise(n_tratados = sum(tratado))

# Salvando o painel completo em arquivo parquet
write_parquet(painel_indicadores, 'painel_indicadores.parquet')

## Criando painel simplificado com censo e dados ISG

painel_indicadores_simplificado <- 
  full_join(censo_escola, dados_isg, by = 'codigo_escola') %>%
  full_join(., indicadores, by = c('ano_censo', 'codigo_escola')) %>%
  mutate(ano_ice = replace_na(ano_ice, 0),  # Preenche valores faltantes com 0
         tratado = replace_na(tratado, 0),  # Preenche valores faltantes com 0
         ano = ano.x,  # Definindo a variável ano
         ano_tratamento = case_when(ano_ice == ano ~ 1,
                                    .default = 0),  # Definindo o ano de tratamento
         ano_tratamento = case_when(  # Marcando tratamento
           ano >= ano_ice & ano_ice > 0 ~ 1,
           TRUE ~ 0
         )) %>% 
  filter(saiu_programa == 0 | ano_ice == 0)  # Filtra escolas que saíram do programa

# Contando escolas tratadas por ano e acumulando o total
painel_indicadores_simplificado %>%
  filter(ano_tratamento == 1) %>%  # Escolas tratadas
  group_by(ano) %>%
  summarise(escolas_tratadas = n_distinct(codigo_escola)) %>%  # Conta escolas únicas
  mutate(acumulado_tratadas = cumsum(escolas_tratadas))  # Soma acumulada das escolas tratadas

# Salvando o painel simplificado em arquivo parquet
write_parquet(painel_indicadores_simplificado, 'painel_indicadores_simplificado.parquet')

## Carregando dados do ICE

dados_ice_v3 <- 
  haven::read_dta('G:/Meu Drive/Insper/TCC/Dados/dados_ICE/dados_EM_14_v3.dta') %>% 
  select(-contains('std'),  # Removendo colunas irrelevantes
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
    ano_ice = coalesce(ano_ice, 0),  # Substituindo valores NA por 0
    tratado = case_when(ano_ice == 0 ~ 0,  # Marcando escolas não tratadas
                        .default = 1),
    cod_munic = as_factor(cod_munic),  # Transformando o código do município em fator
    dependencia_administrativa = as_factor(dependencia_administrativa)  # Transformando a dependência administrativa em fator
  ) 

# Salvando os dados do ICE limpos em arquivo parquet
write_parquet(dados_ice_v3, 'dados_ice_v3_limpo.parquet')

## Atualizando os dados finais com o censo e matrículas

dados_ice_v4 <- left_join(censo_escola, censo_matricula_agrupado, 
                          by = c('ano', 'codigo_escola')) %>% 
  left_join(., indicadores, by = c('ano', 'codigo_escola')) %>% 
  dplyr::bind_rows(., dados_ice_v3)  # Combinando os dados do ICE

# Salvando os dados finais em arquivo parquet
write_parquet(dados_ice_v4, 'dados_ice_v4.parquet')
