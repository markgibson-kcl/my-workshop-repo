"""
The expected version of analysis/dataset_definition.py at the end of the workshop steps.
"""

from ehrql import create_dataset
from ehrql.tables.core import patients, clinical_events

dataset = create_dataset()

age = patients.age_on("2020-03-31")

dataset.define_population((age > 18) & (age < 80))
dataset.age = age
dataset.sex = patients.sex

events = clinical_events.sort_by(clinical_events.date).first_for_patient()
dataset.event_date = events.date
dataset.after_dob = events.date > patients.date_of_birth
dataset.before_dod = (
    events.date < patients.date_of_death
) | patients.date_of_death.is_null()
