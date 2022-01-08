################################################################################
#
#'
#' Download Malawi administrative boundaries shapefiles from Humanitarian Data
#' Exchange
#'
#' @param .unzip Logical. Should zip file be unzipped and extracted? Default to
#'   TRUE
#'
#' @return If `.unzip`, list of shapefiles within the downloaded zip file else
#'   path to downloaded zip file. (Invisible) Shapefiles zip file downloaded to
#'   specified folder.
#'
#' @examples
#' download_boundaries_shapefiles()
#'
#' @export
#'
#
################################################################################

download_boundaries_shapefiles <- function(.unzip = TRUE) {
  folder <- tempdir()

  path <- rhdx::pull_dataset(
    identifier = "malawi-administrative-level-0-3-boundaries"
  ) %>%
    rhdx::get_resource(index = 2) %>%
    rhdx::download_resource(folder = folder)

  ## Unzip file?
  if (.unzip) {
    shp_files <- utils::unzip(zipfile = path, list = TRUE, exdir = folder)
    utils::unzip(zipfile = path, exdir = folder)
  } else {
    shp_files <- path
  }

  ## Return
  shp_files
}


################################################################################
#
#'
#' Get administrative boundaries layer name
#'
#' @param files List of shapefiles within a downloaded zip file
#' @param adm Integer. Administrative level required. Either `0` for country,
#'   `1` for regions, `2` for districts, or `3` for traditional authority areas.
#'
#' @return Layer name for specified administrative level boundary
#'
#' @examples
#' get_boundaries_name(adm = 0)
#'
#' @export
#'
#
################################################################################

get_boundaries_name <- function(files = download_boundaries_shapefiles(),
                                adm = NULL) {
  ## Get layer name
  x <- files[["Name"]] %>%
    stringr::str_detect(pattern = paste0("adm", adm))

  layer_names <- files[["Name"]][x] %>%
    stringr::str_split(pattern = "\\.", simplify = TRUE)

  layer_name <- layer_names[[1]]

  ## Return
  layer_name
}


################################################################################
#
#'
#' Retrieve Malawi country boundaries
#'
#' @param layer Name of layer for country boundaries
#'
#' @return An sf object for the country borders of Malawi
#'
#' @examples
#' get_country()
#'
#' @export
#'
#
################################################################################

get_country <- function(layer = get_boundaries_name(adm = 0)) {
  ## Read country shapefile
  country <- sf::st_read(dsn = tempdir(), layer = layer)

  ## Return
  country
}


################################################################################
#
#'
#' Retrieve Malawi regions boundaries
#'
#' @param layer Name of layer for regions boundaries
#'
#' @return An sf object for the regions borders of Malawi
#'
#' @examples
#' get_regions()
#'
#' @export
#'
#
################################################################################

get_regions <- function(layer = get_boundaries_name(adm = 1)) {
  ## Read provinces shapefile
  regions <- sf::st_read(dsn = tempdir(), layer = layer)

  ## Return
  regions
}


################################################################################
#
#'
#' Retrieve Malawi districts boundaries
#'
#' @param layer Name of layer for districts boundaries
#'
#' @return An sf object for the districts borders of Malawi
#'
#' @examples
#' get_districts()
#'
#' @export
#'
#
################################################################################

get_districts <- function(layer = get_boundaries_name(adm = 2)) {
  ## Read districts shapefile
  districts <- sf::st_read(dsn = tempdir(), layer = layer)

  ## Return
  districts
}


################################################################################
#
#'
#' Retrieve Malawi traditional authority areas boundaries
#'
#' @param layer Name of layer for traditional authority areas boundaries
#'
#' @return An sf object for the traditional authority areas borders of Malawi
#'
#' @examples
#' get_ta_areas()
#'
#' @export
#'
#
################################################################################

get_ta_areas <- function(layer = get_boundaries_name(adm = 3)) {
  ## Read posts shapefile
  taa <- sf::st_read(dsn = tempdir(), layer = layer)

  ## Return
  taa
}



