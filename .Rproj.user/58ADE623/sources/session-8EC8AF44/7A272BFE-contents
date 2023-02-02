# Shiny - Приложение. Визуализация работы всего кода

source('5.R/2.EuroChemFunc.R', encoding = 'UTF-8')
# 1. Место хранения файлов            ####
path <- "1.Data/view_in_shiny_like_files"
vec_of_files <- list.files(path = path)
data <- tar_read(model_data)$model_data
list_axis_cor <- names(data)[which(names(data) %!in% c('year', 'month', 'gdp_less_1', "model", "err"))] # Определение названий осей по колонкам
# 2. Преобразование данных            ####

# Преобразование
alko_vec <- 'Algorithm 1'
visual_layout_processing <- list(
  selectizeInput('alko', label = 'Algorythm', choices = alko_vec, options = list(create = TRUE), selected = "algorithm 1"),
  sliderInput('market_year', 'Year', min = min(data$year), max = max(data$year), value = c(2012, 2020), sep = ''),
  actionButton("update_data", "Update data", style = "color: #001F3F; background-color: #FDC600; border-color: #FDC600")
  )
# Графики
# box 1
list_box1_processing <- c("methanol", 'model')
visual_layout_graphic1_processing <- list(
  selectizeInput('proc_list1', label = 'Curve data', choices = list_box1_processing, options = list(create = TRUE), selected = list_box1_processing, multiple = TRUE),
  plotlyOutput('proc_graph1') %>% withSpinner(type = getOption("spinner.type", default = 6),color = "#FDC600")
)

# box 2
list_box2_processing <- names(data)[which(names(data) %!in% c('year', 'month', 'gdp_less_1', "err"))] # Определение названий осей по колонкам
visual_layout_graphic2_processing <- list(
  selectizeInput('proc_list2', label = 'Curve data', choices = list_box2_processing, options = list(create = TRUE), selected = c('gas', 'gdp'), multiple = TRUE),
  plotlyOutput('proc_graph2') %>% withSpinner(type = getOption("spinner.type", default = 6),color = "#FDC600")
)
# 3. Раздел меню с общими настройками ####
visual_layout_loading <- list(
                             fileInput("user_file", "Send File", accept = ".csv"), 
                             selectizeInput("from_where", label = "Choose input", choices = c("File","Downloaded"),options = list(create = TRUE), selected = "File"),
                             uiOutput("id2")
                             # actionButton("send_email", "Send Report", style="color: #001F3F; background-color: #FDC600; border-color: #FDC600")
                            # actionButton("update_data", "Update data", style="color: #001F3F; background-color: #FDC600; border-color: #FDC600")
                            )

# 4. Раздел меню с графиками          ####
# Попарные корреляции
visual_layout_corr <- list(
  
  menuItem("First correlation graphic",selectizeInput("Y_1", label = "Choose Y axis for first graph", choices = list_axis_cor, options = list(create = TRUE), selected = 'euro'),
           selectizeInput("X_1", label = "Choose X axis for first graph", choices = list_axis_cor, options = list(create = TRUE), selected = 'oil'),
           sliderInput('first_graph_year', 'Year', min = min(data$year), max = max(data$year), value = c(2012, 2020), sep = '')),   
  
  menuItem("Second correlation graphic", selectizeInput("Y_2", label = "Choose Y axis for second graph", choices = list_axis_cor, options = list(create = TRUE), selected = 'euro'),
           selectizeInput("X_2", label = "Choose X axis for second graph", choices = list_axis_cor, options = list(create = TRUE), selected = 'oil'),
           sliderInput('second_graph_year', 'Year', min = min(data$year), max = max(data$year), value = c(2012, 2020), sep = '')
  )
)
 
# Кривая и гистограмма
visual_layout_model <- list(
  sliderInput('model_year', 'Year', min = min(data$year), max = max(data$year), value = c(2012, 2020), sep = '')
)

# Общий
visual_layout_graphic <- list(
  menuItem('Correlation graphic', visual_layout_corr),
  menuItem('Model graphic', visual_layout_model),
  textInput("email_pol", "Write email for reporting", "n.burakov@dtwin.ru"),
  actionButton("send_email", "Send Report", style="color: #001F3F; background-color: #FDC600; border-color: #FDC600")
)


# 5. Загрузка                         ####
source('3.Shiny/121.EurochemP/visnetwork_fun.R', encoding = 'UTF-8')
source('3.Shiny/121.EurochemP/server.R',         encoding = 'UTF-8')
source('3.Shiny/121.EurochemP/ui.R',             encoding = 'UTF-8')

# 6. Shiny                            ####
shinyApp(ui, server)

