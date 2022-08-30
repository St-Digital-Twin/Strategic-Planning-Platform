# Таргетс. Используется для преобразования функций в систему потока данных с узлами 

source("5.R/1.libraries.r")
source('5.R/2.EuroChemFunc.R')
tar_config_set(script = "_targets.R", store="_targets")

files_read  <- tar_map(values = tibble(set_vec = list.files(path = "1.Data/view_in_shiny_like_files")), 
                       tar_target(download,
                                  downloadQuotes(data = paste0("1.Data/view_in_shiny_like_files/",set_vec))))
files_read_combine <- tar_combine(download_files,         # имя нового узла
                                  files_read,
                                  cue = tar_cue(mode = "thorough"))

list(
  # tar_target(source_ww_price, 
  #            downloadQuotes(), 
  #            cue = tar_cue(mode = "thorough")),
  tar_target(quotes_forecast,
             quotesForecast(data = download_files[1:105,]), 
             cue = tar_cue(mode = "thorough")),
  tar_target(model_data,
             modelCreation(data = quotes_forecast), 
             cue = tar_cue(mode = "thorough")),
  tar_target(model_graph,
             modelGraph(data = model_data$model_data), 
             cue = tar_cue(mode = "thorough")),
  tar_target(correlation_graph,
             graphCor(data = model_data$model_data), 
             cue = tar_cue(mode = "thorough")),
  tar_target(send_report,
             sendReport(model_graph, model_data,correlation_graph), 
             cue = tar_cue(mode = "thorough")),
  tar_target(dashboard,
             dashboardMake(model_graph, model_data,correlation_graph, send_report, quotes_forecast,download_files), 
             cue = tar_cue(mode = "thorough")),
  
  files_read,
  files_read_combine
)

