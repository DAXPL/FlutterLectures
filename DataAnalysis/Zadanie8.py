import numpy as np
import matplotlib.pyplot as plt
from datetime import datetime
import math
from scipy.signal import find_peaks

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

def zadanie(t, vals):
    L = 2
    G = 9.81
    Tteor = 2*math.pi*math.sqrt(L/G)
    T = 0

    peaks_indices, properties = find_peaks(vals, distance=2)
    
    for i in range(1,len(peaks_indices)):
        T += t[peaks_indices[i]]-t[peaks_indices[i-1]]
    T /= len(peaks_indices)-1
    epsilon = (abs(T-Tteor)/Tteor)*100

    print(f"Średni czas drgań {T:.2f}s")
    print(f"Teoretyczny czas drgań:{Tteor:.2f}, epsilon: {epsilon:.2f}%")

    plt.plot(t, vals)
    plt.plot(t[peaks_indices], vals[peaks_indices], "rx")
    plt.show()

t, x, y, z = read_sensor_txt("accel.txt")
t = iso_to_seconds(t)
zadanie(t,x)
