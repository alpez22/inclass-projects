import random

class TeekoPlayer:
    """ An object representation for an AI game player for the game Teeko. """
    board = [[' ' for j in range(5)] for i in range(5)]
    pieces = ['b', 'r']

    def __init__(self):
        """ Initializes a TeekoPlayer object by randomly selecting red or black as its
        piece color. """
        self.my_piece = random.choice(self.pieces)
        self.opp = self.pieces[0] if self.my_piece == self.pieces[1] else self.pieces[1]

    def run_challenge_test(self):
        """ Set to True if you would like to run gradescope against the challenge AI! """
        return False

    def make_move(self, state):
        """ Selects the next move for the AI using a depth-2 minimax algorithm. """
        # Detect drop phase
        piece_count = sum(cell != ' ' for row in state for cell in row)
        drop_phase = piece_count < 8

        best_score = float('-inf')
        best_move = None
        # Generate all successors for AI's piece
        for succ_state, move in self.succ(state, self.my_piece):
            score = self.min_value(succ_state, 2)
            if score > best_score:
                best_score = score
                best_move = move

        # Fallback: random legal move
        if best_move is None:
            legal = []
            if drop_phase:
                for i in range(5):
                    for j in range(5):
                        if state[i][j] == ' ':
                            legal.append([(i, j)])
            else:
                for i in range(5):
                    for j in range(5):
                        if state[i][j] == self.my_piece:
                            for di in (-1,0,1):
                                for dj in (-1,0,1):
                                    ni, nj = i+di, j+dj
                                    if 0<=ni<5 and 0<=nj<5 and state[ni][nj]==' ' and not (di==0 and dj==0):
                                        legal.append([(ni, nj), (i, j)])
            best_move = random.choice(legal)
        return best_move

    def opponent_move(self, move):
        """ Validates the opponent's next move against the internal board representation. """
        # validate input
        if len(move) > 1:
            source_row, source_col = move[1]
            if source_row is not None and self.board[source_row][source_col] != self.opp:
                self.print_board()
                print(move)
                raise Exception("You don't have a piece there!")
            if abs(source_row - move[0][0]) > 1 or abs(source_col - move[0][1]) > 1:
                self.print_board()
                print(move)
                raise Exception('Illegal move: Can only move to an adjacent space')
        if self.board[move[0][0]][move[0][1]] != ' ':
            raise Exception("Illegal move detected")
        # apply opponent's move
        self.place_piece(move, self.opp)

    def place_piece(self, move, piece):
        """ Places a piece on the board or moves it. """
        # If this is a move (after drop phase), remove from source
        if len(move) > 1:
            sr, sc = move[1]
            self.board[sr][sc] = ' '
        # Place at destination
        dr, dc = move[0]
        self.board[dr][dc] = piece

    def print_board(self):
        """ Formatted printing for the board. """
        for row in range(len(self.board)):
            line = str(row) + ": "
            for cell in self.board[row]:
                line += cell + " "
            print(line)
        print("   A B C D E")

    def game_value(self, state):
        """ Checks the current board status for a win condition. """
        # check horizontal wins
        for row in state:
            for i in range(2):
                if row[i] != ' ' and row[i] == row[i+1] == row[i+2] == row[i+3]:
                    return 1 if row[i] == self.my_piece else -1
        # check vertical wins
        for col in range(5):
            for i in range(2):
                if state[i][col] != ' ' and state[i][col] == state[i+1][col] == state[i+2][col] == state[i+3][col]:
                    return 1 if state[i][col] == self.my_piece else -1
        # check \ diagonal wins
        for i in range(2):
            for j in range(2):
                if state[i][j] != ' ' and state[i][j] == state[i+1][j+1] == state[i+2][j+2] == state[i+3][j+3]:
                    return 1 if state[i][j] == self.my_piece else -1
        # check / diagonal wins
        for i in range(3,5):
            for j in range(2):
                if state[i][j] != ' ' and state[i][j] == state[i-1][j+1] == state[i-2][j+2] == state[i-3][j+3]:
                    return 1 if state[i][j] == self.my_piece else -1
        # check 2x2 box wins
        for i in range(4):
            for j in range(4):
                if state[i][j] != ' ' and state[i][j] == state[i][j+1] == state[i+1][j] == state[i+1][j+1]:
                    return 1 if state[i][j] == self.my_piece else -1
        return 0  # no winner yet

    def succ(self, state, piece):
        """Generate all legal successor states and corresponding moves for the given piece."""
        successors = []
        piece_count = sum(cell != ' ' for row in state for cell in row)
        drop_phase = piece_count < 8
        if drop_phase:
            # drop any empty spot
            for i in range(5):
                for j in range(5):
                    if state[i][j] == ' ':
                        new_state = [row.copy() for row in state]
                        new_state[i][j] = piece
                        successors.append((new_state, [(i, j)]))
        else:
            # move one existing piece to adjacent empty
            for i in range(5):
                for j in range(5):
                    if state[i][j] == piece:
                        for di in (-1, 0, 1):
                            for dj in (-1, 0, 1):
                                ni, nj = i+di, j+dj
                                if 0 <= ni < 5 and 0 <= nj < 5 and state[ni][nj] == ' ' and not (di == 0 and dj == 0):
                                    new_state = [row.copy() for row in state]
                                    new_state[i][j] = ' '
                                    new_state[ni][nj] = piece
                                    successors.append((new_state, [(ni, nj), (i, j)]))
        return successors

    def heuristic_game_value(self, state):
        """Simple heuristic: terminal game value or 0.0 for non-terminal."""
        v = self.game_value(state)
        return float(v) if v != 0 else 0.0

    def max_value(self, state, depth):
        v = self.heuristic_game_value(state)
        if depth == 0 or v != 0:
            return v
        best = float('-inf')
        for succ_state, move in self.succ(state, self.my_piece):
            best = max(best, self.min_value(succ_state, depth-1))
        return best

    def min_value(self, state, depth):
        v = self.heuristic_game_value(state)
        if depth == 0 or v != 0:
            return v
        best = float('inf')
        for succ_state, move in self.succ(state, self.opp):
            best = min(best, self.max_value(succ_state, depth-1))
        return best

############################################################################
#
# THE FOLLOWING CODE IS FOR SAMPLE GAMEPLAY ONLY
#
############################################################################
def main():
    print('Hello, this is Samaritan')
    ai = TeekoPlayer()
    piece_count = 0
    turn = 0

    # drop phase
    while piece_count < 8 and ai.game_value(ai.board) == 0:
        # get the player or AI's move
        if ai.my_piece == ai.pieces[turn]:
            ai.print_board()
            move = ai.make_move(ai.board)
            ai.place_piece(move, ai.my_piece)
            print(ai.my_piece+" moved at "+chr(move[0][1]+ord("A"))+str(move[0][0]))
        else:
            move_made = False
            ai.print_board()
            print(ai.opp+"'s turn")
            while not move_made:
                player_move = input("Move to (e.g. B3): ")
                try:
                    ai.opponent_move([(int(player_move[1]), ord(player_move[0]) - ord("A"))])
                    move_made = True
                except Exception as e:
                    print(e)

        # update the game variables
        piece_count += 1
        turn = (turn + 1) % 2

    # move phase - can't have a winner until all 8 pieces are on the board
    while ai.game_value(ai.board) == 0:
        # get the player or AI's move
        if ai.my_piece == ai.pieces[turn]:
            ai.print_board()
            move = ai.make_move(ai.board)
            ai.place_piece(move, ai.my_piece)
            print(ai.my_piece+" moved from "+chr(move[1][1]+ord("A"))+str(move[1][0]))
            print("  to "+chr(move[0][1]+ord("A"))+str(move[0][0]))
        else:
            move_made = False
            ai.print_board()
            print(ai.opp+"'s turn")
            while not move_made:
                move_from = input("Move from (e.g. B3): ")
                move_to = input("Move to (e.g. C4): ")
                try:
                    ai.opponent_move([(int(move_to[1]), ord(move_to[0]) - ord("A")),
                                      (int(move_from[1]), ord(move_from[0]) - ord("A"))])
                    move_made = True
                except Exception as e:
                    print(e)

        turn = (turn + 1) % 2

    ai.print_board()
    if ai.game_value(ai.board) == 1:
        print("AI wins! Game over.")
    else:
        print("You win! Game over.")

if __name__ == "__main__":
    main()
