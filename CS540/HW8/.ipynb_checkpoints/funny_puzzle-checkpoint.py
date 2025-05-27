import heapq

def state_check(state):
    """check the format of state, and return corresponding goal state.
       Do NOT edit this function."""
    non_zero_numbers = [n for n in state if n != 0]
    num_tiles = len(non_zero_numbers)
    if num_tiles == 0:
        raise ValueError('At least one number is not zero.')
    elif num_tiles > 9:
        raise ValueError('At most nine numbers in the state.')
    matched_seq = list(range(1, num_tiles + 1))
    if len(state) != 9 or not all(isinstance(n, int) for n in state):
        raise ValueError('State must be a list contain 9 integers.')
    elif not all(0 <= n <= 9 for n in state):
        raise ValueError('The number in state must be within [0,9].')
    elif len(set(non_zero_numbers)) != len(non_zero_numbers):
        raise ValueError('State can not have repeated numbers, except 0.')
    elif sorted(non_zero_numbers) != matched_seq:
        raise ValueError('For puzzles with X tiles, the non-zero numbers must be within [1,X], '
                          'and there will be 9-X grids labeled as 0.')
    goal_state = matched_seq
    for _ in range(9 - num_tiles):
        goal_state.append(0)
    return tuple(goal_state)

def is_solvable(state):
    arr = [x for x in state if x != 0]
    inv_count = 0
    for i in range(len(arr)):
        for j in range(i + 1, len(arr)):
            if arr[i] > arr[j]:
                inv_count += 1
    return (inv_count % 2 == 0)

def get_goal_state(state):
    tiles = [v for v in state if v != 0]
    x = len(tiles)
    return [i for i in range(1, x + 1)] + [0] * (9 - x)

def get_manhattan_distance(from_state, to_state):
    distance = 0
    for tile in range(1, 9):
        if tile in from_state:
            from_idx = from_state.index(tile)
            to_idx = to_state.index(tile)
            fx, fy = divmod(from_idx, 3)
            tx, ty = divmod(to_idx, 3)
            distance += abs(fx - tx) + abs(fy - ty)
    return distance

def naive_heuristic(from_state, to_state):
    return 0

def sum_of_squares_distance(from_state, to_state):
    distance = 0
    for tile in range(1, 9):
        if tile in from_state:
            from_idx = from_state.index(tile)
            to_idx = to_state.index(tile)
            fx, fy = divmod(from_idx, 3)
            tx, ty = divmod(to_idx, 3)
            distance += (fx - tx) ** 2 + (fy - ty) ** 2
    return distance

def get_successors(state):
    successors = []
    empty_positions = [i for i, tile in enumerate(state) if tile == 0]
    for empty_pos in empty_positions:
        er, ec = divmod(empty_pos, 3)
        for dr, dc in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
            nr, nc = er + dr, ec + dc
            if 0 <= nr < 3 and 0 <= nc < 3:
                neighbor_pos = nr * 3 + nc
                if state[neighbor_pos] != 0:
                    new_state = list(state)
                    new_state[empty_pos], new_state[neighbor_pos] = new_state[neighbor_pos], new_state[empty_pos]
                    successors.append(new_state)
    unique = set(tuple(s) for s in successors)
    successors = [list(u) for u in unique]
    successors.sort()
    return successors

def print_succ(state, heuristic=get_manhattan_distance):
    goal = list(state_check(state))
    successors = get_successors(state)
    for succ in successors:
        print(f"{succ} h={heuristic(succ, goal)}")

def solve(state, heuristic=get_manhattan_distance):
    goal = list(state_check(state))
    
    if state.count(0) == 1 and not is_solvable(state):
        print(False)
        return

    print(True)
    visited = {}
    expanded = []
    pq = []
    h0 = heuristic(state, goal)
    heapq.heappush(pq, (h0, state, (0, h0, -1)))
    visited[tuple(state)] = h0

    max_queue_len = 1

    while pq:
        if len(pq) > max_queue_len:
            max_queue_len = len(pq)
        cost, curr_state, (g, h_val, parent) = heapq.heappop(pq)
        idx = len(expanded)
        expanded.append((curr_state, g, h_val, parent))
        if curr_state == goal:
            path = []
            while idx != -1:
                path.append(expanded[idx])
                idx = expanded[idx][3]
            path.reverse()
            for st, gg, hh, _ in path:
                print(f"{st} h={hh} moves: {gg}")
            print(f"Max queue length: {max_queue_len}")
            return

        for succ in get_successors(curr_state):
            succ_g = g + 1
            succ_h = heuristic(succ, goal)
            succ_cost = succ_g + succ_h
            st_tup = tuple(succ)
            if st_tup not in visited or visited[st_tup] > succ_cost:
                visited[st_tup] = succ_cost
                heapq.heappush(pq, (succ_cost, succ, (succ_g, succ_h, idx)))

    print(False)

if __name__ == "__main__":
    print_succ([2,5,1,4,0,6,7,0,3], get_manhattan_distance)
    print()
    
    print(get_manhattan_distance([2,5,1,4,0,6,7,0,3], [1,2,3,4,5,6,7,0,0]))
    print()
    
    solve([2,5,1,4,0,6,7,0,3], heuristic=get_manhattan_distance)
    print()
