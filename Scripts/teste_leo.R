library(tidyverse)
library(did)

setwd("D:/OneDrive - Insper - Instituto de Ensino e Pesquisa/Estudos/Insper/TCC/Dados/dados_ICE")

dados_ice_v3 <- haven::read_dta('dados_EM_14_v3.dta') %>% 
  select(-contains('std'),
         -contains('pb'),
         -contains('d_ano'),
         -contains('d_uf'),
         -contains('d_dep'),
         -contains('d_ice'),
         -contains('ice_fluxo'),
         -contains('d_uf'),
         -contains('ice_')) %>% 
  mutate(
    ano_ice = coalesce(ano_ice,0),
    tratado = case_when(ano_ice == 0 ~ 0,
                        .default = 1)
  )

did_teste_redacao <- did::att_gt(
  yname = "enem_nota_redacao",
  tname = "ano",
  idname = "codigo_escola",
  gname = "ano_ice",
  data = dados_ice_v3
)

summary(did_teste_redacao)

ggdid(did_teste_redacao)

aggte(did_teste_redacao, type = "simple", na.rm = T)

ggdid(aggte(did_teste_redacao, type = "dynamic", na.rm = T))

did_teste_matematica <- did::att_gt(
  yname = "enem_nota_matematica",
  tname = "ano",
  idname = "codigo_escola",
  gname = "ano_ice",
  data = dados_ice_v3
)

summary(did_teste_matematica)

ggdid(did_teste_matematica)

aggte(did_teste_matematica, type = "simple")

ggdid(aggte(did_teste_matematica, type = "dynamic", na.rm = T))

did_teste_linguagem <- did::att_gt(
  yname = "enem_nota_linguagens",
  tname = "ano",
  idname = "codigo_escola",
  gname = "ano_ice",
  data = dados_ice_v3
)

summary(did_teste_linguagem)

ggdid(did_teste_linguagem)

aggte(did_teste_linguagem, type = "simple")

ggdid(aggte(did_teste_linguagem, type = "dynamic", na.rm = T))

did_teste_ciencias <- did::att_gt(
  yname = "enem_nota_ciencias",
  tname = "ano",
  idname = "codigo_escola",
  gname = "ano_ice",
  data = dados_ice_v3
)

summary(did_teste_ciencias)

ggdid(did_teste_ciencias)

aggte(did_teste_ciencias, type = "simple", na.rm = T)

ggdid(aggte(did_teste_ciencias, type = "dynamic", na.rm = T))

