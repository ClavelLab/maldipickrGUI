# Building a Prod-Ready, Robust Shiny Application.
#
# README: each step of the dev files is optional, and you don't have to
# fill every dev scripts before getting started.
# 01_start.R should be filled at start.
# 02_dev.R should be used to keep track of your development during the project.
# 03_deploy.R should be used once you need to deploy your app.
#
#
########################################
#### CURRENT FILE: ON START SCRIPT #####
########################################

# renv was already installed
# so installed
renv::install("attachment")
# then instead of the following command from
# the end of the section
# https://thinkr-open.github.io/golem/articles/c_deploy.html#case-1-you-didnt-use-renv-during-developpment-process
# attachment::create_renv_for_dev(dev_pkg = c(
#   "renv",
#   "devtools",
#   "roxygen2",
#   "usethis",
#   "pkgload",
#   "testthat",
#   "remotes",
#   "covr",
#   "attachment",
#   "pak",
#   "dockerfiler",
#   "golem"
# ))
renv::install(c("devtools",
"roxygen2",
"usethis",
"pkgload",
"testthat",
"remotes",
"covr",
"attachment",
"pak",
"dockerfiler",
"golem",
"fs",
"here",
"desc",
"pkgbuild",
"processx",
"rsconnect"
))


## Fill the DESCRIPTION ----
## Add meta data about your application
##
## /!\ Note: if you want to change the name of your app during development,
## either re-run this function, call golem::set_golem_name(), or don't forget
## to change the name in the app_sys() function in app_config.R /!\
##
golem::fill_desc(
  pkg_name = "maldipickrGUI", # The Name of the package containing the App
  pkg_title = "maldipickrGUI: Graphical User Interface to Reproducible Dereplication of Mass Spectrometry Spectra", # The Title of the package containing the App
  pkg_description = "An interactive interface to run reproducible workflow to dereplicate and cherry-pick mass spectrometry spectra with the 'maldipickr' package.", # The Description of the package containing the App
  author_first_name = "Charlie", # Your First Name
  author_last_name = "Pauvert", # Your Last Name
  author_email = "cpauvert@ukaachen.de", # Your Email
  repo_url = "https://github.com/ClavelLab/maldipickrGUI", # The URL of the GitHub Repo (optional),
  pkg_version = "0.0.0.9000" # The Version of the package containing the App
)


## Set {golem} options ----
golem::set_golem_options()

## Install the required dev dependencies ----
# golem::install_dev_deps()
## not used as dependencies are managed via {renv}


## Create Common Files ----
## See ?usethis for more information
usethis::use_gpl3_license()
usethis::use_readme_rmd(open = FALSE)
devtools::build_readme()
# Note that `contact` is required since usethis version 2.1.5
# If your {usethis} version is older, you can remove that param
usethis::use_code_of_conduct(contact = "Charlie Pauvert")
usethis::use_lifecycle_badge("Experimental")
usethis::use_news_md(open = FALSE)


## Init Testing Infrastructure ----
## Create a template for tests
renv::install("spelling")
golem::use_recommended_tests()

## Add helper functions ----
golem::use_utils_ui(with_test = TRUE)
golem::use_utils_server(with_test = TRUE)

# You're now set! ----

# go to dev/02_dev.R
rstudioapi::navigateToFile("dev/02_dev.R")
