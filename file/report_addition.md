# Addition to GA 2.3

**Task 11**

In task 3 you used three different measurement durations Tmeas of 1, 5 and 20 seconds, and analysed the DFT-result for a fc = 1 Hz sine signal. Now, repeat task 3, but for a fc = 2.5 Hz. Before you plot, figure out what the frequency step size $\Delta{f}$ in the DFT-result will be, with these three measurement durations, report these. Then compute and plot the DFT for these three cases, include them in your report, and comment on these results. Any ‘weird’ results?

**Task 12**

In tasks 4 and 5 you worked with a fc = 1 Hz sine, with added to that a 80 Hz sinusoid. The sampling frequency is fs = 100 Hz. Instead of the 80 Hz sinusoid, we now add a 60 Hz sinusoid. In task 5 four different sampling frequencies were used, 110 Hz, 150 Hz, 160 Hz and 200 Hz. Report, with these four sampling frequencies, the positive frequency at which the (first) alias of the 60 Hz sinusoid appears.

**Task 13**

In task 8 you constructed and plotted the periodogram (by coding it yourself). Python offers a built-in function. Use that function, and include your periodogram of task 8 and the new one with ‘periodogram’ both in your report. Comment on the difference(s).

To use periodogram, import the following:


`from scipy.signal import periodogram`

The call the built-in periodogram function looks like:

`freqs, Sxx = periodogram(YOUR_CODE_HERE, fs=YOUR_CODE_HERE, `

`window='boxcar', nfft=N, return_onesided=False, scaling='density')`
