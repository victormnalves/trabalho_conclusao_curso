library(tidyverse)
library(basedosdados)
library(arrow)

# Defina o seu projeto no Google Cloud
gargle::gargle_oauth_sitrep()
set_billing_id("meu-tcc-404923")

# Carregando dados do ENEM

bdplyr("br_inep_enem.microdados")  %>% 
  dplyr::select(
    id_inscricao, ano, faixa_etaria, sexo, estado_civil, cor_raca, 
    situacao_conclusao, tipo_escola, indicador_certificado, nota_ciencias_humanas, 
    nota_ciencias_natureza, nota_linguagens_codigos, nota_matematica, nota_redacao, 
    indicador_certificado, nome_certificadora) %>% 
  bd_collect(.) %>% 
  write_parquet(., 'enem.parquet')

# Carregando microdados dos questionários

# Dados para o ENEM 2003

bdplyr("basedosdados.br_inep_enem.questionario_socioeconomico_2003")  %>% 
  dplyr::select(
    id_inscricao, Q1, Q4, Q15, Q16, Q17, Q22, Q27, Q34) %>% 
  dplyr::rename(sexo = Q1,
                estado_civil = Q4,
                filhos = Q15,
                escolaridade_pai = Q16,
                escolaridade_mae = Q17,
                renda_familiar = Q22,
                automovel = Q27,
                casa_propria = Q34) %>% 
  bd_collect(.) %>% 
  write_parquet(., 'enem_2003.parquet')

# Dados para o ENEM 2004

bdplyr("basedosdados.br_inep_enem.questionario_socioeconomico_2004")  %>% 
  dplyr::select(
    id_inscricao, Q1, Q4, Q15, Q16, Q17, Q22, Q27, Q34) %>% 
  dplyr::rename(sexo = Q1,
                estado_civil = Q4,
                filhos = Q15,
                escolaridade_pai = Q16,
                escolaridade_mae = Q17,
                renda_familiar = Q22,
                automovel = Q27,
                casa_propria = Q34) %>% 
  bd_collect(.) %>% 
  write_parquet(., 'enem_2004.parquet')

# Dados para o ENEM 2005

bdplyr("basedosdados.br_inep_enem.questionario_socioeconomico_2005")  %>% 
  dplyr::select(
    id_inscricao, Q1, Q5, Q16, Q17, Q18, Q23, Q28, Q35) %>% 
  dplyr::rename(sexo = Q1,
                estado_civil = Q5,
                filhos = Q16,
                escolaridade_pai = Q17,
                escolaridade_mae = Q18,
                renda_familiar = Q23,
                automovel = Q28,
                casa_propria = Q35) %>% 
  bd_collect(.) %>% 
  write_parquet(., 'enem_2005.parquet')

# Dados para o ENEM 2006

bdplyr("basedosdados.br_inep_enem.questionario_socioeconomico_2006")  %>% 
  dplyr::select(
    id_inscricao, Q1, Q5, Q16, Q17, Q18, Q23, Q28, Q35) %>% 
  dplyr::rename(sexo = Q1,
                estado_civil = Q5,
                filhos = Q16,
                escolaridade_pai = Q17,
                escolaridade_mae = Q18,
                renda_familiar = Q23,
                automovel = Q28,
                casa_propria = Q35) %>% 
  bd_collect(.) %>% 
  write_parquet(., 'enem_2006.parquet')

# Dados para o ENEM 2007

bdplyr("basedosdados.br_inep_enem.questionario_socioeconomico_2007")  %>% 
  dplyr::select(
    id_inscricao, Q1, Q5, Q16, Q17, Q18, Q23, Q28, Q35) %>% 
  dplyr::rename(sexo = Q1,
                estado_civil = Q5,
                filhos = Q16,
                escolaridade_pai = Q17,
                escolaridade_mae = Q18,
                renda_familiar = Q23,
                automovel = Q28,
                casa_propria = Q35) %>% 
  bd_collect(.) %>% 
  write_parquet(., 'enem_2007.parquet')

# Dados para o ENEM 2008

bdplyr("basedosdados.br_inep_enem.questionario_socioeconomico_2008")  %>% 
  dplyr::select(
    id_inscricao, Q1, Q5, Q16, Q17, Q18, Q23, Q28, Q35) %>% 
  dplyr::rename(sexo = Q1,
                estado_civil = Q5,
                filhos = Q16,
                escolaridade_pai = Q17,
                escolaridade_mae = Q18,
                renda_familiar = Q23,
                automovel = Q28,
                casa_propria = Q35) %>% 
  bd_collect(.) %>% 
  write_parquet(., 'enem_2008.parquet')

# Dados para o ENEM 2009

bdplyr("basedosdados.br_inep_enem.questionario_socioeconomico_2009")  %>% 
  dplyr::select(
    id_inscricao, Q1, Q6, Q16, Q17, Q18, Q21, Q26, Q33) %>% 
  dplyr::rename(sexo = Q1,
                estado_civil = Q6,
                filhos = Q16,
                escolaridade_pai = Q17,
                escolaridade_mae = Q18,
                renda_familiar = Q21,
                automovel = Q26,
                casa_propria = Q33) %>% 
  bd_collect(.) %>% 
  write_parquet(., 'enem_2009.parquet')

# Dados para o ENEM 2010

bdplyr("basedosdados.br_inep_enem.questionario_socioeconomico_2010")  %>% 
  dplyr::select(
    id_inscricao, Q02, Q03, Q04, Q06) %>% 
  dplyr::rename(escolaridade_pai = Q02,
                escolaridade_mae = Q03,
                renda_familiar = Q04,
                casa_propria = Q06) %>% 
  bd_collect(.) %>% 
  write_parquet(., 'enem_2010.parquet')

# Dados para o ENEM 2011

bdplyr("basedosdados.br_inep_enem.questionario_socioeconomico_2011")  %>% 
  dplyr::select(
    id_inscricao, Q002, Q003, Q004, Q006) %>% 
  dplyr::rename(escolaridade_pai = Q002,
                escolaridade_mae = Q003,
                renda_familiar = Q004,
                casa_propria = Q006) %>% 
  bd_collect(.) %>% 
  write_parquet(., 'enem_2011.parquet')

# Dados para o ENEM 2012

bdplyr("basedosdados.br_inep_enem.questionario_socioeconomico_2012")  %>% 
  dplyr::select(
    id_inscricao, Q001, Q002, Q003, Q005, Q011) %>% 
  dplyr::rename(escolaridade_pai = Q001,
                escolaridade_mae = Q002,
                renda_familiar = Q003,
                casa_propria = Q005,
                automovel = Q011) %>% 
  bd_collect(.) %>% 
  write_parquet(., 'enem_2012.parquet')

# Dados para o ENEM 2013

bdplyr("basedosdados.br_inep_enem.questionario_socioeconomico_2013")  %>% 
  dplyr::select(
    id_inscricao, Q001, Q002, Q003, Q005, Q011) %>% 
  dplyr::rename(escolaridade_pai = Q001,
                escolaridade_mae = Q002,
                renda_familiar = Q003,
                casa_propria = Q005,
                automovel = Q011) %>% 
  bd_collect(.) %>% 
  write_parquet(., 'enem_2013.parquet')

# Dados para o ENEM 2014

bdplyr("basedosdados.br_inep_enem.questionario_socioeconomico_2014")  %>% 
  dplyr::select(
    id_inscricao, Q001, Q002, Q003, Q005, Q011) %>% 
  dplyr::rename(escolaridade_pai = Q001,
                escolaridade_mae = Q002,
                renda_familiar = Q003,
                casa_propria = Q005,
                automovel = Q011) %>% 
  bd_collect(.) %>% 
  write_parquet(., 'enem_2014.parquet')

# Dados para o ENEM 2015

bdplyr("basedosdados.br_inep_enem.questionario_socioeconomico_2015")  %>% 
  dplyr::select(
    id_inscricao, Q001, Q002, Q006, Q010) %>% 
  dplyr::rename(escolaridade_pai = Q001,
                escolaridade_mae = Q002,
                renda_familiar = Q006,
                automovel = Q010) %>% 
  bd_collect(.) %>% 
  write_parquet(., 'enem_2015.parquet')

# Dados para o ENEM 2016

bdplyr("basedosdados.br_inep_enem.questionario_socioeconomico_2016")  %>% 
  dplyr::select(
    id_inscricao, Q001, Q002, Q006, Q010) %>% 
  dplyr::rename(escolaridade_pai = Q001,
                escolaridade_mae = Q002,
                renda_familiar = Q006,
                automovel = Q010) %>% 
  bd_collect(.) %>% 
  write_parquet(., 'enem_2016.parquet')

# Dados para o ENEM 2017

bdplyr("basedosdados.br_inep_enem.questionario_socioeconomico_2017")  %>% 
  dplyr::select(
    id_inscricao, Q001, Q002, Q006, Q010) %>% 
  dplyr::rename(escolaridade_pai = Q001,
                escolaridade_mae = Q002,
                renda_familiar = Q006,
                automovel = Q010) %>% 
  bd_collect(.) %>% 
  write_parquet(., 'enem_2017.parquet')






