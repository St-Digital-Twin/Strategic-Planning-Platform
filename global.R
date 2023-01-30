# Shiny - Приложение. Визуализация работы всего кода
source('5.R/2.EuroChemFunc.R', encoding = 'UTF-8')
source('5.R/3.UIFunc.R', encoding = 'UTF-8')
source('visnetwork_fun.R', encoding = 'UTF-8')
source('server.R',encoding = 'UTF-8')
translete <- as.data.table(read.xlsx("1.Data/208_dt_asset_en(updated).xlsx",sheet = "Teb")) %>%
  melt(id.vars = c("Key","Remark"))
source('ui.R',  encoding = 'UTF-8')

# translete <-as.data.table(read.xlsx("1.Data/208_dt_asset_en(updated).xlsx",sheet = "Teb")) %>% 
#   melt(id.vars = c("Key","Remark"))


# 6. Shiny                            ####
shinyApp(ui, server)


