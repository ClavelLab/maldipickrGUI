#' project_management UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_project_management_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      bs4Dash::box(
        title = "Select active project", id = ns("box_select"),
        collapsible = FALSE, closable = FALSE, width = 6,
        selectInput(
          inputId = ns("project"),
          label = NULL,
          selected = character(0),
          choices = character(0),
          multiple = FALSE
        ),
        bs4Dash::actionButton(
          inputId = ns("project_delete"),
          label = "Delete selected project",
          status = "secondary"
        )
      ),
      bs4Dash::box(
        title = "New project", id = ns("box_create"),
        collapsible = FALSE, closable = FALSE, width = 6,
        textInput(
          inputId = ns("project_new"),
          label = NULL,
          value = NULL,
          placeholder = "Name of new project"
        ),
        bs4Dash::actionButton(
          inputId = "project_create",
          label = "Create project",
          status = "primary"
        )
      )
    )
  )
}

#' project_management Server Functions
#'
#' @noRd
mod_project_management_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    # Every time the user selects a project in the drop-down menu
    # of the "Control" tab, switch to that project and load the settings.
    observe({
      project_set(input$project)
      project_load()
    }) %>% bindEvent(input$project)
  })
}

## To be copied in the UI
#

## To be copied in the server
#
