#' select_dirs UI Function
#'
#' @description A shiny Module to select input directories holding the MALDI Biotyper data
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_select_dirs_ui <- function(id){
  ns <- NS(id)
  tagList(
    bs4Dash::box(
        title = "Select data directories", id = ns("box_select"),
        collapsible = FALSE, closable = FALSE, width = 12,
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
          checkboxGroupInput(ns('chosen_dirs'),'Selected directories')
        )
    )
  )
}

#' select_dirs Server Functions
#'
#' @noRd
mod_select_dirs_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    volumes <- c(Home = fs::path_home(), Here = fs::path_wd())

    shinyFiles::shinyDirChoose(input, "spectra_dirs",
                               roots = volumes, session = session,
                               allowDirCreate = FALSE)
    getChosenDirs <- reactive({
      c(
        input$chosen_dirs,
        shinyFiles::parseDirPath(volumes, input$spectra_dirs)
      ) %>% base::unique()
    })

    observe({
      updateCheckboxGroupInput(session, 'chosen_dirs',
                               choices = getChosenDirs(),
                               selected = getChosenDirs())
    }) %>%
      bindEvent(input$spectra_dirs)

    # based on:
    # https://engineering-shiny.org/structuring-project.html?q=modules#a.-returning-values-from-the-module
     return(
       reactive({
         input$chosen_dirs
        })
     )
  })
}

## To be copied in the UI
#

## To be copied in the server
#
