import math

import numpy as np
from typing import Tuple, Optional
import numpy.typing as npt
import copy
from collections import Counter
from dataclasses import dataclass
import time

NDArrayInt = npt.NDArray[np.int8]
Board = NDArrayInt

ROWS = 7
COLS = 7
DIR = [(0, 1), (1, 1), (1, -1), (1, 0)]
playermark = {0: " ", 1: "X", -1: "O"}


@dataclass
class AIResult:
    score: int
    newstate: Optional['Model'] = None
    move: Optional[int] = None


## Examples:
## 1. m = Model() starts with empty board
## 2. m = Model(player=2) empty board but player 2 (O) starts
## 3. mat = np.zeros(7,6); mat[3,0] = 1; mat[3,1] = 1 mat[4,0]=-1;
##    m = Model(board=mat) # already has 2 X's and one O.

# player 1 = max human X
# player2 = min ai

class Model:
    def __init__(self, player: int = 1, board: NDArrayInt = None):
        self.player = player
        self.board = (
            board if board is not None else np.zeros((ROWS, COLS), dtype=np.int8)
        )

    def __copy__(self):
        return Model(player=self.player, board=np.copy(self.board))

    def __str__(self):
        return "\n".join(
            [
                " ".join([playermark[self.board[r, c]] for c in range(COLS)])
                for r in range(ROWS - 1, -1, -1)
            ]
            + ["-".join([str(c) for c in range(COLS)])]
        )


def winning_index_maker(nrows, ncols, run_length=4):
    """:return [[(row,col)]] a list of lists of 4 ordered pairs (row,col)"""
    ans = []
    for r in range(nrows):
        for c in range(ncols):
            for drow, dcol in DIR:
                in_a_row = [
                    (r + k * drow, c + k * dcol)
                    for k in range(run_length)
                    for newrow in (r + k * drow,)
                    for newcol in (c + k * dcol,)
                    if 0 <= newrow < ROWS and 0 <= newcol < COLS
                ]
                if len(in_a_row) == run_length:
                    ans.append(in_a_row)
    return ans


## This dictionary contains the n-in-a-row sequences on the ROWSxCOLS board.
## The most useful one is SEQUENCES[4], the four-in-a-row sequences to detect wins.
SEQUENCES = {
    run_length: winning_index_maker(ROWS, COLS, run_length)
    for run_length in range(1, 5)
}
FOURS = SEQUENCES[4]


def winner(board):
    """Return 0 if there is no winner. Otherwise 1 or -1."""
    for four in FOURS:
        values = [board[r, c] for (r, c) in four]
        if (
                values[0] != 0
                and values[0] == values[1]
                and values[1] == values[2]
                and values[2] == values[3]
        ):
            return int(values[0])  # values = player
    # No four in a row
    return 0


def opponent(player: int):  # returns opposite player after move
    return -player


def top_row(m: Model, colmove: int):
    return max([r for r in range(ROWS) if m.board[r, colmove] != 0], default=-1)


def is_legal(m: Model, colmove: int):
    """True if the column is a legal number and at least the top space in the column is empty."""
    return 0 <= colmove < COLS and m.board[ROWS - 1, colmove] == 0


def all_legal_moves(m: Model):
    return [c for c in range(COLS) if is_legal(m, c)]


def make_move(m: Model, colmove: int):
    """What should happen if the move is illegal? Possibly error instead of just warning."""
    if not is_legal(m, colmove):
        print(
            f"WARNING: asked to move in column {colmove} but that is illegal {m.board=}"
        )
        return m  # could be None?

    r = 1 + top_row(m, colmove)
    newm = copy.copy(m)
    newm.board[r, colmove] = m.player
    newm.player = opponent(m.player)
    return newm


def event_loop(m: Model):
    print(m)
    while True:
        pm = input(
            f"Player {playermark[m.player]} to move.\nEnter a number 0-{COLS - 1}, or -1 to quit.\n? "
        )
        try:
            colmove = int(pm)
        except ValueError:
            if pm == "":
                colmove = -11
            else:
                colmove = -2
        if colmove == -1:
            return m
        starttime = time.time()
        m = make_move(m, colmove)
        aimove = ai_minimax_move(m, 4)
        m = make_move(m, aimove.move)
        endtime = time.time()
        runtime = endtime - starttime
        print(m)
        print(f"board score={score_game(m, 1) - score_game(m, -1)}")
        print(f"Runtime = {runtime}")
        w = winner(m.board)
        if w != 0:
            print(f"Player {w} WINS!!!")
            return m
        elif not all_legal_moves(m):
            print(f"NO WINNER")
            return m


def possible_moves(m: Model):
    return [c for c in range(COLS) if is_legal(m, c)]


def score_game(m: Model, player):
    score = 0
    for r in range(0, ROWS):
        entire_row = []
        for c in range(COLS):
            entire_row.append(m.board[r, c])
        for col in range(COLS - 3):
            four = entire_row[col:col + 4]
            score += scorehelp(four, player)
            #print (four, "Horizontal")

    for c in range(COLS):
        entire_col = []
        for r in range(ROWS):
            entire_col.append(m.board[r, c])
        for row in range(ROWS - 3):
            four = entire_col[row:row + 4]
            score += scorehelp(four, player)
            #print(four, "Vertical")

    for r in range(ROWS - 3):
        for c in range(COLS - 3):
            four = [m.board[r + i, c + i] for i in range(0, 4)]
            four2 = [m.board[r + 3 - i, c + i] for i in range(0, 4)]
            score += scorehelp(four, player)
            score += scorehelp(four2,player)
            #print(four, "Diags")
    return score


def scorehelp(four, player):
    score = 0
    if four.count(player) == 4:
        score += 10000000000000
    if four.count(player) == 3 and four.count(0) == 1:
        score += 300
    if four.count(player) == 2 and four.count(0) == 2:
        score += 100
    return score


def ai_minimax_move(m: Model, depth: int = 1) -> AIResult:
    # max = true min = false
    move = 0
    def minimaxhelp(model, d, maxp):
        scores = {}
        nonlocal move
        for play in all_legal_moves(model):
            tempm = make_move(model, play)
            if winner(tempm.board) != 0:
                move = play
                if maxp:
                    scores[play] = 1000000
                    return 1 * 1000000
                else:
                    scores[play] = (-1) * 1000000
                    return (-1) * 1000000
            if d < depth:
                scores[play] = minimaxhelp(tempm, d + 1, not (maxp))
            else:
                scores[play] = (score_game(tempm, 1)) - score_game(tempm, -1)
        if not maxp:
            if d == 1:
                print(scores)
                move = keywithminval(scores)
            v = list(scores.values())
            return (min(v))
        else:
            if d == 1:
                move = keywithmaxval(scores)
            v = list(scores.values())
            return (max(v))

    minimaxhelp(m, 1, False)
    return AIResult(score_game(m, 1) - score_game(m, -1), m, move)


def keywithmaxval(d):
    """ a) create a list of the dict's keys and values;
        b) return the key with the max value"""
    v = list(d.values())
    k = list(d.keys())
    return k[v.index(max(v))]


def keywithminval(d):
    """ a) create a list of the dict's keys and values;
        b) return the key with the max value"""
    v = list(d.values())
    k = list(d.keys())
    return k[v.index(min(v))]


if __name__ == "__main__":
    m0 = Model()
    m1 = event_loop(m0)
