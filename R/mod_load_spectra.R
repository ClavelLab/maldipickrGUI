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
          "Biotyper spectra directory (i.e., a ",tags$em("target", .noWS = "after"), ")",
          "using the button below. Selected directories will be listed and only",
          "ticked directories will be included in the analysis."
        ),
        tags$p(
          shinyFiles::shinyDirButton(
            ns("spectra_dirs"),
            "Choose directory", "Input directory")
        ),
        tags$p(
          checkboxGroupInput(ns('chosenfolders'),'Selected directories')
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
      ) %>% base::unique()
    })

    observe({
      updateCheckboxGroupInput(session, 'chosenfolders',
                               choices = inputfolders(),
                               selected = inputfolders())
    }) %>%
      bindEvent(input$spectra_dirs)

     output$selected <- renderPrint({
      if (not_null(input$chosenfolders)) {
        input$chosenfolders
      }
    })
  })
}

## To be copied in the UI
#

## To be copied in the server
#
