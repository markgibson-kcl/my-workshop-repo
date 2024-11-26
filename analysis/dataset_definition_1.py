from ehrql import create_dataset
from ehrql.tables.tpp import patients, practice_registrations

dataset = create_dataset()

index_date = "2020-03-31"

has_registration = practice_registrations.for_patient_on(
    index_date
).exists_for_patient()

dataset.define_population(has_registration)
dataset.configure_dummy_data(population_size=1000)

dataset.registered = has_registration
dataset.age = patients.age_on(index_date)
dataset.sex = patients.sex

