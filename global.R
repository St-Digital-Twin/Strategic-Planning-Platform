# Центральный файл для запуска отдельных функций таргетса
source("5.R/1.libraries.r")

tar_make(download_files)
tar_make(correlation_graph)
tar_make(quotes_forecast)
tar_make(model_data)
tar_make(model_graph)
tar_make(send_report)
tar_make(dashboard)
