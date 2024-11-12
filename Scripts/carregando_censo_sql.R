library(tidyverse)
library(basedosdados)
library(arrow)

# Defina o seu projeto no Google Cloud
gargle::gargle_oauth_sitrep()
set_billing_id("meu-tcc-404923")

setwd("G:/Meu Drive/Insper/TCC/Dados")

# Carregando e salvando dados do Censo (escolas)

write_parquet(
  read_sql(query = 
  'SELECT ano, 
  sigla_uf, 
  id_municipio AS cod_munic, 
  id_escola AS codigo_escola, 
  rede AS dependencia_administrativa, 
  tipo_localizacao AS rural, 
  tipo_situacao_funcionamento AS ativa, 
  agua_rede_publica AS agua, 
  energia_rede_publica AS eletricidade, 
  esgoto_rede_publica AS esgoto, 
  lixo_servico_coleta AS lixo_coleta, 
  quadra_esportes_coberta AS quadra_esportes, 
  laboratorio_informatica AS lab_info, 
  laboratorio_ciencias AS lab_ciencias, 
  local_funcionamento_predio_escolar AS predio,
  biblioteca, 
  sala_leitura, 
  sala_diretoria AS diretoria, 
  quantidade_sala_existente AS n_salas_exis, 
  quantidade_sala_utilizada, 
  internet
  FROM `basedosdados.br_inep_censo_escolar.escola` 
  WHERE ano >= 2007 AND etapa_ensino_medio > 0'), 
  'censo_escolas.parquet')

# Carregando e salvando os dados do Censo (matricula)

write_parquet(
  read_sql(query = 
"SELECT 
    codigo_escola,
    ano,
    SUM(n_alunos_em_1) AS alunos_em_1,
    SUM(n_alunos_em_2) AS alunos_em_2,
    SUM(n_alunos_em_3) AS alunos_em_3,
    SUM(n_mulheres_em_1) AS mulheres_em_1,
    SUM(n_mulheres_em_2) AS mulheres_em_2,
    SUM(n_mulheres_em_3) AS mulheres_em_3,
    SUM(n_brancos_em_1) AS brancos_em_1,
    SUM(n_brancos_em_2) AS brancos_em_2,
    SUM(n_brancos_em_3) AS brancos_em_3,
    SUM(n_alu_transporte_publico_em_1) AS alu_transporte_publico_em_1,
    SUM(n_alu_transporte_publico_em_2) AS alu_transporte_publico_em_2,
    SUM(n_alu_transporte_publico_em_3) AS alu_transporte_publico_em_3,
    AVG(CASE WHEN etapa_ensino = 25 AND sexo = 2 THEN 1.0 ELSE 0.0 END) AS p_mulheres_em_1,
    AVG(CASE WHEN etapa_ensino = 26 AND sexo = 2 THEN 1.0 ELSE 0.0 END) AS p_mulheres_em_2,
    AVG(CASE WHEN etapa_ensino = 27 AND sexo = 2 THEN 1.0 ELSE 0.0 END) AS p_mulheres_em_3,
    AVG(CASE WHEN etapa_ensino = 25 AND raca_cor = 1 THEN 1.0 ELSE 0.0 END) AS p_brancos_em_1,
    AVG(CASE WHEN etapa_ensino = 26 AND raca_cor = 1 THEN 1.0 ELSE 0.0 END) AS p_brancos_em_2,
    AVG(CASE WHEN etapa_ensino = 27 AND raca_cor = 1 THEN 1.0 ELSE 0.0 END) AS p_brancos_em_3,
    AVG(CASE WHEN etapa_ensino = 25 AND transporte_publico = 1 THEN 1.0 ELSE 0.0 END) AS p_alu_transporte_publico_em_1,
    AVG(CASE WHEN etapa_ensino = 26 AND transporte_publico = 1 THEN 1.0 ELSE 0.0 END) AS p_alu_transporte_publico_em_2,
    AVG(CASE WHEN etapa_ensino = 27 AND transporte_publico = 1 THEN 1.0 ELSE 0.0 END) AS p_alu_transporte_publico_em_3,
    AVG(CASE WHEN etapa_ensino = 25 THEN idade END) AS m_idade_em_1,
    AVG(CASE WHEN etapa_ensino = 26 THEN idade END) AS m_idade_em_2,
    AVG(CASE WHEN etapa_ensino = 27 THEN idade END) AS m_idade_em_3
FROM (
    SELECT 
        ano,
        CAST(id_escola AS INT64) AS codigo_escola,
        CAST(sexo AS INT64) AS sexo,
        CAST(raca_cor AS INT64) AS raca_cor,
        CAST(transporte_publico AS INT64) AS transporte_publico,
        CAST(etapa_ensino AS INT64) AS etapa_ensino,
        CAST(idade AS INT64) AS idade,
        CASE WHEN etapa_ensino = '25' THEN 1 ELSE 0 END AS n_alunos_em_1,
        CASE WHEN etapa_ensino = '26' THEN 1 ELSE 0 END AS n_alunos_em_2,
        CASE WHEN etapa_ensino = '27' THEN 1 ELSE 0 END AS n_alunos_em_3,
        CASE WHEN etapa_ensino = '25' AND sexo = '2' THEN 1 ELSE 0 END AS n_mulheres_em_1,
        CASE WHEN etapa_ensino = '26' AND sexo = '2' THEN 1 ELSE 0 END AS n_mulheres_em_2,
        CASE WHEN etapa_ensino = '27' AND sexo = '2' THEN 1 ELSE 0 END AS n_mulheres_em_3,
        CASE WHEN etapa_ensino = '25' AND raca_cor = '1' THEN 1 ELSE 0 END AS n_brancos_em_1,
        CASE WHEN etapa_ensino = '26' AND raca_cor = '1' THEN 1 ELSE 0 END AS n_brancos_em_2,
        CASE WHEN etapa_ensino = '27' AND raca_cor = '1' THEN 1 ELSE 0 END AS n_brancos_em_3,
        CASE WHEN etapa_ensino = '25' AND transporte_publico = 1 THEN 1 ELSE 0 END AS n_alu_transporte_publico_em_1,
        CASE WHEN etapa_ensino = '26' AND transporte_publico = 1 THEN 1 ELSE 0 END AS n_alu_transporte_publico_em_2,
        CASE WHEN etapa_ensino = '27' AND transporte_publico = 1 THEN 1 ELSE 0 END AS n_alu_transporte_publico_em_3
    FROM `basedosdados.br_inep_censo_escolar.matricula`
    WHERE ano >= 2007 AND etapa_ensino BETWEEN '25' AND '34'
) subquery
GROUP BY codigo_escola, ano"), 
  'censo_matricula_agrupado.parquet')

# Carregando e salvando os dados de indicadores educacionais


write_parquet(
  read_sql(query = 
  'SELECT ano, 
  id_escola AS codigo_escola, 
  taxa_aprovacao_em AS apr_em,
  tdi_em AS dist_em, 
  taxa_reprovacao_em AS rep_em, 
  taxa_abandono_em AS aba_em  
  FROM `basedosdados.br_inep_indicadores_educacionais.escola` 
  WHERE ano >= 2007'), 
  'indicadores.parquet')

# Carregando e salvando os dados do Censo (turmas)

write_parquet(
  read_sql(query = 
  'SELECT ano, id_escola, etapa_ensino 
  FROM `basedosdados.br_inep_censo_escolar.turma`
  WHERE ano >= 2007'), 
  'censo_turma.parquet')

