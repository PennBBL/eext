### This script creates a summary csv of the scans that have been acquired
### for Cobb's estrogen project
###
### Ellyn Butler
### December 22, 2020


import subprocess as sub
import os
import flywheel
import json
import shutil
import re
import time
import array
import numpy as np
import pandas as pd
from datetime import date

fw = flywheel.Client()

studyinfo = {"subjlabel":[], "seslabel":[], "datatype":[], "nifti":[]}
proj = fw.lookup("bbl/E-EXT_826854")

# Get all of the data types as keys
#for subj in proj.subjects():
#    for ses in subj.sessions():
#        for acq in ses.acquisitions():
#            if 'Measurement' in acq['files'][0]['classification'].keys():
#                filetype = acq['files'][0]['classification']['Measurement'][0]
#                if filetype not in studyinfo.keys():
#                    studyinfo[filetype] = []

for subj in proj.subjects():
    for ses in subj.sessions():
        for acq in ses.acquisitions():
            if len(acq["files"]) > 1:
                studyinfo["subjlabel"].append(subj.label)
                studyinfo["seslabel"].append(ses.label)
                studyinfo["nifti"].append(acq["files"][1]["name"])
                if "Measurement" in acq['files'][0]['classification'].keys():
                    studyinfo["datatype"].append(acq['files'][0]['classification']['Measurement'][0])
                else:
                    studyinfo["datatype"].append("NA")


# Create pandas dataframe
studyinfo2 = pd.DataFrame.from_dict(studyinfo)

filename = '/Users/butellyn/Documents/eext/data/eext_collected_' + date.today().strftime("%m-%d-%Y") + '.csv'
studyinfo2.to_csv(filename, index=False)
