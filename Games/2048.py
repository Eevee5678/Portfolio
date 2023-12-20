import pygame
from pygame.locals import *
from dataclasses import dataclass, field
from typing import Tuple
import math
import random
import copy
from collections import defaultdict
from collections import deque
import collections


WIDTH, HEIGHT = 100, 100
rows,cols = 4,4
Colors = {2:Color(238,228,218,255), 4:Color(237,224,200,255), 8:Color(242,177,121,255), 16:Color(245,149,99,255), 32:Color(246,124,96,255),
          64:Color(246,94,59,255), 128:Color(237,207,115,255), 256:Color(237,204,98,255), 512:Color(237,200,80,255), 1024: Color(237,197,63,255), 2048: Color(237,194,45,255)}

def rand():
    chance = random.randrange(0, 100)
    if chance < 90:
        a = 2
    else: a = 4
    return a

def start():
    s = set()
    for x in range(0,rows):
        for y in range (0,cols):
            s.add((x,y))
    return s

@dataclass
class Model:
    arr = [[0 for i in range(rows)] for j in range(cols)]
    empty = start()
    running = True

def sliderightdown (model,row,right):
    i = row
    original = []
    if right:
        for j in range (0,cols):
            original.append(model.arr[i][j])
    else:
        for j in range (0,cols):
            original.append(model.arr[j][i])
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
    for j in range(0,cols):
        if right:
            model.arr[i][j] = copy1[j]
            if model.arr[i][j] == 0:
                model.empty.add((i, j))
            else:
                if (i, j) in model.empty:
                    model.empty.remove((i, j))
        else:
            model.arr[j][i] = copy1[j]
            if model.arr[j][i] == 0:
                model.empty.add((j, i))
            else:
                if (j, i) in model.empty:
                    model.empty.remove((j, i))

def slideleftup (model,row, left):
    i = row
    original = []
    if left:
        for j in range (0,cols):
            original.append(model.arr[i][j])
    else:
        for j in range (0,cols):
            original.append(model.arr[j][i])
    print(original)
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
    for j in range(0,cols):
        if left:
            model.arr[i][j] = copy1[j]
            if model.arr[i][j] == 0:
                model.empty.add((i, j))
            else:
                if (i,j) in model.empty:
                    model.empty.remove((i, j))
        else:
            model.arr[j][i] = copy1[j]
            if model.arr[j][i] == 0:
                model.empty.add((j, i))
            else:
                if (j,i) in model.empty:
                    model.empty.remove((j,i))


def keyh (model,event):
    original = copy.deepcopy(model.arr)
    if event.key == K_UP:
        for x in range (0,cols):
            slideleftup(model,x,False)
    elif event.key == K_DOWN:
        for x in range (0,cols):
            sliderightdown(model,x,False)
    elif event.key == K_RIGHT:
        for x in range (0,rows):
            sliderightdown(model,x,True)
    elif event.key == K_LEFT:
        for x in range (0,rows):
            slideleftup(model,x,True)
    if original != model.arr:
        if model.empty:
            (a,b) = model.empty.pop()
            chance = random.randrange(0,100)
            if chance < 90:
                model.arr[a][b] = 2
            else: model.arr[a][b] = 4



def drawh(model,screen):
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

def main():
    pygame.init()
    model = Model()
    clock = pygame.time.Clock()
    for i in range (0,2):
        (x,y) = model.empty.pop()
        model.arr[x][y] = rand()
    screen = pygame.display.set_mode(((rows*WIDTH)+15, (cols*HEIGHT)+10))
    while model.running:
        for event in pygame.event.get():
            if event.type == QUIT:
                model.running = False
            drawh(model,screen)
            if event.type == KEYDOWN:
                keyh(model,event)

main()
