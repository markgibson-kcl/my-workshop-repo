from ehrql import create_dataset
from ehrql.tables.core import patients, clinical_events

dataset = create_dataset()

age = patients.age_on("2020-03-31")
first_event_date = clinical_events.sort_by(clinical_events.date).first_for_patient().date

dataset.define_population((age > 18) & (age < 80))
dataset.age = age
dataset.sex = patients.sex
dataset.first_event_date = first_event_date
