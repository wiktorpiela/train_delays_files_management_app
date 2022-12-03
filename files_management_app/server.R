library("shiny")
library("shinyjs")
source("utils/func.R")

server <- function(input, output, session){
  
  observeEvent(input$import,{
    
    updateTextInput(session,
                    "parent_dir",
                    value = "")
    
    updateNumericInput(session,
                       "n_list",
                       value = 1)
    })
  
  observeEvent(input$archive_raw,{
    
    updateTextInput(session,
                    "parent_dir",
                    value = "")
  })
  
  results <- eventReactive(input$import,{
    
    combine_import(input$file_ext, input$parent_dir)
    
  })
  
  raw_data_list <- reactive(results()$data)
  
  files_dir <- reactive(results()$all_files_path)
  
  output$tab <- renderTable(raw_data_list()[[input$n_list]])
  
  
  
  
  
  
  # archive raw files as list of dataframes in one rds file (create new directory)
  
  disable("archive_raw")
  
  observeEvent(input$archive_raw, {
    
    parent_dir_raw_archive <- paste0(input$parent_dir,"\\",Sys.Date(),"_raw_archive")
    
    if(parent_dir_raw_archive==""){
      
      showModal(
        modalDialog(
          title = "Warning!",
          "You have to input directory!",
          easyClose = TRUE
        )
      )
    } else if(file.exists(parent_dir_raw_archive)){
      
      showModal(
        modalDialog(
          title = "Warning!",
          "Directory already exist!",
          easyClose = TRUE
        )
      )
    } else { 
      
      dir.create(parent_dir_raw_archive)
      
      write_rds(raw_data_list(),paste0(parent_dir_raw_archive,"\\",Sys.Date(),"_raw_unique_data_list.rds"))
      
    }
    
  })
  

  
  
  
  
  
  
  

  
    
  
# modify dictionary -------------------------------------------------------
  
  observeEvent(input$import_geo_dict, {
    
    updateSelectInput(session,
                      "filter_name",
                      choices = unique(raw_geo_dict()$Nazwa),
                      selected = NULL)
    
    })
  
  raw_geo_dict <- eventReactive(input$import_geo_dict, read_rds("data/pkp_geo_dict.rds"))
  
  geo_dict <- reactive({
    
    if(is.null(input$filter_name)){
      
      raw_geo_dict() %>% 
        mutate(across(c(lat,lon), as.character))
      
    } else {
      
      filter(raw_geo_dict(), Nazwa%in%input$filter_name) %>% 
        mutate(across(c(lat,lon), as.character))
      
      }
    
    
  
  })
  

  
  output$dict <- renderTable(geo_dict())

}
