% Generated by roxygen2 (4.0.2): do not edit by hand
\name{getNWISSiteInfo}
\alias{getNWISSiteInfo}
\title{USGS Site File Data Retrieval}
\usage{
getNWISSiteInfo(siteNumber)
}
\arguments{
\item{siteNumber}{string USGS site number.  This is usually an 8 digit number}
}
\value{
retval dataframe with all information found in the expanded site file
}
\description{
Imports data from USGS site file site. This function gets data from here: \url{http://waterservices.usgs.gov/}
}
\examples{
# These examples require an internet connection to run
siteINFO <- getNWISSiteInfo('05114000')
siteINFOMulti <- getNWISSiteInfo(c('05114000','09423350'))
}
\keyword{USGS}
\keyword{data}
\keyword{import}
\keyword{service}
\keyword{web}

