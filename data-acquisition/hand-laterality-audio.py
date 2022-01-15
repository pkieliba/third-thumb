from __future__ import division
from psychopy import visual, core, data, event, logging, monitors, voicekey
from psychopy.constants import *
import numpy as np
import os
import sys
from optparse import OptionParser
import pandas
import random
import shutil

# Set trial variables
IMAGE_LIST = 'assets/hand-laterality.csv'
INTER_TRIAL_INTERVAL = 1.0
ACCEPTED_KEYS = ["escape","space","1","2","a","b"]
WINSIZE = [800,800]
FULL = True # Fullscreen or not
NBLOCK = 4
INFO =  True
TEXT_SIZE = 30
INFO = True # Show instructions or no

# Get the subject code
parser = OptionParser()
parser.add_option("-s", "--subj", dest="subj", action="store", help="Subject Code")
parser.add_option("-t", "--timepoint", dest="session", action="store", help="pre/post")
(options, args) = parser.parse_args()
subj = options.subj
session = options.session # pre or post

_thisDir = os.path.dirname(os.path.abspath( __file__))
os.chdir(_thisDir)
logging.console.setLevel(logging.WARNING)

fileOut = subj + "-" + session + "-HLJ.csv"
path = "./" + subj
audio = path + "/audio_" + session + "/"

if not os.path.exists(path):
    os.mkdir(path)
if not os.path.exists(audio):
    os.mkdir(audio)

if os.path.exists(path + fileOut):
    sys.exit("File " + fileOut + " already exists!")

stimuli_list = pandas.read_csv(IMAGE_LIST).values
trials = random.sample(list(stimuli_list), len(stimuli_list))
for i in range(NBLOCK-1):
    trials.extend([['break']])
    trials.extend(random.sample(list(stimuli_list), len(stimuli_list)))

responses = [] # output variable

voicekey.pyo_init() # initialize software for voice recording

try:
    win = visual.Window(fullscr=FULL, size=WINSIZE, color=[1,1,1], colorSpace='rgb', units='pix')

    # All text stimuli

    fixation = visual.TextStim(win=win, ori=0, name='fixation',
         text='+',  height=15, font=u'Arial',
         pos=[0, 0], wrapWidth=None,
         color=u'black', colorSpace='rgb', opacity=1,
         depth=0.0)

    instructions1 = visual.TextStim(win=win, ori=0, name='text',
         text=u'Welcome to the experiment! \n \nThis experiment aims to measure your accuracy and  \nreaction time in judging the laterality of the hand images. \n \nPress one of the foot pedals to continue.',   height=TEXT_SIZE, font=u'Arial',
         pos=[0, 0], wrapWidth=None,
         color=u'black', colorSpace='rgb', opacity=1,
         depth=0.0)
         

    break_text = visual.TextStim(win=win, ori=0, name='break',
         text=u'You can now have a short break. \n \nPress one of the foot pedals when you are ready to continue.',  height=TEXT_SIZE, font=u'Arial',
         pos=[0, 0], wrapWidth=None,
         color=u'black', colorSpace='rgb', opacity=1,
         depth=0.0)

    thanks_text = visual.TextStim(win=win, ori=0, name='thanks',
         text=u'You have completed the experiment. \nThank you for taking part. \nIf you have any questions please ask the experimenter now.',  height=TEXT_SIZE, font=u'Arial',
         pos=[0, 0], wrapWidth=None,
         color=u'black', colorSpace='rgb', opacity=1,
         depth=0.0)
         
         
    # Image stimuli
    hand = visual.ImageStim(win=win, ori=0, name='hand', units="pix", image="assets/hand-pics/LH1_030.png")
    
    # Show instructions and wait for key press to continue
    if (INFO==True):
        instructions1.draw()
        win.flip()
        event.waitKeys()
        core.wait(2)
    else:
        fixation.draw()
        win.flip()
        event.waitKeys()
        core.wait(2)
    # Start the timer
    trialClock = core.Clock()
    globalClock = core.Clock()  # to track the time since experiment started
    logging.setDefaultClock(globalClock)
    
    fixation.draw()
    win.flip()
    globalClock.reset()
    numTrial = 0

    for thisTrial in trials:
        print(thisTrial[0])
        
        if thisTrial[0][0] == "L":
            handSide = 1
        elif thisTrial[0][0] == "R":
            handSide = 2

        trialClock.reset()

        if (thisTrial[0]=='break'):
            break_text.draw()
            win.flip()
            event.waitKeys()
            core.wait(2)
        else:

            numTrial = numTrial+1

            audio_file = subj + "_" + session + "_resp" + str(numTrial)
            AudioResp = voicekey.OnsetVoiceKey(sec=30,file_out=audio_file)

            hand.setImage("assets/hand-pics/"+ thisTrial[0])
            hand.draw()
            # refresh the screen
            win.flip()
            # wait for audio response
            voiceResp = AudioResp.wait_for_event(plus=1)
            # append responses
            responses.append([handSide, float(thisTrial[0][2]), float(thisTrial[0][4:7]), 99, float(AudioResp.event_onset)])
            while trialClock.getTime()-voiceResp < INTER_TRIAL_INTERVAL: # show fixation cross between trials
                fixation.draw()
                win.flip()


    np.savetxt(path + "/" + fileOut, responses, delimiter=",", header="HAND,POSE,ORIENTATION,ANSWER,RT", comments='')
    files = os.listdir()
    for f in files:
        if (f.endswith(".wav")):
            shutil.move(f,audio)
    thanks_text.draw()
    win.flip()
    print("done")
    print(globalClock.getTime())
    event.waitKeys()

except (Exception) as e:
    print(e)
finally:
    win.close()
    core.quit()

