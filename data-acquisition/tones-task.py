from __future__ import division
from psychopy import visual, core, data, event, sound, prefs
from psychopy.constants import *
import numpy as np
import math
import random
import time

TRIAL_LENGTH = 60
WINSIZE = [400,400]
TEXT_SIZE = 60
FULL = False
prefs.general['audioLib'] = ['pygame']
tones = ["assets/low-tone.wav","assets/high-tone.wav"]
endTone = sound.Sound("assets/end-tone.wav",stereo=True)
ACCEPTED_KEYS = ["escape","space"]
count = 10


win = visual.Window(fullscr=FULL, size=WINSIZE, color=[1,1,1], colorSpace='rgb', units='pix')

timer = visual.TextStim(win=win, ori=0, name='timer',
                        text='60',  height=TEXT_SIZE, font=u'Arial',
                        pos=[0, 0], wrapWidth=None,
                        color=u'black', colorSpace='rgb', opacity=1,
                        depth=0.0)
timer.draw()
win.flip()
keys = event.waitKeys()
if ('escape' in keys):
    core.quit()
routineTimer = core.CountdownTimer()
routineTimer.add(TRIAL_LENGTH)

while routineTimer.getTime()>0.3:

    keys = event.getKeys()
    if ('escape' in keys):
        core.quit()

    if routineTimer.getTime()>6:
        time.sleep(random.randint(1,6))
    else:
        time.sleep(routineTimer.getTime())
        break
    
    timer.text=math.ceil(routineTimer.getTime())
    timer.draw()
    win.flip()
    toPlay = random.choice(tones)
    tone = sound.Sound(toPlay,stereo=True)
    tone.play()
    if toPlay=="assets/high-tone.wav":
        count = count +1
    if toPlay=="assets/low-tone.wav":
        count = count -1

timer.text=('0!!!')
timer.color=u'red'
timer.draw()
win.flip()
time.sleep(0.5)
endTone.play()
time.sleep(2)
event.waitKeys()
win.close()
print(count)
core.quit()


