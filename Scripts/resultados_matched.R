# Carrega o pacote MatchIt, utilizado para realizar a correspondência entre grupos no contexto de matching
library(MatchIt)

# Ajuste das variáveis do banco de dados para garantir que os tipos de dados estão corretos
painel_indicadores <- painel_indicadores %>% 
  mutate(
    dependencia_administrativa = as.numeric(dependencia_administrativa),  # Converte a variável 'dependencia_administrativa' para numérica
    tratado = as.factor(tratado)  # Converte a variável 'tratado' para fator (variável categórica)
  )

# Ajuste de um modelo de regressão logística (glm) para prever a probabilidade de ser tratado com base em várias variáveis independentes
m_ps <- glm(
  tratado ~ n_salas_exis + dependencia_administrativa + rural +  
    biblioteca + internet + quadra_esportes + lab_info + lab_ciencias + 
    p_mulheres_em_1 + p_mulheres_em_2 + p_mulheres_em_2 + 
    p_brancos_em_1 + p_brancos_em_2 + p_brancos_em_3 + ano,  # Variáveis independentes
  family = binomial(),  # Família binomial para regressão logística
  data = painel_indicadores  # Base de dados
)

# Exibe o resumo do modelo de regressão logística ajustado
summary(m_ps)

# Criação de um data frame contendo as probabilidades previstas de ser tratado (pr_score) e o status de tratamento
prs_df <- data.frame(
  pr_score = predict(m_ps, type = "response"),  # Predição das probabilidades
  tratado = m_ps$model$tratado  # Variável de status de tratamento
)

# Geração de um gráfico de densidade para as probabilidades de tratamento, separando por 'tratado'
prs_df %>%
  mutate(tratado = as_factor(tratado)) %>%  # Converte 'tratado' para fator
  ggplot() +  # Cria o gráfico
  geom_density(aes(x = pr_score, fill = tratado), alpha = 0.25) +  # Densidade das probabilidades de tratamento
  xlab("Probability of being treated")  # Rótulo do eixo x

# Definindo um vetor de covariáveis a serem usadas no processo de matching
covariados <- c('n_salas_exis', 'dependencia_administrativa', 'rural', 
                'biblioteca', 'internet', 'quadra_esportes', 'lab_info', 'lab_ciencias', 
                'p_mulheres_em_1', 'p_mulheres_em_2', 'p_mulheres_em_2', 'p_brancos_em_1', 
                'p_brancos_em_2', 'p_brancos_em_3')

# Resumo das médias das covariáveis para cada grupo (tratado e controle) separadamente
painel_indicadores %>%
  group_by(tratado) %>%  # Agrupa os dados por 'tratado'
  select(one_of(covariados)) %>%  # Seleciona as variáveis do vetor 'covariados'
  summarise_all(funs(mean(., na.rm = T)))  # Calcula a média de cada covariável, ignorando NA's

# Teste t para comparar as médias das covariáveis entre os grupos 'tratado' e 'controle'
lapply(covariados, function(v) {
  t.test(painel_indicadores[[v]] ~ painel_indicadores[['tratado']])  # Teste t para cada covariável
})

# Remoção de linhas com valores ausentes, pois o pacote MatchIt não permite valores missing
painel_indicadores_nomiss <- painel_indicadores %>%  
  select(ends_with('em'), tratado, one_of(covariados), ano) %>%  # Seleciona as colunas relevantes
  na.omit()  # Remove as linhas com valores ausentes

# Realiza o matching usando o método de "nearest neighbor" (vizinho mais próximo) com as covariáveis definidas
mod_match <- matchit(
  tratado ~ n_salas_exis + dependencia_administrativa + rural + 
    biblioteca + internet + quadra_esportes + lab_info + lab_ciencias + 
    p_mulheres_em_1 + p_mulheres_em_2 + p_mulheres_em_2 + 
    p_brancos_em_1 + p_brancos_em_2 + p_brancos_em_3 + ano,  # Covariáveis a serem usadas para matching
  method = "nearest",  # Método de matching "nearest neighbor"
  data = painel_indicadores_nomiss  # Base de dados sem valores ausentes
)

# Acessa os dados de correspondência após a execução do matching
painel_indicadores_matched <- match.data(mod_match)

# Normaliza variáveis específicas e armazena em painel_indicadores_matched
painel_indicadores_matched <- painel_indicadores_matched %>% 
  mutate_at(c('aba_em', 'dist_em', 'apr_em', 'rep_em'),  ~(scale(.) %>% as.vector))  # Normaliza as variáveis selecionadas

# Realiza o gráfico de diferenças dinâmicas no ATT (Average Treatment Effect on the Treated) para 'aba_em'
ggdid(aggte(
  did::att_gt(
    yname = "aba_em",  # Variável dependente 'aba_em'
    tname = "ano",  # Variável de tempo 'ano'
    idname = "codigo_escola",  # Identificador das unidades 'codigo_escola'
    gname = "ano_ice",  # Variável de grupo 'ano_ice'
    data = painel_indicadores_simplificado_norm  # Dados de entrada
  ), 
  type = "dynamic", na.rm = T)  # Tipo de gráfico: dinâmico
)[["data"]] %>% 
  mutate(ymin = att-c*att.se, ymax=att+c*att.se, year=as.factor(year)) %>%  # Cálculo das barras de erro
  ggplot(aes(year, att)) +  # Cria o gráfico de ATT por ano
  geom_point(aes(year, att)) +  # Adiciona pontos de ATT
  geom_errorbar(aes(ymin = ymin, ymax = ymax), size = 0.1) +  # Adiciona barras de erro
  labs(title = '', x = 'Tempo de exposição ao programa', y = 'ATT') +  # Rótulos dos eixos
  geom_vline(xintercept = '0', linetype = 'dotted') +  # Linha vertical no tempo 0
  geom_hline(yintercept = 0, linetype = 'dotted') +  # Linha horizontal em ATT = 0
  tema_did  # Tema específico para gráficos de DID

# Repetição dos mesmos passos de gráficos de ATT para outras variáveis: 'dist_em', 'apr_em', 'rep_em'
# O processo é idêntico para as outras variáveis, substituindo apenas o nome da variável dependente.
ggdid(aggte(
  did::att_gt(
    yname = "dist_em",  # Variável dependente 'dist_em'
    tname = "ano",  # Variável de tempo 'ano'
    idname = "codigo_escola",  # Identificador das unidades 'codigo_escola'
    gname = "ano_ice",  # Variável de grupo 'ano_ice'
    data = painel_indicadores_simplificado_norm  # Dados de entrada
  ), 
  type = "dynamic", na.rm = T)  # Tipo de gráfico: dinâmico
)[["data"]] %>% 
  mutate(ymin = att-c*att.se, ymax=att+c*att.se, year=as.factor(year)) %>%  # Cálculo das barras de erro
  ggplot(aes(year, att)) +  # Cria o gráfico de ATT por ano
  geom_point(aes(year, att)) +  # Adiciona pontos de ATT
  geom_errorbar(aes(ymin = ymin, ymax = ymax), size = 0.1) +  # Adiciona barras de erro
  labs(title = '', x = 'Tempo de exposição ao programa', y = 'ATT') +  # Rótulos dos eixos
  geom_vline(xintercept = '0', linetype = 'dotted') +  # Linha vertical no tempo 0
  geom_hline(yintercept = 0, linetype = 'dotted') +  # Linha horizontal em ATT = 0
  tema_did  # Tema específico para gráficos de DID

# Repetição para as variáveis 'apr_em' e 'rep_em', com a mesma estrutura dos gráficos anteriores

ggdid(aggte(
  did::att_gt(
    yname = "apr_em",  # Variável dependente 'apr_em'
    tname = "ano",  # Variável de tempo 'ano'
    idname = "codigo_escola",  # Identificador das unidades 'codigo_escola'
    gname = "ano_ice",  # Variável de grupo 'ano_ice'
    data = painel_indicadores_simplificado_norm  # Dados de entrada
  ), 
  type = "dynamic", na.rm = T)  # Tipo de gráfico: dinâmico
)[["data"]] %>% 
  mutate(ymin = att-c*att.se, ymax=att+c*att.se, year=as.factor(year)) %>%  # Cálculo das barras de erro
  ggplot(aes(year, att)) +  # Cria o gráfico de ATT por ano
  geom_point(aes(year, att)) +  # Adiciona pontos de ATT
  geom_errorbar(aes(ymin = ymin, ymax = ymax), size = 0.1) +  # Adiciona barras de erro
  labs(title = '', x = 'Tempo de exposição ao programa', y = 'ATT') +  # Rótulos dos eixos
  geom_vline(xintercept = '0', linetype = 'dotted') +  # Linha vertical no tempo 0
  geom_hline(yintercept = 0, linetype = 'dotted') +  # Linha horizontal em ATT = 0
  tema_did  # Tema específico para gráficos de DID

ggdid(aggte(
  did::att_gt(
    yname = "rep_em",  # Variável dependente 'rep_em'
    tname = "ano",  # Variável de tempo 'ano'
    idname = "codigo_escola",  # Identificador das unidades 'codigo_escola'
    gname = "ano_ice",  # Variável de grupo 'ano_ice'
    data = painel_indicadores_simplificado_norm  # Dados de entrada
  ), 
  type = "dynamic", na.rm = T)  # Tipo de gráfico: dinâmico
)[["data"]] %>% 
  mutate(ymin = att-c*att.se, ymax=att+c*att.se, year=as.factor(year)) %>%  # Cálculo das barras de erro
  ggplot(aes(year, att)) +  # Cria o gráfico de ATT por ano
  geom_point(aes(year, att)) +  # Adiciona pontos de ATT
  geom_errorbar(aes(ymin = ymin, ymax = ymax), size = 0.1) +  # Adiciona barras de erro
  labs(title = '', x = 'Tempo de exposição ao programa', y = 'ATT') +  # Rótulos dos eixos
  geom_vline(xintercept = '0', linetype = 'dotted') +  # Linha vertical no tempo 0
  geom_hline(yintercept = 0, linetype = 'dotted') +  # Linha horizontal em ATT = 0
  tema_did  # Tema específico para gráficos de DID
