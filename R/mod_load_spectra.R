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
    fluidRow(
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
      actionButton(ns("submitbutton"), "Add folder", class = "btn btn-primary"),
      verbatimTextOutput(ns("directorypath"), placeholder = FALSE),
      verbatimTextOutput(ns("selected"))

      )
    ),
    bs4Dash::box(
      title = "confirm selection", id = ns("box_confirm"),
      collapsible = FALSE, closable = FALSE,
      tags$p(
        checkboxGroupInput(ns('chosenfolders'),'Chosen folders...')
      )
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
    inputfolders <- reactive({
      c(
        input$chosenfolders,
        shinyFiles::parseDirPath(volumes, input$spectra_dirs)
      )
    })

    observe({
      updateCheckboxGroupInput(session, 'chosenfolders',
                               choices = inputfolders(),
                               selected = inputfolders())
    }) %>%
      bindEvent(input$submitbutton)

    output$directorypath <- renderPrint({
      if (is.integer(input$spectra_dirs)) {
        if (input$spectra_dirs > 0) {
          cat("No directory selected")
        }
      } else {
        shinyFiles::parseDirPath(volumes, input$spectra_dirs)
      }
    })

    output$selected <- renderPrint({
      if (input$submitbutton>0) {
        isolate(inputfolders())
      } else {
        return("Server is ready for calculation.")
      }
    })
  })
}

## To be copied in the UI
#

## To be copied in the server
#
