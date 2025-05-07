#### A&G Calculations Data####


#### install and load packages ####

my_packages <- c('dplyr', 'readr', 'here', 'DT', 'scales', 'lubridate', 'readxl','writexl','tidyverse','gt','pacman', 'openxlsx', 'glue') # Specify your packages

not_installed <- my_packages[!(my_packages %in% installed.packages()[ , 'Package'])] # Extract not installed packages

if(length(not_installed)) install.packages(not_installed) # Install not installed packages

pacman::p_load(char = my_packages)

#suppressPackageStartupMessages(install_and_load_packages(my_packages))

#### Load Data required #### 

data_AG <- read_excel(path = 'A&G.xlsm',
                      sheet = 'ICB-specialist-advice-activity-', 
                      col_names = TRUE)

### Rename column headings so you can use them ###

data_wrangle <- data_AG |> rename (ICB_Code = 'ICB Code',
                                   In_Scope = 'In scope of ERF?',
                                   Metric_Diverted = 'Metric Diverted Requests',
                                   Metric_Processed = 'Metric Processed Requests',
                                   Activity_Month = 'Activity Month',
                                   ICB_Name = 'ICB Name')

### filter to what you need ###

data_AGF <- data_wrangle |>filter(Metric_Diverted == 'Yes',
                  Metric_Processed == 'Yes',
                  In_Scope == 'In scope of ERF')

### Take out Irrelevant Columns ##

data_final <- data_AGF |> select (Activity_Month, ICB_Code, ICB_Name, Type, Requests)

### Write Files ###
codes <- c('QOX', 'QUY', 'QT6', 'QJK', 'QVV', 'QR1', 'QSL')

for (i in codes) {

read_file <- case_when(i == 'QR1' ~ "Glos 24_25.xlsx", 
                       i == 'QVV' ~ 'Dorset 24_25.xlsx',
                      i == 'QSL' ~  'Somerset 24_25.xlsx',
                      i == 'QOX' ~ 'BSW 24_25.xlsx',
                      i == 'QUY' ~ 'BNSSG 24_25.xlsx',
                      i == 'QT6' ~'CIOS 24_25.xlsx',
                      i == 'QJK' ~ 'Devon 24_25.xlsx', 
                       .default= "error")

data_loop <- filter (data_final, ICB_Code == i)

wbb <- loadWorkbook(read_file)

removeWorksheet(wbb, "data")

addWorksheet (wbb,"data")

writeData(wbb, "data", data_loop)

rpt_date <- format (Sys.Date(), '%b%y')

filename <- paste0(i,'_AG_', rpt_date, '.xlsx')

saveWorkbook(wbb, file=filename, overwrite =FALSE)

}






