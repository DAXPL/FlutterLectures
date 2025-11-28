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

t, x, y, z = read_sensor_txt("magnetometer.txt")
t = iso_to_seconds(t)
kat_azymut = np.arctan2(y,x)
unwrap = np.unwrap(kat_azymut)
a = np.degrees(unwrap)

plt.plot(t, a)
plt.show()