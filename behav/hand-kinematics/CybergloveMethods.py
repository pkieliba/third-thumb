#!/usr/bin/env python3

import xml.etree.ElementTree
import csv
import sys
import numpy as np
from scipy import stats
import pandas as pd
from sklearn.linear_model import LinearRegression
from sklearn.decomposition import PCA
from datetime import datetime
import scipy.signal as signal
from sklearn.preprocessing import StandardScaler


joint_names = ['G_ThumbRotate','G_ThumbMPJ','G_ThumbIJ','G_ThumbAb','G_IndexMPJ','G_IndexPIJ',
               'G_IndexDIJ','G_MiddleMPJ','G_MiddlePIJ','G_MiddleDIJ','G_MiddleIndexAb','G_RingMPJ',
               'G_RingPIJ','G_RingDIJ','G_RingMiddleAb','G_PinkieMPJ','G_PinkiePIJ','G_PinkieDIJ',
               'G_PinkieRingAb','G_PalmArch','G_WristPitch','G_WristYaw']


class CyberGloveSample:


    def __init__(self, calibration_file_name=None, raw_timeseries_file_name=None):
        
        self.GainOffsetDict = None
        self.RawData = None
        self.CalibratedData = None
        self.FilteredData = None
        self.Time = []
        self.Vel = None

        if calibration_file_name:
            self.CalibrationFromFile(calibration_file_name)
        else:
            print("No calibration file provided")
            sys.exit(1)

        if raw_timeseries_file_name:
            self.ReadTimeSeriesFromFile(raw_timeseries_file_name)
            self.ToVelocities()
        else:
            print("No timeseries fille provided")
            sys.exit(1)



    @staticmethod
    def JointNamesMap():
        return dict([ ('field.position' + str(idx), name ) for idx, name in enumerate(joint_names)])


    def CalibrationFromFile(self, file_name):
        """Read in the sensor value to joint angle mapping and calculate gain and offset parameters"""

        e = xml.etree.ElementTree.parse(file_name).getroot()
        self.GainOffsetDict = {}

        for row in e:

            joint_name = row.attrib['name']
            x1, y1 = float(row[0].attrib['raw_value']), float(row[0].attrib['calibrated_value'])
            x2, y2 = float(row[1].attrib['raw_value']), float(row[1].attrib['calibrated_value'])
            
            if joint_name == 'G_IndexDIJ': # this sensor was usually not working. We're assinging a very small value here, to avoid calibration error.
                x2 = 0.00000001

            gain = (y2 - y1) / (x2 - x1)
            offset = (y2 * x1 - y1 * x2) / (y2 - y1)
            self.GainOffsetDict[joint_name] = (gain, offset)

        
    def ReadTimeSeriesFromFile(self, file_name):
        """Read in and pre-process the timeseries data"""

        self.RawData = {}
        joint_names_map = self.JointNamesMap()
        keys = joint_names_map.keys()
        
        for key in keys:
            self.RawData[joint_names_map[key]] = []

        with open(file_name, 'r') as file:
            raw_file_reader = csv.DictReader(file, delimiter=',')
            for row in raw_file_reader:
                self.Time.append(datetime.fromtimestamp(float(row['field.header.stamp'])/1000000000))
                for key in keys:
                    self.RawData[joint_names_map[key]].append(float(row[key]))

        self.CalibTimeseries()
        self.SavgolFilter()


    def CalibTimeseries(self):
        """Calibrate the timeseries using computed gain and offset parameters"""

        self.CalibratedData = {}

        if not self.GainOffsetDict:
            raise ValueError('Gain-Offset dictionary not calibrated.')
            sys.exit(1)

        for joint in self.JointNamesMap().values():
            gain, offset = self.GainOffsetDict[joint]
            self.CalibratedData[joint] = [gain * (i - offset) for i in self.RawData[joint]]


    def SavgolFilter(self):
        """Smooth the timeseries data using Savitzky-Golay filter"""
        
        self.FilteredData= {}

        for joint in self.JointNamesMap().values():
            self.FilteredData[joint] = signal.savgol_filter(self.CalibratedData[joint], 151, 3)   


    def ToVelocities(self):
        """Calculate angular velocities"""
        
        self.Vel = {}
        times = self.Time

        for joint in self.JointNamesMap().values():
            ts_data = self.FilteredData[joint]
            self.Vel[joint] = [(ts_data[i + 1] - ts_data[i])/0.01 for i in range(len(ts_data) - 1)]
            #(times[i+1] - times[i]).total_seconds()  


def LinRegression(data, joint):

    Betas = np.zeros([5,5])
    R = np.zeros([5,5])

    if joint == 'PIJ':
        names = ['G_ThumbIJ', 'G_IndexPIJ', 'G_MiddlePIJ', 'G_RingPIJ', 'G_PinkiePIJ']
    elif joint == 'MPJ':
        names = ['G_ThumbMPJ', 'G_IndexMPJ', 'G_MiddleMPJ', 'G_RingMPJ', 'G_PinkieMPJ']

    for fin1 in names:
        for fin2 in names:
            lin_reg_res = stats.linregress(data[fin1], data[fin2])
            slope, r = lin_reg_res[0], lin_reg_res[2]
            Betas[names.index(fin1)][names.index(fin2)] = slope
            R[names.index(fin1)][names.index(fin2)] = r

    return Betas, R


def MultRegression(data,joint):

    MultReg = np.zeros([1,5])

    if joint == 'PIJ':
        names=['G_ThumbIJ', 'G_IndexPIJ', 'G_MiddlePIJ', 'G_RingPIJ', 'G_PinkiePIJ']
    elif joint == 'MPJ':
        names=['G_ThumbMPJ', 'G_IndexMPJ', 'G_MiddleMPJ', 'G_RingMPJ', 'G_PinkieMPJ']
    
    for name1 in names:
        other_names = [name2 for name2 in names if name2!= name1]
        explanatory_series = [data[name] for name in other_names]
        
        X,Y =  np.array(explanatory_series).transpose(), np.array(data[name1])
        lin_reg = LinearRegression().fit(X,Y)
        MultReg[0, names.index(name1)] = lin_reg.score(X,Y)
        
    return MultReg


def kinPCA(data, joint, scale=0):

    if joint == 'PIJ':
        names=['G_ThumbIJ', 'G_IndexPIJ', 'G_MiddlePIJ', 'G_RingPIJ', 'G_PinkiePIJ']
    elif joint == 'MPJ':
        names=['G_ThumbMPJ', 'G_IndexMPJ', 'G_MiddleMPJ', 'G_RingMPJ', 'G_PinkieMPJ']
    elif joint == 'all':
        names=['G_ThumbIJ', 'G_IndexPIJ', 'G_MiddlePIJ', 'G_RingPIJ', 'G_PinkiePIJ', 'G_ThumbMPJ', 'G_IndexMPJ',
               'G_MiddleMPJ', 'G_RingMPJ', 'G_PinkieMPJ']

    series = np.array([data[fin] for fin in names]).transpose()

    if scale == 1:
        series = StandardScaler().fit_transform(series)
    pca = PCA(n_components=len(names))
    pca.fit(series)

    return(np.cumsum(pca.explained_variance_ratio_), pca.components_)
    
def kinMats(var, joint):

    r = pd.DataFrame.from_dict(var)
    r = r.reset_index()

    if joint == 'PIJ':
        columnsTitles = ['index', 'G_ThumbPIJ', 'G_IndexPIJ', 'G_MiddlePIJ', 'G_RingPIJ', 'G_PinkiePIJ']
    elif joint == 'MPJ':
        columnsTitles = ['index', 'G_ThumbMPJ', 'G_IndexMPJ', 'G_MiddleMPJ', 'G_RingMPJ', 'G_PinkieMPJ']

    r = r.reindex(columns=columnsTitles)
    r = r.reindex([4,0,1,3,2])
    r = r.reset_index(drop=True)
    
    return r

