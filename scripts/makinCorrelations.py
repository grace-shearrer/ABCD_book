# -*- coding: utf-8 -*-
"""
Created on Mon Jul 30 17:09:15 2018
script to get ABCD data going
@author: nibl
"""
import subprocess
import glob
import os
#import pdb
import shutil

def cor_maker(basedir, workdir, biglist, power, powertxt):
    for item in biglist:
        x=item.split('/')[4].split('_')[0]
        print(x)
        #check for the folder 
        folder = 'sub-%s'%(x)
        output = os.path.join(workdir, folder, 'derivative')
        keep = os.path.join(workdir, folder, 'keep')
        intermed = os.path.join(workdir,folder,'ses-baselineYear1Arm1')
        if os.path.exists(os.path.join(keep)):
            print('FOLDER EXISTS')

        else:
            matching = [s for s in biglist if x in s]
            print(matching)
            for item in matching:
                zippi = 'tar -xzvf %s -C %s'%(item,workdir)
                print(zippi)
                call=subprocess.Popen(zippi, shell = True)
                call.wait()
            if os.path.exists(output) == False:
                os.makedirs(output)
            #do the fancy stuff    
            inputpath = glob.glob(os.path.join(intermed,'func','*.nii'))
            for img in inputpath:
                if os.path.exists(os.path.join(intermed,'anat')):
                    print('found a T1!')
                    t1=glob.glob(os.path.join(intermed,'anat','*.nii'))
                    print(t1)
                    restcall = 'python /Users/nibl/Desktop/ABCD/scripts/bin/resting_pipeline2.py --func=%s --t1=%s --steps="3,4,7"  --outpath=%s --corrlabel=%s  --corrtext=%s --cleanup'%(img,t1[0],output, power, powertxt)
                    print(restcall)
                    runrest = subprocess.Popen(restcall, shell = True)
                    runrest.wait()
                else:
                    print('NO T1!')
                    restcall = 'python /Users/nibl/Desktop/ABCD/scripts/bin/resting_pipeline2.py --func=%s --steps="3,4,7"  --outpath=%s --corrlabel=%s  --corrtext=%s --cleanup'%(img,output, power, powertxt)
                    print(restcall)
                    runrest = subprocess.Popen(restcall, shell = True)
                    runrest.wait()
#            pdb.set_trace()
            #move the things you need    
            if os.path.exists(keep) == False:
                print(keep)
                os.makedirs(keep)
#            pdb.set_trace()
            for thing in glob.glob(os.path.join(output, '*')):
                if thing.endswith("r_matrix.nii.gz"):
                    print(thing)
                    print("moving")                    
                    shutil.move(thing, keep)
                elif thing.endswith(".txt"):
                    print(thing)
                    print("moving")
                    shutil.move(thing, keep)
                elif thing.endswith(".csv"):
                    print(thing)
                    print("moving")
                    shutil.move(thing, keep)
            #delete what you don't need
            shutil.rmtree(output)
            shutil.rmtree(intermed)
#            pdb.set_trace()
#        pdb.set_trace()

def main():
    basedir = '/Volumes/ABCDrive1/submission_14921'   
    workdir = '/Volumes/mac_X/ABCDworking'
    biglist=glob.glob(os.path.join(basedir,'*.tgz'))
    biglist = biglist[5000:8000]
    power='/Users/nibl/Desktop/ABCD/scripts/data/pp264_all_ROIs_combined_61x73x61_3mm.nii'
    powertxt='/Users/nibl/Desktop/ABCD/scripts/data/PP264_template.txt'
    cor_maker(basedir, workdir, biglist, power, powertxt)
main()