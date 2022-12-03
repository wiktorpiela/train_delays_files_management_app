library("shiny")
library("shinyjs")

manage_files <- tabPanel("Manage files",
                         useShinyjs(),
                         radioButtons(
                           "file_ext",
                           "Choose file extension",
                           choices = c(".parquet",".rds"),
                           selected = NULL
                         ),
                         textInput("parent_dir",
                                   label = NULL,
                                   placeholder = "Input directory here...",
                                   width = "600px"),
                         actionButton("import","Import"),
                         actionButton("archive_raw", "Archive raw files"),
                         numericInput("n_list","element listy", value = NULL),
                         tableOutput("tab")
                         )
