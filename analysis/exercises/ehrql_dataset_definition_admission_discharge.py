from ehrql import create_dataset
from ehrql.tables.core import patients
from ehrql.tables.tpp import apcs

admission = apcs.sort_by(apcs.admission_date).first_for_patient()

dataset = create_dataset()
dataset.admission_date = admission.admission_date
dataset.discharge_date = admission.discharge_date

dataset.define_population(patients.exists_for_patient())

dataset.configure_dummy_data(population_size=20)
