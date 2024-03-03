class MinitermGenerator:
    def __init__(self, predicates):
        self.predicates = predicates

    def generate_horizontal_miniterms(self):
        miniterms = []
        for predicate in self.predicates:
            miniterm = []
            for attribute, value in predicate.items():
                miniterm.append(f"{attribute} = {value}")
            miniterms.append(" AND ".join(miniterm))
        return miniterms

# Example Usage:
predicates_list = [
    {"name": "'Alem'", "age": 25},
    {"name": "'Lia'", "age": 30},
    {"city": "'A.A'", "salary": 50000}
]

miniterm_generator = MinitermGenerator(predicates_list)
horizontal_miniterms = miniterm_generator.generate_horizontal_miniterms()

for miniterm in horizontal_miniterms:
    print(miniterm)
