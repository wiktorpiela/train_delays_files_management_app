library("shiny")
library("shinyjs")
source("utils/func.R")

server <- function(input, output, session){
 

# import files: raw - .parquet, preprocessed - .rds, prepared - .p --------
  
  observeEvent(input$import,{
    
    updateTextInput(session, "parent_dir", value = "")
    updateNumericInput(session, "n_list", value = 1)
    
    })

  dataset <- eventReactive(input$import,{
    
    combine_import(input$file_ext, input$parent_dir)
    
  })
  
  output$length <- renderText(paste("Dataframes amount:",
                                    format(length(dataset()), big.mark=" "))
  )
  
  output$tab <- renderTable(dataset()[[input$n_list]])
  
# archive raw files as list of dataframes in one rds file -----------------

  disable("archive_raw")
  
  observeEvent(input$archive_raw, {
    
    updateTextInput(session, "parent_dir", value = "")
    
    if(input$parent_dir==""){
      
      show_my_modal("Please input directory!")
      
    } else if(!dir.exists(input$parent_dir)){
      
      show_my_modal("Directory doesn't exist!")
      
    } else { 
      
      write_rds(dataset(),paste0(input$parent_dir,"\\",Sys.Date(),"_raw_unique_data.rds"))
      
    }
    
  })
  

# remove raw parquet files ------------------------------------------------

  observeEvent(input$remove_parquet_raw_data_files, {
    
    show_my_modal("Processing...")
    
    file_paths_to_remove <- list.files(input$parent_dir,
                                       pattern = ".parquet",
                                       recursive = TRUE,
                                       full.names = TRUE)
    
    updateTextInput(session, "parent_dir", value = "")
    
    file.remove(file_paths_to_remove)
    
    removeModal()
    
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
