# 1. Место хранения файлов            ####
path <- "1.Data/view_in_shiny_like_files"
vec_of_files <- list.files(path = path)
data <- tar_read(model_data)$model_data
list_axis_cor <- names(data)[which(names(data) %!in% c('year', 'month', 'gdp_less_1', "model", "err"))] # Определение названий осей по колонкам
# 2. Преобразование данных            ####

# Преобразование
alko_vec <- c('Algorithm 1','Algorithm 2','Algorithm 3','Algorithm 4')
visual_layout_processing <-  fluidRow(
  selectizeInput('alko', label = 'Algorythm', choices = alko_vec, options = list(create = TRUE), selected = 'Algorithm 1', multiple = TRUE),
  sliderInput('market_year', 'Year', min = min(data$year), max = max(data$year), value = c(2012, 2020), sep = ''),
  actionButton("update_data", "Update data", style = "color: #001F3F; background-color: #FDC600; border-color: #FDC600")
)
# Графики
# box 1
list_box1_processing <- c("methanol", 'Algorithm 1')
list_box2_processing <- names(data)[which(names(data) %!in% c('year', 'month', 'gdp_less_1', "err"))] # Определение названий осей по колонкам
