library(dplyr)

set.seed(314159)

pop_n <- 1000
index_date <- as.Date("2020-12-08")

pfizer_name <- "COVID-19 mRNA Vaccine Comirnaty 30micrograms/0.3ml dose conc for susp for inj MDV (Pfizer)"
az_name <- "COVID-19 Vaccine Vaxzevria 0.5ml inj multidose vials (AstraZeneca)"

dummy_data_nomissing <- tibble(
  patient_id = 1:pop_n,
  registered = rbinom(pop_n, 1, 0.99)==1,
  age = as.integer(rnorm(pop_n, mean= 55, sd=20)),
  sex = sample(c("female", "male", "intersex", "unknown"), size = pop_n, replace=TRUE, prob = c(0.50, 0.49, 0, 0.01)),
  diabetes = rbinom(pop_n, 1, 0.1)==1,
  vaccine_date1 = index_date + runif(pop_n, 0, 150),
  vaccine_product1 = sample(c(pfizer_name, az_name), size = pop_n, replace=TRUE, prob = c(0.50, 0.50)),
  vaccine_date2 = vaccine_date1 + runif(pop_n, 3*7, 16*7),
  vaccine_product2 = if_else(runif(pop_n)<0.95, vaccine_product1, "az"),
  death_date = index_date + runif(pop_n, 0, 1000)
)

dummy_data <- 
  mutate(
    dummy_data_nomissing,
    sex = if_else(runif(pop_n)<0.01, NA_character_, sex),
    vaccine_date1 = if_else(runif(pop_n)<0.2, as.Date(NA), vaccine_date1),
    vaccine_product1 = if_else(is.na(vaccine_date1), NA_character_, vaccine_product1),
    vaccine_date2 = if_else(runif(pop_n)<0.1 | is.na(vaccine_date1), as.Date(NA), vaccine_date2),
    vaccine_product2 = if_else(is.na(vaccine_date2), NA_character_, vaccine_product2),
    death_date = if_else(runif(pop_n)<0.95, as.Date(NA), death_date)
  )

# write to arrow file
arrow::write_feather(dummy_data, sink = here::here("output", "dummy_dataset_2a.arrow"))

