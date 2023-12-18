# Projects related functions adapted from https://github.com/wlandau/targets-shiny
# especially to prefix functions and add {fs} dependencies to manage paths.

# All the projects live in project_home(). tools::R_user_dir()
# provides unobtrusive persistent user-specific storage for packages
# and apps. If you are the administrator and need to change where
# In transient mode, the app only writes to temporary storage.
project_home <- function() {
  # if (transient_active()) return(fs::path(tempdir(), "maldipickrGUI"))
  home <- Sys.getenv("MALDIPICKRGUI_HOME")
  if (identical(home, "")) {
    out <- tools::R_user_dir("maldipickrGUI", "cache")
  } else {
    out <- fs::path(home, Sys.getenv("USER"), ".maldipickrGUI")
  }
  fs::path_expand(out)
}

# Identify the absolute file path of any file in a project
# given the project's name.
project_path <- function(name, ...) {
  fs::path(project_home(), name, ...)
}

# Identify the path of the file that keeps track of the
# currently selected project.
project_marker <- function() {
  project_path("_project")
}

# Identify the path of the YAML config file.
project_config <- function() {
  project_path("_targets.yaml")
}

# Identify the absolute path of the project's stdout log file.
project_stdout <- function() {
  project_path(project_get(), "stdout.txt")
}

# Identify the absolute path of the project's stderr log file.
project_stderr <- function() {
  project_path(project_get(), "stderr.txt")
}

# Identify all the instantiated projects of the current user.
project_list <- function() {
  out <- list.dirs(project_home(), full.names = FALSE, recursive = FALSE)
  setdiff(out, "_logs")
}

# Identify the first project in the project list.
# This is useful for finding out which project to switch to
# when the current project is deleted.
project_head <- function() {
  utils::head(project_list(), 1)
}

# Identify the project currently loaded.
project_get <- function() {
  path <- project_marker()
  if (fs::file_exists(path)) readLines(path)
}

# Determine if the user is currently in a valid project.
project_exists <- function() {
  name <- project_get()
  any(nzchar(name)) && fs::file_exists(project_path(name))
}

# Internally switch the app to the project with the given name.
project_set <- function(name) {
  writeLines(as.character(name), project_marker())
  project_config_set(name)
  control_set()
}

# Switch to the target script file and data store
# of the project with the given name.
project_config_set <- function(name) {
  targets::tar_config_set(
    config = project_config(),
    script = project_path(name, "_targets.R"),
    store = project_path(name, "_targets")
  )
}

# Update the UI to reflect the identity of the current project.
project_select <- function(name = project_get(), choices = project_list()) {
  session <- getDefaultReactiveDomain()
  # TODO: set the update to use the correct module ns: ns("project")
  # updateSelectInput(session, "project", NULL, name, choices)
}

# Initialize a project but do not switch to it.
# This function has some safety checks on the project name.
project_init <- function(name) {
  name <- trimws(name)
  valid <- length(name) > 0L &&
    nzchar(name) &&
    !(name %in% project_list()) &&
    identical(name, make.names(name))
  if (!valid) {
    msg <- paste(
      "Project name must not conflict with other project names",
      "and must not contain spaces, leading underscores,",
      "or unsafe characters."
    )
    showModal(
      modalDialog(
        msg,
        title = "Invalid project name!",
        footer = modalButton("Edit project name",
                             icon = icon("pencil",lib = "glyphicon")
        ),
        size = "m", easyClose = TRUE, fade = TRUE)
    )
    return(FALSE)
  }
  fs::dir_create(project_path(name))
  TRUE
}

# Create a directory for a new project and switch to it,
# but do not fill the directory.
# project_save() populates and refreshes a project's files.
project_create <- function(name) {
  if (!project_init(name)) return()
  project_set(name)
  project_save(c("albumin", "log_bilirubin"), 1000L)
  project_select(name)
}

# Delete a project but do not necessarily switch to another.
project_delete <- function(name) {
  fs::dir_delete(project_path(name), recursive = TRUE)
  if (!length(project_list())) fs::dir_delete(project_marker())
  project_select(project_head())
}

# Populate or refresh a project's files.
# This happens when a project is created or the user
# changes settings that affect the pipeline.
project_save <- function(raw_spectra) {
  if (!project_exists()) return()
  name <- project_get()
  settings <- list(name = name, raw_spectra = raw_spectra)
  saveRDS(settings, project_path(name, "settings.rds"))
  write_pipeline(name, raw_spectra)
}

# Load a project and handle errors gracefully.
project_load <- function() {
  tryCatch(project_load_try(), error = project_error)
}

# Set the working directory to the current project,
# read the settings file of the current project
# and update the UI to reflect the project's last known settings.
# Try to load the project. Assumes the project is uncorrupted.
# Errors should be handled gracefully.
project_load_try <- function() {
  if (!project_exists()) return()
  project_config_set(project_get())
  session <- getDefaultReactiveDomain()
  settings <- readRDS(project_path(project_get(), "settings.rds"))
  # TODO: set the update to use the correct module ns: ns("project")
  # updatePickerInput(session, "biomarkers", selected = settings$biomarkers)
  # updateSliderInput(session, "iterations", value = settings$iterations)
}

# Handle a corrupted project.
project_error <- function(error) {
  showModal(
    modalDialog(
      conditionMessage(error),
      title = "Project is corrupted",
      size = "m", easyClose = TRUE, fade = TRUE)
  )
}

# With the SGE backend, a project may create logs
# outside the project's file system
# (to avoid accidentally creating corrupted projects).
# This function clears out logs from deleted projects.
# Happens once on startup.
project_clear_logs <- function() {
  logs <- fs::dir_ls(project_path("_logs"))
  projects <- project_list()
  delete <- setdiff(logs, projects)
  fs::file_delete(project_path("_logs", delete))
}
