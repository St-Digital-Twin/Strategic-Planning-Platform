# Элемент визуализации приложения

ui <- tagList(
  # 1. Слой - основа                        ####
  navbarPage( 
  "Strategic Planning Platform",# Основнное название в левом верхнем углу
  theme = shinytheme("cosmo"),# shiny тема можно выбрать https://rstudio.github.io/shinythemes/ отвечает за верхнюю панель и задний фон
  useShinydashboard(),
  tags$style(HTML("
    .tabbable > .nav > li > a                  {background-color: aqua;  color:navy}
    .tabbable > .nav > li > a[data-value='Plot'] {background-color: navy;   color:gray}
    .tabbable > .nav > li > a[data-value='Map'] {background-color: navy;  color:gray}
    .tabbable > .nav > li > a[data-value='Contact Us'] {background-color: navy;  color:gray}
    .tabbable > .nav > li > a[data-value='t3'] {background-color: green; color:white}
    .tabbable > .nav > li[class=active]    > a {background-color: navy; color:white}
    .skin-blue .main-sidebar .sidebar .sidebar-menu .active a{
 background-color: rgb(107,194,0);
color: rgb(255,255,255);font-weight: bold;font-size: 18px;}
  # ")),
  tags$style(HTML('body {font-family: "Panton"}')),# Некоторые настройки для красоты
  
  # 2. Вкладка "About"                      ####
  tabPanel('About',
           fluidRow(box(width = 12, imageOutput("func_architect", height = "800px") %>% withSpinner(type = getOption("spinner.type", default = 6),color = "#001F3F"), height = '1000px'))
           # fluidRow(box(width = 12, title = 'ФУНКЦИОНАЛЬНАЯ АРХИТЕКТУРА', 
           #              box(title = a('1. Мониторинг  рынков', style = 'color:#fff'), background = 'teal', width = 4,
           #                  box(width = 12, title = a('Сбор рыночных данных', style = 'color:#fff'), background = 'light-blue'),
           #                  box(width = 12, title = a('Прогнозирование рынков', style = 'color:#fff'), background = 'light-blue',
           #                      box(width = 12, title = a('Пример задачи follow-up', style = 'color:#001F3F'), background = 'orange')),
           #                  box(width = 12, title = a('Анализ и оценка рынков', style = 'color:#fff'), background = 'light-blue')
           #              ),
           #              box(title = a('2. Оценка и анализ', style = 'color:#fff'), background = 'green', width = 4,
           #                  box(width = 12, title = a('Оценка текущего состояния Х.', style = 'color:#fff'), background = 'olive'),
           #                  box(width = 12, title = a('Прогноз состояния Х.', style = 'color:#fff'), background = 'olive'),
           #                  box(width = 12, title = a('Выявление «узких» мест', style = 'color:#fff'), background = 'olive'),
           #                  box(width = 12, title = a('Оценка влияния инвестпроекта', style = 'color:#fff'), background = 'olive'),
           #                  box(width = 12, title = a('Оптимизация инвестпроекта', style = 'color:#fff'), background = 'olive')
           #              ),
           #              box(title = a('3. Портфельное управление', style = 'color:#fff'), background = 'lime', width = 4,
           #                  box(width = 12, title = a('Формирование инвестиционного портфеля', style = 'color:#fff'), background = 'green'),
           #                  box(width = 12, title = a('Оценка и анализ портфеля', style = 'color:#fff'), background = 'green'),
           #                  box(width = 12, title = a('Оптимизация портфеля', style = 'color:#fff'), background = 'green')
           #              ),
           #              box(title = a('Методическое обеспечение: концепция, методика, регламент', style = 'color:#001F3F'), background = 'gray', width = 12),
           #              box(title = a('Математическое обеспечение: прогноз рыночных факторов, оценка потенциалов, прогноз цены и объемов, модели оценки и оптимизации', style = 'color:#001F3F'), background = 'gray', width = 12),
           #              box(title = a('Информационное обеспечение: подписка на источники данных, набору внутренних данных, хранилище данных, конвеер', style = 'color:#001F3F'), background = 'gray', width = 12),
           #              box(title = a('Программное обеспечение', style = 'color:#001F3F'), background = 'gray', width = 12)
           #              
           # ))
           ),
  # 3. Вкладка "Market Data"                ####
  tabPanel('Market Data', 
           tags$style(HTML(".navbar {background-color:#001F3F;}
                          .navbar-nav li a:hover, .navbar-nav > .active > a {
                          color: #001F3F !important;
                          background-color:#FDC600 !important;}
                         ")),
           fluidRow(
             # 3.1. Боковая панель          ####
             dashboardSidebar( 
               #inputId = "sidebarState",
               imageOutput("logo", height = "70px"),
               sidebarMenu(
                 
                 id = "sidebar",
                 menuItem('1. Initial data loading', visual_layout_loading),
                 menuItem('2. Data processing', visual_layout_processing),
                 menuItem('3. Graphic visualization',visual_layout_graphic),
                 tags$style(HTML(".sidebar {background-color:#001F3F;}
                                .active a {color:white;}
                                .btn-file {
                                color: #001F3F;
                                background-color:#FDC600; 
                                border-color: #001F3F; }")),
                 tags$style(HTML(
                   "<script>
           $( document ).ready(function() {
              $(\".tab-content [type='checkbox']\").on('click', function(){
                var is_checked = this.checked;
                if(typeof is_checked === 'boolean' && is_checked === true){
                  setTimeout(function() {
                    window.scrollTo(0,document.body.scrollHeight);
                  }, 200)
                }
              })
           })
        </script>"
                 ))
                 # tags$style(HTML(".sidebar {background-color:#001F3F;}
                 #                  a:hover {color:red;}
                 #                  a:link {color:purple;}
                 #                  a {color:white;}"))
                 # 1 - боковая панель, 2 - при наведении цвет, 3 - когда нажимал уже цвеь, 4 - в неактивном режиме цвет
                 
                 
               ), # sidebarMenu
               width = 300),
             # 3.2. Основной экран          ####
             dashboardBody( 
               # 3.2.1. Рыночные котировки  ####
               box(width = 12, background = "navy", title = "Market data", collapsible = TRUE,
                   box(background = "navy", visual_layout_graphic1_processing),
                   box(background = "navy", visual_layout_graphic2_processing)),
               
               # 3.2.2. Таргетс             ####
               box(width = 12, title = a('Data process flow', style = 'color:#001F3F; vspace:1;'), collapsible = TRUE, background = 'gray',
                   visNetworkOutput("visnetwork", width = 'auto', height = "450px") %>% withSpinner(type = getOption("spinner.type", default = 6),color = "#001F3F"),
                   actionButton('SavePos', 'Save Positions', style = "color: #fff; background-color: #001F3F; border-color: #001F3F")
                   # actionButton('LoadPos', 'Load Positions', style="color: #fff; background-color: #001F3F; border-color: #001F3F")),
               ),
               
               
               # 3.2.3. Таблички  и графики ####
               box(width = 12,title = a('Content', style = 'color:#001F3F; vspace:1;'),background = "gray", collapsible = TRUE, 
                   uiOutput("id3")
                   )
             ), 

             controlbar = dashboardControlbar()
           )
  ),
  # 4. Вкладка "Projects"                   ####
  tabPanel('Projects'), 
  # 5. Вкладка "Portfolio"                  ####
  tabPanel('Portfolio') 


))
