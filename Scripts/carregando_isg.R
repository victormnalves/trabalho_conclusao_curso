library(tidyverse)

# Criar vetores com os anos de interesse
years1 <- 2008:2022  # Anos 

# Inicializar listas vazias para armazenar os dados
formato1 <- list()

# Loop para ler os arquivos
for (year in years1) {
  # Criando o caminho do arquivo
  formato1_file <- sprintf("D:/OneDrive - Insper - Instituto de Ensino e Pesquisa/Estudos/Insper/TCC/Dados/dados_isg/%04d.xls", year)
  
  # Verificar se o arquivo existe
  if (file.exists(formato1_file)) {
    # Ler o arquivo Excel (sheet "Escolas", pulando as 4 primeiras linhas)
    formato1[[as.character(year)]] <- readxl::read_xls(formato1_file, sheet = "Escolas", skip = 4) %>% 
      janitor::clean_names() %>% 
      mutate(ano = year)
  } else {
    message(sprintf("Arquivo do ISG para o ano %04d não encontrado.", year))
  }
  
  # Chamando garbage collector (opcional)
  gc()
}

dados_isg <- dplyr::bind_rows(formato1) %>% 
  filter(escola_integral_no_ensino_medio  == 1)

write.csv(dados_isg, "D:/OneDrive - Insper - Instituto de Ensino e Pesquisa/Estudos/Insper/TCC/Dados/dados_isg.csv", row.names = FALSE)
