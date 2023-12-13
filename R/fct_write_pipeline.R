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
        spectra_lengths,
        base::lengths(spectra_raw)
      )
    )

  })
}
