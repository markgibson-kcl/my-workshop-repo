from itertools import product

# heart failure codes that downstream analyses will look for
HEART_FAILURE_CODES = ["I50", "I500", "I501", "I509"]

# made-up ICD-10-like codes to use as non-heart failure codes
NON_HEART_FAILURE_CODES = [
    "".join(x) for x in product(["A", "B", "C"], ["0", "1"], ["0", "1", "9"])
]
