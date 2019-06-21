import glob
import os
import networkx as nx
import numpy as np
import pandas as pd
import community
from sklearn.metrics.cluster import normalized_mutual_info_score
import bz2
import pickle
import pdb
import statistics
import matplotlib
matplotlib.use("Qt5Agg")
import matplotlib.pyplot as plt

from visbrain.objects import ConnectObj, SceneObj, SourceObj, BrainObj
from visbrain.io import download_file

import bct

def removekey(d, key):
    r = dict(d)
    del r[key]
    return r

def create_corr_network_5(G, corr_direction, min_correlation):
    ##Creates a copy of the graph
    H = G.copy()

    ##Checks all the edges and removes some based on corr_direction
    for stock1, stock2, weight in list(G.edges(data=True)):
        ##if we only want to see the positive correlations we then delete the edges with weight smaller than 0
        if corr_direction == "positive":
            ####it adds a minimum value for correlation.
            ####If correlation weaker than the min, then it deletes the edge
            if weight["weight"] <0 or weight["weight"] < min_correlation:
                H.remove_edge(stock1, stock2)
        ##this part runs if the corr_direction is negative and removes edges with weights equal or largen than 0
        else:
            ####it adds a minimum value for correlation.
            ####If correlation weaker than the min, then it deletes the edge
            if weight["weight"] >=0 or weight["weight"] > min_correlation:
                H.remove_edge(stock1, stock2)
    return(H)


def make_graphs(list_o_data, direction, min_cor):
    edge_dict={}
    FC_dict={}
    graph_dict={}

    print(len(list(list_o_data.keys())))
    j=0
    mylist=[]
    mu_network={}
    bad={}
    for key, val_list in list_o_data.items():
        print("on number %s"%(str(j)))
        j=j+1
        newlist=[]
        for item in val_list:

            print(np.array(item).diagonal())
            if np.all(np.array(item).diagonal()) == True:
                newlist.append(np.array(item))
                i=item.set_index(labels.ID)
                i.rename(columns=labels.ID, inplace=True)
                edge_dict.setdefault(key, []).append(i)

            else:
                print("%s is fucked"%key)
                bad.setdefault(key, []).append(item)


        try:
            y=np.dstack(newlist)
            print(y.shape)
            y=np.rollaxis(y,-1)
            print(y.shape)
            mu=np.mean(y, axis=0)
            print(np.array(mu).diagonal())
            mu_network.setdefault(key, mu)

            m=x.mean()
            FC_dict.setdefault(key, []).append(m)

            G = nx.from_numpy_matrix(mu)
            for i, nlrow in labels.iterrows():
                G.node[i].update(nlrow[0:].to_dict())

            graph_dict.setdefault(key, []).append(G)

            partition = community.best_partition(create_corr_network_5(G, direction,min_cor))

            graph_dict.setdefault(key, []).append(partition)
        except ValueError:
            continue
    return({'edges':edge_dict, 'mean_FC':FC_dict, 'graphs':graph_dict, 'mu':mu_network})


def merge_two_dicts(x, y):
    z = x.copy()   # start with x's keys and values
    z.update(y)    # modifies z with y's keys and values & returns None
    return z

def participation_award(cor_mats, parts):
#     cor_mats need to be something like a dictionary of correlation matrices with the subject as the key
#     parts need to be the numerical modularity values
    allPC={}
    for keys, values in cor_mats.items():
        print(keys)
        cor_mat = np.array(values)
        test_array=np.array(list(list(z['graphs'][keys])[1].values()))
        testPART=np.vstack(test_array)

        PC=bct.participation_coef(W=cor_mat, ci= testPART)
        allPC[keys]=PC

    return(allPC)

def cluster_fuq(cor_mats):
    clusters={}
    for keys, values in cor_mats.items():
        CC=bct.clustering_coef_wd(values)
        clusters[keys]=CC
    return(clusters)
