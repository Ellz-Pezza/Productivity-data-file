#### ERF Data####


#### install and load packages ####

my_packages <- c('dplyr', 'readr', 'here', 'DT', 'scales', 'lubridate', 'readxl','writexl','tidyverse','gt','pacman', 'openxlsx', 'glue') # Specify your packages

not_installed <- my_packages[!(my_packages %in% installed.packages()[ , 'Package'])] # Extract not installed packages

if(length(not_installed)) install.packages(not_installed) # Install not installed packages

pacman::p_load(char = my_packages)

#suppressPackageStartupMessages(install_and_load_packages(my_packages))

#### Wrangling ####

data_ERFC <- read_excel(path = 'ERF 2425.xlsm',
                      sheet = 'Commisioner', 
                      col_names = TRUE)

data_ERFP <- read_excel(path = 'ERF 2425.xlsm',
                              sheet = 'Provider', 
                              col_names = TRUE)

data_AG <- read_excel(path = 'A&G.xlsm',
                        sheet = 'ICB-specialist-advice-activity-', 
                        col_names = TRUE)

data_wrangle <- data_AG %>%
  rename(STP_ICS = 'ICB Code') 

# function to bring all of the data together

fn_excel_output_prov <- function(provider_code_to_use, filename_to_use) {
  
data_frames <-list ("Provider" = data_ERFP %>% filter(Provider_or_IS_ICS_Code == provider_code_to_use))
                  
# write the data frames to Excel using the sheet names specified above
write.xlsx(data_frames,
           file = glue(format(Sys.time(), '%Y %m %d'),'_',filename_to_use,'.xlsx'),
           asTable = TRUE
           )
  
}

fn_excel_output_system <- function(system_name_to_use, filename_to_use) {
  
  # create list of the dataframes that you want to export to Excel 
  data_frames <-list ("Commisioner" = data_ERFC %>% filter(STP_ICS == system_name_to_use),
                      "A&G" = data_wrangle %>% filter(STP_ICS == system_name_to_use))
  
  # write the data frames to Excel using the sheet names specified above
  write.xlsx(data_frames,
             file = glue(format(Sys.time(), '%Y %m %d'),'_',filename_to_use,'.xlsx'),
             asTable = TRUE
           )
}

# creating the outputs

# put in the prov code then the prov shortname/code for filename
fn_excel_output_prov('RA7','UHBW')
fn_excel_output_prov('REF','Cornwall')
fn_excel_output_prov('RBD','DCH')
fn_excel_output_prov('RTE','Gloucestershire')
fn_excel_output_prov('RN3','Great Western')
fn_excel_output_prov('RVJ','NBT')
fn_excel_output_prov('RH8','RDUH')
fn_excel_output_prov('RD1','RUHB')
fn_excel_output_prov('RNZ','Salisbury')
fn_excel_output_prov('RH5','Somerset')
fn_excel_output_prov('RA9','T&SD')
fn_excel_output_prov('R0D','UHD')
fn_excel_output_prov('RK9','UHP')
fn_excel_output_prov('RDY','Dorset Healthcare Uni')

# put in the system short name then the system shortname/code for filename
fn_excel_output_system('QOX','BSW ICB')
fn_excel_output_system('QUY','BNSSG ICB')
fn_excel_output_system('QJK','Devon ICB')
fn_excel_output_system('QVV','Dorset ICB')
fn_excel_output_system('QT6','CIOS ICB')
fn_excel_output_system('QR1','Gloucestershire ICB')
fn_excel_output_system('QSL','Somerset ICB')

print(' ***All done, the excel do not automatically open, check your directory ***')