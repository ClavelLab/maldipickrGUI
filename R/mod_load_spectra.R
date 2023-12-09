#' load_spectra UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_load_spectra_ui <- function(id){
  ns <- NS(id)
  tagList(
    shiny::fileInput(ns("spectra_dirs"),
                     "Choose one or more MALDI-TOF Biotyper spectra directory",
                     multiple = TRUE)
  )
}

#' load_spectra Server Functions
#'
#' @noRd
mod_load_spectra_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    golem::print_dev("running load spectra")
    observe({
      cat("\ninput$spectra_dirs:\n\n")
      print(input$spectra_dirs)
    })
  })
}

## To be copied in the UI
#

## To be copied in the server
#
