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

def get_manhattan_distance(from_state, to_state):
    """
    implement this function. This function will not be tested directly by the grader. 

    INPUT: 
        Two states (The first one is current state, and the second one is goal state)

    RETURNS:
        A scalar that is the sum of Manhattan distances for all tiles.
    """
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
    """
    implement this function. This function will not be tested directly by the grader. 

    INPUT: 
        Two states (The first one is current state, and the second one is goal state)

    RETURNS:
        0 (but experimenting with other constants is encouraged)
    """
    distance = 0
    return distance

def sum_of_squares_distance(from_state, to_state):
    """
    implement this function. This function will not be tested directly by the grader. 

    INPUT: 
        Two states (The first one is current state, and the second one is goal state)

    RETURNS:
        A scalar that is the sum of squared distances for all tiles
    """
    distance = 0
    for tile in range(1, 9):
        if tile in from_state:
            from_idx = from_state.index(tile)
            to_idx = to_state.index(tile)
            fx, fy = divmod(from_idx, 3)
            tx, ty = divmod(to_idx, 3)
            distance += (fx - tx) ** 2 + (fy - ty) ** 2
    return distance

def print_succ(state, heuristic=get_manhattan_distance):
    """
    This is based on get_succ function below, so should implement that function.

    INPUT: 
        A state (list of length 9)

    WHAT IT DOES:
        Prints the list of all the valid successors in the puzzle. 
    """

    # given state, check state format and get goal_state.
    goal_state = state_check(state)
    # please remove debugging prints when you submit your code.
    # print('initial state: ', state)
    # print('goal state: ', goal_state)

    succ_states = get_succ(state)

    for succ_state in succ_states:
        print(succ_state, "h={}".format(heuristic(succ_state,goal_state)))


def get_succ(state):
    """
    implement this function.

    INPUT: 
        A state (list of length 9)

    RETURNS:
        A list of all the valid successors in the puzzle (don't forget to sort the result as done below). 
    """
    succ_states = set()
    for i in range(9):
        if state[i] == 0:
            x, y = divmod(i, 3)
            for dx, dy in [(-1,0),(1,0),(0,-1),(0,1)]:
                nx, ny = x + dx, y + dy
                if 0 <= nx < 3 and 0 <= ny < 3:
                    ni = nx * 3 + ny
                    if state[ni] != 0:
                        new_state = state[:]
                        new_state[i], new_state[ni] = new_state[ni], new_state[i]
                        succ_states.add(tuple(new_state))
    return sorted([list(s) for s in succ_states])

def is_solvable(state):
    arr = [n for n in state if n != 0]
    inv_count = sum(
        1 for i in range(len(arr)) for j in range(i + 1, len(arr)) if arr[i] > arr[j]
    )
    return inv_count % 2 == 0

def solve(state, goal_state=[1, 2, 3, 4, 5, 6, 7, 0, 0], heuristic=get_manhattan_distance):
    """
    Implement the A* algorithm here.

    INPUT: 
        An initial state (list of length 9)

    WHAT IT SHOULD DO:
        Prints a path of configurations from initial state to goal state along  h values, number of moves, and max queue number in the format specified in the pdf.
    """

    # This is a format helper，which is only designed for format purpose.
    # define "solvable_condition" to check if the puzzle is really solvable
    # build "state_info_list", for each "state_info" in the list, it contains "current_state", "h" and "move".
    # define and compute "max_length", it might be useful in debugging
    # it can help to avoid any potential format issue.

    # given state, check state format and get goal_state.
    goal_state = state_check(state)
    # please remove debugging prints when you submit your code.
    #print('initial state: ', state)
    #print('goal state: ', goal_state)

    if not is_solvable(state):
        print("Unsolvable")
        print(False)
        return
    print("Solvable")
    print(True)

    pq = []
    g_score = {}
    came_from = {}
    max_len = 0

    goal = tuple(goal_state)
    h0 = heuristic(state, goal)
    heapq.heappush(pq, (h0, 0, state))
    g_score[tuple(state)] = 0
    came_from[tuple(state)] = (None, 0, h0)  # (parent, g, h)

    while pq:
        max_len = max(max_len, len(pq))
        f, g, current = heapq.heappop(pq)
        print(f"Popped: {current} with f={f}, g={g}")

        if tuple(current) == goal:
            print("Reached goal!")
            steps = []
            node = tuple(current)
            while node is not None:
                parent, g_val, h_val = came_from[node]
                steps.append((list(node), h_val, g_val))
                node = parent
            for s, h, g in reversed(steps):
                print(f"{s} h={h} moves: {g}")
            print(f"Max queue length: {max_len}")
            return

        for succ in get_succ(current):
            succ_t = tuple(succ)
            tentative_g = g + 1
            h = heuristic(succ, goal)
            if succ_t not in g_score or tentative_g < g_score[succ_t]:
                g_score[succ_t] = tentative_g
                came_from[succ_t] = (tuple(current), tentative_g, h)
                print(f"Pushing: {succ} with g={tentative_g}, h={h}, f={tentative_g + h}")
                heapq.heappush(pq, (tentative_g + h, tentative_g, succ))

if __name__ == "__main__":
    """
    Feel free to write your own test code here to exaime the correctness of your functions. 
    Note that this part will not be graded.
    """
    # print_succ([2,5,1,4,0,6,7,0,3])
    # print()
    #
    # print(get_manhattan_distance([2,5,1,4,0,6,7,0,3], [1, 2, 3, 4, 5, 6, 7, 0, 0]))
    # print()

    solve([2,5,1,4,0,6,7,0,3], heuristic=get_manhattan_distance)
    print()
