library(dplyr)
library(ggplot2)

# developed using base R
custom_data_a <- arrow::read_feather(here::here("output", "dummy_dataset_2a.arrow"))

# developed using dd4d
custom_data_b <- arrow::read_feather(here::here("output", "dummy_dataset_2b.arrow"))

# developed using dd4d then passed through ehrQL for checks
custom_data_c <- arrow::read_feather(here::here("output", "dummy_dataset_2c.arrow"))

# developed in ehrQL directly
ehrql_data <- arrow::read_feather(here::here("output", "dataset_2.arrow"))


simplify_product_names <- function(data){
  
  pfizer_name <- "COVID-19 mRNA Vaccine Comirnaty 30micrograms/0.3ml dose conc for susp for inj MDV (Pfizer)"
  az_name <- "COVID-19 Vaccine Vaxzevria 0.5ml inj multidose vials (AstraZeneca)"
  
  mutate(
    data, 
    across(starts_with("vaccine_product"), 
      ~{
        case_when(
          .x == pfizer_name ~ "pfizer",
          .x == az_name ~ "az",
          .default = .x
        )
      }
    )
  )
}

product_xtab <- function(data){
  with(
    data,
    table(vaccine_product1, vaccine_product2, useNA='ifany')
  )
}

custom_data_a %>%
  simplify_product_names() %>%
  product_xtab()

custom_data_b %>%
  simplify_product_names() %>%
  product_xtab()

custom_data_c %>%
  simplify_product_names() %>%
  product_xtab()

ehrql_data %>%
  simplify_product_names() %>%
  with(
    table(vax1 = vaccine_product1 %in% c("", NA), vax2 = vaccine_product2 %in% c("", NA))
  )


plot_dates <- function(data){
  
  data %>%
  simplify_product_names() %>%
  ggplot() +
  geom_point(aes(x=vaccine_date1, y = vaccine_date2))+
  scale_x_date(labels = ~ format(.x, "%Y-%b"))+
  scale_y_date(labels = ~ format(.x, "%Y-%b"))+
  theme_bw()
}

plot_dates(custom_data_c)
plot_dates(ehrql_data)



plot_death <- function(data){
  
  data %>%
    simplify_product_names() %>%
    ggplot() +
    geom_histogram(aes(x=death_date))+
    scale_x_date(labels = ~ format(.x, "%Y-%b"))+
    theme_bw()
}

sum(custom_data_c$death_date<as.Date("2021-06-01"), na.rm=TRUE)
sum(ehrql_data$death_date<as.Date("2021-06-01"), na.rm=TRUE)

plot_death(custom_data_c)
plot_death(ehrql_data)
