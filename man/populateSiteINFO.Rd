% Generated by roxygen2 (4.0.2): do not edit by hand
\name{populateSiteINFO}
\alias{populateSiteINFO}
\title{Populate Site Information Columns}
\usage{
populateSiteINFO(INFO, siteNumber, interactive = TRUE)
}
\arguments{
\item{INFO}{dataframe with value and code columns}

\item{siteNumber}{string USGS site number}

\item{interactive}{logical Option for interactive mode.  If true, there is user interaction for error handling and data checks.}
}
\value{
INFO dataframe
}
\description{
Populates INFO data frame with additional user-supplied information. Also removes fields not related to WRTDS study.
}
\examples{
#This example requires an internet connection to run
INFO <- getNWISSiteInfo('01594440')
siteNumber <- "01594440"
siteINFO <- populateSiteINFO(INFO, siteNumber)
}

