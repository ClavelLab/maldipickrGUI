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
    bs4Dash::box(
      title = "Import spectra", id = ns("box_import"),
      collapsible = FALSE, closable = FALSE,
      tags$p(
        "Choose at least one directory which contains spectra from a MALDI-TOF",
        "Biotyper spectra directory (i.e., a ",tags$em("target", .noWS = "after"), ")"
      ),
      tags$p(
        shiny::fileInput(ns("spectra_dirs"),
                         "Choose directory",
                         multiple = TRUE)
      )
    )
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
