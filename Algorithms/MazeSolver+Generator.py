import pygame
from pygame.locals import *
from dataclasses import dataclass, field
from typing import Tuple
import math
import random
from collections import defaultdict

def make_grid(width, height):
  edges = defaultdict(set)
  for y in range(height):
    for x in range(width):
      possible = [(x-1,y), (x+1,y), (x,y-1), (x,y+1)]
      for (a,b) in possible:
        if (a < width and b < height and a >= 0 and b >= 0):
          edges[(x,y)].add((a,b))
  return edges


WIDTH, HEIGHT = 40, 40
SCREENX, SCREENY = 10,10

@dataclass
class Model:
    start: tuple
    end: tuple
    stepper_running: bool = True
    solver_running = True
    running = True
    time = 0
    grid_on: ... = field(default_factory=list)
    grid = make_grid(SCREENX,SCREENY)
    maze = defaultdict(set)
    todo = [(0,0)]
    solvertodo = []
    mazediscovered = set([(0,0)])
    solverdiscovered = set()
    timein = {}
    processed = set()
    wallx = set()
    wally = set()

    def step(self):
        if not self.todo:
            self.stepper_running = False
            return False
        selected = self.todo.pop()
        neighbors = [x for x in self.grid[selected]
                     if x not in self.mazediscovered]
        if neighbors:
            x = random.choice(neighbors)
            self.maze[selected].add(x)
            self.maze[x].add(selected)
            self.todo.append(selected)
            self.todo.append(x)
            self.mazediscovered.add(x)

    def solver(self):
        if not self.solvertodo:
            self.solver_running = False
            return False
        current = self.solvertodo[-1]
        if current in self.timein:
            self.processed.add(current)
            self.solvertodo.pop()
        else: self.timein[current] = self.time
        self.time +=1
        for edge in self.maze[current]:
            if edge not in self.solverdiscovered:
                self.solvertodo.append(edge)
                self.solverdiscovered.add(edge)


def wallfunction (model):
    for (x,y) in model.grid:
        for (a,b) in model.grid[(x,y)]:
            if (a,b) not in model.maze[(x,y)]:
                if y-b == 0:
                    model.wally.add((((WIDTH*(a+x))+40)/2, (HEIGHT*(b+y))/2))
                if x-a == 0:
                    model.wallx.add(((WIDTH * (a + x))/ 2, ((HEIGHT * (b + y))+40) / 2))

def drawh(model,screen):
    screen.fill(pygame.color.Color("white"))
    render_wall(screen, (0,0), (5,(SCREENY*HEIGHT)+5))
    render_wall(screen, (0, (SCREENY*HEIGHT)+5), ((SCREENX*WIDTH)+10,5))
    render_wall(screen, ((SCREENX*WIDTH)+10, 0), (5, (SCREENY*HEIGHT)+10))
    render_wall(screen, (0, 0), ((SCREENX*WIDTH)+10, 5))
    for (a,b) in model.wally:
        render_wall(screen, (a+5,b+5), (5,40))
    for (a,b) in model.wallx:
        render_wall(screen,(a+5,b+5), (45,5))
    pygame.display.flip()

def render_wall(screen, position, dimensions):
    x,y = position
    a,b = dimensions
    r = pygame.rect.Rect(x,y,a,b)
    pygame.draw.rect(screen,"black", r)

def drawsolver(model,screen):
    for (a,b) in model.solverdiscovered:
        render_solver(screen,(a,b),"yellow")
    for (a,b) in model.processed:
        render_solver(screen,(a,b),"green")
    render_solver(screen, model.start, "pink")
    for (a, b) in model.wally:
        render_wall(screen, (a + 5, b + 5), (5, 40))
    for (a, b) in model.wallx:
        render_wall(screen, (a + 5, b + 5), (45, 5))
    pygame.display.flip()


def render_solver(screen,position,color):
    x,y = position
    r = pygame.rect.Rect((x * WIDTH)+5,(y * HEIGHT)+5,WIDTH+5,HEIGHT)
    pygame.draw.rect(screen,color,r)


def main():
    pygame.init()
    model = Model(grid_on=[], start = (0,0), end = (10,10))
    clock = pygame.time.Clock()
    screen = pygame.display.set_mode(((SCREENX*WIDTH)+15, (SCREENY*HEIGHT)+10))
    while model.stepper_running:
        model.step()
    while model.running:
        for event in pygame.event.get():
            if event.type == QUIT:
                model.running = False
            wallfunction(model)
            drawh(model,screen)
            if event.type == MOUSEBUTTONDOWN:
                x,y = event.pos
                model.start = (x//WIDTH, y//HEIGHT)
                model.solvertodo.append(model.start)
                model.solver_running = True
                while model.solver_running:
                    model.solver()
                    drawsolver(model,screen)
                    clock.tick(10)


main()
