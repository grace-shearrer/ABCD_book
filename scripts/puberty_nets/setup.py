from setuptools import setup

setup(name='puberty_nets',
      version='0.1',
      description='Trying to make a module for easy import between RENCI and local',
      url='https://github.com/grace-shearrer/ABCD_book/tree/working',
      author='grace-shearrer',
      author_email='grace.shearrer@gmail.com',
      license='MIT',
      packages=['puberty_nets'],
      install_requires=[
      'glob',
      'os',
      'networkx',
      'numpy',
      'pandas',
      'python-louvain',
      'sklearn',
      'pickle',
      'pdb',
      'statistics',
      'matplotlib',
      'visbrain',
      'bct',
      'nda_aws_token_generator',
      'awsdownload',
      'argparse',
      'glob',
      'subprocess',
      'shutil'
      ]
      zip_safe=False)
