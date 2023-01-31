source('5.R/1.libraries.r')

# 1. Загрузка данных из экселя                              ####
downloadQuotes <- function(excel = TRUE, data = NULL ){
  # Надо перейти на котировки
  if(excel){
    if(is.null(data)){
      quotes <- read.xlsx(xlsxFile = '1.Data/quotes.xlsx')
    }else{
      quotes <- read.xlsx(data)
    }
  # names(quotes) <- str_replace_all(names(quotes), '\\.', ' ')
  quotes <- as.data.table(quotes) %>% 
    setnames(old = names(.), new = c('year', 'month', 'oil', 'euro', 'coal', 'gdp', 'gas', 'methanol'))
  
  }
  
  return(quotes)
}


# 2. Прогнозирование биржевых котировок (сценарных условий) ####
quotesForecast <- function(data                = tar_read(download_files),
                           GDP_before_end_year = -2, # Использую для зактрытия данных за 2020 год
                           GDP_forecast        = 2,
                           xyinya = NULL
                           ){
  
# Прогнозные константы для котировок
 pred_data_const <- data.table(year = 2021:2035, 
                               oil  = 45, 
                               euro = c(1.20, 1.22, 1.24, 1.24, 1.24, 1.24, 1.24, 1.24, 1.24, 1.24, 1.24, 1.24, 1.24, 1.24, 1.24), 
                               coal = c(63.69, 69.6080065625, 74.27375, 75.6, 75.6, 75.6, 75.6, 75.6, 75.6, 75.6, 75.6, 75.6, 75.6, 75.6, 75.6), 
                               gas  = c(3.66448886194379, 4.88572420088728, 5.05664274751648, 5.29190037015231, 4.22940806641501, 4.32245504387614, 4.41754905484142, 4.51473513404793, 4.61405930699698, 4.71556861175092, 4.81931112120944, 4.92533596587605, 5.03369335712532, 5.14443461098208, 5.25761217242368)) %>% 
   .[year >= 2025, oil := oil * cumprod(rep(1.022, length(oil)))]
 
 # Достраивание данных с октября 2020 до 2021. и изменение GDP. При скачивании котировок, этот костыль можно будет убрать
 data <- data[.(2020, 9), gdp := -3, on = c('year', 'month')]
 
 if(last(data$month) < 12){
   data1 <- data.table(year = last(data$year),
              month = (last(data$month) + 1):12, 
              oil = last(data$oil),
              euro = last(data$euro),
              coal = last(data$coal),
              gdp = GDP_before_end_year,
              gas = last(data$gas),
              methanol = NA)
 } else {
   data1 <- data[, lapply(.SD, function(x) x = NA)] %>% na.omit()
 }
 # Прогнозы
 data_forc <- data.table(year = rep((last(data$year) + 1):2035, each = 12), 
                         month = rep(1:12, length((last(data$year) + 1):2035)),
                         gdp = 0,
                         methanol = NA)
 if(last(data$year) == 2020){
   data_forc <- data_forc %>% 
     .[(year == 2021) & (month >= 10), gdp := GDP_forecast] %>% 
     .[year > 2021, gdp := GDP_forecast]
 } else {
   data_forc <- data_forc[year > last(data$year), gdp := GDP_forecast]
 }
 
 data_forc <- merge(data_forc, pred_data_const, by = 'year', all.x = TRUE)
 
 # Объединение
 data_new <- rbindlist(list(data, data1, data_forc), use.names=TRUE)[, gdp_less_1 := ifelse(gdp < 1, gdp, 0)]
 
return(data_new)
}

# 3. Создание модели                                        ####
modelCreation <- function(data   = tar_read(quotes_forecast),
                          bias   = 61.2277,
                          w_oil  = 0.624111,
                          w_coal = 0.62876,
                          w_gas  = 27.31724){
  # Проверил lm и их lm, отличаются
  # fit <- lm(methanol ~ oil + coal + gas, data = na.omit(data, cols = 'Methanol, spot FOB RDAM T2, $'))
  # summary(fit)
  
  # Построенная модель по месяцам
  model_data <- data[, model := bias + w_oil*oil+ w_coal*coal + w_gas*gas] %>%
    .[, `:=`(err = abs(model/methanol - 1))]
  
  # Построенная модель по годам. Они считают среднюю за год, хотя надо брать последнюю
  model_data_year <- copy(model_data)[, lapply(.SD, mean), .SDcols = c('model', 'methanol'), by = year] %>%
    .[, err := abs(model/methanol - 1)]
  
  return(list(model_data      = model_data,
              model_data_year = model_data_year))
}


# 4. График корреляций                                      ####
graphCor <- function(data     = tar_read(model_data)$model_data, # если xlsx, то "1.Data/model_data.xlsx"
                     y_gr     = 'euro',
                     x_gr     = 'oil',
                     str_year = 2012,
                     end_year = 2020,
                     targets  = TRUE # Данные берутся из таргется
){
  
  if(!targets){
    data <- read.xlsx(xlsxFile = data) %>% as.data.table() 
      # setnames(old = names(.), new = c('year', 'month', 'oil', 'euro', 'coal', 'gdp', 'gas', 'methanol'))
  }
  
  if(str_year < min(data$year)){
    str_year <- min(data$year)
  }
  if(end_year > max(data$year)){
    end_year <- max(data$year)
  }
  
  data <- data[year %between% c(str_year, end_year), ]
  
  t <- list(family = "Panton", size = 14, color = 'white')
  ggplotly(ggplot(data, aes(x = .data[[x_gr]], y = .data[[y_gr]])) + 
             geom_point(color = 'white') + 
             geom_smooth(method = 'lm', linetype = 3, color = 'red', se = FALSE, formula = 'y ~ x') + 
             theme (
               #text = element_text(family = "Panton"),
               panel.grid.major.x = element_line(colour = "white", linetype = "dotted"),
               panel.grid.major.y = element_line(colour = "white", linetype = "dotted"),
               legend.position = "bottom",
               legend.box.just = "bottom",
               legend.direction = "horizontal",
               #legend.text.align = 0.001,
               text              = element_text (family = "Panton",
                                                 color  = "white"   ),
               rect              = element_rect (fill   = "black"    ),
               line              = element_line (color  = "black"    ),
               title             = element_text (size   = 15,
                                                 face   = "bold"   ),
               
               legend.title      = element_text (size  = 12,
                                                 color = "white",
                                                 face  = "bold"    ),
               legend.key        = element_rect (fill  = "black"     ),
               legend.background = element_rect (fill  = "black"     ),
               legend.text       = element_text (size  = 12,
                                                 color = "white",
                                                 face  = "bold"    ),
               
               panel.background  = element_rect (fill = "black"),
               panel.grid        = element_blank(),
               
               axis.title.x      = element_text (size  = 16        ),
               axis.title.y      = element_text (size  = 16        ),
               axis.text         = element_text (size  = 12,
                                                 color = "white"    ),
               plot.caption      = element_text (size  = 8,
                                                 face  = "italic",
                                                 color = "white")
             ) + 
             labs(title    = paste0('R2 = ', round(cor(data[[x_gr]], data[[y_gr]])^2, 4), '\n Correlation = ', round(cor(data[[x_gr]], data[[y_gr]]), 4)))
  )  %>% 
    layout(plot_bgcolor = '#343a40') %>%
    layout(paper_bgcolor = '#343a40') %>%
    layout(font = t) %>%
    layout(legend = list(
      orientation = "h",y = -0.25, 
      bgcolor  = '#343a40'))  %>%
    layout(xaxis = list(gridcolor = '#6c757d'),
           yaxis = list(gridcolor = '#6c757d')) 
}

# 5. Графики модели                                         ####
modelGraph <- function(data = tar_read(model_data)$model_data, # '1.Data/model_data.xlsx'
                       str_year = 2012,
                       end_year = 2020,
                       targets  = TRUE # Данные берутся из таргется
                       ){
  
  if(!targets){
    data <- read.xlsx(xlsxFile = data) %>% as.data.table()
  }
  if(str_year < min(data$year)){
    str_year <- min(data$year)
  }
  if(end_year > max(data$year)){
    end_year <- max(data$year)
  }
  # Подготовка данных для кривых
  data_month <- copy(data) %>% 
    .[, rowid := 1:nrow(.)] %>% 
    .[year %between% c(str_year, end_year), ]
    
    #na.omit(., cols = 'methanol')
  
  # Кривая
  curve <- ggplotly(ggplot(data_month, aes(x = rowid)) + 
             geom_line(aes(y = methanol, color = 'methanol')) +
             geom_line(aes(y = model, color = 'model')) +
             scale_x_continuous(name = 'year', breaks = seq(first(data_month$rowid), last(data_month$rowid), by = 12), label = seq(first(data_month$year), last(data_month$year), by = 1)) +
    theme (
      #text = element_text(family = "Panton"),
      panel.grid.major.x = element_line(colour = "white", linetype = "dotted"),
      panel.grid.major.y = element_line(colour = "white", linetype = "dotted"),
      #legend.text.align = 0.001,
      text              = element_text (family = "Panton",
                                        color  = "white"),
      rect              = element_rect (fill   = "black"),
      line              = element_line (color  = "black"),
      title             = element_text (size   = 15,
                                        face   = "bold"),
      
      legend.title      = element_text (size  = 12,
                                        color = "white",
                                        face  = "bold"),
      legend.key        = element_rect (fill  = "black"),
      legend.background = element_rect (fill  = "black"),
      legend.text       = element_text (size  = 12,
                                        color = "white",
                                        face  = "bold"),
      
      panel.background  = element_rect (fill = "black"),
      panel.grid        = element_blank(),
      
      axis.title.x      = element_text (size  = 16),
      axis.title.y      = element_text (size  = 16),
      axis.text         = element_text (size  = 12,
                                        color = "white"),
      plot.caption      = element_text (size  = 8,
                                        face  = "italic",
                                        color = "white")
    ) + 
      scale_color_manual (name = "type:",
                          values = c("methanol" = '#FDC600',"model" = '#6fb3a7')) + 
      ylab('price')
    # labs(title    = paste0('R2 = ', round(cor(data[[x_gr]], data[[y_gr]])^2, 4), '\n Correlation = ', round(cor(data[[x_gr]], data[[y_gr]]), 4)))
  ) %>% 
    layout(legend = list(
      orientation = "h",y = -0.25,
      bgcolor  = 'rgb(0, 46, 69)'))  %>%
    layout(plot_bgcolor = 'rgb(0, 46, 69)') %>%
    layout(paper_bgcolor = 'rgb(0, 46, 69)') %>%
    layout(font = t) %>%
    layout(xaxis = list(gridcolor = 'rgb(150, 150, 150)'),
           yaxis = list(gridcolor = 'rgb(150, 150, 150)'))
  
  
  # Подготовка данных для гистограммы
  
  data_year <- copy(data)[, lapply(.SD, mean), .SDcols = c('model', 'methanol'), by = year] %>% # na.omit(data_year, cols =  'methanol') %>% 
    .[year %between% c(str_year, end_year), ] %>% 
    melt(id.vars = 'year', variable.name = "type", value.name = 'price')
  
  # Гистограмма
  graph_cols <- ggplotly(ggplot(data_year, aes(x = year, y = price, fill = type)) + 
               geom_col(position = 'dodge') +
               scale_fill_manual(values = c("methanol" = 'red',"model" = "white"))  +
             scale_x_continuous(name = 'year', breaks = seq(first(data_year$year), last(data_year$year), by = 1)) +
             theme (
               #text = element_text(family = "Panton"),
               panel.grid.major.x = element_line(colour = "white", linetype = "dotted"),
               panel.grid.major.y = element_line(colour = "white", linetype = "dotted"),
               #legend.text.align = 0.001,
               text              = element_text (family = "Panton",
                                                 color  = "white"),
               rect              = element_rect (fill   = "black"),
               line              = element_line (color  = "black"),
               title             = element_text (size   = 15,
                                                 face   = "bold"),
               
               legend.title      = element_text (size  = 12,
                                                 color = "white",
                                                 face  = "bold"),
               legend.key        = element_rect (fill  = "black"),
               legend.background = element_rect (fill  = "black"),
               legend.text       = element_text (size  = 12,
                                                 color = "white",
                                                 face  = "bold"),
               
               panel.background  = element_rect (fill = "black"),
               panel.grid        = element_blank(),
               
               axis.title.x      = element_text (size  = 16),
               axis.title.y      = element_text (size  = 16),
               axis.text         = element_text (size  = 12,
                                                 color = "white"),
               plot.caption      = element_text (size  = 8,
                                                 face  = "italic",
                                                 color = "white")
             )  
  ) %>% 
    layout(plot_bgcolor = '#343a40') %>%
    layout(paper_bgcolor = '#343a40') %>%
    layout(font = t) %>%
    layout(legend = list(
      orientation = "h",y = -0.25, 
      bgcolor  = '#343a40'))  %>%
    layout(xaxis = list(gridcolor = '#6c757d'),
           yaxis = list(gridcolor = '#6c757d')) 
  
  # Возврат
  return(list(curve      = curve,
              graph_cols = graph_cols))
}

# 6. Отправка отчёта                                        ####
sendReport <- function(data1,data2,data3){}
# 7. Функция интерфейса                                     ####
dashboardMake <- function(data1,data2,data3,data4,data5,data6){}

# 8. Графики рыночных акций                                 ####
marketDataGraph <- function(vec_indic = c('coal', 'gas', 'oil'),
                            str_year = 2012,
                            end_year = 2020,
                            data = tar_read(model_data)$model_data, # '1.Data/model_data.xlsx'
                            targets  = TRUE){
  if(!targets){
    data <- read.xlsx(xlsxFile = data,sep.names = " ") %>% as.data.table()
  }
  if(str_year < min(data$year)){
    str_year <- min(data$year)
  }
  if(end_year > max(data$year)){
    end_year <- max(data$year)
  }
  # Подготовка данных для кривых
  data0 <- copy(data) %>% 
    .[, rowid := 1:nrow(.)] %>% 
    .[, c('year', 'rowid', vec_indic), with = FALSE] %>% 
    .[year %between% c(str_year, end_year), ] %>% 
    melt(measure = vec_indic, variable.name = "type", value.name = 'price')
  #na.omit(., cols = 'methanol')
  
  # Кривая
  ggplotly(ggplot(data0, aes(x = rowid, y = price, color = type)) + 
                  geom_line() + scale_color_manual(values=c("red","#FFFFFF", "#3D9970", "#FFA500", "#1C80AC")) +
             # scale_colour_manual(values = c('#FDC600','#637672')) +
                  scale_x_continuous(name = 'year', breaks = seq(first(data0$rowid), last(data0$rowid), by = 12), label = seq(first(data0$year), last(data0$year), by = 1)) +
                           theme (
                             #text = element_text(family = "Panton"),
                             panel.grid.major.x = element_line(colour = "white", linetype = "dotted"),
                             panel.grid.major.y = element_line(colour = "white", linetype = "dotted"),
                             #legend.text.align = 0.001,
                             text              = element_text (family = "Panton",
                                                               color  = "white"),
                             rect              = element_rect (fill   = "black"),
                             line              = element_line (color  = "black"),
                             title             = element_text (size   = 15,
                                                               face   = "bold"),
                             
                             legend.title      = element_text (size  = 12,
                                                               color = "white",
                                                               face  = "bold"),
                             legend.key        = element_rect (fill  = "black"),
                             legend.background = element_rect (fill  = "black"),
                             legend.text       = element_text (size  = 12,
                                                               color = "white",
                                                               face  = "bold"),
                             
                             panel.background  = element_rect (fill = "black"),
                             panel.grid        = element_blank(),
                             
                             axis.title.x      = element_text (size  = 16),
                             axis.title.y      = element_text (size  = 16),
                             axis.text         = element_text (size  = 12,
                                                               color = "white"),
                             plot.caption      = element_text (size  = 8,
                                                               face  = "italic",
                                                               color = "white")
                           )
  ) %>% 
    layout(plot_bgcolor = '#343a40') %>%
    layout(paper_bgcolor = '#343a40') %>%
    layout(font = t) %>%
    layout(legend = list(
      orientation = "h",y = -0.25, 
      bgcolor  = '#343a40'))  %>%
    layout(xaxis = list(gridcolor = '#6c757d'),
           yaxis = list(gridcolor = '#6c757d')) 
}
# 8. Графики рыночных акций                                 ####
marketDataGraph2 <- function(vec_indic = c('coal', 'gas', 'oil'),
                            str_year = 2012,
                            end_year = 2020,
                            data = tar_read(model_data)$model_data, # '1.Data/model_data.xlsx'
                            targets  = TRUE){
  if(!targets){
    data <- read.xlsx(xlsxFile = data,sep.names = " ") %>% as.data.table()
  }
  if(str_year < min(data$year)){
    str_year <- min(data$year)
  }
  if(end_year > max(data$year)){
    end_year <- max(data$year)
  }
  # Подготовка данных для кривых
  data0 <- copy(data) %>% 
    .[, rowid := 1:nrow(.)] %>% 
    .[, c('year', 'rowid', vec_indic), with = FALSE] %>% 
    .[year %between% c(str_year, end_year), ] %>% 
    melt(measure = vec_indic, variable.name = "type", value.name = 'price')
  #na.omit(., cols = 'methanol')
  
  # Кривая
  ggplotly(ggplot(data0, aes(x = rowid, y = price, color = type)) + 
             geom_line() + scale_color_manual(values=c("red","#343A40", "#3D9970", "#FFA500", "#1C80AC","#35BF35","#010AFF","#FBCAA1")) +
             # scale_colour_manual(values = c('#FDC600','#637672')) +
             scale_x_continuous(name = 'year', breaks = seq(first(data0$rowid), last(data0$rowid), by = 12), label = seq(first(data0$year), last(data0$year), by = 1)) +
             theme (
               #text = element_text(family = "Panton"),
               panel.grid.major.x = element_line(colour = "white", linetype = "dotted"),
               panel.grid.major.y = element_line(colour = "white", linetype = "dotted"),
               #legend.text.align = 0.001,
               text              = element_text (family = "Panton",
                                                 color  = "black"),
               rect              = element_rect (fill   = "black"),
               line              = element_line (color  = "black"),
               title             = element_text (size   = 15,
                                                 face   = "bold"),
               
               legend.title      = element_text (size  = 12,
                                                 color = "black",
                                                 face  = "bold"),
               legend.key        = element_rect (fill  = "black"),
               legend.background = element_rect (fill  = "black"),
               legend.text       = element_text (size  = 12,
                                                 color = "black",
                                                 face  = "bold"),
               
               panel.background  = element_rect (fill = "black"),
               panel.grid        = element_blank(),
               
               axis.title.x      = element_text (size  = 16),
               axis.title.y      = element_text (size  = 16),
               axis.text         = element_text (size  = 12,
                                                 color = "black"),
               plot.caption      = element_text (size  = 8,
                                                 face  = "italic",
                                                 color = "white")
             )
  ) %>% 
    layout(plot_bgcolor = 'white') %>%
    layout(paper_bgcolor = 'white') %>%
    layout(font = t) %>%
    layout(legend = list(
      orientation = "h",y = -0.25, 
      bgcolor  = 'white'))  %>%
    layout(xaxis = list(gridcolor = '#CCCCCC'),
           yaxis = list(gridcolor = '#CCCCCC')) 
}