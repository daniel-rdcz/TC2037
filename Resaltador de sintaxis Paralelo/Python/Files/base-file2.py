# The source list
data = [1, 2, 3, 4, 5, 6]
print("Source:")
print(data)


# Multiply each element in data by 2
# Using a loop and appending to a new list
result = []
for item in data:
    result.append(item * 2)
print("Regular:")
print(result)


# Same, using list comprehensions
result = [item * 2 for item in data]
print("List comprehension:")
print(result)


# Same with map and lambda
result = list(map(lambda item: item * 2, data))
print("Map and lambda:")
print(result)

