# load libraries
library(ggplot2)
library(dplyr)
library(tidyr)

# install EDAWR from devtool
devtools::install_github("rstudio/EDAWR")
library(EDAWR)

# tbl
data(diamonds)
tbl_df(diamonds)

# tidyr: gather()
data(cases)
tbl_df(cases)
gather(cases, 'year', 'n', 2:4)

# tidyr: spread()
data(pollution)
tbl_df(pollution)
spread(pollution, size, amount)

#tidyr: separate()
data(storms)
tbl_df(storms)
storms2 <- separate(storms, date, c('year','month','day'), sep = '-') 

#tidyr unite()
unite(storms2, 'date', year, month, day, sep = '-')
