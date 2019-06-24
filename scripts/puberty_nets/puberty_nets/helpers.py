#helper functions
def removekey(d, key):
    r = dict(d)
    del r[key]
    return r

def ickle_me(data, name):
    pickle.dump(data, open('/Users/gracer/Google Drive/ABCD/ABCD_puberty/_data/%s'(%name), 'wb'), protocol=4)
    return('dickle me doc')

def dilly_of_a_pickle(path, name):
    with open(path, 'rb') as pickle_file:
    try:
        while True:
            name = pickle.load(pickle_file)
    except EOFError:
        pass
    return(name)
    
