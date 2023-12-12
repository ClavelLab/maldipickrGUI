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
    tableOutput(ns("lengths_spectra"))
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
          dplyr::rename("n_spectra" = "value")
      }
    })
  })
}

## To be copied in the UI
#

## To be copied in the server
#
