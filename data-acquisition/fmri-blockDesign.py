from __future__ import division
from psychopy import visual, core, data, event, logging, monitors
from psychopy.constants import *
import numpy as np
import os
from datetime import datetime
from optparse import OptionParser

# Set trial variables
BEGIN_TRIAL_DELAY = 7.0
END_TRIAL_DELAY = 9.0
BLOCK_DURATION = 9.0
DISPLAY_DURATION = 0.8
TRIGGER =['5']
ACCEPTED_KEYS = ["escape","5"]
WINSIZE = [800,800]
FULL = True
TEXT_SIZE = 50

def setGreen(finger):
    finger.fillColor=[0,1,0]
    return finger

# Get the subject code
parser = OptionParser()
parser.add_option("-b", "--block", dest="block", action="store", help="Block Number")
parser.add_option("-s", "--subj", dest="subj", action="store", help="Subject Code")
(options, args) = parser.parse_args()
block = options.block
subj = options.subj

STIMULI_LIST = 'block' + block + '.csv'

_thisDir = os.path.dirname(os.path.abspath(__file__))
os.chdir(_thisDir)
logging.console.setLevel(logging.WARNING)

expName = '6-fin-block'
expInfo = {}
expInfo['participant'] =  subj
expInfo['block'] =  block
expInfo['date'] = str(datetime.now())
expInfo['expName'] = expName

filename = _thisDir + os.sep + 'log_' + expInfo['participant']
resp = []
targ = []

thisExp = data.ExperimentHandler(name=expName, version='',
                                 extraInfo=expInfo,
                                 runtimeInfo=None,
                                 originPath=None,
                                 savePickle=False)
trials = data.TrialHandler(nReps=1, method='sequential',
                           extraInfo=expInfo,
                           originPath=None,
                           trialList=data.importConditions(STIMULI_LIST),
                           name='trials')
thisExp.addLoop(trials)

try:
    win = visual.Window(fullscr=FULL, size=WINSIZE,
                        color=[-1,-1,-1],
                        colorSpace='rgb',
                        units='pix')

    # All text stimuli
    fixation = visual.TextStim(win=win, ori=0, name='fixation',
         text='+',  height=TEXT_SIZE, font=u'Arial',
         pos=[0, 0], wrapWidth=None,
         color=u'white', colorSpace='rgb', opacity=1,
         depth=0.0)

    rest_text = visual.TextStim(win=win, ori=0, name='rest_text',
         text=u'REST',   height=TEXT_SIZE, font=u'Arial',
         pos=[0, 0], wrapWidth=None,
         color=u'white', colorSpace='rgb', opacity=1,
         depth=0.0)

    feet_text = visual.TextStim(win=win, ori=0, name='feet_text',
         text=u'FEET',   height=TEXT_SIZE, font=u'Arial',
         pos=[0, 0], wrapWidth=None,
         color=u'white', colorSpace='rgb', opacity=1,
         depth=0.0)

    face_text = visual.TextStim(win=win, ori=0, name='face_text',
         text=u'FACE',   height=TEXT_SIZE, font=u'Arial',
         pos=[0, 0], wrapWidth=None,
         color=u'white', colorSpace='rgb', opacity=1,
         depth=0.0)

    # Finger grid
    thumb_right = visual.Rect(win=win, units ="pix", width=70, height=200, fillColor=[0, 0, 0], lineColor=[0, 0, 0], pos=[80, -25])
    index_right = visual.Rect(win=win, units ="pix", width=70, height=330, fillColor=[0, 0, 0], lineColor=[0, 0, 0], pos=[155, 40])
    middle_right = visual.Rect(win=win, units ="pix", width=70, height=370, fillColor=[0, 0, 0], lineColor=[0, 0, 0], pos=[230, 60])
    ring_right = visual.Rect(win=win, units ="pix", width=70, height=330, fillColor=[0, 0, 0], lineColor=[0, 0, 0], pos=[305, 40])
    pinky_right = visual.Rect(win=win, units ="pix", width=70, height=240, fillColor=[0, 0, 0], lineColor=[0, 0, 0], pos=[380, -5])

    thumb_left = visual.Rect(win=win, units ="pix", width=70, height=200, fillColor=[0, 0, 0], lineColor=[0, 0, 0], pos=[-80, -25])
    index_left = visual.Rect(win=win, units ="pix", width=70, height=330, fillColor=[0, 0, 0], lineColor=[0, 0, 0], pos=[-155, 40])
    middle_left = visual.Rect(win=win, units ="pix", width=70, height=370, fillColor=[0, 0, 0], lineColor=[0, 0, 0], pos=[-230, 60])
    ring_left = visual.Rect(win=win, units ="pix", width=70, height=330, fillColor=[0, 0, 0], lineColor=[0, 0, 0], pos=[-305, 40])
    pinky_left = visual.Rect(win=win, units ="pix", width=70, height=240, fillColor=[0, 0, 0], lineColor=[0, 0, 0], pos=[-380, -5])

    stimuli_cases = {'1': lambda : thumb_left, '2': lambda: index_left, '3': lambda: middle_left, '4': lambda: ring_left, '5': lambda: pinky_left, '6': lambda: thumb_right, '7': lambda: index_right, '8': lambda: middle_right, '9': lambda: ring_right, '10': lambda: pinky_right, 'REST': lambda: 'rest', 'FEET': lambda: 'feet', 'FACE': lambda: 'face'}
 
    # Start the timer
    trialClock = core.Clock()
    globalClock = core.Clock()
    routineTimer = core.CountdownTimer()
    logging.setDefaultClock(globalClock)
    
    # INIT
    fixation.setAutoDraw(True)
    win.flip()
    keys = event.waitKeys(keyList=ACCEPTED_KEYS)
    globalClock.reset()
    routineTimer.reset()
    routineTimer.add(BEGIN_TRIAL_DELAY)
    if ('escape' in keys):
        core.quit()
    while routineTimer.getTime()>0:
        continue
    for thisTrial in trials:
        finger = stimuli_cases[list(thisTrial.values())[0]]()
        trial_time = 0
        trial_status = NOT_STARTED
        t = 0
        trialClock.reset()
        routineTimer.add(BLOCK_DURATION)

        # TRIAL
        targ.append(list(thisTrial.values())[0])
        while routineTimer.getTime() > 0:
            t=trialClock.getTime()
            if t >= trial_time and trial_status == NOT_STARTED:
                if finger != 'rest':
                    targ.append(globalClock.getTime())
                pressed = event.getKeys(timeStamped=globalClock)
                if pressed:
                    resp.append(pressed)
                if trial_time == 0:
                    trials.addData("startsTime", globalClock.getTime())
                if (finger != 'rest') and (finger != 'face') and (finger != 'feet'):
                    thumb_right.setAutoDraw(True)
                    index_right.setAutoDraw(True)
                    middle_right.setAutoDraw(True)
                    ring_right.setAutoDraw(True)
                    pinky_right.setAutoDraw(True)
                    thumb_left.setAutoDraw(True)
                    index_left.setAutoDraw(True)
                    middle_left.setAutoDraw(True)
                    ring_left.setAutoDraw(True)
                    pinky_left.setAutoDraw(True)
                    finger.fillColor = [0, 1, 0]
                    finger.setAutoDraw(True)
                    fixation.setAutoDraw(False)
                    trial_status = STARTED
                elif(finger == 'rest'):
                    thumb_right.setAutoDraw(False)
                    index_right.setAutoDraw(False)
                    middle_right.setAutoDraw(False)
                    ring_right.setAutoDraw(False)
                    pinky_right.setAutoDraw(False)
                    thumb_left.setAutoDraw(False)
                    index_left.setAutoDraw(False)
                    middle_left.setAutoDraw(False)
                    ring_left.setAutoDraw(False)
                    pinky_left.setAutoDraw(False)
                    rest_text.setAutoDraw(True)
                    fixation.setAutoDraw(False)
                elif(finger == 'feet'):
                    thumb_right.setAutoDraw(False)
                    index_right.setAutoDraw(False)
                    middle_right.setAutoDraw(False)
                    ring_right.setAutoDraw(False)
                    pinky_right.setAutoDraw(False)
                    thumb_left.setAutoDraw(False)
                    index_left.setAutoDraw(False)
                    middle_left.setAutoDraw(False)
                    ring_left.setAutoDraw(False)
                    pinky_left.setAutoDraw(False)
                    feet_text.setAutoDraw(True)
                    fixation.setAutoDraw(False)
                    trial_status = STARTED
                elif(finger == 'face'):
                    thumb_right.setAutoDraw(False)
                    index_right.setAutoDraw(False)
                    middle_right.setAutoDraw(False)
                    ring_right.setAutoDraw(False)
                    pinky_right.setAutoDraw(False)
                    thumb_left.setAutoDraw(False)
                    index_left.setAutoDraw(False)
                    middle_left.setAutoDraw(False)
                    ring_left.setAutoDraw(False)
                    pinky_left.setAutoDraw(False)
                    face_text.setAutoDraw(True)
                    fixation.setAutoDraw(False)
                    trial_status = STARTED
            elif trial_status == STARTED and t >= (trial_time + (DISPLAY_DURATION - win.monitorFramePeriod*0.75)):
                if (finger != 'rest') and (finger != 'face') and (finger != 'feet'):
                    finger.fillColor = [0,0,0]
                    finger.setAutoDraw(True)
                else:
                    rest_text.setAutoDraw(False)
                    face_text.setAutoDraw(False)
                    feet_text.setAutoDraw(False)
                    fixation.setAutoDraw(True)
                trial_time += 1.3
                trial_status = NOT_STARTED
                
            if event.getKeys(keyList=["escape"]):
                core.quit()
                
            win.flip()
            
        if (finger != 'rest') and (finger != 'face') and (finger != 'feet'):
            finger.fillColor = [0,0,0]
        rest_text.setAutoDraw(False)
        face_text.setAutoDraw(False)
        feet_text.setAutoDraw(False)
        
    # SAVE
    fixation.setAutoDraw(True)
    win.flip()
    print("done")
    routineTimer.add(END_TRIAL_DELAY)
    while routineTimer.getTime() > 0:
        continue
    print(globalClock.getTime())
    fixation.setAutoDraw(False)
    win.flip()
    np.save(subj + "_" + block + "_resp", resp)
    np.save(block + "_targ", targ)

except (Exception) as e:
    print(e)
finally:
    win.close()
    core.quit()
