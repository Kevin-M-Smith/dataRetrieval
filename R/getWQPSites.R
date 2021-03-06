#' Site Data Import from Water Quality Portal
#'
#' Returns a list of sites from the Water Quality Portal web service. This function gets the data from: \url{http://www.waterqualitydata.us}.
#' Arguments to the function should be based on \url{www.waterqualitydata.us/webservices_documentation.jsp}
#'
#' @param \dots see \url{www.waterqualitydata.us/webservices_documentation.jsp} for a complete list of options
#' @keywords data import WQP web service
#' @return retval dataframe with first column dateTime, and at least one qualifier and value columns
#' (subsequent qualifier/value columns could follow depending on requested parameter codes)
#' @export
#' @examples
#' \dontrun{
#' site1 <- getWQPSites(siteid="USGS-01594440")
#' type <- "Stream"
#' sites <- getWQPSites(statecode="US:55",countycode="US:55:025",siteType=type)
#' }
getWQPSites <- function(...){

  matchReturn <- list(...)
  
  options <- c("bBox","lat","long","within","countrycode","statecode","countycode","siteType","organization",
    "siteid","huc","sampleMedia","characteristicType","characteristicName","pCode","activityId",
    "startDateLo","startDateHi","mimeType","Zip","providers")

  if(!all(names(matchReturn) %in% options)) warning(matchReturn[!(names(matchReturn) %in% options)],"is not a valid query parameter to the Water Quality Portal")

  values <- sapply(matchReturn, function(x) URLencode(as.character(paste(eval(x),collapse="",sep=""))))
  
  urlCall <- paste(paste(names(values),values,sep="="),collapse="&")
  
  
  baseURL <- "http://www.waterqualitydata.us/Station/search?"
  urlCall <- paste(baseURL,
               urlCall,
               "&mimeType=tsv",sep = "")
  
  retval = tryCatch({
    h <- basicHeaderGatherer()
    doc <- getURL(urlCall, headerfunction = h$update)
    
  }, warning = function(w) {
    message(paste("URL caused a warning:", urlCall))
    message(w)
  }, error = function(e) {
    message(paste("URL does not seem to exist:", urlCall))
    message(e)
    return(NA)
  })
  
  if(h$value()["Content-Type"] == "text/tab-separated-values;charset=UTF-8"){
  
    numToBeReturned <- as.numeric(h$value()["Total-Site-Count"])
    
    if (!is.na(numToBeReturned) | numToBeReturned != 0){
   
      retval <- read.delim(textConnection(doc), header = TRUE, quote="\"", 
                           dec=".", sep='\t', 
                           colClasses=c('character'), 
                           fill = TRUE)    
      actualNumReturned <- nrow(retval)
      
      if(actualNumReturned != numToBeReturned) warning(numToBeReturned, " sites were expected, ", actualNumReturned, " were returned")
      
      if("LatitudeMeasure" %in% names(retval)){
        retval$LatitudeMeasure <- as.numeric(retval$LatitudeMeasure)
      }
      
      if("LongitudeMeasure" %in% names(retval)){
        retval$LongitudeMeasure <- as.numeric(retval$LongitudeMeasure)
      }
      
      retval$queryTime <- Sys.time()
      
      return(retval)
      
    } else {
      warning(paste("No data to retrieve from",urlCall))
      return(NA)
    }
  } else {
    message(paste("URL caused an error:", urlCall))
    message("Content-Type=",h$value()["Content-Type"])
    return(NA)
  }

}
