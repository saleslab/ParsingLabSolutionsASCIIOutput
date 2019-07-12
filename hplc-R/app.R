suppressWarnings({
  suppressPackageStartupMessages({
    library(shiny)
    library(tidyverse)
  })
})

source("parse-hplc.R")


ui <- fluidPage(
  fluidRow(
    div(
      h2("HPLC Data Parser"),
      fileInput(
        inputId = "file_upload",
        label = "Select File:"
      ),
      textInput(
        inputId = "out_name",
        label = "Download File Name:",
        value = "hplc_data.csv"
      ),
      downloadButton(
        outputId = "download",
        label = "Parse File"
      ),
      style = "margin-left:10px;margin-top:10px;"
    )
  )
)


server <- function(input, output, session){
  session$onSessionEnded(stopApp)
  
  filename <- reactive({
    file <- input$out_name
    
    if (!str_detect(file, "\\.csv$")){
      file <- paste0(file, ".csv")
    } 
    
    return(file)
  })
  
  output$download <- downloadHandler(
    filename = function(){filename()},
    content = function(x){
      parse_hplc(input$file_upload$datapath, x)
    }
  )
}


shinyApp(ui, server)
