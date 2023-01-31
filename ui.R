# ui <- tagList(
#   tags$head(
#     includeCSS("www/CSS.css")
#   ),
#   # 1. Слой - основа                        ####
#   navbarPage( 
#   "Strategic Planning Platform",# Основнное название в левом верхнем углу
#   theme = shinytheme("cosmo"),# shiny тема можно выбрать https://rstudio.github.io/shinythemes/ отвечает за верхнюю панель и задний фон
#   useShinydashboard(),
#   tags$style(HTML("
#     .tabbable > .nav > li > a                  {background-color: aqua;  color:navy}
#     .tabbable > .nav > li > a[data-value='Plot'] {background-color: navy;   color:gray}
#     .tabbable > .nav > li > a[data-value='Map'] {background-color: navy;  color:gray}
#     .tabbable > .nav > li > a[data-value='Contact Us'] {background-color: navy;  color:gray}
#     .tabbable > .nav > li > a[data-value='t3'] {background-color: green; color:white}
#     .tabbable > .nav > li[class=active]    > a {background-color: navy; color:white}
#     .skin-blue .main-sidebar .sidebar .sidebar-menu .active a{
#  background-color: rgb(107,194,0);
# color: rgb(255,255,255);font-weight: bold;font-size: 18px;}
#   # ")),
#   tags$style(HTML('body {font-family: "Panton"}')),# Некоторые настройки для красоты
# 
#   # 3. Вкладка "Market Data"                ####
#   tabPanel('Market Data', 
#            tags$style(HTML(".navbar {background-color:#001F3F;}
#                           .navbar-nav li a:hover, .navbar-nav > .active > a {
#                           color: #001F3F !important;
#                           background-color:#FDC600 !important;}
#                          ")),
#            fluidRow(
#              # 3.1. Боковая панель          ####
#              dashboardSidebar( 
#                #inputId = "sidebarState",
#                imageOutput("logo", height = "70px"),
#                sidebarMenu(
#                  
#                  id = "sidebar",
#                  menuItem('1. Initial data loading', visual_layout_loading),
#                  menuItem('2. Data processing', visual_layout_processing),
#                  menuItem('3. Graphic visualization',visual_layout_graphic),
#                  tags$style(HTML(".sidebar {background-color:#001F3F;}
#                                 .active a {color:white;}
#                                 .btn-file {
#                                 color: #001F3F;
#                                 background-color:#FDC600; 
#                                 border-color: #001F3F; }")),
#                  tags$style(HTML(
#                    "<script>
#            $( document ).ready(function() {
#               $(\".tab-content [type='checkbox']\").on('click', function(){
#                 var is_checked = this.checked;
#                 if(typeof is_checked === 'boolean' && is_checked === true){
#                   setTimeout(function() {
#                     window.scrollTo(0,document.body.scrollHeight);
#                   }, 200)
#                 }
#               })
#            })
#         </script>"))
#                ), # sidebarMenu
#                width = 300),
#              # 3.2. Основной экран          ####
#              dashboardBody( 
#                # 3.2.1. Рыночные котировки  ####
#                box(width = 12, background = "navy", title = "Market data", collapsible = TRUE,
#                    box(background = "navy", visual_layout_graphic1_processing),
#                    box(background = "navy", visual_layout_graphic2_processing)),
#                
#                # 3.2.2. Таргетс             ####
#                box(width = 12, title = a('Data process flow', style = 'color:#001F3F; vspace:1;'), collapsible = TRUE, background = 'gray',
#                    visNetworkOutput("visnetwork", width = 'auto', height = "450px") %>% withSpinner(type = getOption("spinner.type", default = 6),color = "#001F3F"),
#                    actionButton('SavePos', 'Save Positions', style = "color: #fff; background-color: #001F3F; border-color: #001F3F")
#                    # actionButton('LoadPos', 'Load Positions', style="color: #fff; background-color: #001F3F; border-color: #001F3F")),
#                ),
#                
#                
#                # 3.2.3. Таблички  и графики ####
#                box(width = 12,title = a('Content', style = 'color:#001F3F; vspace:1;'),background = "gray", collapsible = TRUE, 
#                    uiOutput("id3")
#                    )
#              ), 
# 
#              controlbar = dashboardControlbar()
#            )
#   )
# ))

# 1. Функция из menuItem делает вкладку ####
convertMenuItem <- function(mi,tabName) {
  # mi <<- mi
  mi$children[[1]]$attribs['data-toggle']="tab"
  mi$children[[1]]$attribs['data-value'] = tabName
  if(length(mi$attribs$class)>0 && mi$attribs$class=="treeview"){
    mi$attribs$class=NULL
  }
  mi
}

# 2. UI                                 ####
ui <- bs4DashPage(
  dark = NULL,
  # 2.1. Header                         ####
  header = bs4DashNavbar(
    tags$head(
      includeCSS("www/CSS.css")
    ),
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
        </script>")),
    status = 'light',
    textOutput("texttitle")
    #Не удаляйте пж
    # bs4Dash::actionButton("help_button", "Справка по данному разделу", icon = icon("info"),status = "info", flat = TRUE)
  ),#,status = "info"
  # 2.2. Sidebar                        ####
  sidebar = bs4DashSidebar(
    minified = FALSE,
    width = "300px",
    
    imageOutput("logo", height = "70px"),
    bs4SidebarMenu(
      id = "sbMenu",
      tags$style(HTML('.sidebar{font-family: Panton;
                                 color: white}
                        a:hover{ background: #191a1a }
                        }
                      ')), # .active a{ background: #817CB1<i class="fa-regular fa-chart-scatter"></i>
      # 2.2.1. Menu                     ####
      convertMenuItem(bs4SidebarMenuItem("Methodology", icon = icon("project-diagram")), tabName = 'methodology'),
      convertMenuItem(bs4SidebarMenuItem('Data context graphic', visual_layout_processing, icon = icon("chart-line")), tabName = 'processing'),
      convertMenuItem(bs4SidebarMenuItem('Correlation visualization',
                                         selectizeInput("Y_1", label = "Choose Y axis for first graph", choices = list_axis_cor, options = list(create = TRUE), selected = 'euro'),
                                         selectizeInput("X_1", label = "Choose X axis for first graph", choices = list_axis_cor, options = list(create = TRUE), selected = 'oil'),
                                         sliderInput('first_graph_year', 'Year', min = min(data$year), max = max(data$year), value = c(2012, 2020), sep = ''),
                                         icon = icon("chart-column")), tabName = 'visualization'),
      fileInput("user_file", "Send File", accept = ".csv"), 
      selectizeInput("from_where", label = "Choose input", choices = c("File","Downloaded"),options = list(create = TRUE), selected = "File"),
      uiOutput("id2"),
      textInput("email_pol", "Write email for reporting", "info@dtwin.com"),
      actionButton("send_email", "Send Report", style="color: #001F3F; background-color: #FDC600; border-color: #FDC600")
    )
  ),
  # 2.3. Controlbar (left)              ####
  controlbar = bs4DashControlbar(
    #icon = icon("info"),
    tags$ol(
      # type="1",
      # line-height = 1.5,
      style = "font-size:12px;",
      tags$h5 (tags$b(translete[Key == "200_Ui_tags_1" & variable == "En"]$value), style = "margin-top: 15px; margin-bottom: 15px;"),
      tags$li( a(href = "https://www.dtwin.ru"       , target = "_blank", translete[Key == "200_Ui_tags_2" & variable == "En"]$value)),  # tags$li(
      tags$li( a(href = "https://openbook.dtwin.ru"  , target = "_blank", translete[Key == "200_Ui_tags_3" & variable == "En"]$value)),  # tags$li(
      tags$li( a(href = "https://dtwin.city"         , target = "_blank", translete[Key == "200_Ui_tags_4" & variable == "En"]$value)),  # tags$li(
      tags$li( a(href = "https://t.me/DT_Prosha_Bot" , target = "_blank", translete[Key == "200_Ui_tags_5" & variable == "En"]$value)),  # tags$li(
      tags$li( a(href = "https://mobski.dtwin.ru/"   , target = "_blank", translete[Key == "200_Ui_tags_6" & variable == "En"]$value)),  # tags$li(
      tags$li( a(href = "https://teb.dtwin.ru/"      , target = "_blank", translete[Key == "200_Ui_tags_7" & variable == "En"]$value)),  # tags$li(
      tags$li( a(href = "https://realestate.dtwin.ru", target = "_blank", translete[Key == "200_Ui_tags_8" & variable == "En"]$value)),  # tags$li(
      tags$li( a(href = "https://parks.dtwin.ru"     , target = "_blank", translete[Key == "200_Ui_tags_9" & variable == "En"]$value)),  # tags$li(
      tags$li( a(href = "https://asset.dtwin.ru"     , target = "_blank", translete[Key == "200_Ui_tags_10" & variable == "En"]$value)),  # tags$li(
      tags$li( a(href = "https://t.me/sergeygumerov" , target = "_blank", translete[Key == "200_Ui_tags_11" & variable == "En"]$value))  # tags$li(
    )
  ),
  
  # 2.4. Body                           ####
  body = bs4DashBody(
    use_theme(create_theme(
      bs4dash_status(light = "#D0D0D0"),
      bs4dash_status(light = "#1A1814", primary = "#30d5c8"),
      bs4dash_vars(
        navbar_light_color = "gray",
        navbar_light_active_color = "white",
        navbar_light_hover_color = "white"
      ),
      
      bs4dash_sidebar_light(
        bg = "#1A1814",
        color = 'white',
        hover_color  = 'gray',
        submenu_active_bg  = 'orange'
          # header_color = 'black'
      ),
      bs4dash_sidebar_dark(
        bg = "#1A1814",
        color = 'white',
        hover_color  = 'gray',
        submenu_active_bg   = 'orange'
          # header_color = 'black'
      ),
      bs4dash_layout(
        sidebar_width = "340px",
        main_bg = "#15120F"
      ),
      bs4dash_color(
        gray_900 = "#FFF"
      )
    )),
    
    tags$style(HTML('*{font-family: Panton}')),
    uiOutput("ui_output")
  )
)


