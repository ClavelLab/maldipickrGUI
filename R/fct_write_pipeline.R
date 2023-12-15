#' Write the _targets.R script
#'
#' @param raw_spectra List of directories with MALDI Biotyper raw spectra data
#' @return None. Used for side-effects.
#'
#' @noRd
#'
#' @author William Landau
#' @source Adapted from <https://github.com/wlandau/targets-shiny>
write_pipeline <- function(
    raw_spectra
) {
  targets::tar_helper("_targets.R", {
    library(targets)
    library(tarchetypes)

    tar_option_set(
      packages = c("maldipickr"),
      memory = "transient",
      garbage_collection = TRUE,
      iteration = "list"
    )
    tar_source(files = "R/fct_spectra.R")
    # Workflow
    list(
      tarchetypes::tar_files(
        plates,
        !!raw_spectra
      ),
      tar_target(
        spectra_raw,
        import_biotyper_spectra(plates) %>% suppressWarnings(),
        pattern = map(plates)
      ),
      tar_target(
        checks,
        check_spectra(spectra_raw, tolerance = 1),
        pattern = map(spectra_raw)
      ),
      tar_target(
        valid_spectra,
        remove_spectra(spectra_raw, checks),
        pattern = map(spectra_raw, checks)
      ),
      tar_target(
        spectra_stats,
        gather_spectra_stats(checks, plates),
        pattern = map(checks, plates),
        iteration = "vector"
      ),
      tar_target(
        all_stats,
        dplyr::bind_rows(spectra_stats)
      )
    )

  })
}
