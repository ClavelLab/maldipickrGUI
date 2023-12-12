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
