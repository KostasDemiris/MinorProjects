import random

# OrgSet = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P"}
OrgSet = {"A", "B", "C", "D", "E", "F", "G"}

ObjSet = set()


class obj:
    def __init__(self, name, connections, log_times):
        self.name = name
        self.connected_to = connections
        self.time_log = log_times

    def __str__(self):
        return f"Name: {self.name}, connections: {self.connected_to}, log times: {self.time_log}"

    def add_connection(self, node):
        self.connected_to.append(node)

    def add_connection_with_time(self, node, time):
        self.connected_to.append(node)
        self.time_log.append(time)

    def remove_connection(self, target_node):
        for node in self.connected_to:
            if node == target_node:
                self.connected_to.remove(target_node)

    def is_connected(self, target_node):
        if target_node in self.connected_to:
            return True
        else:
            return False

    def union(self, node):
        if not self.is_connected(node):
            self.add_connection(node)

    def find(self, node, visited):
        found = False
        visited.append(self)
        if node in self.connected_to:
            return [self.name, node.name]
        for val in self.connected_to:
            if not found and val not in visited:
                found = val.find(node, visited)
                if found:
                    return [self.name] + found
        return False

    def shortest_path(self, node, visited, min_time):
        shortest_time = float('inf')
        visited.append(self)
        for val in self.connected_to:
            if node == val:  # Node is the target node
                shortest_time = min(shortest_time, max(self.time_log[self.connected_to.index(node)], min_time))
            elif val not in visited:
                found = val.shortest_path(node, visited, max(min_time, self.time_log[self.connected_to.index(val)]))
                shortest_time = min(shortest_time, max(min_time, found))
        return shortest_time

    def random_connections(self, other_nodes):
        num_connections = random.randint(0, len(other_nodes))
        for i in range(num_connections):
            potential_connections = random.choice(list(other_nodes))
            if potential_connections is not self:
                self.union(potential_connections)
                if self not in potential_connections.connected_to:
                    potential_connections.union(self)

    def random_connections_timed(self, other_nodes):
        num_connections = random.randint(0, 2)
        for i in range(num_connections):
            potential_connection = random.choice(list(other_nodes))
            if potential_connection is not self and potential_connection not in self.connected_to:
                time_sig = random.randint(1, 1000)
                self.add_connection_with_time(potential_connection, time_sig)
                if self not in potential_connection.connected_to:
                    potential_connection.add_connection_with_time(self, time_sig)

    @staticmethod
    def full_coverage_time(node_set):
        largest_time_signature = 0
        origin_node = random.choice(list(node_set))
        print(f"Origin node is {origin_node.name}")
        for node in node_set:
            if node != origin_node:
                time_taken = origin_node.shortest_path(node, [], 0)
                if time_taken != float('inf'):
                    largest_time_signature = max(largest_time_signature, time_taken)
                else:
                    print(f"No connection between {origin_node.name} and {node.name}.")
                    return False  # There is no connection between them, so there is no full coverage
                print(f"Shortest time from {origin_node.name} to {node.name} is {time_taken}")

        return largest_time_signature


for value in OrgSet:
    curObj = obj(value, [], [])
    ObjSet.add(curObj)

for value in ObjSet:
    value.random_connections_timed(ObjSet)

for value in ObjSet:
    print(f"{value}\n")
    for connection in value.connected_to:
        print(f"    {value.name} is connected to {connection.name}")
    print("\n")

    # for connection in value.connected_to:
    #     print(f"Connection: {connection.name}")

source = random.choice(list(ObjSet))
target = random.choice(list(ObjSet))
while target is source:
    target = random.choice(list(ObjSet))
print(f"From {source.name} to {target.name} is {source.find(target, [])}")
print(f"Shortest network coverage is {obj.full_coverage_time(ObjSet)}")
