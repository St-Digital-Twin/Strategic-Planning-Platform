server <- function(input, output,  session) {
  down_table <- reactiveVal()
  need_cols <- reactiveVal(c("oil","euro","coal","gdp","gas"))
  
  output$ui_output <- renderUI({
    if(input$sbMenu == 'methodology'){
      fluidPage(
        fluidRow(
          bs4Card(width = 12, title = 'Data process flow', collapsible = TRUE, background = 'white', visNetworkOutput("visnetwork", width = 'auto', height = "790px") %>% withSpinner(type = getOption("spinner.type", default = 6),color = "#FFA500"),
                  actionButton('SavePos', 'Save Positions', style = "color: #fff; background-color: #001F3F; border-color: #001F3F")),
          bs4Card(width = 12, title = 'Intermediate result', collapsible = TRUE, background = 'white',uiOutput("id3"))#,DT::dataTableOutput("table_first", width = "100%", height = "auto"))
        )
      )
    }else if(input$sbMenu == 'processing'){
      fluidPage(
        fluidRow(
          bs4Card(width = 7, title = 'Сomparing algorithms', background = "gray-dark", 
                  plotlyOutput('proc_graph1') %>% withSpinner(type = getOption("spinner.type", default = 6),color = "#FDC600")),
          bs4Card(width = 5, title = 'Relative changes',background = "gray-dark", collapsible = TRUE,
                  plotlyOutput('model_graph2') %>% withSpinner(type = getOption("spinner.type", default = 6),color = "#FDC600")),
          bs4Card(width = 5, title = 'Reciprocal behaviour',background = "white", 
                  fluidRow(
                    column(width = 4,selectizeInput('td_axis1', label = 'Select x label', choices = need_cols(), options = list(create = TRUE), need_cols()[1], multiple = FALSE)),
                    column(width = 4,selectizeInput('td_axis2', label = 'Select y label', choices = need_cols(), options = list(create = TRUE), need_cols()[2], multiple = FALSE)),
                    column(width = 4,selectizeInput('td_axis3', label = 'Select z label', choices = need_cols(), options = list(create = TRUE), need_cols()[3], multiple = FALSE)),
                    column(width = 12,plotlyOutput('chart3D') %>% withSpinner(type = getOption("spinner.type", default = 6),color = "#FDC600")))),
          bs4Card(width = 7, title = 'Input comparison',background = "white", 
                  selectizeInput('proc_list2', label = 'Curve data', choices = list_box2_processing, options = list(create = TRUE), selected = c('gas', 'gdp'), multiple = TRUE),
                  plotlyOutput('proc_graph2') %>% withSpinner(type = getOption("spinner.type", default = 6),color = "#FDC600"))
          
        ))
    }else if(input$sbMenu == 'visualization'){
              fluidRow(
              bs4Card(width = 8,title = 'Correlation',background = "gray-dark", collapsible = TRUE,
                    plotlyOutput('cor_pot1') %>% withSpinner(type = getOption("spinner.type", default = 6),color = "#FDC600")),
              bs4Card(width = 4,title = 'Сorrelation distribution',background = "gray-dark", collapsible = TRUE,
                      plotlyOutput('cor_pot4') %>% withSpinner(type = getOption("spinner.type", default = 6),color = "#FDC600")),
              bs4Card(width = 12,title = 'Correlations of all indicators',background = "white", collapsible = TRUE,
                    plotlyOutput('cor_pot3',height = "700px") %>% withSpinner(type = getOption("spinner.type", default = 6),color = "#FDC600")))
    }
  })
  
  
# 5. Проверка загруженных файлов                        ####
vec_of_files2 <- reactiveValues(a = vec_of_files)
    
    
# 6. Логотип                                            ####
    output$logo <- renderImage({
      list(src = '6.Pic/15.png',
           width = 150,
           vspace = 20,
           hspace = 20,
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
        input_data <- as.data.table(read.xlsx("1.Data/2.shiny/coords.xlsx"))
        
        can_see <- copy(input_data) %>% 
          .[is.na(title)]
        
        if(is.null(input$click)){
          id0 <-  4
        }else{
          if(str_count(input$click) > 5){
            id0 <-  4
          }else{
            id0 <- as.numeric(input$click)
          }
        }
        if(id0 %in% as.numeric(can_see$id)){
          data <- copy(input_data) %>% 
            .[id == id0,c("label")] %>% 
            deframe()
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
              downloadButton("down", "Download as Excel file", style = "color: #001F3F; background-color: #FDC600; border-color: #FDC600"),
              rHandsontableOutput('table'))
          }  
        }else{
          content_link <-"https://www.linkedin.com/company/dtwin/"
          url <- a("contact us", href = content_link)
          tagList("To download data in the form of data sets, please", url)
        }
        # }else{
        #   if(data == "model_graph"){
        #     tagList(
        #       box(width = 6,title = 'Model graph first',background = "navy", collapsible = TRUE,
        #           plotlyOutput('model_graph1') %>% withSpinner(type = getOption("spinner.type", default = 6),color = "#FDC600")),
        #       box(width = 6,title = 'Model graph second',background = "navy", collapsible = TRUE,
        #           plotlyOutput('model_graph2') %>% withSpinner(type = getOption("spinner.type", default = 6),color = "#FDC600")))
        #   }else{
        #     if(data == "correlation_graph"){
        #         tagList(
        #           box(width = 6,title = 'Correlation graph first',background = "navy", collapsible = TRUE,
        #               plotlyOutput('cor_pot1') %>% withSpinner(type = getOption("spinner.type", default = 6),color = "#FDC600")),
        #           box(width = 6,title = 'Correlation graph second',background = "navy", collapsible = TRUE,
        #               plotlyOutput('cor_pot2') %>% withSpinner(type = getOption("spinner.type", default = 6),color = "#FDC600")),
        #           box(width = 12,title = a('All quarterly correlation', style = 'color:#001F3F; vspace:1;'),background = "gray", collapsible = TRUE,
        #               plotlyOutput('cor_pot3',height = "700px") %>% withSpinner(type = getOption("spinner.type", default = 6),color = "#001F3F")))
        #     }else{
        #       if(data == "send_report"){
        #         dataTableOutput('table2')
        #         }
        #     } 
        #     
            
          # }
        # }
      })
# 9. Вывод графика всевозможных кореляций               ####  
    output$cor_pot3 <- renderPlotly({
      k <- read.xlsx(paste0(path,"/",input$nd_file))
      ggplotly(ggpairs((k %>% mutate(month = as.character(month %% 4))), ggplot2::aes(colour = month),
                       columns = 3:8,
                       upper = list(continuous = wrap("cor", alpha = 1)),
                       lower = list(continuous = wrap("points", alpha = 1,    size = 0.5)),
                       diag = list(continuous =  wrap("densityDiag", alpha = 0.3,    size = 0.5))))
    })
  output$cor_pot4 <- renderPlotly({
    k <- read.xlsx(paste0(path,"/",input$nd_file))
    test <- cor(k[,3:8]) %>% 
      as.data.frame() %>% 
      rownames_to_column() %>% 
      as.data.table() %>% 
      melt(is.vars = c("rowname")) %>% 
      .[rowname != variable] %>% 
      .[,par := paste0(rowname,"-",variable)] %>% 
      .[,c("par","value")] %>% 
      distinct(value,.keep_all = TRUE)
    
    fig <- test %>% plot_ly(labels = ~par, values = ~value,textinfo='label') %>% 
      add_pie(hole = 0.5) %>% 
      layout(showlegend = F,
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE)) %>% 
      layout(plot_bgcolor = '#343a40') %>%
      layout(paper_bgcolor = '#343a40') %>%
      layout(font = t)
    fig
  })
    
# 10. Отправка динамического отчета на email            ####
    observeEvent(input$send_email, {
      reqipient <- input$email_pol
      knit2html("testrmd.rmd",options = "")

      send.mail(from = "<dtwin496@gmail.com>",
                to = paste0("<",reqipient,">"),
                subject = paste0("Report on file :", input$nd_file),
                # body = "Body of the email",
                body = "Your report is enclosedl",
                html = TRUE,
                inline = TRUE,
                smtp = list(host.name = "smtp.gmail.com",
                            port = 465,
                            user.name = "dtwin496@gmail.com",
                            passwd = "cfdocpmuldwewwhq",
                            ssl = TRUE),
                authenticate = TRUE,
                attach.files = c("testrmd.pdf"),
                file.names = c("testrmd.pdf"), # optional parameter
                encoding = "utf-8")
      # k <- data.frame(time = Sys.time(), Status = "Succsesfull", recipient_mail = reqipient)
      write_delim(k,"1.Data/send_report/reports.csv",delim = ",",append = TRUE)
      showModal(modalDialog(
        tags$a(style = "color: black", "The report was sent by post"),
        size = 's',
        easyClose = TRUE
      ))
    })
    output$down <- downloadHandler(
      filename = function() {
        paste0(input$name_file, ".xlsx")
      },
      content = function(file) {
        write.xlsx(down_table(), file)
      }
    )
    
    
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
        down_table(table0[[1]])
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
                           model_year = input$market_year[1], 
                           model_end_year = input$market_year[2]),"1.Data/Rmddata.csv")
          p <- graphCor(data = "1.Data/tempdata.xlsx", targets = FALSE, x_gr = input$X_1, y_gr = input$Y_1, str_year = input$first_graph_year[1], end_year = input$first_graph_year[2])
          p %>%
            layout(
              images = list(
                source = base64enc::dataURI(file = '6.Pic/15.png'),
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
                         model_year = input$market_year[1], 
                         model_end_year = input$market_year[2]),"1.Data/Rmddata.csv")
        p <- graphCor(x_gr = input$X_1, y_gr = input$Y_1, str_year = input$first_graph_year[1], end_year = input$first_graph_year[2])
        p %>%
          layout(
            images = list(
              source = base64enc::dataURI(file = '6.Pic/15.png'),
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
                           model_year = input$market_year[1], 
                           model_end_year = input$market_year[2]),"1.Data/Rmddata.csv")
          p <- graphCor(data = "1.Data/tempdata.xlsx", targets = FALSE, x_gr = input$X_2, y_gr = input$Y_2, str_year = input$second_graph_year[1], end_year = input$second_graph_year[2])
          p %>%
            layout(
              images = list(
                source = base64enc::dataURI(file = '6.Pic/15.png'),
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
                         model_year = input$market_year[1], 
                         model_end_year = input$market_year[2]),"1.Data/Rmddata.csv")
        p <- graphCor(x_gr = input$X_2, y_gr = input$Y_2, str_year = input$second_graph_year[1], end_year = input$second_graph_year[2])
        p %>%
          layout(
            images = list(
              source = base64enc::dataURI(file = '6.Pic/15.png'),
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
                           model_year = input$market_year[1], 
                           model_end_year = input$market_year[2]),"1.Data/Rmddata.csv")
          p <- modelGraph(data = "1.Data/tempdata.xlsx", targets = FALSE, str_year = input$market_year[1], end_year = input$market_year[2])
          
         # p <- modelGraph(data = paste0(path,"/",input$nd_file), targets = FALSE)
          p$curve %>%
            layout(
              images = list(
                source = base64enc::dataURI(file = '6.Pic/15.png'),
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
                         model_year = input$market_year[1], 
                         model_end_year = input$market_year[2]),"1.Data/Rmddata.csv")
        p <- modelGraph(str_year = input$market_year[1], end_year = input$market_year[2])
        
        # p <- modelGraph(data = paste0(path,"/",input$nd_file), targets = FALSE)
        p$curve %>%
          layout(
            images = list(
              source = base64enc::dataURI(file = '6.Pic/15.png'),
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
                           model_year = input$market_year[1], 
                           model_end_year = input$market_year[2]),"1.Data/Rmddata.csv")
          p <- modelGraph(data = "1.Data/tempdata.xlsx", targets = FALSE, str_year = input$market_year[1], end_year = input$market_year[2])
          p$graph_cols %>%
            layout(
              images = list(
                source = base64enc::dataURI(file = '6.Pic/15.png'),
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
                         model_year = input$market_year[1], 
                         model_end_year = input$market_year[2]),"1.Data/Rmddata.csv")
        p <- modelGraph(str_year = input$market_year[1], end_year = input$market_year[2])
        
        # p <- modelGraph(data = paste0(path,"/",input$nd_file), targets = FALSE)
        p$graph_cols %>%
          layout(
            images = list(
              source = base64enc::dataURI(file = '6.Pic/15.png'),
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
            p <- marketDataGraph(data = "1.Data/tempdata.xlsx", targets = FALSE, str_year = input$market_year[1], end_year = input$market_year[2], vec_indic = c("methanol",input$alko))
            
            # p <- modelGraph(data = paste0(path,"/",input$nd_file), targets = FALSE)
            p %>%
              layout(
                images = list(
                  source = base64enc::dataURI(file = '6.Pic/15.png'),
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
                source = base64enc::dataURI(file = '6.Pic/15.png'),
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
            p <- marketDataGraph2(data = "1.Data/tempdata2.xlsx", targets = FALSE, str_year = input$market_year[1], end_year = input$market_year[2], vec_indic = input$proc_list2)
            
            # p <- modelGraph(data = paste0(path,"/",input$nd_file), targets = FALSE)
            p %>%
              layout(
                images = list(
                  source = base64enc::dataURI(file = '6.Pic/16.png'),
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
          p <- marketDataGraph2(str_year = input$market_year[1], end_year = input$market_year[2], vec_indic = input$proc_list2)
          
          # p <- modelGraph(data = paste0(path,"/",input$nd_file), targets = FALSE)
          p %>%
            layout(
              images = list(
                source = base64enc::dataURI(file = '6.Pic/16.png'),
                x = 0.82, y = 1.05 ,
                sizex = 0.18, sizey = 0.1,
                xref = "paper", yref = "paper",
                xanchor = "left", yanchor = "bottom"
              ),
              margin = list(t = 50)
            )
        }
      })
      output$chart3D<- renderPlotly({
        if(input$from_where == "File"){
          if(!is.null(input$nd_file)){
            quotesForecast <- quotesForecast(read.xlsx(paste0(path,"/",input$nd_file)) %>% as.data.table())
            modelCreation <- modelCreation(quotesForecast)$model_data 
          
            data  <- as.data.table(modelCreation) %>% 
              .[between(year, input$market_year[1],input$market_year[2])]
            
            axx <- list(title = input$td_axis1)
            axy <- list(title = input$td_axis2)
            axz <- list(title = input$td_axis3)
            
            i1 <- input$td_axis1
            i2 <- input$td_axis2
            i3 <- input$td_axis3
            
            p <- plot_ly(x = data[,..i1] %>% deframe(), 
                         y = data[,..i2] %>% deframe(), 
                         z = data[,..i3] %>% deframe(), type = 'mesh3d', 
                         intensity = data[,..i3] %>% deframe()) %>% 
              layout(scene = list(xaxis = axx,yaxis = axy,zaxis = axz))

            p %>%
              layout(
                images = list(
                  source = base64enc::dataURI(file = '6.Pic/16.png'),
                  x = 0.82, y = 1.05 ,
                  sizex = 0.18, sizey = 0.1,
                  xref = "paper", yref = "paper",
                  xanchor = "left", yanchor = "bottom"
                ),
                margin = list(t = 50)
              )
          }
        } else if(input$from_where == "Downloaded"){

          data  <- as.data.table(tar_read(model_data)$model_data) %>% 
            .[between(year, input$market_year[1],input$market_year[2])]
          
          axx <- list(title = input$td_axis1)
          axy <- list(title = input$td_axis2)
          axz <- list(title = input$td_axis3)
          
          i1 <- input$td_axis1
          i2 <- input$td_axis2
          i3 <- input$td_axis3
          
          p <- plot_ly(x = data[,..i1] %>% deframe(), 
                       y = data[,..i2] %>% deframe(), 
                       z = data[,..i3] %>% deframe(), type = 'mesh3d', 
                       intensity = data[,..i3] %>% deframe()) %>% 
            layout(scene = list(xaxis = axx,yaxis = axy,zaxis = axz))
          
          
          # p <- modelGraph(data = paste0(path,"/",input$nd_file), targets = FALSE)
          p %>%
            layout(
              images = list(
                source = base64enc::dataURI(file = '6.Pic/16.png'),
                x = 0.82, y = 1.05 ,
                sizex = 0.18, sizey = 0.1,
                xref = "paper", yref = "paper",
                xanchor = "left", yanchor = "bottom"
              ),
              margin = list(t = 50)
            )
        }
      })
      observeEvent({c(input$from_where,input$nd_file)},{
        if(input$from_where == "File"){
          if(!is.null(input$nd_file)){
            temp <- modelCreation(quotesForecast(read.xlsx(paste0(path,"/",input$nd_file)) %>% as.data.table()))$model_data
            need_cols(names(temp)[which(names(temp) %!in% c("methanol","gdp_less_1","model","err","year","month"))]) 
          }
        } else if(input$from_where == "Downloaded"){
          temp <- tar_read(model_data)$model_data
          need_cols(names(temp)[which(names(temp) %!in% c("methanol","gdp_less_1","model","err","year","month"))]) 
        }
      })
      output$texttitle <- renderText({paste0("Strategic Planning Platform")})
}
