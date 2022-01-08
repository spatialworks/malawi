################################################################################
#
#'
#' Download Malawi livelihood zones shapefiles from Humanitarian Data Exchange
#'
#' @param .unzip Logical. Should zip file be unzipped and extracted? Default to
#'   TRUE
#'
#' @return If `.unzip`, list of shapefiles within the downloaded zip file else
#'   path to downloaded zip file. (Invisible) Shapefiles zip file downloaded to
#'   specified folder.
#'
#' @examples
#' download_lhz_shapefiles()
#'
#' @export
#'
#
################################################################################

download_lhz_shapefiles <- function(.unzip = TRUE) {
  base_url <- "https://geonode.wfp.org/geoserver/wfs?"
  format_options <- "format_options=charset:UTF-8"
  typename <- "typename=geonode:mwi_phy_predlhz_geonode_20140612"
  outputFormat <- "outputFormat=SHAPE-ZIP"
  version <- "version=1.0"
  service <- "service=WFS"
  request <- "request=GetFeature"

  .url <- paste0(
    base_url,
    paste(
      format_options,
      typename,
      outputFormat,
      version,
      service,
      request,
      sep = "&"
    )
  )

  zipfile <- tempfile()

  utils::download.file(url = .url, destfile = zipfile, mode = "wb")

  ## Unzip file?
  if (.unzip) {
    shp_files <- utils::unzip(zipfile = zipfile, list = TRUE, exdir = tempdir())
    utils::unzip(zipfile = zipfile, exdir = tempdir())
  } else {
    shp_files <- zipfile
  }

  ## Return
  shp_files
}


################################################################################
#
#'
#' Get livelihoods zones layer name
#'
#' @param files List of shapefiles within a downloaded zip file
#'
#' @return Layer name for livelihood zones shapefile
#'
#' @examples
#' get_lhz_name()
#'
#' @export
#'
#
################################################################################

get_lhz_name <- function(files = download_lhz_shapefiles()) {
  ## Get layer name
  layer_names <- files[["Name"]] %>%
    stringr::str_split(pattern = "\\.", simplify = TRUE)

  layer_name <- layer_names[[1]]

  ## Return
  layer_name
}


################################################################################
#
#'
#' Retrieve Malawi livelihood zones
#'
#' @param layer Name of layer for livelihood zones
#'
#' @return An sf object for the livelihood zones of Malawi
#'
#' @examples
#' get_lhz()
#'
#' @export
#'
#
################################################################################

get_lhz <- function(layer = get_lhz_name()) {
  ## Read lhz shapefile
  lhz <- sf::st_read(dsn = tempdir(), layer = layer)

  ## Return
  lhz
}
