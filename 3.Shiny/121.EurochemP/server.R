# setwd("/mnt/github/Strategic-Planning-Platform")
server <- function(input, output,  session) {
# 1. Инструкция пользователя 1                          ####  
  output$inst1 <- renderUI({
    str1 <- paste("Ниже представлена структура потока преобразования данных.")
    str2 <- paste("Варианты взаимодействия с графом:")
    str3 <- paste("1. При нажатии ниже появляется таблица с данными выбранного узла.")
    str4 <-   paste("2. При двойном нажатии отображаются входные и выходные потоки для данного графа.")
    str4.1 <- paste("2.1. Выйти из режима можно путем нажатия на узел с подписью «Свернутый узел».")
    str5 <- paste("3. Интерфейс позволяет менять взаиморасположение узлов и сохранять его при помощи кнопки «Save Positions».")
    str6 <- paste("3. При наведении поялвяется подсказка указывающая к какой группе аппераций над данными принадлежит выбранный узел.")
    HTML(paste(str1, str2,str3,str4,str4.1,str5, sep = '<br/>'))
  })
# 2. Инструкция пользователя 2                          ####  
  output$inst2 <- renderUI({
    str1 <- paste("1. При нажатии на узел ниже поялвяется настраиваемая таблица с содержанием узла (не все узлы содержат данные, некоторые узлы отвечают за отрисовку, об этом при наведении появится уведомление).")
    str2 <- paste("2. Нажав на стрелочки у названия колонки можно отсортировать таблицу по этой колонке.")
    str3 <- paste("3. В окне поиска можно найти интересующее зачение.")
    str4 <- paste("4. Есть возможность листать страницы данных и выбирать количество записей на одной странице.")
    str5 <- paste("5. Все окна могут быть свернуты нажатием на «-» в правом верхнем углу бокса.")
    HTML(paste(str1, str2,str3,str4,str5, sep = '<br/>'))
    
  })
# 3. Инструкция пользователя 3                          ####
  output$inst3 <- renderUI({
    str1 <- paste("1. Для отображения данных используются два графика попарных корреляций, а также отображение данных модели в формате линейной диаграммы и гистограммы.")
    str2 <- paste("2. Графики модели настраиваются вместе и есть возможность изменения временного интервала в разделе «Model graphic».")
    str3 <- paste("3. У графиков попарной корреляции можно настраивать данные по осям и временной интервал в разделе «Correlation graphic».")
    str4 <- paste("4. Есть возможность выбора файла для анализа с помощью выпадающего списка «Choose input» в разделе «Common settings».")
    HTML(paste(str1, str2,str3,str4, sep = '<br/>'))
    
  })
# 4. Инструкция пользователя 4                          ####
  output$inst4 <- renderUI({
    str1 <- paste("1. Есть возможность загрузки пользовательского файла в разделе «Common settings» кнопкой «Browser».")
    str2 <- paste("2. Существующие параметры графиков и данные можно сохранить в виде отчета для этого в разделе «Common settings» в поле вода нужно ввести свою почту и нажать кнопку отправки, на почту придет автоматически сформированный отчет.")
    str3 <- paste("3. При нажатии кнопки «Update data» все узлы и цепочки расчетов пересчитаются с учетом новых загруженных пользователем файлов.")
    HTML(paste(str1, str2,str3,sep = '<br/>'))
  })
# 5. Проверка загруженных файлов                        ####
vec_of_files2 <- reactiveValues(a = vec_of_files)
    
    
# 6. Логотип                                            ####
    output$logo <- renderImage({
      list(src = '8.Pic/15.png',
           # contentType = 'image/png',
           width = 150,
           vspace = 20,
           hspace = 20,
           # # width = 400,
           # height = 60,
           alt = "https://www.eurochemgroup.com/")
      
    }, deleteFile = FALSE)

# 7. Выбор файла из списка                              ####        
    output$id2 <- 
      renderUI({
        req(input$from_where)
        if(input$from_where == "File"){
          selectizeInput(inputId = "nd_file",
                         label = "Choose file",
                         choices = vec_of_files2$a,
                         options = list(create = TRUE), selected = vec_of_files2$a[1], multiple = FALSE) 
        }
      })
# 8. Показ контента узла по клику  (те что не таблицы)  ####            
    output$id3 <- 
      renderUI({
        req(input$click)
        if(is.null(input$click)){
          id0 <-  4
        }else{
          if(str_count(input$click) > 5){
            id0 <-  4
          }else{
            id0 <- as.numeric(input$click)  
          }
        }
        data <- read.xlsx("1.Data/2.shiny/coords.xlsx") %>% filter(id == id0) %>% select(label) %>% deframe()
        table0 <- tar_read_raw(data)
        if(is.data.table(table0)){
          table0 <- list(table0)
        }
        if(is.null(table0) | !is.data.table(table0[[1]])){
          g <- 1
        }else{
          g <- 0
        }
        if(g == 0){
          tagList(
          textInput("name_file", "White name for saving", "eurochem",width =  '30%'),
          actionButton("down", "Download as Excel file", style = "color: #001F3F; background-color: #FDC600; border-color: #FDC600"),
          rHandsontableOutput('table'))
        }else{
          if(data == "model_graph"){
            tagList(
              box(width = 6,title = 'Model graph first',background = "navy", collapsible = TRUE,
                  plotlyOutput('model_graph1') %>% withSpinner(type = getOption("spinner.type", default = 6),color = "#FDC600")),
              box(width = 6,title = 'Model graph second',background = "navy", collapsible = TRUE,
                  plotlyOutput('model_graph2') %>% withSpinner(type = getOption("spinner.type", default = 6),color = "#FDC600")))
          }else{
            if(data == "correlation_graph"){
                tagList(
                  box(width = 6,title = 'Correlation graph first',background = "navy", collapsible = TRUE,
                      plotlyOutput('cor_pot1') %>% withSpinner(type = getOption("spinner.type", default = 6),color = "#FDC600")),
                  box(width = 6,title = 'Correlation graph second',background = "navy", collapsible = TRUE,
                      plotlyOutput('cor_pot2') %>% withSpinner(type = getOption("spinner.type", default = 6),color = "#FDC600")),
                  box(width = 12,title = a('All quarterly correlation', style = 'color:#001F3F; vspace:1;'),background = "gray", collapsible = TRUE,
                      plotlyOutput('cor_pot3',height = "700px") %>% withSpinner(type = getOption("spinner.type", default = 6),color = "#001F3F")))
            }else{
              if(data == "send_report"){
                dataTableOutput('table2')
                }
            } 
            
            
          }
        }
      })
# 9. Вывод графика всевозможных кореляций               ####  
    output$cor_pot3 <- renderPlotly({
      k <- read.xlsx(paste0(path,"/",input$nd_file))
      ggplotly(ggpairs((k %>% mutate(month = as.character(month %% 4))), ggplot2::aes(colour = month),
                       columns = 3:8, title = "All quarterly correlation",
                       upper = list(continuous = wrap("cor", alpha = 1)),
                       lower = list(continuous = wrap("points", alpha = 1,    size = 0.5)),
                       diag = list(continuous =  wrap("densityDiag", alpha = 0.3,    size = 0.5))))
    })
    
# 10. Отправка динамического отчета на email            ####
    observeEvent(input$send_email, {
      reqipient <- input$email_pol
      knit2html("1.Data/testrmd.Rmd", options = "")
      send.mail(from = "<nikbrown35@gmail.com>",
                to = paste0("<",reqipient,">"),
                subject = paste0("Report on file : ",input$nd_file),
                body = "testrmd.html",
                html = TRUE,
                inline = TRUE,
                smtp = list(host.name = "smtp.gmail.com",
                            port = 465,
                            user.name = "dtwin496@gmail.com",
                            passwd = "cfdocpmuldwewwhq",
                            ssl = TRUE),
                authenticate = TRUE,
                encoding = "utf-8")
      k <- data.frame(time = Sys.time(), Status = "Succsesfull", recipient_mail = reqipient)
      write_delim(k,"1.Data/send_report/reports.csv",delim = ",",append = TRUE)
      showModal(modalDialog(
        "Send",
        size = 's',
        easyClose = TRUE
      ))
    })
# 11. Сохранение промежуточной таблицы вычислений       ####
    observeEvent(input$down,
                 {
                   if (!is.null(isolate(input$table))){
                     x <- hot_to_r(isolate(input$table))
                     write.xlsx(x, file = paste0('1.Data/3. Saved files/',input$name_file,'.xlsx'))
                     showModal(modalDialog(
                       "Saved",
                       size = 's',
                       easyClose = TRUE
                     ))
                   }else{
                     showModal(modalDialog(
                       "Error",
                       size = 's',
                       easyClose = TRUE
                     ))
                   }
                   
                 })
# 12. Вывод таблицы логов отправки отчета на почту      ####
    output$table2 <- renderDataTable({
      k <- read_delim("1.Data/send_report/reports.csv")
      k
    })
# 13. Вывод изменяемой таблицы по клику                 ####
    output$table <- renderRHandsontable({
      if(is.null(input$click)){
        id0 <-  4
      }else{
        if(str_count(input$click) > 5){
          id0 <-  4
        }else{
          id0 <- as.numeric(input$click)  
        }
      }
      data <- read.xlsx("1.Data/2.shiny/coords.xlsx") %>% filter(id == id0) %>% select(label) %>% deframe()
      table0 <- tar_read_raw(data)
      if(is.data.table(table0)){
        table0 <- list(table0)
      }
      if(is.null(table0) | !is.data.table(table0[[1]])){
        data.table(Message = "It is not a table target")
      }else{
        rhandsontable(table0[[1]], stretchH = "all", useTypes = F,height = 600) %>%
          hot_context_menu(
            customOpts = list(
              csv = list(name = "Download to CSV",
                         callback = htmlwidgets::JS(
                           "function (key, options) {
                         var csv = csvString(this, sep=',', dec='.');

                         var link = document.createElement('a');
                         link.setAttribute('href', 'data:text/plain;charset=utf-8,' +
                           encodeURIComponent(csv));
                         link.setAttribute('download', 'data.csv');

                         document.body.appendChild(link);
                         link.click();
                         document.body.removeChild(link);
                       }")),
              search = list(name = "Search",
                            callback = htmlwidgets::JS(
                              "function (key, options) {
                         var srch = prompt('Search criteria');

                         this.search.query(srch);
                         this.render();
                       }")))) %>%
          hot_cols(columnSorting = TRUE) %>%
          hot_table(highlightCol = TRUE, highlightRow = TRUE)
      }
      })
# 14. Загрузка пользовательского файла                  ####
    observeEvent(input$user_file, {
      file <- input$user_file
      ext <- tools::file_ext(file$datapath)
      l <- read.xlsx(file$datapath)
      write.xlsx(l,paste0("1.Data/view_in_shiny_like_files/",file$name))
      vec_of_files2$a <-  list.files(path = path)
      new_graph <- get_graph()
      pipeline$n <- new_graph$n
      pipeline$e <- new_graph$e
      tar_make(download_files)
    })
    
# 15. Запуск перерасчета всей цепочки по новым данным   ####
    observeEvent(input$update_data, {
      tar_make(dashboard)
      new_graph <- get_graph()
      pipeline$n <- new_graph$n
      pipeline$e <- new_graph$e
      tar_make(download_files)
      
      showModal(modalDialog(
        "Updated",
        size = 's',
        easyClose = TRUE
      ))
    })
    
# 16. Первый корреляционный график                      ####
    output$cor_pot1 <- renderPlotly({
      if(input$from_where == "File"){
        if(!is.null(input$nd_file)){
          quotesForecast <- quotesForecast(read.xlsx(paste0(path,"/",input$nd_file)) %>% as.data.table())
          modelCreation <- modelCreation(quotesForecast)$model_data
          write.xlsx(modelCreation, "1.Data/tempdata.xlsx")
          write.csv(tibble(file = input$nd_file, 
                           x_gr = input$X_1, 
                           y_gr = input$Y_1, 
                           str_year = input$first_graph_year[1], 
                           end_year = input$first_graph_year[2],
                           x_gr2 = input$X_2, 
                           y_gr2 = input$Y_2, 
                           str_year2 = input$second_graph_year[1], 
                           end_year2 = input$second_graph_year[2],
                           model_year = input$model_year[1], 
                           model_end_year = input$model_year[2]),"1.Data/Rmddata.csv")
          p <- graphCor(data = "1.Data/tempdata.xlsx", targets = FALSE, x_gr = input$X_1, y_gr = input$Y_1, str_year = input$first_graph_year[1], end_year = input$first_graph_year[2])
          p %>%
            layout(
              images = list(
                source = base64enc::dataURI(file = '8.Pic/15.png'),
                x = 0.82, y = 1.05 ,
                sizex = 0.18, sizey = 0.1,
                xref = "paper", yref = "paper",
                xanchor = "left", yanchor = "bottom"
              ),
              margin = list(t = 50)
            )
        }
      } else if(input$from_where == "Downloaded"){
        write.csv(tibble(file = "quotes_agregation_level1.xlsx", 
                         x_gr = input$X_1, 
                         y_gr = input$Y_1, 
                         str_year = input$first_graph_year[1], 
                         end_year = input$first_graph_year[2],
                         x_gr2 = input$X_2, 
                         y_gr2 = input$Y_2, 
                         str_year2 = input$second_graph_year[1], 
                         end_year2 = input$second_graph_year[2],
                         model_year = input$model_year[1], 
                         model_end_year = input$model_year[2]),"1.Data/Rmddata.csv")
        p <- graphCor(x_gr = input$X_1, y_gr = input$Y_1, str_year = input$first_graph_year[1], end_year = input$first_graph_year[2])
        p %>%
          layout(
            images = list(
              source = base64enc::dataURI(file = '8.Pic/15.png'),
              x = 0.82, y = 1.05 ,
              sizex = 0.18, sizey = 0.1,
              xref = "paper", yref = "paper",
              xanchor = "left", yanchor = "bottom"
            ),
            margin = list(t = 50)
          )
      }
    })
    
    
# 17. Второй корреляционный график                      ####    
    output$cor_pot2 <- renderPlotly({
      if(input$from_where == "File"){
        if(!is.null(input$nd_file)){
          quotesForecast <- quotesForecast(read.xlsx(paste0(path,"/",input$nd_file)) %>% as.data.table())
          modelCreation <- modelCreation(quotesForecast)$model_data
          write.xlsx(modelCreation, "1.Data/tempdata.xlsx")
          write.csv(tibble(file = input$nd_file, 
                           x_gr = input$X_1, 
                           y_gr = input$Y_1, 
                           str_year = input$first_graph_year[1], 
                           end_year = input$first_graph_year[2],
                           x_gr2 = input$X_2, 
                           y_gr2 = input$Y_2, 
                           str_year2 = input$second_graph_year[1], 
                           end_year2 = input$second_graph_year[2],
                           model_year = input$model_year[1], 
                           model_end_year = input$model_year[2]),"1.Data/Rmddata.csv")
          p <- graphCor(data = "1.Data/tempdata.xlsx", targets = FALSE, x_gr = input$X_2, y_gr = input$Y_2, str_year = input$second_graph_year[1], end_year = input$second_graph_year[2])
          p %>%
            layout(
              images = list(
                source = base64enc::dataURI(file = '8.Pic/15.png'),
                x = 0.82, y = 1.05 ,
                sizex = 0.18, sizey = 0.1,
                xref = "paper", yref = "paper",
                xanchor = "left", yanchor = "bottom"
              ),
              margin = list(t = 50)
            )
        }
      } else if(input$from_where == "Downloaded"){
        write.csv(tibble(file = "quotes_agregation_level1.xlsx", 
                         x_gr = input$X_1, 
                         y_gr = input$Y_1, 
                         str_year = input$first_graph_year[1], 
                         end_year = input$first_graph_year[2],
                         x_gr2 = input$X_2, 
                         y_gr2 = input$Y_2, 
                         str_year2 = input$second_graph_year[1], 
                         end_year2 = input$second_graph_year[2],
                         model_year = input$model_year[1], 
                         model_end_year = input$model_year[2]),"1.Data/Rmddata.csv")
        p <- graphCor(x_gr = input$X_2, y_gr = input$Y_2, str_year = input$second_graph_year[1], end_year = input$second_graph_year[2])
        p %>%
          layout(
            images = list(
              source = base64enc::dataURI(file = '8.Pic/15.png'),
              x = 0.82, y = 1.05 ,
              sizex = 0.18, sizey = 0.1,
              xref = "paper", yref = "paper",
              xanchor = "left", yanchor = "bottom"
            ),
            margin = list(t = 50)
          )
      }
    })
    
    
# 18. Линейный график модели                            ####
    output$model_graph1 <- renderPlotly({
      if(input$from_where == "File"){
        if(!is.null(input$nd_file)){
          quotesForecast <- quotesForecast(read.xlsx(paste0(path,"/",input$nd_file)) %>% as.data.table())
          modelCreation <- modelCreation(quotesForecast)$model_data
          write.xlsx(modelCreation, "1.Data/tempdata.xlsx")
          write.csv(tibble(file = input$nd_file, 
                           x_gr = input$X_1, 
                           y_gr = input$Y_1, 
                           str_year = input$first_graph_year[1], 
                           end_year = input$first_graph_year[2],
                           x_gr2 = input$X_2, 
                           y_gr2 = input$Y_2, 
                           str_year2 = input$second_graph_year[1], 
                           end_year2 = input$second_graph_year[2],
                           model_year = input$model_year[1], 
                           model_end_year = input$model_year[2]),"1.Data/Rmddata.csv")
          p <- modelGraph(data = "1.Data/tempdata.xlsx", targets = FALSE, str_year = input$model_year[1], end_year = input$model_year[2])
          
         # p <- modelGraph(data = paste0(path,"/",input$nd_file), targets = FALSE)
          p$curve %>%
            layout(
              images = list(
                source = base64enc::dataURI(file = '8.Pic/15.png'),
                x = 0.82, y = 1.05 ,
                sizex = 0.18, sizey = 0.1,
                xref = "paper", yref = "paper",
                xanchor = "left", yanchor = "bottom"
              ),
              margin = list(t = 50)
            )
          }
      } else if(input$from_where == "Downloaded"){
        write.csv(tibble(file = "quotes_agregation_level1.xlsx", 
                         x_gr = input$X_1, 
                         y_gr = input$Y_1, 
                         str_year = input$first_graph_year[1], 
                         end_year = input$first_graph_year[2],
                         x_gr2 = input$X_2, 
                         y_gr2 = input$Y_2, 
                         str_year2 = input$second_graph_year[1], 
                         end_year2 = input$second_graph_year[2],
                         model_year = input$model_year[1], 
                         model_end_year = input$model_year[2]),"1.Data/Rmddata.csv")
        p <- modelGraph(str_year = input$model_year[1], end_year = input$model_year[2])
        
        # p <- modelGraph(data = paste0(path,"/",input$nd_file), targets = FALSE)
        p$curve %>%
          layout(
            images = list(
              source = base64enc::dataURI(file = '8.Pic/15.png'),
              x = 0.82, y = 1.05 ,
              sizex = 0.18, sizey = 0.1,
              xref = "paper", yref = "paper",
              xanchor = "left", yanchor = "bottom"
            ),
            margin = list(t = 50)
          )
      }
    })
    
# 19. График модели - гистограмма                       ####
    output$model_graph2 <- renderPlotly({
      if(input$from_where == "File"){
        if(!is.null(input$nd_file)){
          quotesForecast <- quotesForecast(read.xlsx(paste0(path,"/",input$nd_file)) %>% as.data.table())
          modelCreation <- modelCreation(quotesForecast)$model_data
          write.xlsx(modelCreation, "1.Data/tempdata.xlsx")
          write.csv(tibble(file = input$nd_file, 
                           x_gr = input$X_1, 
                           y_gr = input$Y_1, 
                           str_year = input$first_graph_year[1], 
                           end_year = input$first_graph_year[2],
                           x_gr2 = input$X_2, 
                           y_gr2 = input$Y_2, 
                           str_year2 = input$second_graph_year[1], 
                           end_year2 = input$second_graph_year[2],
                           model_year = input$model_year[1], 
                           model_end_year = input$model_year[2]),"1.Data/Rmddata.csv")
          p <- modelGraph(data = "1.Data/tempdata.xlsx", targets = FALSE, str_year = input$model_year[1], end_year = input$model_year[2])
          p$graph_cols %>%
            layout(
              images = list(
                source = base64enc::dataURI(file = '8.Pic/15.png'),
                x = 0.82, y = 1.05 ,
                sizex = 0.18, sizey = 0.1,
                xref = "paper", yref = "paper",
                xanchor = "left", yanchor = "bottom"
              ),
              margin = list(t = 50)
            )
          }
      } else if(input$from_where == "Downloaded"){
        write.csv(tibble(file = "quotes_agregation_level1.xlsx", 
                         x_gr = input$X_1, 
                         y_gr = input$Y_1, 
                         str_year = input$first_graph_year[1], 
                         end_year = input$first_graph_year[2],
                         x_gr2 = input$X_2, 
                         y_gr2 = input$Y_2, 
                         str_year2 = input$second_graph_year[1], 
                         end_year2 = input$second_graph_year[2],
                         model_year = input$model_year[1], 
                         model_end_year = input$model_year[2]),"1.Data/Rmddata.csv")
        p <- modelGraph(str_year = input$model_year[1], end_year = input$model_year[2])
        
        # p <- modelGraph(data = paste0(path,"/",input$nd_file), targets = FALSE)
        p$graph_cols %>%
          layout(
            images = list(
              source = base64enc::dataURI(file = '8.Pic/15.png'),
              x = 0.82, y = 1.05 ,
              sizex = 0.18, sizey = 0.1,
              xref = "paper", yref = "paper",
              xanchor = "left", yanchor = "bottom"
            ),
            margin = list(t = 50)
          )
      }
    })

    
    
# 20. Вывод графа с пайплайном                          ####
      pipeline        <- reactiveValues(n = get_graph()$n, e = get_graph()$e)
      output$visnetwork <- renderVisNetwork ({show_graph(pipeline$n, pipeline$e)}) # Граф с Pipeline
      
      observe({
        visNetworkProxy("visnetwork") %>%
          visLayout (randomSeed = 123, improvedLayout = T) %>%
          visEdges  (smooth = input$type_edge) %>%
          visHierarchicalLayout (enabled          = input$enabledHier,
                                 levelSeparation  = input$levelSeparation,
                                 nodeSpacing      = input$nodeSpacing,
                                 sortMethod       = input$sortMethod,
                                 blockShifting    = input$blockShifting,
                                 edgeMinimization = input$edgeMinimization,
                                 direction        = input$direction) %>%
          visPhysics(enabled = input$physics, solver = input$solver)
      }) # Получение конфигурационных атрибутов для графа. Временно - далее атрибуты надо зафиксировать

# 21. Работа по сбору координат узлов                   ####
      vals <- reactiveValues(coords=NULL)
      observe({
        invalidateLater(1000)
        visNetworkProxy("visnetwork") %>% visGetPositions()
        vals$coords <- if (!is.null(input$visnetwork_positions)) 
          do.call(rbind, input$visnetwork_positions)
      }) # Сбор координат с узлов
      
      observeEvent(input$SavePos,{ 
        
        t <- vals$coords %>% as_tibble() %>% 
          rownames_to_column(var = "id") %>% 
          unnest() %>% 
          as.data.table() %>% 
          merge(pipeline$n %>% 
                  .[, c("id", "label", "group", "title", "group2")],
                by = "id", all.x = TRUE)
        #     node      x     y
        #    <chr>    <int> <int>
        # 1    1      4861  4862
        openxlsx::write.xlsx (t,        "1.Data/2.shiny/coords.xlsx")
        openxlsx::write.xlsx (t, paste0("1.Data/2.shiny/coords.", Sys.Date(),".xlsx")) # Резервная копия
        showModal(modalDialog(
          "Saved",
          size = 's',
          easyClose = TRUE
        ))
      }) #Сохранение координат в файл
    
    
# 22. Рыночные данные                                   ####
      # Первый график
      output$proc_graph1 <- renderPlotly({
        if(input$from_where == "File"){
          if(!is.null(input$nd_file)){
            quotesForecast <- quotesForecast(read.xlsx(paste0(path,"/",input$nd_file)) %>% as.data.table())
            modelCreation <- modelCreation(quotesForecast)$model_data
            
            VA_data <- qread("modelVA")
            
            new_data <- cbind(VA_data, modelCreation$model) %>% setnames("V2","Algorithm 1")
            
            modelCreation <- modelCreation %>% 
              as.data.table() %>% 
              .[,-c("model")] %>% 
              cbind(new_data %>% .[,-c("fact","x")])
            
            
            write.xlsx(modelCreation, "1.Data/tempdata.xlsx")
            write.csv(tibble(file = input$nd_file, 
                             x_gr = input$X_1, 
                             y_gr = input$Y_1, 
                             str_year = input$market_year[1], 
                             end_year = input$market_year[2],
                             x_gr2 = input$X_2, 
                             y_gr2 = input$Y_2, 
                             str_year2 = input$market_year[1], 
                             end_year2 = input$market_year[2],
                             model_year = input$market_year[1], 
                             model_end_year = input$market_year[2]),"1.Data/Rmddata.csv")
            p <- marketDataGraph(data = "1.Data/tempdata.xlsx", targets = FALSE, str_year = input$market_year[1], end_year = input$market_year[2], vec_indic = c(input$proc_list1,input$alko))
            
            # p <- modelGraph(data = paste0(path,"/",input$nd_file), targets = FALSE)
            p %>%
              layout(
                images = list(
                  source = base64enc::dataURI(file = '8.Pic/15.png'),
                  x = 0.82, y = 1.05 ,
                  sizex = 0.18, sizey = 0.1,
                  xref = "paper", yref = "paper",
                  xanchor = "left", yanchor = "bottom"
                ),
                margin = list(t = 50)
              )
          }
        } else if(input$from_where == "Downloaded"){
          write.csv(tibble(file = "quotes_agregation_level1.xlsx", 
                           x_gr = input$X_1, 
                           y_gr = input$Y_1, 
                           str_year = input$market_year[1], 
                           end_year = input$market_year[2],
                           x_gr2 = input$X_2, 
                           y_gr2 = input$Y_2, 
                           str_year2 = input$market_year[1], 
                           end_year2 = input$market_year[2],
                           model_year = input$market_year[1], 
                           model_end_year = input$market_year[2]),"1.Data/Rmddata.csv")
          vec_indic2 <- input$proc_list1
          vec_indic2[which(vec_indic2 == "Algorithm 1")] <- "model"
          p <- marketDataGraph(str_year = input$market_year[1], end_year = input$market_year[2], vec_indic = vec_indic2)
          
          # p <- modelGraph(data = paste0(path,"/",input$nd_file), targets = FALSE)
          p %>%
            layout(
              images = list(
                source = base64enc::dataURI(file = '8.Pic/15.png'),
                x = 0.82, y = 1.05 ,
                sizex = 0.18, sizey = 0.1,
                xref = "paper", yref = "paper",
                xanchor = "left", yanchor = "bottom"
              ),
              margin = list(t = 50)
            )
        }
      })
      
      
# 23. График рыночных данных                            ####
      output$proc_graph2 <- renderPlotly({
        if(input$from_where == "File"){
          if(!is.null(input$nd_file)){
            quotesForecast <- quotesForecast(read.xlsx(paste0(path,"/",input$nd_file)) %>% as.data.table())
            modelCreation <- modelCreation(quotesForecast)$model_data 
            write.xlsx(modelCreation, "1.Data/tempdata2.xlsx")
            write.csv(tibble(file = input$nd_file, 
                             x_gr = input$X_1, 
                             y_gr = input$Y_1, 
                             str_year = input$market_year[1], 
                             end_year = input$market_year[2],
                             x_gr2 = input$X_2, 
                             y_gr2 = input$Y_2, 
                             str_year2 = input$market_year[1], 
                             end_year2 = input$market_year[2],
                             model_year = input$market_year[1], 
                             model_end_year = input$market_year[2]),"1.Data/Rmddata.csv")
            p <- marketDataGraph(data = "1.Data/tempdata2.xlsx", targets = FALSE, str_year = input$market_year[1], end_year = input$market_year[2], vec_indic = input$proc_list2)
            
            # p <- modelGraph(data = paste0(path,"/",input$nd_file), targets = FALSE)
            p %>%
              layout(
                images = list(
                  source = base64enc::dataURI(file = '8.Pic/15.png'),
                  x = 0.82, y = 1.05 ,
                  sizex = 0.18, sizey = 0.1,
                  xref = "paper", yref = "paper",
                  xanchor = "left", yanchor = "bottom"
                ),
                margin = list(t = 50)
              )
          }
        } else if(input$from_where == "Downloaded"){
          write.csv(tibble(file = "quotes_agregation_level1.xlsx", 
                           x_gr = input$X_1, 
                           y_gr = input$Y_1, 
                           str_year = input$market_year[1], 
                           end_year = input$market_year[2],
                           x_gr2 = input$X_2, 
                           y_gr2 = input$Y_2, 
                           str_year2 = input$market_year[1], 
                           end_year2 = input$market_year[2],
                           model_year = input$market_year[1], 
                           model_end_year = input$market_year[2]),"1.Data/Rmddata.csv")
          p <- marketDataGraph(str_year = input$market_year[1], end_year = input$market_year[2], vec_indic = input$proc_list2)
          
          # p <- modelGraph(data = paste0(path,"/",input$nd_file), targets = FALSE)
          p %>%
            layout(
              images = list(
                source = base64enc::dataURI(file = '8.Pic/15.png'),
                x = 0.82, y = 1.05 ,
                sizex = 0.18, sizey = 0.1,
                xref = "paper", yref = "paper",
                xanchor = "left", yanchor = "bottom"
              ),
              margin = list(t = 50)
            )
        }
      })
      
# 24. Функциональная архитектура                        ####
      output$func_architect <- renderImage({
        list(src = '8.Pic/func.architect.png',
             # contentType = 'image/png',
             width  = session$clientData$output_func_architect_width,
             height = session$clientData$output_func_architect_height,
             alt = "This is alternate text"
)
        
      }, deleteFile = FALSE)
      
}
