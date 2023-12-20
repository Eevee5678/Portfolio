import pygame
from pygame.locals import *
from dataclasses import dataclass, field
from typing import Tuple
import math
import random
import copy
import time
from collections import defaultdict
from collections import deque
import collections


WIDTH, HEIGHT = 100, 100
rows,cols = 4,4
Colors = {2:Color(238,228,218,255), 4:Color(237,224,200,255), 8:Color(242,177,121,255), 16:Color(245,149,99,255), 32:Color(246,124,96,255),
          64:Color(246,94,59,255), 128:Color(237,207,115,255), 256:Color(237,204,98,255), 512:Color(237,200,80,255), 1024: Color(237,197,63,255), 2048: Color(237,194,45,255)}

Weights = [[3**16,3**15,3**14,3**13], [3**9, 3**10, 3**11, 3**12], [3**8, 3**7, 3**6, 3**5], [3, 3**2, 3**3, 3**4]]
moves = ["up", "down", "left", "right"]

def rand(): #generates random tile init
    chance = random.randrange(0, 100)
    if chance < 90:
        a = 2
    else: a = 4
    return a

def start(): #generates set with all positions (a,b) in the board
    s = set()
    for x in range(0,rows):
        for y in range (0,cols):
            s.add((x,y))
    return s

def generatearr(): #generates 2d array for board
    return [[0 for i in range(rows)] for j in range(cols)]

@dataclass
class Model:
    arr = [[0 for i in range(rows)] for j in range(cols)]
    empty = start()
    running = True
    game_running = True

def sliderightdown (board,row,right):  #transposes row (swapped if right/down)
    i = row
    original = []
    if right:
        for j in range (0,cols):
            original.append(board[i][j])
    else:
        for j in range (0,cols):
            original.append(board[j][i])
    order = [n for n in range(0, rows-1)]
    order.reverse()
    for x in order:
        if original[x+1] == 0:
            y = x+1
            while y >0:
                if original[x+1] == 0:
                    original.pop(x+1)
                    original.insert(0,0)
                    y -= 1
                else:
                    break
    copy1 = copy.deepcopy(original)
    for x in order:
        if copy1[x] == original[x] and copy1[x+1] == original[x+1] and original[x] == original[x+1] and original[x] != 0:
            copy1[x+1] += copy1[x]
            copy1.pop(x)
            copy1.insert(0,0)
    if right:
        for j in range(0,cols):
            board[i][j] = copy1[j]
    else:
        for j in range(0,cols):
            board[j][i] = copy1[j]

def slideleftup (board,row, left): #transposes row if left/up
    i = row
    original = []
    if left:
        for j in range (0,cols):
            original.append(board[i][j])
    else:
        for j in range (0,cols):
            original.append(board[j][i])
    order = [n for n in range(0, rows-1)]
    for x in order:
        if original[x] == 0:
            y = 0
            while y< cols:
                if original[x]==0:
                    original.pop(x)
                    original.append(0)
                    y+=1
                else:
                    break
    copy1 = copy.deepcopy(original)
    for x in order:
        if copy1[x] == original[x] and copy1[x+1] == original[x+1] and original[x] == original[x+1] and original[x] != 0:
            copy1[x] += copy1[x+1]
            copy1.pop(x+1)
            copy1.append(0)
    if left:
        for j in range(0,cols):
            board[i][j] = copy1[j]
    else:
        for j in range(0,cols):
            board[j][i] = copy1[j]

def move_deciderhelp(s, board):   #determines which function
    if s == "up":
        for i in range(0, cols):
            slideleftup(board, i, False)
    elif s == "down":
        for i in range(0, cols):
            sliderightdown(board, i, False)
    elif s == "right":
        for i in range(0, rows):
            sliderightdown(board, i, True)
    elif s == "left":
        for i in range(0, rows):
            slideleftup(board, i, True)

def move_decider (model):  #goes through all possible moves(udlr) and calculates score if its a valid move
    scores = {"up":0, "right":0, "down":0, "left":0}
    for a in moves:    #initial searching of udlr
        copyboard = copy.deepcopy(model.arr)
        move_deciderhelp(a,copyboard)
        copytemp = copy.deepcopy(model.empty)
        tempempty = emptyevaluate(copyboard, copytemp)
        if copyboard == model.arr:
            continue
        else:    #if the move is valid - search through all empty tiles and generate a 2 in each
            emptypos = []
            for (x,y) in tempempty:
                nextscores = {"up":0, "right":0, "down":0, "left":0}
                copyboardtwo = copy.deepcopy(copyboard)
                copyboardtwo[x][y] = 2
                for move in moves:  #find best move after that 2 has been generated
                    move_deciderhelp(move,copyboardtwo)
                    if copyboardtwo == copyboard:
                        continue
                    else:
                        nextscores[move] = scorecalculator(copyboardtwo)
                emptypos.append(max(nextscores.values()))  #add best score to emptypos
            if emptypos:  #avg out the scores of all empty tiles under that move
                avg = 0
                for x in emptypos:
                    avg += x
                scores[a] = avg/(len(emptypos))
    hasmove = validmove(scores)
    if not hasmove:
        model.game_running = False   #no valid possible moves = game over
    else: #avg score becomes score in scores dict to determine highest value and move to make
        s = keywithmaxval(scores)
        move_deciderhelp(s,model.arr)
        model.empty = emptyevaluate(model.arr, model.empty)
        tilegenerate(model)    #game keeps going and new tile generated


def validmove(scores):
    hasmove = False  # determiner for valid moves
    for n in scores:
        if n != 0:
            hasmove = True
    return hasmove

def tilegenerate(model):    #randomly generates tile in empty pos
    if model.empty:
        (a, b) = model.empty.pop()
        chance = random.randrange(0, 100)
        if chance < 90:
            model.arr[a][b] = 2
        else:
            model.arr[a][b] = 4
def keywithmaxval(d):
    """ a) create a list of the dict's keys and values;
        b) return the key with the max value"""
    v = list(d.values())
    k = list(d.keys())
    return k[v.index(max(v))]

def emptyevaluate (board,empty):    #checks to see if same spots are empty and updates before generating new tile
    for i in range (0,rows):
        for j in range (0,cols):
            if board[i][j] == 0:
                empty.add((i, j))
            else:
                if (i, j) in empty:
                    empty.remove((i, j))
    return empty

def scorecalculator(board):   #weighting system to determine optimal move
    score = 0
    for i in range (0,rows):
        for j in range (0,cols):
            score += ((board[i][j]**3) * Weights[i][j])
    return score


def drawh(model,screen):   #animation
    screen.fill(pygame.color.Color("white"))
    render_wall(screen, (0,0), (5,(rows*HEIGHT)+5))
    render_wall(screen, (0, (rows*HEIGHT)+5), ((cols*WIDTH)+10,5))
    render_wall(screen, ((rows*WIDTH)+10, 0), (5, (cols*HEIGHT)+10))
    render_wall(screen, (0, 0), ((rows*WIDTH)+10, 5))
    for i in range (0,rows):
        for j in range (0,cols):
            value = model.arr[j][i]
            if value == 0:
                r = pygame.rect.Rect((i * WIDTH) + 5, (j * HEIGHT) + 5, WIDTH + 5, HEIGHT)
                pygame.draw.rect(screen, "white", r)
            else:
                render_square(screen,(i,j), Colors[value], value)
    pygame.display.flip()

def render_wall(screen, position, dimensions):
    x,y = position
    a,b = dimensions
    r = pygame.rect.Rect(x,y,a,b)
    pygame.draw.rect(screen,"black", r)


def render_square(screen,position,color,value):
    x,y = position
    r = pygame.rect.Rect((x * WIDTH)+5,(y * HEIGHT)+5,WIDTH+5,HEIGHT)
    pygame.draw.rect(screen,color,r)
    font = pygame.font.SysFont(None, 30)
    text = font.render(str(value), True, "black")
    screen.blit(text,((x * WIDTH)+50,(y * HEIGHT)+45))

"""
def main():
    pygame.init()
    model = Model()
    clock = pygame.time.Clock()
    screen = pygame.display.set_mode(((rows*WIDTH)+15, (cols*HEIGHT)+10))
    while model.running:
        for i in range(0, 2):
            (x, y) = model.empty.pop()
            model.arr[x][y] = rand()
        for event in pygame.event.get():
            while model.game_running:
                if event.type == QUIT:
                    model.running = False
                move_decider(model)
                drawh(model,screen)
                clock.tick(5)
            else:break
        return maxnum(model.arr)
"""

def maxnum (board):    #max tile on board
    ans = 0
    for row in range(4):
        for col in range(4):
            if board[row][col] > ans:
                ans = board[row][col]
    return ans

def reset (model):    #reset model after each run/trial
    model.empty = start()
    model.game_running = True
    model.arr = generatearr()
    model.running = True

def run_your_solveranimate():   #animated runner
    pygame.init()
    model = Model()
    reset(model)
    clock = pygame.time.Clock()
    for i in range(0, 2):
        (x, y) = model.empty.pop()
        model.arr[x][y] = rand()
    screen = pygame.display.set_mode(((rows * WIDTH) + 15, (cols * HEIGHT) + 10))
    while model.game_running:
        copyboard = copy.deepcopy(model.arr)
        if pygame.event.EventType == QUIT:
            return(maxnum(model.arr))
        move_decider(model)
        drawh(model, screen)
        clock.tick(1000)
        if copyboard == model.arr:
            a = (maxnum(model.arr))
            break
    return a

def run_your_solver():   #non animated runner
    model = Model()
    reset(model)
    clock = pygame.time.Clock()
    for i in range(0, 2):
        (x, y) = model.empty.pop()
        model.arr[x][y] = rand()
    while model.game_running:
        copyboard = copy.deepcopy(model.arr)
        if pygame.event.EventType == QUIT:
            return(maxnum(model.arr))
        move_decider(model)
        clock.tick(1000)
        if copyboard == model.arr:
            a = (maxnum(model.arr))
            break
    return a

def runtrials(n=100):
    for _ in range(n):
        starttime = time.time()
        maxtile = run_your_solveranimate() ## <--- CHANGE
        endtime = time.time()
        runtime = endtime-starttime
        print(f'"REPORT","Katelyn",{runtime},{maxtile}')

if __name__ == '__main__':
    runtrials()
