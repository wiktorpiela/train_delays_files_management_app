library("shiny")
source("tabs/manage_files.R")
source("tabs/modify_dict.R")

ui <- navbarPage(
  title = "Files management app",
  id="all_tabs",
  manage_files,
  modify_dictionary
)

