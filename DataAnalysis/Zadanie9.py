import numpy as np
import matplotlib.pyplot as plt
from datetime import datetime
import math
from scipy.signal import find_peaks
from scipy.signal import savgol_filter
import statistics

def read_sensor_txt(path, sep=";"):
    t_iso = np.genfromtxt(path, delimiter=sep, skip_header=1, usecols=0, dtype=str)[::-1]
    data = np.genfromtxt(path, delimiter=sep, skip_header=1, usecols=(1,2,3,4,5,6), dtype=float)

    xa = data[:, 0]
    ya = data[:, 1]
    za = data[:, 2]
    xg = data[:, 3]
    yg = data[:, 4]
    zg = data[:, 5]

    return t_iso, xa, ya, za, xg, yg, zg

def iso_to_seconds(t_iso):
        dt = np.array([datetime.fromisoformat(str(s)) for s in t_iso])
        t0 = dt[0]
        t_sec = np.array([(d-t0).total_seconds() for d in dt], dtype=float)
        return t_sec

def rotation_movement(signal):
      maxVal = max(signal)
      RMS = np.sqrt(np.mean(np.square(signal)))
      return maxVal, RMS

def find_highest_peaks(peaks_indicies, signal, howMany):
    peaks_arr = np.array(peaks_indicies)
    signal_arr = np.array(signal)
    peak_values = signal_arr[peaks_arr]
    sorted_args = np.argsort(peak_values)
    top_args = sorted_args[-howMany:][::-1]
    return np.sort(peaks_arr[top_args]) 

t_iso, xa, ya, za, xg, yg, zg = read_sensor_txt("throw.txt")
t = iso_to_seconds(t_iso)

c = np.mean(np.diff(t))
g = 9.81 

acc = np.sqrt(xa**2 + ya**2 + za**2)
gyro = np.sqrt(xg**2 + yg**2 + zg**2)

stdev = statistics.stdev(acc[0:int(1/c)])
acc = savgol_filter(acc, 7, 3)

peaks_indices, properties = find_peaks(acc, height=9.81 + stdev * 3)

best_peaks = find_highest_peaks(peaks_indices, acc, 2)
t_start = best_peaks[0]
t_end = best_peaks[1]

t_start_lot = t_start
t_end_lot = t_end
free_fall_threshold = 6.0

for i in range(t_start, t_end):
    if acc[i] <= free_fall_threshold:
        t_start_lot = i
        break

for i in range(t_start_lot, t_end):
    if acc[i] >= free_fall_threshold:
        t_end_lot = i
        break

cut_gyro = gyro[t_start_lot:t_end_lot]
maxG, RMS = rotation_movement(cut_gyro)
fly_time = t[t_end_lot] - t[t_start_lot]

hmax = (g * (fly_time**2)) / 8
desc = f"Czas lotu: {fly_time:.3f} s\nWysokość rzutu: {hmax:.2f} m\nMax omega = {maxG:.2f}, RMS = {RMS:.2f}"

plt.figure(figsize=(12, 7))
plt.plot(t, acc, label='accel')
plt.plot(t, gyro, label='gyro', alpha=0.5)

plt.plot(t[t_start], acc[t_start], "rx", markersize=10, label="Wyrzut")
plt.plot(t[t_start_lot], acc[t_start_lot], "g>", markersize=10, label="Początek lotu")
plt.plot(t[t_end_lot], acc[t_end_lot], "g<", markersize=10, label="Koniec lotu")
plt.plot(t[t_end], acc[t_end], "rx", markersize=10, label="Uderzenie")

plt.axvspan(t[t_start_lot], t[t_end_lot], color='green', alpha=0.1)
plt.text(0, 0, desc, ha='left')

plt.title("Analiza rzutu")
plt.xlabel("Czas [s]")
plt.legend()
plt.show()