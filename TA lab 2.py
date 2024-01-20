def unique_paths_recursive(rows, columns):
    if rows == 1 or columns == 1:
        return 1
    return unique_paths_recursive(rows - 1, columns) + unique_paths_recursive(rows, columns - 1)


def unique_paths_try_2(rows, columns):
    moves = [[0 for column in range(columns)] for row in range(rows)]
    for row in range(rows):
        moves[row][0] = 1
    for column in range(columns):
        moves[0][column] = 1
    for row in range(1, columns):
        for column in range(1, rows):
            moves[row][column] = moves[row][column - 1] + moves[row - 1][column]  # We're going bottom up
    return moves[rows - 1][columns - 1]


def factorial(n):
    fact = 1
    for i in range(1, n + 1):
        fact *= i
    return fact


def unique_paths_combinations(rows, columns):
    return int(factorial(rows + columns - 2) / (factorial(rows - 1) * factorial(columns - 1)))


def min_cost(costs):
    costs[len(costs) - 2] += costs[len(costs) - 1]
    for index in range(len(costs) - 3, -1, -1):  # Iterate to -1 because the second val is exclusive
        costs[index] += min(costs[index + 1], costs[index + 2])
    print(costs)
    return min(costs[0], costs[1])


def find_bitonicList_peak(biList):  # Takes in a bitonic list and returns the index of the peak
    if len(biList) >= 3:
        if biList[len(biList) // 2] > biList[(len(biList) // 2) - 1]:  # If increasing
            if biList[len(biList) // 2] > biList[(len(biList) // 2) - 1]:
                print(biList)
                return len(biList) // 2
            else:
                return find_bitonicList_peak(biList[(len(biList) // 2) - 1:])
        else:
            return find_bitonicList_peak(biList[:(len(biList) // 2) + 1])
    print(f"This failed, with elements {biList}")
    return False


def bitonic_search(biList, target):
    midPoint = find_bitonicList_peak(biList)

    if midPoint is False:
        print("Was false so didn't work out")
        return False

    print(f"midpoint is {midPoint} with an array size of {len(biList)}")

    while 1 <= midPoint < len(biList) - 1:

        if target == biList[midPoint]:
            return True

        if target < biList[midPoint]:
            midPoint /= 2
            midPoint = int(midPoint)
            print(f"midpoint is {midPoint} with an array size of {len(biList)} and a cur value of {biList[midPoint]}")

        if target > biList[midPoint]:
            midPoint *= 1.5
            midPoint = int(midPoint)
            print(f"midpoint is {midPoint} with an array size of {len(biList)} and a cur value of {biList[midPoint]}")

    if target == biList[0] or target == biList[len(biList) - 1]:
        return True
    return False


print(unique_paths_recursive(4, 4))
print(unique_paths_try_2(4, 4))
print(unique_paths_combinations(4, 4))

costs = [1, 5, 4, 2, 5, 10, 7]
print(min_cost(costs))
print(bitonic_search([2, 4, 6, 8, 10, 12, 11, 9, 7, 5, 3], 9))
