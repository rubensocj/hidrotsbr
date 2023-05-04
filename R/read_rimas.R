#' Function to process RIMAS data
#'
#' @description
#' Clean and transform data of the Groundwater Monitoring Network (RIMAS) from
#' Geological Survey of Brazil (CPRM).
#' Data from groundwater monitoring wells can be found at
#' \link{http://rimasweb.cprm.gov.br/layout/}.
#'
#' @param file String. A path to the file downloaded from the RIMAS website.
#'
#' @return
#' \code{read_rimas} returns an \code{data.frame}
#'
#' @author Rubens da Cunha Junior
#'
#' @seealso \code{\link{read_funceme}}
#'
#' @export
read_rimas <- function(file) {
  # require packages
  require("dplyr")

  # import text file
  x <- base::readLines(file, encoding = "latin1")
  x <- x[-which(x==";;;;;;")]
  x <- x[-which(x=="")]

  # header (n) and data (x)
  n <- "N"
  for (i in 1:length(x)) {
    if (base::substr(x[i],1,1)==n) {
      kn <- i
      break
    }
  }
  n <- x[kn]
  x <- x[(kn+1):length(x)]

  # separe by ";"
  sx <- base::strsplit(x, split = ";")
  nx <- base::unlist(strsplit(n, split = ";"))

  # create data frame
  xm <- data.frame(matrix(unlist(sx), nrow = length(sx), byrow = T))
  names(xm) <- nx
  len <- nrow(xm)

  # date column correct
  xm <- xm %>% dplyr::mutate(Data = as.Date(xm[,2], "%d/%m/%Y"))

  # level column correct
  xm <- xm %>% dplyr::mutate(Nivel = as.numeric(gsub(",",".",xm[,4])))
  xm <- xm %>% dplyr::group_by(Data) %>% dplyr::mutate(Nivel = mean(Nivel))

  # date regularization in a new data frame
  dti <- xm$Data[1]
  dtf <- xm$Data[len]
  df <- data.frame(Data = seq(as.Date(dti), as.Date(dtf), by = 1))
  df <- suppressMessages(df %>% dplyr::left_join(xm))
  df <- df %>% dplyr::select(Data, Nivel)

  # day, month and year columns
  df <- df %>% dplyr::mutate(Ano = as.numeric(substr(Data, 1, 4)), .before = Nivel)
  df <- df %>% dplyr::mutate(Mes = as.numeric(substr(Data, 6, 7)), .before = Nivel)
  df <- df %>% dplyr::mutate(Dia = as.numeric(substr(Data, 9, 10)), .before = Nivel)

  return(df)
}
