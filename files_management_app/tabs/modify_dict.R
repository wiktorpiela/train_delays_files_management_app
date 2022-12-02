library("shiny")

modify_dictionary <- tabPanel("Modify dictionary",
                              
                              actionButton("import_geo_dict", "Import geo dictionary"),
                              selectInput("filter_name",
                                          label = "Filter by name",
                                          choices = character(0),
                                          multiple = TRUE),
                              tableOutput("dict")
                              
                              )