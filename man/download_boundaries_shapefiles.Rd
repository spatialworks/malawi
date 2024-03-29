% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_boundaries.R
\name{download_boundaries_shapefiles}
\alias{download_boundaries_shapefiles}
\title{Download Malawi administrative boundaries shapefiles from Humanitarian Data
Exchange}
\usage{
download_boundaries_shapefiles(id, .unzip = TRUE)
}
\arguments{
\item{id}{Character vector for unique identifier of administrative
boundaries data for Malawi from Humanitarian Data Exchange}

\item{.unzip}{Logical. Should zip file be unzipped and extracted? Default to
TRUE}
}
\value{
If \code{.unzip}, list of shapefiles within the downloaded zip file else
path to downloaded zip file. (Invisible) Shapefiles zip file downloaded to
specified folder.
}
\description{
Download Malawi administrative boundaries shapefiles from Humanitarian Data
Exchange
}
\examples{
download_boundaries_shapefiles(id = "cod-ab-mwi")

}
