# Установка библиотек необходимых для программного проекта

`%!in%` <- Negate(`%in%`)

libs <- c("targets", "tarchetypes", "htmlTable",
           "readxl","dplyr","shiny", "bs4Dash","shinydashboard","shinythemes", "sysfonts",
          "shinydashboardPlus","shinyWidgets", 
          "devtools", "openxlsx", "tidyverse", "tibble", "devtools", "data.table", "visNetwork",
          "plotly", "ggplot2", 'knitr', 'mailR', 'bookdown',"shinycssloaders","rhandsontable","GGally")

# Обновление библиотек из гитхаба при наличии
update_github_pkgs <- function() {

  # check/load necessary packages
  # devtools package
  if (!("package:devtools" %in% search())) {
    tryCatch(require(devtools), error = function(x) {warning(x); cat("Cannot load devtools package \n")})
    on.exit(detach("package:devtools", unload = TRUE))
  }

  pkgs <- installed.packages(fields = "RemoteType")
  github_pkgs <- pkgs[pkgs[, "RemoteType"] %in% "github", "Package"]

  print(github_pkgs)
  lapply(github_pkgs, function(pac) {
    message("Updating ", pac, " from GitHub...")

    repo = packageDescription(pac, fields = "GithubRepo")
    username = packageDescription(pac, fields = "GithubUsername")

    install_github(repo = paste0(username, "/", repo), auth_token = "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")
  })
}
# update_github_pkgs()

# Инсталляция отсутствующих не гитхаб библиотек
new.packages <- libs[!(libs %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

# Включение библиотек
suppressMessages(lapply(libs, require, character.only = TRUE))




