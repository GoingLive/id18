# import sys
# sys.path.append('src/python')
# from slid import generate_slid
# print(generate_slid())

import os, sys
BASE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(BASE, 'src', 'python'))

from slid import generate_slid
print(generate_slid())