from ehrql import create_dataset, months
from ehrql.tables.core import ons_deaths, patients
from ehrql.tables.tpp import apcs, practice_registrations

from analysis.supporting_data.icd10_codes import (
    HEART_FAILURE_CODES,
    NON_HEART_FAILURE_CODES,
)

# study dates from target dataset definition (analysis/dataset_definition_covid_boosters.py)
study_start_date = "2022-01-01"
study_end_date = "2023-01-01"

# use dates one year before/after study dates so we ensure we filter to the right dates
dummy_data_start_date = "2021-01-01"
dummy_data_end_date = "2024-01-01"

# Find heart failure and non heart failure deaths with the date range
heart_failure_death = ons_deaths.underlying_cause_of_death.is_in(
    HEART_FAILURE_CODES
) & ons_deaths.date.is_on_or_between(dummy_data_start_date, dummy_data_end_date)
# We define some possible non heart failure codes to prevent them all being None
non_heart_failure_death = ons_deaths.underlying_cause_of_death.is_in(
    NON_HEART_FAILURE_CODES
) & ons_deaths.date.is_on_or_between(dummy_data_start_date, dummy_data_end_date)

# ensure we have hospital admissions before date of death
# We don't need to specify the 6 month cutoff
hospital_admission_date = (
    apcs.where(apcs.admission_date.is_on_or_before(ons_deaths.date))
    .sort_by(apcs.admission_date)
    .last_for_patient()
    .admission_date
)

# Get registrations for study start date, which should mostly give us patients registered
# on their death dates
registration = practice_registrations.for_patient_on(study_start_date)

dataset = create_dataset()

# define population as patients with a registrations start date OR a non-heart failure death OR
# a heart failure death. This will give us a wide range of patients, some of whom are still alive.
# The will all have a registration, but not necessarily on their date of death, and with some
# patients with a heart failure death, and some with some other cause of death
dataset.define_population(
    registration.start_date.is_not_null()
    | non_heart_failure_death
    | heart_failure_death
)

# Add the region so that it's included in the generated dummy tables
# vaccinations data will be included because it's required for defining the population
dataset.region = registration.practice_nuts1_region_name
dataset.date_of_death = ons_deaths.date
dataset.cause_of_death = ons_deaths.underlying_cause_of_death
dataset.hospitalisation_date = hospital_admission_date

# Increase the populations size as we're generating dummy data in the tables that will
# be excluded by our target dataset definition
dataset.configure_dummy_data(population_size=5000)
