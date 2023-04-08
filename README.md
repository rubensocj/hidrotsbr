# hidrotsbr

Process hydrological time series data of Brazil

## Description

The R package *hidrotsbr* provides tools for reading, cleaning and processing data from hydrological services of Brazil.
Currently, the package contains functions for:

- Groundwater level from piezometers of the Geological Survey of Brazil's (CPRM) Groundwater Monitoring Network (RIMAS)
- Rainfall data from monitoring stations of the Meteorological Foundation of Ceara (FUNCEME)

## Instalation

You can install the package from
[Github](https://github.com/rubensocj/hidrotsbr)

``` r
# install.packages("remotes")
remotes::install_github("rubensocj/hidrotsbr")
```

## Usage

``` r
library(hidrotsbr)

# RIMAS/CPRM Data
funceme <- read_rimas("/path/to/file.csv")

# FUNCEME Data
cprm <- read_funceme("/path/to/file.txt")
```

## Data source

- RIMAS/CPRM groundwater level data: [link](http://rimasweb.cprm.gov.br/layout/)
- FUNCEME rainfall data: [link 1](http://www.funceme.br/?page_id=2694) or [link 2](http://www.funceme.br/produtos/script/chuvas/Download_de_series_historicas/DownloadChuvasPublico.php)
