from __future__ import division
from psychopy import visual, core, data, event, logging, monitors
from psychopy.constants import *
import numpy as np
import os
from datetime import datetime
import sys

CONFIGURATION_FILE = 'body_loc.csv'

BEGIN_TRIAL_DELAY = 7.0
END_TRIAL_DELAY = 8.0
TEXT_SIZE = 0.11
BLOCK_DURATION = 24.0
PREPARE_TIME = 0.0
MOVE_TIME = 0.0
REST_TIME = 12.0
DISPLAY_DURATION = 1.1
TRIGGER = ['5']
_thisDir = os.path.dirname(os.path.abspath( __file__))
os.chdir(_thisDir)
logging.console.setLevel(logging.WARNING)

expName = 'body_loc'
expInfo = {}
if len(sys.argv) ==2:
    expInfo['participant'] =  sys.argv[1]
else:
    expInfo['participant'] = 'test'
expInfo['date'] = str(datetime.now())
expInfo['expName'] = expName

filename = _thisDir + os.sep + 'log_' + expInfo['participant']

thisExp = data.ExperimentHandler(name=expName, version='',
     extraInfo=expInfo, runtimeInfo=None,
     originPath=None,
     savePickle=False, saveWideText=True,
     dataFileName=filename)
trials = data.TrialHandler(nReps=1, method='sequential',
     extraInfo=expInfo, originPath=None,
     trialList=data.importConditions(CONFIGURATION_FILE),
     name='trials')
thisExp.addLoop(trials)

try:
    win = visual.Window(fullscr=True, size=[1024,768],screen=0, allowGUI=False, allowStencil=False,
         color=[-1,-1,-1], colorSpace='rgb')

    fixation = visual.TextStim(win=win, ori=0, name='fixation',
         text='+',  height = TEXT_SIZE, font=u'Arial',
         pos=[0, 0], wrapWidth=None,
         color=u'white', colorSpace='rgb', opacity=1,
         depth=0.0)

    text = visual.TextStim(win=win, ori=0, name='text',
         text=u'.......',   height = TEXT_SIZE, font=u'Arial',
         pos=[0, 0], wrapWidth=None,
         color=u'white', colorSpace='rgb', opacity=1,
         depth=0.0)

    rest_text = visual.TextStim(win=win, ori=0, name='move',
         text=u'~~~~~ Rest ~~~~~',  height = TEXT_SIZE, font=u'Arial',
         pos=[0, 0], wrapWidth=None,
         color=u'white', colorSpace='rgb', opacity=1,
         depth=0.0)

    move_text = visual.TextStim(win=win, ori=0, name='move',
         text=u'MOVE',  height = TEXT_SIZE, font=u'Arial',
         pos=[0, 0], wrapWidth=None,
         color=u'white', colorSpace='rgb', opacity=1,
         depth=0.0)

    trialClock = core.Clock()
    globalClock = core.Clock()
    routineTimer = core.CountdownTimer()
    logging.setDefaultClock(globalClock)
    
    #------Prepare to init the routine-------

    text.setAutoDraw(True)
    win.flip()
    keys = event.waitKeys(keyList=TRIGGER + ['escape'])
    globalClock.reset()
    routineTimer.reset()
    routineTimer.add(BEGIN_TRIAL_DELAY)
    text.setAutoDraw(False)
    fixation.setAutoDraw(True)
    win.flip()
    if('escape' in keys):
         core.quit()
    while routineTimer.getTime() > 0:
         continue
    for thisTrial in trials:
        print(list(thisTrial.values())[0])
        trialComponents = [rest_text, move_text]
        for thisComponent in trialComponents:
              if hasattr(thisComponent, 'status'):
                    thisComponent.setAutoDraw(False)
                    thisComponent.status = NOT_STARTED
        t = 0
        trialClock.reset()  # clock
        routineTimer.add(BLOCK_DURATION)
        
        #-------Start trial-------
        continueRoutine = True
        isFirstFrame = True
        move_time = MOVE_TIME
        rest_time = REST_TIME
        while continueRoutine and routineTimer.getTime() > 0:
            t = trialClock.getTime()
            if t >= move_time and move_text.status == NOT_STARTED:
                if move_time == MOVE_TIME:
                    trials.addData("move",globalClock.getTime())
                move_text.setText("MOVE " + list(thisTrial.values())[0])
                move_text.setAutoDraw(True)
                fixation.setAutoDraw(False)
            elif move_text.status == STARTED and t >= (move_time + (DISPLAY_DURATION -win.monitorFramePeriod*0.75)):
                move_text.setAutoDraw(False)
                fixation.setAutoDraw(True)
                if move_time + 2 < REST_TIME:
                    move_time+=2
                    move_text.status = NOT_STARTED
            elif t >= rest_time and rest_text.status == NOT_STARTED:
                if rest_time == REST_TIME:
                    trials.addData("rest",globalClock.getTime())
                rest_text.setAutoDraw(True)
                fixation.setAutoDraw(False)
            elif rest_text.status == STARTED and t >= (rest_time + (DISPLAY_DURATION -win.monitorFramePeriod*0.75)):
                rest_text.setAutoDraw(False)
                fixation.setAutoDraw(True)
                rest_time+=2
                rest_text.status = NOT_STARTED

            if event.getKeys(keyList=["escape"]):
                core.quit()
                    
            # refresh the screen
            if continueRoutine:
                win.flip()
         
        #-------End trial-------
        thisExp.nextEntry()
    
    fixation.setAutoDraw(True)
    win.flip()
    print("done")
    routineTimer.add(END_TRIAL_DELAY)
    while routineTimer.getTime() > 0:
        continue
    print(globalClock.getTime())
    fixation.setAutoDraw(False)
    win.flip()
    
except (Exception) as e:
    print(e)
finally:
    win.close()
    core.quit()
