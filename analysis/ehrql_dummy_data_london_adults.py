from ehrql import create_dataset
from ehrql.tables.core import patients
from ehrql.tables.tpp import addresses

dataset = create_dataset()
age = patients.age_on("2024-01-01")

possible_msoas = ["E02000001", "E02000002", "E02000003", "E02000004"]
