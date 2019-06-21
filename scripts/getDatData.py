#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jun 21 15:13:02 2018

@author: gracer
"""

import os
import pandas as pd
import glob
from nda_aws_token_generator import *
import awsdownload
import subprocess
import argparse


def getDatData(colnames, basedir,arglist, password, downloaddir,checkdir):
    print(basedir)
    txtfile = os.path.join(basedir, 'fmriresults01use.csv')
    infile = pd.read_csv(txtfile, names=colnames)
    scans = infile.derived_files[10:15].tolist()
    print(len(scans))
    for item in scans:
        call = "python awsdownload.py %s -r %s -u %s -p %s"%(item, checkdir, arglist['WHO'],password)
        call = call.split(' ')
        print(call)
        subprocess.call(call)
    for filie in glob.glob(os.path.join(checkdir,'*.tgz')):
        print('unzipping')
        print(filie)
        unzip = "tar -xvzf %s -C %s"%(filie,downloaddir)
#        unzip = unzip.split(' ')
        print('unzipping')
        subprocess.call(unzip, shell = True)
            
def Main():
    password = input("enter password: ")
    password  = str(password)
    colnames = ['src_subject_id	gender','img03_id	file_source','derived_files','scan_type',	'session_det']
    basedir = '/Users/gracer/Google Drive/ABCD/important_txt/'
    downloaddir ='/Users/gracer/Desktop/submission_14921'
    checkdir = '/Users/gracer/AWS_downloads/submission_14921'
    
    parser=argparse.ArgumentParser(description='Getting Data')
    parser.add_argument('-username',dest='WHO',
                        default=False, help='NDSR username')
    
    
    args = parser.parse_args()
    arglist={}
    for a in args._get_kwargs():
        arglist[a[0]]=a[1]
    print(arglist)
    
    #######################################
    getDatData(colnames, basedir, arglist, password, downloaddir,checkdir)
    #######################################
Main()
