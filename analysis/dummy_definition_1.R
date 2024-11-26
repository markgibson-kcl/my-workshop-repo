
population_size <- 1000

set.seed(420)

## attempt 1
# dummy_data <- data.frame(
#   patient_id = 1:population_size,
#   age = rnorm(population_size, mean= 60, sd=20),
#   sex = sample(c("Female", "Male", "Intersex", "Unknown"), size = population_size, replace=TRUE, prob = c(0.50, 0.49, 0, 0.01)),
# )

## attempt 2 - add registered variable
# dummy_data <- data.frame(
#   patient_id = 1:population_size,
#   registered = rbinom(population_size, 1, 0.99)==1,
#   age = rnorm(population_size, mean= 60, sd=20),
#   sex = sample(c("Female", "Male", "Intersex", "Unknown"), size = population_size, replace=TRUE, prob = c(0.50, 0.49, 0, 0.01)),
# )


## attempt 3 - ensure registered is output as "T" or "F" so is  read by python correctly
# dummy_data <- data.frame(
#   patient_id = 1:population_size,
#   registered = ifelse(rbinom(population_size, 1, 0.99), "T", "F"),
#   age = rnorm(population_size, mean= 60, sd=20),
#   sex = sample(c("Female", "Male", "Intersex", "Unknown"), size = population_size, replace=TRUE, prob = c(0.50, 0.49, 0, 0.01)),
# )

# ## attempt 4 - fix age so it's an integer
# dummy_data <- data.frame(
#   patient_id = 1:population_size,
#   registered = ifelse(rbinom(population_size, 1, 0.99), "T", "F"),
#   age = as.integer(rnorm(population_size, mean= 60, sd=20)),
#   sex = sample(c("Female", "Male", "Intersex", "Unknown"), size = population_size, replace=TRUE, prob = c(0.50, 0.49, 0, 0.01)),
# )


## attempt 5 - fix sex so it uses the correct levels
# dummy_data <- data.frame(
#   patient_id = 1:population_size,
#   registered = ifelse(rbinom(population_size, 1, 0.99), "T", "F"),
#   age = as.integer(rnorm(population_size,  mean= 60, sd=20)),
#   sex = sample(c("female", "male", "intersex", "unknown"), size = population_size, replace=TRUE, prob = c(0.50, 0.49, 0, 0.01))
# )

## attempt 6 - add a diabetes variable that is not in the ehrql definition
dummy_data <- data.frame(
  patient_id = 1:population_size,
  registered = ifelse(rbinom(population_size, 1, 0.99), "T", "F"),
  age = as.integer(rnorm(population_size, mean= 55, sd=20)),
  sex = sample(c("female", "male", "intersex", "unknown"), size = population_size, replace=TRUE, prob = c(0.50, 0.49, 0, 0.01)),
  diabetes = rbinom(population_size, 1, 0.1)
)

# write to compressed csv file
readr::write_csv(dummy_data, here::here("output", "dummy_dataset_1.csv.gz"))

# write to arrow file
feather::write_feather(dummy_data, here::here("output", "dummy_dataset_1.arrow"))
