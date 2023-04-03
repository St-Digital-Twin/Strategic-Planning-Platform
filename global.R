# Shiny - Приложение. Визуализация работы всего кода
#setwd('/mnt/data-external/Strategic-Planning-Platform/')

library(qs)

source('5.R/2.EuroChemFunc.R', encoding = 'UTF-8')
source('5.R/3.UIFunc.R', encoding = 'UTF-8')
source('visnetwork_fun.R', encoding = 'UTF-8')
source('server.R',         encoding = 'UTF-8')
source('ui.R',             encoding = 'UTF-8')

# 6. Shiny                            ####
shinyApp(ui, server)


