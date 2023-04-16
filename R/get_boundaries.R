################################################################################
#
#'
#' Download Malawi administrative boundaries shapefiles from Humanitarian Data
#' Exchange
#'
#' @param id Character vector for unique identifier of administrative
#'   boundaries data for Malawi from Humanitarian Data Exchange
#' @param .unzip Logical. Should zip file be unzipped and extracted? Default to
#'   TRUE
#'
#' @return If `.unzip`, list of shapefiles within the downloaded zip file else
#'   path to downloaded zip file. (Invisible) Shapefiles zip file downloaded to
#'   specified folder.
#'
#' @examples
#' download_boundaries_shapefiles(id = "cod-ab-mwi")
#'
#' @export
#'
#
################################################################################

download_boundaries_shapefiles <- function(id, .unzip = TRUE) {
  folder <- tempdir()

  path <- rhdx::pull_dataset(
    identifier = id
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
#' get_boundaries_name(
#'   download_boundaries_shapefiles(id = "cod-ab-mwi"), adm = 0
#' )
#'
#' @export
#'
#
################################################################################

get_boundaries_name <- function(files, adm = NULL) {
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
#' Retrieve Malawi boundary layer
#'
#' @param id Character vector for unique identifier of administrative
#'   boundaries data for Malawi from Humanitarian Data Exchange
#' @param adm Integer. Administrative level required. Either `0` for country,
#'   `1` for regions, `2` for districts, or `3` for traditional authority areas.
#'
#' @return An sf object for specific boundary of Malawi
#'
#' @examples
#' get_boundary(id = "cod-ab-mwi", adm = 0)
#'
#' @export
#'
#
################################################################################

get_boundary <- function(id, adm = NULL) {
  ## Get files from specific downloaded shapfiles
  files <- download_boundaries_shapefiles(id = id, .unzip = TRUE)

  ## Get specific layer
  layer <- get_boundaries_name(files = files, adm = adm)

  ## Read shapefile for layer
  sf::st_read(dsn = tempdir(), layer = layer)
}


################################################################################
#
#'
#' Retrieve Malawi country boundaries
#'
#' @param id Character vector for unique identifier of administrative
#'   boundaries data for Malawi from Humanitarian Data Exchange
#'
#' @return An sf object for the country borders of Malawi
#'
#' @examples
#' get_country(id = "cod-ab-mwi")
#'
#' @export
#'
#
################################################################################

get_country <- function(id) {
  ## Get country boundaries
  get_boundary(id = id, adm = 0)
}


################################################################################
#
#'
#' Retrieve Malawi regions boundaries
#'
#' @param id Character vector for unique identifier of administrative
#'   boundaries data for Malawi from Humanitarian Data Exchange
#'
#' @return An sf object for the regions borders of Malawi
#'
#' @examples
#' get_regions(id = "cod-ab-mwi")
#'
#' @export
#'
#
################################################################################

get_regions <- function(id) {
  get_boundary(id = id, adm = 1)
}


################################################################################
#
#'
#' Retrieve Malawi districts boundaries
#'
#' @param id Character vector for unique identifier of administrative
#'   boundaries data for Malawi from Humanitarian Data Exchange
#'
#' @return An sf object for the districts borders of Malawi
#'
#' @examples
#' get_districts(id = "cod-ab-mwi")
#'
#' @export
#'
#
################################################################################

get_districts <- function(id) {
  get_boundary(id = id, adm = 2)
}


################################################################################
#
#'
#' Retrieve Malawi traditional authority areas boundaries
#'
#' @param id Character vector for unique identifier of administrative
#'   boundaries data for Malawi from Humanitarian Data Exchange
#'
#' @return An sf object for the traditional authority areas borders of Malawi
#'
#' @examples
#' get_ta_areas(id = "cod-ab-mwi")
#'
#' @export
#'
#
################################################################################

get_ta_areas <- function(id) {
  get_boundary(id = id, adm = 3)
}



