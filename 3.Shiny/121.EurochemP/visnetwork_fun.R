# Функции формирования графика потока данных с узлами 

# Функция обработки координат узлов
get_graph <- function(){
  
  path <- "_targets/meta/meta"

  meta_is <- fread(path, fill = TRUE) %>% 
    .[,warnings := ""] %>% 
    .[,error := ""] 

  write.table(meta_is, path, sep = "|", quote = FALSE, row.names = FALSE, fileEncoding = "UTF-8", na = "")
  
  tarnet    <- tar_network()
  
  tar_nodes <- tarnet$vertices %>%
    rowid_to_column() %>% 
    as.data.table() %>% 
    setnames(c("name","rowid"), c("label", "id")) %>% 
    .[                    , shape := "text"   ] %>% 
    .[type   == "stem"    , shape := "box"    ] %>% 
    .[                    , color := "#e69c18"] %>% 
    .[status == "started" , color := "#8eac6d"] %>% 
    .[status == "uptodate", color := "#67b5cc"] %>% 
    .[status == "error"   , color := "red"    ] %>% 
    .[!type %in% c("function", "object")] %>% 
    # rowid_to_column() %>%
    merge(read.xlsx("1.Data/2.shiny/coords.xlsx") %>% 
            as.data.table() %>% 
            .[, c("label", "x", "y", "group", "title", "group2")], 
          by = "label", all.x = TRUE) %>% 
    # merge(fread("7.shiny/coords.csv") %>% as.data.table(), by = "id", all.x = TRUE) %>%
    .[, id := as.character(id)] 
  
  tar_edges <- tarnet$edges %>% 
    select(from_l = from, to_l = to) %>% 
    left_join(tar_nodes %>% select(from = id, label, type), by = c("from_l" = "label")) %>% 
    left_join(tar_nodes %>% select(to   = id, label)      , by = c("to_l"   = "label")) %>% 
    as.data.table() %>% 
    .[                  , dashes:= FALSE] %>% 
    .[type == "function", dashes:= TRUE] 
  
  write.xlsx(tar_nodes, file = '1.Data/2.shiny/tar_nodes.xlsx')
  write.xlsx(tar_edges, file = '1.Data/2.shiny/tar_edges.xlsx')
  return(list(n = tar_nodes, e = tar_edges))
}

# Функция отображения графика потока данных с узлами 
show_graph <- function(node = NULL, edge = NULL){
  
  if(is.null(node)){
    node <- read_xlsx('1.Data/2.shiny/tar_nodes.xlsx')
  }
  if(is.null(edge)){
    edge <- read_xlsx('1.Data/2.shiny/tar_edges.xlsx')
  }
  
  node1 <- node %>% 
    mutate(title = ifelse(is.na(title), label, title)) %>% 
    mutate(label = str_wrap(title, 40))
      
      
  visNetwork(node1, edge) %>%
    visEdges  (arrows = "middle", smooth = "diagonalCross") %>% 
    visNodes  (shadow = TRUE, font = list(face  = "Panton",  color = "black")) %>% #fixed = TRUE,
    visLayout (randomSeed = 123, improvedLayout = TRUE) %>% 
    visOptions(highlightNearest = list(enabled   = TRUE,
                                       hover     = FALSE, # подсвечивание узлов графа при проведении мышкой
                                       algorithm = "hierarchical", # подсвечивание последователей по направлению графа или опция "all"
                                       degree    = 1, # глубина подсвечивание
                                       hideColor = "rgba(200,200,200,0.5"), # цвет не выбранных узлов
               nodesIdSelection = TRUE,
                selectedBy       = list(variable = "group", hideColor = "rgba(200,200,200,0.5"),
                autoResize       = TRUE,
               collapse   = list(enabled        = TRUE,
                                 fit            = TRUE,
                                 resetHighlight = TRUE,
                                 keepCoord      = TRUE,
                                 labelSuffix    = "Свернутый узел"),
               clickToUse   = TRUE
               ) %>%  # Опция редактирования графа
    visEvents(type = "on", doubleClick = "networkOpenCluster", click = "function(node){
                  Shiny.onInputChange('click', node.nodes[0]);
                  ;}") %>% # При двойном нажатии на узел открывается кластер
    visInteraction(hover                = TRUE,
                   hoverConnectedEdges  = TRUE,
                   multiselect          = TRUE,
                   navigationButtons    = TRUE,
                   tooltipDelay         = 50,
                   selectable           = TRUE,
                   selectConnectedEdges = TRUE) %>%
    visPhysics(enabled = FALSE) %>%
    visLegend(main = list (text = "Legend", style = "font-family: Panton; font-size: 10;"), position = "right", width = 0.05, zoom = F)
}


