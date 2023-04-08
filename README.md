# hidrotsbr

Process hydrological time series data of Brazil

## Description

The R package *hidrotsbr* provides tools for reading, cleaning and processing data from hydrological services of Brasil.

## Instalation

You can install the **development** version from
[Github](https://github.com/rubensocj/hidrotsbr)

``` r
# install.packages("remotes")
remotes::install_github("rubensocj/hidrotsbr")
```

## Usage

``` r
library(hidrotsbr)
```

- RIMAS/CPRM Data

Download groundwater level data from [RIMAS *Web*](http://rimasweb.cprm.gov.br/layout/).

``` r
data <- read_rimas('/path/to/file.csv)
```

- FUNCEME Data

Download rainfall data from [FUNCEME](http://www.funceme.br/?page_id=2694) or [here](http://www.funceme.br/produtos/script/chuvas/Download_de_series_historicas/DownloadChuvasPublico.php).

``` r
data <- read_funceme('/path/to/file.txt)
```

## License

This package is free and open source software, licensed under GPL-3.
