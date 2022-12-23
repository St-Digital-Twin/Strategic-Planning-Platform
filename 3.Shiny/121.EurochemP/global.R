# Shiny - Приложение. Визуализация работы всего кода

setwd('/mnt/seafiles.dtwin.ru/121.EurochemP')

library(qs)

source('5.R/2.EuroChemFunc.R', encoding = 'UTF-8')
source('5.R/3.UIFunc.R', encoding = 'UTF-8')
source('3.Shiny/121.EurochemP/visnetwork_fun.R', encoding = 'UTF-8')
source('3.Shiny/121.EurochemP/server.R',         encoding = 'UTF-8')
source('3.Shiny/121.EurochemP/ui.R',             encoding = 'UTF-8')

# 6. Shiny                            ####
shinyApp(ui, server)


