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
        shinyFiles::shinyDirButton(ns("spectra_dirs"),
                         "Choose directory", "Input directory"),
      verbatimTextOutput(ns("directorypath"), placeholder = T)
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
    volumes <- c(Home = fs::path_home(), Here = fs::path_wd())

    shinyFiles::shinyDirChoose(input, "spectra_dirs",
                               roots = volumes, session = session,
                               allowDirCreate = FALSE)

    output$directorypath <- renderPrint({
      if (is.integer(input$spectra_dirs)) {
        cat("No directory has been selected (shinyDirChoose)")
      } else {
        shinyFiles::parseDirPath(volumes, input$spectra_dirs)
      }
    })
  })
}

## To be copied in the UI
#

## To be copied in the server
#
