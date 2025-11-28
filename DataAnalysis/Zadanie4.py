import numpy as np
import matplotlib.pyplot as plt
from datetime import datetime
import statistics
from matplotlib.widgets import SpanSelector
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

t, x, y, z = read_sensor_txt("uaccel.txt")
t = iso_to_seconds(t)
a = []
for i in range(0,len(x)):
    a.append(math.sqrt((x[i]*x[i]) + (y[i]*y[i]) + (z[i]*z[i])))

fig, ax = plt.subplots(figsize=(10, 6))
ax.plot(t, a)

def onselect(xmin, xmax):
    print(f"Zakres: {xmin:.2f} s - {xmax:.2f} s")
    time = float(xmax) - float(xmin)
    g = 9.81
    h = (g/2)*(time*time)
    print(f"Wysokość upadku: {h:.2f}[m]")
span = SpanSelector(
    ax,
    onselect,
    'horizontal',
)

plt.show()