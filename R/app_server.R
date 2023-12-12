#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  chosen_dirs <- mod_select_dirs_server("select_dirs_1")
  mod_load_spectra_server("load_spectra_1", chosen_dirs)
}
