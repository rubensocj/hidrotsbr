#' Function to process FUNCEME data
#'
#' @description
#' Clean and transform data of the Meteorological Foundation of Ceara (FUNCEME).
#' Data from monitoring stations can be found at
#' \link{http://www.funceme.br/?page_id=2694}.
#'
#' @param file String. A path to the file downloaded from the FUNCEME website.
#'
#' @return
#' \code{read_funceme} returns an \code{list} with components
#' \item{data.monthly}{data.frame object with the monthly data}
#' \item{data.daily}{data.frame object with daily data}
#' \item{series.monthly}{ts object with monthly data}
#' \item{series.daily}{ts object with daily data}
#' \item{latitude}{numeric object with latitude}
#' \item{longitude}{numeric object with longitude}
#'
#' @author Rubens da Cunha Junior
#'
#' @seealso \code{\link{read_rimas}}
#'
#' @export
read_funceme <- function(file) {
  # require packages
  require("dplyr")
  require("tidyr")

  # load file
  x <- read.csv2(arquivo, encoding = "latin1", sep = ";")
  n <- nrow(x)

  # coordinates
  lat <- as.numeric(unique(x$Latitude))
  lon <- as.numeric(unique(x$Longitude))

  # monthly data
  x.m <- data.frame(cbind(Ano = x$Anos, Mes = x$Meses, Precip = x$Total))

  dti <- as.Date(paste0(x.m$Ano[1], "/", x.m$Mes[1], "/1"))
  dtf <- as.Date(paste0(x.m$Ano[n], "/", x.m$Mes[n], "/1"))
  dt <- seq(dti, dtf, by = "month")

  if(length(dt)!=n) {
    # set NA to months without records
    x.m <- x.m %>% mutate(Data = as.Date(paste0(Ano, "/", Mes, "/1")), .before = Precip)
    x.f <- data.frame(Data = dt)
    x.f <- x.f %>% mutate(Ano = as.numeric(format(Data, "%Y")), Mes = as.numeric(format(Data, "%m")))
    x.f <- left_join(x.f, x.m, by = c("Data"="Data"))
    x.f <- x.f[,-c(1,4,5)]
    names(x.f) <- c("Ano", "Mes", "Precip")
  } else {
    x.f <- x.m
  }

  # monthly time series
  s.m <- ts(as.numeric(x.f$Precip),
            start = c(x.f$Ano[1], x.f$Mes[1]),
            end = c(x.f$Ano[nrow(x.f)], x.f$Mes[nrow(x.f)]),
            frequency = 12)

  # daily data
  # convert to long format
  x.d <- tidyr::gather(x[,-c(1,2,3,4,7)], dia, precip, Dia1:Dia31)

  # format table
  names(x.d) <- c("Ano", "Mes", "Dia", "Precip")
  x.d <- x.d %>% mutate(Dia = as.numeric(substr(Dia, 4, 5)))
  x.d <- x.d %>% mutate(Mes = as.numeric(Mes))
  x.d <- x.d %>% mutate(Ano = as.numeric(Ano))
  x.d <- x.d %>% arrange(Ano,Mes)
  x.d <- x.d %>% mutate(Data = paste0(sprintf("%02d", as.numeric(Dia)),"/",sprintf("%02d", as.numeric(Mes)),"/",Ano), .before = Ano)
  x.d <- x.d %>% mutate(Data = as.Date(Data, "%d/%m/%Y"))
  x.d <- x.d[!(x.d$Precip == "888.0"),]
  x.d$Precip[x.d$Precip == "999.0"] <- NA
  x.d <- x.d %>% mutate(Precip = as.numeric(Precip))
  x.d <- head(x.d, max(which(!is.na(x.d$Precip))))

  # daily time series
  s.d <- ts(as.numeric(x.d$Precip),
            start = c(x.d$Ano[1], x.d$Dia[1]),
            end = c(x.d$Ano[nrow(x.d)], x.d$Dia[nrow(x.d)]),
            frequency = 365)

  return(list(data.monthly = x.f,
              data.daily = x.d,
              series.monthly = s.m,
              series.daily = s.d,
              latitude = lat,
              longitude = lon))
}
