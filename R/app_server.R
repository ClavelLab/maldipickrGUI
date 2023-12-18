#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  # Clear logs from deleted projects
  project_clear_logs()
  # Load the saved settings of the project. This is important to do
  # before project_select() because of the reactivity loop.
  project_load()
  # Identify the set project in the _project file
  # and populate the dropdown menu.
  project_select()
  chosen_dirs <- mod_select_dirs_server("select_dirs_1")
  mod_load_spectra_server("load_spectra_1", chosen_dirs)
  mod_project_management_server("project_management_1")
}
