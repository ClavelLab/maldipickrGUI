#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    bs4Dash::dashboardPage(
      title = golem::get_golem_name(),
      header = bs4Dash::dashboardHeader(
        golem::get_golem_name()
      ),
      sidebar = bs4Dash::dashboardSidebar(
        bs4Dash::sidebarUserPanel(
          image = "www/maldipickrGUI.png",
          name = golem::get_golem_name()
        ),
        bs4Dash::sidebarMenu(
          id = "sidebarmenu",
          bs4Dash::sidebarHeader("Header 1"),
          bs4Dash::menuItem(
            "Item 1",
            tabName = "item1",
            icon = icon("sliders")
          ),
          bs4Dash::menuItem(
            "Item 2",
            tabName = "item2",
            icon = icon("id-card")
          )
        )
      ),
      footer = bs4Dash::dashboardFooter(
        left = desc::desc_get("Title") |> stringr::str_remove("\\n") |> stringr::str_squish(),
        right = paste0("v", golem::get_golem_version())
      ),
      body = bs4Dash::dashboardBody(
        mod_load_spectra_ui("load_spectra_1")
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "maldipickrGUI"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
