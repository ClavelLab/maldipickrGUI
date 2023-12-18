#' load_spectra UI Function
#'
#' @description A shiny Module to import spectra from input directories.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_load_spectra_ui <- function(id){
  ns <- NS(id)
  tagList(
    bs4Dash::actionButton(inputId = ns("import_spectra"),
                          label = "Import spectra",
                          status = "success") %>%
      tags$div(align = "right") %>%
      col_12(),
    tags$br(),
    bs4Dash::box(
      title = "Quality control", id = ns("box_qc"),
      solidHeader = FALSE, status = "info",
      collapsible = TRUE, closable = FALSE, width = 12,
      tags$div(
        tableOutput(ns("stats_spectra")),
        class="d-flex justify-content-center")
    ),
  )
}

#' load_spectra Server Functions
#'
#' @noRd
mod_load_spectra_server <- function(id, selected_dirs){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    output$stats_spectra <- renderTable({
      if(not_null(selected_dirs()) & targets::tar_exist_objects("all_stats")){
        targets::tar_read("all_stats")
      }
    })

    observe({
      write_pipeline(selected_dirs())
      targets::tar_make()
    }) %>% bindEvent(input$import_spectra)
  })
}

## To be copied in the UI
#

## To be copied in the server
#
