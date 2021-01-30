import re
from random import randint as rand


# Parsing data

with open("books.txt", encoding = "utf-8") as file:
    data = file.readlines()

target_audience = 0
books = []

book_id = 1000
for line in data:
    if line == "\n":
        continue

    line = line[:-1]

    if line[-1] == ':':
        target_audience = target_audience + 1
        continue

    line_data = re.split(" – ", line)
    author = line_data[0]
    titles = re.split("; ", line_data[1])

    for title in titles:
        books.append((book_id, author, title, target_audience))
        book_id = book_id + 1

cities = []
with open("cities.txt", "r", encoding = "utf-8") as file:
    for line in file:
        line = line[:-1]
        if (line != ""):
            cities.append(re.split("\t", line))

libraries = []
with open("libraries.txt", "r", encoding = "utf-8") as file:
    for line in file:
        line = line[:-1]
        if (line != ""):
            libraries.append(re.split("\t", line))


# Creating sql script

with open("create_library_assets.sql", "w", encoding = "utf-8") as file_1, open("model_logiczny_pp418377.sql", "r", encoding = "utf-8") as file_2:
    for line in file_2:
        file_1.write(line)

with open("create_library_assets.sql", "a", encoding = "utf-8") as file:
    table_name = "miasto"
    file.write("\n-- ============================== MIASTO ==============================\n\n")
    for city in cities:
        file.write("insert into {0} values ({1}, '{2}');\n".format(table_name, city[0], city[1]))

    table_name = "biblioteka"
    last_city_id = '10'
    file.write("\n\n-- ============================== BIBLIOTEKA ==============================\n\n")
    for library in libraries:
        if last_city_id != library[2]:
            last_city_id = str(int(last_city_id) + 1)
            file.write("\n")

        file.write("insert into {0} values ({1}, 'Biblioteka {2}', {3});\n".format(table_name, library[0], library[1], library[2]))

    assignments = {}
    table_name = "ksiazka"
    file.write("\n\n-- ============================== KSIAZKA ==============================\n\n")
    last_target = 1
    for book in books:
        if last_target != book[2]:
            last_target = last_target + 1
            file.write("\n")

        library_index = rand(0, len(libraries) - 1)
        if library_index in assignments:
            assignments[library_index] = assignments[library_index] + 1
        else:
            assignments[library_index] = 1

        file.write(
            "insert into {0} values ({1}, '{2}', '{3}', {4}, {5}, {6});\n"
            .format(table_name, book[0], book[1], book[2], rand(2, 5), book[3], libraries[library_index][0])
        )

    minmax = (420, -1)
    for val in assignments.values():
        minmax = (min(minmax[0], val), max(minmax[1], val))
    print(minmax)
