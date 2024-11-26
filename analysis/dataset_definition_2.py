from ehrql import create_dataset
from ehrql.tables.tpp import patients, practice_registrations, vaccinations, ons_deaths

dataset = create_dataset()

index_date = "2020-12-08"

has_registration = practice_registrations.for_patient_on(
    index_date
).exists_for_patient()

alive = (
  ons_deaths.date.is_on_or_after(index_date) | 
  ons_deaths.date.is_null()
)

dataset.define_population(
  has_registration & 
  alive
)
dataset.configure_dummy_data(population_size=1000)

dataset.registered = has_registration
dataset.age = patients.age_on(index_date)
dataset.sex = patients.sex

covid_vaccinations = (
  vaccinations
  .where(vaccinations.target_disease.is_in(["SARS-2 CORONAVIRUS"]))
  .sort_by(vaccinations.date)
)

covid_vaccinations1 = covid_vaccinations.first_for_patient()
dataset.vaccine_date1 = covid_vaccinations1.date
dataset.vaccine_product1 = covid_vaccinations1.product_name

covid_vaccinations2 = (
    covid_vaccinations.
    where(covid_vaccinations.date>dataset.vaccine_date1).
    first_for_patient()
  )
dataset.vaccine_date2 = covid_vaccinations2.date
dataset.vaccine_product2 = covid_vaccinations2.product_name

dataset.death_date = ons_deaths.date

