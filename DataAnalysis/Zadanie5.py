import numpy as np
import matplotlib.pyplot as plt
from datetime import datetime
import math

def read_sensor_txt(path, sep=";"):
    t_iso = np.genfromtxt(path, delimiter=sep, skip_header=1, usecols=0, dtype=str)[::-1]
    data = np.genfromtxt(path, delimiter=sep, skip_header=1, usecols=(1,2,3), dtype=float)

    x = data[:, 0]
    y = data[:, 1]
    z = data[:, 2]

    return t_iso, x, y, z

def iso_to_seconds(t_iso):
        dt = np.array([datetime.fromisoformat(str(s)) for s in t_iso])
        t0 = dt[0]
        t_sec = np.array([(d-t0).total_seconds() for d in dt], dtype=float)
        return t_sec

def derivative(t,a):
    x = []
    for i in range(0,len(t)-1):
        val = (a[i+1]-a[i])/(t[i+1]-t[i])
        x.append(val)
    
    return x

def draw_plot(t,a,header):
    myVals = derivative(t,a)
    pythonVals = np.gradient(a,t)
    plt.plot(t, a, label=header)
    plt.plot(t[:-1], myVals, label='moja pochodna')
    plt.plot(t, pythonVals, label='pochodna z biblioteki')

    plt.title(header)
    plt.xlabel("Time")
    plt.ylabel("Value")

    plt.legend()
    plt.grid(True, linestyle='--', alpha=0.6)
    plt.show()
   
t, x, y, z = read_sensor_txt("magnetometer.txt")
t = iso_to_seconds(t)
draw_plot(t,x, "Oś X")
draw_plot(t,y, "Oś Y")
draw_plot(t,z, "Oś Z")