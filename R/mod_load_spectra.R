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
    bs4Dash::box(
      title = "Number of spectra", id = ns("box_select"),
      solidHeader = FALSE, status = "info",
      collapsible = FALSE, closable = FALSE, width = 12,
      tags$div(
        tableOutput(ns("lengths_spectra")),
        class="d-flex justify-content-center")
    )
  )
}

#' load_spectra Server Functions
#'
#' @noRd
mod_load_spectra_server <- function(id, selected_dirs){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    output$lengths_spectra <- renderTable({
      if(not_null(selected_dirs())){
        selected_dirs() %>%
          estimate_number_spectra() %>%
          tibble::as_tibble(rownames = "chosen_dirs") %>%
          dplyr::rename("n_spectra" = "value") %>%
          dplyr::mutate(
            chosen_dirs = fs::path_file(chosen_dirs)
          )
      }
    })
  })
}

## To be copied in the UI
#

## To be copied in the server
#
