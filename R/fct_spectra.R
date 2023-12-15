#' Guess raw spectra number in a (recursive) path
#'
#' @description Count the number of `fid` files within `1SLin` directory, which
#' indicates MALDI Biotyper raw spectra
#'
#' @param directory A vectorized path to the raw spectra
#'
#' @return A named vector with the number of spectra detected (recursively) in the folder
#' spectra
#'
#' @noRd
estimate_number_spectra <- function(directory){
  n_spectra <- vapply(
    directory,
    function(folder){
      fs::dir_ls(path = folder,
                 type = "file",
                 glob = "*1SLin*fid$",
                 recurse = TRUE) %>% base::length()
    },  FUN.VALUE = integer(1L))

  if(any( n_spectra  == 0)){
    warning("Directory with no spectra")
  }
  return(n_spectra)
}

#' Gather spectra stats
#'
#' @param check_vectors A list of 3 logical vectors from [maldipickr::check_spectra]
#' @param plate_name A character indicating the name of the MALDI plate from which the spectra came
#'
#' @return A tibble of *n* rows, with *n* the number of spectra, and 6 columns:
#' * `n_spectra`: Total number of spectra imported
#' * `n_valid_spectra`: Total number of spectra passing all checks
#' * `is_empty`: Number of empty spectra
#' * `is_outlier_length`: Number of spectra with an odd length
#' * `is_not_regular`: Number of non-profile spectra
#' * `maldi_plate`: Name of the MALDI target
#' @noRd
#'
gather_spectra_stats <- function(check_vectors, plate_name){
  aggregated_checks <- Reduce(`|`, check_vectors)
  check_stats <- vapply(check_vectors, sum, FUN.VALUE = integer(1)) %>%
    tibble::as_tibble_row()
  tibble::tibble(
    "n_spectra" = base::length(aggregated_checks),
    "n_valid_spectra" = n_spectra - sum(aggregated_checks)
  ) %>%
    dplyr::bind_cols(check_stats) %>%
    dplyr::mutate(maldi_plate = plate_name) %>%
    return()
}
