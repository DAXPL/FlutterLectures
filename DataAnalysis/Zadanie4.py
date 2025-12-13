import numpy as np
import matplotlib.pyplot as plt
from datetime import datetime
import statistics
from matplotlib.widgets import SpanSelector
import math
from scipy.signal import find_peaks
from scipy.signal import savgol_filter

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

def calc_fall(timeStart, timeEnd):
    print(f"Zakres: {timeStart:.2f} s - {timeEnd:.2f} s")
    time = float(timeEnd) - float(timeStart)
    g = 9.81
    h = (g/2)*(time*time)
    print(f"Wysokość upadku: {h:.2f}[m]")
t, x, y, z = read_sensor_txt("uaccel_upadek_sala")
t = iso_to_seconds(t)

a = []
for i in range(0,len(x)):
    a.append(math.sqrt((x[i]*x[i]) + (y[i]*y[i]) + (z[i]*z[i])))
smoothA = savgol_filter(a, 5, 4)#dane eksperymentalne. 4 stopień powinien dobrze dopasować się do oryginalnego wykresu, delikatnie go odszumiając
a = np.array(a)

gradient = np.gradient(smoothA,t)
#stdev = statistics.stdev(gradient)

for i in range(0,len(gradient)):
    if gradient[i]>-2:#2m/s*s traktuję jako szum
         gradient[i] = 0
end_points, properties = find_peaks(-gradient, distance=2)

start_points = []
for i in range(0,len(gradient)-1):
     if(gradient[i] == 0 and gradient[i+1]<gradient[i]):
          start_points.append(i)

#Moje podejście jest nieidealne. Mimo odszumiania wykrywa dużo małych odbić po ok 20cm (zrzucałem kilkukrotnie z okolic 1 - 1,8 m)
for start in start_points:
    found_impact = False
    for impact in end_points:
        if impact > start:
            t_start = t[start]
            t_impact = t[impact]
            calc_fall(t_start, t_impact)
            found_impact = True
            break

fig, ax = plt.subplots(figsize=(10, 6))
ax.plot(t, a)
plt.plot(t[end_points], a[end_points], "rx")
plt.plot(t[start_points], a[start_points], "go")

def onselect(xmin, xmax):
    calc_fall(xmin,xmax)
span = SpanSelector(
    ax,
    onselect,
    'horizontal',
)

plt.show()