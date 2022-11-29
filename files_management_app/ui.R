library("shiny")
source("tabs/get_files_from_dirs.R")
source("tabs/get_unique_data.R")
source("tabs/glimpse_data.R")

ui <- navbarPage(
  title = "Files management app",
  id="all_tabs",
  gffd,
  get_unique_files,
  glimpse_data
    

  
  

)

