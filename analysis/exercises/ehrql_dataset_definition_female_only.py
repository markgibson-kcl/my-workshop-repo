from ehrql import create_dataset
from ehrql.tables.core import patients

dataset = create_dataset()

index_date = "2020-03-31"

age = patients.age_on(index_date)
sex = patients.sex

dataset.define_population((age > 18) & (age < 80) & (sex == "female"))
dataset.age = age
dataset.sex = sex
